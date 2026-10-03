local NpcIdleState = BaseClass("NpcIdleState")

function NpcIdleState:__init(npc)
  self.npc = npc
end

function NpcIdleState:__delete()
end

function NpcIdleState:OnEnter(param)
  self.param = param
end

function NpcIdleState:OnExit()
end

function NpcIdleState:OnUpdate(deltaTime)
end

return NpcIdleState
