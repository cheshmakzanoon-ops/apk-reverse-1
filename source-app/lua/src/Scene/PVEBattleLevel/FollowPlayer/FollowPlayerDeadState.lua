local FollowPlayerDeadState = BaseClass("FollowPlayerDeadState")

function FollowPlayerDeadState:__init(player)
  self.player = player
end

function FollowPlayerDeadState:__delete()
end

function FollowPlayerDeadState:OnEnter(...)
  self.player:PlayAnim(self.player.Anim.Dead)
end

function FollowPlayerDeadState:OnExit()
end

function FollowPlayerDeadState:OnUpdate()
end

return FollowPlayerDeadState
