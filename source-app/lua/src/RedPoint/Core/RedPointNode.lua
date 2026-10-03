local RedPointNode = BaseClass("RedPointNode", CEventable)

function RedPointNode:__init(nodeName)
  self.name = nodeName
  self.callbacks = nil
  self.parent = nil
  self.depth = 0
  self.count = 0
  self.newCount = 0
  self.isSimpleCount = nil
end

function RedPointNode:__delete()
  self.count = 0
  self.newCount = 0
  self:__InternalChangeValue()
  self.callbacks = nil
  self.parent = nil
end

function RedPointNode:SetData(...)
end

function RedPointNode:GetCount()
  if self.isSimpleCount then
    return self.count > 0 and 1 or 0
  else
    return self.count
  end
end

function RedPointNode:SetCount(count)
  count = math.max(0, count or 0)
  self.newCount = count
  if self.count ~= count then
    if GMUtils.GetBool(GMConst.LogRedPointInfo, false) then
      Logger.Log("RedPointNode: SetCount type:" .. self.__cname .. " name:" .. self.name .. " count: " .. count)
    end
    self:SetDirty()
  end
end

function RedPointNode:SetCountBoolean(isShow)
  self:SetCount(isShow and 1 or 0)
end

function RedPointNode:SetCountBool(isShow)
  self:SetCountBoolean(isShow)
end

function RedPointNode:UpdateCount()
  if self.newCount ~= self.count then
    if GMUtils.GetBool(GMConst.LogRedPointInfo, false) then
      self:__LodChange()
    end
    self.count = self.newCount
    self:__InternalChangeValue()
  end
end

function RedPointNode:SetDirty()
  DataCenter.RedPointManager:MarkDirty(self)
  if self.parent then
    self.parent:SetDirty()
  end
end

function RedPointNode:Reset()
  self.newCount = 0
  self:SetDirty()
end

function RedPointNode:RemoveSelf()
  if self.parent then
    self.parent:RemoveChild(self.name)
    self.parent = nil
  end
end

function RedPointNode:OnBindParent(parent)
  self.parent = parent
  self.depth = (parent and parent.depth or 0) + 1
end

function RedPointNode:Bind(target, callback, userData_)
  if not self.callbacks then
    self.callbacks = {}
  end
  if self.callbacks[target] then
    local lastCallback = self.callbacks[target]
    lastCallback = type(lastCallback) == "table" and lastCallback.callback or lastCallback
    if lastCallback == callback then
      return
    end
    Logger.LogError("RedPointNode: Bind target already has different callback: " .. tostring(target))
  end
  self:__OnChangeValue(target, callback, userData_)
  if userData_ then
    self.callbacks[target] = {callback = callback, userData = userData_}
  else
    self.callbacks[target] = callback
  end
end

function RedPointNode:UnBind(target)
  if not self.callbacks then
    return
  end
  if self.callbacks[target] then
    self.callbacks[target] = nil
  else
    Logger.LogError("RedPointNode: UnBind target not found: " .. tostring(target))
  end
end

function RedPointNode:__InternalChangeValue()
  if not self.callbacks then
    return
  end
  for target, callback in pairs(self.callbacks) do
    if type(callback) == "table" then
      self:__OnChangeValue(target, callback.callback, callback.userData)
    else
      self:__OnChangeValue(target, callback)
    end
  end
end

function RedPointNode:__OnChangeValue(target, callback, userData_)
  if target and callback then
    callback(target, self:GetCount(), userData_, self)
  else
    Logger.LogError("RedPointNode: OnChangeValue callback or target is nil")
  end
end

function RedPointNode:__LodChange()
  local path = ""
  local currentNode = self
  while currentNode do
    path = currentNode.name .. (path == "" and "" or "/" .. path)
    currentNode = currentNode.parent
  end
  local changeStr = self.newCount - self.count
  if 0 <= changeStr then
    changeStr = "+" .. tostring(changeStr)
  end
  Logger.LogWarning(string.format("RedPointNode: __InternalChangeValue count=%d, change=%s, classType=%s, path=%s", self.newCount, changeStr, self.__cname, path))
end

return RedPointNode
