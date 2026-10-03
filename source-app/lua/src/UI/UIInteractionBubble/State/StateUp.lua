local StateUp = BaseClass("StateUp")

function StateUp:__init(view)
  self.view = view
end

function StateUp:__delete()
end

function StateUp:OnEnter()
  self.view:AllBubbleUp()
end

function StateUp:OnUpdate()
end

function StateUp:OnExit()
end

function StateUp:OnUpdate()
end

return StateUp
