local FollowPlayerStopMoveState = BaseClass("FollowPlayerStopMoveState")

function FollowPlayerStopMoveState:__init(player)
  self.player = player
end

function FollowPlayerStopMoveState:__delete()
end

function FollowPlayerStopMoveState:OnEnter(...)
  self.player:PlayMoveAnim(self.player.MoveAnim.Stand)
end

function FollowPlayerStopMoveState:OnExit()
end

function FollowPlayerStopMoveState:OnUpdate()
  local player = self.player
  if player:IsInQueue() then
    local prePlayer = player:GetPrePlayerInQueue()
    local forwardDir = prePlayer:GetForward()
    local targetPos = prePlayer:GetPosition() - forwardDir * player.QueueSpace
    local curPos = player:GetPosition()
    local distToTarget = Vector3.Distance(curPos, targetPos)
    if 0.01 < distToTarget then
      player:MoveInQueue()
    end
  elseif player:IsRescued() then
    local target = player:GetAttackTarget()
    if target ~= nil and target:GetCurBlood() > 0 then
      player:SetRotation(Quaternion.LookRotation(target:GetPosition() - player:GetPosition()))
      local distToTarget = Vector3.Distance(target:GetPosition(), player:GetPosition())
      if distToTarget < 2 then
        player:MoveAwayFromTarget()
      end
    else
      player:MoveInQueue()
    end
  end
end

return FollowPlayerStopMoveState
