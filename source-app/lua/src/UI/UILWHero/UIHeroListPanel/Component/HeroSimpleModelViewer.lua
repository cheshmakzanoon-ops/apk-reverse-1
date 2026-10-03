local hero_dynamic_download_path = "Assets/Download/HeroModel/High/%s.prefab"
local hero_build_in_path = "Assets/PackageRes/Prefabs/HeroModel/High/%s.prefab"
local default_build_in_model_name = "feixingyuan"
local GameQualitySettings = require("Util.GameQualitySettings")
local LightPath = "City/Scene_City2(Clone)/Light_City"
local HeroSimpleModelViewer = BaseClass("HeroSimpleModelViewer", UIBaseContainer)
local base = UIBaseContainer
local SystemInfo = CS.UnityEngine.SystemInfo
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local ResourceManager = CS.GameEntry.Resource
local PlayableDirector = CS.UnityEngine.Playables.PlayableDirector
local Camera = CS.UnityEngine.Camera
local Screen = CS.UnityEngine.Screen
local RTUtils = require("Util.RTUtils")
local HeroRenderLayer = "PlaneShadowObject"
local GrabRenderLayer = "Grab"
local AdvanceEffectName = "HeroAdvanceEffect"
local shadowDistance, defaultQuality
HeroSimpleModelViewer.openedRef = 0

local function OnCreate(self, enableTouch, onDragCallBack)
  base.OnCreate(self)
  self:ComponentDefine(enableTouch)
  self.defaultScenePos = Vector3.New(-5000, 0, -5000)
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
  self.rotateState = 0
  self.rawImage:SetEnable(false)
  HeroSimpleModelViewer.openedRef = HeroSimpleModelViewer.openedRef + 1
  self.refTag = HeroSimpleModelViewer.openedRef
  DataCenter.CityLightManager:AddDeactiveRef()
end

local function SetRTSize(self, width, height)
  self.rtWidth = width
  self.rtHeight = height
end

local function OnDestroy(self)
  HeroSimpleModelViewer.openedRef = HeroSimpleModelViewer.openedRef - 1
  self.refTag = nil
  self:ReleaseTexture()
  if self.heroRequest ~= nil then
    self.heroRequest:Destroy()
    self.heroRequest = nil
  end
  if self.heroUWReq then
    self.heroUWReq:Destroy()
    self.heroUWReq = nil
  end
  if self.sceneLoading ~= nil then
    self.sceneLoading:Destroy()
  end
  if self.sceneLoaded ~= nil then
    self.sceneLoaded:Destroy()
  end
  self.sceneLoaded = nil
  self.sceneLoading = nil
  self.curRotationX = nil
  self.sceneCamera = nil
  self.onDragCallBack = nil
  self.rotateState = nil
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
      if animator then
        animator:SetTrigger("idle")
      end
    end
  end
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
  base.OnDisable(self)
end

local function ComponentDefine(self, enableTouch)
  self.rawImage = self:AddComponent(UIRawImage, "")
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
  end
end

local function ComponentDestroy(self)
  self.event_trigger = nil
  self.camera = nil
end

function HeroSimpleModelViewer:ShowEmptyScene()
  self:RemoveHero()
  self:ReloadScene(function(ret)
    if not ret then
      return
    end
    if not IsNull(self.sceneCamera) then
      self.sceneCamera.gameObject:SetActive(true)
    end
    self:ReloadHero(self.heroModelPath, function()
      if self.heroLoadedCallback then
        self.heroLoadedCallback()
      end
    end)
  end)
end

function HeroSimpleModelViewer:SetHeroIdDynamic(heroData)
  if not heroData then
    return
  end
  local heroModelPath, appearanceId, modelSourceType = heroData:GetHeroModelData(HeroModelType.PBR)
  local armedUpgradeAppearanceId, isReplaceArmedUpgradeAppearance = DataCenter.LWArmedUpgradeManager:GetArmedUpgradeAppearanceId(heroData.heroId, appearanceId)
  if isReplaceArmedUpgradeAppearance then
    appearanceId = armedUpgradeAppearanceId
    heroModelPath = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), appearanceId, HeroModelTypeName[HeroModelType.PBR])
  end
  local isPackAsset = HeroModelSourceTypeListInRemotePack[modelSourceType] ~= nil
  if isPackAsset then
    if self.heroModelPath == heroModelPath or self.waitLoadHeroUniqueWeaponModelPath == heroModelPath then
      if self.heroLoadedCallback then
        self.heroLoadedCallback()
      end
      return
    end
  elseif self.heroModelPath == heroModelPath then
    if self.heroLoadedCallback then
      self.heroLoadedCallback()
    end
    return
  end
  self:RemoveHero()
  self.heroData = heroData
  if string.IsNullOrEmpty(heroModelPath) then
    Logger.LogError("HeroSimpleModelViewer heroModelPath\231\169\186\228\186\134\239\188\129\232\139\177\233\155\132\230\168\161\229\158\139\230\178\161\230\152\190\231\164\186\229\135\186\230\157\165\239\188\129 heroId:" .. heroData.heroId .. " weaponLv: " .. heroData:GetUniqueWeaponLv() .. " skinId: " .. heroData:GetSkinId())
    return
  end
  if isPackAsset then
    local isLoaded = UIUtil.CheckAssetDownloaded(heroModelPath)
    if not isLoaded then
      local originalModelPath, originalAppearanceId = HeroUtils.GetHeroModelDataForceHeroSourceType(heroData.heroId, HeroModelType.PBR)
      self.waitLoadHeroUniqueWeaponModelPath = heroModelPath
      heroModelPath = originalModelPath
      appearanceId = originalAppearanceId
    end
  end
  self.heroModelPath = heroModelPath
  self:ReloadScene(function(ret)
    if not ret then
      return
    end
    if not IsNull(self.sceneCamera) then
      self.sceneCamera.gameObject:SetActive(true)
    end
    self.heroRequest = self:ReloadHero(self.heroModelPath, function()
      if self.heroLoadedCallback then
        self.heroLoadedCallback()
      end
    end)
    if self.waitLoadHeroUniqueWeaponModelPath then
      self.heroUWReq = self:ReloadHero(self.waitLoadHeroUniqueWeaponModelPath, function()
        if self.heroRequest then
          self.heroRequest:Destroy()
          self.heroRequest = nil
        end
        if self.heroLoadedCallback then
          self.heroLoadedCallback()
        end
      end)
      self.heroModelPath = self.waitLoadHeroUniqueWeaponModelPath
      self.waitLoadHeroUniqueWeaponModelPath = nil
    end
  end)
end

local function ReloadScene(self, callback)
  if self.sceneLoaded ~= nil then
    local camera = self.sceneCamera
    self:OnRenderTexture(camera)
    self.sceneLoaded.gameObject:SetActive(true)
    if callback ~= nil then
      callback(true)
    end
    return
  end
  if self.sceneLoading ~= nil then
    return
  end
  local scenePath = HeroUtils.DisplayScenePath
  Logger.Log("#RecruitScene# HeroModelViewer  heroScenePreviewPath", scenePath)
  local request = ResourceManager:InstantiateAsync(scenePath)
  self.sceneLoading = request
  request:completed("+", function()
    if request.isError then
      self.sceneLoading = nil
      if callback ~= nil then
        callback(false)
      end
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    request.gameObject.transform:Set_position(self.defaultScenePos.x, self.defaultScenePos.y, self.defaultScenePos.z)
    local camera = request.gameObject.transform:Find("Camera"):GetComponentInChildren(typeof(Camera))
    self.heroSlot = request.gameObject.transform:Find("HeroSlot")
    self.sceneLoading = nil
    self.sceneLoaded = request
    self.sceneCamera = camera
    if self.sceneVisible ~= nil then
      self.sceneLoaded.gameObject:SetActive(self.sceneVisible)
    end
    self:ToggleSceneCamera(true)
    if callback ~= nil then
      callback(true)
    end
  end)
end

local function AddGrabCamera(currentScene, camera, cameraData)
  local grabTransform = camera.transform:Find("GrabCamera")
  if grabTransform == nil then
    local grabObj = currentScene.transform:Find("GrabCamera")
    if grabObj ~= nil then
      grabObj.transform:SetParent(camera.transform)
      grabObj.transform:Set_localScale(1, 1, 1)
      grabObj.transform:Set_localPosition(0, 0, 0)
      grabObj.transform.localRotation = Quaternion.Euler(0, 0, 0)
      grabObj.gameObject:SetActive(true)
      local subCamera = grabObj:GetComponent(typeof(CS.UnityEngine.Camera))
      cameraData.cameraStack:Add(subCamera)
    end
  end
end

local function ReloadHero(self, heroModelPath, callback)
  if string.IsNullOrEmpty(heroModelPath) then
    if callback ~= nil then
      callback(false)
    end
    return
  end
  local request = ResourceManager:InstantiateAsync(heroModelPath)
  request:completed("+", function()
    if request.isError then
      Logger.LogError("#RecruitScene# ModelViewer ReloadHero Error! heroModelPath:" .. heroModelPath .. ", Error:" .. request.error)
      if callback ~= nil then
        callback(false)
      end
      return
    end
    local currentScene = self.sceneLoaded
    local go_rt = request.gameObject.transform
    local spawnPoint = self.heroSlot
    if IsNull(spawnPoint) then
      spawnPoint = currentScene.gameObject.transform
      return
    end
    request.gameObject:SetActive(true)
    go_rt:SetParent(spawnPoint)
    go_rt:Set_localPosition(0, 0, 0)
    go_rt:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go_rt.localRotation = Quaternion.identity
    self.heroModel = go_rt
    local animator = go_rt:GetComponentInChildren(typeof(CS.UnityEngine.Animator), true)
    if not IsNull(animator) then
      animator:SetTrigger("idle")
    end
    if callback ~= nil then
      callback(true)
    end
  end)
  return request
end

local function RemoveHero(self)
  if self.heroRequest ~= nil then
    self.heroRequest:Destroy()
    self.heroRequest = nil
  end
  if self.heroUWReq then
    self.heroUWReq:Destroy()
    self.heroUWReq = nil
  end
  self.heroModelPath = nil
  self.waitLoadHeroUniqueWeaponModelPath = nil
  self.heroData = nil
  self.heroModel = nil
  if not IsNull(self.sceneCamera) then
    self.sceneCamera.gameObject:SetActive(false)
  end
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
  if self.sceneCamera ~= nil then
    self.sceneCamera.targetTexture = nil
  end
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
end

local function Rotate(self, offset)
  local model = self.heroModel
  if not IsNull(model) then
    local y = model.rotation.eulerAngles.y + offset
    model.rotation = Quaternion.Euler(0, y, 0)
  end
end

local function OnBeginDrag(self, eventData)
  self.lastDragPosX = eventData.position.x
  if self.beginDragListener ~= nil then
    self.beginDragListener()
  end
end

local function OnDrag(self, eventData)
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
  if self.endDragListener ~= nil then
    self.endDragListener()
  end
end

local function OnPointerDown(self, eventData)
end

local function OnPointerUp(self, eventData)
end

local function ToggleSceneCamera(self, b)
  local sceneCamera = self.sceneCamera
  if sceneCamera ~= nil then
    sceneCamera.gameObject:SetActive(b)
    if b then
      self:OnRenderTexture(sceneCamera)
    else
      sceneCamera.targetTexture = nil
    end
  end
end

local function StartRotateModel(self, isLeft)
  self.rotateState = isLeft and 1 or 2
end

local function StopRotateModel(self)
  self.rotateState = 0
end

local function SetCameraOffset(self, vector3Offset)
  self.cameraOffset = vector3Offset
  if self.sceneCamera then
    local v3 = HeroSimpleModelViewer.CampCameraPosTable + self.cameraOffset
    self.sceneCamera.transform:Set_localPosition(v3.x, v3.y, v3.z)
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

local function SetLensShift(self, x, y)
end

local function ChangeToPreview(self)
  local camera = self.sceneCamera
  local duration = 0.2
  self:DoCameraAttrAni(camera, "lensShift", Vector2.New(0, 0), duration)
  self:DoCameraAttrAni(camera, "focalLength", 21, duration)
end

local function DoCameraAttrAni(self, camera, attr, endValue, duration)
  local function Getter()
    return camera[attr]
  end
  
  local function Setter(x)
    camera[attr] = x
  end
  
  DOTween.To(Getter, Setter, endValue, duration):SetEase(CS.DG.Tweening.Ease.InOutCubic)
end

local function FindTagRecursively(t, tagName, level)
  local ret1 = {}
  for k = 0, t.childCount - 1 do
    local child = t:GetChild(k)
    if child.gameObject.tag == tagName then
      table.insert(ret1, child)
    elseif 1 < level then
      local ret2 = FindTagRecursively(child, tagName, level - 1)
      table.insertto(ret1, ret2)
    end
  end
  return ret1
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

function HeroSimpleModelViewer:SetSceneVisible(visible)
  self.sceneVisible = visible
  if self.sceneLoaded then
    self.sceneLoaded.gameObject:SetActive(self.sceneVisible)
  end
end

HeroSimpleModelViewer.OnCreate = OnCreate
HeroSimpleModelViewer.OnDestroy = OnDestroy
HeroSimpleModelViewer.OnEnable = OnEnable
HeroSimpleModelViewer.OnDisable = OnDisable
HeroSimpleModelViewer.ComponentDefine = ComponentDefine
HeroSimpleModelViewer.ComponentDestroy = ComponentDestroy
HeroSimpleModelViewer.ReloadScene = ReloadScene
HeroSimpleModelViewer.ReloadHero = ReloadHero
HeroSimpleModelViewer.RemoveHero = RemoveHero
HeroSimpleModelViewer.Rotate = Rotate
HeroSimpleModelViewer.OnRenderTexture = OnRenderTexture
HeroSimpleModelViewer.ReleaseTexture = ReleaseTexture
HeroSimpleModelViewer.OnBeginDrag = OnBeginDrag
HeroSimpleModelViewer.OnDrag = OnDrag
HeroSimpleModelViewer.OnEndDrag = OnEndDrag
HeroSimpleModelViewer.OnPointerDown = OnPointerDown
HeroSimpleModelViewer.OnPointerUp = OnPointerUp
HeroSimpleModelViewer.ToggleSceneCamera = ToggleSceneCamera
HeroSimpleModelViewer.StartRotateModel = StartRotateModel
HeroSimpleModelViewer.StopRotateModel = StopRotateModel
HeroSimpleModelViewer.SetCameraOffset = SetCameraOffset
HeroSimpleModelViewer.SetHeroLoadedCallback = SetHeroLoadedCallback
HeroSimpleModelViewer.SetBeginDragListener = SetBeginDragListener
HeroSimpleModelViewer.SetEndDragListener = SetEndDragListener
HeroSimpleModelViewer.SetDefaultScenePos = SetDefaultScenePos
HeroSimpleModelViewer.SetLensShift = SetLensShift
HeroSimpleModelViewer.SetQuality = SetQuality
HeroSimpleModelViewer.ChangeToPreview = ChangeToPreview
HeroSimpleModelViewer.DoCameraAttrAni = DoCameraAttrAni
HeroSimpleModelViewer.FindTagRecursively = FindTagRecursively
HeroSimpleModelViewer.EnableWorldCamera = EnableWorldCamera
HeroSimpleModelViewer.DisableWorldCamera = DisableWorldCamera
HeroSimpleModelViewer.ToggleSceneVisible = ToggleSceneVisible
HeroSimpleModelViewer.AddGrabCamera = AddGrabCamera
HeroSimpleModelViewer.SetRTSize = SetRTSize
HeroSimpleModelViewer.CampCameraPosTable = 9999
return HeroSimpleModelViewer
