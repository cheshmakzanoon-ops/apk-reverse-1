local MailArmyResultBase = require("DataCenter.MailData.BattleReport.MailArmyResultBase")
local MailArmyResult_March = BaseClass("MailArmyResult_March", MailArmyResultBase)

function MailArmyResult_March:InitData(armyResult)
  MailArmyResultBase.InitData(self, armyResult)
  self._isDefeat = armyResult.isDefeat
  local armyResultByType = self:GetArmyResultByType(armyResult)
  self._pointId = armyResultByType.pointId or 0
  local armyObj = armyResultByType.armyObj or {}
  self._armyObj = self:InitCombatUnitData(armyObj)
  local afterArmyObj = armyResultByType.afterArmyObj or {}
  self._afterArmyObj = self:InitCombatUnitData(afterArmyObj)
  self:CheckArmyObj()
  self:InitDestroyValue(armyResultByType)
  self:InitDamagePercentInfo(armyResultByType)
end

function MailArmyResult_March:GetPointId()
  return self._pointId
end

return MailArmyResult_March
