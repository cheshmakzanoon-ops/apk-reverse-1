local Resource = CS.GameEntry.Resource
local PVEScenePath = "Assets/Main/Prefabs/PVELevel/LastWar_Scene_Hero_Exhibit_Preview/%s.prefab"
local sceneOffset = 0
local PreviewHeroExhibitEffectManager = BaseClass("PreviewHeroExhibitEffectManager")
local LightPath = "City/Scene_City2(Clone)/Light_City"
local defaultQuality, shadowDistance
local RenderSettings = CS.UnityEngine.RenderSettings
local Camera = CS.UnityEngine.Camera

function PreviewHeroExhibitEffectManager:__init()
  self.timer = nil
  self.sceneLoadRequest = nil
end

function PreviewHeroExhibitEffectManager:__delete()
  self:Destroy()
end

function PreviewHeroExhibitEffectManager:Destroy()
  self:UnInitCamera()
  self:CloseTimer()
  if self.sceneLoadRequest then
    self.sceneLoadRequest:RealDestroy()
  end
  self.sceneLoadRequest = nil
  self.param = nil
  self.scene = nil
  self.director = nil
  self.cameraRoot = nil
  self.roleRoot = nil
end

function PreviewHeroExhibitEffectManager:Enter(param)
  self.squadCreateFinish = false
  self.param = param
  shadowDistance = RenderSetting.GetShadowDistance()
  self.initCityLightState = self:GetCityLightActive()
  DataCenter.CityLightManager:AddDeactiveRef()
  self:CloseMainCamera()
  self:CreateLevel(param)
end

function PreviewHeroExhibitEffectManager:Exit()
  if shadowDistance ~= nil then
    RenderSetting.SetShadowDistance(shadowDistance)
  end
  local initCityLightState = self.initCityLightState
  if initCityLightState == nil then
    initCityLightState = true
  end
  DataCenter.CityLightManager:DecreaseDeactiveRef()
  self:RecoverMainCamera()
  self:Destroy()
end

function PreviewHeroExhibitEffectManager:GetCityLightActive(val)
  local light = CS.UnityEngine.GameObject.Find(LightPath)
  if not IsNull(light) then
    return light.activeSelf
  end
  return false
end

function PreviewHeroExhibitEffectManager:CreateLevel(param)
  self:LoadScene()
end

function PreviewHeroExhibitEffectManager:LoadScene()
  self.sceneLoadRequest = nil
  local sceneName = self.param.modelData
  local sceneDir = self.param.modelDir
  local req = Resource:InstantiateAsync(string.format(sceneDir .. "/%s.prefab", sceneName))
  if not IsNull(self.rtRect) then
    self.rtRect.gameObject:SetActive(false)
    Logger.Log("Close RT")
  end
  req:completed("+", function()
    local sceneRoot = req.gameObject.transform
    sceneRoot:Set_localPosition(sceneOffset, 0, sceneOffset)
    if not IsNull(self.rtRect) then
      self.rtRect.gameObject:SetActive(true)
      Logger.Log("Open RT")
    end
    self.scene = req.gameObject
    self.director = self.scene.transform:Find("TimelineRoot"):GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
    self.cameraRoot = self.scene.transform:Find("TimelineRoot/Camera")
    self.roleRoot = self.scene.transform:Find("TimelineRoot/Role")
    self:ResetParam()
    self:OnLoadedScene()
  end)
  self.sceneLoadRequest = req
end

function PreviewHeroExhibitEffectManager:OnLoadedScene()
  self:InitCamera()
  self:InitTimerCallBack()
  self:InitGame()
end

function PreviewHeroExhibitEffectManager:CloseTimer()
  if self._timer ~= nil then
    self._timer:Stop()
  end
  self._timer = nil
end

function PreviewHeroExhibitEffectManager:InitCamera()
  self.camera = self.cameraRoot:GetComponentInChildren(typeof(CS.UnityEngine.Camera))
end

function PreviewHeroExhibitEffectManager:UnInitCamera()
  if self.camera then
    self.camera.targetTexture = nil
    self.camera = nil
  end
end

function PreviewHeroExhibitEffectManager:InitTimerCallBack()
  self:CloseTimer()
  local time = self.director.duration
  self._timer = TimerManager:GetInstance():DelayInvoke(function()
    self:CloseTimer()
    if self.director then
      self.director.enabled = false
    end
    local animator = self.roleRoot:GetComponentInChildren(typeof(CS.UnityEngine.Animator), true)
    if animator then
      animator:SetTrigger("idle")
    end
  end, time)
end

function PreviewHeroExhibitEffectManager:ResetParam()
  if self.director then
    self.director.enabled = true
  end
end

function PreviewHeroExhibitEffectManager:InitGame()
  self:InitParam()
  EventManager:GetInstance():Broadcast(EventId.PreviewHeroExhibitSceneInit)
end

function PreviewHeroExhibitEffectManager:InitParam()
  local pos = Vector3.New()
  pos.x = sceneOffset
  pos.y = 0
  pos.z = sceneOffset
  self.centerPointPos = pos
end

function PreviewHeroExhibitEffectManager:CacheSetting()
  self.ambientEquatorColor = RenderSettings.ambientEquatorColor
  self.ambientGroundColor = RenderSettings.ambientGroundColor
  self.ambientIntensity = RenderSettings.ambientIntensity
  self.ambientLight = RenderSettings.ambientLight
  self.ambientMode = RenderSettings.ambientMode
  self.ambientProbe = RenderSettings.ambientProbe
  self.ambientSkyColor = RenderSettings.ambientSkyColor
  self.customReflection = RenderSettings.customReflection
  self.defaultReflectionMode = RenderSettings.defaultReflectionMode
  self.flareFadeSpeed = RenderSettings.flareFadeSpeed
  self.flareStrength = RenderSettings.flareStrength
  self.fog = RenderSettings.fog
  self.fogColor = RenderSettings.fogColor
  self.fogDensity = RenderSettings.fogDensity
  self.fogEndDistance = RenderSettings.fogEndDistance
  self.fogMode = RenderSettings.fogMode
  self.fogStartDistance = RenderSettings.fogStartDistance
  self.haloStrength = RenderSettings.haloStrength
  self.reflectionBounces = RenderSettings.reflectionBounces
  self.reflectionIntensity = RenderSettings.reflectionIntensity
  self.skybox = RenderSettings.skybox
  self.subtractiveShadowColor = RenderSettings.subtractiveShadowColor
  self.sun = RenderSettings.sun
end

function PreviewHeroExhibitEffectManager:RecoverSetting()
  RenderSettings.ambientEquatorColor = self.ambientEquatorColor
  RenderSettings.ambientGroundColor = self.ambientGroundColor
  RenderSettings.ambientIntensity = self.ambientIntensity
  RenderSettings.ambientLight = self.ambientLight
  RenderSettings.ambientMode = self.ambientMode
  RenderSettings.ambientProbe = self.ambientProbe
  RenderSettings.ambientSkyColor = self.ambientSkyColor
  RenderSettings.customReflection = self.customReflection
  RenderSettings.defaultReflectionMode = self.defaultReflectionMode
  RenderSettings.flareFadeSpeed = self.flareFadeSpeed
  RenderSettings.flareStrength = self.flareStrength
  RenderSettings.fog = self.fog
  RenderSettings.fogColor = self.fogColor
  RenderSettings.fogDensity = self.fogDensity
  RenderSettings.fogEndDistance = self.fogEndDistance
  RenderSettings.fogMode = self.fogMode
  RenderSettings.fogStartDistance = self.fogStartDistance
  RenderSettings.haloStrength = self.haloStrength
  RenderSettings.reflectionBounces = self.reflectionBounces
  RenderSettings.reflectionIntensity = self.reflectionIntensity
  RenderSettings.skybox = self.skybox
  RenderSettings.subtractiveShadowColor = self.subtractiveShadowColor
  RenderSettings.sun = self.sun
end

function PreviewHeroExhibitEffectManager:ChangeSetting()
  self:CacheSetting()
end

function PreviewHeroExhibitEffectManager:CloseMainCamera()
  self.mainCamera = Camera.main
  self.mainCullingMask = self.mainCamera.cullingMask
  self.mainCamera.cullingMask = 0
end

function PreviewHeroExhibitEffectManager:RecoverMainCamera()
  if self.mainCamera ~= nil and self.mainCullingMask ~= nil then
    self.mainCamera.cullingMask = self.mainCullingMask
  end
end

return PreviewHeroExhibitEffectManager
