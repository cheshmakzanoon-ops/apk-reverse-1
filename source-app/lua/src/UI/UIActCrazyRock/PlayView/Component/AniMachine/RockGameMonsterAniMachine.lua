local RockGameBaseAniMachine = require("UI.UIActCrazyRock.PlayView.Component.AniMachine.RockGameBaseAniMachine")
local base = RockGameBaseAniMachine
local RockGameMonsterAniMachine = BaseClass("RockGameMonsterAniMachine", RockGameBaseAniMachine)
local Localization = CS.GameEntry.Localization
local magic_be_hit_eff_path = "ModelRoot/MonsterPoint/MonsterEffPoint/MagicBeHitEff"
local MonsterState = {
  Idle = 101,
  SingleBeHit = 201,
  PreContinueBeHit = 202,
  ContinueBeHit = 203,
  HeavyBeHit = 204
}

local function __init(self)
  base.__init(self)
end

local function __delete(self)
  base.__delete(self)
end

function RockGameMonsterAniMachine:Init(transform, aniSpeed, getRtNodeFunc, customParam)
  base.Init(self, transform, aniSpeed, getRtNodeFunc, customParam)
  self.ANI_NAME_CONFIG[MonsterState.Idle] = "Idle"
  self.ANI_NAME_CONFIG[MonsterState.SingleBeHit] = "MagicBeHit"
  self.ANI_NAME_CONFIG[MonsterState.PreContinueBeHit] = "PreNormalAtkBeHit"
  self.ANI_NAME_CONFIG[MonsterState.ContinueBeHit] = "NormalAtkBeHit"
  self.ANI_NAME_CONFIG[MonsterState.HeavyBeHit] = "MagicBeHit"
  if getRtNodeFunc then
    self.effectObjDic[self.ANI_NAME_CONFIG[MonsterState.SingleBeHit]] = getRtNodeFunc(magic_be_hit_eff_path)
  end
  self:SetEntityName("Monster")
  self.isShowDebug = true
  self:ChangeState(MonsterState.Idle)
end

function RockGameMonsterAniMachine:OnPlayerSuccessSingleHit(hitRet, params)
  base.OnPlayerSuccessSingleHit(self, hitRet, params)
  if hitRet.scoreType ~= CrazyRockScoreType.Perfect then
    if self.state ~= MonsterState.Idle then
      self:ChangeState(MonsterState.Idle)
    end
    return
  end
  if hitRet.isHeavyAttack then
    self:AutoChangeState(MonsterState.HeavyBeHit, MonsterState.Idle)
    return
  end
  if self.state ~= MonsterState.SingleBeHit then
    self:ChangeState(MonsterState.SingleBeHit, nil, 0)
  end
end

function RockGameMonsterAniMachine:OnEnterContinueClickState()
  base.OnEnterContinueClickState(self)
  if self.state ~= MonsterState.Idle then
    self:ChangeState(MonsterState.Idle)
  end
end

function RockGameMonsterAniMachine:OnPlayerSuccessContinueHit(hitRet, params)
  base.OnPlayerSuccessContinueHit(self, hitRet, params)
  if params and params.isPreAtk then
    self:ChangeState(MonsterState.PreContinueBeHit, function()
      self:AutoChangeState(MonsterState.ContinueBeHit, MonsterState.Idle)
    end)
  else
    self:AutoChangeState(MonsterState.ContinueBeHit, MonsterState.Idle)
  end
end

function RockGameMonsterAniMachine:OnNoteItemFinish(noteType)
  if noteType == CrazyRockNoteType.Continue then
    self:ChangeState(MonsterState.Idle)
  end
end

function RockGameMonsterAniMachine:OnBreakCombo(noteItem)
  base.OnBreakCombo(self, noteItem)
  if not noteItem then
    return
  end
  if self.state ~= MonsterState.Idle then
    self:ChangeState(MonsterState.Idle)
  end
end

function RockGameMonsterAniMachine:CheckMatchStateAndAni()
  if not self.simpleAni then
    return
  end
  if self.state == MonsterState.Idle and not self.simpleAni:IsPlaying(self.ANI_NAME_CONFIG[MonsterState.Idle]) then
    self.simpleAni:CrossFade(self.ANI_NAME_CONFIG[MonsterState.Idle], 0.2)
  end
end

return RockGameMonsterAniMachine
