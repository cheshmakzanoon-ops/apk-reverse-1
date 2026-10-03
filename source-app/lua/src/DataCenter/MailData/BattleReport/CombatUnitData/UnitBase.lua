local UnitBase = BaseClass("UnitBase")

function UnitBase:InitData(unitData)
end

function UnitBase:GetSoldiers()
end

function UnitBase:GetHeroes()
end

function UnitBase:GetBaseInfo()
end

function UnitBase:GetAllMembers()
  return {}
end

function UnitBase:GetAttTotalCnt(attId, isMySelf)
  return 0
end

function UnitBase:GetSoliderLvStr()
  return ""
end

function UnitBase:GetHealth()
  return 0
end

function UnitBase:GetSimpleCombatUnit()
  return nil
end

function UnitBase:GetPlayerHeroes()
  return {}
end

function UnitBase:GetAllMembersUuid(unitType)
  return {}
end

function UnitBase:GetArmyUuidByUid(uid, unitType)
  return 0
end

function UnitBase:GetSimpleCombatUnitByUuid(uuid)
  return nil
end

function UnitBase:GetBuffIdListByEffectId(effectId, marchId)
  local buffList = {}
  return buffList
end

function UnitBase:GetSoldierPercentByType(sType)
  return 0
end

function UnitBase:GetSpecialType()
  return SpecialUnitType.NONE
end

function UnitBase:GetFormationIndex()
  return 0
end

function UnitBase:GetHeroSpecialSkillList()
  return {}
end

return UnitBase
