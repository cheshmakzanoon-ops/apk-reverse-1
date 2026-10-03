local UIBaseContainer = BaseClass("UIBaseContainer", UIBaseComponent)
local base = UIBaseComponent
local tinsert = table.insert
local tcount = table.count
local pairs = _ENV.pairs
local assert = _ENV.assert
local error = _ENV.error
local type = _ENV.type
local use_pool

local function CanUsePool()
  if use_pool ~= nil then
    return use_pool
  end
  if use_pool == nil then
    if CS.CommonUtils.IsDebug() then
      use_pool = true
    elseif LuaEntry and LuaEntry.Player then
      use_pool = LuaEntry.Player:GetGMFlag() > 0
    else
      use_pool = false
    end
    return use_pool
  end
  return false
end

local function OnCreate(self)
  base.OnCreate(self)
  self.components = {}
  self.length = 0
  self.addListenerCount = 0
  self.__event_handlers = {}
end

local function OnEnable(self)
  base.OnEnable(self)
  if self.__update_handle then
    UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
    self.__update_handle = nil
  end
  if self.Update or self.Update100MS or self.Update1000MS then
    function self.__update_handle()
      if type(self.Update100MS) == "function" then
        self.__time_update_100ms = (self.__time_update_100ms or 0) + Time.unscaledDeltaTime
        
        if self.__time_update_100ms >= 0.1 then
          self.__time_update_100ms = self.__time_update_100ms % 0.1
          self:Update100MS()
        end
      end
      if type(self.Update1000MS) == "function" then
        if self.__time_update_1000ms == nil then
          local offset = self.synchronizePhaseOffset or 0.5
          local _, floatPart = math.modf(UITimeManager:GetInstance():GetServerTime() / 1000 - offset - Time.unscaledDeltaTime)
          self.__time_update_1000ms = floatPart
        end
        self.__time_update_1000ms = (self.__time_update_1000ms or 0) + Time.unscaledDeltaTime
        if self.__time_update_1000ms >= 1 then
          self.__time_update_1000ms = self.__time_update_1000ms % 1
          self:Update1000MS()
        end
      end
      if type(self.Update) == "function" then
        self:Update()
      end
    end
    
    UpdateManager:GetInstance():AddUpdate(self.__update_handle)
  end
  self:OnAddListener()
  self.addListenerCount = self.addListenerCount + 1
end

local function OnDisable(self)
  if self.addListenerCount > 0 then
    self:OnRemoveListener()
    self.addListenerCount = self.addListenerCount - 1
  end
  if self.__update_handle then
    UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
    self.__update_handle = nil
  end
  base.OnDisable(self)
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function AddUIListener(self, msg_name, callback)
  if msg_name and self.__event_handlers ~= nil then
    local function bindFunc(...)
      if callback then
        callback(self, ...)
      end
    end
    
    self.__event_handlers[msg_name] = bindFunc
    EventManager:GetInstance():AddListener(msg_name, bindFunc)
  end
end

local function RemoveUIListener(self, msg_name, callback)
  if msg_name and self.__event_handlers ~= nil then
    local bindFunc = self.__event_handlers[msg_name]
    if not bindFunc then
      Logger.LogError(msg_name, " not register")
      return
    end
    self.__event_handlers[msg_name] = nil
    EventManager:GetInstance():RemoveListener(msg_name, bindFunc)
  end
end

local function UIBroadcast(self, msg_name, ...)
  EventManager:GetInstance():Broadcast(msg_name, bindFunc)
end

local function Walk(self, callback, component_class)
  for _, components in pairs(self.components) do
    for cmp_class, component in pairs(components) do
      if component_class == nil then
        callback(component)
      elseif cmp_class == component_class then
        callback(component)
      end
    end
  end
end

local function WalkDelete(self, component_class)
  for _, components in pairs(self.components) do
    for cmp_class, component in pairs(components) do
      if component_class == nil then
        component:Delete()
        if CanUsePool() then
          UIComponentPoolManager:GetInstance():RecycleComponent(component)
        end
      elseif cmp_class == component_class then
        component:Delete()
        if CanUsePool() then
          UIComponentPoolManager:GetInstance():RecycleComponent(component)
        end
      end
    end
  end
end

local function AddNewRecordIfNeeded(self, name)
  if name and self.components and self.components[name] == nil then
    self.components[name] = {}
  end
end

local function RecordComponent(self, name, component_class, component)
  if UIManager:GetInstance():IsDisableLuaAddComponentAssert() then
    if self.components[name][component_class] ~= nil then
      Logger.LogError("Aready exist component_class : " .. name .. "|" .. component_class.__cname)
    end
  else
    assert(self.components[name][component_class] == nil, "Aready exist component_class : " .. name .. "|" .. component_class.__cname)
  end
  self.components[name][component_class] = component
end

local function OnComponentSetName(self, component, new_name)
  AddNewRecordIfNeeded(self, new_name)
  local old_name = component:GetName()
  if old_name then
    local components = self.components[old_name]
    if components then
      for k, v in pairs(components) do
        v:SetName(new_name)
        RecordComponent(self, new_name, k, v)
      end
    end
    self.components[old_name] = nil
  end
end

local function OnComponentDestroy(self, component)
  self.length = self.length - 1
end

local function AddComponent(self, component_target, var_arg, ...)
  assert(component_target.__ctype == ClassType.class)
  local component_inst, component_class
  if CanUsePool() then
    component_inst = UIComponentPoolManager:GetInstance():GetComponentClass(component_target, self, var_arg)
  else
    component_inst = component_target.New(self, var_arg)
  end
  component_class = component_target
  component_inst:OnCreate(...)
  local name = component_inst:GetName()
  AddNewRecordIfNeeded(self, name)
  RecordComponent(self, name, component_class, component_inst)
  self.length = self.length + 1
  if component_inst:GetActiveInHierarchy() then
    component_inst:OnEnable()
  end
  return component_inst
end

local function GetComponent(self, name, component_class)
  local components = self.components[name]
  if components == nil then
    return nil
  end
  if component_class == nil then
    assert(tcount(components) == 1, "Must specify component_class while there are more then one component!")
    for _, component in pairs(components) do
      return component
    end
  else
    return components[component_class]
  end
end

local function GetComponents(self, component_target)
  local components = {}
  if type(component_target) == "table" then
    self:Walk(function(component)
      tinsert(components, component)
    end, component_target)
  elseif type(component_target) == "string" then
    components = self.components[component_target]
  else
    error("GetComponents params err!")
  end
  return components
end

local function GetComponentsCount(self)
  return self.length
end

local function RemoveComponent(self, name, component_class)
  local component = self:GetComponent(name, component_class)
  if not component then
    return
  end
  component:SetActive(false)
  local cmp_class = component._class_type
  component:Delete()
  self.components[name][cmp_class] = nil
  if CanUsePool() then
    UIComponentPoolManager:GetInstance():RecycleComponent(component)
  end
end

local function RemoveComponentOnly(self, name, component_class)
  local component = self:GetComponent(name, component_class)
  if not component then
    return
  end
  local cmp_class = component._class_type
  component:Delete()
  self.components[name][cmp_class] = nil
  if CanUsePool() then
    UIComponentPoolManager:GetInstance():RecycleComponent(component)
  end
end

local function RemoveComponents(self, component_target)
  local components = self:GetComponents(component_target)
  if not components then
    return
  end
  for _, component in pairs(components) do
    component:SetActive(false)
    local cmp_name = component:GetName()
    local cmp_class = component._class_type
    component:Delete()
    if self.components[cmp_name] then
      self.components[cmp_name][cmp_class] = nil
    end
    if CanUsePool() then
      UIComponentPoolManager:GetInstance():RecycleComponent(component)
    end
  end
end

local function RemoveComponentsOnly(self, component_target)
  local components = self:GetComponents(component_target)
  if not components then
    return
  end
  for _, component in pairs(components) do
    local cmp_name = component:GetName()
    local cmp_class = component._class_type
    component:Delete()
    if self.components[cmp_name] then
      self.components[cmp_name][cmp_class] = nil
    end
    if CanUsePool() then
      UIComponentPoolManager:GetInstance():RecycleComponent(component)
    end
  end
end

local function __OnFrameworkDestroy(self)
end

local function OnDestroy(self)
  self.addListenerCount = 0
  if self.__event_handlers then
    for k, v in pairs(self.__event_handlers) do
      self:RemoveUIListener(k, v)
    end
    self.__event_handlers = nil
  end
  if self.__update_handle then
    UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
    self.__update_handle = nil
  end
  if self.lazyComponents then
    for _, proxy in pairs(self.lazyComponents) do
      proxy:Delete()
    end
    self.lazyComponents = nil
  end
  if self.components then
    WalkDelete(self)
    self.components = nil
  end
  base.OnDestroy(self)
end

local function SetActiveRecursive(com)
  local state, changed
  if com.activeCached ~= nil then
    local oldActive = com.activeCached
    com.activeCached = nil
    state = com:GetActiveInHierarchy()
    changed = oldActive ~= state
  else
    state = com:GetActiveInHierarchy()
    changed = true
  end
  if com.components ~= nil then
    for _, components in pairs(com.components) do
      for _, childCom in pairs(components) do
        SetActiveRecursive(childCom)
      end
    end
  end
  if changed then
    if state then
      com:OnEnable()
    else
      com:OnDisable()
    end
  end
end

local function SetActive(self, active)
  if active then
    if self:GetActiveInHierarchy() then
      return
    end
  elseif not self:GetActiveInHierarchy() then
    if self.gameObject then
      if self.activeSelf ~= false then
        self.gameObject:SetActive(false)
      end
    else
      self:SetInitActiveSelf(false)
    end
    self.activeSelf = false
    return
  end
  self.activeSelf = active
  if self.gameObject then
    self.gameObject:SetActive(active)
    SetActiveRecursive(self)
  else
    self:SetInitActiveSelf(active)
  end
end

local function DefineCompsByBook(self, compBook)
  self.__compBook = compBook
  for _, compEntry in ipairs(compBook) do
    local nameArr = string.split(compEntry.name, ".")
    local parent = self
    for i, nameEntry in ipairs(nameArr) do
      local isLast = i == #nameArr
      if isLast then
        local comp
        if compEntry.type == nil then
          local trans = self.gameObject.transform:Find(compEntry.path)
          if trans == nil or IsNull(trans) then
            printError("ComponentDefine can't find " .. compEntry.path .. " from " .. self.gameObject.transform.name)
          end
          if compEntry.rawType then
            comp = trans.gameObject:GetComponent(typeof(compEntry.rawType))
            if compEntry.active ~= nil then
              comp.gameObject:SetActive(compEntry.active)
            end
          else
            comp = trans.gameObject
            if compEntry.active ~= nil then
              comp:SetActive(compEntry.active)
            end
          end
        elseif compEntry.type == UIGameObjectWrap then
          local trans = self.gameObject.transform:Find(compEntry.path)
          if trans == nil or IsNull(trans) then
            printError("ComponentDefine can't find " .. compEntry.path .. " from " .. self.gameObject.transform.name)
          end
          comp = UIGameObjectWrap.new(trans.gameObject)
          if compEntry.active ~= nil then
            comp:SetActive(compEntry.active)
          end
        else
          comp = self:AddComponent(compEntry.type, compEntry.path)
          if compEntry.active ~= nil then
            comp:SetActive(compEntry.active)
          end
          if compEntry.type == UIButton and compEntry.onClick ~= nil then
            comp:SetOnClick(function()
              compEntry.onClick(self)
            end)
          end
          if compEntry.type == UIToggle and compEntry.onValueChanged ~= nil then
            comp:SetOnValueChanged(function(isOn)
              compEntry.onValueChanged(self, isOn)
            end)
          end
          if compEntry.type == UIText or compEntry.type == UITextMeshProUGUIEx then
            if compEntry.textKey ~= nil then
              comp:SetText(CS.GameEntry.Localization:GetString(compEntry.textKey))
            elseif compEntry.text ~= nil then
              comp:SetText(compEntry.text)
            end
          end
        end
        if comp then
          if compEntry.idx ~= nil then
            if parent[nameEntry] == nil then
              parent[nameEntry] = {}
            end
            table.insert(parent[nameEntry], compEntry.idx, comp)
          else
            parent[nameEntry] = comp
          end
        end
      else
        if parent[nameEntry] == nil then
          parent[nameEntry] = {}
        end
        parent = parent[nameEntry]
      end
    end
  end
end

local function ClearCompsByBook(self, compBook)
  compBook = compBook or self.__compBook
  for j = #compBook, 1, -1 do
    local compEntry = compBook[j]
    local nameArr = string.split(compEntry.name, ".")
    local parent = self
    for i, nameEntry in ipairs(nameArr) do
      if not parent then
        break
      end
      local isLast = i == #nameArr
      if isLast then
        parent[nameEntry] = nil
      else
        parent = parent[nameEntry]
      end
    end
  end
end

local function RemoveAllComponentes(self)
  if self.components then
    self:Walk(function(component)
      component:SetActive(false)
      component:Delete()
    end)
    self.components = {}
  end
end

local function TryAddComponent(self, component_target, var_arg, ...)
  if not component_target or not var_arg then
    return
  end
  local argType = type(var_arg)
  if argType ~= "string" then
    return
  end
  if not self.transform then
    return
  end
  if not self.transform:Find(var_arg) then
    return
  end
  return self:AddComponent(component_target, var_arg, ...)
end

local LazyComponentProxy = require("Framework.UI.Base.LazyComponentProxy")

function UIBaseContainer:LazyAddComponent(componentType, ...)
  local proxy = LazyComponentProxy:new(self, componentType, ...)
  if not self.lazyComponents then
    self.lazyComponents = {}
  end
  self.lazyComponents[componentType] = proxy
  return proxy
end

UIBaseContainer.SetActive = SetActive
UIBaseContainer.OnCreate = OnCreate
UIBaseContainer.OnEnable = OnEnable
UIBaseContainer.AddUIListener = AddUIListener
UIBaseContainer.RemoveUIListener = RemoveUIListener
UIBaseContainer.UIBroadcast = UIBroadcast
UIBaseContainer.OnAddListener = OnAddListener
UIBaseContainer.OnRemoveListener = OnRemoveListener
UIBaseContainer.Walk = Walk
UIBaseContainer.OnComponentSetName = OnComponentSetName
UIBaseContainer.OnComponentDestroy = OnComponentDestroy
UIBaseContainer.AddComponent = AddComponent
UIBaseContainer.GetComponent = GetComponent
UIBaseContainer.GetComponents = GetComponents
UIBaseContainer.GetComponentsCount = GetComponentsCount
UIBaseContainer.RemoveComponent = RemoveComponent
UIBaseContainer.RemoveComponentOnly = RemoveComponentOnly
UIBaseContainer.RemoveComponents = RemoveComponents
UIBaseContainer.RemoveComponentsOnly = RemoveComponentsOnly
UIBaseContainer.OnDisable = OnDisable
UIBaseContainer.OnDestroy = OnDestroy
UIBaseContainer.__OnFrameworkDestroy = __OnFrameworkDestroy
UIBaseContainer.DefineCompsByBook = DefineCompsByBook
UIBaseContainer.ClearCompsByBook = ClearCompsByBook
UIBaseContainer.RemoveAllComponentes = RemoveAllComponentes
UIBaseContainer.TryAddComponent = TryAddComponent
return UIBaseContainer
