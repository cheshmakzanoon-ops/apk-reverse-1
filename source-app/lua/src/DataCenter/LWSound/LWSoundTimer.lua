local LWSoundTimer = BaseClass("LWSoundTimer")

function LWSoundTimer:__init(id, soundLength)
  self.timerId = 0
  self.timer = {}
  self.assetId = 0
  self:CreateTimer(id, soundLength)
end

function LWSoundTimer:__delete()
  self.timerId = nil
  self.timer = nil
  self.assetId = nil
end

local function LoopTimerAction(self)
  DataCenter.LWSoundManager:PlaySound(self.assetId, false)
end

function LWSoundTimer:CreateTimer(id, soundLength)
  self.assetId = id
  self.timer = TimerManager:GetInstance():GetTimer(soundLength, LoopTimerAction, self, false, false, false)
  self.timerId = self.timer.timer_id
end

function LWSoundTimer:Resume()
  if self.timer then
    LoopTimerAction(self)
    self.timer:Resume()
  end
end

function LWSoundTimer:Pause()
  if self.timer then
    self.timer:Pause()
  end
end

function LWSoundTimer:Stop()
  if self.timer then
    self.timer:Stop()
  end
end

return LWSoundTimer
