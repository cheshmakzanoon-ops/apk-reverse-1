local base = require("Scene.LWHummerScene.Unit.LWHummerSceneUnitBase")
local LWHummerSceneUnitDominator = BaseClass("LWHummerSceneUnitDominator", base)
local Constant = require("Scene.LWHummerScene.LWHummerSceneConstant")
local FSMachine = require("Common.FSMachine")
LWHummerSceneUnitDominator.State = {
  Node = 0,
  Spawn = 1,
  Run = 2,
  Stay = 3,
  Hide = 4,
  MoveAttack = 5,
  Attack = 6
}

function LWHummerSceneUnitDominator:OnDestroy()
  base.OnDestroy(self)
  if self.fsm ~= nil then
    self.fsm:Dispose()
    self.fsm = nil
  end
  for _, groups in pairs(self.progressGroups) do
    for _, group in pairs(groups) do
      if not IsNull(group) then
        group:Destroy()
      end
    end
  end
  self.progressGroups = nil
  self.refreshTimer = nil
end

function LWHummerSceneUnitDominator:__init(param)
  self.curState = self.State.None
  self.buffState = {}
  self.fsm = FSMachine.Create(self)
  self.fsm:Add(self.State.Spawn, require("Scene.LWHummerScene.State.Dominator.LWHummerSceneUnitDominatorSpawn").Create())
  self.fsm:Add(self.State.Run, require("Scene.LWHummerScene.State.Dominator.LWHummerSceneUnitDominatorRun").Create())
  self.fsm:Add(self.State.Stay, require("Scene.LWHummerScene.State.Dominator.LWHummerSceneUnitDominatorStay").Create())
  self.fsm:Add(self.State.Hide, require("Scene.LWHummerScene.State.Dominator.LWHummerSceneUnitDominatorHide").Create())
  self.fsm:Add(self.State.MoveAttack, require("Scene.LWHummerScene.State.Dominator.LWHummerSceneUnitDominatorMoveAttack").Create())
  self.fsm:Add(self.State.Attack, require("Scene.LWHummerScene.State.Dominator.LWHummerSceneUnitDominatorAttack").Create())
end

function LWHummerSceneUnitDominator:InitBase(param)
  base.InitBase(self, param)
end

function LWHummerSceneUnitDominator:OnInited()
  base.OnInited(self)
  self.cfgId = self.bornData.cfgId
  self.cfg = DataCenter.AppearanceTemplateManager:GetTemplate(self.cfgId)
  self.bulletId = self.logic.data:GetDominatorBulletId(self.cfgId)
  self.bulletCfg = self.logic.data:GetBulletTemplate(self.bulletId)
  self.fireTrans = self.transform:Find(self.cfg.fire_path)
  self:ChangeState(self.State.Hide)
end

function LWHummerSceneUnitDominator:ChangeState(targetState, param)
  if self.curState == targetState then
    return
  end
  self.fsm:Switch(targetState, param)
  self.curState = targetState
end

function LWHummerSceneUnitDominator:OnUpdate(dt)
  base.OnUpdate(self, dt)
  if self.fsm then
    self.fsm:Update(dt)
  end
end

function LWHummerSceneUnitDominator:Recycle()
  base.Recycle(self)
  if self.fsm then
    self.fsm:Reset()
  end
end

function LWHummerSceneUnitDominator:GetMoveAtkTargetPos()
  local target = self.logic:GetDominatorMoveTarget()
  if target then
    return target:GetPosition()
  end
  return nil
end

function LWHummerSceneUnitDominator:GetBattleAtkTargetPos()
  local target = self.logic:GetDominatorBattleTarget()
  if target then
    return target:GetPosition()
  end
  return nil
end

function LWHummerSceneUnitDominator:SetActive(active)
  self.active = active
  self.gameObject:SetActive(active)
end

function LWHummerSceneUnitDominator:CastSkill(targetPos)
  self.logic:CastSkill(self.bulletId, self.fireTrans, targetPos)
end

return LWHummerSceneUnitDominator
