local base = require("Scene.LWBattle.Surfing.SurfingUnit")
local SurfingHunterUnit = BaseClass("SurfingHunterUnit", base)
local SurfingHunterIdleState = require("Scene.LWBattle.Surfing.HunterKiller.HunterFSM.SurfingHunterIdleState")
local SurfingHunterRunState = require("Scene.LWBattle.Surfing.HunterKiller.HunterFSM.SurfingHunterRunState")
local SurfingHunterHuntState = require("Scene.LWBattle.Surfing.HunterKiller.HunterFSM.SurfingHunterHuntState")
local FSM = require("Framework.Common.FSM")
local UnitViewFacade = CS.PVEBattleLogic.Unit.UnitViewFacade
local pveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")
local Const = require("Scene.LWBattle.Const")
local VIEW_INVALID_HANDLE = -1
local LineOffset = 4
local LineChangeTime = 0.16
local JumpForce = 18
local Gravity = -50
local State = {
  Idle = 1,
  Running = 2,
  Hunt = 3
}

function SurfingHunterUnit:Init(logic, localPos, curLine, hero)
  base.Init(self, logic, localPos)
  if DataCenter.LWBattleManager.lineOffset then
    LineOffset = DataCenter.LWBattleManager.lineOffset
    LineChangeTime = DataCenter.LWBattleManager.lineChangeTime
    JumpForce = DataCenter.LWBattleManager.jumpForce
    Gravity = DataCenter.LWBattleManager.gravity
  end
  self.curLine = curLine
  self.baseLineX = localPos.x
  self.lineChangeTime = LineChangeTime
  self.localPosition = localPos
  self.unitType = UnitType.Plot
  self.searchType = BattleSearchType.Plot
  self.verticalVelocity = 0
  self.verticalAcceleration = 0
  self.isGrounded = true
  self.isJumping = nil
  self.moveSpeed = 20
  self.viewLoaded = false
  self.viewHandle = VIEW_INVALID_HANDLE
  local scale = 1
  local path = "Assets/Main/Prefabs/LWBattle/Surfing/Hero/Monster_surfing_paoku_dazhuang.prefab"
  self.viewHandle, self.viewLoaded = pveUnitViewUtil.CreateUnitView(self.guid, path, nil, scale, self.localPosition.x, self.localPosition.y, self.localPosition.z, ResetPosition.x, ResetPosition.y, ResetPosition.z, LayerMask.NameToLayer("Default"))
  if self.viewLoaded then
    self:OnViewLoaded(true)
  end
end

function SurfingHunterUnit:DestroyView()
  base.DestroyView(self)
end

function SurfingHunterUnit:DestroyData()
  base.DestroyData(self)
end

function SurfingHunterUnit:OnViewLoaded(force, objHandle)
  if self.viewLoaded and not force then
    return
  end
  self.viewLoaded = true
  self.gameObject = UnitViewFacade.GetGameObject(self.viewHandle)
  self.transform = UnitViewFacade.GetTransform(self.viewHandle)
  self:ComponentDefineWithoutView()
  self:InitFSM()
end

function SurfingHunterUnit:InitFSM()
  self.fsm = FSM.New()
  self.fsm:AddState(State.Idle, SurfingHunterIdleState.New(self))
  self.fsm:AddState(State.Running, SurfingHunterRunState.New(self))
  self.fsm:AddState(State.Hunt, SurfingHunterHuntState.New(self))
  if self.cacheFsm then
    self:ChangeState(self.cacheFsm)
  elseif self.logic and self.logic.state and self.logic.state == Const.SurfingState.Surfing then
    self.fsm:ChangeState(State.Running)
  else
    self.fsm:ChangeState(State.Idle)
  end
  self.cacheFsm = nil
end

function SurfingHunterUnit:ChangeState(newState)
  if self.fsm == nil then
    self.cacheFsm = newState
    return
  end
  self.state = newState
  if newState == Const.SurfingState.Surfing then
    self.fsm:ChangeState(State.Running)
  end
end

local function HandleBasicMovement(self, deltaTime)
  local moveDirection = Vector3.forward
  local position = self:GetPosition()
  local targetVelocity = moveDirection * self.moveSpeed * deltaTime
  targetVelocity = targetVelocity + position
  if not self.isGrounded then
    local vo = self.verticalVelocity
    local a = self.verticalAcceleration
    self.verticalMoveTimer = self.verticalMoveTimer + deltaTime
    local t = self.verticalMoveTimer
    local vert = vo * t + 0.5 * a * t * t
    local newY = self.verticalMoveStartY + vert
    if newY <= 0 then
      self.isGrounded = true
      self.isJumping = false
      self:CrossFadeSimpleAnim("run", 1, 0.2)
      newY = 0
    end
    targetVelocity.y = newY
  end
  if self.lineChangeTimer then
    self.lineChangeTimer = self.lineChangeTimer - deltaTime
    local curX = Mathf.Lerp(self.targetX, self.curX, self.lineChangeTimer / self.lineChangeTime)
    targetVelocity.x = curX
    if 0 >= self.lineChangeTimer then
      self.lineChangeTimer = nil
      self:CrossFadeSimpleAnim("run", 1, 0.2)
    end
  end
  self:SetPositionXYZ(targetVelocity.x, targetVelocity.y, targetVelocity.z)
end

function SurfingHunterUnit:OnUpdate(deltaTime)
  base.OnUpdate(self, deltaTime)
  HandleBasicMovement(self, deltaTime)
end

function SurfingHunterUnit:GetPosition()
  local curFrame = Time.frameCount
  if self.getPosCurFrame == curFrame then
    return self.curWorldPos
  end
  self.getPosCurFrame = curFrame
  if IsNotNull(self.transform) then
    self.curWorldPos.x, self.curWorldPos.y, self.curWorldPos.z = self.transform:Get_position()
    return self.curWorldPos
  else
    return self.localPosition
  end
end

function SurfingHunterUnit:OnMoveLeft()
  if self.curLine > -1 then
    self.curLine = self.curLine - 1
    self.curX = self:GetPosition().x
    self.targetX = self.baseLineX + self.curLine * LineOffset
    self.lineChangeTimer = LineChangeTime
    self:CrossFadeSimpleAnim("move_left", 1, 0.2)
  end
end

function SurfingHunterUnit:OnMoveRight()
  if self.curLine < 1 then
    self.curLine = self.curLine + 1
    self.curX = self:GetPosition().x
    self.targetX = self.baseLineX + self.curLine * LineOffset
    self.lineChangeTimer = LineChangeTime
    self:CrossFadeSimpleAnim("move_right", 1, 0.2)
  end
end

function SurfingHunterUnit:OnMoveUp()
  if self.isGrounded then
    self.isGrounded = false
    self:CrossFadeSimpleAnim("up", 1, 0.2)
    self.verticalVelocity = JumpForce
    self.verticalAcceleration = Gravity
    self.verticalMoveTimer = 0
    self.verticalMoveStartY = self:GetPosition().y
    self.isJumping = true
  end
end

return SurfingHunterUnit
