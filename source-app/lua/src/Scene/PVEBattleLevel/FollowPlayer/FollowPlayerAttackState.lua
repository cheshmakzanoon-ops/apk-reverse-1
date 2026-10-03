local FollowPlayerAttackState = BaseClass("FollowPlayerAttackState")

function FollowPlayerAttackState:__init(player)
  self.player = player
end

function FollowPlayerAttackState:__delete()
end

function FollowPlayerAttackState:OnEnter(...)
  self.player:PlayAnim(self.player.Anim.Attack)
  self.fireTimer = TimerManager:GetInstance():GetTimer(0.5, function()
    self.player:Fire()
  end, nil, false, false, false)
  self.fireTimer:Start()
end

function FollowPlayerAttackState:OnExit()
  if self.fireTimer then
    self.fireTimer:Stop()
    self.fireTimer = nil
  end
end

function FollowPlayerAttackState:OnUpdate()
  local player = self.player
  local target = player:GetAttackTarget()
  if target == nil or target:GetCurBlood() <= 0 then
    player:StopAttack()
  else
    local distToTarget = Vector3.Distance(target:GetPosition(), player:GetPosition())
    if distToTarget > player:GetAttackRadius() then
      player:StopAttack()
    end
  end
end

return FollowPlayerAttackState
