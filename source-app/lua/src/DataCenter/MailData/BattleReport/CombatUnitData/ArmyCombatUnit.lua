local SimpleCombatUnit = require("DataCenter.MailData.BattleReport.CombatUnitData.SimpleCombatUnit")
local UnitBase = require("DataCenter.MailData.BattleReport.CombatUnitData.UnitBase")
local ArmyUnitBuff = require("DataCenter.MailData.BattleReport.ArmyUnitBuff")
local ArmyCombatUnit = BaseClass("ArmyCombatUnit", UnitBase)
local Localization = CS.GameEntry.Localization

function ArmyCombatUnit:InitData(armyCombatUnit)
  self._simpleCombatUnit = SimpleCombatUnit.New()
  self._simpleCombatUnit:InitData(armyCombatUnit.simpleCombatUnit)
  self.specialArmyType = armyCombatUnit.specialArmyType or SpecialUnitType.NONE
  self.formationIndex = armyCombatUnit.formationIndex or 0
  self._tSoldiers = {}
  self:InitSoldiers(armyCombatUnit.armyInfo)
  self._tHeroes = {}
  self:InitHeroes(armyCombatUnit.armyInfo)
  self:InitMemberInfo(armyCombatUnit.armyInfo)
end

function ArmyCombatUnit:InitMemberInfo(armyInfo)
  if armyInfo == nil then
    return
  end
  self.alAbbr = armyInfo.alAbbr or ""
  self.name = armyInfo.name or ""
  self.pic = armyInfo.pic or ""
  self.picVer = armyInfo.picVer or 0
  self.careerType = armyInfo.careerType or 0
  self.careerLv = armyInfo.careerLv or 0
  self:InitArmyUnitBuffList(armyInfo.unitBuffs)
end

function ArmyCombatUnit:InitArmyUnitBuffList(unitBuffs)
  if unitBuffs == nil then
    return
  end
  self.unitBuffList = {}
  for k, v in pairs(unitBuffs) do
    local oneData = ArmyUnitBuff.New()
    oneData:InitData(v)
    if oneData.buffId ~= nil and oneData.buffId > 0 then
      self.unitBuffList[oneData.buffId] = oneData
    end
  end
end

function ArmyCombatUnit:InitHeroes(armyInfo)
  if armyInfo == nil then
    return
  end
  local armyHeroes = armyInfo.heroes or {}
  local tHeros = {}
  for _, hInfo in pairs(armyHeroes) do
    tHeros[hInfo.heroId] = hInfo
  end
  self._tHeroes = tHeros
end

function ArmyCombatUnit:GetHeroSpecialSkillList()
  local skillList = {}
  for k, v in pairs(self._tHeroes) do
    local skillData = v.skillInfos
    for a, b in pairs(skillData) do
      local skillId = b.skillId
      local subType = GetTableData(TableName.SkillTab, skillId, "subType")
      local skillType = GetTableData(TableName.SkillTab, skillId, "type")
      if subType == 16 or skillType == 16 then
        local skill = {}
        skill.id = b.skillId
        skill.level = b.skillLv
        local health_enable = GetTableData(TableName.SkillTab, skillId, "health_enable")
        local arr = string.split(health_enable, "|")
        local effect_des = GetTableData(TableName.SkillTab, skillId, "effect_num")
        local effect_arr = string.split(effect_des, "|")
        if #arr >= skill.level and #effect_arr >= skill.level then
          local subArr = string.split(arr[skill.level], ";")
          if 1 < #subArr then
            skill.minPercent = tonumber(subArr[1])
            skill.maxPercent = tonumber(subArr[2])
            skill.numDes = effect_arr[skill.level]
            skill.effectId = GetTableData(TableName.SkillTab, skillId, "effect_num_des")
            table.insert(skillList, skill)
          end
        end
      end
    end
  end
  return skillList
end

function ArmyCombatUnit:GetUserName()
  if self.specialArmyType == SpecialUnitType.BUILDING_STATION then
    return Localization:GetString("140311")
  else
    if not string.IsNullOrEmpty(self.alAbbr) then
      return "[" .. self.alAbbr .. "] " .. self.name
    end
    return self.name
  end
end

function ArmyCombatUnit:GetSimpleCombatUnit()
  return self._simpleCombatUnit
end

function ArmyCombatUnit:GetPicInfo()
  local userid = self._simpleCombatUnit:GetUid()
  local param = {}
  param.uid = userid
  param.pic = self.pic or ""
  param.picVer = self.picVer or 0
  return param
end

function ArmyCombatUnit:InitSoldiers(armyInfo)
  if armyInfo == nil then
    return
  end
  local armySoldiers = armyInfo.soldiers or {}
  local tSoldiers = {}
  for _, sInfo in pairs(armySoldiers) do
    tSoldiers[sInfo.armsId] = sInfo
  end
  self._tSoldiers = tSoldiers
end

function ArmyCombatUnit:GetAllMembers()
  local param = {}
  param[#param + 1] = self
  return param
end

function ArmyCombatUnit:GetSoldiers()
  return self._tSoldiers
end

function ArmyCombatUnit:GetSoliderLvStr()
  local dic = {}
  for _, sInfo in pairs(self._tSoldiers) do
    local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(_)
    if template ~= nil then
      local level = template.level
      if dic[level] == nil then
        dic[level] = NumToRoman(level)
      end
    end
  end
  local str = ""
  for k, v in pairs(dic) do
    if str ~= "" then
      str = str .. " , " .. v
    else
      str = str .. v
    end
  end
  return str
end

function ArmyCombatUnit:GetSoldierPercentByType(sType)
  local percent = 0
  local curCount = 0
  local totalCnt = 0
  for k, v in pairs(self._tSoldiers) do
    local type = v.type
    local total = v.total
    local lost = v.lost
    local rest = total - lost
    if type == sType then
      curCount = curCount + rest
    end
    totalCnt = totalCnt + rest
  end
  if 0 < curCount and 0 < totalCnt then
    percent = curCount / totalCnt
  end
  return percent
end

function ArmyCombatUnit:GetPlayerHeroes(userId)
  return self._tHeroes
end

function ArmyCombatUnit:GetMarchId()
  return self._simpleCombatUnit:GetMarchId()
end

function ArmyCombatUnit:GetUserId()
  return self._simpleCombatUnit:GetUid()
end

function UnitBase:GetBuffIdListByEffectId(effectId, marchId)
  local buffList = {}
  return buffList
end

function ArmyCombatUnit:GetAttTotalCnt(attId, isMySelf)
  local totalCnt = 0
  for _, sInfo in pairs(self._tSoldiers) do
    totalCnt = totalCnt + sInfo[attId]
  end
  return totalCnt
end

function ArmyCombatUnit:GetHealth()
  return self._simpleCombatUnit:GetHealth()
end

function ArmyCombatUnit:GetInitHealth()
  return self._simpleCombatUnit:GetInitHealth()
end

function ArmyCombatUnit:IsEmpty()
  if string.IsNullOrEmpty(self.name) then
    return true
  end
  return false
end

function ArmyCombatUnit:GetSpecialType()
  return self.specialArmyType
end

function UnitBase:GetFormationIndex()
  return self.formationIndex
end

function ArmyCombatUnit:GetAllMembersUuid(unitType)
  local list = {}
  local uuid = self:GetMarchId()
  if uuid ~= nil and uuid ~= "" then
    table.insert(list, uuid)
  end
  return list
end

function ArmyCombatUnit:GetArmyUuidByUid(targetUid, unitType)
  local uid = self:GetUserId()
  if uid == targetUid then
    return self:GetMarchId()
  end
  return 0
end

function ArmyCombatUnit:GetBuffIdListByEffectId(effectId, marchId)
  local buffList = {}
  if self.unitBuffList ~= nil then
    for k, v in pairs(self.unitBuffList) do
      local num = v:GetEffectNum(effectId)
      if 0 < num then
        buffList[k] = num
      end
    end
  end
  return buffList
end

return ArmyCombatUnit
