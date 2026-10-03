local base = UIBaseContainer
local UILWDominatorMainModelSceneViewer = BaseClass("UILWDominatorMainModelSceneViewer", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local ResourceManager = CS.GameEntry.Resource
local Camera = CS.UnityEngine.Camera
local Screen = CS.UnityEngine.Screen
UILWDominatorMainModelSceneViewer.defaultScenePos = Vector3.New(-500, 0, -500)
UILWDominatorMainModelSceneViewer.rtWidth = 810
UILWDominatorMainModelSceneViewer.rtHeight = 1440
UILWDominatorMainModelSceneViewer.sceneAssetPath = "Assets/Main/CoditionLoadRes/Dominator/Common/Prefabs/MainScene/DominatorMainScene_1.prefab"
UILWDominatorMainModelSceneViewer.clickAnimName = "click"
UILWDominatorMainModelSceneViewer.CampCameraPosTable = 7777
UILWDominatorMainModelSceneViewer.RotationRatio = 0.5
UILWDominatorMainModelSceneViewer.EmoAnimNames = {
  "emo01",
  "emo02",
  "emo03"
}
UILWDominatorMainModelSceneViewer.DefaultRotation = {
  [DominatorId.Gorilla] = Vector3.New(0, -10.191, 0),
  [DominatorId.Cockatrice] = Vector3.New(0, -10.191, 0)
}

function UILWDominatorMainModelSceneViewer:OnCreate(enableTouch, onDragCallBack)
  base.OnCreate(self)
  self:ComponentDefine(enableTouch)
  self:DataDefine(onDragCallBack)
  self:OnOpen()
end

function UILWDominatorMainModelSceneViewer:OnDestroy()
  self:OnClose()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorMainModelSceneViewer:ComponentDefine(enableTouch)
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

function UILWDominatorMainModelSceneViewer:ComponentDestroy()
  self.event_trigger = nil
  self.camera = nil
  self:ReleaseModel()
  self:ReleaseScene()
end

function UILWDominatorMainModelSceneViewer:DataDefine(onDragCallBack)
  self.sceneRequest = nil
  self.sceneCamera = nil
  self.sceneAnim = nil
  self.model = nil
  self.modelAnim = nil
  self.modelLoadCallback = nil
  self.onDragCallBack = onDragCallBack
  self.isModelLoaded = false
  self.animClipData = {}
end

function UILWDominatorMainModelSceneViewer:DataDestroy()
  self.sceneCamera = nil
  self.sceneAnim = nil
  self.model = nil
  self.modelAnim = nil
  self.modelLoadCallback = nil
  self.onDragCallBack = nil
  self.isModelLoaded = nil
  self.animClipData = nil
end

function UILWDominatorMainModelSceneViewer:OnEnable()
  base.OnEnable(self)
  self.isDragging = false
  self:SetSceneActive(true)
  DataCenter.CityLightManager:AddDeactiveRef()
end

function UILWDominatorMainModelSceneViewer:OnDisable()
  DataCenter.CityLightManager:DecreaseDeactiveRef()
  self:SetSceneActive(false)
  base.OnDisable(self)
end

function UILWDominatorMainModelSceneViewer:SetSceneActive(isActive)
  if self.sceneRequest ~= nil and not IsNull(self.sceneRequest.gameObject) then
    self.sceneRequest.gameObject:SetActive(isActive)
  end
end

function UILWDominatorMainModelSceneViewer:OnOpen()
  self.rawImage:SetEnable(false)
end

function UILWDominatorMainModelSceneViewer:OnClose()
  self:ReleaseTexture()
end

function UILWDominatorMainModelSceneViewer:SetRTSize(width, height)
  self.rtWidth = width
  self.rtHeight = height
end

function UILWDominatorMainModelSceneViewer:ReleaseTexture()
  self.rawImage:SetTexture(nil)
  if self.sceneCamera ~= nil then
    self.sceneCamera.targetTexture = nil
  end
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
end

function UILWDominatorMainModelSceneViewer:SetModel(modelAppearanceId, loadCallback, dominatorId)
  local modelAppearanceTemplate = DataCenter.AppearanceTemplateManager:GetTemplate(modelAppearanceId)
  if modelAppearanceTemplate == nil then
    DataCenter.DominatorManager:PrintRealErrorLog("appearance template not found, id: " .. tostring(modelAppearanceId))
    if loadCallback then
      loadCallback(false, false)
    end
    return
  end
  if self.modelAppearanceTemplate ~= nil and self.modelAppearanceTemplate.id == modelAppearanceTemplate.id then
    if loadCallback then
      loadCallback(true, false)
    end
    return
  end
  self:ReleaseModel()
  self.modelAppearanceTemplate = modelAppearanceTemplate
  self:ReloadScene(function(isSuccess)
    if not isSuccess then
      return
    end
    if self.modelAppearanceTemplate == nil then
      DataCenter.DominatorManager:PrintRealErrorLog("appearance template nil when load model")
      return
    end
    self:ReloadModel(function(isSuccessModel)
      if loadCallback then
        loadCallback(isSuccessModel, true)
      end
    end, dominatorId)
  end)
end

function UILWDominatorMainModelSceneViewer:ReleaseScene()
  if self.sceneRequest ~= nil then
    self.sceneRequest:Destroy()
  end
  self.sceneRequest = nil
end

function UILWDominatorMainModelSceneViewer:ReleaseModel()
  self.model = nil
  self.modelAnim = nil
  if self.modelRequest ~= nil then
    if not IsNull(self.modelRequest.gameObject) then
      self.modelRequest.gameObject.transform:DOKill()
    end
    self.modelRequest:Destroy()
    self.modelRequest = nil
  end
  self.modelAppearanceTemplate = nil
  self.isModelLoaded = false
end

function UILWDominatorMainModelSceneViewer:ReloadScene(loadCallback, dominatorId)
  if self.sceneRequest ~= nil then
    if not IsNull(self.sceneRequest.gameObject) then
      self:SetRenderTexture(self.sceneCamera)
      self.sceneRequest.gameObject:SetActive(true)
      self:ResetHeroSlotRotation(dominatorId)
      if loadCallback ~= nil then
        loadCallback(true)
      else
      end
    end
    return
  end
  local request = ResourceManager:InstantiateAsync(self.sceneAssetPath)
  self.sceneRequest = request
  self.sceneRequest:completed("+", function()
    if request.isError then
      if loadCallback ~= nil then
        loadCallback(false)
      end
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    request.gameObject.transform:Set_position(self.defaultScenePos.x, self.defaultScenePos.y, self.defaultScenePos.z)
    self.sceneObj = request.gameObject
    local cameraTrans = request.gameObject.transform:Find("Camera")
    if not IsNull(cameraTrans) then
      local camera = cameraTrans:GetComponentInChildren(typeof(Camera))
      self.sceneCamera = camera
    end
    local sceneAnim = request.gameObject:GetComponent(typeof(CS.SimpleAnimation))
    if not IsNull(sceneAnim) then
      self.sceneAnim = sceneAnim
    end
    self.heroSlot = request.gameObject.transform:Find("HeroSlot")
    self.upgradeEffect = request.gameObject.transform:Find("UpgradeEffect")
    self:ResetHeroSlotRotation(dominatorId)
    self:SetSceneCameraActive(true)
    if loadCallback ~= nil then
      loadCallback(true)
    end
  end)
end

function UILWDominatorMainModelSceneViewer:ReloadModel(loadCallback)
  if self.modelAppearanceTemplate == nil then
    DataCenter.DominatorManager:PrintRealErrorLog("appearance template nil when load model")
    if loadCallback then
      loadCallback(false)
    end
    return
  end
  local modelPath = self.modelAppearanceTemplate.heroimg_model
  if string.IsNullOrEmpty(modelPath) then
    DataCenter.DominatorManager:PrintRealErrorLog("appearance template heroimg_model nil when load model")
    if loadCallback then
      loadCallback(false)
    end
    return
  end
  local request = ResourceManager:InstantiateAsync(modelPath)
  self.modelRequest = request
  request:completed("+", function()
    if request.isError then
      DataCenter.DominatorManager:PrintRealErrorLog("appearance template model load error , " .. modelPath .. ", Error:" .. request.error)
      if loadCallback then
        loadCallback(false)
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
    self.model = go_rt
    local anim = go_rt:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    self.modelAnim = anim
    local defaultAnim = self.playModelAnimCache or "idle"
    self:PlayModelAnim(defaultAnim)
    self.playModelAnimCache = nil
    self:UpdateEmoModelAnimClipData()
    if loadCallback then
      loadCallback(true)
    end
    self.isModelLoaded = true
  end)
end

function UILWDominatorMainModelSceneViewer:SetSceneCameraActive(isActive)
  local sceneCamera = self.sceneCamera
  if sceneCamera ~= nil then
    sceneCamera.gameObject:SetActive(isActive)
    if isActive then
      self:SetRenderTexture(sceneCamera)
    else
      sceneCamera.targetTexture = nil
    end
  end
end

function UILWDominatorMainModelSceneViewer:SetRenderTexture(camera)
  if camera == nil then
    DataCenter.DominatorManager:PrintRealErrorLog("model camera is null")
    return
  end
  if self.renderTexture == nil then
    local rtWidth = self.rtWidth
    local rtHeight = self.rtHeight
    local rtFormat = RenderTextureFormat.ARGB32
    self.renderTexture = RenderTexture.GetTemporary(rtWidth, rtHeight, 24, rtFormat)
    self.renderTexture.name = "DominatorSimpleShow" .. rtWidth .. "*" .. rtHeight
    self.rawImage:SetTexture(self.renderTexture)
    self.rawImage:SetEnable(true)
    self.rawImage:SetColor(Color.New(1, 1, 1, 1))
  end
  camera.targetTexture = self.renderTexture
end

function UILWDominatorMainModelSceneViewer:OnBeginDrag(eventData)
  if not self.enableTouch then
    return
  end
  self.lastDragPosX = eventData.position.x
  self.dragging = true
end

function UILWDominatorMainModelSceneViewer:OnDrag(eventData)
  if not self.enableTouch then
    return
  end
  local currentPosX = eventData.position.x
  if currentPosX > Screen.width then
    return
  end
  if self.lastDragPosX then
    local offset = (self.lastDragPosX - currentPosX) * self.RotationRatio
    self.lastDragPosX = currentPosX
    self:Rotate(offset)
  end
end

function UILWDominatorMainModelSceneViewer:OnEndDrag(eventData)
  if not self.enableTouch then
    return
  end
  self.dragging = false
end

function UILWDominatorMainModelSceneViewer:OnPointerDown(eventData)
end

function UILWDominatorMainModelSceneViewer:OnPointerUp(eventData)
  if self.dragging then
    return
  end
end

function UILWDominatorMainModelSceneViewer:OnPointerClick(eventData)
  if self.dragging then
    return
  end
  local anim = self.modelAnim
  if not IsNull(anim) then
    local animClip = anim:GetState(self.clickAnimName)
    if animClip == nil then
      return
    end
    anim:SampleAnimationAtTime(self.clickAnimName, 0)
    anim:Play(self.clickAnimName)
  end
end

function UILWDominatorMainModelSceneViewer:IsPlayingModelAnim(anim)
  if not IsNull(self.modelAnim) then
    return self.modelAnim:IsPlaying(anim)
  end
  return false
end

function UILWDominatorMainModelSceneViewer:PlaySceneAnim(anim)
  if not IsNull(self.sceneAnim) then
    self.sceneAnim:Play(anim)
  end
end

function UILWDominatorMainModelSceneViewer:PlayModelAnim(anim, fadeTime)
  if not IsNull(self.modelAnim) then
    if fadeTime == nil or fadeTime <= 0 then
      return self.modelAnim:Play(anim)
    else
      return self.modelAnim:CrossFade(anim, fadeTime)
    end
  else
    self.playModelAnimCache = anim
  end
end

function UILWDominatorMainModelSceneViewer:QueuePlayModelAnim(anim, fadeTime)
  if not IsNull(self.modelAnim) then
    if fadeTime == nil or fadeTime <= 0 then
      self.modelAnim:PlayQueued(anim)
    else
      self.modelAnim:CrossFadeQueued(anim, fadeTime, CS.UnityEngine.QueueMode.CompleteOthers)
    end
  end
end

function UILWDominatorMainModelSceneViewer:SetCameraOffset(vector3Offset)
  self.cameraOffset = vector3Offset
  if self.sceneCamera then
    local v3 = self.CampCameraPosTable + self.cameraOffset
    self.sceneCamera.transform:Set_localPosition(v3.x, v3.y, v3.z)
  end
end

function UILWDominatorMainModelSceneViewer:Rotate(offset)
  local model = self.model
  if model ~= nil then
    local y = model.transform.rotation.eulerAngles.y + offset
    model.transform.rotation = Quaternion.Euler(0, y, 0)
  end
end

function UILWDominatorMainModelSceneViewer:ResetRotation()
  local model = self.model
  if model ~= nil then
    local curRotation = model.transform.rotation
    if curRotation ~= Quaternion.identity then
      model.transform:DOLocalRotate(Vector3.zero, 0.4)
    end
  end
end

function UILWDominatorMainModelSceneViewer:UpdateEmoModelAnimClipData()
  self.animClipData = {}
  if not IsNull(self.modelAnim) then
    for i, v in pairs(self.EmoAnimNames) do
      local length = self.modelAnim:GetClipLength(v)
      if 0 < length then
        local data = {name = v, length = length}
        table.insert(self.animClipData, data)
      end
    end
  end
end

function UILWDominatorMainModelSceneViewer:GetModelAnimClipLength(anim)
  if not IsNull(self.modelAnim) then
    return self.modelAnim:GetClipLength(anim)
  end
end

function UILWDominatorMainModelSceneViewer:GetEmoModelAnimClipData()
  return self.animClipData
end

function UILWDominatorMainModelSceneViewer:ResetHeroSlotRotation(dominatorId)
  local rotation = Vector3.New(0, 0, 0)
  if dominatorId and self.DefaultRotation[dominatorId] then
    rotation = self.DefaultRotation[dominatorId]
  end
  if not IsNull(self.heroSlot) then
    self.heroSlot.localRotation = Quaternion.Euler(rotation:Split())
  end
end

function UILWDominatorMainModelSceneViewer:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DominatorHideMainModelScene, self.OnHideMainScene)
  self:AddUIListener(EventId.DominatorShowMainModelScene, self.OnShowMainScene)
end

function UILWDominatorMainModelSceneViewer:OnRemoveListener()
  self:RemoveUIListener(EventId.DominatorHideMainModelScene, self.OnHideMainScene)
  self:RemoveUIListener(EventId.DominatorShowMainModelScene, self.OnShowMainScene)
  base.OnRemoveListener(self)
end

function UILWDominatorMainModelSceneViewer:OnHideMainScene()
  if IsNotNull(self.sceneObj) then
    self.sceneObj:SetActive(false)
  end
end

function UILWDominatorMainModelSceneViewer:OnShowMainScene()
  if IsNotNull(self.sceneObj) then
    self.sceneObj:SetActive(true)
  end
end

return UILWDominatorMainModelSceneViewer
