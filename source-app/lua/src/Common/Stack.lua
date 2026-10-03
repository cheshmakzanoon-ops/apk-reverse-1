local Stack = BaseClass("Stack")

function Stack:__init()
  self.list = {}
  self.countCache = 0
end

function Stack:__delete()
  self.list = nil
  self.countCache = nil
end

function Stack:Clear()
  self.list = {}
  self.countCache = 0
end

function Stack:Size()
  return self.countCache
end

function Stack:Push(value)
  if value == nil then
    return
  end
  self.countCache = self.countCache + 1
  table.insert(self.list, value)
end

function Stack:Pop()
  if self.countCache > 0 then
    self.countCache = self.countCache - 1
    return table.remove(self.list)
  end
end

function Stack:Peek()
  if self.countCache > 0 then
    return self.list[self.countCache]
  end
end

return Stack
