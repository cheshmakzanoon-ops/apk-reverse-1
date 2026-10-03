local UIAllianceStarMainScenePanel = BaseClass("UIAllianceStarMainScenePanel", UIBaseContainer)
local base = UIBaseContainer
local ResourceManager = CS.GameEntry.Resource
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local Camera = CS.UnityEngine.Camera
local GameQualitySettings = require("Util.GameQualitySettings")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  if self.sceneLight then
    self.sceneLight:SetActive(true)
  end
end

local function OnDisable(self)
  if self.sceneLight then
    self.sceneLight:SetActive(false)
  end
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.rawImage = self:AddComponent(UIRawImage, "")
end

local function ComponentDestroy(self)
  self:ReleaseTexture()
  self.rawImage = nil
end

local function DataDefine(self)
  self.camera = nil
  self.renderTexture = nil
end

local function DataDestroy(self)
  self.sceneLight = nil
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function OnScreenCreate(self, sceneObj)
  local light = sceneObj.transform:Find("Light")
  if light then
    self.sceneLight = sceneObj.transform:Find("Light").gameObject
    self.sceneLight:SetActive(true)
  end
  local camera = sceneObj.transform:Find("Camera"):GetComponentInChildren(typeof(Camera))
  if camera then
    self:OnRenderTexture(camera)
  end
end

local function OnRenderTexture(self, camera)
  self.camera = camera
  if camera == nil then
    Logger.LogError(" OnRenderTexture camera is nil!")
    return
  end
  if self.renderTexture == nil then
    local scale = 1
    if not GameQualitySettings.IsHighGearQuality() then
      scale = 0.75
    end
    local rtWidth, rtHeight = DataCenter.AllianceStarManager:GetUIScreenSizeXY()
    local rtFormat = RenderTextureFormat.ARGB32
    rtWidth = math.floor(rtWidth * scale)
    rtHeight = math.floor(rtHeight * scale)
    self.renderTexture = RenderTexture.GetTemporary(rtWidth, rtHeight, 24, rtFormat)
    self.renderTexture.name = "AllianceStarCeremonyShow"
    self.rawImage:SetTexture(self.renderTexture)
    self.rawImage:SetEnable(true)
    self.rawImage:SetColorRGBA(1, 1, 1, 1)
  end
  camera.targetTexture = self.renderTexture
  self:SetActive(true)
end

local function ReleaseTexture(self)
  if self.camera ~= nil then
    self.camera.targetTexture = nil
  end
  self.rawImage:SetTexture(nil)
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
end

UIAllianceStarMainScenePanel.OnCreate = OnCreate
UIAllianceStarMainScenePanel.OnDestroy = OnDestroy
UIAllianceStarMainScenePanel.OnEnable = OnEnable
UIAllianceStarMainScenePanel.OnDisable = OnDisable
UIAllianceStarMainScenePanel.ComponentDefine = ComponentDefine
UIAllianceStarMainScenePanel.ComponentDestroy = ComponentDestroy
UIAllianceStarMainScenePanel.DataDefine = DataDefine
UIAllianceStarMainScenePanel.DataDestroy = DataDestroy
UIAllianceStarMainScenePanel.OnAddListener = OnAddListener
UIAllianceStarMainScenePanel.OnRemoveListener = OnRemoveListener
UIAllianceStarMainScenePanel.OnRenderTexture = OnRenderTexture
UIAllianceStarMainScenePanel.OnScreenCreate = OnScreenCreate
UIAllianceStarMainScenePanel.ReleaseTexture = ReleaseTexture
return UIAllianceStarMainScenePanel
