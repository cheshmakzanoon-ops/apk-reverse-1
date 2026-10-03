local base = UIBaseContainer
local LWUIGiftItemView = BaseClass("LWUIGiftItemView", base)
local GiftIconShowContent = require("UI/LWPlayerInfo/UILWGiftSystem/Common/GiftIconShowContent")
local Localization = CS.GameEntry.Localization
local qualityImg_path = "Corner"
local giftIconImg_path = "Icon"
local giftNumTxt_path = "Num"
local giftNameTxt_path = "Name"
local addCharmTxt_path = "AddCharm"
local selectGo_path = "SelectGo"
local selectBtn_path = "SelectBtn"
local blackMask_path = "BlackMask"
local detailBtn_path = "DetailBtn"
local recycleGo_path = "RecycleGo"
local eff_ui_gift_special_select_path = "SelectGo/Eff_ui_Gift_special_select"
local select_go_img_path = "SelectGo/SelectGoImg"
local gift_icon_show_content_path = "GiftIconShowContent"
local effect_content_path = "effectContent"
local act_tip_btn_path = "actTipBtn"
local act_tip_eff_path = "actTipBtn/actTipEff"
local iconNormalH = 57

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.qualityImg = self:AddComponent(UIImage, qualityImg_path)
  self.giftIconImg = self:AddComponent(UIImage, giftIconImg_path)
  self.giftNumTxt = self:AddComponent(UIText, giftNumTxt_path)
  self.giftNameTxt = self:AddComponent(UIText, giftNameTxt_path)
  self.addCharmTxt = self:AddComponent(UIText, addCharmTxt_path)
  self.selectGo = self:AddComponent(UIBaseContainer, selectGo_path)
  self.selectBtn = self:AddComponent(UIButton, selectBtn_path)
  self.blackMask = self:AddComponent(UIBaseContainer, blackMask_path)
  self.detailBtn = self:AddComponent(UIButton, detailBtn_path)
  self.recycleGo = self:AddComponent(UIBaseContainer, recycleGo_path)
  self.selectBtn:SetOnClick(function()
    if type(self.selectFunc) == "function" then
      self.selectFunc(self.template)
    end
  end)
  self.detailBtn:SetOnClick(function()
    self:OnDetailBtnClick()
  end)
  self.eff_ui_gift_special_select = self:AddComponent(UIImage, eff_ui_gift_special_select_path)
  self.select_go_img = self:AddComponent(UIImage, select_go_img_path)
  self.gift_icon_show_content = self:AddComponent(GiftIconShowContent, gift_icon_show_content_path)
  self.effect_content = self:AddComponent(UIVfx, effect_content_path)
  self.act_tip_btn = self:AddComponent(UIButton, act_tip_btn_path)
  self.act_tip_eff = self:AddComponent(UIVfx, act_tip_eff_path, VfxAssets.GiftActEffect, {
    lifeType = UIVfxLifeType.Stay
  })
  self.act_tip_btn:SetOnClick(function()
    self:OnTipBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.qualityImg = nil
  self.giftIconImg = nil
  self.giftNumTxt = nil
  self.giftNameTxt = nil
  self.addCharmTxt = nil
  self.selectGo = nil
  self.selectBtn = nil
  self.blackMask = nil
  self.detailBtn = nil
  self.recycleGo = nil
  self.eff_ui_gift_special_select = nil
  self.select_go_img = nil
  self.gift_icon_show_content = nil
  self.effect_content:Remove()
  self.effect_content = nil
  self.act_tip_btn = nil
  self.act_tip_eff:Remove()
  self.act_tip_eff = nil
end

local function DataDefine(self)
  self.template = nil
  self.allDataList = nil
  self.allDataIndex = nil
end

local function DataDestroy(self)
  self.template = nil
  self.allDataList = nil
  self.allDataIndex = nil
end

function LWUIGiftItemView:SetData(data, allDataList, allDataIndex)
  self.template = data
  self.allDataList = allDataList
  self.allDataIndex = allDataIndex
  local quality, num, goods
  if self.template.isLockGift then
    goods = self.template.temp
    local itemTemp = DataCenter.ItemTemplateManager:GetItemTemplate(goods.id)
    quality = itemTemp.color
    num = 0
    self.blackMask:SetActive(true)
    self.addCharmTxt:SetActive(false)
  else
    quality = self.template.color
    num = DataCenter.GiftSystemManager:GetGiftNum(data.id)
    goods = DataCenter.GiftSystemManager:GetGiftGoods(data.id)
    self.blackMask:SetActive(false)
    self.addCharmTxt:SetActive(true)
  end
  self.qualityImg:LoadSprite(GiftSystemConst.GetGiftDetailQualityIcon(quality))
  local hOffset, minScale, midScale, maxScale = DataCenter.GiftSystemManager.GetGiftIconParam(goods)
  local hOffset = iconNormalH
  local changeH = tonumber(goods.spine_param2) or 0
  if 0 < #goods.show_fx then
    self.giftIconImg:SetActive(false)
    self.gift_icon_show_content:SetActive(true)
    self.gift_icon_show_content:SetShowData(goods.id, 1)
    self.gift_icon_show_content:SetLocalScaleXYZ(midScale, midScale, midScale)
    self.gift_icon_show_content:SetAnchoredPositionXY(0, hOffset + changeH)
  else
    self.giftIconImg:SetActive(true)
    self.gift_icon_show_content:SetActive(false)
    self.giftIconImg:LoadSpriteAsyncWithCallback(GiftSystemConst.GetIconPathNew(goods.icon_big), function()
      if self.giftIconImg then
        self.giftIconImg:SetNativeSize()
      end
    end)
    self.giftIconImg:SetLocalScaleXYZ(midScale, midScale, midScale)
    self.giftIconImg:SetAnchoredPositionXY(0, hOffset + changeH)
  end
  self.giftNameTxt:SetLocalText(self.template.name)
  self.giftNumTxt:SetText("x" .. string.GetFormattedStr(num))
  self.addCharmTxt:SetText("+" .. goods.add_exp)
  self.selectGo:SetActive(false)
  self.giftNumTxt:SetActive(num ~= 0)
  self.detailBtn:SetActive(false)
  self.act_tip_btn:SetActive(false)
  if goods.ep_gift == 0 then
    self.select_go_img:SetActive(true)
    self.eff_ui_gift_special_select:SetActive(false)
  else
    self.select_go_img:SetActive(false)
    self.eff_ui_gift_special_select:SetActive(true)
  end
  local isShowEffect = false
  if self.template.isLockGift or goods.ep_gift == 0 then
    isShowEffect = false
  else
    isShowEffect = true
  end
  if isShowEffect then
  else
    self.effect_content:SetActive(false)
    self.effect_content:Remove()
  end
end

function LWUIGiftItemView:SetOnSelect(func)
  self.selectFunc = func
end

function LWUIGiftItemView:SetSelect(state)
  self.selectGo:SetActive(state)
end

function LWUIGiftItemView:SetShowType(windowType)
  self.windowType = windowType
  self.detailBtn:SetActive(windowType == GiftSystemConst.WindowType.Show and not self.template.isLockGift)
  local isActTipShow = false
  if not self.template.isLockGift then
    local goods = DataCenter.GiftSystemManager:GetGiftGoods(self.template.id)
    isActTipShow = windowType == GiftSystemConst.WindowType.Send and DataCenter.GiftSystemManager:CheckGiftOrderActPass(goods)
  end
  self.act_tip_btn:SetActive(isActTipShow)
  if isActTipShow then
    self.act_tip_eff:Replay()
  end
  local showExpired = DataCenter.ItemExchangeManager:IsShowWillExpired(tonumber(self.template.id))
  self.recycleGo:SetActive(windowType == GiftSystemConst.WindowType.Send and showExpired)
end

function LWUIGiftItemView:OnDetailBtnClick()
  if self.windowType ~= GiftSystemConst.WindowType.Show then
    return
  end
  if self.template == nil then
    return
  end
  if self.template.isLockGift then
    UIUtil.ShowTipsId("gift_detail_tips_1")
    return
  end
  if UIUtil.CheckGiftShowDetailInfoViewIsOpen() then
    local originIdList = {}
    local originIdIndex = 1
    for i, v in ipairs(self.allDataList) do
      local originId = DataCenter.GiftSystemManager:GetOriginId(v.id)
      if originId ~= nil then
        table.insert(originIdList, originId)
        if v.id == self.template.id then
          originIdIndex = #originIdList
        end
      end
    end
    UIUtil.OpenGiftShowDetailInfoView(LuaEntry.Player.uid, LuaEntry.Player:GetSourceServerId(), originIdList, originIdIndex)
  else
    local originId = DataCenter.GiftSystemManager:GetOriginId(self.template.id)
    if originId == nil then
      Logger.LogError("\230\137\190\228\184\141\229\136\176\231\164\188\231\137\169\229\142\159\229\167\139id " .. tostring(self.template.id))
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIGiftHistory, {anim = true}, {
      targetUid = LuaEntry.Player.uid,
      itemId = originId
    })
  end
end

function LWUIGiftItemView:OnTipBtnClick()
  local des_txt = Localization:GetString("activity_gift1")
  UIUtil.ShowBubbleTips(des_txt, self.act_tip_eff.transform.position, 0, 20, 0, nil, nil, {reversal = true})
end

LWUIGiftItemView.OnCreate = OnCreate
LWUIGiftItemView.OnDestroy = OnDestroy
LWUIGiftItemView.OnEnable = OnEnable
LWUIGiftItemView.OnDisable = OnDisable
LWUIGiftItemView.ComponentDefine = ComponentDefine
LWUIGiftItemView.ComponentDestroy = ComponentDestroy
LWUIGiftItemView.DataDefine = DataDefine
LWUIGiftItemView.DataDestroy = DataDestroy
return LWUIGiftItemView
