local ActDispatchTaskFakeMarchManager = BaseClass("ActDispatchTaskFakeMarchManager")
local ActDispatchTaskFakeMarchData = require("DataCenter.ActivityListData.ActDispatchTaskFakeMarchData")

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

local function AddMarchIndex(self, pointId, startPt, backHome)
  if self.allMarches[pointId] == nil then
    local data = ActDispatchTaskFakeMarchData.New()
    self.allMarches[pointId] = data
    local endPt = pointId
    data:SetStartAndEndIndex(pointId, startPt, endPt, backHome)
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
  self:CheckAndRefreshMarches()
end

local function DoWhenBackToWorld(self)
  self.rebuildFlag = true
end

ActDispatchTaskFakeMarchManager.__init = __init
ActDispatchTaskFakeMarchManager.__delete = __delete
ActDispatchTaskFakeMarchManager.AddMarchIndex = AddMarchIndex
ActDispatchTaskFakeMarchManager.RemoveMarchIndex = RemoveMarchIndex
ActDispatchTaskFakeMarchManager.AddTimer = AddTimer
ActDispatchTaskFakeMarchManager.RemoveTimer = RemoveTimer
ActDispatchTaskFakeMarchManager.CheckAndRefreshMarches = CheckAndRefreshMarches
ActDispatchTaskFakeMarchManager.RemoveAllDisappearEvent = RemoveAllDisappearEvent
ActDispatchTaskFakeMarchManager.StartMarch = StartMarch
ActDispatchTaskFakeMarchManager.DoWhenBackToWorld = DoWhenBackToWorld
ActDispatchTaskFakeMarchManager.AddListener = AddListener
ActDispatchTaskFakeMarchManager.RemoveListener = RemoveListener
return ActDispatchTaskFakeMarchManager
