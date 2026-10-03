local Queue = {}
Queue.__index = Queue

function Queue.new()
  return setmetatable({
    _head = 1,
    _tail = 0,
    _size = 0,
    _data = {}
  }, Queue)
end

function Queue:enqueue(item)
  self._tail = self._tail + 1
  self._data[self._tail] = item
  self._size = self._size + 1
end

function Queue:dequeue()
  if self:isEmpty() then
    return nil
  end
  local item = self._data[self._head]
  self._data[self._head] = nil
  self._head = self._head + 1
  self._size = self._size - 1
  if self:_shouldCompact() then
    self:compact()
  end
  return item
end

function Queue:peek()
  if self:isEmpty() then
    return nil
  end
  return self._data[self._head]
end

function Queue:isEmpty()
  return self._head > self._tail
end

function Queue:size()
  return self._size
end

function Queue:compact()
  if self._size == 0 then
    self._head = 1
    self._tail = 0
    self._data = {}
    return
  end
  self:compressInPlace(self._data)
  self._head = 1
  self._tail = self._size
end

function Queue:compressInPlace(t)
  local pos = 1
  for i = self._head, self._tail do
    if t[i] ~= nil then
      if i ~= pos then
        t[pos] = t[i]
        t[i] = nil
      end
      pos = pos + 1
    end
  end
  return t
end

function Queue:reset()
  self._head = 1
  self._tail = 0
  self._size = 0
  self._data = {}
end

function Queue:bulkDequeue(count)
  count = math.min(count, self._size)
  if count <= 0 then
    return
  end
  for i = self._head, self._head + count - 1 do
    self._data[i] = nil
  end
  self._head = self._head + count
  if self:_shouldCompact() then
    self:compact()
  end
  return count
end

function Queue:_shouldCompact()
  local freeSpace = self._head - 1
  if self._size ~= self._tail - self._head + 1 then
    Logger.LogError("_size = " .. self._size .. "     " .. "railSize = " .. self._tail - self._head + 1)
  end
  return freeSpace > self._size and 1024 < freeSpace
end

return Queue
