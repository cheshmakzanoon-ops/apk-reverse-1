local FakeParkourRescueMarchManager = BaseClass("FakeParkourRescueMarchManager")
local FakeParkourRescueMarchData = require("DataCenter.RadarCenterDataManager.FakeParkourRescueMarchData")

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
  EventManager:GetInstance():AddListenerWithSelf(EventId.OnExitWorldState, self.OnExitWorld, self)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener2(EventId.OnExitWorldState, self.OnExitWorld, self)
end

local function AddMarchIndex(self, pointId, modelPath)
  if self.allMarches[pointId] == nil then
    local data = FakeParkourRescueMarchData.New()
    self.allMarches[pointId] = data
    local startPt = LuaEntry.Player:GetMainWorldPos()
    local endPt = pointId
    data:SetStartAndEndIndex(pointId, startPt, endPt, modelPath)
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
  return not CS.SceneManager:IsInWorld()
end

local function OnExitWorld(self)
  for k, v in pairs(self.allMarches) do
    self:RemoveMarchIndex(k)
  end
end

FakeParkourRescueMarchManager.__init = __init
FakeParkourRescueMarchManager.__delete = __delete
FakeParkourRescueMarchManager.AddMarchIndex = AddMarchIndex
FakeParkourRescueMarchManager.RemoveMarchIndex = RemoveMarchIndex
FakeParkourRescueMarchManager.AddTimer = AddTimer
FakeParkourRescueMarchManager.RemoveTimer = RemoveTimer
FakeParkourRescueMarchManager.CheckAndRefreshMarches = CheckAndRefreshMarches
FakeParkourRescueMarchManager.RemoveAllDisappearEvent = RemoveAllDisappearEvent
FakeParkourRescueMarchManager.StartMarch = StartMarch
FakeParkourRescueMarchManager.IsEventDoing = IsEventDoing
FakeParkourRescueMarchManager.NeedRemove = NeedRemove
FakeParkourRescueMarchManager.OnExitWorld = OnExitWorld
FakeParkourRescueMarchManager.AddListener = AddListener
FakeParkourRescueMarchManager.RemoveListener = RemoveListener
return FakeParkourRescueMarchManager
