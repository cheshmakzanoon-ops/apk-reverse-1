local LazyComponentProxy = {}
local internalKeys = {
  _proxyType = true,
  owner = true,
  componentType = true,
  component = true,
  isCreated = true,
  isActive = true,
  cachedCalls = true,
  cachedProperties = true,
  createArgs = true
}

function LazyComponentProxy:new(owner, componentType, ...)
  local obj = {
    _proxyType = "LazyComponentProxy",
    owner = owner,
    componentType = componentType,
    createArgs = {
      ...
    },
    component = nil,
    isCreated = false,
    isActive = nil,
    cachedCalls = {},
    cachedProperties = {}
  }
  local proxyMeta = {
    __index = function(proxy, key)
      if internalKeys[key] then
        return rawget(obj, key)
      end
      local proxyMethod = LazyComponentProxy[key]
      if proxyMethod then
        return function(self, ...)
          return proxyMethod(obj, ...)
        end
      end
      if obj.cachedProperties[key] ~= nil then
        return obj.cachedProperties[key]
      end
      return obj:ensureCreated()[key]
    end,
    __newindex = function(proxy, key, value)
      if internalKeys[key] then
        rawset(obj, key, value)
        return
      end
      obj.cachedProperties[key] = value
      if obj.isCreated and obj.component then
        obj.component[key] = value
      end
    end
  }
  setmetatable(obj, proxyMeta)
  return obj
end

function LazyComponentProxy:ensureCreated()
  if not self.isCreated then
    if not self.owner or not self.owner.components then
      return nil
    end
    self.component = self.owner:AddComponent(self.componentType, table.unpack(self.createArgs))
    self.isCreated = true
    for key, value in pairs(self.cachedProperties) do
      self.component[key] = value
    end
    if self.isActive ~= nil then
      self.component:SetActive(self.isActive)
    end
    for _, cachedCall in ipairs(self.cachedCalls) do
      self.component[cachedCall.method](self.component, table.unpack(cachedCall.args))
    end
    self.cachedCalls = {}
  end
  return self.component
end

function LazyComponentProxy:GetComponent()
  return self:ensureCreated()
end

function LazyComponentProxy:SetActive(active)
  self.isActive = active
  if active then
    self:ensureCreated():SetActive(active)
  elseif self.isCreated then
    self.component:SetActive(active)
  end
end

function LazyComponentProxy:SetLocalScaleXYZ(x, y, z)
  self:cacheMethodCall("SetLocalScaleXYZ", x, y, z)
end

function LazyComponentProxy:SetAnchoredPositionXY(x, y)
  self:cacheMethodCall("SetAnchoredPositionXY", x, y)
end

function LazyComponentProxy:SetSizeDeltaXY(x, y)
  self:cacheMethodCall("SetSizeDeltaXY", x, y)
end

function LazyComponentProxy:SetPivotXY(x, y)
  self:cacheMethodCall("SetPivotXY", x, y)
end

function LazyComponentProxy:SetAnchorMinXY(x, y)
  self:cacheMethodCall("SetAnchorMinXY", x, y)
end

function LazyComponentProxy:SetAnchorMaxXY(x, y)
  self:cacheMethodCall("SetAnchorMaxXY", x, y)
end

function LazyComponentProxy:cacheMethodCall(method, ...)
  if self.isCreated then
    return self.component[method](self.component, ...)
  else
    table.insert(self.cachedCalls, {
      method = method,
      args = {
        ...
      }
    })
  end
end

function LazyComponentProxy:ForceCreate()
  return self:ensureCreated()
end

function LazyComponentProxy:IsCreated()
  return self.isCreated
end

function LazyComponentProxy:IsProxy()
  return true
end

function LazyComponentProxy:OnDestroy()
  if self.isCreated and self.component then
    self.component:Delete()
  end
  self.component = nil
  self.isCreated = false
  self.cachedCalls = {}
  self.cachedProperties = {}
end

function LazyComponentProxy:Delete()
  self:OnDestroy()
end

function LazyComponentProxy:__delete()
  self:OnDestroy()
end

return LazyComponentProxy
