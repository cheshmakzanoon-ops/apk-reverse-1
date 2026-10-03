local LWFireworkQueue = BaseClass("LWFireworkQueue")

function LWFireworkQueue:__init()
  self.first = 1
  self.last = 0
  self.size = 0
  self.data = {}
end

function LWFireworkQueue:__delete()
  self.first = nil
  self.last = nil
  self.size = nil
  self.data = nil
end

function LWFireworkQueue:Enqueue(value)
  if not value then
    return
  end
  self.last = self.last + 1
  self.data[self.last] = value
  self.size = self.size + 1
end

function LWFireworkQueue:Dequeue()
  if self:IsEmpty() then
    return nil
  end
  local value = self.data[self.first]
  self.data[self.first] = nil
  self.first = self.first + 1
  self.size = self.size - 1
  return value
end

function LWFireworkQueue:Peek()
  if self:IsEmpty() then
    return nil
  end
  return self.data[self.first]
end

function LWFireworkQueue:LastPeek()
  if self:IsEmpty() then
    return nil
  end
  return self.data[self.last]
end

function LWFireworkQueue:GetSize()
  return self.size
end

function LWFireworkQueue:IsEmpty()
  return self.size <= 0
end

function LWFireworkQueue:Clear()
  self.first = 1
  self.last = 0
  self.size = 0
  self.data = {}
end

function LWFireworkQueue:ForEach(callback)
  if not callback then
    return
  end
  for i = self.first, self.last do
    if self.data[i] then
      callback(self.data[i])
    end
  end
end

function LWFireworkQueue:ToArray()
  local array = {}
  local index = 1
  for i = self.first, self.last do
    if self.data[i] then
      array[index] = self.data[i]
      index = index + 1
    end
  end
  return array
end

return LWFireworkQueue
