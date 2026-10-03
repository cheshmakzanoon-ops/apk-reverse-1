local UICommonResItemBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemBase")
local UICommonResItemResourceItem = BaseClass("UICommonResItemResourceItem", UICommonResItemBase)
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
  self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(tonumber(self.param.rewardType), tonumber(self.param.itemId)))
  self:SetItemQualityImage(DataCenter.RewardManager:GetRewardQualityBg(tonumber(self.param.rewardType), tonumber(self.param.itemId)))
  self:SetNameText(DataCenter.RewardManager:GetNameByType(tonumber(self.param.rewardType), tonumber(self.param.itemId)))
end

local function OnClick(self)
  local desc = ""
  local name = ""
  if string.IsNullOrEmpty(self.param.itemName) then
    desc = DataCenter.RewardManager:GetDescByType(self.param.rewardType, self.param.itemId)
    name = DataCenter.RewardManager:GetNameByType(self.param.rewardType, self.param.itemId)
  elseif self.param.isLocal then
    desc = self.param.itemDesc
    name = self.param.itemName
  else
    desc = CS.GameEntry.Localization:GetString(self.param.itemDesc)
    name = CS.GameEntry.Localization:GetString(self.param.itemName)
  end
  if string.IsNullOrEmpty(desc) and string.IsNullOrEmpty(name) then
    return
  end
  if self.fetchMummyDesc then
    if self.theSoldierType == SoldierType.Player then
      name = Localization:GetString("season_s3_Mummy_ui_info03")
    elseif self.theSoldierType == SoldierType.Mummy then
      name = Localization:GetString("season_s3_soilder_Mummy")
    end
  end
  local param = {}
  param.rewardType = RewardType.RESOURCE_ITEM
  param.itemId = self.param.itemId
  param.itemName = name
  param.itemDesc = desc
  param.alignObject = self.item_icon
  if self.fetchMummyDesc then
    param.fetchMummyDesc = true
    param.theSoldierType = self.theSoldierType
    param.hasCount = self.param.count or 0
  end
  param.isLocal = true
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

UICommonResItemResourceItem.OnCreate = OnCreate
UICommonResItemResourceItem.OnDestroy = OnDestroy
UICommonResItemResourceItem.ComponentDefine = ComponentDefine
UICommonResItemResourceItem.ComponentDestroy = ComponentDestroy
UICommonResItemResourceItem.DataDefine = DataDefine
UICommonResItemResourceItem.DataDestroy = DataDestroy
UICommonResItemResourceItem.OnReInit = OnReInit
UICommonResItemResourceItem.OnClick = OnClick
return UICommonResItemResourceItem
