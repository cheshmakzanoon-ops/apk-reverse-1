local SurfingScenePool = BaseClass("SurfingScenePool")
local Resource = CS.GameEntry.Resource
local Constant = require("Scene.LWHummerScene.LWHummerSceneConstant")

function SurfingScenePool:__init()
  self.pool = {}
  self.activeScenes = {}
  self.totalToLoad = 0
  self.loadedCount = 0
  self.isPreloadComplete = false
end

function SurfingScenePool:__delete()
  self:OnDestroy()
end

function SurfingScenePool:OnDestroy()
  self:ClearAllScenes()
end

function SurfingScenePool:ClearAllScenes()
  local function clearTable(t)
    for _, requests in pairs(t) do
      for _, req in ipairs(requests) do
        req:Destroy()
      end
    end
  end
  
  clearTable(self.pool)
  clearTable(self.activeScenes)
  self.pool = {}
  self.activeScenes = {}
  self.totalToLoad = 0
  self.loadedCount = 0
  self.isPreloadComplete = false
end

function SurfingScenePool:_initSceneLoad(sceneId, callback)
  local sceneMeta = DataCenter.LWSceneTemplateManager:GetTemplate(sceneId)
  if not sceneMeta then
    Logger.LogError("\229\156\186\230\153\175\233\133\141\231\189\174\230\156\170\230\137\190\229\136\176 id:" .. sceneId)
    return nil
  end
  local assetPath = string.format(Constant.PVEScenePath, sceneMeta.asset)
  local req = Resource:InstantiateAsync(assetPath)
  req:completed("+", function(request)
    if not request or IsNull(request.gameObject) then
      return
    end
    local sceneObj = request.gameObject
    sceneObj.name = "SurfingScenePool " .. sceneId
    sceneObj:SetActive(false)
    callback(request)
  end)
  return req
end

function SurfingScenePool:PreloadScenes(sceneIds, onComplete)
  self.isPreloadComplete = false
  self.totalToLoad = 0
  self.loadedCount = 0
  for _, sceneId in ipairs(sceneIds) do
    if self.pool[sceneId] == nil then
      self.totalToLoad = self.totalToLoad + 1
      self:_initSceneLoad(sceneId, function(req)
        self:_addToPool(sceneId, req)
        self.loadedCount = self.loadedCount + 1
        self:_checkCompletion(onComplete)
      end)
    end
  end
  if self.totalToLoad == 0 then
    self.isPreloadComplete = true
    if onComplete then
      onComplete()
    end
    return
  end
end

function SurfingScenePool:_addToPool(sceneId, req)
  if not req or IsNull(req.gameObject) then
    return
  end
  self.pool[sceneId] = self.pool[sceneId] or {}
  table.insert(self.pool[sceneId], req)
end

function SurfingScenePool:_addToActiveList(sceneId, req)
  if not req or IsNull(req.gameObject) then
    return
  end
  self.activeScenes[sceneId] = self.activeScenes[sceneId] or {}
  table.insert(self.activeScenes[sceneId], req)
end

function SurfingScenePool:_checkCompletion(onComplete)
  if self.loadedCount >= self.totalToLoad then
    self.isPreloadComplete = true
    if onComplete then
      onComplete()
    end
  end
end

function SurfingScenePool:GetScene(sceneId, onGetSceneCallback)
  if not self.pool[sceneId] or #self.pool[sceneId] == 0 then
    local req = self:_initSceneLoad(sceneId, function(request)
      self:_activateScene(request)
      self:_addToActiveList(sceneId, request)
      if onGetSceneCallback then
        onGetSceneCallback(request)
      end
    end)
    return req
  end
  local req = table.remove(self.pool[sceneId], 1)
  self:_activateScene(req)
  self:_addToActiveList(sceneId, req)
  if onGetSceneCallback then
    onGetSceneCallback(req)
  end
  return req
end

function SurfingScenePool:ReleaseScene(sceneId, req)
  if not req or IsNull(req.gameObject) or not sceneId then
    return
  end
  self:_deactivateScene(req)
  if self.activeScenes[sceneId] then
    table.removebyvalue(self.activeScenes[sceneId], req)
  end
  self:_addToPool(sceneId, req)
end

function SurfingScenePool:_activateScene(req)
  if not req or IsNull(req.gameObject) then
    return
  end
  local sceneObj = req.gameObject
  sceneObj:SetActive(true)
end

function SurfingScenePool:_deactivateScene(req)
  if not req or IsNull(req.gameObject) then
    return
  end
  local sceneObj = req.gameObject
  sceneObj:SetActive(false)
  sceneObj.transform.position = CS.UnityEngine.Vector3.zero
end

function SurfingScenePool:IsPreloadComplete()
  return self.isPreloadComplete
end

return SurfingScenePool
