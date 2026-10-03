local UILWSeason4MilitaryCenterModelViewer = BaseClass("UILWSeason4MilitaryCenterModelViewer", UIBaseContainer)
local base = UIBaseContainer
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local ResourceManager = CS.GameEntry.Resource
local Camera = CS.UnityEngine.Camera
UILWSeason4MilitaryCenterModelViewer.CampCameraPosTable = 9999
local a_build_build1_path = "LastWar_Scene_shamo_s4/fadian_s4/jianzhu/tongmengzhongxin_S4_fadian/tongmengzhongxin_S4_xiaofangzi1"
local a_build_build2_path = "LastWar_Scene_shamo_s4/fadian_s4/jianzhu/tongmengzhongxin_S4_fadian/tongmengzhongxin_S4_xiaofangzi2"
local a_build_build3_path = "LastWar_Scene_shamo_s4/fadian_s4/jianzhu/tongmengzhongxin_S4_fadian/tongmengzhongxin_S4_xiaofangzi3"
local a_build_build_base_path = "LastWar_Scene_shamo_s4/fadian_s4/jianzhu/tongmengzhongxin_S4_fadian/tongmengzhongxin_S4_dafangzi"
local fogPathLocked = "Assets/Main/SeasonRes/S4/Prefabs/World/FogVolume_s4_SeasonMilitaryCenterLocked.prefab"
local fogPathLocked_bloody = "Assets/Main/SeasonRes/S4/Prefabs/World/FogVolume_s4_SeasonMilitaryCenterLocked_bloody.prefab"
local fogPath = "Assets/Main/SeasonRes/S4/Prefabs/World/FogVolume_s4_SeasonMilitaryCenter.prefab"
local fogPath_bloody = "Assets/Main/SeasonRes/S4/Prefabs/World/FogVolume_s4_SeasonMilitaryCenter_bloody.prefab"
local eff_main_path = "LastWar_Scene_shamo_s4/fadian_s4/jianzhu/tongmengzhongxin_S4_fadian/tongmengzhongxin_S4_dafangzi/Eff_tongmengzhongxin_S4_dafangzi"

function UILWSeason4MilitaryCenterModelViewer:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.defaultScenePos = Vector3.New(-5000, 0, -5000)
  self.cameraOffset = Vector3.zero
  self.rtWidth = DefaultScreenWidth
  self.rtHeight = DefaultScreenHeight
  self.sceneLoaded = nil
  self.sceneCamera = nil
  self.sceneLoading = nil
  self.fogLoading = nil
  self.fogLoaded = nil
  self.fogPath = ""
  self.fogObj = nil
end

function UILWSeason4MilitaryCenterModelViewer:OnDestroy()
  self:ReleaseTexture()
  if self.sceneLoading ~= nil then
    self.sceneLoading:Destroy()
  end
  if self.sceneLoaded ~= nil then
    self.sceneLoaded:Destroy()
  end
  if self.fogLoading ~= nil then
    self.fogLoading:Destroy()
  end
  if self.fogLoaded ~= nil then
    self.fogLoaded:Destroy()
  end
  self.eff_main = nil
  self._build_base = nil
  self._build_1 = nil
  self._build_2 = nil
  self._build_3 = nil
  self.sceneLoaded = nil
  self.sceneLoading = nil
  self.sceneCamera = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeason4MilitaryCenterModelViewer:OnEnable()
  base.OnEnable(self)
  if self.sceneLoaded ~= nil then
    self.sceneLoaded.gameObject:SetActive(true)
  end
end

function UILWSeason4MilitaryCenterModelViewer:OnDisable()
  if self.sceneLoaded ~= nil then
    self.sceneLoaded.gameObject:SetActive(false)
  end
  base.OnDisable(self)
end

function UILWSeason4MilitaryCenterModelViewer:ComponentDefine()
  self.rawImage = self:AddComponent(UIRawImage, "")
  self.rawImage:SetEnable(false)
end

function UILWSeason4MilitaryCenterModelViewer:ComponentDestroy()
  self.camera = nil
  self.simpleAnimation = nil
  self.build_ground_shamo = nil
  self.build_ground_caodi = nil
end

function UILWSeason4MilitaryCenterModelViewer:ReloadScene(bgNode)
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
  local scenePath = "Assets/Main/SeasonRes/S4/Prefabs/UI/UIMilitaryCenter/DisplaySeasonMilitaryCenter.prefab"
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
    local camera_path = "LastWar_Scene_shamo_s4/Camera01"
    local camera = go.transform:Find(camera_path):GetComponentInChildren(typeof(Camera))
    self.eff_main = go.transform:Find(eff_main_path)
    self._build_base = go.transform:Find(a_build_build_base_path)
    self._build_3 = go.transform:Find(a_build_build3_path)
    self._build_2 = go.transform:Find(a_build_build2_path)
    self._build_1 = go.transform:Find(a_build_build1_path)
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

function UILWSeason4MilitaryCenterModelViewer:OnRenderTexture(camera)
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

function UILWSeason4MilitaryCenterModelViewer:ReleaseTexture()
  self.rawImage:SetTexture(nil)
  if self.sceneCamera ~= nil then
    self.sceneCamera.targetTexture = nil
  end
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
end

function UILWSeason4MilitaryCenterModelViewer:SetCameraOffset(vector3Offset)
  self.cameraOffset = vector3Offset
  if self.sceneCamera then
    local v3 = UILWSeason4MilitaryCenterModelViewer.CampCameraPosTable + self.cameraOffset
    self.sceneCamera.transform:Set_localPosition(v3.x, v3.y, v3.z)
  end
end

function UILWSeason4MilitaryCenterModelViewer:SetDefaultScenePos(defaultPos)
  self.defaultScenePos = defaultPos
end

function UILWSeason4MilitaryCenterModelViewer:ChangeToPreview()
  local camera = self.sceneCamera
  local duration = 0.2
  self:DoCameraAttrAni(camera, "lensShift", Vector2.New(0, 0), duration)
  self:DoCameraAttrAni(camera, "focalLength", 21, duration)
end

function UILWSeason4MilitaryCenterModelViewer:DoCameraAttrAni(camera, attr, endValue, duration)
  function UILWSeason4MilitaryCenterModelViewer:Getter()
    return camera[attr]
  end
  
  function UILWSeason4MilitaryCenterModelViewer:Setter(x)
    camera[attr] = x
  end
  
  DOTween.To(Getter, Setter, endValue, duration):SetEase(CS.DG.Tweening.Ease.InOutCubic)
end

function UILWSeason4MilitaryCenterModelViewer:ToggleSceneVisible(t)
  if self.sceneLoaded then
    self.sceneLoaded.gameObject:SetActive(t)
  end
end

function UILWSeason4MilitaryCenterModelViewer:Play(name)
  if self.simpleAnimation then
    if self.simpleAnimation:IsPlaying(name) then
      self.simpleAnimation:Rewind(name)
    else
      self.simpleAnimation:Play(name)
    end
  end
end

function UILWSeason4MilitaryCenterModelViewer:Stop()
  self:Play("Default")
end

function UILWSeason4MilitaryCenterModelViewer:UpdateFog(isLight, isBloody)
  local path = fogPathLocked
  if isLight and isBloody then
    path = fogPath_bloody
  elseif isLight and not isBloody then
    path = fogPath
  elseif not isLight and isBloody then
    path = fogPathLocked_bloody
  end
  if path == self.fogPath then
    return
  end
  self.fogPath = path
  local request = ResourceManager:InstantiateAsync(path)
  self.fogLoading = request
  request:completed("+", function()
    if request.isError then
      self.fogLoading = nil
      return
    end
    if self.fogObj ~= nil then
      self.fogObj:Destroy()
    end
    self.fogObj = request.gameObject
    self.fogObj:SetActive(true)
    if self.sceneLoaded ~= nil and self.sceneLoaded.gameObject ~= nil then
      self.fogObj.transform:SetParent(self.sceneLoaded.gameObject.transform)
    end
    self.fogObj.transform:Set_position(self.defaultScenePos.x, self.defaultScenePos.y, self.defaultScenePos.z)
    self.fogLoading = nil
    self.fogLoaded = request
  end)
end

function UILWSeason4MilitaryCenterModelViewer:UpdateStatus(active_building_list)
  if active_building_list then
    self.active_building_list = active_building_list
  end
  if self._build_base and GameObjectIsValid(self._build_base.gameObject) then
    local theStoveCenter = DataCenter.AllianceMineManager:GetAllianceStoveCenter()
    if theStoveCenter == nil or theStoveCenter.status == AllianceMineStatus.Build then
      self._build_1.gameObject:SetActive(false)
      self._build_2.gameObject:SetActive(false)
      self._build_3.gameObject:SetActive(false)
      if self.eff_main then
        self.eff_main.gameObject:SetActive(false)
      end
      return
    end
    local shown = {
      false,
      false,
      false,
      false
    }
    local theAttachmentList = DataCenter.AllianceMineManager:GetAllianceCenterAttachmentList()
    if theAttachmentList ~= nil and self.active_building_list ~= nil then
      for index, meta in ipairs(self.active_building_list) do
        local buildId = toInt(meta.baseId)
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
    if self.eff_main then
      self.eff_main.gameObject:SetActive(theStoveCenter.status == AllianceMineStatus.Normal)
    end
  end
end

return UILWSeason4MilitaryCenterModelViewer
