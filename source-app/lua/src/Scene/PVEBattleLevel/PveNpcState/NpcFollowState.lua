local NpcFollowState = BaseClass("NpcFollowState")
local Speed = 0.08
local LevelDistance = 0.5
local State = {Move = 1, Idle = 2}

function NpcFollowState:__init(npc)
  self.npc = npc
  self.state = State.Idle
end

function NpcFollowState:__delete()
end

function NpcFollowState:OnEnter(param)
  self.param = param
  self:ChangeState(State.Move)
end

function NpcFollowState:OnExit()
end

function NpcFollowState:OnUpdate(deltaTime)
  if self.state == State.Move then
    self.endPos = DataCenter.BattleLevel:GetPosition() + self.param.extraPos
    local curPos = self.npc:GetPosition()
    local distToTarget = Vector3.Distance(curPos, self.endPos)
    if distToTarget < LevelDistance then
      self:ChangeState(State.Idle)
    else
      local moveForward = Vector3.Normalize(self.endPos - curPos)
      self.npc:SetRotation(Quaternion.LookRotation(-moveForward))
      self.npc:SetPosition(curPos + moveForward * Speed)
    end
  end
end

function NpcFollowState:ChangeState(state)
  if self.state ~= state then
    self.state = state
    self.npc:RefreshAnim()
  end
end

function NpcFollowState:GetAnimName()
  if self.state == State.Move then
    return self.npc.AnimName.Walk
  end
  return self.npc.AnimName.Idle
end

function NpcFollowState:OnPlayerMoveSignal(pos)
  if self.state == State.Idle then
    self.endPos = DataCenter.BattleLevel:GetPosition() + self.param.extraPos
    local curPos = self.npc:GetPosition()
    local distToTarget = Vector3.Distance(curPos, self.endPos)
    if distToTarget > LevelDistance then
      self:ChangeState(State.Move)
    end
  end
end

return NpcFollowState
