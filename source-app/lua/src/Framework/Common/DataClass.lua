local function DatakIndex(mt, key)
  local value
  
  if mt[key] ~= nil then
    value = mt[key]
  end
  if value == nil then
    error(mt.__cname .. " read err: no key named : " .. key .. "\n" .. table.dump(mt), 2)
  end
  return value
end

local function DataNewindex(mt, key, value)
  if mt[key] == nil then
    error(mt.__cname .. " write err: No key named : " .. key .. "\n" .. table.dump(mt), 2)
  end
  if value then
    rawset(mt, key, value)
  else
    rawset(mt, key, false)
  end
end

function DataClass(classname, data_tb, super)
  assert(type(classname) == "string" and 0 < #classname)
  local cls
  if super then
    cls = DeepCopy(super)
  else
    cls = {}
  end
  if data_tb then
    for i, v in pairs(data_tb) do
      cls[i] = v
    end
  end
  cls.super = super
  cls.__cname = classname
  
  function cls.New(...)
    local data = DeepCopy(cls)
    local ret_data
    data.New = nil
    if Config.Debug then
      function data.__index(tb, key)
        return DatakIndex(data, key)
      end
      
      function data.__newindex(tb, key, value)
        DataNewindex(data, key, value)
      end
      
      ret_data = setmetatable({}, data)
    else
      ret_data = setmetatable(data, data)
    end
    do
      local args = {
        ...
      }
      local create
      
      function create(c, ...)
        if c.super then
          create(c.super, ...)
        end
        if c.__init then
          c.__init(ret_data, ...)
        end
      end
      
      if 0 < #args then
        create(cls, ...)
      end
    end
    return ret_data
  end
  
  return cls
end
