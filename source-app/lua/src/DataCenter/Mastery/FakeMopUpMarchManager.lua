local FakeMopUpMarchManager = BaseClass("FakeMopUpMarchManager")
local FakeMopUpMarchData = require("DataCenter.Mastery.FakeMopUpMarchData")

local function __init(self)
  self.allMarches = {}
  
  function self.timer_action(temp)
    self:CheckAndRefreshMarches()
  end
  
  self:AddListener()
end

local function __delete(self)
  self.allMarches = nil
  self:RemoveListener()
end

local function AddListener(self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.OnEnterWorld, self.DoWhenBackToWorld, self)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener2(EventId.OnEnterWorld, self.DoWhenBackToWorld, self)
end

local function AddMarchIndex(self, pointId)
  local newData
  if self.allMarches[pointId] == nil then
    newData = FakeMopUpMarchData.New()
    self.allMarches[pointId] = newData
    local startPt = LuaEntry.Player:GetMainWorldPos()
    local endPt = pointId
    newData:SetStartAndEndIndex(pointId, startPt, endPt)
  end
  self:AddTimer()
  self:CheckAndRefreshMarches()
  return newData and newData:GetBackHomeTimeStamp() or 0
end

local function RemoveMarchIndex(self, pointId)
  if self.allMarches[pointId] ~= nil then
    self.allMarches[pointId]:Remove()
  end
  self.allMarches[pointId] = nil
  if table.count(self.allMarches) == 0 then
    self:RemoveTimer()
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
    self.timer:Start()
  end
end

local function RemoveTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function CheckAndRefreshMarches(self)
  local removeList = {}
  table.walk(self.allMarches, function(k, v)
    if v:NeedRemove() then
      table.insert(removeList, k)
    else
      local now = UITimeManager:GetInstance():GetServerTime()
      v:UpdateState(now)
    end
  end)
  table.walk(removeList, function(_, v)
    self:RemoveMarchIndex(v)
  end)
  if self.rebuildFlag == true and CS.SceneManager:IsInWorld() then
    if table.count(self.allMarches) == 0 then
      self.rebuildFlag = false
    else
      table.walk(self.allMarches, function(_, v)
        local pointInfo = CS.SceneManager.World:GetPointInfo(v.endIndex)
        if pointInfo ~= nil then
          v:DoWhenBackToWorld()
          self.rebuildFlag = false
        end
      end)
    end
  end
end

local function StartMarch(self, uid)
  self:AddMarchIndex(uid)
  self.allMarches[uid]:StartMarch()
end

local function RemoveAllDisappearEvent(self)
  local needDeletes = {}
  table.walk(self.allMarches, function(k, _)
    if self:NeedRemove(k) then
      table.insert(needDeletes, k)
    end
  end)
  table.walk(needDeletes, function(_, v)
    self:RemoveMarchIndex(v)
  end)
end

local function IsEventDoing(self, pointId)
  if self.allMarches[pointId] ~= nil then
    return self.allMarches[pointId]:IsEventDoing()
  end
  return false
end

local function NeedRemove(self, index)
  if not CS.SceneManager:IsInWorld() then
    return false
  end
  local info = CS.SceneManager.World:GetPointInfo(index)
  if info ~= nil and (info.PointType == WorldPointType.SAMPLE_POINT_NEW or info.PointType == WorldPointType.GARBAGE) then
    return false
  end
  local detectEventData = DataCenter.RadarCenterDataManager:GetDetectEventInfoByPointId(index)
  if info == nil and detectEventData ~= nil then
    return false
  end
  return true
end

local function DoWhenBackToWorld(self)
  self.rebuildFlag = true
end

FakeMopUpMarchManager.__init = __init
FakeMopUpMarchManager.__delete = __delete
FakeMopUpMarchManager.AddMarchIndex = AddMarchIndex
FakeMopUpMarchManager.RemoveMarchIndex = RemoveMarchIndex
FakeMopUpMarchManager.AddTimer = AddTimer
FakeMopUpMarchManager.RemoveTimer = RemoveTimer
FakeMopUpMarchManager.CheckAndRefreshMarches = CheckAndRefreshMarches
FakeMopUpMarchManager.RemoveAllDisappearEvent = RemoveAllDisappearEvent
FakeMopUpMarchManager.StartMarch = StartMarch
FakeMopUpMarchManager.IsEventDoing = IsEventDoing
FakeMopUpMarchManager.NeedRemove = NeedRemove
FakeMopUpMarchManager.DoWhenBackToWorld = DoWhenBackToWorld
FakeMopUpMarchManager.AddListener = AddListener
FakeMopUpMarchManager.RemoveListener = RemoveListener
return FakeMopUpMarchManager
