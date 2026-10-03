local RadarFakeUIMarchData_Base = BaseClass("RadarFakeUIMarchData_Base")

function RadarFakeUIMarchData_Base:__init()
  self.Uuid = 0
  self.StartIndex = 0
  self.EndIndex = 0
  self.StartTime = 0
  self.HasEnded = false
end

function RadarFakeUIMarchData_Base:__delete()
  self.Uuid = nil
  self.StartIndex = nil
  self.EndIndex = nil
  self.StartTime = nil
  self.HasEnded = false
end

function RadarFakeUIMarchData_Base:Init(eventData)
  if eventData == nil then
    return false
  end
  self:SetEnd(eventData.pointId)
  return true
end

function RadarFakeUIMarchData_Base:SetEnd(endIndex)
  self.StartIndex = LuaEntry.Player:GetMainWorldPos()
  self.EndIndex = endIndex
  local data = CS.SceneManager.World:GetPointInfo(self.EndIndex)
  if data then
    self.Uuid = data.uuid
  end
  local detectEventData = DataCenter.RadarCenterDataManager:GetNotFinishDetectEventInfoByPointId(self.EndIndex)
  if detectEventData ~= nil then
    self.Uuid = detectEventData.uuid
  end
end

function RadarFakeUIMarchData_Base:Start()
  self.StartTime = UITimeManager:GetInstance():GetServerTime()
  self.MarchTime = math.ceil(self:CalculateMarchTime())
  self.EndTime = self.StartTime + self.MarchTime
  self:SendStart()
  return self.StartTime, self.EndTime
end

function RadarFakeUIMarchData_Base:TryEnd(force)
  local now = UITimeManager:GetInstance():GetServerTime()
  if not self.HasEnded and (force or now >= self.EndTime) then
    self:SendEnd()
    self.HasEnded = true
  end
end

function RadarFakeUIMarchData_Base:CalculateMarchTime()
  local startPt = SceneUtils.IndexToTilePos(self.StartIndex)
  local endPt = SceneUtils.IndexToTilePos(self.EndIndex)
  local dis = Vector2.Distance(startPt, endPt)
  local speed = self:GetMarchSpeed()
  local time = dis * 1000 / speed
  return Mathf.Min(3000, time)
end

function RadarFakeUIMarchData_Base:GetMarchSpeed()
  return LuaEntry.DataConfig:TryGetNum("detect_quick_finish_config", "k2", 7)
end

function RadarFakeUIMarchData_Base:Remove()
end

function RadarFakeUIMarchData_Base:NeedRemove()
  return not self:IsEventDoing()
end

function RadarFakeUIMarchData_Base:IsEventDoing()
  local now = UITimeManager:GetInstance():GetServerTime()
  return not self.HasEnded and now >= checknumber(self.StartTime) and now <= checknumber(self.EndTime)
end

function RadarFakeUIMarchData_Base:SendStart()
end

function RadarFakeUIMarchData_Base:SendEnd()
end

return RadarFakeUIMarchData_Base
