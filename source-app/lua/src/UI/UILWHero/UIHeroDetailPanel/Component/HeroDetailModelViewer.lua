local hero_build_in_path = LoadPath.DyHero
local default_build_in_model_name = "tank"
local HeroDetailModelViewer = BaseClass("HeroDetailModelViewer", UIBaseContainer)
local GameQualitySettings = require("Util.GameQualitySettings")
local RTUtils = require("Util.RTUtils")
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
local shadowDistance, defaultQuality
HeroDetailModelViewer.openedRef = 0

local function OnCreate(self, enableTouch, onDragCallBack, onTimeLineCallback)
  base.OnCreate(self)
  self:ComponentDefine(enableTouch)
  self.defaultScenePos = Vector3.New(9999, 9999, 9999)
  self.cameraOffsetFlag = 1
  self.cameraOffset = Vector3.zero
  self.sceneLoaded = nil
  self.sceneCamera = nil
  self.heroModels = {}
  self.sceneLoading = nil
  self.heroesLoaded = {}
  self.heroesLoading = {}
  self.lastHeroesUuid = nil
  self.heroLoadedCallback = nil
  self.heroId = 0
  self.curRotationX = 0
  self.onDragCallBack = onDragCallBack
  self.onTimeLineCallback = onTimeLineCallback
  self.rotateState = 0
  self.rawImage:SetEnable(false)
  HeroDetailModelViewer.openedRef = HeroDetailModelViewer.openedRef + 1
  self.refTag = HeroDetailModelViewer.openedRef
  self.extraImgComponent = {}
end

local function OnDestroy(self)
  RenderSetting.ToggleFurRenderFeature(false)
  HeroDetailModelViewer.openedRef = HeroDetailModelViewer.openedRef - 1
  self.refTag = nil
  self:ReleaseTexture()
  for _, v in pairs(self.heroesLoading) do
    if v ~= nil then
      v:Destroy()
    end
  end
  for _, v in pairs(self.heroesLoaded) do
    if v ~= nil then
      v:Destroy()
    end
  end
  if self.sceneLoading ~= nil then
    self.sceneLoading:Destroy()
  end
  if self.sceneLoaded ~= nil then
    self.sceneLoaded:Destroy()
  end
  self.heroesLoading = nil
  self.sceneLoaded = nil
  self.sceneLoading = nil
  self.lastHeroId = nil
  self.curRotationX = nil
  self.sceneCamera = nil
  self.heroModels = nil
  self.onDragCallBack = nil
  self.onTimeLineCallback = nil
  self.rotateState = nil
  self.heroId = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  if self.sceneLoaded ~= nil then
    self.sceneLoaded.gameObject:SetActive(true)
  end
  self:SetQuality(true)
  RenderSetting.ToggleFurRenderFeature(true)
  for _, v in pairs(self.heroModels) do
    local model = v
    local animation = model:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    if animation then
      animation:Stop()
      animation:Play("idle")
    end
  end
end

local function SetQuality(self, enable)
  if enable then
    shadowDistance = RenderSetting.GetShadowDistance()
    RenderSetting.SetShadowDistance(6)
  else
    RenderSetting.SetShadowDistance(shadowDistance)
  end
end

local function OnDisable(self)
  if self.sceneLoaded ~= nil then
    self.sceneLoaded.gameObject:SetActive(false)
  end
  base.OnDisable(self)
  self:SetQuality(false)
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
  self.hero1Slot = nil
  self.hero2Slot = nil
  self.hero3Slot = nil
  self.hero4Slot = nil
  self.hero5Slot = nil
  self.hero6Slot = nil
  self.hero7Slot = nil
  self.hero8Slot = nil
  self.hero9Slot = nil
  self.heroSlots = nil
  self.shadow1 = nil
  self.shadow2 = nil
  self.shadow3 = nil
  self.shadow4 = nil
  self.shadow5 = nil
  self.shadow6 = nil
  self.shadow7 = nil
  self.shadow8 = nil
  self.shadow9 = nil
  self.shadows = nil
end

local function SetHeroId(self, heroId, shadowScale, shadowOffset)
  if self.heroId == heroId then
    return
  end
  self.lastHeroUuid = self.heroId
  self.heroId = heroId
  self.time1 = UITimeManager:GetInstance():GetServerTime()
  self:RemoveLastHero(heroId)
  self:ReloadScene(function(ret)
    if not ret then
      return
    end
    self.time2 = UITimeManager:GetInstance():GetServerTime()
    if self.heroId == nil then
      return
    end
    if shadowScale ~= nil then
      local scaleX = self.shadows[1].transform.localScale.x
      local scaleY = self.shadows[1].transform.localScale.y
      local scaleZ = self.shadows[1].transform.localScale.z
      if shadowScale[1] ~= nil then
        scaleX = shadowScale[1]
      end
      if shadowScale[2] ~= nil then
        scaleY = shadowScale[2]
      end
      if shadowScale[3] ~= nil then
        scaleZ = shadowScale[3]
      end
      for _, v in pairs(self.shadows) do
        if v ~= nil then
          v:Set_localScale(scaleX, scaleY, scaleZ)
        end
      end
    end
    if shadowOffset ~= nil then
      local offsetX = self.shadows[1].transform.localPosition.x
      local offsetY = self.shadows[1].transform.localPosition.y
      local offsetZ = self.shadows[1].transform.localPosition.z
      if shadowOffset[1] ~= nil then
        offsetX = shadowOffset[1]
      end
      if shadowOffset[2] ~= nil then
        offsetY = shadowOffset[2]
      end
      if shadowOffset[3] ~= nil then
        offsetZ = shadowOffset[3]
      end
      for _, v in pairs(self.shadows) do
        if v ~= nil then
          v:Set_localPosition(offsetX, offsetY, offsetZ)
        end
      end
    end
    local modelPath
    local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(heroId)
    local heroAppearanceTemplate = DataCenter.AppearanceTemplateManager:GetTemplate(heroTemplate.appearance)
    local modelName = ""
    local cannonPath = ""
    if heroTemplate ~= nil then
      modelName = heroAppearanceTemplate.model_path
      cannonPath = heroAppearanceTemplate.canon_path
    end
    if modelName == nil or modelName == "" then
      Logger.LogError("#HeroPreview# ReloadHero Error! prefab_high is nil!, heroId:" .. self.heroId)
      modelPath = string.format(hero_build_in_path, default_build_in_model_name)
    else
      modelPath = modelName
    end
    local localForward = Vector3.New(0, 0, 0)
    local canonFix = heroAppearanceTemplate.canon_rotation
    if canonFix and #canonFix == 3 then
      localForward = Vector3.forward * Quaternion.Euler(canonFix[1], canonFix[2], canonFix[3])
    end
    for i = 1, 9 do
      self:ReloadHero(i, modelPath, cannonPath, localForward, function(ret2)
        if ret2 then
        end
        if self.heroLoadedCallback then
          self.heroLoadedCallback()
        end
      end)
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
  local scenePath = HeroUtils.DisplayHeroDetailScenePath
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
    request.gameObject.transform:Set_localPosition(self.defaultScenePos.x, self.defaultScenePos.y, self.defaultScenePos.z)
    local camera = request.gameObject.transform:Find("Camera"):GetComponentInChildren(typeof(Camera))
    self.sceneLoading = nil
    self.sceneLoaded = request
    self.sceneCamera = camera
    self:ToggleSceneCamera(true)
    self.hero1Slot = request.gameObject.transform:Find("HeroSlot1")
    self.hero2Slot = request.gameObject.transform:Find("HeroSlot2")
    self.hero3Slot = request.gameObject.transform:Find("HeroSlot3")
    self.hero4Slot = request.gameObject.transform:Find("HeroSlot4")
    self.hero5Slot = request.gameObject.transform:Find("HeroSlot5")
    self.hero6Slot = request.gameObject.transform:Find("HeroSlot6")
    self.hero7Slot = request.gameObject.transform:Find("HeroSlot7")
    self.hero8Slot = request.gameObject.transform:Find("HeroSlot8")
    self.hero9Slot = request.gameObject.transform:Find("HeroSlot9")
    self.heroSlots = {
      self.hero1Slot,
      self.hero2Slot,
      self.hero3Slot,
      self.hero4Slot,
      self.hero5Slot,
      self.hero6Slot,
      self.hero7Slot,
      self.hero8Slot,
      self.hero9Slot
    }
    self.shadow1 = request.gameObject.transform:Find("HeroSlot1/New Sprite")
    self.shadow2 = request.gameObject.transform:Find("HeroSlot2/New Sprite")
    self.shadow3 = request.gameObject.transform:Find("HeroSlot3/New Sprite")
    self.shadow4 = request.gameObject.transform:Find("HeroSlot4/New Sprite")
    self.shadow5 = request.gameObject.transform:Find("HeroSlot5/New Sprite")
    self.shadow6 = request.gameObject.transform:Find("HeroSlot6/New Sprite")
    self.shadow7 = request.gameObject.transform:Find("HeroSlot7/New Sprite")
    self.shadow8 = request.gameObject.transform:Find("HeroSlot8/New Sprite")
    self.shadow9 = request.gameObject.transform:Find("HeroSlot9/New Sprite")
    self.shadows = {
      self.shadow1,
      self.shadow2,
      self.shadow3,
      self.shadow4,
      self.shadow5,
      self.shadow6,
      self.shadow7,
      self.shadow8,
      self.shadow9
    }
    if callback ~= nil then
      callback(true)
    end
  end)
end

local function SetHeroOnSlot(self, heroModel, slotIndex)
  if heroModel == nil then
    return
  end
  if self.heroSlots == nil or self.heroSlots[slotIndex] == nil then
    return
  end
  local slot = self.heroSlots[slotIndex]
  local slotTransform = slot.transform
  local heroTransform = heroModel.transform
  heroTransform:SetParent(slotTransform)
  heroTransform:Set_localPosition(0, 0, 0)
  heroTransform:Set_localScale(1, 1, 1)
  heroTransform:Set_localEulerAngles(0, 0, 0)
end

local function ReloadHero(self, slotIndex, modelPath, cannonPath, cannonForward, callback)
  if self.heroesLoading[slotIndex] ~= nil then
    return
  end
  if modelPath == nil then
    if callback ~= nil then
      callback(false)
    end
    return
  end
  if self.heroesLoaded[slotIndex] ~= nil then
    self.heroesLoaded[slotIndex].gameObject:SetActive(true)
    SetHeroOnSlot(self, self.heroesLoaded[slotIndex].gameObject, slotIndex)
    if callback ~= nil then
      callback(true)
    end
    return
  end
  local request = ResourceManager:InstantiateAsync(modelPath)
  self.heroesLoading[slotIndex] = request
  request:completed("+", function()
    if request.isError then
      Logger.LogError("#RecruitScene# ModelViewer ReloadHero Error! Path:" .. modelPath .. ", Error:" .. request.error)
      self.heroesLoading[slotIndex] = nil
      if callback ~= nil then
        callback(false)
      end
      return
    end
    self.time3 = UITimeManager:GetInstance():GetServerTime()
    local currentScene = self.sceneLoaded
    local go_rt = request.gameObject.transform
    local spawnPoint = currentScene.gameObject.transform:Find("SpawnPoint")
    request.gameObject:SetActive(true)
    go_rt:SetParent(spawnPoint ~= nil and spawnPoint or currentScene.gameObject.transform)
    go_rt:Set_localPosition(0, 0, 0)
    go_rt:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go_rt:Set_localEulerAngles(0, 0, 0)
    self.heroesLoading[slotIndex] = nil
    go_rt.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer(HeroRenderLayer))
    go_rt:Set_localEulerAngles(0, 0, 0)
    self.heroModels[slotIndex] = go_rt
    local director = go_rt:GetComponentInChildren(typeof(PlayableDirector), true)
    local timeLineCamera = go_rt:GetComponentInChildren(typeof(Camera), true)
    if director then
      director.enabled = false
    end
    local animation = go_rt:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    if animation then
      animation:Stop()
      animation:Play("idle")
    end
    if timeLineCamera ~= nil then
      timeLineCamera.gameObject:SetActive(false)
    end
    SetHeroOnSlot(self, request.gameObject, slotIndex)
    local cannon = go_rt:Find(cannonPath)
    if cannon ~= nil then
      cannon:Set_localEulerAngles(cannonForward)
    end
    self.heroesLoading[slotIndex] = nil
    self.heroesLoaded[slotIndex] = request
    if callback ~= nil then
      callback(true)
    end
  end)
end

local function RemoveLastHero(self, heroId)
  if self.heroesLoading ~= nil then
    for k, v in pairs(self.heroesLoading) do
      v:Destroy()
      self.heroesLoading[k] = nil
    end
  end
  if self.heroesLoaded ~= nil then
    for k, v in pairs(self.heroesLoaded) do
      v:Destroy()
      self.heroesLoaded[k] = nil
    end
  end
  self.heroModels = {}
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
    local rtWidth = DefaultScreenHeight
    local rtHeight = DefaultScreenHeight
    self.renderTexture = RTUtils.GetTemporaryWithFallback(rtWidth, rtHeight, 24)
    if IsNull(self.renderTexture) then
      Logger.LogError(string.format("#HeroPreview# GetTemporaryWithFallback failed! size=%sx%s", tostring(rtWidth), tostring(rtHeight)))
      return
    end
    self.renderTexture.name = "HeroShow"
    self.rawImage:SetTexture(self.renderTexture)
    self.rawImage:SetEnable(true)
    self.rawImage:SetColor(Color.New(1, 1, 1, 1))
  end
  camera.targetTexture = self.renderTexture
end

local function AddRawImageTexture(self, rawImage)
  if rawImage == nil then
    return
  end
  rawImage:SetTexture(self.renderTexture)
  rawImage:SetEnable(true)
  rawImage:SetColor(Color.New(1, 1, 1, 1))
  table.insert(self.extraImgComponent, rawImage)
end

local function RemoveRawImageTexture(self, rawImage)
  if rawImage == nil then
    return
  end
  rawImage:SetTexture(nil)
  rawImage:SetEnable(false)
  rawImage:SetColor(Color.New(1, 1, 1, 0))
  for i, v in ipairs(self.extraImgComponent) do
    if v == rawImage then
      table.remove(self.extraImgComponent, i)
      break
    end
  end
end

local function ReleaseTexture(self)
  self.rawImage:SetTexture(nil)
  for i, v in ipairs(self.extraImgComponent) do
    v:SetTexture(nil)
  end
  if self.sceneCamera ~= nil then
    self.sceneCamera.targetTexture = nil
  end
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
end

local function Rotate(self, offset)
  local model = self.heroModels[self.heroId]
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
    local v3 = HeroDetailModelViewer.CampCameraPosTable + self.cameraOffset
    self.sceneCamera.transform:Set_localPosition(v3.x, v3.y, v3.z)
  end
end

local function ApplyCameraLensShift(self)
  local camera
  camera = self.curTimeLineCamera
  if camera ~= nil and self.lensShift ~= nil then
    camera.lensShift = self.lensShift
  end
end

local function Update(self)
end

local function SetHeroLoadedCallback(self, callback)
  self.heroLoadedCallback = callback
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

local function ToggleSceneVisible(self, t)
  if self.sceneLoaded then
    self.sceneLoaded.gameObject:SetActive(t)
  end
end

HeroDetailModelViewer.OnCreate = OnCreate
HeroDetailModelViewer.OnDestroy = OnDestroy
HeroDetailModelViewer.OnEnable = OnEnable
HeroDetailModelViewer.OnDisable = OnDisable
HeroDetailModelViewer.ComponentDefine = ComponentDefine
HeroDetailModelViewer.ComponentDestroy = ComponentDestroy
HeroDetailModelViewer.SetHeroId = SetHeroId
HeroDetailModelViewer.ReloadScene = ReloadScene
HeroDetailModelViewer.ReloadHero = ReloadHero
HeroDetailModelViewer.RemoveLastHero = RemoveLastHero
HeroDetailModelViewer.Rotate = Rotate
HeroDetailModelViewer.OnRenderTexture = OnRenderTexture
HeroDetailModelViewer.ReleaseTexture = ReleaseTexture
HeroDetailModelViewer.OnBeginDrag = OnBeginDrag
HeroDetailModelViewer.OnDrag = OnDrag
HeroDetailModelViewer.OnEndDrag = OnEndDrag
HeroDetailModelViewer.OnPointerDown = OnPointerDown
HeroDetailModelViewer.OnPointerUp = OnPointerUp
HeroDetailModelViewer.ToggleSceneCamera = ToggleSceneCamera
HeroDetailModelViewer.StartRotateModel = StartRotateModel
HeroDetailModelViewer.StopRotateModel = StopRotateModel
HeroDetailModelViewer.SetCameraOffset = SetCameraOffset
HeroDetailModelViewer.Update = Update
HeroDetailModelViewer.SetHeroLoadedCallback = SetHeroLoadedCallback
HeroDetailModelViewer.SetDefaultScenePos = SetDefaultScenePos
HeroDetailModelViewer.SetLensShift = SetLensShift
HeroDetailModelViewer.ApplyCameraLensShift = ApplyCameraLensShift
HeroDetailModelViewer.SetShadow = SetShadow
HeroDetailModelViewer.ResetShadow = ResetShadow
HeroDetailModelViewer.SetQuality = SetQuality
HeroDetailModelViewer.ChangeToPreview = ChangeToPreview
HeroDetailModelViewer.DoCameraAttrAni = DoCameraAttrAni
HeroDetailModelViewer.FindTagRecursively = FindTagRecursively
HeroDetailModelViewer.ToggleSceneVisible = ToggleSceneVisible
HeroDetailModelViewer.AddRawImageTexture = AddRawImageTexture
HeroDetailModelViewer.RemoveRawImageTexture = RemoveRawImageTexture
HeroDetailModelViewer.CampCameraPosTable = 9999
return HeroDetailModelViewer
