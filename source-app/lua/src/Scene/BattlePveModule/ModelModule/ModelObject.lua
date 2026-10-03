local ModelObject = BaseClass("ModelObject")
local Buff = require("Scene.BattlePveModule.SkillModule.Buff")
local WeaponObject = require("Scene.BattlePveModule.ModelModule.WeaponObject")
local MonsterHeadUI = require("Scene.TroopHeadUI.MonsterHeadUI")
local Const = require("Scene.BattlePveModule.Const")
local BloodBar = require("Scene.BattlePveModule.UI.BloodBar")
local Resource = CS.GameEntry.Resource
local TextMeshProType = typeof(CS.TMPro.TextMeshPro)
local SimpleAnimationType = typeof(CS.SimpleAnimation)
local TypeOfParticleSystem = typeof(CS.UnityEngine.ParticleSystem)
local Animator = typeof(CS.UnityEngine.Animator)

function ModelObject:__init(modelType, standIndex, heroId, power, heroLv, quality, rarity, targetLv)
  self.m_modelType = modelType
  self.m_heroId = heroId
  self.m_heroPower = power
  self.m_heroLv = heroLv
  self.m_quality = quality
  self.m_rarity = rarity
  self.m_targetLv = targetLv
  self.m_gameObject = nil
  self.m_req = nil
  self.m_standIndex = standIndex
  self.m_buffList = {}
  self.m_objBloodBar = nil
  self.m_bloodUI = nil
  self:InstantiateObj()
  self.m_maxHp = 0
  self.m_curHp = 0
  self.m_detailReportPlayerInfo = nil
  self.m_objWeapon = WeaponObject.New()
  self.m_reqMubei = {}
  self.m_req_addHp = {}
  self.m_req_upgrade = {}
  self.m_req_hit = {}
  self.isCreateFinish = false
  self.showWeak = false
end

function ModelObject:IsPlayer()
  return self.m_modelType == Const.CampType.Player
end

function ModelObject:IsCreateFinish()
  return self.isCreateFinish
end

function ModelObject:IsDead()
  return self.m_curHp <= 0
end

function ModelObject:GetHeroId()
  return self.m_heroId
end

function ModelObject:GetTransform()
  if self.m_gameObject == nil then
    return nil
  end
  return self.m_gameObject.transform
end

function ModelObject:GetGameObject()
  return self.m_gameObject
end

function ModelObject:SetDetailReportPlayerInfo(value)
  for _, v in pairs(value) do
    if v.uuid == self.m_armyCombatUnit:GetMarchId() then
      self.m_detailReportPlayerInfo = v
      return
    end
  end
end

function ModelObject:SetArmyCombatUnit(value)
  self.m_armyCombatUnit = value
end

function ModelObject:GetTriggerIndex()
  if self.m_detailReportPlayerInfo ~= nil then
    return self.m_detailReportPlayerInfo.index
  end
  return 0
end

function ModelObject:SetBloodVisible(visible)
  if self.m_bloodUI ~= nil then
    self.m_bloodUI:SetActive(visible)
  end
end

function ModelObject:SetCurHp(value)
  if self.m_bloodUI ~= nil then
    self.m_bloodUI:SetHp(value, self.m_maxHp)
  end
end

function ModelObject:SetHpFactor(maxHpPercent)
  if self.m_bloodUI ~= nil then
    self.m_bloodUI:SetHpFactor(maxHpPercent)
  end
end

function ModelObject:BattleInit()
  if self.m_bloodUI ~= nil then
    self.m_bloodUI:StopUpdate()
    self.m_bloodUI:ShowHpObject()
  end
  self:SetCurHp(self.m_curHp)
  self:SetBloodVisible(true)
end

function ModelObject:AddBuff(buffItem)
  local _buff = Buff.New()
  _buff:SetData(buffItem)
  self.m_buffList[#self.m_buffList + 1] = _buff
end

function ModelObject:DoActionBuff()
  for k, v in pairs(self.m_buffList) do
    TimerManager:GetInstance():DelayInvoke(function()
      v:DoAction()
    end, 0.3 * k * PveActorMgr:GetInstance():GetSpeed())
  end
end

function ModelObject:GetModelResPath()
  local model = GetTableData(HeroUtils.GetHeroXmlName(), self.m_heroId, "prefab_low")
  local str_side = ""
  return "Assets/Main/Prefabs/PVE/DyHeroes/" .. model .. str_side .. ".prefab"
end

function ModelObject:GetModelResName()
  local model = GetTableData(HeroUtils.GetHeroXmlName(), self.m_heroId, "prefab_low")
  return model
end

function ModelObject:GetStandWorldPos()
  return PveActorMgr:GetInstance():GetStandPosByIndex(self.m_modelType, self.m_standIndex) or Vector3.New(0, 0, 0)
end

function ModelObject:GetTargetStandWorldPos()
  local targetType = self.m_modelType == Const.CampType.Player and Const.CampType.Target or Const.CampType.Player
  return PveActorMgr:GetInstance():GetStandPosByIndex(targetType, self.m_standIndex) or Vector3.New(0, 0, 0)
end

function ModelObject:InstantiateObj()
  local _prefabPath = self:GetModelResPath()
  self.m_req = Resource:InstantiateAsync(_prefabPath)
  self.m_req:completed("+", function(req)
    local _go = req.gameObject
    if _go == nil then
      return
    end
    self.m_gameObject = _go
    self:UpdatePos(self.m_standIndex)
    self:InitComponent()
    self.isCreateFinish = true
    PveActorMgr:GetInstance():CheckPlayRound()
  end)
end

function ModelObject:UpdatePos(index)
  if self.m_gameObject ~= nil then
    self.m_standIndex = index
    local parent = PveActorMgr:GetInstance():GetStandObj(self.m_modelType, self.m_standIndex)
    if parent ~= nil then
      self.m_gameObject.transform:SetParent(parent)
    end
    self.m_gameObject.transform.localPosition = ResetPosition
    self.m_gameObject.transform.localRotation = Quaternion.Euler(0, 180, 0)
    self.m_gameObject.transform:Set_localScale(1, 1, 1)
    local _obj = self.m_gameObject.transform:Find("A_Hero_low")
    if _obj ~= nil then
      _obj.gameObject.transform:Set_localScale(1, 1, 1)
    end
  end
end

function ModelObject:InitComponent()
  self:CreateBloodBar()
  self.m_animator = self:GetTransform():GetComponentInChildren(Animator)
  if self.m_animator == nil then
    Logger.LogError("\232\175\165\232\139\177\233\155\132\230\178\161\230\156\137\229\138\168\231\148\187\231\174\161\231\144\134\229\153\168")
  end
  self.m_objWeapon:AddWeapon(self, Const.WeaponType.Gun)
  self:PlayIdle()
end

function ModelObject:PlayIdle()
  self:PlayAnimation(Const.AniName.Idle)
  self.m_objWeapon:StopAttack()
end

function ModelObject:PlayAttack()
  if self.m_curHp <= 0 then
    self:PlayDead()
  else
    self.m_objWeapon:ToAttack()
    self:PlayAnimation(Const.AniName.Attack)
    if self.m_modelType ~= Const.CampType.Player then
    end
  end
end

function ModelObject:PlayStopFire()
  if self.m_curHp <= 0 then
    self:PlayDead()
  else
    self:PlayIdle()
  end
end

function ModelObject:PlayAnimation(aniname)
  if self.m_animator ~= nil then
    self.m_animator:SetTrigger(aniname)
    self.m_animator.speed = 1.0 * PveActorMgr:GetInstance():GetSpeedOffset()
  end
end

function ModelObject:Destroy()
  if self.m_animator ~= nil then
    self.m_animator.speed = 1.0
  end
  if self.m_bloodUI ~= nil then
    self.m_bloodUI:Destroy()
    self.m_bloodUI = nil
  end
  if self.m_objWeapon ~= nil then
    self.m_objWeapon:Destroy()
  end
  for _, v in pairs(self.m_reqMubei) do
    v:Destroy()
  end
  if self.m_reqBlood ~= nil then
    self.m_reqBlood:Destroy()
    self.m_reqBlood = nil
  end
  for _, v in pairs(self.m_req_upgrade) do
    v:Destroy()
  end
  for _, v in pairs(self.m_req_addHp) do
    v:Destroy()
  end
  if self.m_req_hit ~= nil then
    for _, v in pairs(self.m_req_hit) do
      v:Destroy()
    end
  end
  if self.m_req ~= nil then
    self.m_req:Destroy()
  end
end

function ModelObject:BeginAttack()
  self:PlayAttack()
end

local util = require("Common.Tools.cjson.util")

function ModelObject:RecvHit(value, flytext)
  flytext = flytext == nil and true or false
  local triggerIdx = self:GetTriggerIndex()
  local oldValue = self.m_curHp
  self.m_curHp = self.m_curHp + value
  self.m_curHp = Mathf.Clamp(self.m_curHp, 0, self.m_maxHp)
  self:SetCurHp(self.m_curHp)
  if self.m_modelType == Const.CampType.Player then
    PveActorMgr:GetInstance():AddAtkTotalHp(self.m_curHp - oldValue)
  else
    PveActorMgr:GetInstance():AddDefTotalHp(self.m_curHp - oldValue)
  end
  if self.m_curHp <= 0 then
    if PveActorMgr:GetInstance():IsFinalRound() == true and self.showWeak == false then
      if PveActorMgr:GetInstance():GetBattleResult() == Const.Result.Win then
        if self.m_modelType == Const.CampType.Target then
          self:ShowMuBei()
          self.showWeak = true
          return
        end
      elseif self.m_modelType == Const.CampType.Player then
        self:ShowMuBei()
        self.showWeak = true
        return
      end
    end
    self:PlayDead()
    if not PveActorMgr:GetInstance():IsStopPlay() and self.showWeak == false and PveActorMgr:GetInstance():IsFinalRound() == false then
      local _str = CS.GameEntry.Localization:GetString("400076")
      self:FlyText(_str)
      self.showWeak = true
    end
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_pve_hero_weak, false)
  elseif oldValue <= 0 and self.m_curHp > 0 then
    self.showWeak = false
    self.m_gameObject:SetActive(true)
    if self.m_objWeapon ~= nil then
      self.m_objWeapon:SetActive(true)
    end
    self:PlayAnimation(Const.AniName.Idle)
    self.m_objWeapon:StopAttack()
    self:SetBloodVisible(true)
    if self.m_objMubei ~= nil then
      self.m_objMubei:SetActive(false)
    end
  end
  if not PveActorMgr:GetInstance():IsStopPlay() and flytext then
    local _strtext = ""
    if value < 0 then
      _strtext = "<color=#FF0000>" .. tostring(value) .. "</color>"
    elseif 0 < value then
      _strtext = "<color=#008B00>" .. tostring(value) .. "</color>"
    end
    if self.m_curHp > 0 then
      self:FlyText(_strtext)
    end
  end
end

function ModelObject:PlayDead()
  self:SetBloodVisible(false)
  self:PlayAnimation(Const.AniName.Weaken)
  if self.m_objWeapon ~= nil then
    self.m_objWeapon:SetActive(false)
  end
end

function ModelObject:GetFlyNode()
  return self.m_gameObject
end

function ModelObject:FlyText(value)
  local pathText = "Assets/Main/Prefabs/CityScene/FlyText_UI.prefab"
  local flyTextInst = Resource:InstantiateAsync(pathText)
  flyTextInst:completed("+", function(req)
    TimerManager:GetInstance():DelayInvoke(function()
      if flyTextInst ~= nil then
        flyTextInst:Destroy()
      end
    end, 2 * PveActorMgr:GetInstance():GetSpeed())
    local _go = req.gameObject
    if _go == nil then
      return
    end
    local flyNode = self:GetFlyNode()
    if flyNode then
      local CanvasNormal = UIManager:GetInstance():GetLayer(UILayer.Background.Name).gameObject
      _go.transform:SetParent(CanvasNormal.transform)
      local _modelPos = self:GetTransform().position + Vector3.New(0, 1.5, 0)
      local mainCamera = CS.UnityEngine.Camera.main
      local _screenPos = mainCamera:WorldToScreenPoint(_modelPos)
      _go.transform.position = Vector3.New(_screenPos.x, _screenPos.y, 0)
      _go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local num = _go.transform:Find("objRoot/num"):GetComponent(typeof(CS.UnityEngine.UI.Text))
      num.text = value
    end
  end)
end

function ModelObject:PlayEffectUpgrade()
  local _effect_path = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_pve_upgrade.prefab"
  self.m_req_upgrade[#self.m_req_upgrade + 1] = Resource:InstantiateAsync(_effect_path)
  self.m_req_upgrade[#self.m_req_upgrade]:completed("+", function(req)
    local req_trans = req.gameObject.transform
    req.gameObject.transform:SetParent(self:GetTransform())
    req_trans.localPosition = Vector3.New(0, 0.62, 0)
  end)
end

function ModelObject:PlayEffectDeBuff()
  local _effect_path = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_pve_debuff.prefab"
  self.m_req_upgrade[#self.m_req_upgrade + 1] = Resource:InstantiateAsync(_effect_path)
  self.m_req_upgrade[#self.m_req_upgrade]:completed("+", function(req)
    local req_trans = req.gameObject.transform
    req.gameObject.transform:SetParent(self:GetTransform())
    req_trans.localPosition = Vector3.New(0, 0.62, 0)
  end)
end

function ModelObject:DelayHideShield(time)
  if self.m_effect_shield == nil then
    return
  end
  if self.m_delayShield ~= nil then
    self.m_delayShield:Stop()
    self.m_delayShield = nil
  end
  self.m_delayShield = TimerManager:GetInstance():DelayInvoke(function()
    self.m_effect_shield:Stop()
  end, time * PveActorMgr:GetInstance():GetSpeed())
end

function ModelObject:ShowShield(time)
  if self.m_effect_shield ~= nil then
    self.m_effect_shield:Simulate(0)
    self.m_effect_shield:Play()
    self:DelayHideShield(time)
    return
  end
  local e_path = "Assets/_Art/Effect/prefab/PVE/VFX_pve_hudun.prefab"
  self.m_req_hit[#self.m_req_hit + 1] = Resource:InstantiateAsync(e_path)
  self.m_req_hit[#self.m_req_hit]:completed("+", function(req)
    local _go = req.gameObject
    if _go == nil then
      return
    end
    local req_trans = req.gameObject.transform
    self.m_effect_shield = req_trans:GetComponent(TypeOfParticleSystem)
    req.gameObject.transform:SetParent(self:GetTransform())
    req_trans.localPosition = Vector3.New(0, 0, 0)
    self:DelayHideShield(time)
  end)
end

function ModelObject:DelayHideHitEffect()
  if self.m_effect_hit == nil then
    return
  end
  if self.m_delayHit ~= nil then
    self.m_delayHit:Stop()
    self.m_delayHit = nil
  end
  self.m_delayHit = TimerManager:GetInstance():DelayInvoke(function()
    self.m_effect_hit:Stop()
  end, 1)
end

function ModelObject:ShowHitEffect()
  if self.m_effect_hit ~= nil then
    self.m_effect_hit:Simulate(0)
    self.m_effect_hit:Play()
    self:DelayHideHitEffect()
    return
  end
  local e_path = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_pve_q_jiaohu_guai_ui.prefab"
  self.m_req_hit[#self.m_req_hit + 1] = Resource:InstantiateAsync(e_path)
  self.m_req_hit[#self.m_req_hit]:completed("+", function(req)
    local _go = req.gameObject
    if _go == nil then
      return
    end
    self.m_effect_hit = _go.transform:GetComponent(TypeOfParticleSystem)
    local CanvasNormal = UIManager:GetInstance():GetLayer(UILayer.Normal.Name).gameObject
    _go.transform:SetParent(CanvasNormal.transform)
    local _modelPos = self:GetTransform().position + Vector3.New(0, 0.38, 0)
    local mainCamera = CS.UnityEngine.Camera.main
    local _screenPos = mainCamera:WorldToScreenPoint(_modelPos)
    _go.transform.position = Vector3.New(_screenPos.x, _screenPos.y, 0)
    _go.transform:Set_localScale(ResetScale.x * 1.2, ResetScale.y * 1.2, ResetScale.z * 1.2)
    self:DelayHideHitEffect()
  end)
end

function ModelObject:PlayEffectAddHp()
  if self.m_particle_addHp ~= nil then
    self.m_particle_addHp:Simulate(0)
    self.m_particle_addHp:Play()
    return
  end
  local _effect_path = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_pve_zhiliao.prefab"
  self.m_req_addHp[#self.m_req_addHp + 1] = Resource:InstantiateAsync(_effect_path)
  self.m_req_addHp[#self.m_req_addHp]:completed("+", function(req)
    local req_trans = req.gameObject.transform
    req.gameObject.transform:SetParent(self:GetTransform())
    req_trans.localPosition = Vector3.New(0, 0.09, 0)
    self.m_particle_addHp = req_trans:GetComponent(TypeOfParticleSystem)
  end)
end

function ModelObject:CreateBloodBar()
  if self.m_reqBlood ~= nil then
    return
  end
  local path_prefab = "Assets/Main/Prefabs/PVE/UI/Pve_UI_HeroBlood.prefab"
  self.m_reqBlood = Resource:InstantiateAsync(path_prefab)
  self.m_reqBlood:completed("+", function(req)
    local _go = req.gameObject
    if _go == nil then
      return
    end
    self.m_bloodUI = BloodBar.New(self, _go)
    _go.transform:Set_localScale(ResetScale.x * 0.8, ResetScale.y * 0.8, ResetScale.z * 0.8)
    self:InitBloodCom()
    self:SetPlayerShowLevelOrPower()
  end)
end

function ModelObject:SetPlayerShowLevelOrPower()
  if self.m_bloodUI ~= nil then
    self.m_bloodUI:SetPlayerShowLevelOrPower()
  end
end

function ModelObject:SetHeroLv(heroLv)
  self.m_heroLv = heroLv
  if self.m_bloodUI ~= nil then
    self.m_bloodUI:SetHeroLv(self.m_heroLv, self.m_targetLv)
  end
end

function ModelObject:InitBloodCom()
  if self.m_bloodUI ~= nil then
    self.m_bloodUI:SetHeroLv(self.m_heroLv, self.m_targetLv)
    self.m_bloodUI:SetHeroStar(self.m_quality, self.m_rarity)
    self.m_bloodUI:SetPower(self.m_heroPower)
  end
end

function ModelObject:GetHeroPower()
  return self.m_heroPower or 0
end

function ModelObject:SetBarForGuide(showArrow)
  if self.m_bloodUI ~= nil then
    self.m_bloodUI:SetBarForGuide(self.m_heroPower, showArrow)
  end
end

function ModelObject:HideBarForGuide()
  if self.m_bloodUI ~= nil then
    self.m_bloodUI:HideBarForGuide()
  end
end

function ModelObject:SetHeroPower(value)
  self.m_heroPower = value
  if self.m_bloodUI ~= nil then
    self.m_bloodUI:SetPower(self.m_heroPower)
  end
end

function ModelObject:SetHeroHp(maxHp)
  self.m_curHp = maxHp
  self.m_maxHp = maxHp
end

function ModelObject:GetCurHp()
  return self.m_curHp
end

function ModelObject:GetMaxHp()
  return self.m_maxHp
end

function ModelObject:ShowMuBei()
  if self.m_gameObject ~= nil then
    self.m_gameObject:SetActive(false)
  end
  self:SetBloodVisible(false)
  if self.m_objWeapon ~= nil then
    self.m_objWeapon:SetActive(false)
  end
  if self.m_objMubei ~= nil then
    self.m_objMubei:SetActive(true)
    return
  end
  local _prefabPath = "Assets/Main/Prefabs/PVE/Obj_A_build_th_mb.prefab"
  self.m_reqMubei[#self.m_reqMubei + 1] = Resource:InstantiateAsync(_prefabPath)
  self.m_reqMubei[#self.m_reqMubei]:completed("+", function(req)
    local _go = req.gameObject
    if _go == nil then
      return
    end
    _go.transform.position = self:GetTransform().position
    _go.transform.rotation = ResetEulerAngles
    self.m_objMubei = _go
  end)
end

return ModelObject
