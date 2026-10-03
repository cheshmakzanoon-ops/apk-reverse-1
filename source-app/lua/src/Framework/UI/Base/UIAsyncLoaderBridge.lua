local UIAsyncLoaderBridge = BaseClass("UIAsyncLoaderBridge")

local function __recordCall(t, key, args)
  table.insert(t.__callRecords, {method = key, args = args})
end

local function __getFileNameWithoutExtension(path)
  local name = string.match(path, "([^/\\]+)%.?[^%.\\/]*$")
  name = name and name:match("^(.*)%..+$") or name
  return name
end

local function __disposeSelf(self)
  if self.__rawMetaIndex then
    setmetatable(self, {
      __index = self.__rawMetaIndex
    })
  end
  self.__master = nil
  self.__rootTransform = nil
  self.__prefabPath = nil
  self.__luaClsPath = nil
  self.__loadCallback = nil
  self.__isActive = nil
  self.__luaComp = nil
  self.__luaCompLoaded = nil
  self.__callRecords = nil
  self.__rawMetaIndex = nil
  self.__controlParentActive = nil
  self.isAsync = nil
end

local function _AsyncLoadNotDone()
  return false
end

function UIAsyncLoaderBridge:__init(master, name, rootTransform, prefabPath, luaClsPath, controlParentActive, loadCallback)
  self.__master = master
  self.__rootTransform = rootTransform
  self.__prefabPath = prefabPath
  self.__luaClsPath = luaClsPath
  self.__loadCallback = loadCallback
  self.__controlParentActive = controlParentActive
  self.isAsync = true
  self.__name = name
  if CommonUtil.IsEditor() then
    self.__prefabName = __getFileNameWithoutExtension(prefabPath)
  end
  self.__isActive = false
  self.__luaComp = {}
  self.__luaCompLoaded = false
  self.__callRecords = {}
  self.__rawMetaIndex = getmetatable(self).__index
  local meta = {
    __index = function(t, key)
      local value
      value = self.__luaComp and self.__luaComp.gameObject and self.__luaComp[key]
      if value ~= nil then
        Logger.LogError(string.format("[\232\173\166\229\145\138]\229\183\178\231\187\143\229\173\152\229\156\168lua\231\187\132\228\187\182\231\177\187\239\188\140\228\189\134\228\187\141\231\132\182\233\128\154\232\191\135bridge\232\176\131\231\148\168\228\186\134\239\188\154%s", key))
        if type(value) ~= "function" then
          return value
        else
          return function(_, ...)
            value(self.__luaComp, ...)
          end
        end
      end
      if self.__rawMetaIndex then
        if type(self.__rawMetaIndex) == "function" then
          value = self.__rawMetaIndex(t, key)
          if value then
            return value
          end
        elseif type(self.__rawMetaIndex) == "table" then
          value = self.__rawMetaIndex[key]
          if value then
            return value
          end
        end
      end
      if key == "AsyncLoadDone" then
        return _AsyncLoadNotDone
      end
      return function(_, ...)
        local args = {
          ...
        }
        __recordCall(t, key, args)
      end
    end
  }
  setmetatable(self, meta)
end

function UIAsyncLoaderBridge:__delete()
  if self.__luaCompLoaded and self.__luaComp then
    self.__luaComp:Delete()
    __disposeSelf(self)
  end
end

function UIAsyncLoaderBridge:__AsyncLoadComponent()
  self.__luaComp = self.__master and self.__master:LoadComponentAsync(self.__luaClsPath, self.__prefabPath, self.__rootTransform, function()
    if CommonUtil.IsEditor() then
      self.__luaComp.gameObject.name = string.format("[AsyncLoader]%s", self.__prefabName or "?")
    end
    self:__OnComponentLoaded()
  end, nil, self.__master)
  self.__luaCompLoaded = self.__luaComp ~= nil
end

function UIAsyncLoaderBridge:__OnComponentLoaded()
  if not (self.__master and self.__luaComp) or not self.__luaComp:AsyncLoadDone() then
    Logger.LogError(string.format("UIAsyncLoaderBridge.__OnComponentLoaded.Exception  name-%s,master-%s.luaComp-%s", self.__name, self.__master and self.__master.__name or "null", self.__luaComp and self.__luaComp.__name or "null"))
    __disposeSelf(self)
    return
  end
  if self.__master and self.__name then
    self.__master[self.__name] = self.__luaComp
  end
  if self.__loadCallback then
    self.__loadCallback(self.__luaComp)
  end
  self.__luaComp:SetActive(self.__isActive)
  if #self.__callRecords > 0 then
    for k, v in ipairs(self.__callRecords) do
      local methodName = v.method
      local args = v.args
      local method = self.__luaComp[methodName]
      if method then
        CommonUtil.ProtectCall(function()
          if args then
            method(self.__luaComp, table.unpack(args))
          else
            method(self.__luaComp)
          end
        end)
      end
    end
    self.__callRecords = {}
  end
  __disposeSelf(self)
end

function UIAsyncLoaderBridge:SetActive(active)
  self.__isActive = active
  if self.__rootTransform and self.__controlParentActive then
    self.__rootTransform.gameObject:SetActive(active)
  end
  if self.__isActive and not self.__luaCompLoaded then
    self:__AsyncLoadComponent()
  end
end

function UIAsyncLoaderBridge:Description()
  if self.__master then
    local sb = StringBuilder.New()
    sb:AppendFormatLine("%s, loaded:%s, isActive:%s", self.__luaClsPath, tostring(self.__luaComp ~= nil), self.__isActive)
    if #self.__callRecords <= 0 then
      sb:AppendFormatLine("\230\178\161\230\156\137\229\135\189\230\149\176\232\176\131\231\148\168\232\174\176\229\189\149")
    else
      sb:AppendFormatLine("\229\135\189\230\149\176\232\176\131\231\148\168\232\174\176\229\189\149\230\149\176\233\135\143\228\184\186:%s", #self.__callRecords)
      for k, v in ipairs(self.__callRecords) do
        sb:AppendFormatLine("%s:%s", k, v.method)
      end
    end
    return sb:ToString()
  end
  return "\229\183\178\232\162\171\233\135\138\230\148\190\229\150\189..."
end

return UIAsyncLoaderBridge
