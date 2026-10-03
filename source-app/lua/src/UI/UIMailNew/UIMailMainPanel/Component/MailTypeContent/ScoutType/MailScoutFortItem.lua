local MailScoutFortItem = BaseClass("MailScoutFortItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local level_num_path = "Lv"
local attack_num_path = "Attack"
local tip_path = "Tip"
local blood_fore_path = "BloodFg"
local blood_num_path = "blood"

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
  self.LevelNumN = self:AddComponent(UIText, level_num_path)
  self.AttackNumN = self:AddComponent(UIText, attack_num_path)
  self.TipsN = self:AddComponent(UIText, tip_path)
  self.BloodNumN = self:AddComponent(UIText, blood_num_path)
  self.BloodForeBgN = self:AddComponent(UIImage, blood_fore_path)
end

local function ComponentDestroy(self)
  self.LevelNumN = nil
  self.AttackNumN = nil
  self.TipsN = nil
  self.BloodNumN = nil
  self.BloodForeBgN = nil
end

local function DataDefine(self)
  self.targetPointId = nil
end

local function DataDestroy(self)
  self.targetPointId = nil
end

local function RefreshData(self, fortInfo)
  self.LevelNumN:SetText(Localization:GetString("300627", fortInfo.level.value))
  self.AttackNumN:SetText(Localization:GetString("300628", fortInfo.attack.value))
  self.BloodNumN:SetText(fortInfo.hp.value .. "/" .. fortInfo.hpMax.value)
  self.TipsN:SetLocalText(300629)
  self.BloodForeBgN:SetFillAmount(fortInfo.hp.value / fortInfo.hpMax.value)
end

MailScoutFortItem.OnCreate = OnCreate
MailScoutFortItem.OnDestroy = OnDestroy
MailScoutFortItem.OnEnable = OnEnable
MailScoutFortItem.OnDisable = OnDisable
MailScoutFortItem.ComponentDefine = ComponentDefine
MailScoutFortItem.ComponentDestroy = ComponentDestroy
MailScoutFortItem.DataDefine = DataDefine
MailScoutFortItem.DataDestroy = DataDestroy
MailScoutFortItem.RefreshData = RefreshData
return MailScoutFortItem
