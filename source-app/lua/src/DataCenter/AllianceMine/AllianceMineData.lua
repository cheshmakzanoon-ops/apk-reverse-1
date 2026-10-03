local AllianceMineData = BaseClass("AllianceMineData")

function AllianceMineData:__init()
  self.uuid = 0
  self.buildId = 0
  self.status = AllianceMineStatus.Normal
  self.pointId = 0
  self.level = 0
  self.alAbbr = ""
  self.alName = ""
  self.flag = ""
  self.allianceId = ""
  self.durability = 0
  self.lastBuildTime = 0
  self.buildSpeed = 0
  self.soldierNum = 0
  self.soldierMax = 0
  self.initNum = 1
  self.remainNum = 0
  self.collectSpeed = 0
  self.expireTime = 0
  self.srcServerId = 0
  self.curServerId = 0
  self.posV2 = {}
  self.posV2.x = 0
  self.posV2.y = 0
  self.battleStartTime = 0
  self.curRound = 0
  self.maxRound = 0
  self.reward = {}
end

function AllianceMineData:__delete()
  self.uuid = nil
  self.buildId = nil
  self.status = nil
  self.pointId = nil
  self.level = nil
  self.alAbbr = nil
  self.allianceId = nil
  self.durability = nil
  self.lastBuildTime = nil
  self.buildSpeed = nil
  self.soldierNum = nil
  self.soldierMax = nil
  self.initNum = nil
  self.remainNum = nil
  self.collectSpeed = nil
  self.expireTime = nil
  self.battleStartTime = nil
  self.curRound = nil
  self.maxRound = nil
  self.reward = nil
end

function AllianceMineData:ParseData(message)
  if message == nil then
    return
  end
  if message.uuid then
    self.uuid = message.uuid
  end
  if message.buildId then
    self.buildId = message.buildId
  end
  if message.status then
    self.status = message.status
  end
  if message.pointId then
    self.pointId = message.pointId
    self.posV2 = SceneUtils.IndexToTilePos(self.pointId, ForceChangeScene.World)
  else
    self.posV2 = Vector2.New(0, 0)
  end
  if message.level then
    self.level = message.level
  end
  if message.alAbbr then
    self.alAbbr = message.alAbbr
  end
  if message.alName then
    self.alName = message.alName
  end
  if message.icon then
    self.flag = message.icon
  end
  if message.allianceId then
    self.allianceId = message.allianceId
  end
  if message.durability then
    self.durability = message.durability
  end
  if message.lastBuildTime then
    self.lastBuildTime = message.lastBuildTime
  end
  if message.buildSpeed then
    self.buildSpeed = message.buildSpeed
  end
  if message.soldierNum then
    self.soldierNum = message.soldierNum
  end
  if message.soldierMax then
    self.soldierMax = message.soldierMax
  end
  if message.initNum then
    self.initNum = message.initNum
  end
  if message.remainNum then
    self.remainNum = message.remainNum
  end
  if message.collectSpeed then
    self.collectSpeed = message.collectSpeed
  end
  if message.expireTime then
    self.expireTime = message.expireTime
  end
  if message.srcServer then
    self.srcServerId = message.srcServer
  end
  if message.serverId then
    self.curServerId = message.serverId
  end
  if message.battleStartTime then
    self.battleStartTime = message.battleStartTime
  end
  if message.curRound then
    self.curRound = message.curRound
  end
  if message.maxRound then
    self.maxRound = message.maxRound
  end
  if message.reward then
    self.reward = DataCenter.RewardManager:ReturnRewardParamForMessage(message.reward)
  end
  local templateId = self.buildId
  local level = toInt(self.level)
  if self.buildId ~= BuildingTypes.LW_ALLIANCE_WAR_CAMP_2 then
    templateId = templateId + level
  end
  local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(templateId)
  if template == nil then
    template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(self.buildId)
  end
  if template == nil then
    self.maxHp = toInt(GetTableData(TableName.AllianceMine, self.buildId, "res_durable"))
  else
    self.maxHp = toInt(template.resDurable)
  end
end

function AllianceMineData:GetConstructDurability()
  if WorldAllianceBuildUtil.IsAllianceMineGroup(self.buildId) == true and self.status == AllianceMineStatus.Constructing then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local temp = self.durability + (curTime - self.lastBuildTime) / 1000 * self.buildSpeed
    return temp
  end
  return self:GetDurability()
end

function AllianceMineData:GetAllianceCenterDurability()
  return self:GetDurability()
end

function AllianceMineData:GetAllianceFrontDurability()
  return self:GetDurability()
end

function AllianceMineData:GetDurability()
  if self.status == AllianceMineStatus.Ruin then
    return 0
  end
  if self.buildSpeed == 0 or self.durability >= self.maxHp then
    return self.durability
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  return math.min(self.maxHp, self.durability + (curTime - self.lastBuildTime) / 1000 * self.buildSpeed)
end

function AllianceMineData:IsInZone(cityId)
  if self.pointId then
    local zoneId = SceneUtils.GetZoneIdByPosId(self.pointId)
    return toInt(cityId) == zoneId
  end
  return false
end

function AllianceMineData:GetBuildEndTime()
  if self.status == AllianceMineStatus.Ruin then
    return 0
  end
  if self.lastBuildTime == 0 or self.durability >= self.maxHp then
    return 0
  end
  local buildSpeed = toInt(self.buildSpeed)
  if buildSpeed == 0 then
    return UITimeManager:GetInstance():GetNextDayMs()
  end
  return (self.maxHp - self.durability) * 1000 / self.buildSpeed + self.lastBuildTime
end

function AllianceMineData:GetHPRate()
  local maxHp = toInt(self.maxHp)
  if maxHp <= 0 then
    return 0
  end
  return math.min(self:GetDurability() / maxHp, 1)
end

function AllianceMineData:Injuried()
  if self.status == AllianceMineStatus.Ruin then
    return true
  end
  return self:GetDurability() < toInt(self.maxHp)
end

function AllianceMineData:JumpTo()
  local serverId = self.srcServerId or self.curServerId or LuaEntry.Player:GetSourceServerId()
  local v3 = SceneUtils.TileIndexToWorld(self.pointId, ForceChangeScene.World)
  GoToUtil.CloseAllWindows()
  GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
  end, serverId, 0)
end

function AllianceMineData:GetZoneId()
  if self.pointId then
    return SceneUtils.GetZoneIdByPosId(self.pointId)
  end
  return 0
end

function AllianceMineData:GetWorldPos()
  local serverId = self.srcServerId or self.curServerId
  local v3 = SceneUtils.TileIndexToWorld(self.pointId, ForceChangeScene.World)
  if serverId ~= nil then
    local x, y, z = SceneUtils.GetNinePalacesOffset(serverId)
    if x ~= nil and z ~= nil then
      return Vector3.New(v3.x + x, v3.y + y, v3.z + z)
    end
  end
  return v3
end

return AllianceMineData
