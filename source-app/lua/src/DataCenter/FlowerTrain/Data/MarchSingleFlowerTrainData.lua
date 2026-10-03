local BaseSingleFlowerTrainData = require("DataCenter.FlowerTrain.Data.BaseSingleFlowerTrainData")
local base = BaseSingleFlowerTrainData
local MarchSingleFlowerTrainData = BaseClass("MarchSingleFlowerTrainData", BaseSingleFlowerTrainData)
local FlowerTrainConstant = require("DataCenter.FlowerTrain.FlowerTrainConstant")
local Localization = CS.GameEntry.Localization
local FAR_AWAY = Vector3.New(10000, 10000, 10000)

function MarchSingleFlowerTrainData:__init()
end

function MarchSingleFlowerTrainData:__delete()
end

function MarchSingleFlowerTrainData:UpdateData(index, serverData, marchInfo)
  self.marchInfo = marchInfo
  base.UpdateData(self, serverData)
  self.index = index
  self.nextNextStation = marchInfo.preStation or nil
  self.startTime = marchInfo.startTime
  self.endTime = marchInfo.endTime
  self.startPointId = marchInfo.startPos
  self.endPointId = marchInfo.targetPos
  self.startWorldPos = SceneUtils.TileIndexToWorld(self.startPointId)
  self.startWorldPos = Vector3.New(self.startWorldPos.x, self.startWorldPos.y, self.startWorldPos.z)
  self.endWorldPos = SceneUtils.TileIndexToWorld(self.endPointId)
  self.endWorldPos = Vector3.New(self.endWorldPos.x, self.endWorldPos.y, self.endWorldPos.z)
  self.speed = marchInfo.speed * TileSize
  self.pathList = marchInfo.pathList
end

function MarchSingleFlowerTrainData:IsFirstCar()
  return self.index == 1
end

function MarchSingleFlowerTrainData:CheckAndGetHistoryStationList()
  self.historyStationList = self.marchInfo.historyStationList or {}
end

function MarchSingleFlowerTrainData:GetPrefabPath()
  if not self.fromGoodsId then
    Logger.LogError("SingleFlowerTrainData:GetPrefabPath fromGoodsId is nil")
    return ""
  end
  return FlowerTrainUtils.GetFlowerTrainPrefabPathByGoodsId(self.fromGoodsId, self.lv)
end

function MarchSingleFlowerTrainData:GetMarchCurPos()
  if not self.marchInfo then
    return FAR_AWAY
  end
  local serverNow = UITimeManager:GetInstance():GetServerTime()
  local curPathLen = (serverNow - self.sendTime) * self.speed * 0.001
  curPathLen = curPathLen - (self.index - 1) * FlowerTrainConstant.FlowerTrainSize
  local pathSegment = self:CreatePathSegment()
  if not pathSegment then
    return FAR_AWAY
  end
  local curPosition, dir = self:CalcMoveStateOnPath(pathSegment, 1, curPathLen)
  return curPosition, dir
end

function MarchSingleFlowerTrainData:CreatePathSegment()
  if not self.marchInfo then
    return nil
  end
  local path = self.marchInfo.path
  if path.Length < 2 then
    return nil
  end
  local newPath = {}
  for i = 0, path.Length - 1 do
    table.insert(newPath, path[i])
  end
  local pathList = {}
  for i = 1, #newPath do
    pathList[i] = {}
    if i < #newPath then
      local curPos = SceneUtils.TileIndexToWorld(newPath[i], ForceChangeScene.World)
      local nextPos = SceneUtils.TileIndexToWorld(newPath[i + 1], ForceChangeScene.World)
      local pathVec = Vector3.New(nextPos.x - curPos.x, nextPos.y - curPos.y, nextPos.z - curPos.z)
      pathList[i].pos = curPos
      pathList[i].dir = Vector3.Normalize(pathVec)
      pathList[i].dist = Vector3.Magnitude(pathVec)
    else
      pathList[i].pos = SceneUtils.TileIndexToWorld(newPath[i], ForceChangeScene.World)
      pathList[i].dir = pathList[i - 1].dir
      pathList[i].dist = LongMaxValue
    end
  end
  return pathList
end

function MarchSingleFlowerTrainData:CalcMoveStateOnPath(path, startIndex, startPathLen)
  local pathIdx = startIndex
  local pathLen = startPathLen
  local pos, dir
  while pathIdx < #path and pathLen > path[pathIdx].dist do
    pathLen = pathLen - path[pathIdx].dist
    pathIdx = pathIdx + 1
  end
  if pathIdx <= #path then
    pos = path[pathIdx].pos + path[pathIdx].dir * pathLen
    dir = path[pathIdx].dir
  else
    pos = path[#path].pos
    dir = path[#path].dir
  end
  return pos, dir
end

function MarchSingleFlowerTrainData:GetCurMarchPointId()
  if self.marchInfo == nil then
    return base:GetCurMarchPointId()
  end
  local curWorldPos = self.marchInfo:GetMarchCurPos()
  local curPointId = SceneUtils.WorldToTileIndex(curWorldPos)
  return curPointId
end

function MarchSingleFlowerTrainData:GetDropBoxPrefabPath()
  if not self.showMeta then
    return ""
  end
  return self.showMeta.dropBoxPrefab or ""
end

function MarchSingleFlowerTrainData:GetDropBoxAppearEffPath()
  if not self.showMeta then
    return ""
  end
  return self.showMeta.boxDropEff or ""
end

function MarchSingleFlowerTrainData:GetDropBoxIdleEffPath()
  if not self.showMeta then
    return ""
  end
  return self.showMeta.boxLoopEff or ""
end

function MarchSingleFlowerTrainData:GetDropBoxBoomEffPath()
  if not self.showMeta then
    return ""
  end
  return self.showMeta.boxBoomEff or ""
end

function MarchSingleFlowerTrainData:GetWaitRewardStateEffPath()
  if not self.showMeta then
    return ""
  end
  return self.showMeta.waitRewardEff or ""
end

function MarchSingleFlowerTrainData:GetWaitRewardCompleteStateEffPath()
  if not self.showMeta then
    return ""
  end
  return self.showMeta.waitRewardDoneEff or ""
end

return MarchSingleFlowerTrainData
