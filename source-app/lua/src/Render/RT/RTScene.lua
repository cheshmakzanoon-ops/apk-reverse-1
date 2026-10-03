local RTScene = BaseClass("RTScene")
local Resource = CS.GameEntry.Resource

function RTScene:__init()
end

function RTScene:__delete()
  self:Clear()
end

function RTScene:Clear()
  self.nodeMap = nil
  self.nodeCptMap = nil
  if self.param then
    for k, v in pairs(self.param) do
      self.param[k] = nil
    end
  end
  self.param = nil
  self.onLoadComplete = nil
  if self.resRootLoadReq then
    self.resRootLoadReq:Destroy()
    self.resRootLoadReq = nil
  end
  self.resRoot = nil
  self.active = nil
  self.isLoaded = nil
end

function RTScene:Init(scenePath, param, onLoadSceneHandler)
  self.resRootPath = scenePath
  if string.IsNullOrEmpty(self.resRootPath) then
    return
  end
  self.nodeMap = {}
  self.nodeCptMap = {}
  self.param = param
  self.param.resParent = param.resParent
  self.param.resPos = param.resPos or ResetPosition
  self.param.resAngles = param.resAngles or ResetEulerAngles
  self.param.resScale = param.resScale or ResetScale
  self.onLoadComplete = onLoadSceneHandler
end

function RTScene:Show()
  self.active = true
  if self.resRoot then
    self.resRoot:SetActive(self.active)
  end
end

function RTScene:Hide()
  self.active = false
  if self.resRoot then
    self.resRoot:SetActive(self.active)
  end
end

function RTScene:Load()
  self.resRootLoadReq = Resource:InstantiateAsync(self.resRootPath)
  self.resRootLoadReq:completed("+", function(request)
    local gameObject = request.gameObject
    if IsNull(gameObject) then
      if self.onLoadComplete then
        self.onLoadComplete(false)
      end
      return
    end
    self.isLoaded = true
    gameObject:SetActive(self.active)
    local transform = gameObject.transform
    if self.resRootParent then
      transform:SetParent(self.param.resParent)
    end
    transform.localPosition = self.param.resPos
    transform.localRotation = Quaternion.Euler(self.param.resAngles.x, self.param.resAngles.y, self.param.resAngles.z)
    transform.localScale = self.param.resScale
    self.resRoot = gameObject
    self:OnLoaded()
  end)
end

function RTScene:OnLoaded()
  if self.onLoadComplete then
    self.onLoadComplete(true)
  end
end

function RTScene:GetRoot()
  return self.resRoot
end

function RTScene:GetNode(path)
  if self.resRoot and not string.IsNullOrEmpty(path) and not self.nodeMap[path] then
    local transform = self.resRoot.transform:Find(path)
    if transform then
      local node = transform.gameObject
      self.nodeMap[path] = node
    end
  end
  if not self.nodeMap[path] then
    Logger.LogError("Not:" .. path .. " resRoot nil?:" .. tostring(self.resRoot == nil) .. "  scenePath:" .. self.resRootPath .. "  isLoad:" .. self.isLoaded .. "   isActive:" .. tostring(self.active))
  end
  return self.nodeMap[path]
end

function RTScene:GetComponentInNode(path, cpt)
  if self.resRoot and not string.IsNullOrEmpty(path) and not self.nodeCptMap[path] then
    local node = self:GetNode(path)
    if node then
      local nodeCpt = node:GetComponent(cpt)
      self.nodeCptMap[path] = nodeCpt
    end
  end
  if not self.nodeCptMap[path] then
    Logger.LogError("not find node cpt in path:" .. path)
  end
  return self.nodeCptMap[path]
end

function RTScene:GetComponentInAllNode(cpt)
  if self.resRoot then
    return self.resRoot:GetComponentInChildren(cpt, true)
  end
end

function RTScene:IsActive()
  return self.active
end

function RTScene:IsLoaded()
  return self.isLoaded
end

function RTScene:IsLive()
  return self:IsActive() and self:IsLoaded()
end

return RTScene
