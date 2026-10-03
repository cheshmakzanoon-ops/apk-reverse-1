local base = require("Scene.LWBattle.ParkourBattle.ParkourUnit")
local MemberUnit = BaseClass("MemberUnit", base)
local FSM = require("Framework.Common.FSM")
local MoveStateLeftRight = require("Scene.LWBattle.ParkourBattle.Team.FSM.MoveStateLeftRight")
local MoveStateAllDirection = require("Scene.LWBattle.ParkourBattle.Team.FSM.MoveStateAllDirection")
local MoveStateAuto = require("Scene.LWBattle.ParkourBattle.Team.FSM.MoveStateAuto")
local StayState = require("Scene.LWBattle.ParkourBattle.Team.FSM.StayState")
local Const = require("Scene.LWBattle.Const")
local ColliderComponent = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.Component.ColliderComponent")
local UnitViewFacade = CS.PVEBattleLogic.Unit.UnitViewFacade
local VIEW_INVALID_HANDLE = -1
local BORN_TWEEN_SCALE = 1.3
local BORN_TWEEN_TRANS = 1
local BORN_TWEEN_INTERVAL = 0.2

function MemberUnit:Init(logic, team, parent, localPos)
  base.Init(self, logic)
  self.team = team
  self.parent = parent
  self.guid = logic:AllotUnitGuid()
  self.logic = logic
  self.anim = nil
  self.localPosition = localPos
  self.invincible = false
  self.initUnit = false
  self.bornTweenScale = self.logic.data.bornTweenScale or BORN_TWEEN_SCALE
  self.bornTweenTrans = self.logic.data.bornTweenTrans or BORN_TWEEN_TRANS
  self.bornTweenInterval = self.logic.data.bornTweenInterval or BORN_TWEEN_INTERVAL
  self.showedBornEffect = false
end

function MemberUnit:InitFSM()
  self.moveFsm = FSM.New()
  self.moveFsm:AddState(Const.ParkourMoveState.Auto, MoveStateAuto.New(self))
  self.moveFsm:AddState(Const.ParkourMoveState.LeftRight, MoveStateLeftRight.New(self))
  self.moveFsm:AddState(Const.ParkourMoveState.AllDirection, MoveStateAllDirection.New(self))
  self.moveFsm:AddState(Const.ParkourMoveState.BossStay, StayState.New(self))
  self:ChangeStage(self.logic.state)
end

function MemberUnit:OnUpdate(deltaTime)
  base.OnUpdate(self, deltaTime)
  if self.moveFsm then
    self.moveFsm:OnUpdate()
  end
  if self.bornEffectTimer then
    self.bornEffectTimer = self.bornEffectTimer - deltaTime
    if self.bornEffectTimer <= 0 then
      self:ClearBornTween()
    end
  end
end

function MemberUnit:SetLocalPosition(pos)
  self.localPosition = pos
  if self.transform then
    self.transform:DOKill()
    self:ClearBornTween()
    self.transform:Set_localPosition(self.localPosition.x, self.localPosition.y, self.localPosition.z)
  end
end

function MemberUnit:BornValidFlag()
  self.bornValidFlag = true
  if IsNotNull(self.transform) then
    self:ShowBornTween()
  end
end

function MemberUnit:ShowBornTween()
  if self.logic.lowQualityMode then
    return
  end
  if not self.bornValidFlag then
    return
  end
  self:ClearBornTween()
  if self.transform == nil then
    return
  end
  self.bornScaleTween = self.transform:DOScale(self.bornTweenScale, self.bornTweenInterval):SetEase(CS.DG.Tweening.Ease.OutCirc):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo)
  local tPos = self.localPosition * self.bornTweenTrans
  self.bornPosTween = self.transform:DOLocalMove(tPos, self.bornTweenInterval):SetEase(CS.DG.Tweening.Ease.OutCirc):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo)
  UnitViewFacade.MPBBornEffect(self.viewHandle)
  self.bornEffectTimer = self.bornTweenInterval * 2 + 0.1
end

function MemberUnit:ClearBornTween()
  if self.bornScaleTween then
    self.bornScaleTween:Kill()
    self.bornScaleTween = nil
  end
  if self.bornPosTween then
    self.bornPosTween:Kill()
    self.bornPosTween = nil
    UnitViewFacade.MPBResetBornEffect(self.viewHandle)
  end
  self.bornEffectTimer = nil
end

function MemberUnit:SetPosition(worldPos)
  if not IsNull(self.transform) then
    self.transform:DOKill()
    self:ClearBornTween()
    self.transform.position = worldPos
  end
end

function MemberUnit:MoveToLocalPos(dstLocalPos, time)
  if time < 0 then
    self:SetLocalPosition(dstLocalPos)
  elseif not IsNull(self.transform) then
    self.transform:DOLocalMove(dstLocalPos, time)
  else
    self:SetLocalPosition(dstLocalPos)
  end
end

function MemberUnit:GetPosition()
  local curFrame = Time.frameCount
  if self.getPosCurFrame == curFrame then
    return self.curWorldPos
  end
  self.getPosCurFrame = curFrame
  if self.transform then
    self.curWorldPos.x, self.curWorldPos.y, self.curWorldPos.z = self.transform:Get_position()
    return self.curWorldPos
  else
    self.curWorldPos = self.team:GetPosition() + self.localPosition
    return self.curWorldPos
  end
end

function MemberUnit:GetMoveVelocity()
  return Vector3.zero
end

function MemberUnit:DestroyView()
  self.bornValidFlag = nil
  if self.transform then
    self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
  end
  if self.bornEffectId then
    self.team.logic:RemoveEffectObj(self.bornEffectId)
    self.bornEffectId = nil
  end
  base.DestroyView(self)
  if self.moveFsm then
    self.moveFsm:Delete()
    self.moveFsm = nil
  end
  self:ClearBornTween()
  if self.req then
    self.req:Destroy()
    self.req = nil
    self.gameObject = nil
    self.transform = nil
  end
  if self.viewHandle and self.viewHandle > VIEW_INVALID_HANDLE then
    self.viewHandle = UnitViewFacade.DestroyUnitView(self.viewHandle)
  end
  self.gameObject = nil
  self.transform = nil
end

function MemberUnit:DestroyData()
  self.logic = nil
  self.appearanceMeta = nil
  base.DestroyData(self)
  self.parent = nil
  self.team = nil
end

function MemberUnit:Rotate(degree)
  self.transform:Rotate(Vector3.up, degree)
end

function MemberUnit:ShowBornEffect(bornEffectPath)
  if self.bornEffectId then
    self.team.logic:RemoveEffectObj(self.bornEffectId)
    self.bornEffectId = nil
  end
  local path
  if string.IsNullOrEmpty(self.customBornEffectPath) then
    path = bornEffectPath or Const.ParkourAddMemberEffectPath
  else
    path = self.customBornEffectPath
  end
  if not self.team then
    return
  end
  if self.showedBornEffect then
    return
  end
  if self.team and self.team.IsTeamDefaultUnit and self.team:IsTeamDefaultUnit(self.guid) then
    return
  end
  if self.team.logic.ShowHitEffectForViewTarget and self.viewHandle then
    self.bornEffectId = self.team.logic:ShowHitEffectForViewTarget(path, nil, nil, nil, 0.7, self.viewHandle)
  else
    self.bornEffectId = self.team.logic:ShowEffectObj(path, Vector3.zero, nil, 0.7, self.transform)
  end
  self.showedBornEffect = true
end

function MemberUnit:IsMoving()
  if self.moveFsm and self.moveFsm:GetStateIndex() == Const.ParkourMoveState.BossStay then
    return false
  elseif self.moveFsm and self.moveFsm:GetStateIndex() == Const.ParkourMoveState.AllDirection then
    return self.fingerDown
  else
    return true
  end
end

function MemberUnit:InitColliderComponent(layerMask, OnCollision)
  if self.transform and not self.colliderComponent then
    self.colliderComponent = ColliderComponent.New()
    local result = self.colliderComponent:InitCollider(self.transform, 10, layerMask)
    if not result then
      Logger.LogError("\232\175\165\229\141\149\228\189\141\230\160\185\232\138\130\231\130\185\228\184\138\231\188\186\229\176\145\231\162\176\230\146\158\231\155\146:" .. self.gameObject.name)
    end
    self.colliderComponent:SetOnCollide(OnCollision)
  end
end

function MemberUnit:GetMoveSpeed()
  return 999
end

function MemberUnit:ChangeStage(stage)
  if stage == Const.ParkourBattleState.Boss then
    if self.moveFsm then
      self.moveFsm:ChangeState(Const.ParkourMoveState.AllDirection)
    end
  elseif stage == Const.ParkourBattleState.BossStay then
    if self.moveFsm then
      self.moveFsm:ChangeState(Const.ParkourMoveState.BossStay)
    end
  elseif stage == Const.ParkourBattleState.BossHorizontal then
    if self.moveFsm then
      self.moveFsm:ChangeState(Const.ParkourMoveState.LeftRight)
    end
  elseif stage == Const.ParkourBattleState.PreExit then
  elseif stage == Const.ParkourBattleState.Exit then
    if self.moveFsm then
      self.moveFsm:ChangeState(Const.ParkourMoveState.Auto)
    end
  elseif stage == Const.ParkourBattleState.Farm and self.moveFsm then
    self.moveFsm:ChangeState(Const.ParkourMoveState.LeftRight)
  end
end

function MemberUnit:OnFingerHold(targetPos)
  if self.moveFsm then
    self.moveFsm:ChangeState(Const.ParkourMoveState.AllDirection, targetPos)
  end
end

function MemberUnit:OnFingerDown(pos)
  if self.appearanceMeta.walk_sound > 0 then
    self.soundUid = DataCenter.LWSoundManager:PlaySound(self.appearanceMeta.walk_sound, true)
  end
  self.fingerDown = true
end

function MemberUnit:OnFingerUp()
  if self.soundUid ~= nil and self.soundUid > 0 then
    DataCenter.LWSoundManager:StopSound(self.soundUid)
  end
  self.fingerDown = false
end

function MemberUnit:SetInitUnit()
  self.initUnit = true
end

function MemberUnit:GetTeamZeroWorldPos()
  if self.team then
    return self.team:GetZeroWorldPos()
  end
  return Vector3.zero
end

return MemberUnit
