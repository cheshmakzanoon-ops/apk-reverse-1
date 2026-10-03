local UIS0AllianceBossModelShowCtrl = BaseClass("UIS0AllianceBossModelShowCtrl", UIBaseContainer)
local base = UIBaseContainer
local ResourceManager = CS.GameEntry.Resource
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local Camera = CS.UnityEngine.Camera
local GameQualitySettings = require("Util.GameQualitySettings")
local UI_MODEL_SCENE_PATH = "Assets/Main/Prefabs/UIModelScene/UIS0AllianceBossModelScene.prefab"
local HERO_SLOT_PATH = "DisplayScene_boss/HeroSlot"
local CAMERA_PATH = "DisplayScene_boss/Camera"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  if self.scene and not IsNull(self.scene.gameObject) then
    self.scene.gameObject:SetActive(true)
  end
end

local function OnDisable(self)
  if self.scene and not IsNull(self.scene.gameObject) then
    self.scene.gameObject:SetActive(false)
  end
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.rawImage = self:AddComponent(UIRawImage, "")
  if self.rawImage ~= nil then
    self.rawImage:SetColorRGBA(1, 1, 1, 0)
    self.rawImage:SetActive(false)
  end
end

local function ComponentDestroy(self)
  self.rawImage = nil
end

local function DataDefine(self)
  self.camera = nil
  self.citySlot = nil
  self.rtLen = 1080
  self.isFirstInit = true
  self.path = nil
  self.requests = {}
  self.curModel = nil
end

local function DataDestroy(self)
  self:ReleaseTexture()
  self.camera = nil
  self.citySlot = nil
  if self.requests then
    for _, v in pairs(self.requests) do
      if v then
        v:Destroy()
      end
    end
    self.requests = nil
  end
  self:DestroyScene()
  self.rtLen = nil
  self.isFirstInit = nil
  self.path = nil
  self.curModel = nil
end

local function DestroyScene(self)
  if self.scene ~= nil then
    self.scene:Destroy()
    self.scene = nil
  end
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

local function Init(self, path)
  self:LoadScene(path)
end

local function LoadScene(self, path)
  if path == nil then
    return
  end
  if self.path == path then
    return
  end
  self.path = path
  if self.scene == nil then
    local scene = ResourceManager:InstantiateAsync(UI_MODEL_SCENE_PATH)
    self.scene = scene
    scene:completed("+", function()
      if scene.isError then
        return
      end
      local go = scene.gameObject
      local trans = go.transform
      trans:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      trans.position = Vector3.New(2000, 2000, 2000)
      self.camera = trans:Find(CAMERA_PATH):GetComponentInChildren(typeof(Camera))
      self.citySlot = trans:Find(HERO_SLOT_PATH)
      if IsNull(self.camera) or IsNull(self.citySlot) then
        Logger.LogError("S0AllianceBoss -- camera or citySlot is nil")
        return
      end
      self:OnRenderTexture(self.camera)
      go:SetActive(true)
      self:LoadBoss(self.path)
    end)
  elseif self.camera ~= nil then
    self:LoadBoss(path)
  end
end

local function LoadBoss(self, path)
  if self.lastPath ~= path and self.requests[self.lastPath] then
    if self.requests[self.lastPath].gameObject then
      self.requests[self.lastPath].gameObject.transform:Set_localPosition(1000, 1000, 1000)
    else
      self.requests[self.lastPath]:Destroy()
      self.requests[self.lastPath] = nil
    end
  end
  if self.requests[path] then
    if self.requests[path].gameObject then
      self.requests[path].gameObject.transform:Set_localPosition(0, 0, 0)
    end
  else
    local request = ResourceManager:InstantiateAsync(path)
    request:completed("+", function()
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      local trans = go.transform
      trans:SetParent(self.citySlot.transform)
      trans:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      trans:Set_localPosition(0, 0, 0)
      trans:Set_localRotation(0, 0, 0, 1)
    end)
    self.requests[path] = request
  end
  self.lastPath = path
end

local function OnRenderTexture(self, camera)
  if camera == nil then
    Logger.LogError(" OnRenderTexture camera is nil!")
    return
  end
  if self.renderTexture == nil then
    local scale = 1
    local qualityLevel = GameQualitySettings.GetQuality()
    if qualityLevel <= EnumQualityLevel.Low then
      scale = 0.5
    elseif qualityLevel <= EnumQualityLevel.Middle then
      scale = 0.7
    end
    local rtWidth = self.rtLen * scale
    local rtHeight = self.rtLen * scale
    local rtFormat = RenderTextureFormat.ARGB32
    self.renderTexture = RenderTexture.GetTemporary(rtWidth, rtHeight, 24, rtFormat)
    self.renderTexture.name = "UIS0AllianceBossModelShow"
    self.rawImage:SetTexture(self.renderTexture)
    self.rawImage:SetEnable(true)
    if self.rawImage ~= nil then
      self.rawImage:SetColorRGBA(1, 1, 1, 1)
    end
  end
  if self.isFirstInit then
    self.rawImage:SetActive(true)
    self.isFirstInit = false
  end
  camera.targetTexture = self.renderTexture
end

UIS0AllianceBossModelShowCtrl.OnCreate = OnCreate
UIS0AllianceBossModelShowCtrl.OnDestroy = OnDestroy
UIS0AllianceBossModelShowCtrl.OnEnable = OnEnable
UIS0AllianceBossModelShowCtrl.OnDisable = OnDisable
UIS0AllianceBossModelShowCtrl.ComponentDefine = ComponentDefine
UIS0AllianceBossModelShowCtrl.ComponentDestroy = ComponentDestroy
UIS0AllianceBossModelShowCtrl.DataDefine = DataDefine
UIS0AllianceBossModelShowCtrl.DataDestroy = DataDestroy
UIS0AllianceBossModelShowCtrl.DestroyScene = DestroyScene
UIS0AllianceBossModelShowCtrl.ReleaseTexture = ReleaseTexture
UIS0AllianceBossModelShowCtrl.LoadBoss = LoadBoss
UIS0AllianceBossModelShowCtrl.OnRenderTexture = OnRenderTexture
UIS0AllianceBossModelShowCtrl.Init = Init
UIS0AllianceBossModelShowCtrl.LoadScene = LoadScene
return UIS0AllianceBossModelShowCtrl
