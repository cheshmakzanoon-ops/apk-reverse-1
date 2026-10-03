local base = require("Scene.LWHummerScene.Unit.LWHummerSceneUnitBase")
local LWHummerSceneUnitJumpZombie = BaseClass("LWHummerSceneUnitJumpZombie", base)
local FSMachine = require("Common.FSMachine")
local LWBattleRVOAgent = CS.LWBattleRVOAgent
local Constant = require("Scene.LWHummerScene.LWHummerSceneConstant")
local Time = _ENV.Time
LWHummerSceneUnitJumpZombie.State = {
  None = 0,
  Born = 1,
  Run = 2,
  Jump = 3,
  Hold = 4,
  Drop = 5
}
LWHummerSceneUnitJumpZombie.DirType = {Left = 1, Right = 2}
LWHummerSceneUnitJumpZombie.AnimType = {
  Jump1 = {
    [LWHummerSceneUnitJumpZombie.DirType.Left] = "jumpL01",
    [LWHummerSceneUnitJumpZombie.DirType.Right] = "jumpR01"
  },
  Jump2 = {
    [LWHummerSceneUnitJumpZombie.DirType.Left] = "jumpL02",
    [LWHummerSceneUnitJumpZombie.DirType.Right] = "jumpR02"
  },
  Jump3 = {
    [LWHummerSceneUnitJumpZombie.DirType.Left] = "jumpL03",
    [LWHummerSceneUnitJumpZombie.DirType.Right] = "jumpR03"
  },
  Hold = {
    [LWHummerSceneUnitJumpZombie.DirType.Left] = "attackL",
    [LWHummerSceneUnitJumpZombie.DirType.Right] = "attackR"
  },
  Drop = {
    [LWHummerSceneUnitJumpZombie.DirType.Left] = "deadL",
    [LWHummerSceneUnitJumpZombie.DirType.Right] = "deadR"
  }
}

function LWHummerSceneUnitJumpZombie:OnDestroy()
  base.OnDestroy(self)
  if self.fsm ~= nil then
    self.fsm:Dispose()
    self.fsm = nil
  end
  self.agent = nil
  self.cfgId = nil
  self.cfg = nil
end

function LWHummerSceneUnitJumpZombie:__init(param)
  self.layerMask = LayerMask.GetMask(LayerType.Member)
  self.curState = self.State.None
  self.fsm = FSMachine.Create(self)
  self.fsm:Add(self.State.Born, require("Scene.LWHummerScene.State.JumpZombie.LWHummerSceneJumpZombieBorn").Create())
  self.fsm:Add(self.State.Run, require("Scene.LWHummerScene.State.JumpZombie.LWHummerSceneJumpZombieRun").Create())
  self.fsm:Add(self.State.Jump, require("Scene.LWHummerScene.State.JumpZombie.LWHummerSceneJumpZombieJump").Create())
  self.fsm:Add(self.State.Hold, require("Scene.LWHummerScene.State.JumpZombie.LWHummerSceneJumpZombieHold").Create())
  self.fsm:Add(self.State.Drop, require("Scene.LWHummerScene.State.JumpZombie.LWHummerSceneJumpZombieDrop").Create())
end

function LWHummerSceneUnitJumpZombie:OnInited()
  base.OnInited(self)
  self.cfgId = self.bornData.cfgId
  self.cfg = DataCenter.PveMonsterTemplateManager:GetTemplate(self.cfgId)
  self.effectMeta = DataCenter.PveHeroEffectTemplateManager:GetTemplate(self.cfg.monster_effect)
  if self.transform then
    self.sid = self.logic.rvoMgr:AddAgent(self:GetPosition(), self.gameObject, 5, 2)
    self.agent = self.transform:GetComponent(typeof(LWBattleRVOAgent))
    if self.agent then
      self.agent.speed = 0
      self.agent:SetActive(false)
    end
  end
  self.colliderComponent.active = false
  self.jumpDis = Constant.JUMP_ZOMBIE_DIS
  self.targetTrans = self.bornData.targetTrans
  self.targetPos = Vector3.New(0, 0, 0)
  self.targetTransDirType = self.bornData.targetTransDirType
  self.needDropTime = self.logic.data:GetZombieDropTime()
  self.showRewardDrop = true
  self:ChangeState(self.State.Born)
end

function LWHummerSceneUnitJumpZombie:ChangeState(targetState, param)
  if self.curState == targetState then
    return
  end
  self.fsm:Switch(targetState, param)
  self.curState = targetState
end

function LWHummerSceneUnitJumpZombie:OnUpdate(dt)
  base.OnUpdate(self, dt)
  if self.isLoaded and self.curPos.z < self.logic:GetFollowCameraTarget().z and self.curState ~= self.State.Jump and self.curState ~= self.State.Hold then
    self.logic:RemoveUnit(self)
    return
  end
  if self.fsm then
    self.fsm:Update(dt)
  end
end

function LWHummerSceneUnitJumpZombie:SetDestination(x, z)
  return self.agent:SetTargetPosition(x, z)
end

function LWHummerSceneUnitJumpZombie:RemoveDestination()
  return self.agent:SetActive(false)
end

function LWHummerSceneUnitJumpZombie:GetTargetPos()
  local curFrame = Time.frameCount
  if self.getPosCurFrame == curFrame then
    return self.targetPos
  end
  self.getPosCurFrame = curFrame
  if self.targetTrans then
    local x, y, z = self.targetTrans:Get_position()
    self.targetPos.x = x
    self.targetPos.z = z
  end
  return self.targetPos
end

function LWHummerSceneUnitJumpZombie:OnCollisionPlayer(other, trigger)
end

function LWHummerSceneUnitJumpZombie:Recycle()
  base.Recycle(self)
  if self.fsm then
    self.fsm:Reset()
  end
end

function LWHummerSceneUnitJumpZombie:ArriveJumpDis()
  local isArrive = false
  local targetPos = self:GetTargetPos()
  if targetPos then
    local dis = math.abs(targetPos.z - self.curPos.z)
    if dis <= self.jumpDis then
      isArrive = true
    end
  end
  return isArrive
end

function LWHummerSceneUnitJumpZombie:OnDropJumpZombie()
  if self.curState == self.State.Hold then
    self.needDropTime = self.needDropTime - 1
  end
end

function LWHummerSceneUnitJumpZombie:OnChangeJumpParent()
  self.transform.parent = self.targetTrans
end

function LWHummerSceneUnitJumpZombie:OnChangeDropParent()
  self.transform.parent = self.logic.unitMgr.root.transform
end

function LWHummerSceneUnitJumpZombie:SetLocalPosition(pos)
  self.transform:Set_localPosition(pos.x, pos.y, pos.z)
end

function LWHummerSceneUnitJumpZombie:GetLocalPosition()
  local x, y, z = self.transform:Get_localPosition()
  return Vector3.New(x, y, z)
end

function LWHummerSceneUnitJumpZombie:ResetLocalRotation()
  if self.DirType == self.DirType.Left then
    self.transform:Set_localEulerAngles(0, -90, 0)
  else
    self.transform:Set_localEulerAngles(0, 90, 0)
  end
end

function LWHummerSceneUnitJumpZombie:OnChangeBattle()
  self.showRewardDrop = false
  self:ChangeState(self.State.Drop)
end

return LWHummerSceneUnitJumpZombie
