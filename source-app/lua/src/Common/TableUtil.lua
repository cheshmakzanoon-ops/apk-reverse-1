local function count(hashtable)
  if hashtable == nil or type(hashtable) ~= "table" then
    return 0
  end
  local _count = 0
  for _, _ in pairs(hashtable) do
    _count = _count + 1
  end
  return _count
end

local function length(array)
  if array.n ~= nil then
    return array.n
  end
  local _count = 0
  for i, _ in pairs(array) do
    if i > _count then
      _count = i
    end
  end
  return _count
end

local function csCount(hashtable)
  if type(hashtable) ~= "table" then
    if hashtable.Count then
      return hashtable.Count
    end
    return 0
  end
  local ret = 0
  for _, _ in pairs(hashtable) do
    ret = ret + 1
  end
  return ret
end

local function keys(hashtable)
  local data = {}
  local i = 1
  for k, v in pairs(hashtable) do
    data[i] = k
    i = i + 1
  end
  return data
end

local function values(hashtable)
  local data = {}
  local i = 1
  for k, v in pairs(hashtable) do
    data[i] = v
    i = i + 1
  end
  return data
end

local function merge(dest_hashtable, src_hashtable)
  if src_hashtable and dest_hashtable then
    for k, v in pairs(src_hashtable) do
      dest_hashtable[k] = v
    end
  end
end

local function insertto(dest_array, src_array, begin)
  assert(begin == nil or type(begin) == "number")
  if begin == nil or begin <= 0 then
    begin = #dest_array + 1
  end
  local src_len = #src_array
  for i = 0, src_len - 1 do
    dest_array[i + begin] = src_array[i + 1]
  end
end

local function indexof(array, value, begin)
  for i = begin or 1, #array do
    if array[i] == value then
      return i
    end
  end
  return false
end

local function keyof(hashtable, value)
  for k, v in pairs(hashtable) do
    if v == value then
      return k
    end
  end
  return nil
end

function table.removebyvalue(array, value, removeall)
  local remove_count = 0
  for i = #array, 1, -1 do
    if array[i] == value then
      table.remove(array, i)
      remove_count = remove_count + 1
      if not removeall then
        break
      end
    end
  end
  return remove_count
end

function table.removebyfunc(array, predict)
  local remove_count = 0
  if type(predict) ~= "function" then
    return remove_count
  end
  for i = #array, 1, -1 do
    if predict(array[i]) == true then
      table.remove(array, i)
      remove_count = remove_count + 1
    end
  end
  return remove_count
end

local function map(tb, func)
  for k, v in pairs(tb) do
    tb[k] = func(k, v)
  end
end

local function walk(tb, func)
  for k, v in pairs(tb) do
    func(k, v)
  end
end

local function walkex(tb, func, ret, ...)
  for k, v in pairs(tb) do
    ret = func(k, v, ret, ...)
  end
  return ret
end

local function walksort(tb, sort_func, walk_func)
  local keys = table.keys(tb)
  table.sort(keys, function(lkey, rkey)
    return sort_func(lkey, rkey)
  end)
  for i = 1, #keys do
    walk_func(keys[i], tb[keys[i]])
  end
end

local function filter(tb, func)
  local filter = {}
  for k, v in pairs(tb) do
    if not func(k, v) then
      filter[k] = v
    end
  end
  return filter
end

local function choose(tb, func)
  local choose = {}
  for k, v in pairs(tb) do
    if func(k, v) then
      choose[k] = v
    end
  end
  return choose
end

local function dump(tb, dump_metatable, max_level)
  local lookup_table = {}
  local level = 0
  local rep = string.rep
  local dump_metatable = dump_metatable
  local max_level = max_level or 1
  
  local function _dump(tb, level)
    local str = "\n" .. rep("\t", level) .. "{\n"
    for k, v in pairs(tb) do
      local k_is_str = type(k) == "string" and 1 or 0
      local v_is_str = type(v) == "string" and 1 or 0
      str = str .. rep("\t", level + 1) .. "[" .. rep("\"", k_is_str) .. (tostring(k) or type(k)) .. rep("\"", k_is_str) .. "]" .. " = "
      if type(v) == "table" then
        if not lookup_table[v] and (not max_level or level < max_level) then
          lookup_table[v] = true
          str = str .. _dump(v, level + 1, dump_metatable) .. "\n"
        else
          str = str .. (tostring(v) or type(v)) .. ",\n"
        end
      else
        str = str .. rep("\"", v_is_str) .. (tostring(v) or type(v)) .. rep("\"", v_is_str) .. ",\n"
      end
    end
    if dump_metatable then
      local mt = getmetatable(tb)
      if mt ~= nil and type(mt) == "table" then
        str = str .. rep("\t", level + 1) .. "[\"__metatable\"]" .. " = "
        if not lookup_table[mt] and (not max_level or level < max_level) then
          lookup_table[mt] = true
          str = str .. _dump(mt, level + 1, dump_metatable) .. "\n"
        else
          str = str .. (tostring(v) or type(v)) .. ",\n"
        end
      end
    end
    str = str .. rep("\t", level) .. "},"
    return str
  end
  
  return _dump(tb, level)
end

local function reverse(tab)
  local tmp = {}
  for i = 1, #tab do
    tmp[i] = table.remove(tab)
  end
  return tmp
end

local function hasvalue(t, value)
  for k, v in pairs(t) do
    if v == value then
      return true
    end
  end
  return false
end

local function containsKey(tab, key)
  local isUseHashJudge = false
  if LuaEntry.DataConfig then
    if LuaEntry.DataConfig.isUseHashJudge_ContainKey == nil then
      LuaEntry.DataConfig.isUseHashJudge_ContainKey = CS.ClientSwitch.IsOn(CS.ClientSwitch.LUA_TABLE_UTIL_CONTAINS_KEY_USE_NEW_JUDGE)
    end
    isUseHashJudge = LuaEntry.DataConfig.isUseHashJudge_ContainKey
  end
  if isUseHashJudge and type(tab) == "table" then
    return rawget(tab, key) ~= nil
  end
  for k, _ in pairs(tab) do
    if k == key then
      return true
    end
  end
  return false
end

local function IsNotEmpty(table)
  for _, _ in pairs(table) do
    return true
  end
  return false
end

local function IsEmpty(table)
  for _, _ in pairs(table) do
    return false
  end
  return true
end

local function IsNullOrEmpty(table)
  if table == nil or type(table) ~= "table" then
    return true
  end
  for _, _ in pairs(table) do
    return false
  end
  return true
end

local function isarray(t)
  return 0 < #t and next(t, #t) == nil
end

local function table2string(t, sep1, sep2)
  sep1 = sep1 or ";"
  sep2 = sep2 or "="
  local msg = ""
  local i = 1
  for k, v in pairs(t) do
    if i == 1 then
      msg = msg .. k .. sep2 .. v
    else
      msg = msg .. sep1 .. k .. sep2 .. v
    end
    i = i + 1
  end
  return msg, i
end

local function array2string(t, sep1, sep2)
  sep1 = sep1 or ","
  sep2 = sep2 or "|"
  local msg = ""
  local i = 1
  for _, v in ipairs(t) do
    local segment
    if type(v) == "table" then
      segment = table.concat(v, sep1)
    else
      segment = tostring(v)
    end
    if i == 1 then
      msg = segment
    else
      msg = msg .. sep2 .. segment
    end
    i = i + 1
  end
  return msg, i
end

local function print_r(t, r)
  r = r or 3
  local print_r_cache = {}
  
  local function sub_print_r(t, d, indent)
    if print_r_cache[tostring(t)] then
      print(indent .. "*" .. tostring(t))
    else
      print_r_cache[tostring(t)] = true
      if type(t) == "table" then
        for pos, val in pairs(t) do
          local key = (type(pos) == "table" or type(pos) == "userdata") and "<" .. type(pos) .. ">" or pos
          if type(val) == "table" then
            if d <= r then
              print(indent .. "[" .. key .. "] => " .. tostring(t) .. " {")
              sub_print_r(val, d + 1, indent .. string.rep(" ", string.len(key) + 8))
            else
              print(indent .. "[" .. key .. "] => " .. tostring(t) .. " {...")
            end
            print(indent .. string.rep(" ", string.len(key) + 6) .. "}")
          elseif type(val) == "string" then
            print(indent .. "[" .. key .. "] => \"" .. val .. "\"")
          else
            print(indent .. "[" .. key .. "] => " .. tostring(val))
          end
        end
      else
        print(indent .. tostring(t))
      end
    end
  end
  
  if type(t) == "table" then
    print(tostring(t) .. " {")
    sub_print_r(t, 1, "  ")
    print("}")
  else
    sub_print_r(t, 1, "  ")
  end
  print()
end

local function randomArrayValue(tbl)
  local idx = math.random(1, #tbl)
  return tbl[idx]
end

local function clear(tbl)
  for k in pairs(tbl) do
    tbl[k] = nil
  end
end

local function mergeArray(tbl1, tbl2)
  local tbl = {}
  if tbl1 then
    for _, v in ipairs(tbl1) do
      table.insert(tbl, v)
    end
  end
  if tbl2 then
    for _, v in ipairs(tbl2) do
      table.insert(tbl, v)
    end
  end
  return tbl
end

local function extendArray(arr1, arr2)
  for _, v in ipairs(arr2) do
    table.insert(arr1, v)
  end
end

local function againObtain(tbl)
  local list = {}
  for i = 1, 3 do
    local value = math.random(1, table.count(tbl))
    table.insert(list, value)
  end
  table.sort(list, function(a, b)
    if a < b then
      return true
    end
    return false
  end)
  local list1 = {}
  local list2 = {}
  for i = 1, table.count(tbl) do
    if i <= list[2] then
      table.insert(list1, 1, tbl[i])
    else
      table.insert(list2, 1, tbl[i])
    end
  end
  return table.mergeArray(list1, list2)
end

local function deep_compare(tbl1, tbl2)
  if tbl1 == tbl2 then
    return true
  elseif type(tbl1) == "table" and type(tbl2) == "table" then
    for key1, value1 in pairs(tbl1) do
      local value2 = tbl2[key1]
      if value2 == nil then
        return false
      elseif value1 ~= value2 then
        if type(value1) == "table" and type(value2) == "table" then
          if not deep_compare(value1, value2) then
            return false
          end
        else
          return false
        end
      end
    end
    for key2, _ in pairs(tbl2) do
      if tbl1[key2] == nil then
        return false
      end
    end
    return true
  end
  return false
end

local function getFirst(array)
  if array == nil then
    return nil
  end
  if type(array) ~= "table" then
    return array[0]
  end
  return array[1]
end

function table.transform(tbl, fun)
  local newTable = {}
  if tbl ~= nil and fun ~= nil then
    for k, v in pairs(tbl) do
      newTable[k] = fun(k, v)
    end
  end
  return newTable
end

ReadonlyEmptyTable = {}
local mt = {
  __index = function(_, key)
  end,
  __newindex = function(_, key, value)
  end
}
setmetatable(ReadonlyEmptyTable, mt)

local function copy(tb, result_, deep_, copyKey_)
  result_ = result_ or {}
  local _filter = {}
  
  local function _copy(obj, _deep, result)
    if _deep then
      _deep = _deep + 1
      if _deep > deep_ then
        return
      end
    end
    if type(obj) ~= "table" then
      return obj
    elseif _filter[obj] then
      return _filter[obj]
    end
    local newT = result or {}
    if copyKey_ then
      for k, v in pairs(obj) do
        newT[_copy(k, _deep)] = _copy(v, _deep)
      end
    else
      for k, v in pairs(obj) do
        newT[k] = _copy(v, _deep)
      end
    end
    _filter[obj] = newT
    return setmetatable(newT, getmetatable(obj))
  end
  
  return _copy(tb, deep_, result_)
end

local function listToDic(tb, keyName, dic_)
  dic_ = dic_ or {}
  local keyValue
  for i, v in ipairs(tb) do
    keyValue = v[keyName]
    if keyValue then
      dic_[keyValue] = v
    end
  end
  return dic_
end

local function TryGetValue(tbl, key, default)
  if table.IsNullOrEmpty(tbl) then
    return default
  end
  local value = tbl[key]
  if value ~= nil then
    return value
  end
  return default
end

table.empty = {}
table.count = count
table.csCount = csCount
table.length = length
table.keys = keys
table.values = values
table.merge = merge
table.insertto = insertto
table.indexof = indexof
table.keyof = keyof
table.map = map
table.walk = walk
table.walkex = walkex
table.walksort = walksort
table.filter = filter
table.choose = choose
table.dump = dump
table.reverse = reverse
table.hasvalue = hasvalue
table.containsKey = containsKey
table.IsNotEmpty = IsNotEmpty
table.IsEmpty = IsEmpty
table.IsNullOrEmpty = IsNullOrEmpty
table.isarray = isarray
table.table2string = table2string
table.print = print_r
table.randomArrayValue = randomArrayValue
table.clear = clear
table.mergeArray = mergeArray
table.againObtain = againObtain
table.deep_compare = deep_compare
table.getFirst = getFirst
table.extendArray = extendArray
table.copy = copy
table.listToDic = listToDic
table.TryGetValue = TryGetValue
