local UICommonResItemBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemBase")
local UICommonResItemGold = BaseClass("UICommonResItemGold", UICommonResItemBase)
local base = UICommonResItemBase
local Localization = CS.GameEntry.Localization

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
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  base.DataDefine(self)
end

local function DataDestroy(self)
  base.DataDestroy(self)
end

local function OnReInit(self)
  self:SetFlagActive(false)
  self:SetItemIconImage(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold, true))
  self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE))
  self:SetNameText(Localization:GetString("100183"))
end

local function OnClick(self)
  local desc = DataCenter.RewardManager:GetDescByType(self.param.rewardType, self.param.itemId)
  local name = DataCenter.RewardManager:GetNameByType(self.param.rewardType, self.param.itemId)
  if string.IsNullOrEmpty(desc) and string.IsNullOrEmpty(name) then
    return
  end
  local param = {}
  param.rewardType = RewardType.GOLD
  param.itemName = name
  param.itemDesc = desc
  param.alignObject = self.item_icon
  param.isLocal = true
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

UICommonResItemGold.OnCreate = OnCreate
UICommonResItemGold.OnDestroy = OnDestroy
UICommonResItemGold.ComponentDefine = ComponentDefine
UICommonResItemGold.ComponentDestroy = ComponentDestroy
UICommonResItemGold.DataDefine = DataDefine
UICommonResItemGold.DataDestroy = DataDestroy
UICommonResItemGold.OnReInit = OnReInit
UICommonResItemGold.OnClick = OnClick
return UICommonResItemGold
