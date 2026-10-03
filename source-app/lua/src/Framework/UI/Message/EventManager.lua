local Messenger = require("Framework.Common.Messenger")
local MessengerWithParam = require("Framework.Common.MessengerWithParam")
local EventNotify = CS.EventNotify
local socket = require("socket")
local EventManager = BaseClass("EventManager", Singleton)
local table_clear = table.clear
local Time = _ENV.Time

local function __init(self)
  self.messenger = Messenger.New()
  self.messengerWithParam = MessengerWithParam.New()
  self.deferredEvents = {}
  self.deferredEventsDispatching = {}
  self.isInitLateUpdate = false
  self.profilerSwitch = nil
  self.frameEventCounts = {}
  self.eventTimeStats = {}
  self.currentFrame = 0
  self.profilerReportInterval = 200
  self.profilerReportCounter = 0
  self.profilerTimeThreshold = 0.05
  self.profilerCountThreshold = 8
  self.profilerMaxStatsCount = 1000
  self.reportedHighCostEvents = {}
end

local function DispatchFrameBlendEvents(self)
  if next(self.deferredEvents) == nil then
    return
  end
  local dispatching = self.deferredEvents
  self.deferredEvents = self.deferredEventsDispatching
  self.deferredEventsDispatching = dispatching
  table_clear(self.deferredEvents)
  for eventId, _ in pairs(self.deferredEventsDispatching) do
    local ok, err = pcall(function()
      self:Broadcast(eventId)
    end)
    if not ok then
      Logger.LogError("[EventFrameBlend] DispatchError -- eventId = " .. eventId .. ", error = " .. err)
    end
  end
  table_clear(self.deferredEventsDispatching)
end

local function OnLateUpdate(self)
  DispatchFrameBlendEvents(self)
end

local function AddLateUpdate(self)
  if self.lateUpdateTimer == nil then
    function self.lateUpdateTimer()
      OnLateUpdate(self)
    end
    
    UpdateManager:GetInstance():AddLateUpdate(self.lateUpdateTimer)
  end
end

local function RemoveLateUpdate(self)
  if self.lateUpdateTimer then
    UpdateManager:GetInstance():RemoveLateUpdate(self.lateUpdateTimer)
    self.lateUpdateTimer = nil
  end
end

local function CheckProfilerSwitch(self)
  if self.profilerSwitch == nil then
    self.profilerSwitch = CS.GrayUtils.IsGrayDevice(1)
    if self.profilerSwitch then
      Logger.LogInfo("[EventProfiler] Event profiler switch is ON")
    end
  end
  return self.profilerSwitch
end

local function GetCurrentTime()
  return socket.gettime()
end

local function GetCurrentFrame()
  return Time.frameCount
end

local function RecordEventDispatch(self, eventId)
  local currentFrame = GetCurrentFrame()
  if currentFrame ~= self.currentFrame then
    local frameCounts = self.frameEventCounts
    local threshold = self.profilerCountThreshold
    local highFreqEvents = {}
    for id, count in pairs(frameCounts) do
      if count >= threshold then
        table.insert(highFreqEvents, {eventId = id, count = count})
      end
    end
    if 0 < #highFreqEvents then
      table.sort(highFreqEvents, function(a, b)
        return a.count > b.count
      end)
      for _, event in ipairs(highFreqEvents) do
        Logger.LogInfo(string.format("[EventProfiler] Dispatched [%d] : %d times", event.eventId, event.count))
      end
    end
    table_clear(frameCounts)
    self.currentFrame = currentFrame
    local counter = self.profilerReportCounter + 1
    self.profilerReportCounter = counter
    if counter >= self.profilerReportInterval then
      self:OutputProfilerReport()
      self.profilerReportCounter = 0
    end
  end
  local frameCounts = self.frameEventCounts
  frameCounts[eventId] = (frameCounts[eventId] or 0) + 1
end

local function TrimProfilerStats(self)
  local timeStats = self.eventTimeStats
  local maxCount = self.profilerMaxStatsCount
  local firstKey = next(timeStats)
  if not firstKey then
    return
  end
  local eventList = {}
  local currentCount = 0
  for eventId, stats in pairs(timeStats) do
    currentCount = currentCount + 1
    table.insert(eventList, {
      eventId = eventId,
      count = stats.count
    })
  end
  if maxCount < currentCount then
    table.sort(eventList, function(a, b)
      return a.count < b.count
    end)
    local removeCount = currentCount - maxCount
    for i = 1, removeCount do
      timeStats[eventList[i].eventId] = nil
    end
    Logger.LogInfo(string.format("[EventProfiler] Trimmed stats: removed %d events, kept %d events", removeCount, maxCount))
  end
end

local function RecordEventTime(self, eventId, elapsedTime)
  local timeStats = self.eventTimeStats
  local stats = timeStats[eventId]
  local isNewEvent = false
  if not stats then
    isNewEvent = true
    stats = {
      totalTime = 0,
      count = 0,
      maxTime = 0,
      minTime = math.huge
    }
    timeStats[eventId] = stats
  end
  stats.totalTime = stats.totalTime + elapsedTime
  stats.count = stats.count + 1
  stats.maxTime = math.max(stats.maxTime, elapsedTime)
  stats.minTime = math.min(stats.minTime, elapsedTime)
  local threshold = self.profilerTimeThreshold
  if elapsedTime >= threshold and CommonUtil.IsDebug() then
    Logger.LogInfo(string.format("[EventProfiler] ElapsedTime [%d] : %.4f ms", eventId, elapsedTime * 1000))
  end
end

local function OutputProfilerReport(self)
  local timeStats = self.eventTimeStats
  local threshold = self.profilerTimeThreshold
  local highTimeEvents = {}
  local reportedEvents = self.reportedHighCostEvents
  for eventId, stats in pairs(timeStats) do
    local count = stats.count
    if 0 < count then
      local avgTime = stats.totalTime / count
      if threshold <= avgTime and not reportedEvents[eventId] then
        table.insert(highTimeEvents, {
          eventId = eventId,
          avgTime = avgTime,
          maxTime = stats.maxTime,
          minTime = stats.minTime,
          count = count,
          totalTime = stats.totalTime
        })
      end
    end
  end
  local eventCount = #highTimeEvents
  if 0 < eventCount then
    table.sort(highTimeEvents, function(a, b)
      return a.avgTime > b.avgTime
    end)
    local topCount = math.min(10, eventCount)
    local reportedEvents = self.reportedHighCostEvents
    for i = 1, topCount do
      local event = highTimeEvents[i]
      Logger.LogInfo(string.format("[EventProfiler] High cost event %d: avg=%.4fms, max=%.4fms, min=%.4fms, c=%d, t=%.4fms", event.eventId, event.avgTime * 1000, event.maxTime * 1000, event.minTime * 1000, event.count, event.totalTime * 1000))
      reportedEvents[event.eventId] = true
    end
  else
  end
  TrimProfilerStats(self)
end

local function ClearProfilerStats(self)
  table_clear(self.frameEventCounts)
  table_clear(self.eventTimeStats)
  table_clear(self.reportedHighCostEvents)
  self.profilerReportCounter = 0
end

local function __delete(self)
  RemoveLateUpdate(self)
  self.messenger = nil
  self.messengerWithParam = nil
  self.deferredEvents = nil
  self.deferredEventsDispatching = nil
  self.isInitLateUpdate = nil
  ClearProfilerStats(self)
  self.profilerSwitch = nil
  self.frameEventCounts = nil
  self.eventTimeStats = nil
  self.reportedHighCostEvents = nil
end

local function AddListener(self, eventId, handler)
  self.messenger:AddListener(eventId, handler)
end

local function RemoveListener(self, eventId, handler)
  self.messenger:RemoveListener(eventId, handler)
end

local function AddListenerWithSelf(self, eventId, handler, obj)
  self.messenger:AddListener(eventId, handler, obj)
end

local function RemoveListener2(self, eventId, handler, obj)
  self.messenger:RemoveListener(eventId, handler)
end

local function Broadcast(self, eventId, userData)
  if eventId == nil then
    return
  end
  local isProfiling = CheckProfilerSwitch(self)
  local startTime
  if isProfiling then
    RecordEventDispatch(self, eventId)
    startTime = GetCurrentTime()
  end
  if userData == nil then
    EventNotify.Fire(eventId)
  else
    local t = type(userData)
    if t == "number" then
      EventNotify.FireLong(eventId, userData)
    elseif t == "boolean" then
      EventNotify.FireBool(eventId, userData)
    elseif t == "string" then
      EventNotify.FireString(eventId, userData)
    elseif t == "table" and userData.ToBinary then
      EventNotify.FireSFSObject(eventId, userData:ToBinary())
    elseif t == "table" then
      EventNotify.FireLuaTable(eventId, userData)
    else
      Logger.LogError("[EventProfiler] broadcast type error ", eventId)
    end
  end
  if isProfiling then
    local elapsedTime = GetCurrentTime() - startTime
    RecordEventTime(self, eventId, elapsedTime)
  end
end

local function DispatchCSEvent(self, eventId, userData)
  self.messenger:Broadcast(eventId, userData)
end

local function DispatchCSEventSFSObject(self, eventId, userData)
  local sfsObj = SFSObject.NewFromBinary(userData)
  self.messenger:Broadcast(eventId, sfsObj)
end

local function DelayBroadcast(self, delayTime, eventId, userData)
  local delayBroadcast = self.delayBroadcast
  if delayBroadcast == nil then
    delayBroadcast = {}
  end
  local key = userData or "Null_Delay_Broadcast"
  local eventList = delayBroadcast[eventId] or {}
  if eventList[key] == nil then
    local theEventId = eventId
    local theUserData = userData
    eventList[key] = TimerManager:GetInstance():DelayInvoke(function()
      eventList[key] = nil
      EventManager:GetInstance():Broadcast(theEventId, theUserData)
    end, delayTime or 0.1)
    delayBroadcast[eventId] = eventList
    self.delayBroadcast = delayBroadcast
  end
end

function EventManager:AddListenerWithParam(eventId, scope, handler, ...)
  self.messengerWithParam:AddListener(eventId, scope, handler, ...)
end

function EventManager:RemoveListenerWithParam(eventId, scope, handler)
  self.messengerWithParam:RemoveListener(eventId, scope, handler)
end

function EventManager:BroadcastWithParam(eventId, scope, ...)
  self.messengerWithParam:Broadcast(eventId, scope, ...)
end

local function BroadcastDeferred(self, eventId)
  if eventId == nil then
    Logger.LogError("[EventProfiler] broadcast frame blend error : eventId is nil")
    return
  end
  if self.deferredEvents[eventId] then
    return
  end
  self.deferredEvents[eventId] = true
  if not self.isInitLateUpdate then
    self.isInitLateUpdate = true
    AddLateUpdate(self)
  end
end

EventManager.__init = __init
EventManager.__delete = __delete
EventManager.AddListener = AddListener
EventManager.RemoveListener = RemoveListener
EventManager.AddListenerWithSelf = AddListenerWithSelf
EventManager.RemoveListener2 = RemoveListener2
EventManager.Broadcast = Broadcast
EventManager.DispatchCSEvent = DispatchCSEvent
EventManager.DispatchCSEventSFSObject = DispatchCSEventSFSObject
EventManager.DelayBroadcast = DelayBroadcast
EventManager.BroadcastDeferred = BroadcastDeferred
EventManager.OutputProfilerReport = OutputProfilerReport
EventManager.ClearProfilerStats = ClearProfilerStats
return EventManager
