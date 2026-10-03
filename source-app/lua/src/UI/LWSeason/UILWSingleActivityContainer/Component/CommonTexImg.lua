local base = UIBaseContainer
local CommonTexImg = BaseClass("CommonTexImg", base)
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local ResourceManager = CS.GameEntry.Resource
local Camera = CS.UnityEngine.Camera
local rawImage_path = ""

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
  if self.sceneLoaded ~= nil then
    self.sceneLoaded.gameObject:SetActive(true)
  end
end

local function OnDisable(self)
  if self.sceneLoaded ~= nil then
    self.sceneLoaded.gameObject:SetActive(false)
  end
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.rawImage = self:AddComponent(UIRawImage, rawImage_path)
  self.rawImage:SetEnable(false)
  self.defaultScenePos = Vector3.New(-5000, 0, -5000)
  self.cameraOffset = Vector3.zero
  self.rtWidth = DefaultScreenWidth
  self.rtHeight = DefaultScreenWidth
  self.sceneLoaded = nil
  self.sceneCamera = nil
  self.sceneLoading = nil
end

local function ComponentDestroy(self)
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
  self.simpleAnimation = nil
  self.rawImage = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function CommonTexImg:InitData(data)
  self.data = data
end

function CommonTexImg:ToggleSceneVisible(t)
  if self.sceneLoaded then
    self.sceneLoaded.gameObject:SetActive(t)
  end
end

function CommonTexImg:LoadScene()
  if self.sceneLoaded ~= nil then
    self.sceneLoaded.gameObject:SetActive(true)
    return
  end
  if self.sceneLoading ~= nil then
    return
  end
  local scenePath = self.data.prefabPath
  local request = ResourceManager:InstantiateAsync(scenePath)
  self.sceneLoading = request
  request:completed("+", function()
    if request.isError then
      self.sceneLoading = nil
      return
    end
    self.sceneLoaded = request
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    request.gameObject.transform:Set_position(self.defaultScenePos.x, self.defaultScenePos.y, self.defaultScenePos.z)
    if self.data.loadFinish then
      self.data.loadFinish()
    end
    self.simpleAnimation = request.gameObject.transform:GetComponentInChildren(typeof(CS.SimpleAnimation))
    local camera = request.gameObject.transform:Find("Camera"):GetComponentInChildren(typeof(Camera))
    self.sceneCamera = camera
    if camera ~= nil then
      camera.gameObject:SetActive(true)
      if self:OnRenderTexture(camera) then
      end
    end
  end)
end

function CommonTexImg:OnRenderTexture(camera)
  if camera == nil then
    return false
  end
  self.sceneCamera = camera
  if self.renderTexture == nil then
    local rtWidth = self.rtWidth
    local rtHeight = self.rtHeight
    local rtFormat = RenderTextureFormat.ARGB32
    self.renderTexture = RenderTexture.GetTemporary(rtWidth, rtHeight, 24, rtFormat)
    self.renderTexture.name = "CommonTexImg"
    self.rawImage:SetTexture(self.renderTexture)
    self.rawImage:SetEnable(true)
    self.rawImage:SetColor(Color.New(1, 1, 1, 1))
  end
  self.sceneCamera.targetTexture = self.renderTexture
  return true
end

function CommonTexImg:ReleaseTexture()
  self.rawImage:SetTexture(nil)
  if self.sceneCamera ~= nil then
    self.sceneCamera.targetTexture = nil
  end
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
end

function CommonTexImg:Play(name)
  if self.simpleAnimation then
    if self.simpleAnimation:IsPlaying(name) then
      self.simpleAnimation:Rewind(name)
    else
      self.simpleAnimation:Play(name)
    end
  end
end

function CommonTexImg:PlayQueued(name)
  if self.simpleAnimation then
    self.simpleAnimation:PlayQueued(name)
  end
end

CommonTexImg.OnCreate = OnCreate
CommonTexImg.OnDestroy = OnDestroy
CommonTexImg.OnEnable = OnEnable
CommonTexImg.OnDisable = OnDisable
CommonTexImg.ComponentDefine = ComponentDefine
CommonTexImg.ComponentDestroy = ComponentDestroy
CommonTexImg.DataDefine = DataDefine
CommonTexImg.DataDestroy = DataDestroy
return CommonTexImg
