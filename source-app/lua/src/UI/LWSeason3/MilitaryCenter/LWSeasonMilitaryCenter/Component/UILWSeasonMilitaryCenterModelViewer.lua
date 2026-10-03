local UILWSeasonMilitaryCenterModelViewer = BaseClass("UILWSeasonMilitaryCenterModelViewer", UIBaseContainer)
local base = UIBaseContainer
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local ResourceManager = CS.GameEntry.Resource
local Camera = CS.UnityEngine.Camera
local SimpleAnimation = typeof(CS.SimpleAnimation)
UILWSeasonMilitaryCenterModelViewer.CampCameraPosTable = 9999
local a_build_qianyidian02_path = "LastWar_Scene_shamo_s3/shamo_s/jianzhu/A_build_Qianyidian02"
local a_build_shaota_path = "LastWar_Scene_shamo_s3/shamo_s/jianzhu/A_build_Shaota"
local a_build_shibei_path = "LastWar_Scene_shamo_s3/shamo_s/jianzhu/A_build_Shibei"
local a_build_junxieku_path = "LastWar_Scene_shamo_s3/shamo_s/jianzhu/A_build_Junxieku"
local a_build_cangku_path = "LastWar_Scene_shamo_s3/shamo_s/jianzhu/A_build_Cangku"
local o_build_ground_01_path = "LastWar_Scene_shamo_s3/shamo_s/dimian/O_build_Ground_01"
local o_build_ground_02_path = "LastWar_Scene_shamo_s3/shamo_s/dimian/O_build_Ground_02"

function UILWSeasonMilitaryCenterModelViewer:OnCreate()
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

function UILWSeasonMilitaryCenterModelViewer:OnDestroy()
  self:ReleaseTexture()
  if self.sceneLoading ~= nil then
    self.sceneLoading:Destroy()
  end
  if self.sceneLoaded ~= nil then
    self.sceneLoaded:Destroy()
  end
  self._build_base = nil
  self._build_1 = nil
  self._build_2 = nil
  self._build_3 = nil
  self._build_4 = nil
  self.sceneLoaded = nil
  self.sceneLoading = nil
  self.sceneCamera = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMilitaryCenterModelViewer:OnEnable()
  base.OnEnable(self)
  if self.sceneLoaded ~= nil then
    self.sceneLoaded.gameObject:SetActive(true)
  end
end

function UILWSeasonMilitaryCenterModelViewer:OnDisable()
  if self.sceneLoaded ~= nil then
    self.sceneLoaded.gameObject:SetActive(false)
  end
  base.OnDisable(self)
end

function UILWSeasonMilitaryCenterModelViewer:ComponentDefine()
  self.rawImage = self:AddComponent(UIRawImage, "")
  self.rawImage:SetEnable(false)
end

function UILWSeasonMilitaryCenterModelViewer:ComponentDestroy()
  self.camera = nil
  self.simpleAnimation = nil
  self.build_ground_shamo = nil
  self.build_ground_caodi = nil
end

function UILWSeasonMilitaryCenterModelViewer:ReloadScene(bgNode)
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
  local scenePath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/UIMilitaryCenter/DisplaySeasonMilitaryCenter.prefab"
  local request = ResourceManager:InstantiateAsync(scenePath)
  self.sceneLoading = request
  request:completed("+", function()
    if request.isError then
      self.sceneLoading = nil
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go.transform:Set_position(self.defaultScenePos.x, self.defaultScenePos.y, self.defaultScenePos.z)
    local camera_path = "LastWar_Scene_shamo_s3/Camera01"
    local camera = go.transform:Find(camera_path):GetComponentInChildren(typeof(Camera))
    local isMilitaryCenterGreen = DataCenter.AllianceMineManager.isMilitaryCenterGreen
    self.build_ground_shamo = go.transform:Find(o_build_ground_01_path)
    self.build_ground_caodi = go.transform:Find(o_build_ground_02_path)
    self._build_base = go.transform:Find(a_build_qianyidian02_path)
    self._build_2 = go.transform:Find(a_build_shaota_path)
    self._build_4 = go.transform:Find(a_build_shibei_path)
    self._build_1 = go.transform:Find(a_build_junxieku_path)
    self._build_3 = go.transform:Find(a_build_cangku_path)
    self.build_ground_shamo.gameObject:SetActive(not isMilitaryCenterGreen)
    self.build_ground_caodi.gameObject:SetActive(isMilitaryCenterGreen)
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
    self:UpdateStatus(nil)
  end)
end

function UILWSeasonMilitaryCenterModelViewer:OnRenderTexture(camera)
  if camera == nil then
    return false
  end
  if self.renderTexture == nil then
    local rtWidth = self.rtWidth
    local rtHeight = self.rtHeight
    local rtFormat = RenderTextureFormat.ARGB32
    self.renderTexture = RenderTexture.GetTemporary(rtWidth, rtHeight, 24, rtFormat)
    self.renderTexture.name = "MilitaryCenter"
    self.rawImage:SetTexture(self.renderTexture)
    self.rawImage:SetEnable(true)
    self.rawImage:SetColor(Color.New(1, 1, 1, 1))
  end
  camera.targetTexture = self.renderTexture
  return true
end

function UILWSeasonMilitaryCenterModelViewer:ReleaseTexture()
  self.rawImage:SetTexture(nil)
  if self.sceneCamera ~= nil then
    self.sceneCamera.targetTexture = nil
  end
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
end

function UILWSeasonMilitaryCenterModelViewer:SetCameraOffset(vector3Offset)
  self.cameraOffset = vector3Offset
  if self.sceneCamera then
    local v3 = UILWSeasonMilitaryCenterModelViewer.CampCameraPosTable + self.cameraOffset
    self.sceneCamera.transform:Set_localPosition(v3.x, v3.y, v3.z)
  end
end

function UILWSeasonMilitaryCenterModelViewer:SetDefaultScenePos(defaultPos)
  self.defaultScenePos = defaultPos
end

function UILWSeasonMilitaryCenterModelViewer:ChangeToPreview()
  local camera = self.sceneCamera
  local duration = 0.2
  self:DoCameraAttrAni(camera, "lensShift", Vector2.New(0, 0), duration)
  self:DoCameraAttrAni(camera, "focalLength", 21, duration)
end

function UILWSeasonMilitaryCenterModelViewer:DoCameraAttrAni(camera, attr, endValue, duration)
  function UILWSeasonMilitaryCenterModelViewer:Getter()
    return camera[attr]
  end
  
  function UILWSeasonMilitaryCenterModelViewer:Setter(x)
    camera[attr] = x
  end
  
  DOTween.To(Getter, Setter, endValue, duration):SetEase(CS.DG.Tweening.Ease.InOutCubic)
end

function UILWSeasonMilitaryCenterModelViewer:ToggleSceneVisible(t)
  if self.sceneLoaded then
    self.sceneLoaded.gameObject:SetActive(t)
  end
end

function UILWSeasonMilitaryCenterModelViewer:Play(name)
  if self.simpleAnimation then
    if self.simpleAnimation:IsPlaying(name) then
      self.simpleAnimation:Rewind(name)
    else
      self.simpleAnimation:Play(name)
    end
  end
end

function UILWSeasonMilitaryCenterModelViewer:Stop()
  self:Play("Default")
end

function UILWSeasonMilitaryCenterModelViewer:UpdateStatus(active_building_list)
  if active_building_list then
    self.active_building_list = active_building_list
  end
  if self.active_building_list and self._build_base and GameObjectIsValid(self._build_base.gameObject) then
    local theStoveCenter = DataCenter.AllianceMineManager:GetAllianceStoveCenter()
    if theStoveCenter == nil or theStoveCenter.status == AllianceMineStatus.Build then
      self._build_1.gameObject:SetActive(false)
      self._build_2.gameObject:SetActive(false)
      self._build_3.gameObject:SetActive(false)
      self._build_4.gameObject:SetActive(false)
      self._build_base.gameObject:SetActive(true)
      return
    end
    local shown = {
      false,
      false,
      false,
      false
    }
    local theAttachmentList = DataCenter.AllianceMineManager:GetAllianceCenterAttachmentList()
    if theAttachmentList ~= nil then
      for index, meta in ipairs(self.active_building_list) do
        local buildId = toInt(meta.active_building_id)
        for _, theBuild in pairs(theAttachmentList) do
          if theBuild.buildId == buildId or theBuild.buildId + theBuild.level == buildId then
            shown[index] = true
          end
        end
      end
    end
    self._build_1.gameObject:SetActive(shown[1])
    self._build_2.gameObject:SetActive(shown[2])
    self._build_3.gameObject:SetActive(shown[3])
    self._build_4.gameObject:SetActive(shown[4])
    self._build_base.gameObject:SetActive(true)
  end
end

return UILWSeasonMilitaryCenterModelViewer
