local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)

function State.Create()
  local copy = {}
  setmetatable(copy, State)
  copy:Init()
  return copy
end

function State:Init()
end

function State:OnEnter()
  if self.owner then
    self.owner:PlaySimpleAnim("fRun")
    self.HorizontalMoveState = self.owner.HorizontalMoveState
    self.HitState = self.owner.HitState
    self.curHorizontalState = self.HorizontalMoveState.Idle
    self.widthDrift = self.owner.logic.data.stage.widthDrift
  end
end

function State:OnExit()
  if self.soundId then
    DataCenter.LWSoundManager:StopSound(self.soundId)
  end
end

function State:OnUpdate(deltaTime)
  if self.owner == nil then
    return
  end
  local speed = self.owner:GetMoveSpeedVertical()
  local position = self.owner:GetPosition()
  local moveZ = position.z + speed * deltaTime
  self.owner:SetPosition(position.x, moveZ)
  self.lRunLength = self.owner:GetAnimLength("lRun")
  self.rRunLength = self.owner:GetAnimLength("rRun")
  self.lHitLength = self.owner:GetAnimLength("lHit")
  self.rHitLength = self.owner:GetAnimLength("rHit")
  if self.speedLevel ~= self.owner.speedLevel then
    self.speedLevel = self.owner.speedLevel
    self.soundId = DataCenter.LWSoundManager:PlaySound(SoundAssetId.hummer_run_1 + self.speedLevel, true)
  end
  if self.horizontalAnimLength then
    self.horizontalAnimLength = self.horizontalAnimLength - deltaTime
    if self.horizontalAnimLength <= 0 then
      self.horizontalAnimLength = nil
      self:ChangeHorizontalState(self.HorizontalMoveState.Idle, 0)
    end
  end
  if self.hitAnimLength then
    self.hitAnimLength = self.hitAnimLength - deltaTime
    if 0 >= self.hitAnimLength then
      self.hitAnimLength = nil
      self:ShowHit(self.HitState.None)
    end
  end
end

function State:ChangeHorizontalState(state, value)
  if self.curHorizontalState == state or value < self.widthDrift then
    return
  end
  if state == self.HorizontalMoveState.Idle and self.horizontalAnimLength ~= nil then
    return
  end
  if state == self.HorizontalMoveState.Idle then
    self.owner:PlaySimpleAnim("fRun")
  elseif state == self.HorizontalMoveState.Left then
    self.owner:PlaySimpleAnim("lRun")
    self.horizontalAnimLength = self.lRunLength
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.hummer_piaoyi, false)
  elseif state == self.HorizontalMoveState.Right then
    self.owner:PlaySimpleAnim("rRun")
    self.horizontalAnimLength = self.rRunLength
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.hummer_piaoyi, false)
  end
  self.owner.logic:DropJumpZombie()
  self.curHorizontalState = state
end

function State:ShowHit(state)
  if self.curHorizontalState == self.HorizontalMoveState.Idle then
    if state == self.HitState.Left then
      self.owner:PlaySimpleAnim("lHit")
      self.hitAnimLength = self.lHitLength
    elseif state == self.HitState.Right then
      self.owner:PlaySimpleAnim("rHit")
      self.hitAnimLength = self.rHitLength
    else
      self.owner:PlaySimpleAnim("fRun")
    end
  end
end

return State
