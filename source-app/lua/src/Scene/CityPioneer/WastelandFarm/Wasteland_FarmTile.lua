local Wasteland_FarmTile = BaseClass("Wasteland_FarmTile")
local _type_trigger = typeof(CS.CitySpaceManTrigger)
local typeSimpleAnimation = typeof(CS.SimpleAnimation)
local Const = require("Scene.CityPioneer.Const")
local Resource = CS.GameEntry.Resource
local TypeOfParticleSystem = typeof(CS.UnityEngine.ParticleSystem)
local _cp_objRes_chengshu = "A_plant_cactus_bozhong_mov/state01_chengshuqi"
local _cp_objRes_youmiao = "A_plant_cactus_bozhong_mov/state01_youmiao"
local rawObjPath = "A_build@nt_skin/To_untiy/A_build_nt 1/A_build_nt1"
local _cp_floor_skin = "A_build@nt_skin"
local _cp_chengshu_skin = "A_plant_cactus_bozhong_mov/state01_chengshuqi/Cactus@cactus_skin"
local _cp_youmiao_skin = "A_plant_cactus_bozhong_mov/state01_youmiao/Cactus@A_plant_cactus_youmiao_skin"
local _effect_reap = "VFX_shihuang_shouge"

function Wasteland_FarmTile:__init(farmArea, gameObject, resType)
  self.m_gameObject = gameObject
  self.c_resType = tonumber(resType)
  self.m_farmArea = farmArea
  self.m_curState = Wasteland_PlantState.ToPlant
  self.m_instanceId = self.m_gameObject:GetInstanceID()
  self.trigger = self.m_gameObject:GetComponent(_type_trigger)
  if self.trigger ~= nil then
    self.trigger.ObjectId = self.m_instanceId
  end
  self.m_objyoumiao = self.m_gameObject:Find(_cp_objRes_youmiao)
  self.m_objchengshu = self.m_gameObject:Find(_cp_objRes_chengshu)
  if self.trigger ~= nil then
    function self.trigger.TriggerEnterAction(uuid, resType)
      self:OnChengshuTriggerEnter(uuid, resType)
    end
    
    function self.trigger.TriggerExitAction(uuid)
      self:OnChengshuTriggerExit(uuid)
    end
  end
  local _objFloorSkin = self.m_gameObject:Find(_cp_floor_skin)
  if _objFloorSkin ~= nil then
    self.m_floorAni = _objFloorSkin:GetComponent(typeSimpleAnimation)
  end
  local _objChengshuSkin = self.m_gameObject:Find(_cp_chengshu_skin)
  if _objChengshuSkin ~= nil then
    self.m_chengshuAnim = _objChengshuSkin:GetComponent(typeSimpleAnimation)
  end
  local _objYoumiaoSkin = self.m_gameObject:Find(_cp_youmiao_skin)
  if _objYoumiaoSkin ~= nil then
    self.m_youmiaoAnim = _objYoumiaoSkin:GetComponent(typeSimpleAnimation)
  end
  local _obj_reapEffect = self.m_gameObject:Find(_effect_reap)
  self._obj_reapEffect = _obj_reapEffect
  if _obj_reapEffect ~= nil then
    self.m_effect_reap = _obj_reapEffect:GetComponent(TypeOfParticleSystem)
  end
  _obj_reapEffect.gameObject:SetActive(false)
  self:ShowFloorAnim()
  self:__MakeMaterial()
end

function Wasteland_FarmTile:__delete()
  if self.trigger then
    self.trigger.TriggerEnterAction = nil
    self.trigger.TriggerExitAction = nil
    self.trigger = nil
  end
end

function Wasteland_FarmTile:OnChengshuTriggerEnter(uuid, resType)
  if self.m_curState ~= Wasteland_PlantState.ToReap then
    return
  end
  local man = CitySpaceMan:GetInstance():GetCitySpaceManGameObject()
  local direction = self.m_objchengshu.transform.position - man.transform.position
  local cross = Vector3.Cross(man.transform.forward, direction)
  local pos = Vector3.Dot(man.transform.forward, Vector3.forward)
  if cross.y < 0 then
    direction = Vector3.New(1, 0, 1)
  else
    direction = Vector3.New(1, 0, -1)
  end
  direction = direction * man.transform.rotation
  self.m_objchengshu.transform:DORotate(direction * 5, 0.5)
end

function Wasteland_FarmTile:OnChengshuTriggerExit(uuid)
  if self.m_curState ~= Wasteland_PlantState.ToReap then
    return
  end
  self.m_objchengshu.transform:DORotate(Vector3.New(0, 0, 0), 0.5)
end

function Wasteland_FarmTile:__MakeMaterial()
  self.m_goMaterBlock = CS.UnityEngine.MaterialPropertyBlock()
  self.m_goMaterPropertyId = CS.UnityEngine.Shader.PropertyToID("_threshold")
  local rawObj = self.m_gameObject.transform:Find(rawObjPath)
  if rawObj then
    self.m_renderer = rawObj.transform:GetComponent(typeof(CS.UnityEngine.Renderer))
  end
end

function Wasteland_FarmTile:__doLandWater()
  local function OnProSet(x)
    self.m_goMaterBlock:SetFloat(self.m_goMaterPropertyId, tonumber(x))
    
    self.m_renderer:SetPropertyBlock(self.m_goMaterBlock)
  end
  
  DOTween.To(OnProSet, 0.0, 0.6, 3)
end

function Wasteland_FarmTile:__doLandDry()
  local function OnProGet()
    local v = self.m_goMaterBlock:GetFloat(self.m_goMaterPropertyId)
    
    return v
  end
  
  local function OnProSet(x)
    self.m_goMaterBlock:SetFloat(self.m_goMaterPropertyId, tonumber(x))
    self.m_renderer:SetPropertyBlock(self.m_goMaterBlock)
  end
  
  DOTween.To(OnProGet, OnProSet, 0.0, 3)
end

function Wasteland_FarmTile:GetObjectId()
  return self.m_instanceId
end

function Wasteland_FarmTile:GetTilePlantState()
  return self.m_curState
end

function Wasteland_FarmTile:GetCollectResult()
  if self.m_curState == Wasteland_PlantState.ToReap then
    return true, self.c_resType
  else
    return false, self.c_resType
  end
end

function Wasteland_FarmTile:ShowFloorAnim()
  if self.m_floorAni ~= nil then
    self.m_floorAni:Play("chuxian")
  end
end

function Wasteland_FarmTile:ShowChengshu()
  if self.m_chengshuAnim ~= nil then
    self.m_chengshuAnim:Play("chuxian")
    self.m_chengshuAnim:PlayQueued("idle")
  end
end

function Wasteland_FarmTile:ShowYoumiao()
  if self.m_youmiaoAnim ~= nil then
    self.m_youmiaoAnim:Play("chuxian")
    self.m_youmiaoAnim:PlayQueued("idle")
  end
end

function Wasteland_FarmTile:RecvPlant(force)
  if self.m_curState == Wasteland_PlantState.ToWater then
    return
  end
  DataCenter.LWSoundManager:PlaySound(table.randomArrayValue(EnumPioneerSeed), false)
  self.m_curState = Wasteland_PlantState.ToWater
  self.m_objyoumiao.gameObject:SetActive(true)
  self:ShowYoumiao()
  if force == nil then
    self.m_farmArea:SetAreaPlantState()
  end
end

function Wasteland_FarmTile:RecvWater(force)
  if self.m_curState == Wasteland_PlantState.ToReap then
    return
  end
  self.waterSoundId = DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Pioneer_Water, false)
  self.m_curState = Wasteland_PlantState.ToReap
  self.m_objyoumiao.gameObject:SetActive(false)
  self.m_objchengshu.gameObject:SetActive(true)
  self:ShowChengshu()
  if force == nil then
    self.m_farmArea:SetAreaPlantState()
  end
  self:__doLandWater()
end

function Wasteland_FarmTile:RecvPick()
  if self.m_curState == Wasteland_PlantState.ToPlant then
    return
  end
  self._obj_reapEffect.gameObject:SetActive(true)
  self.m_effect_reap:Play()
  self.m_curState = Wasteland_PlantState.ToPlant
  self.m_objchengshu.gameObject:SetActive(false)
  self.m_farmArea:SetAreaPlantState()
  DataCenter.LWSoundManager:PlaySound(table.randomArrayValue(EnumPioneerCactus), false)
  self:ShowFlyResAnim()
  self:ShowFlyBox()
  self:__doLandDry()
end

function Wasteland_FarmTile:StopWaterSoundEffect()
  if self.waterSoundId ~= nil then
    DataCenter.LWSoundManager:StopSound(self.waterSoundId)
  end
end

function Wasteland_FarmTile:GetFlyNode()
  return self.m_gameObject
end

function Wasteland_FarmTile:ShowFlyResAnim()
  local t = self.c_resType
  local flyTextInst = Resource:InstantiateAsync(UIAssets.CitySpaceManFlyText)
  flyTextInst:completed("+", function(req)
    local flyNode = self:GetFlyNode()
    if flyNode then
      req.gameObject.transform.position = flyNode.transform.position
      local num = req.gameObject.transform:Find("num"):GetComponent(typeof(CS.SuperTextMesh))
      num.text = "+1"
      local spr = req.gameObject.transform:Find("num/icon"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
      local sprImage = Const.ResTypeIconPath[t] or Const.ResTypeIconPath[Const.CityCutResType.Stone]
      spr:LoadSprite(sprImage)
      CS.UnityEngine.GameObject.Destroy(req.gameObject, 0.8)
    end
  end)
end

function Wasteland_FarmTile:ShowFlyBox()
  local restype = self.c_resType
  local resPath = Const.ResTypeFlyPrefabPath[restype]
  if string.IsNullOrEmpty(resPath) then
    return
  end
  local boxInst = Resource:InstantiateAsync(resPath)
  boxInst:completed("+", function(req)
    local _go = req.gameObject
    if _go == nil then
      return
    end
    local obj = CitySpaceMan:GetInstance():GetInstantiateObj()
    if obj == nil then
      return
    end
    local desPosPath = "A_soldie_ben/sold_point"
    local destPos = obj.transform:Find(desPosPath)
    _go.transform.position = self.m_gameObject.transform.position
    local rotController = _go:AddComponent(typeof(CS.ObjectRandRotation))
    _go.transform.localScale = Vector3.New(2.5, 2.5, 2.5)
    rotController.speed = 5
    local flyControl = _go:GetComponent(typeof(CS.UIGoodsFly))
    flyControl:DoAnimBox(1, 1, _go.transform.position, destPos.transform.position, function()
      CS.UnityEngine.GameObject.Destroy(_go)
    end)
  end)
end

return Wasteland_FarmTile
