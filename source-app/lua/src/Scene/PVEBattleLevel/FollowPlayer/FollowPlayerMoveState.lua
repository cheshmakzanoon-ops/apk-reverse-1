local FollowPlayerMoveState = BaseClass("FollowPlayerMoveState")

function FollowPlayerMoveState:__init(player)
  self.player = player
end

function FollowPlayerMoveState:__delete()
end

function FollowPlayerMoveState:OnEnter(...)
  self.player:PlayMoveAnim(self.player.MoveAnim.Run)
end

function FollowPlayerMoveState:OnExit()
end

function FollowPlayerMoveState:OnUpdate(deltaTime)
  local player = self.player
  local target = player:GetAttackTarget()
  if target ~= nil and target:GetCurBlood() > 0 then
    local distToTarget = Vector3.Distance(player:GetPosition(), target:GetPosition())
    if distToTarget < player:GetAttackRadius() then
      if distToTarget > player:GetAttackRadius() - 2 then
        player:StopMove()
      else
        local moveLen = deltaTime * player:GetMoveBackSpeed()
        local curPos = player:GetPosition()
        local forwardDir = Vector3.Normalize(target:GetPosition() - curPos)
        player:SetRotation(Quaternion.LookRotation(forwardDir))
        player:SetPosition(curPos - forwardDir * moveLen)
      end
    else
      player:MoveInQueue()
    end
  else
    player:MoveInQueue()
  end
end

return FollowPlayerMoveState
