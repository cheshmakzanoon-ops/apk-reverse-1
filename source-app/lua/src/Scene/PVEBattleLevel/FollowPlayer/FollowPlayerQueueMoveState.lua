local FollowPlayerQueueMoveState = BaseClass("FollowPlayerQueueMoveState")

function FollowPlayerQueueMoveState:__init(player)
  self.player = player
end

function FollowPlayerQueueMoveState:__delete()
end

function FollowPlayerQueueMoveState:OnEnter(...)
  self.player:PlayMoveAnim(self.player.MoveAnim.Run)
end

function FollowPlayerQueueMoveState:OnExit()
end

function FollowPlayerQueueMoveState:OnUpdate(deltaTime)
  local player = self.player
  local prePlayer = player:GetPrePlayerInQueue()
  local forwardDir = prePlayer:GetForward()
  local targetPos = prePlayer:GetPosition() - forwardDir * player.QueueSpace
  local curPos = player:GetPosition()
  local moveForward = Vector3.Normalize(targetPos - curPos)
  local moveLen = deltaTime * player:GetMoveSpeed()
  local distToTarget = Vector3.Distance(curPos, targetPos)
  if moveLen > distToTarget then
    player:SetRotation(Quaternion.LookRotation(forwardDir))
    player:SetPosition(targetPos)
    player:StopMove()
  else
    player:SetRotation(Quaternion.LookRotation(moveForward))
    player:SetPosition(curPos + moveForward * moveLen)
  end
end

return FollowPlayerQueueMoveState
