local function table_clear(t)
  for k, v in pairs(t) do
    t[k] = nil
  end
end

local table_insert = table.insert
local table_remove = table.remove
ClassType = {class = 1, instance = 2}
OptClass = {
  _class_defines = {}
}
local _class_defines = OptClass._class_defines
local _class_meta_tb_cached = {}

local function _getter_function(t, k)
  local _class = rawget(t, "_class_type")
  local _class_value = _class[k]
  if _class_value ~= nil then
    return _class_value
  end
  local _cur_class = _class
  local _flat_getters = rawget(_cur_class, "getters")
  local _getter = _flat_getters[k]
  if _getter ~= nil then
    return _getter(t)
  else
    _cur_class = rawget(_cur_class, "super")
    while _cur_class do
      _getter = rawget(_cur_class, "getters")[k]
      if _getter then
        _flat_getters[k] = _getter
        return _getter(t)
      end
      _cur_class = rawget(_cur_class, "super")
    end
  end
  return nil
end

local function _has_getter_function(class)
  local _cur_class = class
  while _cur_class do
    local _getters = rawget(_cur_class, "getters")
    if _getters and next(_getters) ~= nil then
      return true
    end
    _cur_class = rawget(_cur_class, "super")
  end
  return false
end

local _getter_meta = {__index = _getter_function}

local function _get_class_meta_table(class)
  local _class_meta = _class_meta_tb_cached[class]
  if _class_meta ~= nil then
    return _class_meta
  end
  if _has_getter_function(class) then
    _class_meta = _getter_meta
  else
    _class_meta = {__index = class}
  end
  _class_meta_tb_cached[class] = _class_meta
  return _class_meta
end

local function _object_delete(obj)
  local _class = rawget(obj, "_class_type")
  local _cur_class = _class
  while _cur_class do
    local _dtor = rawget(_cur_class, "__delete")
    if _dtor then
      _dtor(obj)
    end
    _cur_class = rawget(_cur_class, "super")
  end
  if _class.__pool_allocator then
    _class.__release__(obj)
  end
end

local function _object_instance(obj, superName)
  local super
  if type(superName) == "string" then
    super = _class_defines[superName]
  elseif type(superName) == "table" then
    super = superName
  end
  local cur_class = obj._class_type
  while cur_class do
    if cur_class == super then
      return true
    end
    cur_class = rawget(cur_class, "super")
  end
  return false
end

function OptClass.Declare(classname, super, pool_allocator)
  assert(type(classname) == "string" and 0 < #classname)
  local _class = {}
  _class.__cname = classname
  _class.__ctype = ClassType.class
  _class.getters = {}
  _class.__pool_allocator = pool_allocator or false
  _class.Delete = _object_delete
  _class.instanceOf = _object_instance
  _class.InstanceOf = _object_instance
  _class_defines[classname] = _class
  local _tbl_ctor = {}
  if pool_allocator then
    if type(pool_allocator) == "table" then
      _class.__acquire__ = pool_allocator.acquire
      _class.__release__ = pool_allocator.release
    else
      local _objs_pool = {}
      _class.__objs_pool__ = _objs_pool
      
      function _class.__acquire__()
        if 0 < #_objs_pool then
          return table_remove(_objs_pool), true
        else
          return {}, false
        end
      end
      
      function _class.__release__(t)
        table_clear(t)
        table_insert(_objs_pool, #_objs_pool + 1, t)
      end
    end
  end
  if super then
    _class.super = super
    setmetatable(_class, {__index = super})
  end
  local _cur_class = super
  while _cur_class do
    local _ctor = rawget(_cur_class, "__init")
    if _ctor then
      table_insert(_tbl_ctor, 1, _ctor)
    end
    _cur_class = rawget(_cur_class, "super")
  end
  
  local function _construct(new_obj, ...)
    new_obj._class_type = _class
    new_obj.__ctype = ClassType.instance
    for _i, _v in ipairs(_tbl_ctor) do
      _v(new_obj, ...)
    end
    local _self_ctor = rawget(_class, "__init")
    if _self_ctor then
      _self_ctor(new_obj, ...)
    end
  end
  
  function _class.New(...)
    if CommonUtil and CommonUtil.IsEditor() and ChildClassImplementList and ChildClassImplementCheckedList and not ChildClassImplementCheckedList[_class.__cname] then
      local class = _class
      while class do
        if ChildClassImplementList[class] then
          for funcName in pairs(ChildClassImplementList[class]) do
            local func = rawget(_class, funcName)
            if func == nil or type(func) ~= "function" then
              Logger.LogError(string.format("[NotImplementedException] %s.%s NOT implemented", _class.__cname, funcName))
            end
          end
          ChildClassImplementCheckedList[_class.__cname] = true
        end
        class = rawget(class, "super")
      end
    end
    if _class.__pool_allocator then
      local _obj, is_pooled = _class.__acquire__()
      if not is_pooled then
        setmetatable(_obj, _get_class_meta_table(_class))
      end
      _construct(_obj, ...)
      return _obj
    else
      local _obj = {}
      setmetatable(_obj, _get_class_meta_table(_class))
      _construct(_obj, ...)
      return _obj
    end
  end
  
  return _class
end

OptClass.Delete = _object_delete
OptClass.InstanceOf = _object_instance
return OptClass
