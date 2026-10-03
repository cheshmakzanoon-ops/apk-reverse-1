local FollowPlayerStopAttack = BaseClass("FollowPlayerStopAttack")

function FollowPlayerStopAttack:__init(player)
  self.player = player
end

function FollowPlayerStopAttack:__delete()
end

function FollowPlayerStopAttack:OnEnter(...)
  self.player:PlayAnim(self.player.Anim.StopAttack)
end

function FollowPlayerStopAttack:OnExit()
end

function FollowPlayerStopAttack:OnUpdate()
  local player = self.player
  local target = player:GetAttackTarget()
  if target ~= nil and target:GetCurBlood() > 0 then
    player:AttackTarget()
  end
end

return FollowPlayerStopAttack
