local MailArmyResultBase = require("DataCenter.MailData.BattleReport.MailArmyResultBase")
local MailArmyResult_City = BaseClass("MailArmyResult_City", MailArmyResultBase)
local Localization = CS.GameEntry.Localization

function MailArmyResult_City:InitData(armyResult)
  MailArmyResultBase.InitData(self, armyResult)
  self._isDefeat = armyResult.isDefeat
  local armyResultByType = self:GetArmyResultByType(armyResult)
  self._cityLevel = armyResultByType.level or 0
  local _armyResultBase = armyResultByType.base
  if _armyResultBase == nil then
    return
  end
  local armyObj = _armyResultBase.armyObj or {}
  self._armyObj = self:InitCombatUnitData(armyObj)
  local afterArmyObj = _armyResultBase.afterArmyObj or {}
  self._afterArmyObj = self:InitCombatUnitData(afterArmyObj)
  self:CheckArmyObj()
  self:InitDestroyValue(_armyResultBase)
  self:InitDamagePercentInfo(_armyResultBase)
end

function MailArmyResult_City:GetPic()
  return DataCenter.BuildManager:GetBuildIconPath(BuildingTypes.FUN_BUILD_MAIN, 1)
end

function MailArmyResult_City:GetName()
  local tempName = " "
  local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.FUN_BUILD_MAIN)
  if template ~= nil then
    tempName = tempName .. Localization:GetString(template.name)
  end
  return Localization:GetString("300665", self._cityLevel) .. tempName
end

function MailArmyResult_City:GetName_ForShare()
  local param = {type = "dialog"}
  param.level = self._cityLevel
  local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.FUN_BUILD_MAIN)
  if template ~= nil then
    param.name = template.name
  end
  return param
end

return MailArmyResult_City
