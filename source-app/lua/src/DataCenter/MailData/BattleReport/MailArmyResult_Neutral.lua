local MailArmyResultBase = require("DataCenter.MailData.BattleReport.MailArmyResultBase")
local MailArmyResult_Neutral = BaseClass("MailArmyResult_Neutral", MailArmyResultBase)
local Localization = CS.GameEntry.Localization

function MailArmyResult_Neutral:InitData(armyResult)
  MailArmyResultBase.InitData(self, armyResult)
  self._isDefeat = armyResult.isDefeat
  local armyResultByType = self:GetArmyResultByType(armyResult)
  self._cityId = armyResultByType.cityId or 0
  self._health = armyResultByType.health or 0
  self._initHealth = armyResultByType.initHealth or 0
  self._afterHealth = armyResultByType.afterHealth or 0
  self.cityName = armyResultByType.cityName or ""
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

function MailArmyResult_Neutral:GetPointId()
  local strPos = GetTableData(TableName.WorldCity, self._cityId, "location")
  local tabPos = string.split(strPos, "|")
  if table.count(tabPos) ~= 2 then
    return 0
  end
  local vec2 = CS.UnityEngine.Vector2Int(tonumber(tabPos[1]), tonumber(tabPos[2]))
  local pointId = SceneUtils.TilePosToIndex(vec2)
  return pointId
end

function MailArmyResult_Neutral:GetName()
  local name = self.cityName
  if name == nil or name == "" then
    name = GetTableData(TableName.WorldCity, self._cityId, "name")
    name = Localization:GetString(name)
  end
  return name
end

function MailArmyResult_Neutral:GetName_ForShare()
  local param = {type = "dialog"}
  local name = GetTableData(TableName.WorldCity, self._cityId, "name")
  param.name = name
  return param
end

function MailArmyResult_Neutral:GetNeutral_Health()
  return self._afterHealth
end

function MailArmyResult_Neutral:GetNeutral_InitHealth()
  return self._initHealth
end

return MailArmyResult_Neutral
