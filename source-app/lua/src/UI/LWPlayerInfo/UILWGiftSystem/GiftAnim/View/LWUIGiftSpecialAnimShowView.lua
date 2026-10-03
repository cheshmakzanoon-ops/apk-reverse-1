local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWUIGiftSpecialAnimShowView = BaseClass("LWUIGiftSpecialAnimShowView", base)
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local ResourceManager = CS.GameEntry.Resource
local Camera = CS.UnityEngine.Camera
local DISPLAY_SCENE_PATH = "Assets/Main/Prefabs/UI/LWPlayerInfo/GiftSystem/Effect/%s.prefab"
local camera_path = "camera"
local timeline_path = ""
local LWUIGiftSpecialAnimSenderContent = require("UI.LWPlayerInfo.UILWGiftSystem.GiftAnim.Components.LWUIGiftSpecialAnimSenderContent")
local rtImg_path = "OpenAniRT"
local rtCanvasGroup_path = "OpenAniRT"
local skipBtn_path = "OpenAniRT/ScreenClickArea"
local senderContent_path = "SenderContent"
local TIME_LINE_DISAPPEAR_TIME = 6

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ResetEffect()
  self.data = self:GetUserData() or {}
  self:OnContinuePlayEffect(self.data)
end

local function OnDestroy(self)
  base.OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  self:ResetEffect()
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.rtImg = self:AddComponent(UIRawImage, rtImg_path)
  self.rtCanvasGroup = self:AddComponent(UICanvasGroup, rtCanvasGroup_path)
  self.skipBtn = self:AddComponent(UIButton, skipBtn_path)
  self.senderContent = self:AddComponent(LWUIGiftSpecialAnimSenderContent, senderContent_path)
  self.skipBtn:SetOnClick(function()
    self:OnSkipBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.rtImg = nil
  self.rtCanvasGroup = nil
  self.skipBtn = nil
  self.senderContent = nil
  if self.sceneCamera then
    self.sceneCamera.targetTexture = nil
  end
  if self.privilegeCamera then
    self.privilegeCamera.targetTexture = nil
  end
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
  self.renderTexture = nil
end

local function DataDefine(self)
  self.defaultScenePos = Vector3.New(0, 0, 0)
  self.aniFinishCallback = nil
  self.skipBtnDisappearTimer = nil
  self.skipBtnAniTween = nil
  self.soundId = nil
  self.allowSkip = false
  self.giftPrivileName = nil
  self.giftPrivilegeReq = nil
  self.giftPrivilegeLoaded = nil
end

local function DataDestroy(self)
  self:ClearDelayCloseTimer()
  self:StopAllTimeAndTween()
  self.defaultScenePos = nil
  self.aniFinishCallback = nil
  self.skipBtnDisappearTimer = nil
  self.skipBtnAniTween = nil
  self.soundId = nil
  self.allowSkip = false
end

function LWUIGiftSpecialAnimShowView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GiftSystemPlayEffect, self.OnContinuePlayEffect)
end

function LWUIGiftSpecialAnimShowView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.GiftSystemPlayEffect, self.OnContinuePlayEffect)
end

function LWUIGiftSpecialAnimShowView:OnSkipBtnClick()
  if self.soundId then
    DataCenter.LWSoundManager:StopSound(self.soundId)
  end
  if self.forbiddenSkip then
    return
  end
  if not self.allowSkip then
    return
  end
  self:ExecuteTimeLineFinish()
end

function LWUIGiftSpecialAnimShowView:ClearDelayCloseTimer()
  if self.delayCloseTimer then
    self.delayCloseTimer:Stop()
    self.delayCloseTimer = nil
  end
end

function LWUIGiftSpecialAnimShowView:OnContinuePlayEffect(data)
  self.data = data
  self:StartShowOpeningAni(data.giftId, data.callback, data.forbiddenSkip, data.groupId)
end

function LWUIGiftSpecialAnimShowView:StartShowOpeningAni(giftId, callback, forbiddenSkip, groupId)
  self.giftId = giftId
  self.aniFinishCallback = callback
  self.forbiddenSkip = forbiddenSkip == true
  self.groupId = groupId
  self.configEffectId = nil
  self.configSoundId = nil
  self.privilege_fx = nil
  local goods = DataCenter.GiftSystemManager:GetGiftGoods(self.giftId)
  self.privilege_fx = goods.privilege_fx
  if goods.ep_gift == 1 then
    self.configEffectId = goods.effect_id
    self.configSoundId = goods.sound_id
  elseif next(goods.group_id) and self.groupId then
    local effect = goods.group_effect[self.groupId]
    if effect then
      self.configEffectId = effect
    end
    local sound = goods.group_sound[self.groupId]
    if sound then
      self.configSoundId = sound
    end
  end
  if string.IsNullOrEmpty(self.configEffectId) then
    self:ExecuteTimeLineFinish()
  end
  self.gameObject:SetActive(true)
  self.rtImg:SetEnable(false)
  self.skipBtn:SetActive(false)
  self.rtImg:SetAlpha(1)
  self:LoadScene()
  self:LoadPrivilegeEffect()
  self.senderContent:ReInit(self.data)
  self.isClickScreen = false
end

function LWUIGiftSpecialAnimShowView:LoadScene()
  if self.sceneLoading then
    return
  end
  if self.sceneLoaded and self.sceneCamera then
    self:DoWhenSceneLoaded()
    return
  end
  local animConfig = GiftSystemConst.AnimConfig[self.configEffectId] or {}
  camera_path = animConfig.CameraPath or "camera"
  timeline_path = animConfig.TimeLinePath or ""
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
    self.timeLineDirector = self.sceneObj.transform:Find(timeline_path):GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
    self.sceneLoading = nil
    self.sceneLoaded = request
    self.sceneCamera = camera
    self:ToggleSceneCamera(true)
    self:DoWhenSceneLoaded(self)
  end)
end

function LWUIGiftSpecialAnimShowView:LoadPrivilegeEffect()
  if string.IsNullOrEmpty(self.privilege_fx) then
    self:ResetPrivilegeEffect()
  elseif self.privilege_fx ~= self.giftPrivileName then
    self:ResetPrivilegeEffect()
    self.giftPrivileName = self.privilege_fx
    self.giftPrivilegeReq = self:GameObjectInstantiateAsync(string.format(DISPLAY_SCENE_PATH, self.privilege_fx), function(request)
      local go = request.gameObject
      go:SetActive(false)
      self.giftPrivilegeLoaded = true
    end)
  elseif self.giftPrivilegeLoaded == true then
    self.giftPrivilegeReq.gameObject:SetActive(false)
  end
end

function LWUIGiftSpecialAnimShowView:ToggleSceneCamera(b)
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

function LWUIGiftSpecialAnimShowView:DoWhenSceneLoaded()
  if not IsNull(self.sceneObj) then
    self.sceneObj:SetActive(true)
  end
  self.timeLineDirector.time = 0
  self.timeLineDirector:Play()
  local timeLineDuration = self.timeLineDirector.duration or TIME_LINE_DISAPPEAR_TIME
  self.resultDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
    if not string.IsNullOrEmpty(self.configEffectId) and self.giftPrivilegeLoaded == true then
      self:StopAllTimeAndTween()
      if not IsNull(self.sceneObj) then
        self.sceneObj:SetActive(false)
      end
      local obj = self.giftPrivilegeReq.gameObject
      obj:SetActive(true)
      obj.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      obj.transform:Set_position(self.defaultScenePos.x, self.defaultScenePos.y, self.defaultScenePos.z)
      local camera = obj.transform:Find("Camera"):GetComponentInChildren(typeof(Camera))
      camera.clearFlags = CS.UnityEngine.CameraClearFlags.SolidColor
      local timeLineDirector = obj.transform:Find(timeline_path):GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
      if not IsNull(camera) and not IsNull(timeLineDirector) then
        self.privilegeCamera = camera
        self:OnRenderTexture(camera)
        self.rtImg:SetAlpha(1)
        timeLineDirector.time = 0
        timeLineDirector:Play()
        local timeLineDuration2 = timeLineDirector.duration
        self.resultDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
          self:ExecuteTimeLineFinish()
        end, timeLineDuration2)
      else
        self:ExecuteTimeLineFinish()
      end
    else
      self:ExecuteTimeLineFinish()
    end
  end, timeLineDuration)
  self.canContinueTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.skipBtn:SetActive(true)
    self.allowSkip = true
  end, 1)
  local goods = DataCenter.GiftSystemManager:GetGiftGoods(self.giftId)
  local doFadeTime = 0
  local disappearDelay = 0
  if goods and 0 < goods.fade_out_time then
    local fadeTime = goods.fade_out_time / 1000
    doFadeTime = fadeTime
    disappearDelay = fadeTime
  else
    local animConfig = GiftSystemConst.AnimConfig[self.configEffectId] or {}
    doFadeTime = animConfig.DoFadeTime
    disappearDelay = animConfig.DisappearDelay
  end
  self.giftDisappearTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.giftDisappearTween then
      self.giftDisappearTween:Kill()
    end
    if self.giftDisappearTween == nil then
      self.giftDisappearTween = self.rtImg:DOFade(0, doFadeTime or 0):SetEase(CS.DG.Tweening.Ease.InOutSine)
      self.giftDisappearTween:OnComplete(function()
        self.giftDisappearTween = nil
      end)
    end
    self.giftDisappearTimer = nil
  end, timeLineDuration - (disappearDelay or 0))
  if not string.IsNullOrEmpty(self.configSoundId) then
    self.soundId = DataCenter.LWSoundManager:PlaySound(tonumber(self.configSoundId), false)
  end
end

function LWUIGiftSpecialAnimShowView:OnRenderTexture(camera)
  if camera == nil then
    Logger.LogError("OnRenderTexture camera is nil!")
    return
  end
  if self.renderTexture == nil then
    local rtImgWidth = self.rtImg.rectTransform.rect.width
    local rtImgHeight = self.rtImg.rectTransform.rect.height
    local rtHeight = math.ceil(DefaultScreenHeight)
    local rtWidth = math.ceil(DefaultScreenHeight / (rtImgHeight / rtImgWidth))
    local rtFormat = RenderTextureFormat.ARGBHalf
    self.renderTexture = RenderTexture.GetTemporary(math.floor(rtWidth), math.floor(rtHeight), 24, rtFormat)
    self.renderTexture.name = "GiftSpecialRT"
    self.rtImg:SetTexture(self.renderTexture)
    self.rtImg:SetColor(Color.white)
  end
  self.rtImg:SetEnable(true)
  camera.targetTexture = self.renderTexture
end

function LWUIGiftSpecialAnimShowView:ExecuteTimeLineFinish()
  if self.delayCloseTimer then
    return
  end
  local delayTime
  if self.senderContent then
    delayTime = self.senderContent:TryPlayMoveOutAnim()
  end
  if delayTime and 0 < delayTime then
    self:ClearDelayCloseTimer()
    self.delayCloseTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self then
        self:ClearDelayCloseTimer()
        self:ClearAllStuffs()
      end
    end, delayTime)
  else
    self:ClearAllStuffs()
  end
end

function LWUIGiftSpecialAnimShowView:ClearAllStuffs()
  if self.soundId then
    DataCenter.LWSoundManager:StopSound(self.soundId)
  end
  self:StopAllTimeAndTween()
  if not IsNull(self.gameObject) then
    self.gameObject:SetActive(false)
  end
  if not IsNull(self.sceneObj) then
    self.sceneObj:SetActive(false)
  end
  local callback = self.aniFinishCallback
  self.ctrl:CloseSelf()
  if callback then
    callback()
  end
  self.aniFinishCallback = nil
end

function LWUIGiftSpecialAnimShowView:StopAllTimeAndTween()
  if self.resultDelayTimer then
    self.resultDelayTimer:Stop()
    self.resultDelayTimer = nil
  end
  if self.giftDisappearTimer then
    self.giftDisappearTimer:Stop()
    self.giftDisappearTimer = nil
  end
  if self.giftDisappearTween then
    self.giftDisappearTween:Kill()
    self.giftDisappearTween = nil
  end
  if self.canContinueTimer then
    self.canContinueTimer:Stop()
    self.canContinueTimer = nil
  end
end

function LWUIGiftSpecialAnimShowView:ResetEffect()
  if self.sceneLoaded ~= nil then
    self.sceneLoaded:Destroy()
  end
  self.sceneLoaded = nil
  if self.sceneLoading ~= nil then
    self.sceneLoading:Destroy()
  end
  self.sceneLoading = nil
  self.timeLineDirector = nil
  self:ResetPrivilegeEffect()
end

function LWUIGiftSpecialAnimShowView:ResetPrivilegeEffect()
  if self.giftPrivilegeReq ~= nil then
    self:GameObjectDestroy(self.giftPrivilegeReq)
  end
  self.giftPrivileName = nil
  self.giftPrivilegeReq = nil
  self.giftPrivilegeLoaded = nil
end

function LWUIGiftSpecialAnimShowView:ExecuteCallBack()
  if self.aniFinishCallback then
    self.aniFinishCallback()
    self.aniFinishCallback = nil
  end
end

LWUIGiftSpecialAnimShowView.OnCreate = OnCreate
LWUIGiftSpecialAnimShowView.OnDestroy = OnDestroy
LWUIGiftSpecialAnimShowView.OnEnable = OnEnable
LWUIGiftSpecialAnimShowView.OnDisable = OnDisable
LWUIGiftSpecialAnimShowView.ComponentDefine = ComponentDefine
LWUIGiftSpecialAnimShowView.ComponentDestroy = ComponentDestroy
LWUIGiftSpecialAnimShowView.DataDefine = DataDefine
LWUIGiftSpecialAnimShowView.DataDestroy = DataDestroy
return LWUIGiftSpecialAnimShowView
