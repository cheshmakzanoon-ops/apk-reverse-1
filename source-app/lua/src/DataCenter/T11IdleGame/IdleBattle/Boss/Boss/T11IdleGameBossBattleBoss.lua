local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")
local T11IdleGameBossBattleBoss = BaseClass("T11IdleGameBossBattleBoss")
local ResourceManager = CS.GameEntry.Resource
local FSMachine = require("Common.FSMachine")
local BornState = require("DataCenter/T11IdleGame/IdleBattle/Boss/Boss/State/T11IdleGameBossBattleBossStateBorn")
local IdleState = require("DataCenter/T11IdleGame/IdleBattle/Boss/Boss/State/T11IdleGameBossBattleBossStateIdle")
local StrikeState = require("DataCenter/T11IdleGame/IdleBattle/Boss/Boss/State/T11IdleGameBossBattleBossStateStrike")
local BattleState = require("DataCenter/T11IdleGame/IdleBattle/Boss/Boss/State/T11IdleGameBossBattleBossStateBattle")

function T11IdleGameBossBattleBoss:__init(logic, root)
  self.logic = logic
  self.root = root
  self.bossMeta = nil
  self.monsterMeta = nil
  self.obj = nil
  self.anim = nil
  self.animEffectController = nil
  self.animRoot = root.transform:GetComponent(typeof(CS.SimpleAnimation))
  self.shieldEffectObj = root.transform:Find("Eff_T11_Boss_Shield").gameObject
  self.shieldCrackEffectObj = root.transform:Find("Eff_T11_Boss_Shield_Crack").gameObject
  self.shieldEffectObj:SetActive(false)
  self.shieldCrackEffectObj:SetActive(false)
  self.hitTarget = nil
  self.curState = Const.BossBattleBossState.None
  self.fsm = FSMachine.Create(self)
  self.fsm:Add(Const.BossBattleBossState.Born, BornState.New(self))
  self.fsm:Add(Const.BossBattleBossState.Idle, IdleState.New(self))
  self.fsm:Add(Const.BossBattleBossState.Battle, BattleState.New(self))
  self.fsm:Add(Const.BossBattleBossState.Strike, StrikeState.New(self))
end

function T11IdleGameBossBattleBoss:__delete()
  self:Destroy()
end

function T11IdleGameBossBattleBoss:Load(bossMeta, bornFinishCallback)
  self.bossMeta = bossMeta
  if not bossMeta then
    return
  end
  local monsterId = self.bossMeta:GetRandomMonsterId()
  monsterId = monsterId or Const.NodeBattleDefaultMonsterId
  self.monsterMeta = DataCenter.PveMonsterTemplateManager:GetTemplate(monsterId)
  if not self.monsterMeta then
    return
  end
  local req = ResourceManager:InstantiateAsync(self.monsterMeta.asset)
  req:completed("+", function(request)
    if request.isError or IsNull(self.root) then
      return
    end
    request.gameObject.transform:SetParent(self.root.transform)
    request.gameObject.transform:Set_localPosition(0, 0, 0)
    request.gameObject.transform:Set_localEulerAngles(0, 0, 0)
    request.gameObject.transform:Set_localScale(1.1, 1.1, 1.1)
    self.animEffectController = request.gameObject.transform:GetComponent(typeof(CS.T11IdleGameBossBattleAnimationController))
    self.anim = self.animEffectController:GetMainAnim()
    self.animEffectController:HideAllEffects()
    self:ChangeState(Const.BossBattleBossState.Born, bornFinishCallback)
    self.logic:PlaySceneCameraAnim("Born")
  end)
  self.req = req
end

function T11IdleGameBossBattleBoss:ClearBoss()
  if self.req then
    self.req:Destroy()
  end
  self.req = nil
  self.bossMeta = nil
  self.monsterMeta = nil
  self.obj = nil
  self.anim = nil
end

function T11IdleGameBossBattleBoss:Destroy()
  self:ClearBoss()
  self.logic = nil
  self.root = nil
  self.animRoot = nil
  self.animEffectController = nil
  if IsNotNull(self.shieldEffectObj) then
    self.shieldEffectObj:SetActive(false)
  end
  if IsNotNull(self.shieldCrackEffectObj) then
    self.shieldCrackEffectObj:SetActive(false)
  end
  self.shieldEffectObj = nil
  self.shieldCrackEffectObj = nil
  self.hitTarget = nil
  if self.fsm then
    self.fsm:Dispose()
    self.fsm = nil
  end
  self.curState = nil
end

function T11IdleGameBossBattleBoss:GetAnimLength(name)
  if IsNotNull(self.anim) then
    return self.anim:GetClipLength(name)
  end
  return 1
end

function T11IdleGameBossBattleBoss:PlayAnim(name)
  if IsNotNull(self.animEffectController) then
    DataCenter.T11IdleGameManager:PrintEditorCustomLog("T11IdleGameBossBattleBoss:PlayAnim " .. name)
    return self.animEffectController:Play(name)
  end
end

function T11IdleGameBossBattleBoss:GetMonsterTotalHp()
  return Const.BossBattleDefaultBossHp
end

function T11IdleGameBossBattleBoss:PlayRootAnim(name)
  if IsNotNull(self.animRoot) then
    self.animRoot:Play(name)
  end
end

function T11IdleGameBossBattleBoss:ChangeState(state, ...)
  if self.curState == state then
    return
  end
  self.curState = state
  self.fsm:Switch(state, ...)
end

function T11IdleGameBossBattleBoss:GetHitPosition(index)
  if IsNull(self.hitTarget) and IsNotNull(self.animEffectController) then
    return self.animEffectController:GetHitTarget(index - 1).transform.position
  end
  if IsNotNull(self.hitTarget) then
    return self.hitTarget.transform.position
  end
  return Vector3.zero
end

function T11IdleGameBossBattleBoss:BeHit(isFinalWave)
  if isFinalWave then
    if self.shieldCrackEffectTimer ~= nil then
      return
    end
    self.shieldCrackEffectTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.shieldCrackEffectTimer = nil
    end, 0.5)
    if IsNotNull(self.shieldCrackEffectObj) then
      DataCenter.T11IdleGameManager:PrintEditorCustomLog("T11IdleGameBossBattleBoss:BeHit shieldCrackEffectObj")
      self.shieldCrackEffectObj:SetActive(false)
      self.shieldCrackEffectObj:SetActive(true)
    end
  else
    if self.shieldEffectTimer ~= nil then
      return
    end
    self.shieldEffectTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.shieldEffectTimer = nil
    end, 0.5)
    if IsNotNull(self.shieldEffectObj) then
      DataCenter.T11IdleGameManager:PrintEditorCustomLog("T11IdleGameBossBattleBoss:BeHit shieldEffectObj")
      self.shieldEffectObj:SetActive(false)
      self.shieldEffectObj:SetActive(true)
    end
  end
end

return T11IdleGameBossBattleBoss
