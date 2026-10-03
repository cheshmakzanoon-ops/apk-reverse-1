local RTCtrl = BaseClass("RTCtrl")
local QualitySettingUtil = require("Util.QualitySettingUtil")
local CameraCpt = typeof(CS.UnityEngine.Camera)
local DirectorCpt = typeof(CS.UnityEngine.Playables.PlayableDirector)
local AnimatorCpt = typeof(CS.UnityEngine.Animator)
local RenderTexture = CS.UnityEngine.RenderTexture
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local Resource = CS.GameEntry.Resource
local PREFAB_REQ_INSTANCE_ID = 0

function RTCtrl:__init(instanceId)
end

function RTCtrl:__delete()
  self:Clear()
end

function RTCtrl:Create(instanceId)
  self.instanceId = instanceId
end

RTCtrl.NodeKey = {Model = "Model"}
RTCtrl.ResolutionWidth = {
  High = DefaultScreenWidth,
  Middle = DefaultScreenWidth,
  Low = 512
}

function RTCtrl:Clear()
  PREFAB_REQ_INSTANCE_ID = 0
  if self.prefabReqMap then
    for k, v in pairs(self.prefabReqMap) do
      if v then
        v:Destroy()
        self.prefabReqMap[k] = nil
      end
    end
  end
  self.prefabReqMap = nil
  if self.loadBufferMap then
    for i, v in pairs(self.loadBufferMap) do
      if v then
        if v.req then
          v.req:Destroy()
        end
        if v.lastReq then
          v.lastReq:Destroy()
        end
        v.onModelLoadCompleteHandler = nil
        v.nodePath = nil
        v.resPath = nil
      end
    end
    self.loadBufferMap = nil
  end
  self.onRenderHandler = nil
  self.onLoadSceneHandler = nil
  if self.rtScene then
    self:CameraRendering(nil)
    RTManager:GetInstance():RecycleRTScene(self.rtScene)
    self.rtScene = nil
  end
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
  self.lastLoadScenePath = nil
  self.scenePath = nil
  self.texParam = nil
  self.sceneParam = nil
  self.customCamera = nil
end

function RTCtrl:Init(param)
  if param == nil then
    Logger.LogError("param is nil")
    return
  end
  if param.scenePath == nil then
    Logger.LogError("Must input scenePath to create scene!")
    return
  end
  if param.onRenderHandler == nil then
    Logger.LogError("Must input onRenderHandler to render raw image!")
    return
  end
  if self.lastLoadScenePath and self.lastLoadScenePath == param.scenePath then
    return
  end
  self:Clear()
  self.loadBufferMap = {}
  self.scenePath = param.scenePath
  self.sceneParam = param.sceneParam
  self.texParam = param.texParam
  if self.texParam == nil then
    self.texParam = RTUtils.GetDefaultRenderTextureParam()
  end
  self.onRenderHandler = param.onRenderHandler
  self.onLoadSceneHandler = param.onLoadSceneHandler
  self.rtScene = RTManager:GetInstance():GetRTScene()
  self.rtScene:Init(param.scenePath, param.sceneParam, function(status)
    self:OnSceneLoad(status)
  end)
  self.texParam.rtFormat = self.texParam.rtFormat or RenderTextureFormat.ARGB32
  self.texParam.rtDepthBuffer = self.texParam.rtDepthBuffer or 24
  self:ResolutionAdaptive()
end

function RTCtrl:Show()
  if self.rtScene then
    self.rtScene:Show()
  end
  if self.rtScene:IsLoaded() then
    local camera = self:GetRenderCamera()
    if camera then
      camera.enabled = true
    end
  end
end

function RTCtrl:Hide()
  if self.rtScene then
    self.rtScene:Hide()
  end
  local camera = self:GetRenderCamera()
  if camera then
    camera.enabled = false
  end
end

function RTCtrl:LoadScene()
  if self.lastLoadScenePath and self.lastLoadScenePath == self.scenePath then
    return
  end
  self.lastLoadScenePath = self.scenePath
  if self.rtScene then
    self.rtScene:Load()
  end
end

function RTCtrl:OnSceneLoad(status)
  if status == true then
    self:InitScene()
    self:LoadBuffer()
    self:Rendering()
  end
  if self.onLoadSceneHandler then
    self.onLoadSceneHandler(status)
  end
end

function RTCtrl:LoadBuffer()
  for i, v in pairs(self.loadBufferMap) do
    if v and v.startLoad == false then
      self:LoadNodeChild(v.nodePath)
    end
  end
end

function RTCtrl:ChangeModel(path, onModelLoadCompleteHandler)
  self:ChangeNodeChild(RTCtrl.NodeKey.Model, path, onModelLoadCompleteHandler)
end

function RTCtrl:ChangeNodeChild(nodePath, resPath, onModelLoadCompleteHandler)
  if string.IsNullOrEmpty(resPath) then
    Logger.LogError("resPath is nil or empty." .. tostring(resPath))
    return
  end
  if self.rtScene and self.rtScene:IsLive() and not self:GetSceneNode(nodePath) then
    return
  end
  local lastParam = self.loadBufferMap[nodePath]
  if lastParam and resPath == lastParam.resPath then
    return
  end
  self:RegisterNodeChildLoadBuffer(nodePath, resPath, onModelLoadCompleteHandler)
  if not self.rtScene or not self.rtScene:IsLive() then
    return
  end
  self:LoadNodeChild(nodePath)
end

function RTCtrl:RegisterNodeChildLoadBuffer(nodePath, resPath, onModelLoadCompleteHandler)
  local buffer = self.loadBufferMap[nodePath]
  if buffer then
    if buffer.lastReq then
      buffer.lastReq:Destroy()
    end
    buffer.lastReq = buffer.req
  else
    buffer = {}
  end
  buffer.nodePath = nodePath
  buffer.resPath = resPath
  buffer.onModelLoadCompleteHandler = onModelLoadCompleteHandler
  buffer.startLoad = false
  self.loadBufferMap[nodePath] = buffer
end

function RTCtrl:LoadNodeChild(nodePath)
  local loadBuffer = self.loadBufferMap[nodePath]
  loadBuffer.req = Resource:InstantiateAsync(loadBuffer.resPath)
  loadBuffer.startLoad = true
  loadBuffer.req:completed("+", function(request)
    local gameObject = request.gameObject
    if IsNull(gameObject) then
      if loadBuffer.onModelLoadCompleteHandler then
        loadBuffer.onModelLoadCompleteHandler(false, nil)
      end
      return
    end
    if loadBuffer.lastReq then
      loadBuffer.lastReq:Destroy()
      loadBuffer.lastReq = nil
    end
    gameObject:SetActive(true)
    local transform = gameObject.transform
    if not (self.rtScene and self.rtScene:IsLoaded()) or not self:GetSceneNode(nodePath) then
      Logger.LogError("Req \230\178\161\230\156\137\232\162\171\230\173\163\231\161\174\233\135\138\230\148\190\239\188\140\229\156\186\230\153\175\228\184\141\229\173\152\229\156\168")
      loadBuffer.req:Destroy()
      loadBuffer.req = nil
      loadBuffer.startLoad = false
      if loadBuffer.onModelLoadCompleteHandler then
        loadBuffer.onModelLoadCompleteHandler(false, nil)
        loadBuffer.onModelLoadCompleteHandler = nil
      end
      return
    end
    local node = self:GetSceneNode(nodePath)
    local parent = node.transform
    transform:SetParent(parent)
    transform:Set_localPosition(0, 0, 0)
    transform:Set_localScale(1, 1, 1)
    transform:Set_localEulerAngles(0, 0, 0)
    if loadBuffer.onModelLoadCompleteHandler then
      loadBuffer.onModelLoadCompleteHandler(true, gameObject)
      loadBuffer.onModelLoadCompleteHandler = nil
    end
  end)
end

function RTCtrl:AddPrefab(assetPath, parentPath, onLoadComplete, instanceId)
  if not self.rtScene or not self.rtScene:IsLive() then
    return
  end
  if not self.prefabReqMap then
    self.prefabReqMap = {}
  end
  if not instanceId then
    PREFAB_REQ_INSTANCE_ID = PREFAB_REQ_INSTANCE_ID + 1
    instanceId = PREFAB_REQ_INSTANCE_ID
  end
  if self.prefabReqMap[instanceId] then
    self.prefabReqMap[instanceId]:Destroy()
  end
  self.prefabReqMap[instanceId] = self:LoadPrefab(instanceId, assetPath, parentPath, onLoadComplete)
  return instanceId
end

function RTCtrl:RemovePrefab(instanceId)
  local result = false
  if self.prefabReqMap and self.prefabReqMap[instanceId] then
    self.prefabReqMap[instanceId]:Destroy()
    self.prefabReqMap[instanceId] = nil
    result = true
  end
  return result
end

function RTCtrl:TryGetPrefab(instanceId)
  if self.prefabReqMap and self.prefabReqMap[instanceId] and self.prefabReqMap[instanceId].isDone then
    return true, self.prefabReqMap[instanceId].gameObject
  end
  Logger.LogWarning("\228\189\160\230\152\175\228\184\141\230\152\175\228\188\160\233\148\153Id\228\186\134\229\174\157\232\180\157\239\188\159")
  return false
end

function RTCtrl:LoadPrefab(instanceId, assetPath, parentPath, onLoadComplete)
  local request = Resource:InstantiateAsync(assetPath)
  request:completed("+", function(_request)
    local gameObject = _request.gameObject
    if IsNull(gameObject) then
      if onLoadComplete then
        onLoadComplete(false, instanceId)
      end
      return
    end
    gameObject:SetActive(true)
    local transform = gameObject.transform
    local root = self:GetSceneRoot()
    if root then
      local isCustomParent = false
      if not string.IsNullOrEmpty(parentPath) then
        local parent = root.transform:Find(parentPath)
        if parent then
          transform:SetParent(parent)
          isCustomParent = true
        end
      end
      if not isCustomParent then
        transform:SetParent(root.transform)
      end
    end
    if onLoadComplete then
      onLoadComplete(true, instanceId)
    end
  end)
  return request
end

function RTCtrl:InitScene()
  local camera = self:GetRenderCamera()
  if camera then
    camera.enabled = true
  end
end

function RTCtrl:Rendering()
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
  end
  self.renderTexture = RenderTexture.GetTemporary(self.texParam.rtWidth, self.texParam.rtHeight, self.texParam.rtDepthBuffer, self.texParam.rtFormat)
  if self.onRenderHandler then
    self.onRenderHandler(self.renderTexture)
  end
  self:CameraRendering(self.renderTexture)
end

function RTCtrl:ResolutionAdaptive()
  local rtWidth = self.texParam.containerWidth
  local rtHeight = self.texParam.containerHeight
  if not Config.IsPC() and not CS.SDKManager.IS_UNITY_EDITOR() then
    local anchorMin = self.texParam.containerAnchorMin
    local anchorMax = self.texParam.containerAnchorMax
    if anchorMin.x == 0 and anchorMin.y == 0 and anchorMax.x == 1 and anchorMax.y == 1 then
      local ratio = self.texParam.containerHeight / self.texParam.containerWidth
      local limit = self:GetDeviceQualityLimit()
      rtWidth = math.min(rtWidth, limit.rtWidth)
      rtHeight = rtWidth * ratio
    end
  end
  self.texParam.rtWidth = math.ceil(rtWidth)
  self.texParam.rtHeight = math.ceil(rtHeight)
  self.texParam.rtFormat = self.texParam.rtFormat or RenderTextureFormat.ARGB32
  self.texParam.rtDepthBuffer = self.texParam.rtDepthBuffer or 24
end

function RTCtrl:GetDeviceQualityLimit()
  local quality = QualitySettingUtil.GetCurrentGraphicLevel()
  local limit = {}
  limit.rtWidth = RTCtrl.ResolutionWidth.Low
  if quality == EnumQualityLevel.High then
    limit.rtWidth = RTCtrl.ResolutionWidth.High
  elseif quality == EnumQualityLevel.Middle then
    limit.rtWidth = RTCtrl.ResolutionWidth.Middle
  else
    limit.rtWidth = RTCtrl.ResolutionWidth.Low
  end
  return limit
end

function RTCtrl:SetCustomCamera(camera)
  if camera == nil then
    Logger.LogError("Set camera is nil !")
    return
  end
  self.customCamera = camera
end

function RTCtrl:GetRenderCamera()
  return self:GetSceneNodeComponent(CameraCpt, self.sceneParam.cameraPath)
end

function RTCtrl:CameraRendering(renderTex)
  local camera = self:GetRenderCamera()
  if camera then
    camera.targetTexture = renderTex
  end
end

function RTCtrl:GetAnimator()
  if self.rtScene and self.rtScene:IsLive() then
    return self.sceneAnimator
  end
  return nil
end

function RTCtrl:GetSceneModel()
  return self:GetSceneNode(RTCtrl.NodeKey.Model)
end

function RTCtrl:GetSceneRoot()
  if self.rtScene then
    return self.rtScene:GetRoot()
  end
end

function RTCtrl:GetSceneNode(path)
  if self.rtScene then
    return self.rtScene:GetNode(path)
  end
end

function RTCtrl:GetSceneNodeComponent(cpt, path)
  if not self.rtScene or not self.rtScene:IsLoaded() then
    return
  end
  if string.IsNullOrEmpty(path) then
    return self.rtScene:GetComponentInAllNode(cpt)
  else
    return self.rtScene:GetComponentInNode(path, cpt)
  end
end

function RTCtrl:IsSceneLoaded(path)
  if not string.IsNullOrEmpty(path) and path == self.scenePath and self.rtScene then
    return self.rtScene:IsLoaded()
  end
  return false
end

return RTCtrl
