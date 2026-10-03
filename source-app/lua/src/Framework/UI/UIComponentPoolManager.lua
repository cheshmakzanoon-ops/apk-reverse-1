local UIComponentPoolManager = BaseClass("UIComponentPoolManager", Singleton)

local function __init(self)
  self.componentPool = {}
end

local function __delete(self)
  self.componentPool = nil
end

local SUPPORT_TYPES = {
  [UIText.__cname] = true,
  [UINewText.__cname] = true,
  [UITextMeshProUGUI.__cname] = true,
  [UITextMeshProUGUIEx.__cname] = true,
  [UIImage.__cname] = true,
  [UIButton.__cname] = true
}

local function GetNew(self, useCachce)
end

local function LogStats(self)
end

function UIComponentPoolManager:GetComponentClass(componentClass, context, var_arg)
  if not componentClass then
    return nil
  end
  local componentType = componentClass.__cname
  if not SUPPORT_TYPES[componentType] then
    return componentClass.New(context, var_arg)
  end
  local componentPool = self.componentPool[componentType]
  if componentPool and 0 < #componentPool then
    local component = componentPool[#componentPool]
    componentPool[#componentPool] = nil
    if component.Reinit then
      component:Reinit(context, var_arg)
    end
    return component
  else
    return componentClass.New(context, var_arg)
  end
end

function UIComponentPoolManager:RecycleComponent(component)
  if not component then
    return
  end
  if not component.__ctype or component.__ctype ~= ClassType.instance then
    return
  end
  local componentType = component._class_type.__cname
  if not SUPPORT_TYPES[componentType] then
    return
  end
  local componentPool = self.componentPool[componentType]
  if not componentPool then
    componentPool = {}
    self.componentPool[componentType] = componentPool
    setmetatable(componentPool, {__mode = "v"})
  end
  componentPool[#componentPool + 1] = component
end

UIComponentPoolManager.__init = __init
UIComponentPoolManager.__delete = __delete
UIComponentPoolManager.GetNew = GetNew
UIComponentPoolManager.LogStats = LogStats
return UIComponentPoolManager
