local base = require("UI.UILWTacticalWeapon.Component.SkillChipPage.SkillChipItem")
local SkillChipPageItem = BaseClass("SkillChipPageItem", base)
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")
local upgrade_redPoint_path = "skillChipCommon/upgradeRedPoint"
local red_point_path = "skillChipCommon/RedPoint"

local function OnCreate(self)
  base.OnCreate(self)
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  base.ComponentDefine(self)
  self.upgradeRedPoint = self:AddComponent(UIImage, upgrade_redPoint_path)
  self.redPoint = self:AddComponent(UIImage, red_point_path)
  self.redPoint:SetActive(false)
end

local function ComponentDestroy(self)
  self.upgradeRedPoint = nil
  self.redPoint = nil
  base.ComponentDestroy(self)
end

local function DataDefine(self)
  base.DataDefine(self)
end

local function DataDestroy(self)
  base.DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function SetData(self, chipInfo, index)
  self.upgradeRedPoint:SetActive(false)
  self.redPoint:SetActive(false)
  base.SetData(self, chipInfo)
end

local function SetSlot(self, index)
  self.upgradeRedPoint:SetActive(false)
  self.redPoint:SetActive(false)
  base.SetSlot(self, index)
end

local function RefreshRedPoint(self, heroType)
  if not self.chipInfo then
    if self.index then
      local hasFreeChip = TacticalWeaponUtils.GetHighestPowerFreeChip(self.index, heroType)
      if hasFreeChip then
        self.redPoint:SetActive(true)
        self.upgradeRedPoint:SetActive(false)
      end
    else
      self.redPoint:SetActive(true)
      self.upgradeRedPoint:SetActive(false)
    end
    return
  end
  if TacticalWeaponUtils.SkillChipCanStarUp(self.chipInfo) then
    self.redPoint:SetActive(false)
    self.upgradeRedPoint:SetActive(true)
    return
  end
  if TacticalWeaponUtils.SkillChipCanReplace(self.chipInfo) then
    self.redPoint:SetActive(true)
    self.upgradeRedPoint:SetActive(false)
    return
  end
  if TacticalWeaponUtils.SkillChipCanLvUp(self.chipInfo) then
    self.redPoint:SetActive(true)
    self.upgradeRedPoint:SetActive(false)
    return
  end
end

local function SetTemplate(self, chipId, level, star)
  base.SetTemplate(self, chipId, level, star)
  self.redPoint:SetActive(false)
  self.upgradeRedPoint:SetActive(false)
end

local function GetBgPath(self, chipId)
  local quality = DataCenter.RewardManager:GetRewardQuality(RewardType.TWSkillChip, chipId) or 0
  return string.format(LoadPath.TWSkillChipQualityBgPath, quality)
end

SkillChipPageItem.OnCreate = OnCreate
SkillChipPageItem.OnDestroy = OnDestroy
SkillChipPageItem.ComponentDefine = ComponentDefine
SkillChipPageItem.ComponentDestroy = ComponentDestroy
SkillChipPageItem.DataDefine = DataDefine
SkillChipPageItem.DataDestroy = DataDestroy
SkillChipPageItem.OnEnable = OnEnable
SkillChipPageItem.OnDisable = OnDisable
SkillChipPageItem.SetData = SetData
SkillChipPageItem.SetSlot = SetSlot
SkillChipPageItem.RefreshRedPoint = RefreshRedPoint
SkillChipPageItem.SetTemplate = SetTemplate
SkillChipPageItem.GetBgPath = GetBgPath
return SkillChipPageItem
