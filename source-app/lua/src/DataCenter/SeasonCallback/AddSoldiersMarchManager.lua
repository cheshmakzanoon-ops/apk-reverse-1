local AddSoldiersMarchManager = BaseClass("AddSoldiersMarchManager")
local AddSoldiersMarchData = require("DataCenter.SeasonCallback.AddSoldiersMarchData")

local function __init(self)
  self.events = nil
  self.allMarches = nil
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

local function AddMarchIndex(self, pointId, startId, eventUuid)
  if self.allMarches == nil then
    self.allMarches = {}
  end
  if self.allMarches[eventUuid] == nil then
    local data = AddSoldiersMarchData.New()
    self.allMarches[eventUuid] = data
    local startPt = startId or LuaEntry.Player:GetMainWorldPos()
    local endPt = pointId
    data:SetStartAndEndIndex(pointId, startPt, endPt, eventUuid)
  end
  self:AddTimer()
  self:CheckAndRefreshMarches()
end

local function RemoveMarchIndex(self, eventUuid)
  if self.allMarches == nil then
    return
  end
  if self.allMarches[eventUuid] ~= nil then
    self.allMarches[eventUuid]:Remove()
  end
  self.allMarches[eventUuid] = nil
  if table.count(self.allMarches) == 0 then
    self:RemoveTimer()
    self.events = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    if self.timer_action == nil then
      function self.timer_action(temp)
        self:CheckAndRefreshMarches()
      end
    end
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
  if self.allMarches == nil then
    return
  end
  local removeList
  table.walk(self.allMarches, function(k, v)
    if v:NeedRemove() then
      if removeList == nil then
        removeList = {}
      end
      table.insert(removeList, k)
    else
      local now = UITimeManager:GetInstance():GetServerTime()
      v:UpdateState(now)
    end
  end)
  if removeList then
    table.walk(removeList, function(_, v)
      self:RemoveMarchIndex(v)
    end)
  end
  if self.rebuildFlag == true and CS.SceneManager:IsInWorld() then
    if table.count(self.allMarches) == 0 then
      self.rebuildFlag = false
    else
      table.walk(self.allMarches, function(_, v)
        v:DoWhenBackToWorld()
        self.rebuildFlag = false
      end)
    end
  end
end

local function RemoveAllDisappearEvent(self)
  if self.allMarches == nil then
    return
  end
  local needDeletes = {}
  table.walk(self.allMarches, function(k, v)
    if self:NeedRemove(v.eventUuid) then
      table.insert(needDeletes, k)
    end
  end)
  table.walk(needDeletes, function(_, v)
    self:RemoveMarchIndex(v)
  end)
end

local function IsEventDoing(self, eventUuid)
  if self.allMarches == nil then
    return
  end
  if self.allMarches[eventUuid] ~= nil then
    return self.allMarches[eventUuid]:IsEventDoing()
  end
  return false
end

local function NeedRemove(self, eventUuid)
  if not CS.SceneManager:IsInWorld() then
    return false
  end
  local detectEventData = self:GetDetectEventInfo(eventUuid)
  if detectEventData ~= nil and (detectEventData.state == DetectEventState.DETECT_EVENT_STATE_NOT_FINISH or detectEventData.state == DetectEventState.DETECT_EVENT_STATE_FINISHED) then
    return false
  end
  return false
end

local function DoWhenBackToWorld(self)
  self.rebuildFlag = true
end

local function UpdateEventInfo(self, skillBroadInfo)
  if table.IsNullOrEmpty(skillBroadInfo) then
    return
  end
  skillBroadInfo.eventUuid = skillBroadInfo.startTime + skillBroadInfo.targetPointId
  skillBroadInfo.state = DetectEventState.DETECT_EVENT_STATE_NOT_FINISH
  skillBroadInfo.uid = skillBroadInfo.targetUid
  if LuaEntry.Player.uid == skillBroadInfo.targetUid then
    local data = AddSoldiersMarchData.New()
    local startPt = skillBroadInfo.fromPointId or LuaEntry.Player:GetMainWorldPos()
    local endPt = skillBroadInfo.targetPointId
    data:SetStartAndEndIndex(endPt, startPt, endPt, skillBroadInfo.eventUuid)
    data:PlayGetAnim(skillBroadInfo)
    return
  end
  if self.events == nil then
    self.events = {}
  end
  table.insert(self.events, skillBroadInfo)
  self:AddMarchIndex(skillBroadInfo.targetPointId, skillBroadInfo.fromPointId, skillBroadInfo.eventUuid)
  self:RemoveAllDisappearEvent()
end

local function GetDetectEventInfo(self, eventUuid)
  if not self.events then
    return nil
  end
  for i, v in pairs(self.events) do
    if v.eventUuid == eventUuid then
      return v
    end
  end
  return nil
end

AddSoldiersMarchManager.__init = __init
AddSoldiersMarchManager.__delete = __delete
AddSoldiersMarchManager.AddMarchIndex = AddMarchIndex
AddSoldiersMarchManager.RemoveMarchIndex = RemoveMarchIndex
AddSoldiersMarchManager.AddTimer = AddTimer
AddSoldiersMarchManager.RemoveTimer = RemoveTimer
AddSoldiersMarchManager.CheckAndRefreshMarches = CheckAndRefreshMarches
AddSoldiersMarchManager.RemoveAllDisappearEvent = RemoveAllDisappearEvent
AddSoldiersMarchManager.IsEventDoing = IsEventDoing
AddSoldiersMarchManager.NeedRemove = NeedRemove
AddSoldiersMarchManager.DoWhenBackToWorld = DoWhenBackToWorld
AddSoldiersMarchManager.AddListener = AddListener
AddSoldiersMarchManager.RemoveListener = RemoveListener
AddSoldiersMarchManager.UpdateEventInfo = UpdateEventInfo
AddSoldiersMarchManager.GetDetectEventInfo = GetDetectEventInfo
return AddSoldiersMarchManager
