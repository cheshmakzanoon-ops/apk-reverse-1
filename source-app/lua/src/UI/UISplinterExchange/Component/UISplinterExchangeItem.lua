local base = UIBaseContainer
local UISplinterExchangeItem = BaseClass("UISplinterExchangeItem", base)
local TitleText_path = "TitleText"
local SelectImg_path = "SelectImg"
local ItemImg_path = "ItemBgImg/ItemImg"
local NoItemImg_path = "ItemBgImg/NoItemImg"
local IdTextBg_path = "IdTextBg"
local IdText_path = "IdText"
local NumText_path = "NumText"
local ClickBtn_path = "ClickBtn"
local own_num_text_path = "OwnNumText"
local id_with_bg_text_path = "IdTextBg/IdWithBgText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.TitleText = self:AddComponent(UITextMeshProUGUIEx, TitleText_path)
  self.SelectImg = self:AddComponent(UIBaseContainer, SelectImg_path)
  self.ItemImg = self:AddComponent(UIImage, ItemImg_path)
  self.NoItemImg = self:AddComponent(UIImage, NoItemImg_path)
  self.IdTextBg = self:AddComponent(UIBaseContainer, IdTextBg_path)
  self.IdText = self:AddComponent(UITextMeshProUGUIEx, IdText_path)
  self.id_with_bg_text = self:AddComponent(UITextMeshProUGUIEx, id_with_bg_text_path)
  self.NumText = self:AddComponent(UITextMeshProUGUIEx, NumText_path)
  self.ClickBtn = self:AddComponent(UIButton, ClickBtn_path)
  self.ClickBtn:SetOnClick(function()
    if self.clickCallback then
      self.clickCallback(self.clickIndex)
    end
  end)
  self.own_num_text = self:AddComponent(UITextMeshProUGUIEx, own_num_text_path)
end

local function ComponentDestroy(self)
  self.TitleText = nil
  self.SelectImg = nil
  self.ItemImg = nil
  self.NoItemImg = nil
  self.IdTextBg = nil
  self.IdText = nil
  self.id_with_bg_text = nil
  self.NumText = nil
  self.ClickBtn = nil
  self.own_num_text = nil
end

local function DataDefine(self)
  self.fragId = 0
  self.fragType = DispathTreasureExchangeItemType.None
  self.clickCallback = nil
  self.fragNum = 0
  self.clickIndex = 0
end

local function DataDestroy(self)
  self.fragId = nil
  self.fragType = nil
  self.fragNum = nil
  self.clickCallback = nil
  self.clickIndex = nil
end

local function SetData(self, fragId, fragType, idTextStr)
  self.fragType = fragType
  self.TitleText:SetActive(false)
  self.NoItemImg:SetActive(true)
  self.IdTextBg:SetActive(false)
  self.id_with_bg_text:SetActive(false)
  self.IdText:SetActive(false)
  self.NumText:SetActive(false)
  self:SetFragId(fragId, idTextStr)
  self:SetSelect(false)
end

local function SetClickCallback(self, clickCallback, clickIndex)
  self.clickCallback = clickCallback
  self.clickIndex = clickIndex
end

local function SetSelect(self, isSelect)
  if self.fragType == DispathTreasureExchangeItemType.Top or self.fragType == DispathTreasureExchangeItemType.Down then
    self.SelectImg:SetActive(isSelect)
  end
end

local function SetFragId(self, fragId, idTextStr)
  self.fragId = fragId
  if string.IsNullOrEmpty(idTextStr) then
    self.IdText:SetActive(false)
    self.id_with_bg_text:SetActive(false)
  else
    self.IdText:SetActive(true)
    self.IdText:SetText(idTextStr)
    self.id_with_bg_text:SetActive(true)
    self.id_with_bg_text:SetText(idTextStr)
  end
  if fragId == nil or fragId == 0 then
    self.ItemImg:SetActive(false)
    self.NoItemImg:SetActive(true)
    self.NumText:SetText("0")
  else
    local itemData = DataCenter.ItemData:GetItemByItemId(tonumber(fragId))
    self.ItemImg:LoadSprite(DataCenter.ItemTemplateManager:GetIconPath(fragId))
    self.ItemImg:SetActive(true)
    self.fragNum = itemData and itemData.count or 0
    self.NoItemImg:SetActive(self.fragNum == 0)
    self.NumText:SetText(self.fragNum)
  end
  local loseFragNum = DataCenter.ItemData:GetItemCount(fragId)
  self.own_num_text:SetLocalText("Treasure_map_33", loseFragNum)
  self.own_num_text:SetActive(true)
end

local function HaveFrag(self)
  return self.fragNum > 0
end

local function SetTitleText(self, dialogId)
  self.TitleText:SetActive(true)
  self.TitleText:SetLocalText(dialogId)
end

local function SetNumText(self, num)
  self.fragNum = num
  self.NumText:SetActive(true)
  self.NumText:SetText(num)
end

local function PlayNoItemImgAnim(self, isPlay)
  if isPlay then
    self.NoItemImg:SetActive(true)
    self.NoItemImg:SetAlpha(1)
    self.NoItemImg:DOFade(0, 1):SetLoops(-1, CS.DG.Tweening.LoopType.Yoyo):SetEase(CS.DG.Tweening.Ease.Linear)
  else
    self.NoItemImg.transform:DOKill()
  end
end

local function HideNoItemImg(self)
  self.NoItemImg:SetActive(false)
end

local function ShowIdTextBg(self)
  self.IdTextBg:SetActive(true)
  self.own_num_text:SetActive(false)
  self.IdText:SetActive(false)
end

local function HideOwnNumText(self)
  self.own_num_text:SetActive(false)
end

UISplinterExchangeItem.OnCreate = OnCreate
UISplinterExchangeItem.OnDestroy = OnDestroy
UISplinterExchangeItem.OnEnable = OnEnable
UISplinterExchangeItem.OnDisable = OnDisable
UISplinterExchangeItem.ComponentDefine = ComponentDefine
UISplinterExchangeItem.ComponentDestroy = ComponentDestroy
UISplinterExchangeItem.DataDefine = DataDefine
UISplinterExchangeItem.DataDestroy = DataDestroy
UISplinterExchangeItem.SetData = SetData
UISplinterExchangeItem.SetClickCallback = SetClickCallback
UISplinterExchangeItem.SetSelect = SetSelect
UISplinterExchangeItem.SetFragId = SetFragId
UISplinterExchangeItem.HaveFrag = HaveFrag
UISplinterExchangeItem.SetTitleText = SetTitleText
UISplinterExchangeItem.PlayNoItemImgAnim = PlayNoItemImgAnim
UISplinterExchangeItem.HideNoItemImg = HideNoItemImg
UISplinterExchangeItem.ShowIdTextBg = ShowIdTextBg
UISplinterExchangeItem.SetNumText = SetNumText
UISplinterExchangeItem.HideOwnNumText = HideOwnNumText
return UISplinterExchangeItem
