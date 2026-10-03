local hero_dynamic_download_path = "Assets/Download/HeroModel/High/%s.prefab"
local hero_build_in_path = "Assets/PackageRes/Prefabs/HeroModel/High/%s.prefab"
local default_build_in_model_name = "feixingyuan"
local GameQualitySettings = require("Util.GameQualitySettings")
local LightPath = "City/Scene_City2(Clone)/Light_City"
local TacticalWeaponSimpleModelViewer = BaseClass("TacticalWeaponSimpleModelViewer", UIBaseContainer)
local base = UIBaseContainer
local SystemInfo = CS.UnityEngine.SystemInfo
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local ResourceManager = CS.GameEntry.Resource
local PlayableDirector = CS.UnityEngine.Playables.PlayableDirector
local Camera = CS.UnityEngine.Camera
local Screen = CS.UnityEngine.Screen
local shadowDistance
TacticalWeaponSimpleModelViewer.openedRef = 0

local function OnCreate(self, enableTouch, onDragCallBack)
  base.OnCreate(self)
  self:ComponentDefine(enableTouch)
  self.defaultScenePos = Vector3.New(-5000, 0, -5000)
  self.cameraOffsetFlag = 1
  self.cameraOffset = Vector3.zero
  self.rtWidth = DefaultScreenHeight
  self.rtHeight = DefaultScreenHeight
  self.sceneRequest = nil
  self.sceneCamera = nil
  self.weaponModel = nil
  self.weaponSimpleAnim = nil
  self.weaponLoadCallback = nil
  self.curRotationX = 0
  self.onDragCallBack = onDragCallBack
  self.rotateState = 0
  self.rawImage:SetEnable(false)
  TacticalWeaponSimpleModelViewer.openedRef = TacticalWeaponSimpleModelViewer.openedRef + 1
  self.refTag = TacticalWeaponSimpleModelViewer.openedRef
  DataCenter.CityLightManager:AddDeactiveRef()
end

local function SetRTSize(self, width, height)
  self.rtWidth = width
  self.rtHeight = height
end

local function OnDestroy(self)
  self:RemoveWeapon()
  self:RemoveReplaceEffectModels()
  self.playClickModelId = nil
  TacticalWeaponSimpleModelViewer.openedRef = TacticalWeaponSimpleModelViewer.openedRef - 1
  self.refTag = nil
  if TacticalWeaponSimpleModelViewer.openedRef == 0 then
    self:EnableWorldCamera()
  end
  self:ReleaseTexture()
  if self.playIdleTimer ~= nil then
    self.playIdleTimer:Stop()
    self.playIdleTimer = nil
  end
  if self.sceneRequest ~= nil then
    self.sceneRequest:Destroy()
  end
  self.sceneRequest = nil
  self.curRotationX = nil
  self.sceneCamera = nil
  self.weaponModel = nil
  self.weaponSimpleAnim = nil
  self.onDragCallBack = nil
  self.rotateState = nil
  self.replaceEffectCallback = nil
  DataCenter.CityLightManager:DecreaseDeactiveRef()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.dragging = false
  if self.sceneRequest ~= nil and not IsNull(self.sceneRequest.gameObject) then
    self.sceneRequest.gameObject:SetActive(true)
  end
  if self.appearanceId ~= nil then
    local model = self.weaponModel
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
  if self.sceneRequest ~= nil and not IsNull(self.sceneRequest.gameObject) then
    self.sceneRequest.gameObject:SetActive(false)
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
    self.event_trigger:OnPointerClick(function(eventData)
      self:OnPointerClick(eventData)
    end)
  end
  self.enableTouch = enableTouch
end

local function ComponentDestroy(self)
  self.event_trigger = nil
  self.camera = nil
end

local function ShowEmptyScene(self)
  self:SetModelPath(nil)
end

local function SetModelPath(self, appearanceId)
  if not appearanceId then
    return
  end
  if self.appearanceId == appearanceId then
    return
  end
  if self.prevWeaponRequest or self.afterWeaponRequest then
    self:RemoveReplaceEffectModels()
  end
  self:RemoveWeapon()
  self.appearanceId = appearanceId
  self:ReloadScene(function(ret)
    if not ret then
      return
    end
    self:ReloadWeapon(self.appearanceId, function(ret2)
      if self.weaponLoadCallback then
        self.weaponLoadCallback()
      end
    end)
  end)
  self:HideEffect()
end

local function ReloadScene(self, callback)
  if self.sceneRequest ~= nil and not IsNull(self.sceneRequest.gameObject) then
    local camera = self.sceneCamera
    self:OnRenderTexture(camera)
    self.sceneRequest.gameObject:SetActive(true)
    if callback ~= nil then
      callback(true)
    end
    return
  end
  if self.sceneRequest ~= nil then
    return
  end
  local scenePath = HeroUtils.DisplayTacticalWeaponScenePath
  Logger.Log("#RecruitScene# HeroModelViewer  heroScenePreviewPath", scenePath)
  local request = ResourceManager:InstantiateAsync(scenePath)
  self.sceneRequest = request
  request:completed("+", function()
    if request.isError then
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
    self.upgradeEffect = request.gameObject.transform:Find("UpgradeEffect")
    self.sceneRequest = request
    self.sceneCamera = camera
    self:ToggleSceneCamera(true)
    if callback ~= nil then
      callback(true)
    end
  end)
end

local function ReloadWeapon(self, appearanceId, callback)
  if appearanceId == nil then
    if callback ~= nil then
      callback(false)
    end
    return
  end
  local modelPath = ""
  local appearanceTemplate = DataCenter.AppearanceTemplateManager:GetTemplate(appearanceId)
  if appearanceTemplate ~= nil then
    modelPath = appearanceTemplate.heroimg_model
  end
  local request = ResourceManager:InstantiateAsync(modelPath)
  self.weaponRequest = request
  request:completed("+", function()
    if request.isError then
      Logger.LogError("#RecruitScene# ModelViewer ReloadWeapon Error! modelPath:" .. modelPath .. ", Error:" .. request.error)
      if callback ~= nil then
        callback(false)
      end
      return
    end
    local currentScene = self.sceneRequest
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
    self.weaponModel = go_rt
    local anim = go_rt:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    self.weaponSimpleAnim = anim
    if anim then
      anim:Play("idle")
    end
    if callback ~= nil then
      callback(true)
    end
  end)
end

local function RemoveWeapon(self)
  self.weaponModel = nil
  self.weaponSimpleAnim = nil
  if self.playIdleTimer then
    self.playIdleTimer:Stop()
    self.playIdleTimer = nil
  end
  if self.weaponRequest ~= nil then
    if not IsNull(self.weaponRequest.transform) then
      self.weaponRequest.transform:DOKill()
    end
    self.weaponRequest:Destroy()
    self.weaponRequest = nil
  end
  self.appearanceId = nil
end

local function OnRenderTexture(self, camera)
  if camera == nil then
    Logger.LogError("#zlh# OnRenderTexture camera is nil!")
    return
  end
  if self.renderTexture == nil then
    local rtWidth = self.rtWidth
    local rtHeight = self.rtHeight
    local rtFormat = RenderTextureFormat.ARGB32
    self.renderTexture = RenderTexture.GetTemporary(rtWidth, rtHeight, 24, rtFormat)
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
  local model = self.weaponModel
  if model ~= nil then
    local y = model.transform.rotation.eulerAngles.y + offset
    model.transform.rotation = Quaternion.Euler(0, y, 0)
  end
end

local function OnBeginDrag(self, eventData)
  if not self.enableTouch then
    return
  end
  self.lastDragPosX = eventData.position.x
  if self.beginDragListener ~= nil then
    self.beginDragListener()
  end
  self.dragging = true
end

local function OnDrag(self, eventData)
  if not self.enableTouch then
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
  if not self.enableTouch then
    return
  end
  if self.endDragListener ~= nil then
    self.endDragListener()
  end
  self.dragging = false
end

local function OnPointerDown(self, eventData)
end

local function OnPointerUp(self, eventData)
  if self.dragging then
    return
  end
end

local clickAnimName = "click"

local function OnPointerClick(self, eventData)
  if self.dragging then
    return
  end
  local anim = self.weaponSimpleAnim
  if not IsNull(anim) then
    local animClip = anim:GetState(clickAnimName)
    if animClip == nil then
      return
    end
    anim:SampleAnimationAtTime(clickAnimName, 0)
    anim:Play(clickAnimName)
    local animTime = anim:GetClipLength(clickAnimName)
    if self.playIdleTimer ~= nil then
      self.playIdleTimer:Stop()
      self.playIdleTimer = nil
    end
    self.playIdleTimer = TimerManager:GetInstance():DelayInvoke(function()
      if not IsNull(anim) then
        anim:Play("idle")
      end
      self.playClickModelId = nil
    end, animTime)
    self.playClickModelId = self.appearanceId
  end
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
    local v3 = TacticalWeaponSimpleModelViewer.CampCameraPosTable + self.cameraOffset
    self.sceneCamera.transform:Set_localPosition(v3.x, v3.y, v3.z)
  end
end

local function Update(self)
end

local function SetWeaponLoadCallback(self, callback)
  self.weaponLoadCallback = callback
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
  if self.sceneRequest ~= nil and not IsNull(self.sceneRequest.gameObject) then
    self.sceneRequest.gameObject:SetActive(t)
  end
end

local function EnableTouch(self, enable)
  if not self.event_trigger then
    return
  end
  self.enableTouch = enable
end

local function ResetRotation(self)
  self:StopRotateModel()
  local model = self.weaponModel
  if model ~= nil then
    local curRotation = model.transform.rotation
    if curRotation ~= Quaternion.identity then
      model.transform:DOLocalRotate(Vector3.zero, 0.4)
    end
  end
end

local function HideEffect(self)
  if not IsNull(self.upgradeEffect) then
    self.upgradeEffect.gameObject:SetActive(false)
  end
end

local function PlayEffect(self)
  if not IsNull(self.upgradeEffect) then
    self.upgradeEffect.gameObject:SetActive(false)
    self.upgradeEffect.gameObject:SetActive(true)
  end
end

local function PlayModelReplaceEffect(self, prevAppearanceId, afterAppearanceId, callback, uiEffectObjA, uiEffectObjB)
  if not prevAppearanceId or not afterAppearanceId then
    return
  end
  if self.prevAppearanceId == prevAppearanceId and self.afterAppearanceId == afterAppearanceId then
    return
  else
    self:RemoveReplaceEffectModels()
  end
  self.replaceEffectWaitTime = 0
  if self.weaponRequest then
    if self.appearanceId ~= prevAppearanceId then
      self.replaceEffectWaitTime = 1.2
    end
    self:RemoveWeapon()
  end
  self.prevAppearanceId = prevAppearanceId
  self.afterAppearanceId = afterAppearanceId
  if self.prevWeaponRequest then
    return
  end
  local prevWeaponPath = ""
  local appearanceTemplate = DataCenter.AppearanceTemplateManager:GetTemplate(prevAppearanceId)
  if appearanceTemplate ~= nil then
    prevWeaponPath = appearanceTemplate.heroimg_model
  end
  local afterWeaponPath = ""
  appearanceTemplate = DataCenter.AppearanceTemplateManager:GetTemplate(afterAppearanceId)
  if appearanceTemplate ~= nil then
    afterWeaponPath = appearanceTemplate.heroimg_model
  end
  self.prevWeaponRequest = ResourceManager:InstantiateAsync(prevWeaponPath)
  self.afterWeaponRequest = ResourceManager:InstantiateAsync(afterWeaponPath)
  self.prevWeaponRequest:completed("+", function()
    if not self.prevWeaponRequest then
      return
    end
    if IsNull(self.prevWeaponRequest.gameObject) then
      return
    end
    local currentScene = self.sceneRequest
    local go_rt = self.prevWeaponRequest.gameObject.transform
    local spawnPoint = self.heroSlot
    if IsNull(spawnPoint) then
      spawnPoint = currentScene.gameObject.transform
      return
    end
    self.prevWeaponRequest.gameObject:SetActive(true)
    go_rt:SetParent(spawnPoint)
    go_rt:Set_localPosition(0, 0, 0)
    go_rt:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go_rt.localRotation = Quaternion.identity
    self.prevWeaponModel = go_rt
    local anim = go_rt:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    if anim then
      anim:Play("idle")
    end
    self.prevWeaponRequest.gameObject:SetActive(false)
    self:StartPlayReplaceEffect()
  end)
  self.afterWeaponRequest:completed("+", function()
    if not self.afterWeaponRequest then
      return
    end
    if IsNull(self.afterWeaponRequest.gameObject) then
      return
    end
    local currentScene = self.sceneRequest
    local go_rt = self.afterWeaponRequest.gameObject.transform
    local spawnPoint = self.heroSlot
    if IsNull(spawnPoint) then
      spawnPoint = currentScene.gameObject.transform
      return
    end
    self.afterWeaponRequest.gameObject:SetActive(true)
    go_rt:SetParent(spawnPoint)
    go_rt:Set_localPosition(0, 0, 0)
    go_rt:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go_rt.localRotation = Quaternion.identity
    self.afterWeaponModel = go_rt
    local anim = go_rt:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    if anim then
      anim:Play("idle")
    end
    self.afterWeaponRequest.gameObject:SetActive(false)
    self:StartPlayReplaceEffect()
  end)
  self.uiEffectObjA = uiEffectObjA
  self.uiEffectObjB = uiEffectObjB
  self.replaceEffectCallback = callback
end

local function StartPlayReplaceEffect(self)
  if not self.prevWeaponModel or not self.afterWeaponModel then
    return
  end
  if self.replaceEffectSeq then
    self.replaceEffectSeq:Kill()
    self.replaceEffectSeq = nil
  end
  if self.uiEffectObjA then
    self.uiEffectObjA:SetActive(false)
  end
  if self.uiEffectObjB then
    self.uiEffectObjB:SetActive(false)
  end
  self.replaceEffectSeq = CS.DG.Tweening.DOTween.Sequence()
  local time = 0
  if 0 < self.replaceEffectWaitTime then
    self.replaceEffectSeq:AppendCallback(function()
      if self.prevWeaponModel then
        self.prevWeaponModel.gameObject:SetActive(true)
      end
      if self.afterWeaponModel then
        self.afterWeaponModel.gameObject:SetActive(false)
      end
    end)
    self.replaceEffectSeq:AppendInterval(self.replaceEffectWaitTime)
    time = self.replaceEffectWaitTime
  end
  self.replaceEffectSeq:AppendCallback(function()
    if self.prevWeaponModel then
      self.prevWeaponModel.gameObject:SetActive(false)
    end
    if self.afterWeaponModel then
      self.afterWeaponModel.gameObject:SetActive(true)
      self.afterWeaponModel.localScale = Vector3.zero
    end
    if self.uiEffectObjA then
      self.uiEffectObjA:SetActive(false)
      self.uiEffectObjA:SetActive(true)
    end
    if self.uiEffectObjB then
      self.uiEffectObjB:SetActive(false)
      self.uiEffectObjB:SetActive(true)
    end
  end)
  self.replaceEffectSeq:AppendInterval(1.8)
  self.replaceEffectSeq:Insert(time, self.afterWeaponModel:DOScale(Vector3.New(1.13, 1.13, 1.13), 0.2))
  time = time + 0.2
  self.replaceEffectSeq:Insert(time, self.afterWeaponModel:DOScale(Vector3.one, 0.25))
  self.replaceEffectSeq:OnComplete(function()
    self.weaponRequest = self.afterWeaponRequest
    self.weaponModel = self.afterWeaponModel
    self.weaponSimpleAnim = self.afterWeaponModel:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    self.appearanceId = self.afterAppearanceId
    self.afterAppearanceId = nil
    self.afterWeaponRequest = nil
    self.afterWeaponModel = nil
    self.prevAppearanceId = nil
    if self.prevWeaponRequest then
      self.prevWeaponRequest:Destroy()
      self.prevWeaponRequest = nil
    end
    self.prevWeaponModel = nil
    if self.uiEffectObjA then
      self.uiEffectObjA:SetActive(false)
    end
    if self.uiEffectObjB then
      self.uiEffectObjB:SetActive(false)
    end
    if self.replaceEffectCallback then
      self.replaceEffectCallback()
    end
    self.replaceEffectCallback = nil
  end)
  self.replaceEffectSeq:OnKill(function()
    if self.replaceEffectCallback then
      self.replaceEffectCallback()
    end
    if self.uiEffectObjA then
      self.uiEffectObjA:SetActive(false)
    end
    if self.uiEffectObjB then
      self.uiEffectObjB:SetActive(false)
    end
  end)
end

local function RemoveReplaceEffectModels(self)
  if self.replaceEffectSeq then
    self.replaceEffectSeq:Kill()
    self.replaceEffectSeq = nil
  end
  if self.prevWeaponRequest then
    self.prevWeaponRequest:Destroy()
    self.prevWeaponRequest = nil
  end
  if self.afterWeaponRequest then
    self.afterWeaponRequest:RealDestroy()
    self.afterWeaponRequest = nil
  end
  self.prevWeaponModel = nil
  self.afterWeaponModel = nil
  self.prevAppearanceId = nil
  self.afterAppearanceId = nil
end

TacticalWeaponSimpleModelViewer.OnCreate = OnCreate
TacticalWeaponSimpleModelViewer.OnDestroy = OnDestroy
TacticalWeaponSimpleModelViewer.OnEnable = OnEnable
TacticalWeaponSimpleModelViewer.OnDisable = OnDisable
TacticalWeaponSimpleModelViewer.ComponentDefine = ComponentDefine
TacticalWeaponSimpleModelViewer.ComponentDestroy = ComponentDestroy
TacticalWeaponSimpleModelViewer.ShowEmptyScene = ShowEmptyScene
TacticalWeaponSimpleModelViewer.SetModelPath = SetModelPath
TacticalWeaponSimpleModelViewer.ReloadScene = ReloadScene
TacticalWeaponSimpleModelViewer.ReloadWeapon = ReloadWeapon
TacticalWeaponSimpleModelViewer.RemoveWeapon = RemoveWeapon
TacticalWeaponSimpleModelViewer.Rotate = Rotate
TacticalWeaponSimpleModelViewer.OnRenderTexture = OnRenderTexture
TacticalWeaponSimpleModelViewer.ReleaseTexture = ReleaseTexture
TacticalWeaponSimpleModelViewer.OnBeginDrag = OnBeginDrag
TacticalWeaponSimpleModelViewer.OnDrag = OnDrag
TacticalWeaponSimpleModelViewer.OnEndDrag = OnEndDrag
TacticalWeaponSimpleModelViewer.OnPointerDown = OnPointerDown
TacticalWeaponSimpleModelViewer.OnPointerUp = OnPointerUp
TacticalWeaponSimpleModelViewer.ToggleSceneCamera = ToggleSceneCamera
TacticalWeaponSimpleModelViewer.StartRotateModel = StartRotateModel
TacticalWeaponSimpleModelViewer.StopRotateModel = StopRotateModel
TacticalWeaponSimpleModelViewer.SetCameraOffset = SetCameraOffset
TacticalWeaponSimpleModelViewer.Update = Update
TacticalWeaponSimpleModelViewer.SetWeaponLoadCallback = SetWeaponLoadCallback
TacticalWeaponSimpleModelViewer.SetBeginDragListener = SetBeginDragListener
TacticalWeaponSimpleModelViewer.SetEndDragListener = SetEndDragListener
TacticalWeaponSimpleModelViewer.SetDefaultScenePos = SetDefaultScenePos
TacticalWeaponSimpleModelViewer.SetLensShift = SetLensShift
TacticalWeaponSimpleModelViewer.SetQuality = SetQuality
TacticalWeaponSimpleModelViewer.ChangeToPreview = ChangeToPreview
TacticalWeaponSimpleModelViewer.DoCameraAttrAni = DoCameraAttrAni
TacticalWeaponSimpleModelViewer.FindTagRecursively = FindTagRecursively
TacticalWeaponSimpleModelViewer.EnableWorldCamera = EnableWorldCamera
TacticalWeaponSimpleModelViewer.DisableWorldCamera = DisableWorldCamera
TacticalWeaponSimpleModelViewer.ToggleSceneVisible = ToggleSceneVisible
TacticalWeaponSimpleModelViewer.SetRTSize = SetRTSize
TacticalWeaponSimpleModelViewer.CampCameraPosTable = 7777
TacticalWeaponSimpleModelViewer.EnableTouch = EnableTouch
TacticalWeaponSimpleModelViewer.ResetRotation = ResetRotation
TacticalWeaponSimpleModelViewer.HideEffect = HideEffect
TacticalWeaponSimpleModelViewer.PlayEffect = PlayEffect
TacticalWeaponSimpleModelViewer.OnPointerClick = OnPointerClick
TacticalWeaponSimpleModelViewer.PlayModelReplaceEffect = PlayModelReplaceEffect
TacticalWeaponSimpleModelViewer.RemoveReplaceEffectModels = RemoveReplaceEffectModels
TacticalWeaponSimpleModelViewer.StartPlayReplaceEffect = StartPlayReplaceEffect
return TacticalWeaponSimpleModelViewer
