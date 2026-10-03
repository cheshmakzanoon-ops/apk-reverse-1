local UILWSeasonStoveCenterModelViewer = BaseClass("UILWSeasonStoveCenterModelViewer", UIBaseContainer)
local base = UIBaseContainer
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local ResourceManager = CS.GameEntry.Resource
local Camera = CS.UnityEngine.Camera
local SimpleAnimation = typeof(CS.SimpleAnimation)
UILWSeasonStoveCenterModelViewer.CampCameraPosTable = 9999

function UILWSeasonStoveCenterModelViewer:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.defaultScenePos = Vector3.New(-5000, 0, -5000)
  self.cameraOffset = Vector3.zero
  self.rtWidth = DefaultScreenWidth
  self.rtHeight = DefaultScreenHeight
  self.sceneLoaded = nil
  self.sceneCamera = nil
  self.sceneLoading = nil
end

function UILWSeasonStoveCenterModelViewer:OnDestroy()
  self:ReleaseTexture()
  if self.sceneLoading ~= nil then
    self.sceneLoading:Destroy()
  end
  if self.sceneLoaded ~= nil then
    self.sceneLoaded:Destroy()
  end
  self.sceneLoaded = nil
  self.sceneLoading = nil
  self.sceneCamera = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonStoveCenterModelViewer:OnEnable()
  base.OnEnable(self)
  if self.sceneLoaded ~= nil then
    self.sceneLoaded.gameObject:SetActive(true)
  end
end

function UILWSeasonStoveCenterModelViewer:OnDisable()
  if self.sceneLoaded ~= nil then
    self.sceneLoaded.gameObject:SetActive(false)
  end
  base.OnDisable(self)
end

function UILWSeasonStoveCenterModelViewer:ComponentDefine()
  self.rawImage = self:AddComponent(UIRawImage, "")
  self.rawImage:SetEnable(false)
end

function UILWSeasonStoveCenterModelViewer:ComponentDestroy()
  self.camera = nil
  self.simpleAnimation = nil
end

function UILWSeasonStoveCenterModelViewer:ReloadScene(bgNode)
  if self.sceneLoaded ~= nil then
    local camera = self.sceneCamera
    if self:OnRenderTexture(camera) then
      if bgNode and bgNode.rectTransform and not IsNull(bgNode.rectTransform) then
        bgNode:SetActive(false)
      end
      EventManager:GetInstance():Broadcast(EventId.AllianceStoveCenterUpdate)
    end
    self.sceneLoaded.gameObject:SetActive(true)
    return
  end
  if self.sceneLoading ~= nil then
    return
  end
  local scenePath = "Assets/Main/Prefabs/UI/UIHero/New/HeroPreview/DisplaySeasonStoveScene.prefab"
  local request = ResourceManager:InstantiateAsync(scenePath)
  self.sceneLoading = request
  request:completed("+", function()
    if request.isError then
      self.sceneLoading = nil
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    request.gameObject.transform:Set_position(self.defaultScenePos.x, self.defaultScenePos.y, self.defaultScenePos.z)
    local camera = request.gameObject.transform:Find("Camera"):GetComponentInChildren(typeof(Camera))
    self.heroSlot = request.gameObject.transform:Find("HeroSlot")
    self.simpleAnimation = self.heroSlot:GetComponent(SimpleAnimation)
    self.sceneLoading = nil
    self.sceneLoaded = request
    self.sceneCamera = camera
    if camera ~= nil then
      camera.gameObject:SetActive(true)
      if self:OnRenderTexture(camera) then
        if bgNode and bgNode.rectTransform and not IsNull(bgNode.rectTransform) then
          bgNode:SetActive(false)
        end
        EventManager:GetInstance():Broadcast(EventId.AllianceStoveCenterUpdate)
      end
    end
  end)
end

function UILWSeasonStoveCenterModelViewer:OnRenderTexture(camera)
  if camera == nil then
    return false
  end
  if self.renderTexture == nil then
    local rtWidth = self.rtWidth
    local rtHeight = self.rtHeight
    local rtFormat = RenderTextureFormat.ARGB32
    self.renderTexture = RenderTexture.GetTemporary(rtWidth, rtHeight, 24, rtFormat)
    self.renderTexture.name = "SeasonStoveViewer"
    self.rawImage:SetTexture(self.renderTexture)
    self.rawImage:SetEnable(true)
    self.rawImage:SetColor(Color.New(1, 1, 1, 1))
  end
  camera.targetTexture = self.renderTexture
  return true
end

function UILWSeasonStoveCenterModelViewer:ReleaseTexture()
  self.rawImage:SetTexture(nil)
  if self.sceneCamera ~= nil then
    self.sceneCamera.targetTexture = nil
  end
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
end

function UILWSeasonStoveCenterModelViewer:SetCameraOffset(vector3Offset)
  self.cameraOffset = vector3Offset
  if self.sceneCamera then
    local v3 = UILWSeasonStoveCenterModelViewer.CampCameraPosTable + self.cameraOffset
    self.sceneCamera.transform:Set_localPosition(v3.x, v3.y, v3.z)
  end
end

function UILWSeasonStoveCenterModelViewer:SetDefaultScenePos(defaultPos)
  self.defaultScenePos = defaultPos
end

function UILWSeasonStoveCenterModelViewer:ChangeToPreview()
  local camera = self.sceneCamera
  local duration = 0.2
  self:DoCameraAttrAni(camera, "lensShift", Vector2.New(0, 0), duration)
  self:DoCameraAttrAni(camera, "focalLength", 21, duration)
end

function UILWSeasonStoveCenterModelViewer:DoCameraAttrAni(camera, attr, endValue, duration)
  function UILWSeasonStoveCenterModelViewer:Getter()
    return camera[attr]
  end
  
  function UILWSeasonStoveCenterModelViewer:Setter(x)
    camera[attr] = x
  end
  
  DOTween.To(Getter, Setter, endValue, duration):SetEase(CS.DG.Tweening.Ease.InOutCubic)
end

function UILWSeasonStoveCenterModelViewer:ToggleSceneVisible(t)
  if self.sceneLoaded then
    self.sceneLoaded.gameObject:SetActive(t)
  end
end

function UILWSeasonStoveCenterModelViewer:Play(name)
  if self.simpleAnimation and self.lastAnimName ~= name then
    if self.simpleAnimation:IsPlaying(name) then
      self.simpleAnimation:Rewind(name)
    else
      self.simpleAnimation:Play(name)
    end
    self.lastAnimName = name
  end
end

function UILWSeasonStoveCenterModelViewer:Stop()
  self:Play("Default")
end

return UILWSeasonStoveCenterModelViewer
