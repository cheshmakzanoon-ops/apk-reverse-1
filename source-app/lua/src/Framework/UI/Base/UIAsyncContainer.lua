local base = UIBaseContainer
local UIAsyncContainer = BaseClass("UIAsyncContainer", base)
local ResourceManager = CS.GameEntry.Resource

function UIAsyncContainer:__init(holder, transform, prefabPath, callback, callback_param, var_arg)
  local request = ResourceManager:InstantiateAsync(prefabPath)
  request:completed("+", function()
    if request.isError or transform == nil or IsNull(transform) then
      return
    end
    local initActiveSelf = self.initActiveSelf ~= false
    local go = request.gameObject
    if CommonUtil and CommonUtil.IsArabicAutoMirrorOpen() and not request.isUseCache then
      CS.ArabicMirror.MirrorEntry(true, true, go)
    end
    if type(self.__name) == "string" then
      go.name = self.__name
    end
    local trans = go.transform
    trans:SetParent(transform)
    if self.cacheLocalScaleV3 ~= nil then
      trans:Set_localScale(self.cacheLocalScaleV3.x, self.cacheLocalScaleV3.y, self.cacheLocalScaleV3.z)
      self.cacheLocalScaleV3 = nil
    else
      trans:Set_localScale(1, 1, 1)
    end
    if self.cacheLocalPositionV3 ~= nil then
      trans:Set_localPosition(self.cacheLocalPositionV3.x, self.cacheLocalPositionV3.y, self.cacheLocalPositionV3.z)
      self.cacheLocalPositionV3 = nil
    else
      trans:Set_localPosition(0, 0, 0)
    end
    if self.cacheSizeDeltaV2 ~= nil then
      trans:Set_sizeDelta(self.cacheSizeDeltaV2.x, self.cacheSizeDeltaV2.y)
      self.cacheSizeDeltaV2 = nil
    end
    if self._cacheSiblingSetAsFirst then
      trans:SetAsFirstSibling()
      self._cacheSiblingSetAsFirst = nil
    elseif self._cacheSiblingSetAsLast then
      trans:SetAsLastSibling()
      self._cacheSiblingSetAsLast = nil
    elseif self._cacheSiblingIndex ~= nil then
      trans:SetSiblingIndex(toInt(self._cacheSiblingIndex))
      self._cacheSiblingIndex = nil
    end
    trans:Set_localRotation(0, 0, 0, 1)
    base.Reinit(self, holder, go)
    self.initActiveSelf = initActiveSelf
    self:OnCreate(var_arg)
    if go.activeSelf then
      self:OnEnable()
    end
    self:UpdateData()
    EventManager:GetInstance():BroadcastDeferred(EventId.UIAsyncLoadDynamicPrefabFinish)
    if callback ~= nil and type(callback) == "function" then
      CommonUtil.ProtectCall(function()
        callback(holder, go, self, callback_param)
      end)
    end
  end)
  self.holder = holder
  if holder then
    self.view = holder.view
  end
  self.request = request
end

function UIAsyncContainer:__delete()
  if self.gameObject ~= nil then
    self:OnDisable()
    self:OnDestroy()
    self:__OnFrameworkDestroy()
  end
  if self.request then
    self.request:Destroy()
    self.request = nil
  end
  self.holder = nil
  self.view = nil
end

function UIAsyncContainer:SetName(name)
  if name then
    self.__name = name
    if GameObjectIsValid(self.gameObject) then
      self.gameObject.name = name
    end
  end
end

function UIAsyncContainer:GetActiveInHierarchy()
  return base.GetActiveInHierarchy(self)
end

local lua_type = type

function UIAsyncContainer:OldGetActiveInHierarchy()
  local activeCached = self.activeCached
  if activeCached ~= nil then
    return activeCached
  end
  if self.holder and self.holder.activeInHierarchy ~= nil then
    activeCached = self.holder.activeSelf and self.holder.activeInHierarchy
  else
    activeCached = self.activeSelf and (self.holder == nil or lua_type(self.holder.GetActiveInHierarchy) == "function" and self.holder:GetActiveInHierarchy())
  end
  self.activeCached = activeCached
  return activeCached
end

function UIAsyncContainer:UpdateData()
end

function UIAsyncContainer:RefreshView()
  if IsNotNull(self.gameObject) then
    self:UpdateData()
  end
end

function UIAsyncContainer:AsyncLoadDone()
  return GameObjectIsValid(self.gameObject)
end

function UIAsyncContainer:GetSizeDelta()
  if self:AsyncLoadDone() then
    return base.GetSizeDelta(self)
  end
  if self.cacheSizeDeltaV2 == nil then
    return Vector2.New(0, 0)
  end
  return self.cacheSizeDeltaV2
end

function UIAsyncContainer:SetSizeDelta(value)
  if self:AsyncLoadDone() then
    base.SetSizeDelta(self, value)
  elseif self.cacheSizeDeltaV2 == nil then
    self.cacheSizeDeltaV2 = Vector2.New(value.x, value.y)
  else
    self.cacheSizeDeltaV2:Set(value.x, value.y)
  end
end

function UIAsyncContainer:GetSizeDeltaXY()
  if self:AsyncLoadDone() then
    return base.GetSizeDeltaXY(self)
  end
  if self.cacheSizeDeltaV2 == nil then
    return 0, 0
  end
  return self.cacheSizeDeltaV2.x, self.cacheSizeDeltaV2.y
end

function UIAsyncContainer:SetSizeDeltaXY(x, y)
  if self:AsyncLoadDone() then
    base.SetSizeDeltaXY(self, x, y)
  elseif self.cacheSizeDeltaV2 == nil then
    self.cacheSizeDeltaV2 = Vector2.New(x, y)
  else
    self.cacheSizeDeltaV2:Set(x, y)
  end
end

function UIAsyncContainer:SetLocalPositionXYZ(x, y, z, skipArabicMirror)
  if self:AsyncLoadDone() then
    base.SetLocalPositionXYZ(self, x, y, z, skipArabicMirror)
  elseif self.cacheLocalPositionV3 == nil then
    self.cacheLocalPositionV3 = Vector3.New(x, y, z)
  else
    self.cacheLocalPositionV3:Set(x, y, z)
  end
end

function UIAsyncContainer:GetLocalPositionXYZ(skipArabicMirror)
  if self:AsyncLoadDone() then
    return base.GetLocalPositionXYZ(self, skipArabicMirror)
  end
  if self.cacheLocalPositionV3 == nil then
    return 0, 0, 0
  end
  return self.cacheLocalPositionV3.x, self.cacheLocalPositionV3.y, self.cacheLocalPositionV3.z
end

function UIAsyncContainer:SetLocalPosition(v, skipArabicMirror)
  if self:AsyncLoadDone() then
    base.SetLocalPosition(self, v, skipArabicMirror)
  elseif self.cacheLocalPositionV3 == nil then
    self.cacheLocalPositionV3 = Vector3.New(v.x, v.y, v.z)
  else
    self.cacheLocalPositionV3:Set(v.x, v.y, v.z)
  end
end

function UIAsyncContainer:GetLocalPosition(skipArabicMirror)
  if self:AsyncLoadDone() then
    return base.GetLocalPosition(self, skipArabicMirror)
  end
  if self.cacheLocalPositionV3 == nil then
    return Vector3.New(0, 0, 0)
  end
  return self.cacheLocalPositionV3
end

function UIAsyncContainer:SetLocalScaleXYZ(x, y, z)
  if self:AsyncLoadDone() then
    base.SetLocalScaleXYZ(self, x, y, z)
  elseif self.cacheLocalScaleV3 == nil then
    self.cacheLocalScaleV3 = Vector3.New(x, y, z)
  else
    self.cacheLocalScaleV3:Set(x, y, z)
  end
end

function UIAsyncContainer:GetLocalScaleXYZ()
  if self:AsyncLoadDone() then
    return base.GetLocalScaleXYZ(self)
  end
  if self.cacheLocalScaleV3 == nil then
    return 0, 0, 0
  end
  return self.cacheLocalScaleV3.x, self.cacheLocalScaleV3.y, self.cacheLocalScaleV3.z
end

function UIAsyncContainer:SetLocalScale(v)
  if self:AsyncLoadDone() then
    base.SetLocalScale(self, v)
  elseif self.cacheLocalScaleV3 == nil then
    self.cacheLocalScaleV3 = Vector3.New(v.x, v.y, v.z)
  else
    self.cacheLocalScaleV3:Set(v.x, v.y, v.z)
  end
end

function UIAsyncContainer:GetLocalScale()
  if self:AsyncLoadDone() then
    return base.GetLocalScale(self)
  end
  if self.cacheLocalScaleV3 == nil then
    return Vector3.New(0, 0, 0)
  end
  return self.cacheLocalScaleV3
end

function UIAsyncContainer:SetAsFirstSibling()
  if self:AsyncLoadDone() then
    self.transform:SetAsFirstSibling()
  else
    self._cacheSiblingSetAsFirst = true
    self._cacheSiblingSetAsLast = nil
    self._cacheSiblingIndex = nil
  end
end

function UIAsyncContainer:SetAsLastSibling()
  if self:AsyncLoadDone() then
    self.transform:SetAsLastSibling()
  else
    self._cacheSiblingSetAsFirst = nil
    self._cacheSiblingSetAsLast = true
    self._cacheSiblingIndex = nil
  end
end

function UIAsyncContainer:SetSiblingIndex(index)
  if self:AsyncLoadDone() then
    self.transform:SetSiblingIndex(index)
  else
    self._cacheSiblingSetAsFirst = nil
    self._cacheSiblingSetAsLast = nil
    self._cacheSiblingIndex = index
  end
end

return UIAsyncContainer
