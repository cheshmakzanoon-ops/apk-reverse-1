local hero_dynamic_download_path = "Assets/Download/HeroModel/High/%s.prefab"
local hero_build_in_path = "Assets/PackageRes/Prefabs/HeroModel/High/%s.prefab"
local GameQualitySettings = require("Util.GameQualitySettings")
local default_build_in_model_name = "feixingyuan"
local HeroModelViewer = BaseClass("HeroModelViewer", UIBaseContainer)
local base = UIBaseContainer
local SystemInfo = CS.UnityEngine.SystemInfo
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local ResourceManager = CS.GameEntry.Resource
local PlayableDirector = CS.UnityEngine.Playables.PlayableDirector
local Camera = CS.UnityEngine.Camera
local Screen = CS.UnityEngine.Screen
local HeroRenderLayer = "UIObject3D"
local GrabRenderLayer = "Grab"
local AdvanceEffectName = "HeroAdvanceEffect"
local shadowDistance
HeroModelViewer.openedRef = 0

local function OnCreate(self, enableTouch, onDragCallBack, onTimeLineCallback)
  base.OnCreate(self)
  self:ComponentDefine(enableTouch)
  self.defaultScenePos = Vector3.zero
  self.cameraOffsetFlag = 1
  self.cameraOffset = Vector3.zero
  self.sceneLoaded = {}
  self.sceneCameras = {}
  self.heroCameras = {}
  self.heroModels = {}
  self.sceneLoading = {}
  self.heroLoaded = {}
  self.heroLoading = {}
  self.lastHeroId = nil
  self.lastCamp = nil
  self.heroLoadedCallback = nil
  self.curRotationX = 0
  self.onDragCallBack = onDragCallBack
  self.onTimeLineCallback = onTimeLineCallback
  self.rotateState = 0
  self.rawImage:SetEnable(false)
  self.mainCamera = Camera.main
  self.hudCamera = self.mainCamera.transform:Find("HudCamera"):GetComponent(typeof(Camera))
  HeroModelViewer.openedRef = HeroModelViewer.openedRef + 1
  self.refTag = HeroModelViewer.openedRef
  if HeroModelViewer.openedRef == 1 then
    HeroModelViewer.mainCullingMask = self.mainCamera.cullingMask
    HeroModelViewer.hudCullingMask = self.hudCamera.cullingMask
  end
  self.isFirstHero = true
end

local function OnDestroy(self)
  RenderSetting.ToggleFurRenderFeature(false)
  HeroModelViewer.openedRef = HeroModelViewer.openedRef - 1
  self.refTag = nil
  if HeroModelViewer.openedRef == 0 then
    self:EnableWorldCamera()
  end
  self:ReleaseTexture()
  if self.director then
    self:RemoveTimeLineEvent(self.director)
  end
  if self.heroRequest ~= nil then
    self.heroRequest:RealDestroy()
    self.heroRequest = nil
  end
  for _, v in pairs(self.heroLoading) do
    if v ~= nil then
      v:RealDestroy()
    end
  end
  for _, v in pairs(self.sceneLoading) do
    if v ~= nil then
      v:Destroy()
    end
  end
  for _, v in pairs(self.sceneLoaded) do
    if v ~= nil then
      v:Destroy()
    end
  end
  self.heroLoading = nil
  self.sceneLoaded = nil
  self.sceneLoading = nil
  self.lastHeroId = nil
  self.lastCamp = nil
  self.curRotationX = nil
  self.sceneCameras = nil
  self.heroCameras = nil
  self.heroModels = nil
  self.onDragCallBack = nil
  self.onTimeLineCallback = nil
  self.rotateState = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  for _, v in pairs(self.sceneLoaded) do
    if v ~= nil then
      v.gameObject:SetActive(true)
    end
  end
  self:SetQulity(true)
  RenderSetting.ToggleFurRenderFeature(true)
end

local function SetQulity(self, enable)
  if enable then
    shadowDistance = RenderSetting.GetShadowDistance()
    RenderSetting.SetShadowDistance(6)
  else
    RenderSetting.SetShadowDistance(shadowDistance)
  end
end

local function OnDisable(self)
  for _, v in pairs(self.sceneLoaded) do
    if v ~= nil then
      v.gameObject:SetActive(false)
    end
  end
  base.OnDisable(self)
  self:SetQulity(false)
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
    self.event_trigger:OnPointerDown(function(eventData)
      self:OnPointerDown(eventData)
    end)
    self.event_trigger:OnPointerUp(function(eventData)
      self:OnPointerUp(eventData)
    end)
  end
end

local function ComponentDestroy(self)
  self.event_trigger = nil
  self.camera = nil
end

local function ShowEmptyScene(self)
  self:SetHeroId(nil)
end

local function SetHeroId(self, heroId, heroUuid, showEnterAni, disableWorldCamera)
  self.lastHeroId = self.heroUuid
  self.lastCamp = self.camp
  local camp = heroId ~= nil and GetTableData(HeroUtils.GetHeroXmlName(), heroId, "camp") or self.lastCamp or 1
  self.heroUuid = heroUuid
  self.camp = camp
  self.showEnterAni = showEnterAni
  self.time1 = UITimeManager:GetInstance():GetServerTime()
  self:RemoveHero()
  self:ReloadScene(camp, function(ret)
    if not ret then
      return
    end
    self.time2 = UITimeManager:GetInstance():GetServerTime()
    self.timeLineFinish = false
    self:ReloadHero(self.heroUuid, function(ret2)
      if ret2 then
      end
      if self.isFirstHero and self.refTag == 1 and (disableWorldCamera == nil or disableWorldCamera == true) then
        self:DisableWorldCamera()
      end
      self.isFirstHero = false
      if self.heroLoadedCallback then
        self.heroLoadedCallback()
      end
    end)
  end)
end

local function ReloadScene(self, camp, callback)
  if camp ~= self.lastCamp then
    if self.sceneLoaded[self.lastCamp] then
      self.sceneLoaded[self.lastCamp].gameObject:SetActive(false)
    end
    if self.sceneLoading[self.lastCamp] ~= nil then
      self.sceneLoading[self.lastCamp]:Destroy()
      self.sceneLoading[self.lastCamp] = nil
    end
  end
  if self.sceneLoaded[camp] ~= nil then
    local camera = self.sceneCameras[camp]
    self:OnRenderTexture(camera)
    self.sceneLoaded[camp].gameObject:SetActive(true)
    if callback ~= nil then
      callback(true)
    end
    return
  end
  if self.sceneLoading[camp] ~= nil then
    return
  end
  local scenePath = string.format(HeroUtils.PreviewScenePath, 2)
  Logger.Log("#RecruitScene# HeroModelViewer  heroScenePreviewPath", scenePath)
  local request = ResourceManager:InstantiateAsync(scenePath)
  self.sceneLoading[camp] = request
  request:completed("+", function()
    if request.isError then
      self.sceneLoading[camp] = nil
      if callback ~= nil then
        callback(false)
      end
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    request.gameObject.transform:Set_localPosition(self.defaultScenePos.x, self.defaultScenePos.y, self.defaultScenePos.z)
    local camera = request.gameObject.transform:Find("Camera"):GetComponentInChildren(typeof(Camera))
    if camera then
      local maskValue = 1 << CS.UnityEngine.LayerMask.NameToLayer(HeroRenderLayer)
      camera.cullingMask = maskValue
      camera.depth = 16
      camera.farClipPlane = 10000
    end
    self.sceneLoading[camp] = nil
    self.sceneLoaded[camp] = request
    self.sceneCameras[camp] = camera
    if HeroModelViewer.CampCameraPosTable[camp] == 9999 then
      local pos = camera.gameObject.transform.localPosition
      HeroModelViewer.CampCameraPosTable[camp] = pos
    end
    if self.heroUuid == nil then
      self:ToggleSceneCamera(true)
    end
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

local function ReloadHero(self, heroId, callback)
  if self.heroLoading[heroId] ~= nil then
    return
  end
  if heroId == nil then
    self.timeLineFinish = true
    self:ToggleSceneCamera(true)
    if callback ~= nil then
      callback(false)
    end
    return
  end
  local modelPath
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroId)
  local modelName = ""
  if heroData ~= nil then
    local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(heroData.modelId)
    modelName = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_path")
  end
  if modelName == nil or modelName == "" then
    Logger.LogError("#HeroPreview# ReloadHero Error! prefab_high is nil!, heroId:" .. heroId)
    modelPath = string.format(hero_build_in_path, default_build_in_model_name)
  else
    modelPath = string.format(hero_dynamic_download_path, modelName)
  end
  local request = ResourceManager:InstantiateAsync(modelPath)
  self.heroLoading[heroId] = request
  request:completed("+", function()
    if request.isError then
      Logger.LogError("#RecruitScene# ModelViewer ReloadHero Error! heroId:" .. heroId .. ", Error:" .. request.error)
      self.heroLoading[heroId] = nil
      if callback ~= nil then
        callback(false)
      end
      return
    end
    self.time3 = UITimeManager:GetInstance():GetServerTime()
    local currentScene = self.sceneLoaded[self.camp]
    local go_rt = request.gameObject.transform
    local spawnPoint = currentScene.gameObject.transform:Find("SpawnPoint")
    request.gameObject:SetActive(true)
    go_rt:SetParent(spawnPoint ~= nil and spawnPoint or currentScene.gameObject.transform)
    go_rt:Set_localPosition(0, 0, 0)
    go_rt:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go_rt:Set_eulerAngles(0, 0, 0)
    self.heroLoading[heroId] = nil
    self.heroRequest = request
    local model = go_rt:Find("TimelineRoot/Role")
    model.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer(HeroRenderLayer))
    model:Set_eulerAngles(0, 0, 0)
    self.heroModels[heroId] = model
    local director = go_rt:GetComponentInChildren(typeof(PlayableDirector), true)
    local timeLineCamera = go_rt:GetComponentInChildren(typeof(Camera), true)
    local showEnterAni = self.showEnterAni
    self.curTimeLineCamera = timeLineCamera
    if not showEnterAni then
      if director then
        director.enabled = false
      end
      local animator = model:GetComponentInChildren(typeof(CS.UnityEngine.Animator), true)
      if animator then
        animator:SetTrigger("idle")
      end
      if timeLineCamera ~= nil then
        timeLineCamera.gameObject:SetActive(false)
      end
    else
      if timeLineCamera ~= nil then
        local maskValue = 1 << CS.UnityEngine.LayerMask.NameToLayer(HeroRenderLayer)
        timeLineCamera.gameObject:SetActive(showEnterAni)
        timeLineCamera.cullingMask = maskValue
        timeLineCamera.depth = 15
        timeLineCamera.farClipPlane = 10000
        local additionalData = timeLineCamera:GetComponent(typeof(CS.UnityEngine.Rendering.Universal.UniversalAdditionalCameraData))
        if additionalData ~= nil then
          self.AddGrabCamera(currentScene.gameObject, timeLineCamera, additionalData)
          local layerMask = CS.UnityEngine.LayerMask()
          layerMask.value = maskValue
          additionalData.volumeLayerMask = layerMask
          additionalData.renderPostProcessing = true
        end
        self:OnRenderTexture(timeLineCamera)
        self.heroCameras[heroId] = timeLineCamera
      end
      self:PlayTimeLine(director)
    end
    self.timeLineFinish = not showEnterAni or director == nil
    self:ToggleSceneCamera(not showEnterAni or timeLineCamera == nil)
    if callback ~= nil then
      callback(true)
    end
  end)
end

local function PlayTimeLine(self, director)
  if director == nil then
    self:OnTimeLineEvent("stop")
    return
  end
  
  function self.directorPlayed(dir)
    self:OnTimeLineEvent("start")
  end
  
  function self.directorStopped(dir)
    self:OnTimeLineEvent("stop")
  end
  
  director.enabled = true
  director:played("+", self.directorPlayed)
  director:stopped("+", self.directorStopped)
  self.director = director
end

local function RemoveTimeLineEvent(self, director)
  if director then
    if self.directorPlayed then
      director:played("-", self.directorPlayed)
      self.directorPlayed = nil
    end
    if self.directorStopped then
      director:stopped("-", self.directorStopped)
      self.directorStopped = nil
    end
  end
end

local function RemoveHero(self)
  if self.lastHeroId ~= nil then
    if self.heroLoading[self.lastHeroId] ~= nil then
      self.heroLoading[self.lastHeroId]:RealDestroy()
      self.heroLoading[self.lastHeroId] = nil
    end
    local oldHeroCamera = self.heroCameras[self.lastHeroId]
    if oldHeroCamera ~= nil then
      oldHeroCamera.targetTexture = nil
    end
    self.heroCameras[self.lastHeroId] = nil
    self:ToggleSceneCamera(true)
    self.heroModels[self.lastHeroId] = nil
  end
  if self.heroRequest ~= nil then
    self.heroRequest:RealDestroy()
    self.heroRequest = nil
  end
  if self.director then
    self:RemoveTimeLineEvent(self.director)
    self.director = nil
  end
end

local function OnRenderTexture(self, camera)
  if camera == nil then
    Logger.LogError("#zlh# OnRenderTexture camera is nil!")
    return
  end
  if self.renderTexture == nil then
    local scale = 1
    if not GameQualitySettings.IsHighGearQuality() then
      scale = 0.8
    end
    local rtWidth = math.floor(Screen.width * scale)
    local rtHeight = math.floor(Screen.height * scale)
    local rtFormat = RenderTextureFormat.ARGB32
    self.renderTexture = RenderTexture.GetTemporary(rtWidth, rtHeight, 24, rtFormat)
    self.renderTexture.name = "HeroShow"
    self.rawImage:SetTexture(self.renderTexture)
    self.rawImage:SetEnable(true)
    self.rawImage:SetColor(Color.New(1, 1, 1, 1))
  end
  camera.targetTexture = self.renderTexture
end

local function ReleaseTexture(self)
  self.rawImage:SetTexture(nil)
  for _, camera in pairs(self.heroCameras) do
    if camera ~= nil then
      camera.targetTexture = nil
    end
  end
  for _, camera in pairs(self.sceneCameras) do
    if camera ~= nil then
      camera.targetTexture = nil
    end
  end
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
end

local function Rotate(self, offset)
  if not self.timeLineFinish then
    return
  end
  local model = self.heroModels[self.heroUuid]
  if model ~= nil then
    local y = model.transform.rotation.eulerAngles.y + offset
    model.transform.rotation = Quaternion.Euler(0, y, 0)
  end
end

local function OnBeginDrag(self, eventData)
  self.lastDragPosX = eventData.position.x
  if self.beginDragListener ~= nil then
    self.beginDragListener()
  end
end

local function OnDrag(self, eventData)
  if not self.timeLineFinish then
    return
  end
  local currentPosX = eventData.position.x
  if currentPosX > Screen.width then
    return
  end
  local offset = self.lastDragPosX - currentPosX
  self.lastDragPosX = currentPosX
  self:Rotate(offset)
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

local function OnTimeLineEvent(self, event)
  if event == "start" then
    self.timeLineFinish = false
  elseif event == "stop" then
    self.timeLineFinish = true
  end
  if self.onTimeLineCallback then
    self.onTimeLineCallback(event)
  end
end

local function DebugTimeCamera(self)
  local function CheckAngle(a)
    return 180 < a and a - 360 or a
  end
  
  if self.curTimeLineCamera ~= nil then
    local parent = self.curTimeLineCamera.parent
    local pos = self.curTimeLineCamera.transform.position
    local angles = self.curTimeLineCamera.transform.rotation.eulerAngles
    local scale = self.curTimeLineCamera.transform.localScale
    local lossyScale = self.curTimeLineCamera.transform.lossyScale
    local posStr = string.format("%.3f|%.3f|%.3f", pos.x, pos.y, pos.z)
    local anglesStr = string.format("%.3f|%.3f|%.3f", CheckAngle(angles.x), CheckAngle(angles.y), CheckAngle(angles.z))
    local scaleStr = string.format("%.3f|%.3f|%.3f", lossyScale.x, lossyScale.y, lossyScale.z)
    local focalLength = self.curTimeLineCamera.focalLength
    local sensorSize = self.curTimeLineCamera.sensorSize
    local sensorStr = string.format("%.3f|%.3f", sensorSize.x, sensorSize.y)
  end
end

local function ToggleSceneCamera(self, b)
  local sceneCamera = self.sceneCameras[self.camp]
  if sceneCamera ~= nil then
    sceneCamera.gameObject:SetActive(b)
    if b then
      local pos = 0
      if type(self.camp) ~= "number" or not table.containsKey(HeroModelViewer.CampCameraPosTable, self.camp) then
        pos = HeroModelViewer.CampCameraPosTable[1]
      else
        pos = HeroModelViewer.CampCameraPosTable[self.camp]
      end
      local final = Vector3.New(pos, pos, pos) + self.cameraOffset
      sceneCamera.gameObject.transform:Set_localPosition(final.x, final.y, final.z)
      self:ApplyCameraLensShift()
      self:OnRenderTexture(sceneCamera)
    else
      sceneCamera.targetTexture = nil
    end
  end
end

local function StartRotateModel(self, isLeft)
  if not self.timeLineFinish then
    return
  end
  self.rotateState = isLeft and 1 or 2
end

local function StopRotateModel(self)
  self.rotateState = 0
end

local function SetCameraOffset(self, vector3Offset)
  self.cameraOffset = vector3Offset
  if not self.showEnterAni then
    for camp, v in pairs(self.sceneCameras) do
      if v then
        local v3 = HeroModelViewer.CampCameraPosTable[camp] + self.cameraOffset
        v.transform:Set_localPosition(v3.x, v3.y, v3.z)
      end
    end
  end
end

local function ApplyCameraLensShift(self)
  local camera
  if not self.showEnterAni then
    camera = self.sceneCameras[self.camp]
  else
    camera = self.curTimeLineCamera
  end
  if camera ~= nil and self.lensShift ~= nil then
    camera.lensShift = self.lensShift
  end
end

local function Update(self)
end

local function ShowHeroAdvanceEffect(self)
  local effectPath = "Assets/Main/Prefabs/Effect/HeroAdvanceEffect.prefab"
  local currentScene = self.sceneLoaded[self.camp]
  if IsNull(currentScene.gameObject) then
    return
  end
  local effectObj = currentScene.gameObject.transform:Find(AdvanceEffectName)
  if effectObj ~= nil then
    effectObj.gameObject:SetActive(false)
    effectObj.gameObject:SetActive(true)
    return
  end
  local request = ResourceManager:InstantiateAsync(effectPath)
  request:completed("+", function()
    if request.isError then
      return
    end
    if self.heroRequest == nil or IsNull(currentScene.gameObject) then
      request:RealDestroy()
      return
    end
    request.gameObject.transform:SetParent(currentScene.gameObject.transform)
    request.gameObject.name = AdvanceEffectName
    request.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer(HeroRenderLayer))
    request.gameObject:SetActive(true)
    request.gameObject.transform.localPosition = Vector3.zero
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
  end)
end

local function HideHeroAdvanceEffect(self)
  local currentScene = self.sceneLoaded[self.camp]
  local effectObj = currentScene.gameObject.transform:Find(AdvanceEffectName)
  if effectObj ~= nil then
    effectObj.gameObject:SetActive(false)
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

local function ChangeToRank(self)
  local go_rt = self.heroRequest.gameObject.transform
  local director = go_rt:GetComponentInChildren(typeof(PlayableDirector), true)
  if director then
    director.enabled = false
  end
  local model = go_rt:Find("TimelineRoot/Role")
  if model then
    local animator = model:GetComponentInChildren(typeof(CS.UnityEngine.Animator), true)
    if animator then
      animator:SetTrigger("idle")
    end
    local items = HeroModelViewer.FindTagRecursively(model.transform, "Info", 2)
    if items ~= nil then
      for _, v in pairs(items) do
        v.gameObject:SetActive(false)
      end
    end
  end
  local timeLineCamera = go_rt:GetComponentInChildren(typeof(Camera), true)
  if timeLineCamera then
    timeLineCamera.targetTexture = nil
  end
  self:ToggleSceneCamera(true)
  local camera = self.sceneCameras[self.camp]
  local duration = 0.2
  self:DoCameraAttrAni(camera, "lensShift", Vector2.New(0.1, 0.1), duration)
  self:DoCameraAttrAni(camera, "focalLength", 36, duration)
end

local function ChangeToPreview(self)
  local camera = self.sceneCameras[self.camp]
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
  self.mainCamera.cullingMask = HeroModelViewer.mainCullingMask
  self.hudCamera.cullingMask = HeroModelViewer.hudCullingMask
  pcall(function()
    if CS.SceneManager.World then
      CS.SceneManager.World:EnablePostProcess()
    end
  end)
end

local function DisableWorldCamera(self)
  self.mainCamera.cullingMask = 0
  self.hudCamera.cullingMask = 0
  pcall(function()
    if CS.SceneManager.World then
      CS.SceneManager.World:DisablePostProcess()
    end
  end)
end

local function ToggleSceneVisible(self, t)
  if self.sceneLoaded[self.camp] then
    self.sceneLoaded[self.camp].gameObject:SetActive(t)
  end
end

HeroModelViewer.OnCreate = OnCreate
HeroModelViewer.OnDestroy = OnDestroy
HeroModelViewer.OnEnable = OnEnable
HeroModelViewer.OnDisable = OnDisable
HeroModelViewer.ComponentDefine = ComponentDefine
HeroModelViewer.ComponentDestroy = ComponentDestroy
HeroModelViewer.ShowEmptyScene = ShowEmptyScene
HeroModelViewer.SetHeroId = SetHeroId
HeroModelViewer.ReloadScene = ReloadScene
HeroModelViewer.ReloadHero = ReloadHero
HeroModelViewer.RemoveHero = RemoveHero
HeroModelViewer.Rotate = Rotate
HeroModelViewer.OnRenderTexture = OnRenderTexture
HeroModelViewer.ReleaseTexture = ReleaseTexture
HeroModelViewer.OnBeginDrag = OnBeginDrag
HeroModelViewer.OnDrag = OnDrag
HeroModelViewer.OnEndDrag = OnEndDrag
HeroModelViewer.OnPointerDown = OnPointerDown
HeroModelViewer.OnPointerUp = OnPointerUp
HeroModelViewer.ToggleSceneCamera = ToggleSceneCamera
HeroModelViewer.StartRotateModel = StartRotateModel
HeroModelViewer.StopRotateModel = StopRotateModel
HeroModelViewer.SetCameraOffset = SetCameraOffset
HeroModelViewer.ShowHeroAdvanceEffect = ShowHeroAdvanceEffect
HeroModelViewer.HideHeroAdvanceEffect = HideHeroAdvanceEffect
HeroModelViewer.OnTimeLineEvent = OnTimeLineEvent
HeroModelViewer.Update = Update
HeroModelViewer.PlayTimeLine = PlayTimeLine
HeroModelViewer.RemoveTimeLineEvent = RemoveTimeLineEvent
HeroModelViewer.SetHeroLoadedCallback = SetHeroLoadedCallback
HeroModelViewer.SetBeginDragListener = SetBeginDragListener
HeroModelViewer.SetEndDragListener = SetEndDragListener
HeroModelViewer.SetDefaultScenePos = SetDefaultScenePos
HeroModelViewer.DebugTimeCamera = DebugTimeCamera
HeroModelViewer.SetLensShift = SetLensShift
HeroModelViewer.ApplyCameraLensShift = ApplyCameraLensShift
HeroModelViewer.SetShadow = SetShadow
HeroModelViewer.ResetShadow = ResetShadow
HeroModelViewer.SetQulity = SetQulity
HeroModelViewer.ChangeToRank = ChangeToRank
HeroModelViewer.ChangeToPreview = ChangeToPreview
HeroModelViewer.DoCameraAttrAni = DoCameraAttrAni
HeroModelViewer.FindTagRecursively = FindTagRecursively
HeroModelViewer.EnableWorldCamera = EnableWorldCamera
HeroModelViewer.DisableWorldCamera = DisableWorldCamera
HeroModelViewer.ToggleSceneVisible = ToggleSceneVisible
HeroModelViewer.AddGrabCamera = AddGrabCamera
HeroModelViewer.CampCameraPosTable = {
  [0] = 9999,
  [1] = 9999,
  [2] = 9999,
  [3] = 9999
}
return HeroModelViewer
