local BaseBehaviourState = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.BHBaseBehaviourState")
local HunterBehaviourStateAttack = BaseClass("HunterBehaviourStateAttack", BaseBehaviourState)
local base = BaseBehaviourState
local Const = require("UI/UIActivityCenterTable/Component/ActBountyHunter/BountyHunterConstant")
local ATTACK_TIME = 1
local ATTACK_TIME_LONG = 1.5

local function __init(self)
  base.__init(self)
  self.attackTimer = nil
end

local function __delete(self)
  base.__delete(self)
end

function HunterBehaviourStateAttack:OnRegister(stateType, param)
  base.OnRegister(self, stateType, param)
end

function HunterBehaviourStateAttack:OnRemove()
  base.OnRemove(self)
  self:StopAllTimerAndTween()
end

function HunterBehaviourStateAttack:OnEnter(param)
  base.OnEnter(self)
  self:OnExecute(param)
  if self.itemEntity and self.itemEntity.scene then
    self.itemEntity.scene:SetVirtualCameraMachineShake(true)
  end
  self:ShowStateLog("[bounty hunter state] Enter HunterBehaviourStateAttack")
end

function HunterBehaviourStateAttack:OnExecute(param)
  base.OnExecute(self)
  if not (param and param.targetItem) or not self.itemEntity then
    return
  end
  local time = self:StartShoot(param)
  if self.attackTimer then
    self.attackTimer:Stop()
    self.attackTimer = nil
  end
  self.attackTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.itemEntity then
      EventManager:GetInstance():Broadcast(EventId.BountyHunterHunterAttackAniFinish, param)
      if self.itemEntity and self.itemEntity.scene then
        self.itemEntity.scene:SetVirtualCameraMachineShake(false)
      end
    end
  end, time)
end

function HunterBehaviourStateAttack:StartShoot(param)
  if self.delayAimTimer then
    self.delayAimTimer:Stop()
    self.delayAimTimer = nil
  end
  if param == nil then
    return
  end
  local shootParam = {}
  shootParam.isAimingBoss = self.itemEntity:IsAimingBoss()
  shootParam.targetPos = self.itemEntity:GetAimingWorldPos()
  shootParam.bulletType = param.bulletType
  if param.isFromIdleState == true then
    if shootParam.targetPos then
      self.itemEntity:AimTarget(shootParam.targetPos)
    end
    self:HandleRealShoot(shootParam)
  else
    self:HandleRealShoot(shootParam)
  end
  return Const.HUNTER_ATTACK_ANIM_LENGTH_DICT[shootParam.bulletType] or Const.HUNTER_ATTACK_ANIM_LENGTH_DICT[BountyMonsterBulletType.Gun1]
end

function HunterBehaviourStateAttack:HandleRealShoot(shootParam)
  if not self.itemEntity or not shootParam then
    return
  end
  if shootParam.bulletType == BountyMonsterBulletType.Gun1 then
    self.itemEntity:CrossFade("Attack", 0.1)
    self.itemEntity:CreateBullet(shootParam)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_Shangjin_Buqiang_Multi, false)
  elseif shootParam.bulletType == BountyMonsterBulletType.Gun2Small then
    self.itemEntity:CrossFade("Attack2Small", 0.1)
    self.itemEntity:CreateGun2EffectSmall()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_Shangjin_Jiguang, false)
  elseif shootParam.bulletType == BountyMonsterBulletType.Gun2Big then
    self.itemEntity:CrossFade("Attack2Big", 0.1)
    self.itemEntity:CreateGun2EffectBig()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_Shangjin_Jiguang_Big, false)
  end
  self.itemEntity:SetLastShootIsBig(shootParam.bulletType == BountyMonsterBulletType.Gun2Big)
end

function HunterBehaviourStateAttack:OnExit()
  base.OnExit(self)
  self:StopAllTimerAndTween()
end

function HunterBehaviourStateAttack:StopAllTimerAndTween()
  if self.attackTimer then
    self.attackTimer:Stop()
    self.attackTimer = nil
  end
end

HunterBehaviourStateAttack.__init = __init
HunterBehaviourStateAttack.__delete = __delete
return HunterBehaviourStateAttack
