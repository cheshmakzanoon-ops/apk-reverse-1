local hero_dynamic_download_path = "Assets/Download/HeroModel/High/%s.prefab"
local hero_build_in_path = "Assets/PackageRes/Prefabs/HeroModel/High/%s.prefab"
local GameQualitySettings = require("Util.GameQualitySettings")
local PreviewEffectParams = require("UI.UILWHero.UIHeroDetailPanel.Component.HeroWeaponModelViewerConst")
local WeaponSceneVfx = require("UI.UILWHero.UIHeroDetailPanel.Component.WeaponSceneVfx")
local RTUtils = require("Util.RTUtils")
local LightPath = "City/Scene_City2(Clone)/Light_City"
local HeroWeaponModelViewer = BaseClass("HeroWeaponModelViewer", UIBaseContainer)
local base = UIBaseContainer
local SystemInfo = CS.UnityEngine.SystemInfo
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local ResourceManager = CS.GameEntry.Resource
local PlayableDirector = CS.UnityEngine.Playables.PlayableDirector
local Camera = CS.UnityEngine.Camera
local Screen = CS.UnityEngine.Screen
local Animator = CS.UnityEngine.Animator
local HeroRenderLayer = "timeline"
local HeroRender2Layer = "timeline"
local shadowDistance, defaultQuality
local WIRE_SHADER_PATH = "Assets/Main/Shaders2019/LastWar/CharactorV1_Wire.shader"
local DISPLAY_SCENE_PATH = "Assets/Main/Prefabs/UI/UIHero/New/HeroPreview/DisplaySceneUniqueWeapon.prefab"
local DEFAULT_CAMERA_ROTATION = Vector3(48.701, -52.205, -2.154)

local function OnCreate(self, enableTouch, onDragCallBack)
  base.OnCreate(self)
  self:ComponentDefine(enableTouch)
  self.defaultScenePos = Vector3.New(-800, 800, -800)
  self.cameraOffsetFlag = 1
  self.cameraOffset = Vector3.zero
  self.rtWidth = DefaultScreenHeight
  self.rtHeight = DefaultScreenHeight
  self.sceneLoaded = nil
  self.sceneCamera = nil
  self.heroModel = nil
  self.sceneLoading = nil
  self.heroLoadedCallback = nil
  self.curRotationX = 0
  self.onDragCallBack = onDragCallBack
  self.rawImage:SetEnable(false)
  self.isInAutoRotate = false
  self.pauseAutoRotate = false
  DataCenter.CityLightManager:AddDeactiveRef()
  self.weaponLvUpHangPoint = nil
  self.lightAni = nil
  self.platAni = nil
  self.upgradeCor = nil
  self.InShowUpgradeAni = false
end

local function SetRTSize(self, width, height)
  self.rtWidth = width
  self.rtHeight = height
  if not IsNull(self.rawImage) then
    self.rawImage:SetAnchorMinXY(0.5, 0.5)
    self.rawImage:SetAnchorMaxXY(0.5, 0.5)
    self.rawImage.rectTransform:Set_sizeDelta(width, height)
  end
end

local function OnDestroy(self)
  self:ReleaseTexture()
  self:RemoveHero()
  self:RemoveHeroPreview()
  if self.enhanceEffects then
    for _, effect in pairs(self.enhanceEffects) do
      effect:Delete()
    end
    self.enhanceEffects = nil
  end
  if self.sceneLoading ~= nil then
    self.sceneLoading:Destroy()
  end
  if self.sceneLoaded ~= nil then
    self.sceneLoaded:Destroy()
  end
  if self.effectShaderReq then
    self.effectShaderReq:Release()
    self.effectShaderReq = nil
  end
  if self.upgradeCor then
    self.upgradeCor = nil
  end
  self.sceneLoaded = nil
  self.sceneLoading = nil
  self.curRotationX = nil
  self.sceneCamera = nil
  self.onDragCallBack = nil
  self.platformRotateObj = nil
  self.heroSlot = nil
  self.lightAni = nil
  self.platAni = nil
  self.isPlayPlatAni = nil
  self.prevHeroModelPath4PlatAni = nil
  self.curHeroModelPath4PlatAni = nil
  self.aniFinishCallback = nil
  self.aniStartCallback = nil
  self.heroMatInfo = nil
  DataCenter.CityLightManager:DecreaseDeactiveRef()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  if self.sceneLoaded ~= nil then
    self.sceneLoaded.gameObject:SetActive(true)
  end
  if not IsNull(self.heroModel) then
    local model = self.heroModel
    if not IsNull(model) then
      local animator = model:GetComponentInChildren(typeof(CS.UnityEngine.Animator), true)
      if not IsNull(animator) then
        animator:SetTrigger("idle")
      end
    end
  end
  if not IsNull(self.prevHeroModel) then
    local model = self.prevHeroModel
    if not IsNull(model) then
      local animator = model:GetComponentInChildren(typeof(CS.UnityEngine.Animator), true)
      if not IsNull(animator) then
        animator:SetTrigger("idle")
      end
    end
  end
  if not IsNull(self.afterHeroModel) then
    local model = self.afterHeroModel
    if not IsNull(model) then
      local animator = model:GetComponentInChildren(typeof(CS.UnityEngine.Animator), true)
      if not IsNull(animator) then
        animator:SetTrigger("idle")
      end
    end
  end
  if self.heroModelMaterials then
    self:SetHeroModelBaseColor(1)
  end
  self:SetPlatformAni("Idle")
end

local function SetQuality(self, enable)
  if enable then
    shadowDistance = RenderSetting.GetShadowDistance()
    RenderSetting.SetShadowDistance(30)
  else
    RenderSetting.SetShadowDistance(shadowDistance)
  end
end

local function OnDisable(self)
  if self.sceneLoaded ~= nil then
    self.sceneLoaded.gameObject:SetActive(false)
  end
  self.isPlayPlatAni = nil
  self.prevHeroModelPath4PlatAni = nil
  self.curHeroModelPath4PlatAni = nil
  self.aniFinishCallback = nil
  if self.platRotateTween ~= nil then
    self.platRotateTween:Kill()
    self.platRotateTween = nil
  end
  if self.BaseColorLerpTween ~= nil then
    self.BaseColorLerpTween:Kill()
    self.BaseColorLerpTween = nil
  end
  if self.cameraRotateTween ~= nil then
    self.cameraRotateTween:Kill()
    self.cameraRotateTween = nil
  end
  self.heroMatInfo = nil
  if self.heroModelMaterials then
    self:SetHeroModelBaseColor(1)
  end
  base.OnDisable(self)
end

local function ComponentDefine(self, enableTouch)
  self.rawImage = self:AddComponent(UIRawImage, "PrevModel")
  self:SetEnableTouch(enableTouch)
end

local function ComponentDestroy(self)
  self.event_trigger = nil
  self.camera = nil
end

local function ShowEmptyScene(self)
  self:SetModelPath(nil)
end

local function StartMaterialAnimation(self)
  if not self.changeModelAnimation then
    self.changeModelAnimation = DOTween.Sequence()
    self.changeModelAnimation:InsertCallback(0, function()
      if self.prevHeroModel and not IsNull(self.prevHeroModel.gameObject) then
        self.prevHeroModel.gameObject:SetActive(true)
      end
      if self.afterHeroModel and not IsNull(self.afterHeroModel.gameObject) then
        self.afterHeroModel.gameObject:SetActive(true)
      end
      self:_setMaterials(self.prevMaterials, PreviewEffectParams.INIT_A_ALPHA, PreviewEffectParams.INIT_A_WIRE, PreviewEffectParams.INIT_A_COLOR, PreviewEffectParams.Init_A_REVERT)
      self:_setMaterials(self.afterMaterials, PreviewEffectParams.INIT_B_ALPHA, PreviewEffectParams.INIT_B_WIRE, PreviewEffectParams.INIT_B_COLOR, PreviewEffectParams.Init_B_REVERT)
    end)
    self.changeModelAnimation:InsertCallback(0, function()
      if self.prevHeroModel and not IsNull(self.prevHeroModel.gameObject) then
        self:_setParticlesVisible(self.prevParticles, true)
      end
      if self.afterHeroModel and not IsNull(self.afterHeroModel.gameObject) then
        self:_setParticlesVisible(self.afterParticles, false)
      end
    end)
    local a_alpha_Time = 0
    local a_wire_Time = 0
    local b_alpha_Time = 0
    local b_wire_Time = 0
    local a_color_Time = 0
    local b_color_Time = 0
    local a_alpha_Value = PreviewEffectParams.INIT_A_ALPHA
    local a_wire_Value = PreviewEffectParams.INIT_A_WIRE
    local a_wire_Color = PreviewEffectParams.INIT_A_COLOR
    local b_alpha_Value = PreviewEffectParams.INIT_B_ALPHA
    local b_wire_Value = PreviewEffectParams.INIT_B_WIRE
    local b_wire_Color = PreviewEffectParams.INIT_B_COLOR
    a_alpha_Time, a_alpha_Value = self:_insertTween(a_alpha_Time, self.prevMaterials, "_ChangeAlpha", a_alpha_Value, PreviewEffectParams.ROUND1_A_ALPHA_DELAY_TIME, PreviewEffectParams.ROUND1_A_ALPHA_TARGET, PreviewEffectParams.ROUND1_A_ALPHA_DURATION)
    self.changeModelAnimation:InsertCallback(0.15, function()
      if self.prevHeroModel and not IsNull(self.prevHeroModel.gameObject) then
        self:_setParticlesVisible(self.prevParticles, false)
      end
      if self.afterHeroModel and not IsNull(self.afterHeroModel.gameObject) then
        self:_setParticlesVisible(self.afterParticles, true)
      end
    end)
    a_wire_Time, a_wire_Value = self:_insertTween(a_wire_Time, self.prevMaterials, "_ChangeWire", a_wire_Value, PreviewEffectParams.ROUND1_A_WIRE_DELAY_TIME, PreviewEffectParams.ROUND1_A_WIRE_TARGET, PreviewEffectParams.ROUND1_A_WIRE_DURATION)
    a_color_Time, a_wire_Color = self:_insertTween(a_color_Time, self.prevMaterials, "_Widthcol", a_wire_Color, PreviewEffectParams.ROUND1_A_COLOR_DELAY_TIME, PreviewEffectParams.ROUND1_A_COLOR_TARGET, PreviewEffectParams.ROUND1_A_COLOR_DURATION)
    b_alpha_Time, b_alpha_Value = self:_insertTween(b_alpha_Time, self.afterMaterials, "_ChangeAlpha", b_alpha_Value, PreviewEffectParams.ROUND1_B_ALPHA_DELAY_TIME, PreviewEffectParams.ROUND1_B_ALPHA_TARGET, PreviewEffectParams.ROUND1_B_ALPHA_DURATION)
    b_wire_Time, b_wire_Value = self:_insertTween(b_wire_Time, self.afterMaterials, "_ChangeWire", b_wire_Value, PreviewEffectParams.ROUND1_B_WIRE_DELAY_TIME, PreviewEffectParams.ROUND1_B_WIRE_TARGET, PreviewEffectParams.ROUND1_B_WIRE_DURATION)
    b_color_Time, b_wire_Color = self:_insertTween(b_color_Time, self.afterMaterials, "_Widthcol", b_wire_Color, PreviewEffectParams.ROUND1_B_COLOR_DELAY_TIME, PreviewEffectParams.ROUND1_B_COLOR_TARGET, PreviewEffectParams.ROUND1_B_COLOR_DURATION)
    a_alpha_Time, a_alpha_Value = self:_insertTween(a_alpha_Time, self.prevMaterials, "_ChangeAlpha", a_alpha_Value, PreviewEffectParams.ROUND2_A_ALPHA_DELAY_TIME, PreviewEffectParams.ROUND2_A_ALPHA_TARGET, PreviewEffectParams.ROUND2_A_ALPHA_DURATION)
    a_wire_Time, a_wire_Value = self:_insertTween(a_wire_Time, self.prevMaterials, "_ChangeWire", a_wire_Value, PreviewEffectParams.ROUND2_A_WIRE_DELAY_TIME, PreviewEffectParams.ROUND2_A_WIRE_TARGET, PreviewEffectParams.ROUND2_A_WIRE_DURATION)
    a_color_Time, a_wire_Color = self:_insertTween(a_color_Time, self.prevMaterials, "_Widthcol", a_wire_Color, PreviewEffectParams.ROUND2_A_COLOR_DELAY_TIME, PreviewEffectParams.ROUND2_A_COLOR_TARGET, PreviewEffectParams.ROUND2_A_COLOR_DURATION)
    b_alpha_Time, b_alpha_Value = self:_insertTween(b_alpha_Time, self.afterMaterials, "_ChangeAlpha", b_alpha_Value, PreviewEffectParams.ROUND2_B_ALPHA_DELAY_TIME, PreviewEffectParams.ROUND2_B_ALPHA_TARGET, PreviewEffectParams.ROUND2_B_ALPHA_DURATION)
    self.changeModelAnimation:InsertCallback(b_alpha_Time - PreviewEffectParams.ROUND2_B_ALPHA_DURATION / 2, function()
      if self.prevHeroModel and not IsNull(self.prevHeroModel.gameObject) then
        self:_setParticlesVisible(self.prevParticles, true)
      end
      if self.afterHeroModel and not IsNull(self.afterHeroModel.gameObject) then
        self:_setParticlesVisible(self.afterParticles, false)
      end
    end)
    b_wire_Time, b_wire_Value = self:_insertTween(b_wire_Time, self.afterMaterials, "_ChangeWire", b_wire_Value, PreviewEffectParams.ROUND2_B_WIRE_DELAY_TIME, PreviewEffectParams.ROUND2_B_WIRE_TARGET, PreviewEffectParams.ROUND2_B_WIRE_DURATION)
    b_color_Time, b_wire_Color = self:_insertTween(b_color_Time, self.afterMaterials, "_Widthcol", b_wire_Color, PreviewEffectParams.ROUND2_B_COLOR_DELAY_TIME, PreviewEffectParams.ROUND2_B_COLOR_TARGET, PreviewEffectParams.ROUND2_B_COLOR_DURATION)
    local revert_A_Value = PreviewEffectParams.Init_A_REVERT
    local revert_B_Value = PreviewEffectParams.Init_B_REVERT
    if revert_A_Value ~= PreviewEffectParams.REVERT_A_1_TARGET then
      self.changeModelAnimation:InsertCallback(PreviewEffectParams.REVERT_A_1_TIME, function()
        self:_setMaterials(self.prevMaterials, nil, nil, nil, revert_A_Value)
      end)
      revert_A_Value = PreviewEffectParams.REVERT_A_1_TARGET
    end
    if revert_B_Value ~= PreviewEffectParams.REVERT_B_1_TARGET then
      self.changeModelAnimation:InsertCallback(PreviewEffectParams.REVERT_B_1_TIME, function()
        self:_setMaterials(self.afterMaterials, nil, nil, nil, revert_B_Value)
      end)
      revert_B_Value = PreviewEffectParams.REVERT_B_1_TARGET
    end
    self.changeModelAnimation:SetLoops(-1)
  end
end

function HeroWeaponModelViewer:_setMaterials(materials, alpha, wire, wireColor, revertUV)
  if materials then
    for i = 1, #materials do
      if alpha then
        materials[i]:SetFloat("_ChangeAlpha", alpha)
      end
      if wire then
        materials[i]:SetFloat("_ChangeWire", wire)
      end
      if wireColor then
        materials[i]:SetColor("_Widthcol", wireColor)
      end
      if revertUV then
        materials[i]:SetFloat("_Trunuv3x", revertUV)
      end
    end
  end
end

function HeroWeaponModelViewer:_setParticlesVisible(particles, visible)
  if particles == nil then
    return
  end
  for i = 0, particles.Length - 1 do
    particles[i].gameObject:SetActive(visible)
    if visible then
      particles[i]:Play()
    end
  end
end

function HeroWeaponModelViewer:_insertTween(time, materials, property, currentValue, delayTime, target, duration)
  time = time + delayTime
  if currentValue ~= target then
    if property == "_Widthcol" then
      for i = 1, #materials do
        local material = materials[i]
        self.changeModelAnimation:Insert(time, material:DOColor(target, property, duration))
      end
    else
      for i = 1, #materials do
        local material = materials[i]
        self.changeModelAnimation:Insert(time, material:DOFloat(target, property, duration))
      end
    end
  end
  return time + duration, target
end

function HeroWeaponModelViewer:InsertCallback(time, callback)
  self.changeModelAnimation:InsertCallback(time, callback)
end

local function StopMaterialAnimation(self)
  if self.changeModelAnimation then
    self.changeModelAnimation:Kill()
    self.changeModelAnimation = nil
  end
end

function HeroWeaponModelViewer:GetModelParticles(heroModel)
  if IsNull(heroModel) then
    return
  end
  local particles = heroModel:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem), true)
  return particles
end

local function ReplaceModelMaterial(self, heroModel)
  if not self.effectShader then
    return
  end
  if IsNull(heroModel) then
    return
  end
  local skinnedMeshRenderer = heroModel:GetComponentsInChildren(typeof(CS.UnityEngine.SkinnedMeshRenderer), true)
  local meshRenderer = heroModel:GetComponentsInChildren(typeof(CS.UnityEngine.MeshRenderer), true)
  local materials = {}
  local renderers = {}
  local count = 1
  if skinnedMeshRenderer then
    for i = 0, skinnedMeshRenderer.Length - 1 do
      local material = skinnedMeshRenderer[i].sharedMaterial
      local newMat = CS.UnityEngine.Material(material)
      newMat.shader = self.effectShader
      newMat:SetFloat("_Width", 0.03)
      newMat:SetFloat("_Change", 0.6)
      newMat:SetFloat("_Change1", 0.35)
      newMat:SetInt("_SrcBlend", 5)
      newMat:SetInt("_DstBlend", 10)
      skinnedMeshRenderer[i].sharedMaterial = newMat
      materials[count] = newMat
      renderers[count] = skinnedMeshRenderer[i]
      count = count + 1
    end
  end
  if meshRenderer then
    for i = 0, meshRenderer.Length - 1 do
      local material = meshRenderer[i].sharedMaterial
      local newMat = CS.UnityEngine.Material(material)
      newMat.shader = self.effectShader
      newMat:SetFloat("_Width", 0.02)
      newMat:SetFloat("_Change", 0.431)
      newMat:SetFloat("_Change1", 0.4)
      newMat:SetInt("_SrcBlend", 5)
      newMat:SetInt("_DstBlend", 10)
      meshRenderer[i].sharedMaterial = newMat
      materials[count] = newMat
      renderers[count] = meshRenderer[i]
      count = count + 1
    end
  end
  return materials, renderers
end

local function TryLoadShader(self)
  if not self.effectShaderReq then
    self.effectShaderReq = ResourceManager:LoadAssetAsync(WIRE_SHADER_PATH, typeof(CS.UnityEngine.Shader))
    if self.effectShaderReq then
      function self.effectShaderReq.completed(_)
        local shader = self.effectShaderReq.asset
        
        if IsNull(shader) then
          Logger.LogError("Load shader failed")
          return
        end
        cast(shader, typeof(CS.UnityEngine.Shader))
        self.effectShader = shader
        if self.prevHeroModel then
          self.prevMaterials, self.prevRenderers = ReplaceModelMaterial(self, self.prevHeroModel)
          self.prevParticles = self:GetModelParticles(self.prevHeroModel)
        end
        if self.afterHeroModel then
          self.afterMaterials, self.afterRenderers = ReplaceModelMaterial(self, self.afterHeroModel)
          self.afterParticles = self:GetModelParticles(self.afterHeroModel)
        end
        self:StartPlayPreviewEffect()
      end
    end
  end
end

local function DoWhenSceneLoaded(self, result)
  if not result then
    return
  end
  if self.isPlayPlatAni ~= nil and self.isPlayPlatAni then
    self:StartShowPlatUpgradeAni()
  else
    self:StartShowNormalHero()
  end
end

local function StartShowNormalHero(self)
  if not string.IsNullOrEmpty(self.heroModelPath) then
    self:ReloadHero(self.heroModelPath, function()
      if self.heroLoadedCallback then
        self.heroLoadedCallback()
      end
    end)
    return
  end
  if not string.IsNullOrEmpty(self.prevHeroModelPath) and not string.IsNullOrEmpty(self.afterHeroModelPath) then
    self:ReloadPreivewHeroes(self.prevHeroModelPath, self.afterHeroModelPath, function()
      if self.heroLoadedCallback then
        self.heroLoadedCallback()
      end
    end)
  end
  self:SetPlatformAni("Idle")
end

local function ModifyModelAngleBeforePlayPlatAni(self, rotateTime)
  if IsNull(self.platformRotateObj) then
    return
  end
  local curPlatformRotateAngle = self.platformRotateObj.transform.localRotation.eulerAngles.y
  if math.abs(curPlatformRotateAngle) < 0.1 then
    return
  end
  if self.platRotateTween ~= nil then
    self.platRotateTween:Kill()
  end
  local targetAngle = -curPlatformRotateAngle
  self.platRotateTween = self.platformRotateObj.transform:DOLocalRotate(Vector3(0, targetAngle, 0), rotateTime, CS.DG.Tweening.RotateMode.LocalAxisAdd)
end

local function PlatformRotateShowOneRound(self, rotateTime)
  if self.platformRotateObj then
    if self.platRotateTween ~= nil then
      self.platRotateTween:Kill()
    end
    self.platRotateTween = self.platformRotateObj.transform:DORotate(Vector3(0, 360, 0), rotateTime, CS.DG.Tweening.RotateMode.LocalAxisAdd)
  end
end

local function ReplaceHeroModelMaterials(self)
  if self.heroModel == nil or self.heroModelMaterials ~= nil then
    return
  end
  local skinnedMeshRenderer = self.heroModel:GetComponentsInChildren(typeof(CS.UnityEngine.SkinnedMeshRenderer), true)
  local meshRenderer = self.heroModel:GetComponentsInChildren(typeof(CS.UnityEngine.MeshRenderer), true)
  local materials = {}
  local renderers = {}
  local count = 1
  if skinnedMeshRenderer then
    for i = 0, skinnedMeshRenderer.Length - 1 do
      local material = skinnedMeshRenderer[i].sharedMaterial
      local newMat = CS.UnityEngine.Material(material)
      skinnedMeshRenderer[i].sharedMaterial = newMat
      materials[count] = newMat
      renderers[count] = skinnedMeshRenderer[i]
      count = count + 1
    end
  end
  if meshRenderer then
    for i = 0, meshRenderer.Length - 1 do
      local material = meshRenderer[i].sharedMaterial
      local newMat = CS.UnityEngine.Material(material)
      meshRenderer[i].sharedMaterial = newMat
      materials[count] = newMat
      renderers[count] = meshRenderer[i]
      count = count + 1
    end
  end
  self.heroModelMaterials = materials
  self.heroModelRenderers = renderers
end

local function CacheHeroModelMatColorInfoBeforeChangeColor(self)
  self.heroMatInfo = {}
  if self.heroModelMaterials == nil then
    return
  end
  for k, v in pairs(self.heroModelMaterials) do
    if v ~= nil then
      local matInstanceId = v:GetInstanceID()
      self.heroMatInfo[matInstanceId] = v.color
    end
  end
end

local function HeroModelBaseColorLerpChange(self, from, to, duration)
  local baseColorChangeVal = from
  
  local function Getter()
    return from
  end
  
  local function Setter(x)
    baseColorChangeVal = x
  end
  
  if self.BaseColorLerpTween ~= nil then
    self.BaseColorLerpTween:Kill()
  end
  self.BaseColorLerpTween = DOTween.To(Getter, Setter, to, duration)
  
  function self.BaseColorLerpTween.onUpdate(x)
    self:SetHeroModelBaseColor(baseColorChangeVal)
  end
end

local function SetHeroModelBaseColor(self, baseColorVal)
  if self.heroModelMaterials == nil then
    return
  end
  for k, v in pairs(self.heroModelMaterials) do
    if v ~= nil then
      local targetR, targetG, targetB, targetA, finalColorToSet, oriColor
      if self.heroMatInfo ~= nil then
        local curMatinstanceID = v:GetInstanceID()
        if self.heroMatInfo[curMatinstanceID] then
          oriColor = self.heroMatInfo[curMatinstanceID]
        end
      end
      if oriColor then
        targetR = oriColor.r * baseColorVal
        targetG = oriColor.g * baseColorVal
        targetB = oriColor.b * baseColorVal
        targetA = oriColor.a
        finalColorToSet = Color.New(targetR, targetG, targetB, targetA)
      else
        targetR = baseColorVal
        targetG = baseColorVal
        targetB = baseColorVal
        local currentMaterialColor = v.color
        if currentMaterialColor then
          targetA = currentMaterialColor.a
        else
          targetA = 1.0
        end
        finalColorToSet = Color.New(targetR, targetG, targetB, targetA)
      end
      v:SetColor("_BaseColor", finalColorToSet)
    end
  end
end

local function StartShowPlatUpgradeAni(self)
  if not (self.isPlayPlatAni and self.prevHeroModelPath4PlatAni) or not self.curHeroModelPath4PlatAni then
    self:StartShowNormalHero()
    return
  end
  local curModelAngle = self:GetCurGenModelAngle()
  if self.prevHeroModelPath and self.afterHeroModelPath then
    self:RemoveHeroPreview()
  end
  local defaultLayer = 1
  local zPrePassLayer = 256
  local combineMask = defaultLayer | zPrePassLayer
  
  local function modifyGenModelAngleAndLayer()
    if not IsNull(self.heroModel) then
      self.heroModel.transform.localRotation = Quaternion.Euler(0, curModelAngle, 0)
    end
    self:ReplaceHeroModelMaterials()
    if self.heroModelRenderers ~= nil then
      for k, v in pairs(self.heroModelRenderers) do
        v.renderingLayerMask = combineMask
      end
    end
  end
  
  if self.heroModelPath and self.heroModelPath ~= self.prevHeroModelPath4PlatAni then
    self:RemoveHero()
  end
  self:ReloadHero(self.prevHeroModelPath4PlatAni, modifyGenModelAngleAndLayer)
  self:SetPlatformAni("Start")
  if self.aniStartCallback then
    self.aniStartCallback()
  end
  self.InShowUpgradeAni = true
  local baseColorFromVal = 1
  local baseColorToVal = 0.6
  self.upgradeCor = coroutine.start(function()
    coroutine.waitforseconds(0.8)
    self:ModifyModelAngleBeforePlayPlatAni(1.3)
    coroutine.waitforseconds(0.67)
    self:CacheHeroModelMatColorInfoBeforeChangeColor()
    self:HeroModelBaseColorLerpChange(baseColorFromVal, baseColorToVal, 1.3)
    coroutine.waitforseconds(4)
    if self.BaseColorLerpTween ~= nil then
      self.BaseColorLerpTween:Kill()
    end
    self:RemoveHero()
    self:ReloadHero(self.curHeroModelPath4PlatAni, function()
      modifyGenModelAngleAndLayer()
      self:CacheHeroModelMatColorInfoBeforeChangeColor()
      self:SetHeroModelBaseColor(baseColorToVal)
    end)
    coroutine.waitforseconds(1)
    self:HeroModelBaseColorLerpChange(baseColorToVal, baseColorFromVal, 1.3)
    self:PlatformRotateShowOneRound(7)
    coroutine.waitforseconds(7.5)
    self.heroMatInfo = nil
    if self.heroModelRenderers ~= nil then
      for k, v in pairs(self.heroModelRenderers) do
        v.renderingLayerMask = defaultLayer
      end
    end
    self:SetPlatformAni("Idle")
    if self.aniFinishCallback then
      self.aniFinishCallback()
    end
    self.InShowUpgradeAni = false
  end)
end

local function GetCurGenModelAngle(self)
  if not IsNull(self.heroModel) then
    return self.heroModel.transform.localRotation.eulerAngles.y
  end
  if not IsNull(self.prevHeroModel) then
    return self.prevHeroModel.transform.localRotation.eulerAngles.y
  end
  if not IsNull(self.afterHeroModel) then
    return self.afterHeroModel.transform.localRotation.eulerAngles.y
  end
  return 0
end

local function SetPlatformAni(self, aniName)
  if not (self.lightAni and self.platAni) or not aniName then
    return
  end
  self.lightAni:SetTrigger(aniName)
  self.platAni:SetTrigger(aniName)
end

function HeroWeaponModelViewer:SetModelPath(heroModelPath)
  if self.prevHeroModelPath and self.afterHeroModelPath then
    self:RemoveHeroPreview()
  end
  if self.heroModelPath == heroModelPath then
    if self.heroLoadedCallback then
      self.heroLoadedCallback()
    end
    return
  end
  self:RemoveHero()
  self.heroModelPath = heroModelPath
  self:ReloadScene()
end

local function ResetPlatformRotateAngle(self)
  if not IsNull(self.platformRotateObj) then
    self.platformRotateObj.transform.localRotation = Quaternion.identity
  end
end

local function ShowModelPreivew(self, prevHeroModelPath, afterHeroModelPath)
  if self.prevHeroModelPath == prevHeroModelPath and self.afterHeroModelPath == afterHeroModelPath then
    ResetPlatformRotateAngle(self)
    return
  end
  if self.heroModelPath then
    self:RemoveHero()
  end
  TryLoadShader(self)
  self:RemoveHeroPreview()
  self.prevHeroModelPath = prevHeroModelPath
  self.afterHeroModelPath = afterHeroModelPath
  self:ReloadScene()
end

local function ReloadScene(self)
  if self.sceneLoaded ~= nil then
    local camera = self.sceneCamera
    self:OnRenderTexture(camera)
    self.sceneLoaded.gameObject:SetActive(true)
    DoWhenSceneLoaded(self, true)
    return
  end
  if self.sceneLoading ~= nil then
    return
  end
  local scenePath = DISPLAY_SCENE_PATH
  Logger.Log("#RecruitScene# HeroModelViewer  heroScenePreviewPath", scenePath)
  local request = ResourceManager:InstantiateAsync(scenePath)
  self.sceneLoading = request
  request:completed("+", function()
    if request.isError then
      self.sceneLoading = nil
      DoWhenSceneLoaded(self, false)
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    request.gameObject.transform:Set_position(self.defaultScenePos.x, self.defaultScenePos.y, self.defaultScenePos.z)
    local camera = request.gameObject.transform:Find("Camera"):GetComponentInChildren(typeof(Camera))
    self.sceneLoading = nil
    self.sceneLoaded = request
    self.sceneCamera = camera
    self.platformRotateObj = request.gameObject.transform:Find("A_Build_zhuanwuzhanshi_01/A_Build_zhuanwuzhanshi_01/To_unity/DeformationSystem/Root/Root_M/GuaDian_PingTai/joint2")
    self.heroSlot = request.gameObject.transform:Find("A_Build_zhuanwuzhanshi_01/A_Build_zhuanwuzhanshi_01/To_unity/DeformationSystem/Root/Root_M/GuaDian_PingTai/joint2/GuaDian_ZhuanWu/HeroSlot")
    self.lightAni = request.gameObject.transform:GetComponentInChildren(typeof(Animator))
    self.platAni = request.gameObject.transform:Find("A_Build_zhuanwuzhanshi_01/A_Build_zhuanwuzhanshi_01"):GetComponentInChildren(typeof(Animator))
    self:ToggleSceneCamera(true)
    DoWhenSceneLoaded(self, true)
  end)
end

local function ResetHeroTransform(self, heroModel, initShowState)
  if IsNull(heroModel) then
    return
  end
  local spawnPoint = self.heroSlot
  if IsNull(spawnPoint) then
    local currentScene = self.sceneLoaded
    if not IsNull(currentScene) then
      spawnPoint = currentScene.gameObject.transform
    end
    if IsNull(spawnPoint) then
      return
    end
  end
  heroModel:SetActive(initShowState)
  local go_rt = heroModel.transform
  go_rt:SetParent(spawnPoint)
  go_rt:Set_localPosition(0, 0, 0)
  go_rt:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
  go_rt.localRotation = Quaternion.identity
  local animator = go_rt:GetComponentInChildren(typeof(CS.UnityEngine.Animator), true)
  if animator then
    animator:SetTrigger("idle")
  end
  return go_rt
end

local function ReloadHero(self, heroModelPath, callback)
  if string.IsNullOrEmpty(heroModelPath) then
    if callback ~= nil then
      callback(false)
    end
    return
  end
  local request = ResourceManager:InstantiateAsync(heroModelPath)
  self.heroRequest = request
  request:completed("+", function()
    if request.isError then
      Logger.LogError("#RecruitScene# ModelViewer ReloadHero Error! heroModelPath:" .. heroModelPath .. ", Error:" .. request.error)
      if callback ~= nil then
        callback(false)
      end
      return
    end
    local go_rt = ResetHeroTransform(self, request.gameObject, true)
    self.heroModel = go_rt
    if callback ~= nil then
      callback(true)
    end
  end)
end

local function StartPlayPreviewEffect(self)
  if IsNull(self.prevHeroModel) or IsNull(self.afterHeroModel) then
    return
  end
  if not self.prevMaterials then
    return
  end
  if not self.afterMaterials then
    return
  end
  self.isInAutoRotate = true
  StartMaterialAnimation(self, false)
end

local function ReloadPreivewHeroes(self, prevModelPath, afterModelPath, callback)
  if string.IsNullOrEmpty(prevModelPath) or string.IsNullOrEmpty(afterModelPath) then
    if callback ~= nil then
      callback(false)
    end
    return
  end
  local request = ResourceManager:InstantiateAsync(prevModelPath)
  self.prevHeroRequest = request
  self.prevHeroRequest:completed("+", function(_request)
    if IsNull(_request.gameObject) then
      Logger.LogError("#RecruitScene# ModelViewer ReloadHero Error! prevModelPath:" .. prevModelPath .. ", Error:" .. _request.error)
      if callback ~= nil then
        callback(false)
      end
      return
    end
    local go_rt = ResetHeroTransform(self, _request.gameObject, false)
    self.prevHeroModel = go_rt
    self.prevMaterials, self.prevRenderers = ReplaceModelMaterial(self, go_rt)
    self.prevParticles = self:GetModelParticles(go_rt)
    go_rt.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer(HeroRenderLayer))
    if self.afterHeroModel then
      callback(true)
    end
    StartPlayPreviewEffect(self)
  end)
  request = ResourceManager:InstantiateAsync(afterModelPath)
  self.afterHeroRequest = request
  self.afterHeroRequest:completed("+", function(_request)
    if IsNull(_request.gameObject) then
      Logger.LogError("#RecruitScene# ModelViewer ReloadHero Error! afterModelPath:" .. afterModelPath .. ", Error:" .. _request.error)
      if callback ~= nil then
        callback(false)
      end
      return
    end
    local go_rt = ResetHeroTransform(self, _request.gameObject, false)
    self.afterHeroModel = go_rt
    self.afterMaterials, self.afterRenderers = ReplaceModelMaterial(self, go_rt)
    self.afterParticles = self:GetModelParticles(go_rt)
    go_rt.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer(HeroRender2Layer))
    if self.prevHeroModel then
      callback(true)
    end
    StartPlayPreviewEffect(self)
  end)
end

local function RemoveHero(self)
  if self.heroRequest ~= nil then
    self.heroRequest:Destroy()
    self.heroRequest = nil
  end
  local defaultLayer = 1
  if self.heroModelRenderers ~= nil then
    for k, v in pairs(self.heroModelRenderers) do
      v.renderingLayerMask = defaultLayer
    end
  end
  self.heroModelPath = nil
  self.heroModel = nil
  self.heroModelMaterials = nil
  self.heroModelRenderers = nil
end

local function RemoveHeroPreview(self)
  StopMaterialAnimation(self)
  if self.prevHeroRequest then
    self.prevHeroRequest:RealDestroy()
    self.prevHeroRequest = nil
  end
  if self.afterHeroRequest then
    self.afterHeroRequest:RealDestroy()
    self.afterHeroRequest = nil
  end
  self.prevHeroModelPath = nil
  self.afterHeroModelPath = nil
  self.prevRenderers = nil
  self.afterRenderers = nil
  self.prevMaterials = nil
  self.afterMaterials = nil
  self.prevHeroModel = nil
  self.afterHeroModel = nil
  self.prevParticles = nil
  self.afterParticles = nil
end

local function OnRenderTexture(self, camera)
  if camera == nil then
    Logger.LogError("#zlh# OnRenderTexture camera is nil!")
    return
  end
  if self.renderTexture == nil then
    local rtWidth = self.rtWidth
    local rtHeight = self.rtHeight
    self.renderTexture = RTUtils.GetTemporaryWithFallback(rtWidth, rtHeight, 24)
    if IsNull(self.renderTexture) then
      Logger.LogError(string.format("#HeroPreview# GetTemporaryWithFallback failed! size=%sx%s", tostring(rtWidth), tostring(rtHeight)))
      return
    end
    self.renderTexture.name = "HeroSimpleShow"
    self.rawImage:SetTexture(self.renderTexture)
    self.rawImage:SetEnable(true)
    self.rawImage:SetColor(Color.New(1, 1, 1, 1))
  end
  camera.targetTexture = self.renderTexture
end

local function ReleaseTexture(self)
  self.rawImage:SetTexture(nil)
  if not IsNull(self.sceneCamera) then
    self.sceneCamera.targetTexture = nil
  end
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
end

local function Rotate(self, offset)
  local platform = self.platformRotateObj
  if not IsNull(platform) then
    local y = platform.rotation.eulerAngles.y + offset
    platform.rotation = Quaternion.Euler(0, y, 0)
  end
end

local function OnBeginDrag(self, eventData)
  if self.isInAutoRotate or self.InShowUpgradeAni then
    return
  end
  self.lastDragPosX = eventData.position.x
  if self.beginDragListener ~= nil then
    self.beginDragListener()
  end
end

local function OnDrag(self, eventData)
  if self.isInAutoRotate or self.InShowUpgradeAni then
    return
  end
  local currentPosX = eventData.position.x
  if currentPosX > Screen.width then
    return
  end
  if self.lastDragPosX then
    local offset = self.lastDragPosX - currentPosX
    self.lastDragPosX = currentPosX
    self:Rotate(offset)
  end
end

local function OnEndDrag(self, eventData)
  if self.isInAutoRotate or self.InShowUpgradeAni then
    return
  end
  if self.endDragListener ~= nil then
    self.endDragListener()
  end
end

local function OnPointerDown(self, eventData)
  self.pauseAutoRotate = true
end

local function OnPointerUp(self, eventData)
  self.pauseAutoRotate = false
end

local function OnPointerExit(self, eventData)
  self.pauseAutoRotate = false
end

local function ToggleSceneCamera(self, b)
  local sceneCamera = self.sceneCamera
  if not IsNull(sceneCamera) then
    sceneCamera.gameObject:SetActive(b)
    if b then
      self:OnRenderTexture(sceneCamera)
    else
      sceneCamera.targetTexture = nil
    end
  end
end

local function SetHeroLoadedCallback(self, callback)
  self.heroLoadedCallback = callback
end

local function SetBeginDragListener(self, listener)
  self.beginDragListener = listener
end

local function SetEndDragListener(self, listener)
  self.endDragListener = listener
end

local function SetDefaultScenePos(self, defaultPos)
  self.defaultScenePos = defaultPos
end

local function EnableWorldCamera(self)
  pcall(function()
    if CS.SceneManager.World then
      CS.SceneManager.World:EnablePostProcess()
    end
  end)
end

local function DisableWorldCamera(self)
  pcall(function()
    if CS.SceneManager.World then
      CS.SceneManager.World:DisablePostProcess()
    end
  end)
end

local function ToggleSceneVisible(self, t)
  if self.sceneLoaded then
    self.sceneLoaded.gameObject:SetActive(t)
  end
end

local function Update(self)
  if self.isInAutoRotate then
    if self.pauseAutoRotate then
      return
    end
    if IsNull(self.prevHeroModel) or IsNull(self.afterHeroModel) then
      self.isInAutoRotate = false
      return
    end
    local offset = Time.deltaTime * 24
    self:Rotate(offset)
    return
  end
end

local function SetPlatformUpgradeData(self, prevModelPath, curModelPath, aniStartCallback, aniFinishCallback)
  self.isPlayPlatAni = true
  self.prevHeroModelPath4PlatAni = prevModelPath
  self.curHeroModelPath4PlatAni = curModelPath
  self.aniFinishCallback = aniFinishCallback
  self.aniStartCallback = aniStartCallback
  self:ReloadScene()
end

local function PlayNormalUpgradeEff(self)
  if self.lightAni ~= nil then
    self.lightAni:SetTrigger("Upgrade")
  end
end

local function SetEnableTouch(self, enableTouch)
  if enableTouch then
    self.event_trigger = self:AddComponent(UIEventTrigger, "")
    self.event_trigger:OnBeginDrag(function(eventData)
      self:OnBeginDrag(eventData)
    end)
    self.event_trigger:OnDrag(function(eventData)
      self:OnDrag(eventData)
    end)
    self.event_trigger:OnEndDrag(function(eventData)
      self:OnEndDrag(eventData)
    end)
    self.event_trigger:OnPointerDown(function(eventData)
      self:OnPointerDown(eventData)
    end)
    self.event_trigger:OnPointerUp(function(eventData)
      self:OnPointerUp(eventData)
    end)
    self.event_trigger:OnPointerExit(function(eventData)
      self:OnPointerUp(eventData)
    end)
  end
end

function HeroWeaponModelViewer:ResetCameraRotation(animTime)
  self:RotateCamera(DEFAULT_CAMERA_ROTATION, animTime)
end

function HeroWeaponModelViewer:RotateCamera(targetRotation, animTime)
  if IsNull(self.sceneCamera) or targetRotation == nil then
    return
  end
  if self.cameraRotateTween ~= nil then
    self.cameraRotateTween:Kill()
    self.cameraRotateTween = nil
  end
  if animTime == nil or animTime <= 0 then
    self.sceneCamera.transform:Set_localEulerAngles(targetRotation:Split())
  else
    self.cameraRotateTween = self.sceneCamera.transform:DOLocalRotate(targetRotation, animTime):SetEase(CS.DG.Tweening.Ease.Linear)
  end
end

local WEAPON_UNIT_ENHANCE_EFFECT_PATH = "Assets/_Art_LastWar/Effect/Prefab/2025/Eff_enhance_content/Eff_enhance_content_Up0%d.prefab"

function HeroWeaponModelViewer:PrewarmEnhanceEffects(ids)
  if not self.sceneLoaded or IsNull(self.sceneLoaded) then
    return
  end
  if not self.enhanceEffects then
    self.enhanceEffects = {}
  end
  for _, id in ipairs(ids) do
    if not self.enhanceEffects[id] then
      local effectPath = string.format(WEAPON_UNIT_ENHANCE_EFFECT_PATH, id)
      local vfx = WeaponSceneVfx.New()
      vfx:PreLoad(effectPath, {
        parent = self.sceneLoaded.gameObject.transform
      })
      self.enhanceEffects[id] = vfx
    end
  end
end

function HeroWeaponModelViewer:PlayEnhanceEffects(unitType)
  if not self.enhanceEffects then
    self.enhanceEffects = {}
  end
  for type, effect in pairs(self.enhanceEffects) do
    if type ~= unitType then
      effect:SetActive(false)
    end
  end
  if not self.enhanceEffects[unitType] then
    if not self.sceneLoaded or IsNull(self.sceneLoaded) then
      return
    end
    self.enhanceEffects[unitType] = WeaponSceneVfx.New()
    self.enhanceEffects[unitType]:Play(string.format(WEAPON_UNIT_ENHANCE_EFFECT_PATH, unitType), {
      parent = self.sceneLoaded.gameObject.transform
    })
  else
    self.enhanceEffects[unitType]:SetActive(true)
    self.enhanceEffects[unitType]:RealPlay()
  end
end

function HeroWeaponModelViewer:StopEnhanceEffect()
  for _, effect in pairs(self.enhanceEffects) do
    effect:Stop()
  end
end

HeroWeaponModelViewer.OnCreate = OnCreate
HeroWeaponModelViewer.OnDestroy = OnDestroy
HeroWeaponModelViewer.OnEnable = OnEnable
HeroWeaponModelViewer.OnDisable = OnDisable
HeroWeaponModelViewer.ComponentDefine = ComponentDefine
HeroWeaponModelViewer.ComponentDestroy = ComponentDestroy
HeroWeaponModelViewer.ShowEmptyScene = ShowEmptyScene
HeroWeaponModelViewer.ReloadScene = ReloadScene
HeroWeaponModelViewer.ReloadHero = ReloadHero
HeroWeaponModelViewer.RemoveHero = RemoveHero
HeroWeaponModelViewer.Rotate = Rotate
HeroWeaponModelViewer.OnRenderTexture = OnRenderTexture
HeroWeaponModelViewer.ReleaseTexture = ReleaseTexture
HeroWeaponModelViewer.OnBeginDrag = OnBeginDrag
HeroWeaponModelViewer.OnDrag = OnDrag
HeroWeaponModelViewer.OnEndDrag = OnEndDrag
HeroWeaponModelViewer.ToggleSceneCamera = ToggleSceneCamera
HeroWeaponModelViewer.SetHeroLoadedCallback = SetHeroLoadedCallback
HeroWeaponModelViewer.SetBeginDragListener = SetBeginDragListener
HeroWeaponModelViewer.SetEndDragListener = SetEndDragListener
HeroWeaponModelViewer.SetDefaultScenePos = SetDefaultScenePos
HeroWeaponModelViewer.SetQuality = SetQuality
HeroWeaponModelViewer.EnableWorldCamera = EnableWorldCamera
HeroWeaponModelViewer.DisableWorldCamera = DisableWorldCamera
HeroWeaponModelViewer.ToggleSceneVisible = ToggleSceneVisible
HeroWeaponModelViewer.SetRTSize = SetRTSize
HeroWeaponModelViewer.ShowModelPreivew = ShowModelPreivew
HeroWeaponModelViewer.ReloadPreivewHeroes = ReloadPreivewHeroes
HeroWeaponModelViewer.RemoveHeroPreview = RemoveHeroPreview
HeroWeaponModelViewer.StartPlayPreviewEffect = StartPlayPreviewEffect
HeroWeaponModelViewer.OnPointerDown = OnPointerDown
HeroWeaponModelViewer.OnPointerUp = OnPointerUp
HeroWeaponModelViewer.OnPointerExit = OnPointerExit
HeroWeaponModelViewer.Update = Update
HeroWeaponModelViewer.SetPlatformUpgradeData = SetPlatformUpgradeData
HeroWeaponModelViewer.StartShowNormalHero = StartShowNormalHero
HeroWeaponModelViewer.StartShowPlatUpgradeAni = StartShowPlatUpgradeAni
HeroWeaponModelViewer.SetPlatformAni = SetPlatformAni
HeroWeaponModelViewer.ModifyModelAngleBeforePlayPlatAni = ModifyModelAngleBeforePlayPlatAni
HeroWeaponModelViewer.GetCurGenModelAngle = GetCurGenModelAngle
HeroWeaponModelViewer.PlatformRotateShowOneRound = PlatformRotateShowOneRound
HeroWeaponModelViewer.ReplaceHeroModelMaterials = ReplaceHeroModelMaterials
HeroWeaponModelViewer.HeroModelBaseColorLerpChange = HeroModelBaseColorLerpChange
HeroWeaponModelViewer.SetHeroModelBaseColor = SetHeroModelBaseColor
HeroWeaponModelViewer.PlayNormalUpgradeEff = PlayNormalUpgradeEff
HeroWeaponModelViewer.CacheHeroModelMatColorInfoBeforeChangeColor = CacheHeroModelMatColorInfoBeforeChangeColor
HeroWeaponModelViewer.SetEnableTouch = SetEnableTouch
return HeroWeaponModelViewer
