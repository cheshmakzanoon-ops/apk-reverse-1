local base = require("UI.UILWTacticalWeapon.Component.SkillChipPage.SkillChipCommonItem")
local SkillChipBagItem = BaseClass("SkillChipBagItem", base)
local Localization = CS.GameEntry.Localization
local masterBg_path = "skillChipCommon/masterBg"
local master_txt_path = "skillChipCommon/masterBg/masterTxt"
local count_txt_path = "skillChipCommon/countTxt"

local function OnCreate(self)
  base.OnCreate(self)
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  base.ComponentDefine(self)
  self.masterBg = self:AddComponent(UIImage, masterBg_path)
  self.masterTxt = self:AddComponent(UIText, master_txt_path)
  self.countTxt = self:AddComponent(UIText, count_txt_path)
end

local function ComponentDestroy(self)
  base.ComponentDestroy(self)
  self.masterBg = nil
  self.masterTxt = nil
  self.countTxt = nil
end

local function DataDefine(self)
  base.DataDefine(self)
end

local function DataDestroy(self)
  base.DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function SetMaster(self, masterIndex)
  if not masterIndex or masterIndex <= 0 then
    self.masterBg:SetActive(false)
    return
  end
  self.masterBg:SetActive(true)
  self.masterTxt:SetText(masterIndex)
end

local function SetCount(self, count)
  if count and 1 < count then
    self.countTxt:SetText(string.format("x%s", count))
  else
    self.countTxt:SetText("")
  end
end

local function OnClick(self)
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWTWSkillChipDetail) and self.chipInfo then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTWSkillChipDetail, {anim = true}, self.chipInfo, false, false)
  end
end

SkillChipBagItem.OnCreate = OnCreate
SkillChipBagItem.OnDestroy = OnDestroy
SkillChipBagItem.ComponentDefine = ComponentDefine
SkillChipBagItem.ComponentDestroy = ComponentDestroy
SkillChipBagItem.DataDefine = DataDefine
SkillChipBagItem.DataDestroy = DataDestroy
SkillChipBagItem.OnEnable = OnEnable
SkillChipBagItem.OnDisable = OnDisable
SkillChipBagItem.SetMaster = SetMaster
SkillChipBagItem.SetCount = SetCount
SkillChipBagItem.OnClick = OnClick
return SkillChipBagItem
