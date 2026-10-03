local StateIdle = BaseClass("StateIdle")

function StateIdle:__init(view)
  self.view = view
end

function StateIdle:__delete()
end

function StateIdle:OnEnter()
end

function StateIdle:OnUpdate()
  if self.view:HasFlyOutTask() then
    self.view.fsm:ChangeState(UIInteractionBubbleState.InOut)
  elseif DataCenter.InteractionBubbleManager:HasFlyInTask() then
    if self.view:IsBottomEmpty() then
      self.view.fsm:ChangeState(UIInteractionBubbleState.InOut)
    elseif self.view:IsFull() then
      self.view:TopBubbleEnqueueFlyOut()
    else
      self.view.fsm:ChangeState(UIInteractionBubbleState.Up)
    end
  end
end

function StateIdle:OnExit()
end

return StateIdle
