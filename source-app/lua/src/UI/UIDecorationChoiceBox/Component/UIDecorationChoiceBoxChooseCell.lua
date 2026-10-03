local UIDecorationChoiceBoxChooseCell = BaseClass("UIDecorationChoiceBoxChooseCell", UIBaseContainer)
local base = UIBaseContainer
local UnityRectTransform = typeof(CS.UnityEngine.RectTransform)
local b_g_path = "BG"
local icon_path = "BG/Icon"
local u_i_common_res_item_path = "BG/UICommonResItem"
local name_mask_path = "BG/InfoContent/NameMask"
local name_text_path = "BG/InfoContent/NameMask/NameText"
local cant_content_path = "BG/CantContent"
local be_select_path = "BG/beSelect"
local point_text_path = "BG/CantContent/PointBg/PointText"
local QUEST_ENTRY_WIDTH_LIMIT = 175
local QUEST_ENTRY_ROLLING_SPD = 60
local QUEST_ENTRY_ROLLING_DELAY = 2
local QUEST_ENTRY_ROLLING_HOLD = 3

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  if self.tweenSeq then
    self.tweenSeq:Kill()
  end
  self.tweenSeq = nil
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.b_g = self:AddComponent(UIButton, b_g_path)
  self.b_g_img = self:AddComponent(UIImage, b_g_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.u_i_common_res_item = self:AddComponent(UICommonResItem, u_i_common_res_item_path)
  self.name_mask = self:AddComponent(UIBaseContainer, name_mask_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.name_rectTransform = self.transform:Find(name_text_path):GetComponent(UnityRectTransform)
  self.cant_content = self:AddComponent(UIImage, cant_content_path)
  self.be_select = self:AddComponent(UIImage, be_select_path)
  self.point_text = self:AddComponent(UITextMeshProUGUIEx, point_text_path)
  self.b_g:SetOnClick(function()
    self:ClickBtn()
  end)
end

local function ComponentDestroy(self)
  self.b_g = nil
  self.b_g_img = nil
  self.icon = nil
  self.u_i_common_res_item = nil
  self.name_text = nil
  self.name_rectTransform = nil
  self.cant_content = nil
  self.be_select = nil
  self.point_text = nil
  self.name_mask = nil
end

local function DataDefine(self)
  self.showData = nil
  self.index = nil
  self.selectIndex = nil
  self.clickFunc = nil
end

local function DataDestroy(self)
  self.showData = nil
  self.index = nil
  self.selectIndex = nil
  self.clickFunc = nil
end

local function ReInit(self, showData, index, clickFunc)
  self.showData = showData
  self.index = index
  self.clickFunc = clickFunc
  self:RefreshView()
end

local function AdjustMaskText(self)
  if self.tweenSeq then
    self.tweenSeq:Kill()
  end
  self.tweenSeq = UIUtil.SetTMPHorseRaceLamp(self.name_text, QUEST_ENTRY_WIDTH_LIMIT, QUEST_ENTRY_ROLLING_DELAY, QUEST_ENTRY_ROLLING_SPD, QUEST_ENTRY_ROLLING_HOLD, self.name_rectTransform)
end

local function RefreshView(self)
  self.selectIndex = self.view.currentSelect
  if self.showData.itemTemp.type == GOODS_TYPE.GOODS_TYPE_113 then
    self.icon:SetActive(true)
    self.u_i_common_res_item:SetActive(false)
    self.cant_content:SetActive(not self.showData.isCanUse)
    local txtStrKey = "optional_chest_desc01"
    if self.showData.eternalType == GoodsType113DecorationEternalType.HaveGoods then
      txtStrKey = "building_center_desc23"
    end
    self.point_text:SetLocalText(txtStrKey)
    local bgPath = self:GetItemBg(self.showData.decoTemp.quality)
    self.b_g_img:LoadSprite(bgPath)
    self.icon:LoadSprite(self.showData.decoTemp.icon)
    if self.showData.decoTemp.type == DecorationType.DecorationType_TittleName or self.showData.decoTemp.type == DecorationType.DecorationType_Head_Frame then
      self.icon:SetLocalScaleXYZ(1, 1, 1)
    else
      self.icon:SetLocalScaleXYZ(1.3, 1.3, 1.3)
    end
    self.icon:SetNativeSize()
    self.name_text:SetText(self.showData.itemTemp:GetName())
  else
    self.icon:SetActive(false)
    self.u_i_common_res_item:SetActive(true)
    local isEmojiGoods = self.showData.itemTemp.type == GOODS_TYPE.GOODS_TYPE_149
    local showCant = isEmojiGoods and not self.showData.isCanUse or false
    self.cant_content:SetActive(showCant)
    if showCant then
      self.point_text:SetLocalText("optional_chest_desc01")
    end
    local bgPath = self:GetItemBg(self.showData.itemTemp.quality)
    self.b_g_img:LoadSprite(bgPath)
    local param1 = {
      rewardType = RewardType.GOODS,
      itemId = self.showData.itemId,
      count = self.showData.itemNum
    }
    self.u_i_common_res_item:ReInit(param1)
    self.name_text:SetText(self.showData.itemTemp:GetName())
  end
  self:AdjustMaskText()
  self.be_select:SetActive(self.index == self.selectIndex)
end

local function ClickBtn(self)
  if self.clickFunc then
    self.clickFunc(self.view, self.index)
  end
end

local function GetItemBg(self, quality)
  local imgPath = "Assets/Main/Sprites/UI/LWDecorationBook/lrb_zhuagnshiwugongfang_tujian_card_lan.png"
  if quality == 5 then
    imgPath = "Assets/Main/Sprites/UI/LWDecorationBook/Mjc_zhuagnshiwugongfang_tujian_card.png"
  elseif quality == 4 then
    imgPath = "Assets/Main/Sprites/UI/LWDecorationBook/lrb_zhuagnshiwugongfang_tujian_card_zi.png"
  elseif quality == 3 then
    imgPath = "Assets/Main/Sprites/UI/LWDecorationBook/lrb_zhuagnshiwugongfang_tujian_card_lan.png"
  end
  return imgPath
end

UIDecorationChoiceBoxChooseCell.OnCreate = OnCreate
UIDecorationChoiceBoxChooseCell.OnDestroy = OnDestroy
UIDecorationChoiceBoxChooseCell.ComponentDefine = ComponentDefine
UIDecorationChoiceBoxChooseCell.ComponentDestroy = ComponentDestroy
UIDecorationChoiceBoxChooseCell.DataDefine = DataDefine
UIDecorationChoiceBoxChooseCell.DataDestroy = DataDestroy
UIDecorationChoiceBoxChooseCell.ReInit = ReInit
UIDecorationChoiceBoxChooseCell.RefreshView = RefreshView
UIDecorationChoiceBoxChooseCell.AdjustMaskText = AdjustMaskText
UIDecorationChoiceBoxChooseCell.ClickBtn = ClickBtn
UIDecorationChoiceBoxChooseCell.GetItemBg = GetItemBg
return UIDecorationChoiceBoxChooseCell
