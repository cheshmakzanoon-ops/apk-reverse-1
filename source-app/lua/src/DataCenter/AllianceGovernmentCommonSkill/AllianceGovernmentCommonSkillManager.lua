local AllianceGovernmentCommonSkillManager = BaseClass("AllianceGovernmentCommonSkillManager")
local AllianceGovernmentCommonSkill = require("DataCenter.AllianceGovernmentCommonSkill.AllianceGovernmentCommonSkill")
local AllianceGovernmentCommonEnergy = require("DataCenter.AllianceGovernmentCommonSkill.AllianceGovernmentCommonEnergy")

function AllianceGovernmentCommonSkillManager:__init()
  self.skillList = {}
  self.skill2IdMap = {}
  self.energy = AllianceGovernmentCommonEnergy.New()
  self.chargeData = nil
end

function AllianceGovernmentCommonSkillManager:__delete()
  self.skillList = nil
  self.skill2IdMap = nil
  self.energy = nil
  self.chargeData = nil
end

function AllianceGovernmentCommonSkillManager:InitData()
  if self:IsOpen() then
    SFSNetwork.SendMessage(MsgDefines.AllianceSkillEnergyGetInfo)
    SFSNetwork.SendMessage(MsgDefines.AllianceGovernmentSkillGetList)
  end
end

function AllianceGovernmentCommonSkillManager:InitTemplates()
  if table.count(self.skillList) > 0 then
    return
  end
  local config = DataCenter.SeasonDataManager:GetSeasonConfig()
  if config == nil or string.IsNullOrEmpty(config.alliance_skill) then
    return
  end
  local skillList = string.split(config.alliance_skill, "|")
  local skillMap = {}
  self.skill2IdMap = {}
  for _, skillId in ipairs(skillList) do
    local skillConfig = DataCenter.AllianceGovernmentSkillManager:GetTemplatesById(skillId)
    local tempId = skillMap[skillConfig.skill_flag]
    if tempId == nil then
      skillMap[skillConfig.skill_flag] = skillId
    elseif skillId < tempId then
      skillMap[skillConfig.skill_flag] = skillId
    end
    self.skill2IdMap[skillId] = skillConfig
  end
  for flag, skillId in pairs(skillMap) do
    local commonSkill = AllianceGovernmentCommonSkill.New()
    commonSkill:BindSkillId(skillId)
    self.skillList[flag] = commonSkill
  end
end

function AllianceGovernmentCommonSkillManager:UseSkill(skillFlag, pointId, targetUuid)
  local commonSkill = self:GetSkillBySkillFlag(skillFlag)
  commonSkill:UseSkill(pointId, 0, targetUuid)
end

function AllianceGovernmentCommonSkillManager:ReqAllianceGovernmentSkillList(message)
  local skillList = message.skillList
  local officialList = message.officialList
  local officialMap = {}
  if officialList then
    for _, v in pairs(officialList) do
      officialMap[v.type] = v
    end
  end
  local needUpdateOfficial = false
  if skillList then
    for k, v in pairs(self.skillList) do
      v:Clear()
    end
    for _, v in ipairs(skillList) do
      local skillConfig = DataCenter.AllianceGovernmentSkillManager:GetTemplatesById(v.skillId)
      local commonSkill = self:GetSkillBySkillFlag(skillConfig.skill_flag)
      if commonSkill == nil then
        commonSkill = AllianceGovernmentCommonSkill.New()
        self.skillList[skillConfig.skill_flag] = commonSkill
      end
      commonSkill:BindSkillId(v.skillId)
      commonSkill:ParseServer(v)
    end
    needUpdateOfficial = true
  end
  for _, v in pairs(self.skillList) do
    local change = v:BindOfficial(officialMap)
    if change then
      needUpdateOfficial = true
    end
  end
  if needUpdateOfficial then
    EventManager:GetInstance():Broadcast(EventId.UpdateAllianceGovernmentCommonSkillList)
  end
end

function AllianceGovernmentCommonSkillManager:ReqSkillEnergyGetInfo(message)
  self.energy:ParseServer(message)
end

function AllianceGovernmentCommonSkillManager:IsOpen()
  local inSeason = SeasonUtil.IsInSeason()
  if inSeason then
    local config = DataCenter.SeasonDataManager:GetSeasonConfig()
    if config then
      return not string.IsNullOrEmpty(config.alliance_skill)
    end
  end
  return false
end

function AllianceGovernmentCommonSkillManager:GetSkillBySkillFlag(flag)
  return self.skillList[flag]
end

function AllianceGovernmentCommonSkillManager:GetSkillListByType(type)
  local result = {}
  for _, v in pairs(self.skillList) do
    if v.config.type == type then
      table.insert(result, v)
    end
  end
  return result
end

function AllianceGovernmentCommonSkillManager:GetSkillList(ignoreType)
  local list = {}
  for _, v in pairs(self.skillList) do
    if ignoreType == nil or v.config.skill_flag ~= ignoreType then
      table.insert(list, v)
    end
  end
  table.sort(list, function(a, b)
    return tonumber(a.skillId) < tonumber(b.skillId)
  end)
  return list
end

function AllianceGovernmentCommonSkillManager:GetSkillById(skillId)
  if self.skillList == nil then
    return nil
  end
  for _, v in pairs(self.skillList) do
    if v.config and v.config.id == skillId then
      return v
    end
  end
  return nil
end

function AllianceGovernmentCommonSkillManager:GetEnergyInfo()
  return self.energy
end

function AllianceGovernmentCommonSkillManager:IsGovernmentCommonSkill(skillId, exist)
  if skillId == nil or skillId == 0 or skillId == "" then
    return false
  end
  if self.skill2IdMap then
    if self.skill2IdMap[tostring(skillId)] == nil then
    end
    local isTargetSkill = true
    if not exist then
      return isTargetSkill
    end
    if isTargetSkill then
      local config = DataCenter.AllianceGovernmentSkillManager:GetTemplatesById(skillId)
      local skill = self:GetSkillBySkillFlag(config.skill_flag)
      return skill ~= nil
    end
  end
  return false
end

function AllianceGovernmentCommonSkillManager:GetSkillLevelConfig()
  local skillLevelConfig = LuaEntry.DataConfig:TryGetStr("season_s6_alliance_skill_fish", "k5")
  local skillLevelConfigStr = string.split(skillLevelConfig, "|")
  local levelExtra = {
    [1] = {levelStr = "S", icon = ""},
    [2] = {levelStr = "A", icon = ""},
    [3] = {levelStr = "B", icon = ""},
    [4] = {levelStr = "C", icon = ""},
    [5] = {levelStr = "D", icon = ""}
  }
  local length = #skillLevelConfigStr
  for index = length, 0, -1 do
    local opIndex = length - index + 1
    local downValue = 0
    local upValue = 0
    if index == length then
      downValue = skillLevelConfigStr[index]
      upValue = downValue .. "+"
    elseif index == 0 then
      downValue = "0"
      upValue = skillLevelConfigStr[index + 1]
    else
      downValue = skillLevelConfigStr[index]
      upValue = skillLevelConfigStr[index + 1]
    end
    levelExtra[opIndex].downValue = downValue
    levelExtra[opIndex].upValue = upValue
  end
  return levelExtra
end

function AllianceGovernmentCommonSkillManager:HandleChargeCount(chargeData)
  self.chargeData = chargeData
  EventManager:GetInstance():Broadcast(EventId.RefreshReinforcementChargeCount)
end

function AllianceGovernmentCommonSkillManager:GetChargeData()
  return self.chargeData
end

function AllianceGovernmentCommonSkillManager:CheckCntInSkillRange(pointId, serverId, effectScope, mainRange)
  local points = {}
  local cnt = 0
  local theWorld = CS.SceneManager.World
  if theWorld ~= nil and CS.SceneManager:IsInWorld() then
    local cityList = theWorld:GetAllMainBaseList()
    if cityList == nil then
      return cnt, points
    end
    local myUid = LuaEntry.Player:GetUid()
    for _, v in pairs(cityList) do
      local cityCampId = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(v.srcServerId)
      local bEnemy = v.ownerUid ~= myUid and cityCampId ~= DataCenter.SeasonFactionWarDataManager.myCampId
      if bEnemy and v.ownerUid ~= myUid then
        local check, targetWorldPos = self:CheckDistanceInEffectScope(pointId, v.mainIndex, v.serverId, effectScope, serverId)
        if check then
          points[v.ownerUid] = {
            pointId = v.mainIndex,
            serverId = v.serverId,
            worldPos = targetWorldPos
          }
          cnt = cnt + 1
        end
      end
    end
  end
  return cnt, points
end

function AllianceGovernmentCommonSkillManager:CheckDistanceInEffectScope(selfPoint, pointIndex, serverId, effectScope, theServerId)
  if serverId ~= theServerId then
    return false
  end
  local selfTilePos = SceneUtils.IndexToTilePos(selfPoint, ForceChangeScene.World)
  local tarTilePos = SceneUtils.IndexToTilePos(pointIndex, ForceChangeScene.World)
  local xOffset = math.abs(selfTilePos.x - tarTilePos.x)
  local yOffset = math.abs(selfTilePos.y - tarTilePos.y)
  return effectScope >= xOffset and effectScope >= yOffset
end

function AllianceGovernmentCommonSkillManager:HasSkill()
  if not self.skill2IdMap or table.count(self.skill2IdMap) <= 0 then
    return false
  end
  for _, v in pairs(self.skill2IdMap) do
    if v.prerequisites_effect then
      local effectValue = LuaEntry.Effect:GetGameEffect(v.prerequisites_effect)
      if 0 < effectValue then
        return true
      end
    end
  end
  return false
end

function AllianceGovernmentCommonSkillManager:GetRedPointNum()
  if not DataCenter.AllianceGovernmentCommonSkillManager:IsOpen() then
    return 0
  end
  local season = CS.GameEntry.Setting:GetPrivateInt("LW_Alliance_GETREDDOT_SEASON", -1)
  local seasonType = SeasonUtil.GetSeasonType(false, true, ServerEnum.Login)
  if season == seasonType then
    return 0
  end
  local canShowRed = self:HasSkill()
  return canShowRed and 1 or 0
end

function AllianceGovernmentCommonSkillManager:ClearRed()
  local seasonType = SeasonUtil.GetSeasonType(false, true, ServerEnum.Login)
  CS.GameEntry.Setting:SetPrivateInt("LW_Alliance_GETREDDOT_SEASON", checknumber(seasonType))
end

return AllianceGovernmentCommonSkillManager
