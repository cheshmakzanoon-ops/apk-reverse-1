local LWZombieRushPlanInfoManager = BaseClass("LWZombieRushPlanInfoManager")

function LWZombieRushPlanInfoManager:__init()
  self.id = 0
  self.operateType = -2
  self.planTimeStamp = 0
  self.operateRoleInfo = 0
  self.planLevel = 0
  self.setPlanLevel = 0
  self.canBeAttackUserInfo = {}
  self.planLevelInfo = ""
  self.planLevelInfoList = {}
  self.nowSelectPlanTime = 0
  self.canBeAttackUserCount = 0
  self.recentCountList = ""
  self.playerCountList = {}
  self.needLevelRoleCount = true
  self:AddListener()
end

function LWZombieRushPlanInfoManager:GetPlanId()
  return self.id
end

function LWZombieRushPlanInfoManager:GetPlanLevel()
  return self.planLevel
end

function LWZombieRushPlanInfoManager:SetNowPlanLevel(level)
  self.setPlanLevel = level
end

function LWZombieRushPlanInfoManager:GetNowPlanLevel()
  return self.setPlanLevel
end

function LWZombieRushPlanInfoManager:SetPlanTime(time)
  self.nowSelectPlanTime = time
end

function LWZombieRushPlanInfoManager:GetPlanTime()
  return self.nowSelectPlanTime
end

function LWZombieRushPlanInfoManager:GetPlanTimeStamp()
  return self.planTimeStamp
end

function LWZombieRushPlanInfoManager:GetCanAttendPlayerList()
  return self.canBeAttackUserInfo
end

function LWZombieRushPlanInfoManager:GetCanAttendPlayerListCount()
  return self.canBeAttackUserCount
end

function LWZombieRushPlanInfoManager:GetHistortPlanLevelInfo()
  if self.planLevelInfo == nil or self.planLevelInfo == "" then
    return nil
  else
    local count = 0
    for _ in pairs(self.planLevelInfoList) do
      count = count + 1
      break
    end
    if count == 0 then
      self.planLevelInfoList = LWZombieRushPlanInfoManager:ParseKeyValueString(self.planLevelInfo)
    end
  end
  return self.planLevelInfoList
end

function LWZombieRushPlanInfoManager:GetDefaultPlayerList()
  if self.recentCountList == nil or self.recentCountList == "" then
    return nil
  else
    local count = 0
    for _ in pairs(self.playerCountList) do
      count = count + 1
      break
    end
    if count == 0 then
      self.playerCountList = LWZombieRushPlanInfoManager:ParseKeyValueString(self.recentCountList)
    end
  end
  return self.playerCountList
end

function LWZombieRushPlanInfoManager:ParseKeyValueString(input)
  local result = {}
  for _, pair in ipairs(string.split(input, ";")) do
    local keyValue = string.split(pair, ":")
    if #keyValue == 2 then
      local key, value = keyValue[1], keyValue[2]
      result[key] = value
    else
      Logger.LogError("Invalid input format: " .. pair)
    end
  end
  return result
end

function LWZombieRushPlanInfoManager:__delete()
  self.operateType = nil
  self.planTimeStamp = nil
  self.operateRoleInfo = nil
  self.planLevel = nil
  self.canBeAttackUserInfo = nil
  self.planLevelInfo = nil
  self.planLevelInfoList = nil
  self.nowSelectPlanTime = nil
  self.canBeAttackUserCount = nil
  self.id = nil
  self.setPlanLevel = nil
  self.recentCountList = nil
  self.playerCountList = nil
  self.needLevelRoleCount = nil
  self:RemoveListener()
end

function LWZombieRushPlanInfoManager:AddListener()
end

function LWZombieRushPlanInfoManager:RemoveListener()
end

function LWZombieRushPlanInfoManager:SendMsgZombieRushActSetPlanInfo(Id, longTime, planLevel)
  SFSNetwork.SendMessage(MsgDefines.ZombieRushActSetPlanInfo, Id, longTime, planLevel)
end

function LWZombieRushPlanInfoManager:SendMsgZombieRushActDeletePlanInfo(id)
  SFSNetwork.SendMessage(MsgDefines.ZombieRushActDeletePlanInfo, id)
  UIUtil.ShowTipsId("zombierush_plan_tips_03")
end

function LWZombieRushPlanInfoManager:SendMsgZombieRushSetLevel(id, level)
  SFSNetwork.SendMessage(MsgDefines.ZombieRushActSetPlanLevelInfo, id, level)
end

function LWZombieRushPlanInfoManager:SendMsgZombieRushGetHistorySetInfo(allianceId)
  if DataCenter.LWZombieRushManager:CheckZombiePlanOpen() then
    if self.needLevelRoleCount == nil then
      self.needLevelRoleCount = true
    end
    SFSNetwork.SendMessage(MsgDefines.ZombieRushActPlanInfo, allianceId, self.needLevelRoleCount)
  end
end

function LWZombieRushPlanInfoManager:SetNeedLevelRoleCountValue(value)
  self.needLevelRoleCount = value
end

function LWZombieRushPlanInfoManager:SendMsgZombieRushGetPlayerList(id, allianceId)
  SFSNetwork.SendMessage(MsgDefines.ZombieRushActGetPlayerListInfo, id, allianceId)
end

function LWZombieRushPlanInfoManager:UpdateActInfo(message)
  if message.id then
    self.id = message.id
  end
  if message.operateType then
    self.operateType = message.operateType
  end
  if message.planTimeStamp then
    self.planTimeStamp = message.planTimeStamp
  end
  if message.operateRoleInfo then
    self.operateRoleInfo = message.operateRoleInfo
  end
  if message.planLevel then
    self.planLevel = message.planLevel
  end
  if message.canBeAttackUserInfo then
    self.canBeAttackUserInfo = message.canBeAttackUserInfo
  end
  if message.planLevelInfo then
    self.planLevelInfo = message.planLevelInfo
  end
  if message.canBeAttackUserCount then
    self.canBeAttackUserCount = message.canBeAttackUserCount
  end
  if message.recentCountList then
    self.recentCountList = message.recentCountList
  end
end

function LWZombieRushPlanInfoManager:UpdatePlanInfo(message)
  if message.id then
    self.planLevelId = message.id
  end
  if message.planLevel then
    self.planLevel = message.planLevel
  end
  if message.canBeAttackUserCount then
    self.canBeAttackUserCount = message.canBeAttackUserCount
  end
  self.planLevelInfoList[tostring(self.planLevelId)] = tostring(self.planLevel)
  for k, v in pairs(self.playerCountList) do
    if k == tostring(self.planLevelId) then
      self.playerCountList[tostring(self.planLevelId)] = self.canBeAttackUserCount
      break
    end
  end
end

return LWZombieRushPlanInfoManager
