local DispatchRequestManager = BaseClass("DispatchRequestManager")

local function __init(self)
  self.queue = {}
end

local function __delete(self)
  self.queue = nil
  if self.executeTimer then
    self.executeTimer:Stop()
    self.executeTimer = nil
  end
end

local function Append(self, func)
  table.insert(self.queue, func)
  self:TryStartExecuteTimer()
end

local function Prepend(self, func)
  table.insert(self.queue, 1, func)
  self:TryStartExecuteTimer()
end

local function Pop(self)
  if table.count(self.queue) == 0 then
    return nil
  end
  return table.remove(self.queue, 1)
end

local function Execute(self)
  local element = self:Pop()
  if element then
    element()
    self.executeTimer:Stop()
    self.executeTimer = nil
    if table.count(self.queue) > 0 then
      self:TryStartExecuteTimer()
    end
  end
end

local function TryStartExecuteTimer(self)
  if self.executeTimer == nil then
    local randomDelay = math.random()
    randomDelay = randomDelay * 2
    self.executeTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:Execute()
    end, randomDelay)
    self.executeTimer:Start()
  end
end

DispatchRequestManager.__init = __init
DispatchRequestManager.__delete = __delete
DispatchRequestManager.Append = Append
DispatchRequestManager.Prepend = Prepend
DispatchRequestManager.Pop = Pop
DispatchRequestManager.Execute = Execute
DispatchRequestManager.TryStartExecuteTimer = TryStartExecuteTimer
return DispatchRequestManager
