local base = require("Scene.PVEBattleLevel.Player.PlayerAnimation.PlayerAniBase")
local PlayerAniAttack = BaseClass("PlayerAniAttack", base)
local Resource = CS.GameEntry.Resource
local _cp_path_sickle = "A_soldie_ben/A_soldie@ben_skin/To_unity/DeformationSystem/Root/guadian/A_soldie_ben_sickle"
local _cp_path_sickle_hero = "A_Hero_low/A_Hero_low_skin/To_unity/DeformationSystem/Root/guadian/A_soldie_shxr_sickle"
local path_Weapon_buff = "A_soldie_ben/A_soldie@ben_skin/To_unity/DeformationSystem/Root"
local path_Weapon_hero_buff = "A_Hero_low/A_Hero_low_skin/To_unity/DeformationSystem/Root"
local AttackName = "_attack_"

function PlayerAniAttack:__init(spaceman)
  local objTransform = self.m_citySpaceMan:GetTransform()
  if spaceman.isHero ~= nil and spaceman.isHero == true then
    self.m_objSickle = objTransform:Find(_cp_path_sickle_hero)
    if self.m_objSickle ~= nil then
      self.m_sickleCollider = self.m_objSickle:GetComponent(typeof(CS.UnityEngine.CapsuleCollider))
    end
    self.m_objWeaponBuffEffect = objTransform:Find(path_Weapon_hero_buff)
  else
    self.m_objSickle = objTransform:Find(_cp_path_sickle)
    if self.m_objSickle ~= nil then
      self.m_sickleCollider = self.m_objSickle:GetComponent(typeof(CS.UnityEngine.CapsuleCollider))
    end
    self.m_objWeaponBuffEffect = objTransform:Find(path_Weapon_buff)
  end
  self.animIndex = 0
  self.useRandomAttack = spaceman.param.useRandomAttack
  self.attackDirection = AttackAnimDirection.RightToLeft
  
  function self.attack_anim_timer_action()
    self:AttackTimerCallBack()
  end
  
  self:InitAttackTime()
end

function PlayerAniAttack:__delete()
end

function PlayerAniAttack:Ani_Listen_PlayBegin()
  base.Ani_Listen_PlayBegin(self)
  self.m_citySpaceMan:SetWeaponColliderEnable(false)
  if self.m_sickleCollider ~= nil then
    self.m_sickleCollider.enabled = false
  end
end

function PlayerAniAttack:Ani_Listen_AttackBegin()
  self.m_citySpaceMan:SetWeaponColliderEnable(true)
  if self.m_sickleCollider ~= nil then
    self.m_sickleCollider.enabled = true
  end
end

function PlayerAniAttack:Ani_Listen_AttackDone()
  self.m_citySpaceMan:SetWeaponColliderEnable(false)
  if self.m_sickleCollider ~= nil then
    self.m_sickleCollider.enabled = false
  end
end

function PlayerAniAttack:Ani_Listen_ShowTrail()
  self.m_citySpaceMan:PlayTrail(self:GetAttackDirection())
end

function PlayerAniAttack:OnEnter()
  base.OnEnter(self)
  if self.objTransform == nil then
    self.objTransform = self.m_citySpaceMan:GetTransform()
  end
  self:SetActionListen()
  self.m_citySpaceMan:SetWeaponColliderEnable(false)
  if self.m_sickleCollider ~= nil then
    self.m_sickleCollider.enabled = false
  end
  if self.m_citySpaceMan:IsFarmMode() then
    if self.m_objSickle ~= nil then
      self.m_objSickle.gameObject:SetActive(true)
    end
  else
    self.m_citySpaceMan:ShowWeapon(true)
    self:RefreshBuff()
  end
end

function PlayerAniAttack:OnExit()
  self:EndPlayAttackAnim()
  self:DestroyBuffEffect()
  self:ClearActionListen()
  self.m_citySpaceMan:ShowWeapon(false)
  if self.m_objSickle ~= nil then
    self.m_objSickle.gameObject:SetActive(false)
  end
end

function PlayerAniAttack:OnUpdate()
end

function PlayerAniAttack:RefreshBuff()
  local attackSpeed = self.m_citySpaceMan:GetAttackSpeed()
  self.m_citySpaceMan:SetAnimSpeed(attackSpeed)
  local attackBuff = self.m_citySpaceMan.battleLevel:HasBuffByType(PveBuffType.AttackAnim)
  if attackBuff then
    self.attackDirection = AttackAnimDirection.Circle
    self:EndPlayAttackAnim()
    self:LoadBuffEffect()
  else
    if self.attackAnimTimer == nil then
      if self.useRandomAttack then
        self:StartPlayAttackAnim()
      else
        self.attackDirection = AttackAnimDirection.RightToLeft
      end
    end
    self:DestroyBuffEffect()
  end
end

function PlayerAniAttack:LoadBuffEffect()
  if self.buffEffectIns == nil then
    self.buffEffectIns = Resource:InstantiateAsync(UIAssets.XuanFengZhanEffect)
    self.buffEffectIns:completed("+", function(req)
      local transform = req.gameObject.transform
      local parent = self.m_objWeaponBuffEffect
      if parent ~= nil then
        transform:SetParent(parent)
        transform.position = parent.position
      end
      transform.localScale = ResetScale
      req.gameObject:SetActive(true)
    end)
  end
end

function PlayerAniAttack:DestroyBuffEffect()
  if self.buffEffectIns ~= nil then
    self.buffEffectIns:Destroy()
    self.buffEffectIns = nil
  end
end

function PlayerAniAttack:InitAttackTime()
  self.attackAnim = {}
  local clips = self.m_citySpaceMan.m_animator.runtimeAnimatorController.animationClips
  for i = 0, clips.Length - 1 do
    local animName = clips[i].name
    if string.contains(animName, AttackName) then
      local param = {}
      param.time = clips[i].length
      param.animName = animName
      table.insert(self.attackAnim, param)
    end
  end
end

function PlayerAniAttack:StartPlayAttackAnim()
  local index = math.random(1, #self.attackAnim)
  self.animIndex = index
  self.m_citySpaceMan.m_animator:Play(self.attackAnim[index].animName, 0, 0)
  self:AddAttackTimer(self.attackAnim[index].time / self.m_citySpaceMan:GetAttackSpeed())
  if self.attackAnim[self.animIndex] ~= nil and string.contains(self.attackAnim[self.animIndex].animName, "fan") then
    self.attackDirection = AttackAnimDirection.LeftToRight
  else
    self.attackDirection = AttackAnimDirection.RightToLeft
  end
end

function PlayerAniAttack:EndPlayAttackAnim()
  self:DeleteAttackTimer()
end

function PlayerAniAttack:DeleteAttackTimer()
  if self.attackAnimTimer ~= nil then
    self.attackAnimTimer:Stop()
    self.attackAnimTimer = nil
  end
end

function PlayerAniAttack:AddAttackTimer(time)
  self:DeleteAttackTimer()
  if self.attackAnimTimer == nil then
    self.attackAnimTimer = TimerManager:GetInstance():GetTimer(time, self.attack_anim_timer_action, self, true, false, false)
  end
  self.attackAnimTimer:Start()
end

function PlayerAniAttack:AttackTimerCallBack()
  self:DeleteAttackTimer()
  self:StartPlayAttackAnim()
end

function PlayerAniAttack:GetAttackDirection()
  return self.attackDirection
end

return PlayerAniAttack
