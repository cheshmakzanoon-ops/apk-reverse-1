local UIRecruitSceneHolder = BaseClass("UIRecruitSceneHolder", UIBaseContainer)
local GameQualitySettings = require("Util.GameQualitySettings")
local base = UIBaseContainer
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local ResourceManager = CS.GameEntry.Resource
local PlayableDirector = CS.UnityEngine.Playables.PlayableDirector
local Camera = CS.UnityEngine.Camera
local Screen = CS.UnityEngine.Screen
local shadowDistance

local function SetQulity(self, enable)
  if enable then
    shadowDistance = RenderSetting.GetShadowDistance()
    RenderSetting.SetShadowDistance(6)
  else
    RenderSetting.SetShadowDistance(shadowDistance)
  end
end

local function OnCreate(self, onTimeLineCallback)
  base.OnCreate(self)
  self.sceneVisible = true
  self.rawImage = self:AddComponent(UIRawImage, "")
  self.onTimeLineCallback = onTimeLineCallback
  self.rawImage:SetEnable(false)
  self.rawImage:SetColor(Color.New(1, 1, 1, 10))
end

local function OnDestroy(self)
  self:ReleaseTexture()
  if self.sceneLoading ~= nil then
    self.sceneLoading:Destroy()
    self.sceneLoading = nil
  end
  if self.sceneLoaded ~= nil then
    self.sceneLoaded:Destroy()
    self.sceneLoaded = nil
  end
  self.onTimeLineCallback = nil
  if self.director then
    if self.onPlayed then
      self.director:played("-", self.onPlayed)
    end
    if self.onStopped then
      self.director:stopped("-", self.onStopped)
    end
  end
  base.OnDestroy(self)
end

local function OnEnable(self)
  RenderSetting.ToggleFurRenderFeature(true)
  self:SetQulity(true)
  base.OnEnable(self)
end

local function OnDisable(self)
  RenderSetting.ToggleFurRenderFeature(false)
  self:SetQulity(false)
  base.OnDisable(self)
end

local function LoadModel(self, callback)
  Logger.Log("#RecruitScene# Step in LoadModel!")
  local path = HeroUtils.RecruitScenePath
  local lotteryData = DataCenter.LotteryDataManager:GetLotteryDataById(self.lotteryId)
  if self.rarity == HeroUtils.RarityType.A then
    path = HeroUtils.RecruitSceneGaojiPath
  elseif self.rarity == HeroUtils.RarityType.S then
    path = HeroUtils.RecruitSceneOrangePath
  end
  local request = ResourceManager:InstantiateAsync(path)
  self.sceneLoading = request
  request:completed("+", function()
    if request.isError then
      Logger.LogError("#RecruitScene# SceneHolder LoadModel Error! heroId:" .. heroId .. ", Error:" .. request.error)
      request:Destroy()
      self.sceneLoading = nil
      if callback ~= nil then
        callback(false)
      end
      return
    end
    request.gameObject.transform:Set_localPosition(100, 100, 0)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    request.gameObject:SetActive(true)
    local director = request.gameObject.transform:GetComponentInChildren(typeof(PlayableDirector), true)
    self.director = director
    if director then
      function self.onPlayed(dir)
        Logger.Log("#RecruitScene# UIRecruitSceneHolder TimeLine[" .. dir.playableAsset.name .. "]: step in played!")
        
        self:OnTimeLineEvent(dir.playableAsset.name, "start")
      end
      
      director:played("+", self.onPlayed)
      
      function self.onStopped(dir)
        Logger.Log("#RecruitScene# UIRecruitSceneHolder TimeLine[" .. dir.playableAsset.name .. "]: step in stopped!")
        self:OnTimeLineEvent(dir.playableAsset.name, "stop")
      end
      
      director:stopped("+", self.onStopped)
    else
      TimerManager:GetInstance():DelayInvoke(function()
        self:OnTimeLineEvent(dir.playableAsset.name, "stop")
      end, 0)
    end
    self:PlayTimeLine(HeroUtils.RecruitTimeOpenPath)
    Logger.Log("#RecruitScene# UIRecruitSceneHolder TimeLine[" .. director.playableAsset.name .. "]: Start play manually!")
    local camera = request.gameObject.transform:GetComponentInChildren(typeof(Camera), true)
    if camera then
      camera.cullingMask = 1 << CS.UnityEngine.LayerMask.NameToLayer("UIObject3D")
      local additionalData = camera:GetComponent(typeof(CS.UnityEngine.Rendering.Universal.UniversalAdditionalCameraData))
      if additionalData ~= nil then
        local layerMask = CS.UnityEngine.LayerMask()
        layerMask.value = 1 << CS.UnityEngine.LayerMask.NameToLayer("UIObject3D")
        additionalData.volumeLayerMask = layerMask
      end
    end
    self.rawImage:SetColor(Color.New(1, 1, 1, 0))
    self:OnRenderTexture(camera)
    self.camera = camera
    request.gameObject:SetActive(self.sceneVisible)
    self.sceneLoading = nil
    self.sceneLoaded = request
    if callback ~= nil then
      callback(true)
    end
  end)
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
    local tName = "RecruitScene"
    local lotteryData = DataCenter.LotteryDataManager:GetLotteryDataById(self.lotteryId)
    if self.rarity == HeroUtils.RarityType.A then
      tName = "RecruitScene_gaoji"
    elseif self.rarity == HeroUtils.RarityType.S then
      tName = "RecruitScene_chengse"
    end
    self.renderTexture.name = tName
    self.rawImage:SetTexture(self.renderTexture)
    self.rawImage:SetColor(Color.New(1, 1, 1, 1))
    self.rawImage:SetEnable(true)
  end
  camera.targetTexture = self.renderTexture
end

local function ReleaseTexture(self)
  self.rawImage:SetTexture(nil)
  if self.camera ~= nil then
    self.camera.targetTexture = nil
  end
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
end

local function OnTimeLineEvent(self, playableName, event)
  if event == "start" then
    self.timeLineFinish = false
  elseif event == "stop" then
    self.timeLineFinish = true
  end
  if self.onTimeLineCallback then
    self.onTimeLineCallback(playableName, event)
  end
end

local function ToggleScene(self, t)
  self.sceneVisible = t
  if self.sceneLoaded then
    self.sceneLoaded.gameObject.transform.localScale = t and Vector3.one or Vector3.zero
  end
end

local function ToggleLight(self, t)
  if self.sceneLoaded then
    local light = self.sceneLoaded.gameObject.transform:GetComponentInChildren(typeof(CS.UnityEngine.Light), true)
    light.enabled = t
  end
end

local function PlayTimeLine(self, playablePath)
  Logger.Log("#RecruitScene# Step in PlayTimeLine! path:", playablePath)
  if self.director == nil then
    return
  end
  local req = ResourceManager:LoadAssetAsync(playablePath, typeof(CS.UnityEngine.Playables.PlayableAsset))
  if req ~= nil then
    self.playableRequest = req
    
    function req.completed()
      if req.isError then
        Logger.LogError("#RecruitScene# PlayTimeLine Error err:", tostring(req.isError))
        return
      end
      self.director.playableAsset = req.asset
      self.director:Play()
    end
  end
end

local function PlayCloseTimeLine(self)
  self:PlayTimeLine(HeroUtils.RecruitTimeClosePath)
end

local function SetLotteryId(self, lotteryId, rarity)
  if self.rarity ~= rarity then
    self:ReleaseTexture()
    if self.sceneLoading ~= nil then
      self.sceneLoading:Destroy()
      self.sceneLoading = nil
    end
    if self.sceneLoaded ~= nil then
      self.sceneLoaded:Destroy()
      self.sceneLoaded = nil
    end
    self.rawImage:SetEnable(false)
    self.rawImage:SetColor(Color.New(1, 1, 1, 10))
    self.lotteryId = lotteryId
    self.rarity = rarity
    self:LoadModel()
  end
end

local function GotoEnd(self)
  if self.director then
    self.director.time = 180
  end
end

UIRecruitSceneHolder.OnCreate = OnCreate
UIRecruitSceneHolder.OnDestroy = OnDestroy
UIRecruitSceneHolder.OnEnable = OnEnable
UIRecruitSceneHolder.OnDisable = OnDisable
UIRecruitSceneHolder.LoadModel = LoadModel
UIRecruitSceneHolder.OnRenderTexture = OnRenderTexture
UIRecruitSceneHolder.ReleaseTexture = ReleaseTexture
UIRecruitSceneHolder.OnTimeLineEvent = OnTimeLineEvent
UIRecruitSceneHolder.ToggleScene = ToggleScene
UIRecruitSceneHolder.ToggleLight = ToggleLight
UIRecruitSceneHolder.PlayTimeLine = PlayTimeLine
UIRecruitSceneHolder.PlayCloseTimeLine = PlayCloseTimeLine
UIRecruitSceneHolder.SetQulity = SetQulity
UIRecruitSceneHolder.SetLotteryId = SetLotteryId
UIRecruitSceneHolder.GotoEnd = GotoEnd
return UIRecruitSceneHolder
