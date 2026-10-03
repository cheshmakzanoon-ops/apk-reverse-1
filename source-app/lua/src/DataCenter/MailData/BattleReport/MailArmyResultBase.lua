local MailArmyResultBase = BaseClass("MailArmyResultBase")
local ArmyCombatUnit = require("DataCenter.MailData.BattleReport.CombatUnitData.ArmyCombatUnit")
local CombineCombatUnit = require("DataCenter.MailData.BattleReport.CombatUnitData.CombineCombatUnit")
local SimpleCombatUnit = require("DataCenter.MailData.BattleReport.CombatUnitData.SimpleCombatUnit")
local DamagePercentInfo = require("DataCenter.MailData.BattleReport.DamagePercentInfo")

function MailArmyResultBase:InitData(armyResult)
  self._armyObj = nil
  self._afterArmyObj = nil
  self._unitType = MailCombatUnitType.Unknow
  self._destroyValue = 0
  self._damagePercentInfo = {}
end

function MailArmyResultBase:GetArmyObj()
  return self._armyObj
end

function MailArmyResultBase:GetAfterArmyObj()
  return self._afterArmyObj
end

function MailArmyResultBase:InitDestroyValue(armyResultBase)
  if armyResultBase.destroyValue then
    local arrDestroyValue = armyResultBase.destroyValue
    for _, valueItem in pairs(arrDestroyValue) do
      self._destroyValue = self._destroyValue + valueItem
    end
  else
    self._destroyValue = -1
  end
end

function MailArmyResultBase:InitDamagePercentInfo(armyResultBase)
  if armyResultBase.damagePercent then
    local damagePercent = armyResultBase.damagePercent
    for _, valueItem in pairs(damagePercent) do
      local oneData = DamagePercentInfo.New()
      oneData:InitData(valueItem)
      local selfUuid = oneData.selfUuid
      local targetUuid = oneData.targetUuid
      if selfUuid ~= nil and selfUuid ~= 0 and targetUuid ~= nil and targetUuid ~= 0 then
        if self._damagePercentInfo[selfUuid] == nil then
          self._damagePercentInfo[selfUuid] = {}
        end
        self._damagePercentInfo[selfUuid][targetUuid] = oneData
      end
    end
  end
end

function MailArmyResultBase:GetDamagePercentInfo()
  return self._damagePercentInfo
end

function MailArmyResultBase:GetDestroyValue()
  return self._destroyValue
end

function MailArmyResultBase:GetCombatType(unitData)
  if self._unitType == BattleType.Road then
    return MailCombatUnitType.SimpleCombatUnit
  elseif self._unitType == BattleType.Formation or self._unitType == BattleType.Monster or self._unitType == BattleType.Explore or self._unitType == BattleType.ALLIANCE_NEUTRAL_CITY or self._unitType == BattleType.ELITE_FIGHT_MAIL or self._unitType == BattleType.PVE_MARCH or self._unitType == BattleType.PVE_MONSTER or self._unitType == BattleType.Boss or self._unitType == BattleType.PUZZLE_BOSS or self._unitType == BattleType.ACT_BOSS or self._unitType == BattleType.CHALLENGE_BOSS then
    return MailCombatUnitType.ArmyCombatUnit
  elseif self._unitType == BattleType.Building or self._unitType == BattleType.City or self._unitType == BattleType.Turret or self._unitType == BattleType.ALLIANCE_OCCUPIED_CITY or self._unitType == BattleType.Desert or self._unitType == BattleType.RallyFormation then
    return MailCombatUnitType.CombineCombatUnit
  else
    return MailCombatUnitType.Unknow
  end
end

function MailArmyResultBase:InitCombatUnitData(unitData)
  local handler
  self._unitType = unitData.type
  if self:GetCombatType(unitData) == MailCombatUnitType.SimpleCombatUnit then
    handler = SimpleCombatUnit.New()
    handler:InitData(unitData.simpleCombatUnit)
  elseif self:GetCombatType(unitData) == MailCombatUnitType.ArmyCombatUnit then
    handler = ArmyCombatUnit.New()
    handler:InitData(unitData.armyCombatUnit)
  elseif self:GetCombatType(unitData) == MailCombatUnitType.CombineCombatUnit then
    handler = CombineCombatUnit.New()
    handler:InitData(unitData.combineCombatUnit)
  end
  if handler == nil then
    Logger.LogError("CombatUnit InitData error type: ", self._unitType)
    return handler
  end
  return handler
end

function MailArmyResultBase:GetArmyResultByType(armyResultData)
  local _type = armyResultData.type or 0
  if _type == BattleType.Building or _type == BattleType.Turret then
    return armyResultData.buildArmyResult
  elseif _type == BattleType.City then
    return armyResultData.cityArmyResult
  elseif _type == BattleType.Monster or _type == BattleType.Boss or _type == BattleType.Explore or _type == BattleType.ACT_BOSS or _type == BattleType.PUZZLE_BOSS or _type == BattleType.CHALLENGE_BOSS then
    return armyResultData.monsterArmyResult
  elseif _type == BattleType.ALLIANCE_NEUTRAL_CITY or _type == BattleType.ALLIANCE_OCCUPIED_CITY then
    return armyResultData.allianceCityArmyResult
  elseif _type == BattleType.Desert then
    return armyResultData.desertArmyResult
  elseif _type == BattleType.PVE_MONSTER or _type == BattleType.PVE_MARCH then
    return armyResultData.pveArmyResult
  else
    return armyResultData.simpleArmyResult
  end
end

function MailArmyResultBase:GetPlayerHeroes(userId, isBefore)
  local armyObject = isBefore and self._armyObj or self._afterArmyObj
  return armyObject:GetPlayerHeroes(userId)
end

function MailArmyResultBase:GetBattleType()
  return self.armyResultData.type or 0
end

function MailArmyResultBase:GetName()
  return ""
end

function MailArmyResultBase:GetPic()
  return ""
end

function MailArmyResultBase:GetName_ForShare()
  return ""
end

function MailArmyResultBase:GetPointId()
  return 0
end

function MailArmyResultBase:GetInfo()
  return nil
end

function MailArmyResultBase:GetBuildId()
  return 0
end

function MailArmyResultBase:GetAllMembers(isBefore)
  local armyObj = isBefore and self._armyObj or self._afterArmyObj
  return armyObj:GetAllMembers()
end

function MailArmyResultBase:GetHealth()
  if self._unitType == BattleType.Building or self._unitType == BattleType.Turret then
    local simpleCombatUnit = self._armyObj:GetSimpleCombatUnit()
    if simpleCombatUnit == nil then
      return 0
    end
    return simpleCombatUnit:GetHealth() + self._armyObj:GetHealth()
  end
  return self._armyObj:GetHealth()
end

function MailArmyResultBase:GetHeroSpecialSkillList()
  return self._armyObj:GetHeroSpecialSkillList()
end

function MailArmyResultBase:GetUnitType()
  return self._unitType
end

function MailArmyResultBase:CheckArmyObj()
  local _armyMember = self._armyObj._memberUnit or {}
  local _afterMember = self._afterArmyObj._memberUnit or {}
  
  local function ReCheck(name, obj_list)
    for i = 1, table.count(obj_list) do
      local item = obj_list[i]
      if item.name == name then
        return true
      end
    end
    return false
  end
  
  local function ForeachArmy(srclist, checklist)
    local index, r_index, length = 1, 1, #srclist
    while index <= length do
      local v = srclist[index]
      srclist[index] = nil
      if v ~= nil and ReCheck(v.name, checklist) then
        srclist[r_index] = v
        r_index = r_index + 1
      end
      index = index + 1
    end
  end
  
  ForeachArmy(_armyMember, _afterMember)
  ForeachArmy(_afterMember, _armyMember)
end

function MailArmyResultBase:GetAllMembersUuidList()
  return self._armyObj:GetAllMembersUuid(self._unitType)
end

function MailArmyResultBase:GetUuidInMembersByUid(uid)
  return self._armyObj:GetArmyUuidByUid(uid, self._unitType)
end

return MailArmyResultBase
