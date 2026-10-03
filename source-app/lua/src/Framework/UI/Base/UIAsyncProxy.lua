local base = UIBaseContainer
local UIAsyncProxy = BaseClass("UIAsyncProxy", base)

function UIAsyncProxy:SetActiveAsync(isActive, luaClassOrPath, prefabPath, parent, callback, callback_param, var_arg)
  if isActive then
    if self.__asyncComponent == nil then
      self.__asyncComponent = self:LoadComponentAsync(luaClassOrPath, prefabPath, parent, callback, callback_param, var_arg)
    end
    if self.__asyncComponent ~= nil then
      self.__asyncComponent:SetActive(true)
    end
    return self.__asyncComponent
  end
  if self.__asyncComponent then
    self:RemoveAsyncComponent(self.__asyncComponent)
    self.__asyncComponent = nil
  end
  return nil
end

function UIAsyncProxy:SetActiveAsyncWithPath(isActive, luaPath, prefabPath, parent, callback, callback_param, var_arg)
  if not self.__asyncComponentDict then
    self.__asyncComponentDict = {}
  end
  local obj = self.__asyncComponentDict[luaPath]
  if isActive then
    if obj == nil then
      obj = self:LoadComponentAsync(luaPath, prefabPath, parent, callback, callback_param, var_arg)
      self.__asyncComponentDict[luaPath] = obj
    end
    if obj ~= nil then
      obj:SetActive(true)
    end
    return obj
  end
  if obj then
    self:RemoveAsyncComponent(obj)
    self.__asyncComponentDict[luaPath] = nil
  end
  return nil
end

return UIAsyncProxy
