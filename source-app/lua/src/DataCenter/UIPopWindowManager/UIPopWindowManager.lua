local UIPopWindowManager = BaseClass("UIPopWindowManager")
local pairs = _ENV.pairs
local DELAY = 0.1

local function __init(self)
  self.queue = {}
  self.isInPve = false
  self.popEmptyEvent = false
  self:AddListeners()
end

local function __delete(self)
  self.queue = nil
  self.isInPve = nil
  self.popEmptyEvent = false
  self:RemoveListeners()
end

local function AddListeners(self)
  EventManager:GetInstance():AddListener(EventId.PveLevelEnter, self.OnPveLevelEnter)
  EventManager:GetInstance():AddListener(EventId.PveLevelExit, self.OnPveLevelExit)
  EventManager:GetInstance():AddListener(EventId.OnAfterWindowDestroy, self.OnWindowDestroy)
end

local function RemoveListeners(self)
  EventManager:GetInstance():RemoveListener(EventId.PveLevelEnter, self.OnPveLevelEnter)
  EventManager:GetInstance():RemoveListener(EventId.PveLevelExit, self.OnPveLevelExit)
  EventManager:GetInstance():RemoveListener(EventId.OnAfterWindowDestroy, self.OnWindowDestroy)
end

local function Push(self, windowName, ...)
  self:Append(windowName, ...)
end

local function Append(self, windowName, ...)
  if UIManager:GetInstance():IsWindowOpen(windowName) then
    return
  end
  if self:IsWindowInQueue(windowName) then
    return
  end
  local element = {
    windowName = windowName,
    params = SafePack(...)
  }
  table.insert(self.queue, element)
  TimerManager:GetInstance():DelayInvoke(function()
    self:CheckOpenWindow()
  end, DELAY)
end

local function Prepend(self, windowName, ...)
  if UIManager:GetInstance():IsWindowOpen(windowName) then
    return
  end
  if self:IsWindowInQueue(windowName) then
    return
  end
  local element = {
    windowName = windowName,
    params = SafePack(...)
  }
  table.insert(self.queue, 1, element)
  TimerManager:GetInstance():DelayInvoke(function()
    self:CheckOpenWindow()
  end, DELAY)
end

local function Pop(self)
  if table.count(self.queue) == 0 then
    return nil
  end
  return table.remove(self.queue, 1)
end

local function CheckOpenWindow(self)
  if self.isInPve then
    return
  end
  if not UIManager:GetInstance():CheckIfIsMainUIOpenOnly(true) then
    return
  end
  local element = self:Pop()
  if element == nil then
    if not self.popEmptyEvent then
      self.popEmptyEvent = true
      EventManager:GetInstance():Broadcast(EventId.OnPopWindowFirstFinish)
    end
    return
  end
  if DataCenter.GuideManager:InGuide() then
    DataCenter.GuideManager:SetGuideEndCallBack(function()
      self:OpenWindow(element)
    end)
  else
    self:OpenWindow(element)
  end
end

local function OpenWindow(self, element)
  UIManager:GetInstance():OpenWindow(element.windowName, SafeUnpack(element.params))
end

local function OnWindowDestroy()
  DataCenter.UIPopWindowManager:CheckOpenWindow()
end

local function IsWindowInQueue(self, windowName)
  for _, v in pairs(self.queue) do
    if v and v.windowName == windowName then
      return true
    end
  end
  return false
end

local function IsQueueEmpty(self)
  return table.count(self.queue) == 0
end

local function OnPveLevelEnter()
  DataCenter.UIPopWindowManager.isInPve = true
end

local function OnPveLevelExit()
  DataCenter.UIPopWindowManager.isInPve = false
end

local function Clear(self)
  repeat
    local dt = self:Pop()
  until dt == nil
end

UIPopWindowManager.__init = __init
UIPopWindowManager.__delete = __delete
UIPopWindowManager.AddListeners = AddListeners
UIPopWindowManager.RemoveListeners = RemoveListeners
UIPopWindowManager.Push = Push
UIPopWindowManager.Append = Append
UIPopWindowManager.Prepend = Prepend
UIPopWindowManager.Pop = Pop
UIPopWindowManager.CheckOpenWindow = CheckOpenWindow
UIPopWindowManager.OpenWindow = OpenWindow
UIPopWindowManager.OnWindowDestroy = OnWindowDestroy
UIPopWindowManager.IsWindowInQueue = IsWindowInQueue
UIPopWindowManager.Clear = Clear
UIPopWindowManager.OnPveLevelEnter = OnPveLevelEnter
UIPopWindowManager.OnPveLevelExit = OnPveLevelExit
UIPopWindowManager.IsQueueEmpty = IsQueueEmpty
return UIPopWindowManager
