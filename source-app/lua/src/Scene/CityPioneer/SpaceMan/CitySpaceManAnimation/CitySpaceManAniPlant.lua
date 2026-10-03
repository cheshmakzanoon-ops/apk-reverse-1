local base = require("Scene.CityPioneer.SpaceMan.CitySpaceManAnimation.CitySpaceManAniBase")
local CitySpaceManAniPlant = BaseClass("CitySpaceManAniPlant", base)
local TypeOfParticleSystem = typeof(CS.UnityEngine.ParticleSystem)
local Resource = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local _cp_objPlant = "A_soldie_ben/A_soldie@ben_skin/To_unity/DeformationSystem/Root/guadian/A_soldie_ben_barrel"
local _cp_objCollider = "A_soldie_ben/A_soldie@ben_skin/To_unity/DeformationSystem/Root/Root_M/Spine1_M/Chest_M/Scapula_R/Shoulder_R/Elbow_R/objCollider"
local _cp_effect_bozhong = "tmp_obj_bozhong_effect"
local Collider_Oritation = Quaternion.Euler(105, 409, 140)

function CitySpaceManAniPlant:__init(spaceman)
  base.__init(self, spaceman)
  local objTransform = self.m_citySpaceMan:GetTransform()
  self.m_objPlant = objTransform:Find(_cp_objPlant)
  self.m_objPlant.gameObject:SetActive(false)
  local objCollider = objTransform:Find(_cp_objCollider)
  self.m_objCollider = objCollider
  if objCollider ~= nil then
    self.m_objBoxCollider = objCollider:GetComponent(typeof(CS.UnityEngine.CapsuleCollider))
  end
  self.m_obj_effect = objTransform:Find(_cp_effect_bozhong)
  if self.m_obj_effect ~= nil then
    self.m_effect_bozhong = self.m_obj_effect:GetComponent(TypeOfParticleSystem)
  end
  self.showHead = false
  self.effectInstance = {}
end

function CitySpaceManAniPlant:ShowEffect()
  local resPath = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_shihuang_bozhong.prefab"
  local boxInst = Resource:InstantiateAsync(resPath)
  table.insert(self.effectInstance, boxInst)
  boxInst:completed("+", function(req)
    local _go = req.gameObject
    if _go == nil then
      return
    end
    _go.transform.position = self.m_obj_effect.transform.position
    _go.transform.rotation = self.m_obj_effect.transform.rotation
    _go.name = "VFX_shihuang_bozhong"
    local particle = _go.transform:GetComponent(TypeOfParticleSystem)
    particle:Simulate(0)
    particle:Play()
  end)
end

function CitySpaceManAniPlant:OnTriggerEnter_Weapon(uuid, resType)
  base.OnTriggerEnter_Weapon(self, uuid, resType)
  local farmTile = WastelandFarmManager:GetInstance():GetTileByObjId(uuid)
  if farmTile ~= nil then
    farmTile:RecvPlant()
  end
end

function CitySpaceManAniPlant:OnEnter()
  base.OnEnter(self)
  self:SetActionListen()
  self:SetTriggerListen()
  self.m_objPlant.gameObject:SetActive(true)
  self.m_objCollider.gameObject:SetActive(true)
  self.m_objCollider.transform.localRotation = Collider_Oritation
  self:ShowHead()
end

function CitySpaceManAniPlant:Ani_Listen_PlayBegin()
  base.Ani_Listen_PlayBegin(self)
  self.m_objBoxCollider.enabled = false
end

function CitySpaceManAniPlant:Ani_Listen_AttackBegin()
  self.m_objBoxCollider.enabled = true
  self:ShowEffect()
end

function CitySpaceManAniPlant:Ani_Listen_AttackDone()
  self.m_objBoxCollider.enabled = false
end

function CitySpaceManAniPlant:OnExit()
  self:ClearActionListen()
  self:ClearTriggerListen()
  self.m_objPlant.gameObject:SetActive(false)
  self.m_objCollider.gameObject:SetActive(false)
  self.m_obj_effect.gameObject:SetActive(false)
  self:RemoveHead()
  self:ClearInstance()
  base.OnExit(self)
end

function CitySpaceManAniPlant:OnUpdate()
end

function CitySpaceManAniPlant:ShowHead()
  local hasShow = Setting:GetPrivateInt(SettingKeys.NEWBIE_FARM_SHOW_HEAD .. Wasteland_PlantState.ToPlant, 0) == 1 and true or false
  if not hasShow then
    self.showHead = true
    local headParam = {}
    headParam.dialog = Localization:GetString(GameDialogDefine.START_PLANT)
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

function CitySpaceManAniPlant:RemoveHead()
  if self.showHead then
    self.showHead = false
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGuideHeadTalk, {anim = true, playEffect = false})
  end
end

function CitySpaceManAniPlant:ClearInstance()
  if self.effectInstance ~= nil then
    for k, v in ipairs(self.effectInstance) do
      v:Destroy()
    end
    self.effectInstance = {}
  end
end

return CitySpaceManAniPlant
