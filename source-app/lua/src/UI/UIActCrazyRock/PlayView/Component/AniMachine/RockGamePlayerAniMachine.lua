local RockGameBaseAniMachine = require("UI.UIActCrazyRock.PlayView.Component.AniMachine.RockGameBaseAniMachine")
local base = RockGameBaseAniMachine
local RockGamePlayerAniMachine = BaseClass("RockGamePlayerAniMachine", RockGameBaseAniMachine)
local Localization = CS.GameEntry.Localization
local normal_atk_eff_1_path = "ModelRoot/PlayerPoint/PlayerEffPoint/NormalAtkEff_1"
local normal_atk_eff_2_path = "ModelRoot/PlayerPoint/PlayerEffPoint/NormalAtkEff_2"
local normal_atk_eff_3_path = "ModelRoot/PlayerPoint/PlayerEffPoint/NormalAtkEff_3"
local PlayerState = {
  Idle = 101,
  ContinueIdle = 102,
  SingleAtk = 201,
  PreContinueAtk = 202,
  ContinueAtk = 203,
  HeavyAttack = 204
}

local function __init(self)
  base.__init(self)
end

local function __delete(self)
  base.__delete(self)
end

function RockGamePlayerAniMachine:Init(transform, aniSpeed, getRtNodeFunc, customParam)
  base.Init(self, transform, aniSpeed, getRtNodeFunc, customParam)
  self.ANI_NAME_CONFIG[PlayerState.Idle] = "Idle"
  self.ANI_NAME_CONFIG[PlayerState.ContinueIdle] = "ContinueIdle"
  self.ANI_NAME_CONFIG[PlayerState.SingleAtk] = "MagicAtk"
  self.ANI_NAME_CONFIG[PlayerState.PreContinueAtk] = "PreNormalAtk"
  self.ANI_NAME_CONFIG[PlayerState.ContinueAtk] = "NormalAtk"
  self.ANI_NAME_CONFIG[PlayerState.HeavyAttack] = "MagicAtk"
  if getRtNodeFunc then
    if not string.IsNullOrEmpty(customParam.idleEffPath) and not IsNull(self.transform) then
      local idleEffTrans = self.transform:Find(customParam.idleEffPath)
      if not IsNull(idleEffTrans) then
        self.effectObjDic[self.ANI_NAME_CONFIG[PlayerState.Idle]] = idleEffTrans.gameObject
      end
    end
    if not string.IsNullOrEmpty(customParam.atkEffPath) and not IsNull(self.transform) then
      local atkEffTrans = self.transform:Find(customParam.atkEffPath)
      if not IsNull(atkEffTrans) then
        self.effectObjDic[self.ANI_NAME_CONFIG[PlayerState.SingleAtk]] = atkEffTrans.gameObject
        self.effectObjDic[self.ANI_NAME_CONFIG[PlayerState.HeavyAttack]] = atkEffTrans.gameObject
      end
    end
    self.normalAtkEff1 = getRtNodeFunc(normal_atk_eff_1_path)
    self.normalAtkEff2 = getRtNodeFunc(normal_atk_eff_2_path)
    self.normalAtkEff3 = getRtNodeFunc(normal_atk_eff_3_path)
    if self.normalAtkEff1 then
      self.normalAtkEff1:SetActive(false)
    end
    if self.normalAtkEff2 then
      self.normalAtkEff2:SetActive(false)
    end
    if self.normalAtkEff3 then
      self.normalAtkEff3:SetActive(false)
    end
    self.allNormalAtkEffPool = {}
    self.allNormalAtkEffPool[1] = self.normalAtkEff1
    self.allNormalAtkEffPool[2] = self.normalAtkEff2
    self.allNormalAtkEffPool[3] = self.normalAtkEff3
    self.curUsedNormalAtkEffList = {}
    self.normalAtkEffHideTimerList = {}
  end
  self:SetEntityName("Player")
  self:ChangeState(PlayerState.Idle)
end

function RockGamePlayerAniMachine:OnEnterContinueClickState()
  base.OnEnterContinueClickState(self)
  self:ChangeState(PlayerState.ContinueIdle)
end

function RockGamePlayerAniMachine:OnExitContinueClickState()
  base.OnExitContinueClickState(self)
  self:ChangeState(PlayerState.Idle)
end

function RockGamePlayerAniMachine:OnPlayerSuccessSingleHit(hitRet, params)
  base.OnPlayerSuccessSingleHit(self, hitRet, params)
  if hitRet.isHeavyAttack then
    self:AutoChangeState(PlayerState.HeavyAttack, PlayerState.Idle)
    return
  end
  self:AutoChangeState(PlayerState.SingleAtk, PlayerState.Idle)
end

function RockGamePlayerAniMachine:CheckHeavyAttack(hitRet)
  if hitRet.secondNoteRemainHitTime / 1000 > self:GetAniDuration(self.ANI_NAME_CONFIG[PlayerState.HeavyAttack]) then
    return true
  end
  return false
end

function RockGamePlayerAniMachine:OnPlayerSuccessContinueHit(hitRet, params)
  base.OnPlayerSuccessContinueHit(self, hitRet, params)
  local isPreAtk = false
  if self.state ~= PlayerState.PreContinueAtk and self.state ~= PlayerState.ContinueAtk then
    self:ChangeState(PlayerState.PreContinueAtk, function()
      self:AutoChangeState(PlayerState.ContinueAtk, PlayerState.Idle)
    end)
    isPreAtk = true
  elseif hitRet.isFinish then
    self:ChangeState(PlayerState.Idle)
  else
    self:AutoChangeState(PlayerState.ContinueAtk, PlayerState.ContinueIdle, 0.1)
  end
  return isPreAtk
end

function RockGamePlayerAniMachine:OnNoteItemFinish(noteType)
  if self.state == PlayerState.ContinueIdle then
    self:ChangeState(PlayerState.Idle)
  end
end

function RockGamePlayerAniMachine:OnBreakCombo(noteItem)
  base.OnBreakCombo(self, noteItem)
  if not noteItem then
    return
  end
end

function RockGamePlayerAniMachine:PlayEffect(effectName)
  base.PlayEffect(self, effectName)
  if effectName == self.ANI_NAME_CONFIG[PlayerState.ContinueAtk] then
    self:GetOneNormalAtkEff()
  end
end

function RockGamePlayerAniMachine:GetOneNormalAtkEff()
  local eff
  for _, v in ipairs(self.allNormalAtkEffPool) do
    if not v.activeSelf then
      eff = v
      break
    end
  end
  if not eff then
    eff = self.curUsedNormalAtkEffList[1]
    self:ReturnNormalAtkToPool(eff)
  end
  if not eff then
    return
  end
  table.removebyvalue(self.curUsedNormalAtkEffList, eff)
  table.insert(self.curUsedNormalAtkEffList, eff)
  local hideTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:ReturnNormalAtkToPool(eff)
  end, 1)
  self.normalAtkEffHideTimerList[eff] = hideTimer
  eff:SetActive(true)
  return eff
end

function RockGamePlayerAniMachine:ReturnNormalAtkToPool(eff)
  if not eff then
    return
  end
  eff:SetActive(false)
  table.removebyvalue(self.curUsedNormalAtkEffList, eff)
  table.insert(self.allNormalAtkEffPool, eff)
  if self.normalAtkEffHideTimerList[eff] then
    self.normalAtkEffHideTimerList[eff]:Stop()
    self.normalAtkEffHideTimerList[eff] = nil
  end
end

function RockGamePlayerAniMachine:CheckMatchStateAndAni()
  if not self.simpleAni then
    return
  end
  if self.state == PlayerState.Idle and not self.simpleAni:IsPlaying(self.ANI_NAME_CONFIG[PlayerState.Idle]) then
    self.simpleAni:CrossFade(self.ANI_NAME_CONFIG[PlayerState.Idle], 0.2)
  end
end

function RockGamePlayerAniMachine:Destroy()
  base.Destroy(self)
  self.allNormalAtkEffPool = nil
  self.curUsedNormalAtkEffList = nil
  if self.normalAtkEffHideTimerList then
    for _, v in pairs(self.normalAtkEffHideTimerList) do
      v:Stop()
    end
    self.normalAtkEffHideTimerList = nil
  end
end

return RockGamePlayerAniMachine
