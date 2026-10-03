local MailArmyResultBase = require("DataCenter.MailData.BattleReport.MailArmyResultBase")
local MailArmyResult_Desert = BaseClass("MailArmyResult_Desert", MailArmyResultBase)
local Localization = CS.GameEntry.Localization

function MailArmyResult_Desert:InitData(armyResult)
  MailArmyResultBase.InitData(self, armyResult)
  self._isDefeat = armyResult.isDefeat
  local armyResultByType = self:GetArmyResultByType(armyResult)
  self._desertId = armyResultByType.desertId or 0
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

function MailArmyResult_Desert:GetName()
  local name = Localization:GetString("110251")
  local desertId = self._desertId
  local level = GetTableData(TableName.Desert, desertId, "desert_level")
  if level ~= nil and 0 < level then
    local nameStr = GetTableData(TableName.Desert, desertId, "desert_name")
    name = Localization:GetString("science_condition", level, Localization:GetString(nameStr))
  end
  return name
end

function MailArmyResult_Desert:GetName_ForShare()
  local param = {type = "dialog"}
  param.name = 110251
  local desertId = self._desertId
  local level = GetTableData(TableName.Desert, desertId, "desert_level")
  if level ~= nil and 0 < level then
    local nameStr = GetTableData(TableName.Desert, desertId, "desert_name")
    param.name = nameStr
  end
  return param
end

function MailArmyResult_Desert:GetPointId()
  return self._pointId
end

function MailArmyResult_Desert:GetPic()
  local str = GetTableData(TableName.Desert, self._desertId, "icon")
  local pic = string.format(LoadPath.SeasonDesert, str)
  return pic
end

return MailArmyResult_Desert
