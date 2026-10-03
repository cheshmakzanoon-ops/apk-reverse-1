local _class = {}
ClassType = {class = 1, instance = 2}

function BaseClass(classname, super)
  assert(type(classname) == "string" and 0 < #classname)
  local class_type = {}
  class_type.__init = false
  class_type.__delete = false
  class_type.__cname = classname
  class_type.__ctype = ClassType.class
  class_type.getters = {}
  if super then
    setmetatable(class_type.getters, {
      __index = function(t, k)
        return super.getters[k]
      end
    })
  end
  class_type.super = super
  
  function class_type.New(...)
    local obj = {}
    obj._class_type = class_type
    obj.__ctype = ClassType.instance
    setmetatable(obj, {
      __index = function(t, k)
        local getter = class_type.getters[k]
        if getter then
          return getter(t)
        end
        return _class[class_type][k]
      end
    })
    do
      local create
      
      function create(c, ...)
        if c.super then
          create(c.super, ...)
        end
        if c.__init then
          c.__init(obj, ...)
        end
      end
      
      create(class_type, ...)
    end
    
    function obj:Delete()
      local now_super = self._class_type
      while now_super ~= nil do
        if now_super.__delete then
          now_super.__delete(self)
        end
        now_super = now_super.super
      end
    end
    
    function obj:instanceOf(superName)
      local now_super = self._class_type
      while now_super ~= nil do
        if now_super and now_super.__cname == superName then
          return true
        end
        now_super = now_super.super
      end
      return false
    end
    
    return obj
  end
  
  local vtbl = {}
  _class[class_type] = vtbl
  setmetatable(class_type, {
    __newindex = function(t, k, v)
      vtbl[k] = v
    end,
    __index = vtbl
  })
  if super then
    setmetatable(vtbl, {
      __index = function(t, k)
        local ret = _class[super][k]
        return ret
      end
    })
  end
  return class_type
end

function BaseClassCache(classname, super)
  assert(type(classname) == "string" and 0 < #classname)
  local class_type = {}
  class_type.__init = false
  class_type.__delete = false
  class_type.__cname = classname
  class_type.__ctype = ClassType.class
  class_type.super = super
  
  function class_type.New(...)
    local obj = {}
    obj._class_type = class_type
    obj.__ctype = ClassType.instance
    setmetatable(obj, {
      __index = _class[class_type]
    })
    do
      local create
      
      function create(c, ...)
        if c.super then
          create(c.super, ...)
        end
        if c.__init then
          c.__init(obj, ...)
        end
      end
      
      create(class_type, ...)
    end
    
    function obj:Delete()
      local now_super = self._class_type
      while now_super ~= nil do
        if now_super.__delete then
          now_super.__delete(self)
        end
        now_super = now_super.super
      end
    end
    
    function obj:instanceOf(superName)
      local now_super = self._class_type
      while now_super ~= nil do
        if now_super and now_super.__cname == superName then
          return true
        end
        now_super = now_super.super
      end
      return false
    end
    
    return obj
  end
  
  local vtbl = {}
  _class[class_type] = vtbl
  setmetatable(class_type, {
    __newindex = function(t, k, v)
      vtbl[k] = v
    end,
    __index = vtbl
  })
  if super then
    setmetatable(vtbl, {
      __index = function(t, k)
        local ret = _class[super][k]
        vtbl[k] = ret
        return ret
      end
    })
  end
  return class_type
end
