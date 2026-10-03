local BaseBehaviourState = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.BHBaseBehaviourState")
local MonsterBehaviourStateAlert = BaseClass("MonsterBehaviourStateAlert", BaseBehaviourState)
local base = BaseBehaviourState
local ALERT_EFF_PATH = "Assets/Main/Prefabs/BountyHunter/Effect/Eff_s_BountyHunter_tanhao.prefab"
local ALERT_TIME = 1
local JUMP_HEIGHT = 0.5

local function __init(self)
  base.__init(self)
end

local function __delete(self)
  base.__delete(self)
end

function MonsterBehaviourStateAlert:OnRegister(stateType, param)
  base.OnRegister(self, stateType, param)
end

function MonsterBehaviourStateAlert:OnRemove()
  base.OnRemove(self)
  self:StopAllTimerAndTween()
end

function MonsterBehaviourStateAlert:OnEnter(param)
  base.OnEnter(self)
  self:OnExecute(param)
  self:ShowStateLog("[bounty hunter state] Enter MonsterBehaviourStateAlert. uid: " .. self.itemEntity.monsterData.uuid)
end

function MonsterBehaviourStateAlert:OnExecute(param)
  base.OnExecute(self)
  self:GenAlertEff()
  self.toSeekStateTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.toSeekStateTimer = nil
    self.itemEntity:ChangeBehaviourState(BountyMonsterStateType.Seek, param)
  end, ALERT_TIME)
  local isJumpMove = not self.itemEntity:IsFlyMonster()
  self:StartJump(isJumpMove, param)
end

function MonsterBehaviourStateAlert:StartJump(isJumpMove, targetPos)
  self.itemEntity:CrossFade("run")
  local startPos = self.itemEntity.transform.position
  local jumpEndPos = startPos + Vector3.up * JUMP_HEIGHT
  local targetDir = targetPos - self.itemEntity.transform.position
  if CS.UnityEngine.Application.isEditor then
    CS.UnityEngine.Debug.DrawLine(targetPos, self.itemEntity.transform.position, Color.red, 2)
  end
  local targetRotate = Quaternion.LookRotation(Vector3.New(targetDir.x, 0, targetDir.z))
  self.jumpSeq = DOTween.Sequence()
  if isJumpMove then
    self.jumpSeq:Append(self.itemEntity.transform:DOMove(jumpEndPos, ALERT_TIME / 2))
  end
  self.jumpSeq:Join(self.itemEntity.transform:DORotateQuaternion(targetRotate, ALERT_TIME / 2))
  if isJumpMove then
    self.jumpSeq:Append(self.itemEntity.transform:DOMove(startPos, ALERT_TIME / 2))
  end
end

function MonsterBehaviourStateAlert:GenAlertEff()
  self.alertReq = self.itemEntity:GenOneEff(ALERT_EFF_PATH, self.itemEntity.transform.parent, self.itemEntity.transform.position)
  self.alertEffTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.alertEffTimer = nil
    if self.alertReq then
      self.alertReq:Destroy()
      self.alertReq = nil
    end
  end, ALERT_TIME)
end

function MonsterBehaviourStateAlert:OnExit()
  base.OnExit(self)
end

function MonsterBehaviourStateAlert:StopAllTimerAndTween()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if self.itemEntity then
    self.itemEntity:StopMove()
  end
  if self.alertReq then
    self.alertReq:Destroy()
    self.alertReq = nil
  end
  if self.jumpSeq then
    self.jumpSeq:Kill()
    self.jumpSeq = nil
  end
end

MonsterBehaviourStateAlert.__init = __init
MonsterBehaviourStateAlert.__delete = __delete
return MonsterBehaviourStateAlert
