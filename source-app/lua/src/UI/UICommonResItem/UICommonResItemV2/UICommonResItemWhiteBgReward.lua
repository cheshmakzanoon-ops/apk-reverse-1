local UICommonResItemBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemBase")
local UICommonResItemWhiteBgReward = BaseClass("UICommonResItemWhiteBgReward", UICommonResItemBase)
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
  local rewardType = self.param.rewardType
  self.theIcon = nil
  self.theName = nil
  self.theDesc = nil
  self:SetFlagActive(false)
  self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.WHITE))
  if self.seasonType ~= nil and (rewardType == RewardType.FLINT or rewardType == RewardType.OBSIDIAN or rewardType == RewardType.AllianceCoal or rewardType == RewardType.AllianceStone) then
    local cfg = SeasonUtil.GetWorldSkinConfig(self.seasonType)
    if cfg then
      local detail
      if rewardType == RewardType.FLINT then
        detail = cfg.resource_13
      elseif rewardType == RewardType.OBSIDIAN then
        detail = cfg.resource_10
      elseif rewardType == RewardType.AllianceStone then
        detail = cfg.resource_alliance
      end
      if not string.IsNullOrEmpty(detail) then
        local theIcon, theName, theDesc = string.match(detail, "([^|]+)|([^|]+)|([^|]+)")
        if theIcon and theName and theDesc then
          self.theIcon = string.format(LoadPath.LWCommonPath, theIcon)
          self.theName = Localization:GetString(theName)
          self.theDesc = Localization:GetString(theDesc)
        end
      end
    end
  end
  if self.theName == nil or self.theIcon == nil then
    self.theIcon = DataCenter.RewardManager:GetPicByType(rewardType, nil, nil, true)
    self.theName = DataCenter.RewardManager:GetNameByType(rewardType)
  end
  self:SetItemIconImage(self.theIcon)
  self:SetNameText(self.theName)
end

UICommonResItemWhiteBgReward.OnCreate = OnCreate
UICommonResItemWhiteBgReward.OnDestroy = OnDestroy
UICommonResItemWhiteBgReward.ComponentDefine = ComponentDefine
UICommonResItemWhiteBgReward.ComponentDestroy = ComponentDestroy
UICommonResItemWhiteBgReward.DataDefine = DataDefine
UICommonResItemWhiteBgReward.DataDestroy = DataDestroy
UICommonResItemWhiteBgReward.OnReInit = OnReInit
return UICommonResItemWhiteBgReward
