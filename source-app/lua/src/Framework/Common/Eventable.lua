CEventable = BaseClass("CEventable")

function CEventable:__init()
  self._register_events = nil
  self._register_events_withParam = nil
end

function CEventable:__delete()
  self:ClearAllEvent()
end

function CEventable:ClearAllEvent()
  if self._register_events then
    for k, v in pairs(self._register_events) do
      EventManager:GetInstance():RemoveListener2(k, v, self)
    end
    self._register_events = nil
  end
  if self._register_events_withParam then
    for id, v in pairs(self._register_events_withParam) do
      for scope, func in pairs(v) do
        EventManager:GetInstance():RemoveListenerWithParam(id, scope, func)
      end
    end
    self._register_events_withParam = nil
  end
end

function CEventable:RegisterEvent(id, func)
  if not self._register_events then
    self._register_events = {}
  end
  local v = self._register_events[id]
  if v ~= nil then
    return
  end
  EventManager:GetInstance():AddListenerWithSelf(id, func, self)
  self._register_events[id] = func
end

function CEventable:UnregisterEvent(id)
  if not self._register_events then
    return
  end
  local v = self._register_events[id]
  if v == nil then
    return
  end
  EventManager:GetInstance():RemoveListener2(id, v, self)
  self._register_events[id] = nil
end

function CEventable:AddListener(id, func)
  if not self._register_events then
    self._register_events = {}
  end
  local v = self._register_events[id]
  if v ~= nil then
    return
  end
  
  local function callback(...)
    if not IsNull(self) then
      func(self, ...)
    end
  end
  
  EventManager:GetInstance():AddListener(id, callback)
  self._register_events[id] = callback
end

function CEventable:RemoveListener(id, func)
  if not self._register_events then
    return
  end
  local v = self._register_events[id]
  if not v then
    return
  end
  EventManager:GetInstance():RemoveListener(id, func or v)
  self._register_events[id] = nil
end

function CEventable:AddListenerWithParam(id, scope, func, target)
  if not self._register_events_withParam then
    self._register_events_withParam = {}
  end
  local v = self._register_events_withParam[id]
  if not v then
    v = {}
    self._register_events_withParam[id] = v
  end
  if v[scope] then
    return
  end
  if target then
    EventManager:GetInstance():AddListenerWithParam(id, scope, func, target)
    v[scope] = func
  else
    local function callback(...)
      if not IsNull(self) then
        func(self, ...)
      end
    end
    
    EventManager:GetInstance():AddListenerWithParam(id, scope, callback)
    v[scope] = callback
  end
end

function CEventable:RemoveListenerWithParam(id, scope, func)
  if not self._register_events_withParam then
    return
  end
  local v = self._register_events_withParam[id]
  if not v then
    return
  end
  local f = v[scope]
  if not f then
    return
  end
  EventManager:GetInstance():RemoveListenerWithParam(id, scope, func or f)
  v[scope] = nil
end
