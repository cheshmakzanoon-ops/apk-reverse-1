local setmetatable = _ENV.setmetatable
local emptyValue = {}
local arrayV3 = {}
arrayV3.__index = arrayV3

function arrayV3:new()
  local t = {
    length = 0,
    array = {},
    emptyIndexArray = {},
    emptyIndex = 0
  }
  return setmetatable(t, arrayV3)
end

function arrayV3:clear()
  self.array = {}
  self.emptyIndexArray = {}
  self.length = 0
  self.emptyIndex = 0
end

function arrayV3:Add(value)
  if self.emptyIndex > 0 then
    local index = self.emptyIndex
    local preEmptyIndex = self.emptyIndexArray[index]
    self.emptyIndexArray[index] = 0
    self.array[index] = value
    self.emptyIndex = preEmptyIndex
    return index
  end
  self.length = self.length + 1
  local index = self.length
  self.array[index] = value
  self.emptyIndexArray[index] = 0
  return index
end

function arrayV3:RemoveAt(index)
  if index <= self.length then
    local value = self.array[index]
    self.array[index] = emptyValue
    self.emptyIndexArray[index] = self.emptyIndex
    self.emptyIndex = index
    return value
  end
end

function arrayV3:Get(index)
  if index <= self.length then
    local value = self.array[index]
    return value
  end
end

setmetatable(arrayV3, {
  __call = arrayV3.new
})
return arrayV3
