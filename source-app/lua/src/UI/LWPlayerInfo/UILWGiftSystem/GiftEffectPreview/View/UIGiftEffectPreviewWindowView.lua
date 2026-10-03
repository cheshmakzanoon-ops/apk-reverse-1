local UIGiftEffectPreviewWindowView = BaseClass("UIGiftEffectPreviewWindowView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local ResourceManager = CS.GameEntry.Resource
local Camera = CS.UnityEngine.Camera
local DISPLAY_SCENE_PATH = "Assets/Main/Prefabs/UI/LWPlayerInfo/GiftSystem/Effect/%s.prefab"
local camera_path = "camera"
local timeline_path = ""
local back_btn_path = "Root/BackBtn"
local preview_rt_path = "Root/PreviewRt"
local TIME_LINE_DISAPPEAR_TIME = 6

function UIGiftEffectPreviewWindowView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ResetEffect()
  local data = self:GetUserData() or {}
  self.configEffectId = data.configEffectId
  self.configSoundId = data.configSoundId
  local animConfig = GiftSystemConst.AnimConfig[self.configEffectId] or {}
  camera_path = animConfig.CameraPath or "camera"
  timeline_path = animConfig.TimeLinePath or ""
  self:StartShowOpeningAni()
end

function UIGiftEffectPreviewWindowView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  self:ResetEffect()
  base.OnDestroy(self)
end

function UIGiftEffectPreviewWindowView:ComponentDefine()
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.preview_rt = self:AddComponent(UIRawImage, preview_rt_path)
  self.back_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

function UIGiftEffectPreviewWindowView:ComponentDestroy()
  if not IsNull(self.gameObject) then
    self.gameObject:SetActive(false)
  end
  if not IsNull(self.sceneObj) then
    self.sceneObj:SetActive(false)
  end
  if self.sceneCamera then
    self.sceneCamera.targetTexture = nil
  end
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
  self.renderTexture = nil
  self.back_btn = nil
  self.preview_rt = nil
end

function UIGiftEffectPreviewWindowView:DataDefine()
  self.defaultScenePos = Vector3.New(10000, 10000, 0)
end

function UIGiftEffectPreviewWindowView:DataDestroy()
  if self.resultDelayTimer then
    self.resultDelayTimer:Stop()
    self.resultDelayTimer = nil
  end
end

function UIGiftEffectPreviewWindowView:StartShowOpeningAni()
  if string.IsNullOrEmpty(self.configEffectId) then
    return
  end
  self.preview_rt:SetEnable(false)
  self:LoadScene()
end

function UIGiftEffectPreviewWindowView:LoadScene()
  if self.sceneLoading then
    return
  end
  if self.sceneLoaded and self.sceneCamera then
    self:DoWhenSceneLoaded()
    return
  end
  local scenePath = string.format(DISPLAY_SCENE_PATH, self.configEffectId)
  local request = ResourceManager:InstantiateAsync(scenePath)
  self.sceneLoading = request
  request:completed("+", function()
    if request.isError then
      self.sceneLoading = nil
      self:DoWhenSceneLoaded(self)
      return
    end
    self.sceneObj = request.gameObject
    self.sceneObj:SetActive(true)
    self.sceneObj.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.sceneObj.transform:Set_position(self.defaultScenePos.x, self.defaultScenePos.y, self.defaultScenePos.z)
    local camera = self.sceneObj.transform:Find(camera_path):GetComponentInChildren(typeof(Camera))
    camera.clearFlags = CS.UnityEngine.CameraClearFlags.SolidColor
    camera.backgroundColor = Color.white
    self.timeLineDirector = self.sceneObj.transform:Find(timeline_path):GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
    self.sceneLoading = nil
    self.sceneLoaded = request
    self.sceneCamera = camera
    self:ToggleSceneCamera(true)
    self:DoWhenSceneLoaded(self)
  end)
end

function UIGiftEffectPreviewWindowView:DoWhenSceneLoaded()
  if not IsNull(self.sceneObj) then
    self.sceneObj:SetActive(true)
  end
  self.timeLineDirector.time = 0
  self.timeLineDirector:Play()
  local animConfig = GiftSystemConst.AnimConfig[self.configEffectId] or {}
  local timeLineDuration = self.timeLineDirector.duration or TIME_LINE_DISAPPEAR_TIME
  self.resultDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:DoWhenSceneLoaded()
  end, timeLineDuration - (animConfig.ResultDelay or 0))
  if self.configSoundId ~= 0 then
    self.soundId = DataCenter.LWSoundManager:PlaySound(self.configSoundId, false)
  end
end

function UIGiftEffectPreviewWindowView:ToggleSceneCamera(b)
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

function UIGiftEffectPreviewWindowView:OnRenderTexture(camera)
  if camera == nil then
    Logger.LogError("OnRenderTexture camera is nil!")
    return
  end
  if self.renderTexture == nil then
    local rtImgWidth = self.preview_rt.rectTransform.rect.width
    local rtImgHeight = self.preview_rt.rectTransform.rect.height
    local rtHeight = math.ceil(DefaultScreenHeight)
    local rtWidth = math.ceil(DefaultScreenHeight / (rtImgHeight / rtImgWidth))
    local rtFormat = RenderTextureFormat.ARGB32
    self.renderTexture = RenderTexture.GetTemporary(math.floor(rtWidth), math.floor(rtHeight), 24, rtFormat)
    self.renderTexture.name = "GiftPreviewRT"
    self.preview_rt:SetTexture(self.renderTexture)
    self.preview_rt:SetColor(Color.white)
  end
  self.preview_rt:SetEnable(true)
  camera.targetTexture = self.renderTexture
end

function UIGiftEffectPreviewWindowView:ResetEffect()
  if self.sceneLoaded ~= nil then
    self.sceneLoaded:Destroy()
  end
  self.sceneLoaded = nil
  if self.sceneLoading ~= nil then
    self.sceneLoading:Destroy()
  end
  self.sceneLoading = nil
  self.timeLineDirector = nil
end

return UIGiftEffectPreviewWindowView
