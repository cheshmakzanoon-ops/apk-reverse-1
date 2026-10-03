local VisitorData = BaseClass("CallerData")
local Const = require("Scene.CityVisitor.Const")

function VisitorData:__init()
  self:ClearData()
end

function VisitorData:__delete()
  self:ClearData()
end

function VisitorData:ClearData()
  self.uid = nil
  self.eventId = nil
  self.startTime = nil
  self.visitorId = nil
  self.eventType = nil
  self.appearCfgId = nil
  self.heroData = nil
  self.line = nil
  self.poss = nil
  self.modelPath = nil
  self.modelImg = nil
  self.endPos = nil
  self.startPos = nil
  self.roleInfo = nil
end

function VisitorData:UpdateInfo(message)
  self.uid = message.uid
  self.eventId = message.eventId
  if tonumber(self.eventId == 2001) or tonumber(self.eventId == 1001) then
    Logger.LogError("Error config aps_battlebuff id = ")
  end
  self.startTime = message.startTime
  self.visitorId = message.visitorId
  self.roleInfo = message.roleInfo
  self.line = LocalController:instance():getLine(TableName.City_Visitor, message.eventId)
  if self.line == nil then
    return
  end
  self.eventType = self.line.type
  if self.line.model_path == nil or self.line.model_path == "" then
    self.appearCfgId = message.worker.model
  else
    self.appearCfgId = self.line.model_path
    self.name = self.line.name
  end
  self.workerData = message.worker
  self.tipIcon = self.line.icon
  self.type = tonumber(message.type)
  self:InitModelData()
  self:InitPosDataList()
end

function VisitorData:GetStartPos()
  local level = DataCenter.CityDomeManager:GetDomeRangeCache()
  self.startPos = self.poss[level].startPos
  local count = DataCenter.CityVisitorManager.GetFrontCount(self.uid, self.type)
  self.startPos = count and Vector3.New(self.poss[level].startPos.x, self.poss[level].startPos.y, self.poss[level].startPos.z - count * Const.queueDistance + 5) or self.poss[level].startPos
  return self.startPos
end

function VisitorData:GetEndPos()
  local level = DataCenter.CityDomeManager:GetDomeRangeCache()
  local count = DataCenter.CityVisitorManager.GetFrontCount(self.uid, self.type)
  local offectX = 0
  if self.type == Const.VisitorType.STAGE or self.type == Const.VisitorType.WORKER_LOTTERY or self.type == Const.VisitorType.OPEN_PANEL or self.type == Const.VisitorType.SURVIVOR_PACK_GiFT then
    offectX = 1
  end
  self.endPos = count and Vector3.New(self.poss[level].endPos.x + offectX, self.poss[level].endPos.y, self.poss[level].endPos.z - count * Const.queueDistance) or self.poss[level].endPos
  return self.endPos
end

function VisitorData:InitPosDataList()
  local poss = {}
  local vec = string.split(self.line.visitor_zone, "|")
  table.walk(vec, function(k, v)
    local vec1 = string.split(v, ";")
    local startPos = Vector3.New(vec1[1], 0, vec1[2])
    local endPos = Vector3.New(vec1[3], 0, vec1[4])
    local param = {}
    param.startPos = startPos
    param.endPos = endPos
    table.insert(poss, param)
  end)
  self.poss = poss
end

function VisitorData:InitModelData()
  local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(self.appearCfgId)
  local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId)
  if line == nil then
    return
  end
  self.modelPath = line.city_model_path
  if self.modelPath == nil or self.modelPath == "" then
    local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId)
    if line == nil then
      return
    end
    self.modelPath = line.city_model_path
    self.modelImg = line.pose_icon_path
  end
end

return VisitorData
