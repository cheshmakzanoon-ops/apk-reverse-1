local Timer = BaseClass("Timer")
local TimerNextID = 1

local function __init(self, delay, func, obj, one_shot, use_frame, unscaled)
  TimerNextID = TimerNextID + 1
  self.timer_id = TimerNextID
  if delay and func then
    self:Init(delay, func, obj, one_shot, use_frame, unscaled)
  end
end

local function Init(self, delay, func, obj, one_shot, use_frame, unscaled)
  if type(delay) ~= "number" then
    Logger.LogError("[Timer] Param delay is not number!")
    self.init_failed_flag = true
    return
  elseif delay < 0 then
    Logger.LogError("[Timer] Param delay < 0!")
    self.init_failed_flag = true
    return
  elseif func == nil then
    Logger.LogError("[Timer] Param func is Null!")
    self.init_failed_flag = true
    return
  end
  self.init_failed_flag = false
  self.delay = delay
  self.target_func = func
  self.target_obj = obj
  self.one_shot = one_shot
  self.use_frame = use_frame
  self.unscaled = unscaled
  self.started = false
  self.left = delay
  self.over = false
  self.obj_not_nil = obj and true or false
  self.start_frame_count = Time.frameCount
end

local function Update(self)
  if not self.started or self.over or self.init_failed_flag then
    return
  end
  local timeup = false
  if self.use_frame then
    timeup = Time.frameCount >= self.start_frame_count + self.delay
  else
    local delta = not self.unscaled and Time.deltaTime or Time.unscaledDeltaTime
    self.left = self.left - delta
    timeup = self.left <= 0
  end
  if timeup then
    if self.target_func ~= nil then
      if not self.one_shot then
        if not self.use_frame then
          self.left = self.delay + self.left
          if self.left <= 0 then
            self.left = self.delay
          end
        end
        self.start_frame_count = Time.frameCount
      else
        self.over = true
      end
      local status, err
      if self.obj_not_nil then
        status, err = xpcall(self.target_func, debug.traceback, self.target_obj)
      else
        status, err = xpcall(self.target_func, debug.traceback)
      end
      if not status then
        self.over = true
        Logger.LogError(err)
      end
    else
      Logger.LogError("[Timer] Execute nil, id:", self.timer_id)
      self.over = true
    end
  end
end

local function Start(self)
  if self.init_failed_flag then
    Logger.LogError("[Timer] Timer Init Failed, cant start!")
  end
  if self.over then
    Logger.LogError("[Timer] You can't start a overed timer, try add a new one!")
  end
  if not self.started then
    self.left = self.delay
    self.started = true
    self.start_frame_count = Time.frameCount
  end
end

local function Pause(self)
  if self.init_failed_flag then
    Logger.LogError("[Timer] Timer Init Failed, cant Pause!")
  end
  self.started = false
end

local function Resume(self)
  if self.init_failed_flag then
    Logger.LogError("[Timer] Timer Init Failed, cant Resume!")
  end
  self.started = true
end

local function Stop(self)
  self.left = 0
  self.one_shot = false
  self.target_func = nil
  self.target_obj = nil
  self.use_frame = false
  self.unscaled = false
  self.started = false
  self.over = true
end

local function Reset(self)
  if self.init_failed_flag then
    Logger.LogError("[Timer] Timer Init Failed, cant Reset!")
  end
  self.left = self.delay
  self.start_frame_count = Time.frameCount
end

local function IsOver(self)
  return self.over
end

Timer.__init = __init
Timer.Init = Init
Timer.Update = Update
Timer.Start = Start
Timer.Pause = Pause
Timer.Resume = Resume
Timer.Stop = Stop
Timer.Reset = Reset
Timer.IsOver = IsOver
return Timer
