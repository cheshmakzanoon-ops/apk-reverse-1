local base = require("UI.UILWTacticalWeapon.Component.SkillChipPage.SkillChipCommonItem")
local SkillChipItem = BaseClass("SkillChipItem", base)
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")
local empty_container_path = "skillChipCommon/EmptyContainer"
local empty_bg_path = "skillChipCommon/EmptyContainer/EmptyBg"

local function OnCreate(self)
  base.OnCreate(self)
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  base.ComponentDefine(self)
  self.emptyContainer = self:AddComponent(UIBaseContainer, empty_container_path)
  self.emptyBg = self:AddComponent(UIImage, empty_bg_path)
end

local function ComponentDestroy(self)
  base.ComponentDestroy(self)
  self.emptyContainer = nil
  self.emptyBg = nil
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
  self.emptyContainer:SetActive(false)
  self.contentContainer:SetActive(true)
  base.SetData(self, chipInfo)
end

local function SetSlot(self, index)
  base.ClearChipInfo(self)
  self.index = index
  self.emptyContainer:SetActive(true)
  self.emptyBg:LoadSprite(string.format(LoadPath.TWSkillChipEmptyBgPath, index))
  self.contentContainer:SetActive(false)
  base.ClearStars(self)
end

local function SetTemplate(self, chipId, level, star)
  base.SetTemplate(self, chipId, level, star)
  self.emptyContainer:SetActive(false)
  self.contentContainer:SetActive(true)
end

local function SetLevelTextStr(self, str)
  self.levelText:SetText(str)
end

SkillChipItem.OnCreate = OnCreate
SkillChipItem.OnDestroy = OnDestroy
SkillChipItem.ComponentDefine = ComponentDefine
SkillChipItem.ComponentDestroy = ComponentDestroy
SkillChipItem.DataDefine = DataDefine
SkillChipItem.DataDestroy = DataDestroy
SkillChipItem.OnEnable = OnEnable
SkillChipItem.OnDisable = OnDisable
SkillChipItem.SetData = SetData
SkillChipItem.SetSlot = SetSlot
SkillChipItem.SetTemplate = SetTemplate
SkillChipItem.SetLevelTextStr = SetLevelTextStr
return SkillChipItem
