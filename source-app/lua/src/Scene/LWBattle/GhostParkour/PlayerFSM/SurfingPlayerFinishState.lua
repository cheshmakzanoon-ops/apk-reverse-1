local SurfingPlayerFinishState = BaseClass("SurfingPlayerFinishState")

function SurfingPlayerFinishState:__init(unit)
  self.unit = unit
  self.timer = nil
end

function SurfingPlayerFinishState:__delete()
  self.unit = nil
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

function SurfingPlayerFinishState:OnEnter(id, first)
  local tmp = DataCenter.ParkourHeroTemplateManager:GetTemplate(id)
  if tmp == nil then
    if self.unit then
      self.unit:OnAnimFinished()
    end
    return
  end
  local anim1, anim2 = tmp:GetFinishAnim()
  if anim1 and anim2 then
    local duration = self.unit:GetAnimLength(anim1) or 0
    self.unit:TryCrossFadeSimpleAnim(anim1, nil, nil, true)
    if first then
      DataCenter.LWSoundManager:PlaySound(11040, false)
    end
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
      if self.timer then
        self.timer:Stop()
        self.timer = nil
      end
      if self.unit then
        self.unit:TryCrossFadeSimpleAnim(anim2, 1, 0)
      end
    end, duration)
    if self.delayTimer then
      self.delayTimer:Stop()
    end
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.delayTimer then
        self.delayTimer:Stop()
        self.delayTimer = nil
      end
      if self.unit then
        self.unit:OnAnimFinished()
      end
    end, 1.7)
  elseif self.unit then
    self.unit:OnAnimFinished()
  end
end

function SurfingPlayerFinishState:OnExit()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

function SurfingPlayerFinishState:OnUpdate(deltaTime)
end

return SurfingPlayerFinishState
