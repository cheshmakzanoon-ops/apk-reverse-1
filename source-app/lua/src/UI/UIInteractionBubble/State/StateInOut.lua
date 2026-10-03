local StateInOut = BaseClass("StateInOut")

function StateInOut:__init(view)
  self.view = view
end

function StateInOut:__delete()
end

function StateInOut:OnEnter()
  self.inCD = nil
  self.inPos = nil
  self.duration = 0
  if DataCenter.InteractionBubbleManager:HasFlyInTask() then
    if self.view:IsAllEmpty() then
      self.inPos = math.min(DataCenter.InteractionBubbleManager:GetFlyInTaskCount(), self.view:GetMaxBubbleNum())
      self.view:CreateBubbleAndFlyIn(self.inPos, DataCenter.InteractionBubbleManager:FlyInTaskDequeue())
      self.duration = UIInteractionBubbleFlyInTime
      self.inCD = 0.1
    elseif self.view:IsBottomEmpty() then
      self.view:CreateBottomBubbleAndFlyIn(DataCenter.InteractionBubbleManager:FlyInTaskDequeue())
      self.duration = UIInteractionBubbleFlyInTime
    end
  end
end

function StateInOut:OnUpdate()
  if self.inCD and self.inPos then
    self.inCD = self.inCD - Time.deltaTime
    if self.inCD < 0 then
      self.inPos = self.inPos - 1
      if self.inPos > 0 then
        self.view:CreateBubbleAndFlyIn(self.inPos, DataCenter.InteractionBubbleManager:FlyInTaskDequeue())
        self.duration = math.max(self.duration, UIInteractionBubbleFlyInTime + Time.deltaTime)
        self.inCD = 0.1
      end
      if self.inPos <= 1 then
        self.inCD = nil
        self.inPos = nil
      end
    end
  end
  if self.view:HasFlyOutTask() then
    self.view:ExecuteAllFlyOutTask()
    self.duration = math.max(self.duration, UIInteractionBubbleFlyOutTime + Time.deltaTime)
  end
  self.duration = self.duration - Time.deltaTime
  if self.duration < -0.01 then
    self.view.fsm:ChangeState(UIInteractionBubbleState.Idle)
  end
end

function StateInOut:OnExit()
end

return StateInOut
