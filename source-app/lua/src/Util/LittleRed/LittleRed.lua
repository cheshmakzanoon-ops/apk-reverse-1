local LittleRed = BaseClass("LittleRed")

local function _SetParent(self, parent)
  self.parent = parent
  if not parent then
    return
  end
  if not parent.children then
    parent.children = {}
  end
  table.insert(parent.children, self)
end

local function _SetCount(self, count, quiet)
  if self.redCount == count then
    return false
  end
  self.redCount = count
  self.totalCount = self.redCount + self.childrenRedCount
  if self.parent then
    self.parent:RefreshCount()
  end
  if quiet then
    return true
  end
  self.Notice(self)
  return true
end

local function _AddListener(self, handle, callback)
  if not self.listeners then
    self.listeners = {}
  end
  self.listeners[callback] = handle
end

local function _RemoveListener(self, token)
  if not self.listeners then
    return
  end
  for k, v in pairs(self.listeners) do
    if v == token or k == token then
      self.listeners[k] = nil
    end
  end
end

function LittleRed:__init(name, parent)
  self.parent = nil
  self.children = nil
  self.name = name
  self.redCount = 0
  self.childrenRedCount = 0
  self.totalCount = 0
  self.listeners = nil
  self.rootChildTable = parent and parent.rootChildTable or {}
  self.rootChildTable[name] = self
  _SetParent(self, parent)
end

function LittleRed:__delete()
  self.parent = nil
  self.children = nil
  self.name = nil
  self.redCount = nil
  self.childrenRedCount = nil
  self.totalCount = nil
  self.listeners = nil
  self.rootChildTable = nil
end

function LittleRed:GetChild(name)
  return self.rootChildTable and self.rootChildTable[name]
end

function LittleRed:RefreshCount()
  self.childrenRedCount = 0
  if self.children then
    for k, v in ipairs(self.children) do
      self.childrenRedCount = self.childrenRedCount + v.totalCount
    end
  end
  self.totalCount = self.redCount + self.childrenRedCount
  if self.parent then
    self.parent:RefreshCount()
  end
end

function LittleRed:SetCount(childName, count, quiet)
  if not childName then
    return _SetCount(self, count, quiet)
  else
    local red = self.rootChildTable[childName]
    if red then
      return _SetCount(red, count, quiet)
    end
  end
end

function LittleRed:GetCount(childName)
  if not childName then
    return self.totalCount
  end
  local red = self.rootChildTable[childName]
  return red and red.totalCount or 0
end

function LittleRed:Notice()
  if self.listeners then
    for k, v in pairs(self.listeners) do
      if k then
        k(v, self.totalCount)
      end
    end
  end
  if not self.parent then
    return
  end
  self.parent:Notice()
end

function LittleRed:AddListener(childName, handle, callback)
  if not childName then
    _AddListener(self, handle, callback)
  else
    local red = self.rootChildTable[childName]
    if red then
      _AddListener(red, handle, callback)
    end
  end
end

function LittleRed:RemoveListener(token)
  if self.rootChildTable then
    for k, v in pairs(self.rootChildTable) do
      _RemoveListener(v, token)
    end
  end
end

function LittleRed:Description(replaceHolder)
  replaceHolder = replaceHolder or ""
  local sb = StringBuilder.New()
  sb:AppendFormatLine("%s-%s, \231\186\162\231\130\185\230\128\187\230\149\176:%s(%s + %s), \231\155\145\229\144\172\230\149\176:%s, \229\173\144\232\138\130\231\130\185\230\149\176:%s", replaceHolder, self.name, self.totalCount, self.redCount, self.childrenRedCount, self.listeners and table.count(self.listeners) or 0, self.children and #self.children or 0)
  if self.children then
    for k, v in ipairs(self.children) do
      sb:AppendFormat(v:Description(replaceHolder .. "\t"))
    end
  end
  return sb:ToString()
end

return LittleRed
