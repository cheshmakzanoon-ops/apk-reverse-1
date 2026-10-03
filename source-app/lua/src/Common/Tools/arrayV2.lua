local setmetatable = _ENV.setmetatable
local arrayV2 = {}
arrayV2.__index = arrayV2

function arrayV2:new()
  local t = {
    length = 0,
    innerArr = {},
    useableIds = {}
  }
  return setmetatable(t, arrayV2)
end

function arrayV2:clear()
  self.innerArr = {}
  self.useableIds = {}
  self.length = 0
end

function arrayV2:Add(value)
  local id = 0
  if 0 < #self.useableIds then
    id = self.useableIds[#self.useableIds]
    self.useableIds[#self.useableIds] = nil
  else
    id = self.length + 1
  end
  self.innerArr[id] = {val = value, removed = false}
  self.length = self.length + 1
  return id
end

function arrayV2:RemoveAt(index)
  if self.innerArr[index] then
    self.innerArr[index].val = nil
    self.innerArr[index].removed = true
    self.useableIds[#self.useableIds + 1] = index
    self.length = self.length - 1
  end
end

function arrayV2:iterator()
  local index = 0
  return function()
    index = index + 1
    while index <= self.length do
      if not self.innerArr[index].removed then
        return index, self.innerArr[index].val
      end
      index = index + 1
    end
  end
end

setmetatable(arrayV2, {
  __call = arrayV2.new
})
return arrayV2
