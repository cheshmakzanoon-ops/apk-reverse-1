local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization
local MailBattleArmyinfoBase = require("DataCenter.MailData.BattleReport.MailArmyResultBase")
local BattleEffectList = require("DataCenter.MailData.BattleReport.BattleEffectData.BattleEffectList")
local MailArmyResult_Building = require("DataCenter.MailData.BattleReport.MailArmyResult_Building")
local MailArmyResult_City = require("DataCenter.MailData.BattleReport.MailArmyResult_City")
local MailArmyResult_March = require("DataCenter.MailData.BattleReport.MailArmyResult_March")
local MailArmyResult_Pve = require("DataCenter.MailData.BattleReport.MailArmyResult_Pve")
local MailArmyResult_Monster = require("DataCenter.MailData.BattleReport.MailArmyResult_Monster")
local MailArmyResult_Team = require("DataCenter.MailData.BattleReport.MailArmyResult_Team")
local MailArmyResult_Road = require("DataCenter.MailData.BattleReport.MailArmyResult_Road")
local MailArmyResult_Neutral = require("DataCenter.MailData.BattleReport.MailArmyResult_Neutral")
local MailArmyResult_Desert = require("DataCenter.MailData.BattleReport.MailArmyResult_Desert")
local UnitAttrInfo = require("DataCenter.MailData.BattleReport.UnitAttrInfo.UnitAttrInfo")
local MailReportPlayerReward = require("DataCenter.MailData.BattleReport.MailReportPlayerReward")
local MailBattleOneRound = BaseClass("MailBattleOneRound")

function MailBattleOneRound:__init()
  self.allRewards = {}
  self._selfInfo = nil
  self._otherInfo = nil
  self._otherArmyResult = nil
  self._selfArmyResult = nil
  self.fightResult = nil
  self._otherBattleBuffList = {}
  self._selfBattleBuffList = {}
  self._selfAttrCacheData = {}
  self._otherAttrCacheData = {}
  self._selfAttrDisCacheData = {}
  self._otherAttrDisCacheData = {}
  self._vsMap = {}
end

function MailBattleOneRound:GetSelfArmyResult()
  return self._selfArmyResult
end

function MailBattleOneRound:GetOtherArmyResult()
  return self._otherArmyResult
end

function MailBattleOneRound:GetSelfInfo()
  return self._selfInfo or {}
end

function MailBattleOneRound:GetSelfName()
  local abbr = self:GetOnlySelfAbbr()
  local name = self:GetOnlySelfName()
  if not string.IsNullOrEmpty(abbr) then
    return "[" .. abbr .. "] " .. name
  end
  return name
end

function MailBattleOneRound:GetOnlySelfAbbr()
  if self._selfInfo == nil then
    return ""
  end
  if self._selfInfo.allianceInfo ~= nil then
    local alAbbr = self._selfInfo.allianceInfo.alAbbr or ""
    return alAbbr
  end
  return ""
end

function MailBattleOneRound:GetOnlySelfName()
  local sBattleType = self:GetSelfBattleType()
  if sBattleType == BattleType.Building or sBattleType == BattleType.City or sBattleType == BattleType.Formation or sBattleType == BattleType.Road or sBattleType == BattleType.ELITE_FIGHT_MAIL or sBattleType == BattleType.Desert or sBattleType == BattleType.RallyFormation then
    local userName = self._selfInfo and self._selfInfo.name or "not find target name"
    return userName
  else
    return self._selfArmyResult and self._selfArmyResult:GetName() or ""
  end
end

function MailBattleOneRound:GetPlayerHeroes(isMySide, userId, isBefore)
  if isMySide then
    return self._selfArmyResult:GetPlayerHeroes(userId, isBefore) or {}
  else
    return self._otherArmyResult:GetPlayerHeroes(userId, isBefore) or {}
  end
end

function MailBattleOneRound:ParseContent(fightReportItem, isChampionBattle)
  local _rewardList = fightReportItem.allRewards or {}
  self:InitRewardList(_rewardList)
  self.fightResult = fightReportItem.fightResult or FightResult.DEFAULT
  self._selfInfo = fightReportItem.selfInfo or {}
  self._otherInfo = fightReportItem.otherInfo or {}
  self._curRoundUuid = fightReportItem.uuid or ""
  local _otherArmyResult = fightReportItem.otherArmyResult or {}
  self._otherArmyType = _otherArmyResult.type or 0
  self._otherArmyResult = self:InitArmyInfo(_otherArmyResult)
  local _selfArmyResult = fightReportItem.selfArmyResult or {}
  self._selfArmyType = _selfArmyResult.type or 0
  self._selfArmyResult = self:InitArmyInfo(_selfArmyResult)
  local otherBattleEffectGroups = fightReportItem.otherBattleEffectGroups or {}
  self:InitOtherBattleEffectGroup(otherBattleEffectGroups)
  local battleEffectGroup = fightReportItem.selfBattleEffectGroups or {}
  self:InitMySideBattleEffect(battleEffectGroup)
  local unitAttrInfoArr = fightReportItem.unitAttrInfo or {}
  self:InitUnitAttrInfo(unitAttrInfoArr)
  self:InitVsMap(isChampionBattle)
end

function MailBattleOneRound:InitUnitAttrInfo(unitAttrInfoArr)
  self.unitAttrInfoList = {}
  for _, unitAttrInfoItem in pairs(unitAttrInfoArr) do
    local oneData = UnitAttrInfo.New()
    oneData:InitData(unitAttrInfoItem)
    if oneData.uuid ~= nil and oneData.uuid ~= 0 then
      self.unitAttrInfoList[oneData.uuid] = oneData
    end
  end
end

function MailBattleOneRound:GetUnitAttrInfoByUuid(uuid)
  return self.unitAttrInfoList[uuid]
end

function MailBattleOneRound:InitMySideBattleEffect(buffEffect)
  self._selfBattleBuffList = {}
  for _, buffItem in pairs(buffEffect) do
    local marchId = buffItem.memberUuid
    local arrayEffect = buffItem.battleEffectInfos
    local oneData = BattleEffectList.New()
    oneData:InitData(arrayEffect)
    self._selfBattleBuffList[marchId] = oneData
  end
end

function MailBattleOneRound:GetCurRoundUuid()
  return self._curRoundUuid
end

function MailBattleOneRound:InitOtherBattleEffectGroup(buffEffect)
  self._otherBattleBuffList = {}
  for _, buffItem in pairs(buffEffect) do
    local uuid = buffItem.memberUuid
    local arrayEffect = buffItem.battleEffectInfos
    local oneData = BattleEffectList.New()
    oneData:InitData(arrayEffect)
    self._otherBattleBuffList[uuid] = oneData
  end
end

function MailBattleOneRound:GetOtherBattleEffectByMarchId(marchId)
  return self._otherBattleBuffList[marchId]
end

function MailBattleOneRound:GetSelfBattleEffectByMarchId(marchId)
  return self._selfBattleBuffList[marchId]
end

function MailBattleOneRound:GetBattleResult()
  return self.fightResult
end

function MailBattleOneRound:InitRewardList(_rewardList)
  for k, v in pairs(_rewardList) do
    local uuid = v.uuid
    local reward = v.reward
    if uuid ~= nil and reward ~= nil then
      local oneData = MailReportPlayerReward.New()
      oneData:InitData(reward)
      self.allRewards[uuid] = oneData
    end
  end
end

function MailBattleOneRound:GetRewardItemArr(uuid)
  local rewardItem = self.allRewards[uuid]
  if rewardItem ~= nil then
    return rewardItem:GetRewardItemArr()
  end
  return {}
end

function MailBattleOneRound:GetResRewardItemArr(uuid)
  local rewardItem = self.allRewards[uuid]
  if rewardItem ~= nil then
    return rewardItem:GetResRewardItemArr()
  end
  return {}
end

function MailBattleOneRound:GetRewardExpArr()
  local showList = {}
  for k, v in pairs(self.allRewards) do
    local list = v:GetRewardExpArr()
    table.merge(showList, list)
  end
  return showList
end

function MailBattleOneRound:GetFightResItemArr(uuid)
  local rewardItem = self.allRewards[uuid]
  if rewardItem ~= nil then
    return rewardItem:GetFightResItemArr()
  end
  return {}
end

function MailBattleOneRound:GetPlunderResRate(uuid)
  local rewardItem = self.allRewards[uuid]
  if rewardItem ~= nil then
    return rewardItem:GetPlunderResRate()
  end
  return {}
end

function MailBattleOneRound:InitArmyInfo(armyResult)
  local _type = armyResult.type or 0
  local _armyInfo
  if _type == BattleType.Formation or _type == BattleType.ELITE_FIGHT_MAIL then
    _armyInfo = MailArmyResult_March.New()
  elseif _type == BattleType.PVE_MARCH or _type == BattleType.PVE_MONSTER then
    _armyInfo = MailArmyResult_Pve.New()
  elseif _type == BattleType.Building or _type == BattleType.Turret then
    _armyInfo = MailArmyResult_Building.New()
  elseif _type == BattleType.Monster or _type == BattleType.Boss or _type == BattleType.Explore or _type == BattleType.PVE_MONSTER or _type == BattleType.ACT_BOSS or _type == BattleType.PUZZLE_BOSS or _type == BattleType.CHALLENGE_BOSS then
    _armyInfo = MailArmyResult_Monster.New()
  elseif _type == BattleType.RallyFormation then
    _armyInfo = MailArmyResult_Team.New()
  elseif _type == BattleType.City then
    _armyInfo = MailArmyResult_City.New()
  elseif _type == BattleType.Road then
    _armyInfo = MailArmyResult_Road.New()
  elseif _type == BattleType.ALLIANCE_NEUTRAL_CITY or _type == BattleType.ALLIANCE_OCCUPIED_CITY then
    _armyInfo = MailArmyResult_Neutral.New()
  elseif _type == BattleType.Desert then
    _armyInfo = MailArmyResult_Desert.New()
  end
  if _armyInfo ~= nil then
    _armyInfo:InitData(armyResult)
  end
  return _armyInfo
end

function MailBattleOneRound:GetSoldierAttrDisById(attId, isMySide)
  local attrCache = isMySide and self._selfAttrDisCacheData or self._otherAttrDisCacheData
  if attrCache[attId] ~= nil then
    return attrCache[attId]
  end
  local result = self:GetAfterArmyObjAttTotalCnt(attId, isMySide, false) - self:GetArmyObjAttTotalCnt(attId, isMySide, false)
  attrCache[attId] = result
  return result
end

function MailBattleOneRound:SetSoldierAttrDisCacheById(attId, isMySide, value)
  local attrCache = isMySide and self._selfAttrDisCacheData or self._otherAttrDisCacheData
  attrCache[attId] = value
end

function MailBattleOneRound:GetLeaderHeroes(isMySide, isBefore, targetUid)
  local leaderinfo = isMySide and self._selfInfo or self._otherInfo
  local armyResult = isMySide and self._selfArmyResult or self._otherArmyResult
  local uid = leaderinfo.uid or targetUid
  return armyResult:GetPlayerHeroes(uid, isBefore)
end

function MailBattleOneRound:GetArmyObjAttTotalCnt(attId, isMySide)
  local attrCache = isMySide and self._selfAttrCacheData or self._otherAttrCacheData
  if attrCache[attId] ~= nil then
    return attrCache[attId]
  end
  local armyResult = isMySide and self._selfArmyResult or self._otherArmyResult
  local armyObj = armyResult:GetArmyObj()
  if armyObj == nil then
    return 0
  end
  local result = 0
  if isMySide then
    result = armyObj:GetAttTotalCnt(attId, false)
  else
    result = armyObj:GetAttTotalCnt(attId, false)
  end
  attrCache[attId] = result
  return result
end

function MailBattleOneRound:GetSelfSoldierTotalCnt()
  if self._selfArmyResult == nil then
    return 0
  end
  local armyObj = self._selfArmyResult:GetArmyObj()
  if armyObj == nil then
    return 0
  end
  return armyObj:GetAttTotalCnt(eMailSoldierAttr.Total, true)
end

function MailBattleOneRound:GetAfterArmyObjAttTotalCnt(attId, isMySide, isMySelf)
  local armyResult = isMySide and self._selfArmyResult or self._otherArmyResult
  local armyObj = armyResult:GetAfterArmyObj()
  if armyObj == nil then
    return 0
  end
  if isMySide then
    return armyObj:GetAttTotalCnt(attId, isMySelf)
  else
    return armyObj:GetAttTotalCnt(attId, false)
  end
end

function MailBattleOneRound:GetSelfBattleType()
  return self._selfArmyType
end

function MailBattleOneRound:SetSelfBattleType(value)
  self._selfArmyType = value
end

function MailBattleOneRound:GetTargetBattleType()
  return self._otherArmyType
end

function MailBattleOneRound:SetTargetBattleType(value)
  self._otherArmyType = value
end

function MailBattleOneRound:GetBuildingName(isMySide)
  if isMySide then
    return self._selfArmyResult and self._selfArmyResult:GetName() or ""
  else
    return self._otherArmyResult and self._otherArmyResult:GetName() or ""
  end
end

function MailBattleOneRound:GetBuildingName_ForShare(isMySide)
  if isMySide then
    return self._selfArmyResult and self._selfArmyResult:GetName_ForShare() or ""
  else
    return self._otherArmyResult and self._otherArmyResult:GetName_ForShare() or ""
  end
end

function MailBattleOneRound:GetTargetName()
  local abbr = self:GetOnlyTargetAbbr()
  local username = self:GetOnlyTargetName()
  if not string.IsNullOrEmpty(abbr) then
    return "[" .. abbr .. "] " .. username
  end
  return username
end

function MailBattleOneRound:GetTargetName_ForShare()
  local abbr = self:GetOnlyTargetAbbr()
  local username = self:GetOnlyTargetName_ForShare()
  if not string.IsNullOrEmpty(abbr) then
    if type(username) == "string" then
      return "[" .. abbr .. "] " .. username
    elseif type(username) == "table" then
      username.abbr = abbr
    end
  end
  return username
end

function MailBattleOneRound:GetForceTargetName()
  local abbr = ""
  if self._otherInfo.allianceInfo ~= nil then
    abbr = self._otherInfo.allianceInfo.alAbbr or ""
  end
  local userName = self._otherInfo.name or "-"
  if not string.IsNullOrEmpty(abbr) then
    return "[" .. abbr .. "] " .. userName
  end
  return userName
end

function MailBattleOneRound:GetOnlyTargetName()
  local tBattleType = self:GetTargetBattleType()
  if tBattleType == BattleType.Building or tBattleType == BattleType.City or tBattleType == BattleType.Formation or tBattleType == BattleType.Road or tBattleType == BattleType.RallyFormation then
    local userName = self._otherInfo.name or ""
    return userName
  elseif tBattleType == BattleType.ELITE_FIGHT_MAIL or tBattleType == BattleType.PVE_MARCH then
    local userName = self._otherInfo.name or ""
    if userName == "" then
      userName = Localization:GetString("100184")
    end
    return userName
  elseif tBattleType == BattleType.PVE_MONSTER then
    local userName = self._otherInfo.name or ""
    if userName == "" then
      userName = Localization:GetString("302219")
    end
    return userName
  else
    return self._otherArmyResult and self._otherArmyResult:GetName() or ""
  end
end

function MailBattleOneRound:GetOnlyTargetName_ForShare()
  local tBattleType = self:GetTargetBattleType()
  if tBattleType == BattleType.Building or tBattleType == BattleType.City or tBattleType == BattleType.Formation or tBattleType == BattleType.Road or tBattleType == BattleType.RallyFormation then
    local userName = self._otherInfo.name or "not find target name"
    return userName
  elseif tBattleType == BattleType.ELITE_FIGHT_MAIL then
    local userName = self._otherInfo.name or ""
    if userName == "" then
      local param = {type = "dialog"}
      param.name = "100184"
      return param
    end
    return userName
  else
    return self._otherArmyResult and self._otherArmyResult:GetName_ForShare() or ""
  end
end

function MailBattleOneRound:GetOnlyTargetAbbr()
  local tBattleType = self:GetTargetBattleType()
  if tBattleType == BattleType.Building or tBattleType == BattleType.City or tBattleType == BattleType.Formation or tBattleType == BattleType.RallyFormation or tBattleType == BattleType.ELITE_FIGHT_MAIL or tBattleType == BattleType.Road then
    if self._otherInfo.allianceInfo ~= nil then
      local alAbbr = self._otherInfo.allianceInfo.alAbbr or ""
      return alAbbr
    end
  else
    return ""
  end
end

function MailBattleOneRound:GetTargetPos()
  local tBattleType = self:GetTargetBattleType()
  if tBattleType == BattleType.Building or tBattleType == BattleType.City or tBattleType == BattleType.Turret or tBattleType == BattleType.Formation or tBattleType == BattleType.Road or tBattleType == BattleType.ELITE_FIGHT_MAIL or tBattleType == BattleType.RallyFormation then
    return self._otherInfo.pointId
  else
    return self._otherArmyResult and self._otherArmyResult:GetPointId() or 0
  end
end

function MailBattleOneRound:GetTargetInfo()
  local tBattleType = self:GetTargetBattleType()
  if tBattleType == BattleType.Building or tBattleType == BattleType.City or tBattleType == BattleType.Turret or tBattleType == BattleType.Formation or tBattleType == BattleType.Road or tBattleType == BattleType.ELITE_FIGHT_MAIL or tBattleType == BattleType.RallyFormation then
    return self._otherInfo
  else
    return self._otherArmyResult and self._otherArmyResult:GetInfo() or {}
  end
end

function MailBattleOneRound:GetRoundCnt()
  return 1
end

function MailBattleOneRound:GetAllMembers(isMySide, isBefore)
  local armyResult = isMySide and self._selfArmyResult or self._otherArmyResult
  return armyResult:GetAllMembers(isBefore)
end

function MailBattleOneRound:GetDestroyValue(isMySide)
  local armyResult = isMySide and self._selfArmyResult or self._otherArmyResult
  return armyResult:GetDestroyValue()
end

function MailBattleOneRound:GetTroopHealth(isMySide)
  local armyResult = isMySide and self._selfArmyResult or self._otherArmyResult
  return armyResult:GetHealth()
end

function MailBattleOneRound:GetHeroSpecialSkillList(isMySide)
  local armyResult = isMySide and self._selfArmyResult or self._otherArmyResult
  return armyResult:GetHeroSpecialSkillList()
end

function MailBattleOneRound:InitVsMap(isChampionBattle)
  self._vsMap = {}
  local sBattleType = self:GetSelfBattleType()
  local tBattleType = self:GetTargetBattleType()
  if self._selfArmyResult ~= nil and self._otherArmyResult ~= nil then
    local selfUuidList = self._selfArmyResult:GetAllMembersUuidList()
    local otherUuidList = self._otherArmyResult:GetAllMembersUuidList()
    local selfResult = self._selfArmyResult:GetDamagePercentInfo()
    local otherResult = self._otherArmyResult:GetDamagePercentInfo()
    for a, b in pairs(selfUuidList) do
      for c, d in pairs(otherUuidList) do
        local hasGet = false
        if isChampionBattle == true or sBattleType == BattleType.Building or sBattleType == BattleType.City or sBattleType == BattleType.Turret or tBattleType == BattleType.Building or tBattleType == BattleType.City or tBattleType == BattleType.Turret then
          hasGet = true
        end
        if hasGet == false and selfResult ~= nil and selfResult[b] ~= nil and selfResult[b][d] ~= nil then
          hasGet = true
        end
        if hasGet == false and otherResult ~= nil and otherResult[d] ~= nil and otherResult[d][b] ~= nil then
          hasGet = true
        end
        if hasGet == true then
          if self._vsMap[b] == nil then
            self._vsMap[b] = {}
          end
          self._vsMap[b][d] = 1
        end
      end
    end
  end
end

function MailBattleOneRound:GetVsMap()
  return self._vsMap
end

function MailBattleOneRound:GetLeaderUuid(isMySide)
  local leaderInfo = isMySide and self._selfInfo or self._otherInfo
  local armyResult = isMySide and self._selfArmyResult or self._otherArmyResult
  local uid = leaderInfo.uid
  return armyResult:GetUuidInMembersByUid(uid)
end

function MailBattleOneRound:GetMemberPlayerInfoByUuid(uuid, targetUuid, isMySide)
  local oneData = {}
  local armyResult = isMySide and self._selfArmyResult or self._otherArmyResult
  local battleType = isMySide and self:GetSelfBattleType() or self:GetTargetBattleType()
  local armyObj = armyResult:GetArmyObj()
  local afterArmyObj = armyResult:GetAfterArmyObj()
  oneData.name = armyResult:GetName()
  oneData.pic = armyResult:GetPic()
  oneData.battleType = battleType
  oneData.specialType = SpecialUnitType.NONE
  oneData.buildId = 0
  if battleType == BattleType.Building then
    oneData.buildId = armyResult:GetBuildId()
  elseif battleType == BattleType.Monster then
    oneData.monsterId = armyResult._monsterId
  end
  oneData.selfInMemberUuid = armyResult:GetUuidInMembersByUid(LuaEntry.Player.uid)
  oneData.leaderUuid = self:GetLeaderUuid(isMySide)
  if armyObj ~= nil then
    local members = armyObj:GetAllMembers()
    for k, v in pairs(members) do
      if v:GetMarchId() == uuid then
        oneData.unitData = v
      end
    end
  end
  if afterArmyObj ~= nil then
    local members = afterArmyObj:GetAllMembers()
    for k, v in pairs(members) do
      if v:GetMarchId() == uuid then
        oneData.afterUnitData = v
      end
    end
  end
  if oneData.unitData ~= nil then
    oneData.specialType = oneData.unitData:GetSpecialType()
  end
  oneData.unitAttrInfo = self:GetUnitAttrInfoByUuid(uuid)
  local damagePercent = armyResult:GetDamagePercentInfo()
  if damagePercent ~= nil and damagePercent[uuid] ~= nil then
    oneData.damagePercent = damagePercent[uuid][targetUuid]
  end
  return oneData
end

return MailBattleOneRound
