local FakeRescueMarchManager = BaseClass("FakeRescueMarchManager")
local FakeRescueMarchData = require("DataCenter.RadarCenterDataManager.FakeRescueMarchData")

local function __init(self)
  self.allMarches = {}
  
  function self.timer_action(temp)
    self:CheckAndRefreshMarches()
  end
  
  self:AddListener()
  self.playingSoundSerialId = nil
end

local function __delete(self)
  self.allMarches = nil
  self:RemoveListener()
end

local function AddListener(self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.OnEnterWorld, self.DoWhenBackToWorld, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.OnSceneCameraDisableRender, self.OnSceneCameraDisableRender, self)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener2(EventId.OnEnterWorld, self.DoWhenBackToWorld, self)
  EventManager:GetInstance():RemoveListener2(EventId.OnSceneCameraDisableRender, self.OnSceneCameraDisableRender, self)
end

local function AddMarchIndex(self, pointId)
  if self.allMarches[pointId] == nil then
    local data = FakeRescueMarchData.New()
    self.allMarches[pointId] = data
    local startPt = LuaEntry.Player:GetMainWorldPos()
    local endPt = pointId
    data:SetStartAndEndIndex(pointId, startPt, endPt)
  end
  self:AddTimer()
  self:CheckAndRefreshMarches()
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
  if info ~= nil and info.PointType == WorldPointType.RESCUE_POINT then
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

local function PlaySound(self)
  self:StopSound()
  self.playingSoundSerialId = DataCenter.LWSoundManager:PlaySound(80080, false)
end

local function StopSound(self)
  if self.playingSoundSerialId ~= nil then
    DataCenter.LWSoundManager:StopSound(self.playingSoundSerialId)
    self.playingSoundSerialId = nil
  end
end

local function OnSceneCameraDisableRender(self, isDisableRender)
  if isDisableRender then
    self:StopSound()
  end
end

FakeRescueMarchManager.__init = __init
FakeRescueMarchManager.__delete = __delete
FakeRescueMarchManager.AddMarchIndex = AddMarchIndex
FakeRescueMarchManager.RemoveMarchIndex = RemoveMarchIndex
FakeRescueMarchManager.AddTimer = AddTimer
FakeRescueMarchManager.RemoveTimer = RemoveTimer
FakeRescueMarchManager.CheckAndRefreshMarches = CheckAndRefreshMarches
FakeRescueMarchManager.RemoveAllDisappearEvent = RemoveAllDisappearEvent
FakeRescueMarchManager.StartMarch = StartMarch
FakeRescueMarchManager.IsEventDoing = IsEventDoing
FakeRescueMarchManager.NeedRemove = NeedRemove
FakeRescueMarchManager.DoWhenBackToWorld = DoWhenBackToWorld
FakeRescueMarchManager.AddListener = AddListener
FakeRescueMarchManager.RemoveListener = RemoveListener
FakeRescueMarchManager.PlaySound = PlaySound
FakeRescueMarchManager.StopSound = StopSound
FakeRescueMarchManager.OnSceneCameraDisableRender = OnSceneCameraDisableRender
return FakeRescueMarchManager
