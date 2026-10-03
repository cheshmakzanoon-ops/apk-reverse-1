local UISkyBattleRewardItem = BaseClass("UISkyBattleRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local this_path = "clickBtn"
local num_text_path = "clickBtn/NumText"
local item_quality_path = "clickBtn/ImgQuality"
local item_icon_path = "clickBtn/ItemIcon"
local item_bg_path = "clickBtn/item_bg"

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

local function ComponentDefine(self)
  self.item_bg = self:TryAddComponent(UIImage, item_bg_path)
  if self.item_bg then
    self.item_bg:SetActive(true)
  end
  self.canvasGroup = self:TryAddComponent(UICanvasGroup, this_path)
  self.num_text = self:TryAddComponent(UITextMeshProUGUIEx, num_text_path)
  if self.num_text then
    self.num_text:SetText("")
  end
  self.item_quality = self:TryAddComponent(UIImage, item_quality_path)
  if self.item_quality then
    self.item_quality:SetActive(false)
  end
  self.item_icon = self:TryAddComponent(UIImage, item_icon_path)
  self.btn = self:TryAddComponent(UIButton, this_path)
  if self.btn then
    self.btn:SetOnClick(function()
      self:OnBtnClick()
    end)
  end
end

local function ComponentDestroy(self)
  self.canvasGroup = nil
  self.num_text = nil
  self.item_quality = nil
  self.item_icon = nil
  self.btn = nil
  self.item_bg = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.param = nil
  self.itemCountActive = nil
  self.itemCount = nil
end

local function OnBtnClick(self)
  local desc = self.param.itemDesc
  local name = self.param.itemName
  if string.IsNullOrEmpty(desc) and string.IsNullOrEmpty(name) then
    return
  end
end

local function ReInit(self, param)
  self.param = param
  self:SetItemCountActive(param.count)
  self:SetItemCount(param.count)
  self:SetItemCountColor(WhiteColor)
  self:SetImgQuailtyShow(param.rewardType)
  self:SetItemIconImage(param.iconName)
  self:SetItemQualityImage(param.itemColor)
end

local function SetItemCountActive(self, value)
  local bool = value and true or false
  if self.num_text and self.itemCountActive ~= bool then
    self.itemCountActive = bool
    self.num_text.gameObject:SetActive(bool)
  end
end

local function SetItemCount(self, value)
  if value and self.itemCount ~= value and self.num_text then
    self.itemCount = value
    if type(value) == "number" then
      self.num_text:SetText(string.GetFormattedStr(value))
    else
      self.num_text:SetText(value)
    end
  end
end

local function SetItemCountColor(self, value)
  if self.num_text and value then
    self.num_text:SetColor(value)
  end
end

local function SetImgQuailtyShow(self, show)
  local bool = show and true or false
  if self.item_quality then
    self.item_quality:SetActive(bool)
  end
end

local function SetItemIconImage(self, imageName)
  if self.item_icon and imageName then
    self.item_icon:LoadSprite(imageName)
  end
end

local function SetItemQualityImage(self, imageName)
  if imageName then
    self.item_quality:LoadSprite(imageName)
  end
end

UISkyBattleRewardItem.OnCreate = OnCreate
UISkyBattleRewardItem.OnDestroy = OnDestroy
UISkyBattleRewardItem.ComponentDefine = ComponentDefine
UISkyBattleRewardItem.ComponentDestroy = ComponentDestroy
UISkyBattleRewardItem.DataDefine = DataDefine
UISkyBattleRewardItem.DataDestroy = DataDestroy
UISkyBattleRewardItem.OnBtnClick = OnBtnClick
UISkyBattleRewardItem.ReInit = ReInit
UISkyBattleRewardItem.SetItemCountActive = SetItemCountActive
UISkyBattleRewardItem.SetItemCount = SetItemCount
UISkyBattleRewardItem.SetItemCountColor = SetItemCountColor
UISkyBattleRewardItem.SetImgQuailtyShow = SetImgQuailtyShow
UISkyBattleRewardItem.SetItemIconImage = SetItemIconImage
UISkyBattleRewardItem.SetItemQualityImage = SetItemQualityImage
return UISkyBattleRewardItem
