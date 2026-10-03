local UnitBase = require("DataCenter.MailData.BattleReport.CombatUnitData.UnitBase")
local SimpleCombatUnit = BaseClass("SimpleCombatUnit", UnitBase)

function SimpleCombatUnit:InitData(unitData)
  self._simpleCombatUnit = unitData
end

function SimpleCombatUnit:GetUnitData()
  return self._simpleCombatUnit or {}
end

function SimpleCombatUnit:GetUid()
  return self:GetUnitData().uid or ""
end

function SimpleCombatUnit:GetMarchId()
  return self:GetUnitData().uuid or ""
end

function SimpleCombatUnit:GetHealth()
  return self:GetUnitData().health or 0
end

function SimpleCombatUnit:GetInitHealth()
  return self:GetUnitData().initHealth or 0
end

function SimpleCombatUnit:GetSimpleCombatUnit()
  return self
end

function SimpleCombatUnit:GetAllMembersUuid(unitType)
  local list = {}
  local uuid = self:GetMarchId()
  if uuid ~= nil and uuid ~= "" then
    table.insert(list, uuid)
  end
  return list
end

function SimpleCombatUnit:GetArmyUuidByUid(targetUid, unitType)
  local uid = self:GetUid()
  if uid == targetUid then
    return self:GetMarchId()
  end
  return 0
end

function SimpleCombatUnit:GetHeroSpecialSkillList()
  return {}
end

return SimpleCombatUnit
