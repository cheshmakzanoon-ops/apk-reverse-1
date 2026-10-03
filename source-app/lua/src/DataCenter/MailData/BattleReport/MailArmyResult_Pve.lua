local Localization = CS.GameEntry.Localization
local MailArmyResultBase = require("DataCenter.MailData.BattleReport.MailArmyResultBase")
local MailArmyResult_Pve = BaseClass("MailArmyResult_Pve", MailArmyResultBase)

function MailArmyResult_Pve:InitData(armyResult)
  MailArmyResultBase.InitData(self, armyResult)
  local armyResultByType = self:GetArmyResultByType(armyResult)
  self._monsterId = armyResultByType.monsterId or 0
  local armyResultBase = armyResultByType.base
  local armyObj = armyResultBase.armyObj or {}
  self._armyObj = self:InitCombatUnitData(armyObj)
  local afterArmyObj = armyResultBase.afterArmyObj or {}
  self._afterArmyObj = self:InitCombatUnitData(afterArmyObj)
  self:CheckArmyObj()
  self:InitDestroyValue(armyResultBase)
  self:InitDamagePercentInfo(armyResultBase)
end

function MailArmyResult_Pve:GetName()
  return "no name MailArmyResult_Pve"
end

function MailArmyResult_Pve:GetName_ForShare()
  return nil
end

function MailArmyResult_Pve:GetInfo()
  return nil
end

function MailArmyResult_Pve:GetPointId()
  return 0
end

return MailArmyResult_Pve
