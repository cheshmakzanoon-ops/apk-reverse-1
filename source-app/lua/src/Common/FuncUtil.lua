function checknumber(value, base)
  return tonumber(value, base) or 0
end

function checkstring(value)
  return tostring(value) or ""
end

function BoolToInt(value)
  if value == nil or value == false or value == 0 then
    return 0
  end
  return 1
end

function IntToBool(value)
  if value == nil or value == 0 or value == false then
    return false
  end
  return true
end

function isFloat(value)
  if type(value) == "number" and math.type(value) == "float" then
    return true
  end
  return false
end

function isInteger(value)
  if type(value) == "number" and math.type(value) == "integer" then
    return true
  end
  return false
end

function checktable(value)
  if type(value) ~= "table" then
    value = {}
  end
  return value
end

function toInt(value)
  if value == nil or value == 0 or value == "0" then
    return 0
  end
  local number = tonumber(value)
  if number then
    local int = math.tointeger(number)
    if int then
      return int
    end
    int = math.modf(number)
    return int
  end
  return 0
end

function float_equal(x, v)
  local EPSILON = 1.0E-7
  local r = EPSILON > math.abs(x - v)
  return r
end
