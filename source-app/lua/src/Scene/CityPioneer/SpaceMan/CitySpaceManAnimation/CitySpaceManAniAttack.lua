local base = require("Scene.CityPioneer.SpaceMan.CitySpaceManAnimation.CitySpaceManAniBase")
local CitySpaceManAniAttack = BaseClass("CitySpaceManAniAttack", base)
local TypeOfParticleSystem = typeof(CS.UnityEngine.ParticleSystem)
local Resource = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local path_Weapon = "A_soldie_ben/A_soldie@ben_skin/To_unity/DeformationSystem/Root/guadian/weapon"
local _cp_path_sickle = "A_soldie_ben/A_soldie@ben_skin/To_unity/DeformationSystem/Root/guadian/A_soldie_ben_sickle"
local path_daoguang = "VFX_xinshou_daoguang"
local trail_path = "Assets/PackageRes/Solider/ShiHuangXiaoRen/prefab/WeaponEffectTrail.prefab"
local TrailEndTime = 400

function CitySpaceManAniAttack:__init(spaceman)
  base.__init(self, spaceman)
  local objTransform = self.m_citySpaceMan:GetTransform()
  self.m_objWeapon = objTransform:Find(path_Weapon)
  self.m_objSickle = objTransform:Find(_cp_path_sickle)
  if self.m_objSickle ~= nil then
    self.m_sickleCollider = self.m_objSickle:GetComponent(typeof(CS.UnityEngine.CapsuleCollider))
  end
  self.trail = nil
  self.trainAnim = nil
  self.showHead = false
end

function CitySpaceManAniAttack:Ani_Listen_PlayBegin()
  base.Ani_Listen_PlayBegin(self)
  self.m_citySpaceMan:SetWeaponColliderEnable(false)
  self.m_sickleCollider.enabled = false
  self:PlayTrail()
end

function CitySpaceManAniAttack:Ani_Listen_AttackBegin()
  self.m_citySpaceMan:SetWeaponColliderEnable(true)
  self.m_sickleCollider.enabled = true
end

function CitySpaceManAniAttack:Ani_Listen_AttackDone()
  self.m_citySpaceMan:SetWeaponColliderEnable(false)
  self.m_sickleCollider.enabled = false
end

function CitySpaceManAniAttack:PlayTrail()
  if self.trail == nil then
    self.trail = Resource:InstantiateAsync(trail_path)
    self.trail:completed("+", function(req)
      local transform = req.gameObject.transform
      local parent = self.m_citySpaceMan:GetTrailEffectRoot()
      if parent ~= nil then
        transform:SetParent(parent)
        transform:Set_localPosition(0, 0, 0)
      end
      transform.localRotation = Quaternion.Euler(0, 0, 0)
      transform.localScale = ResetScale
      req.gameObject:SetActive(true)
      self.trainAnim = transform:Find("DeformationSystem"):GetComponent(typeof(CS.UnityEngine.Animator))
    end)
  end
  if self.trainAnim then
    self.trainAnim:Play("V_xinshou_daoguangrail", 0, 0)
  end
end

function CitySpaceManAniAttack:OnEnter()
  base.OnEnter(self)
  self:SetActionListen()
  self.m_citySpaceMan:SetWeaponColliderEnable(true)
  self.m_sickleCollider.enabled = false
  if self.m_citySpaceMan:IsFarmMode() then
    self.m_objSickle.gameObject:SetActive(true)
    self:ShowHead()
  else
    self.m_objWeapon.gameObject:SetActive(true)
  end
end

function CitySpaceManAniAttack:OnExit()
  self:ClearActionListen()
  self.m_objWeapon.gameObject:SetActive(false)
  self.m_objSickle.gameObject:SetActive(false)
  if self.trail then
    self.trail:Destroy()
    self.trail = nil
    self.trainAnim = nil
  end
  self:RemoveHead()
end

function CitySpaceManAniAttack:OnUpdate()
end

function CitySpaceManAniAttack:ShowHead()
  local hasShow = Setting:GetPrivateInt(SettingKeys.NEWBIE_FARM_SHOW_HEAD .. Wasteland_PlantState.ToReap, 0) == 1 and true or false
  if not hasShow then
    self.showHead = true
    local headParam = {}
    headParam.dialog = Localization:GetString(GameDialogDefine.START_REAP)
    headParam.modelName = "HeadSpine_ben"
    headParam.modelPosition = 1
    headParam.isRecommend = true
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideHeadTalk) then
      EventManager:GetInstance():Broadcast(EventId.RefreshUIGuideHeadTalk, headParam)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideHeadTalk, {anim = true, playEffect = false}, headParam)
    end
  end
end

function CitySpaceManAniAttack:RemoveHead()
  if self.showHead then
    self.showHead = false
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGuideHeadTalk, {anim = true, playEffect = false})
  end
end

return CitySpaceManAniAttack
