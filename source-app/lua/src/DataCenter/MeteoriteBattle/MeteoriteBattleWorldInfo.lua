local MeteoriteBattleWorldInfo = BaseClass("MeteoriteBattleWorldInfo")

function MeteoriteBattleWorldInfo:__init()
end

function MeteoriteBattleWorldInfo:__delete()
end

function MeteoriteBattleWorldInfo:Init(serverId, pointIndex, hSize, lSize, startTime, endTime, groupServer)
  self.serverId = serverId
  self.pointIndex = pointIndex
  self.centerPos = SceneUtils.IndexToTilePos(pointIndex, ForceChangeScene.World)
  self.hSize = hSize
  self.lSize = lSize
  self.highRange = {
    minX = self.centerPos.x - hSize,
    maxX = self.centerPos.x + hSize,
    minY = self.centerPos.y - hSize,
    maxY = self.centerPos.y + hSize
  }
  self.lowRange = {
    minX = self.centerPos.x - lSize - hSize,
    maxX = self.centerPos.x + lSize + hSize,
    minY = self.centerPos.y - lSize - hSize,
    maxY = self.centerPos.y + lSize + hSize
  }
  self.groupServer = {}
  if groupServer then
    for k, v in pairs(groupServer) do
      self.groupServer[v] = true
    end
  end
  self.startTime = startTime
  self.endTime = endTime
end

function MeteoriteBattleWorldInfo:RefreshByMsg(msg)
  self.stage = msg.stage or 0
  self.crystal = msg.crystal or 0
  self.nucleus = msg.nucleus or 0
end

function MeteoriteBattleWorldInfo:RefreshStage(stage)
end

function MeteoriteBattleWorldInfo:CheckServerInGroup(serverId)
  return self.groupServer[serverId]
end

function MeteoriteBattleWorldInfo:CheckHighArea()
  local selfPos = SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)
  return selfPos.x <= self.highRange.maxX and selfPos.x >= self.highRange.minX and selfPos.y <= self.highRange.maxY and selfPos.y >= self.highRange.minY
end

function MeteoriteBattleWorldInfo:CheckLowArea()
  if self:CheckHighArea() then
    return false
  end
  local selfPos = SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)
  return selfPos.x <= self.lowRange.maxX and selfPos.x >= self.lowRange.minX and selfPos.y <= self.lowRange.maxY and selfPos.y >= self.lowRange.minY
end

function MeteoriteBattleWorldInfo:CheckPointIndex(pointIndex)
  local pos = SceneUtils.IndexToTilePos(pointIndex, ForceChangeScene.World)
  local inHigh = pos.x <= self.highRange.maxX and pos.x >= self.highRange.minX and pos.y <= self.highRange.maxY and pos.y >= self.highRange.minY
  if inHigh then
    return true, false
  else
    local inLow = pos.x <= self.lowRange.maxX and pos.x >= self.lowRange.minX and pos.y <= self.lowRange.maxY and pos.y >= self.lowRange.minY
    return inHigh, inLow
  end
end

function MeteoriteBattleWorldInfo:CheckServerPointIndex(serverId, pointIndex)
  if serverId ~= self.serverId then
    return false
  end
  if self.stage ~= MeteoriteState.GRAB then
    return false
  end
  return self:CheckPointIndex(pointIndex)
end

function MeteoriteBattleWorldInfo:Description()
  local sb = StringBuilder.New()
  local selfPos = SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)
  sb:AppendFormatLine("serverId : %s[\229\189\147\229\137\141\232\167\130\231\156\139\230\156\141:%s]", self.serverId, LuaEntry.Player:GetCurServerId())
  sb:AppendFormatLine("pointIndex : %s", self.pointIndex)
  sb:AppendFormatLine("stage : %s", self.stage)
  sb:AppendFormatLine("[\228\184\141\229\143\175\233\157\160]crystal : %s", self.crystal)
  sb:AppendFormatLine("[\228\184\141\229\143\175\233\157\160]nucleus : %s", self.nucleus)
  sb:AppendFormatLine("centerPos : %s,%s; \229\189\147\229\137\141\228\184\187\229\159\142[%s,%s]", self.centerPos.x, self.centerPos.y, selfPos.x, selfPos.y)
  sb:AppendFormatLine("\233\187\145\229\156\159\229\156\176\229\176\186\229\175\184(hSize) : %s", self.hSize)
  sb:AppendFormatLine("\233\187\132\229\156\159\229\156\176\229\176\186\229\175\184(lSize): %s", self.lSize)
  sb:AppendFormatLine("highRange : x = %s ~ %s, y = %s ~ %s", self.highRange.minX, self.highRange.maxX, self.highRange.minY, self.highRange.maxY)
  sb:AppendFormatLine("lowRange : x = %s ~ %s, y = %s ~ %s", self.lowRange.minX, self.lowRange.maxX, self.lowRange.minY, self.lowRange.maxY)
  sb:AppendFormatLine("startTime : %s[%s]", os.date("%Y-%m-%d %H:%M:%S", self.startTime), self.startTime)
  sb:AppendFormatLine("endTime : %s[%s]", os.date("%Y-%m-%d %H:%M:%S", self.endTime), self.endTime)
  sb:AppendFormatLine("\229\156\168\233\187\145\229\156\159\229\156\176\228\184\138? : %s", self:CheckHighArea())
  sb:AppendFormatLine("\229\156\168\233\187\132\229\156\159\229\156\176\228\184\138? : %s", self:CheckLowArea())
  local _s = ""
  for k, v in pairs(self.groupServer) do
    _s = _s .. (_s == "" and k or "," .. k)
  end
  sb:AppendFormatLine("\230\180\187\229\138\168\230\156\141\229\138\161\229\153\168:%s[\230\136\145\231\154\132\230\156\141\229\138\161\229\153\168:%s]", _s, LuaEntry.Player:GetSourceServerId())
  return sb:ToString()
end

return MeteoriteBattleWorldInfo
