local ObjectPool = BaseClass("ObjectPool", Singleton)

function ObjectPool:__init()
  self.pool = {}
end

function ObjectPool:__delete()
  self:ClearAll()
end

function ObjectPool:ClearAll()
  for _, v in pairs(self.pool) do
    for kk, vv in pairs(v) do
      kk:Delete()
    end
  end
  self.pool = {}
end

function ObjectPool:Clear(class)
  if not self.pool[class] then
    return
  end
  for object, _ in pairs(self.pool[class]) do
    object:Delete()
  end
  self.pool[class] = nil
end

function ObjectPool:Load(class)
  if not self.pool[class] then
    return class.New()
  end
  local object
  for obj, _ in pairs(self.pool[class]) do
    object = obj
    break
  end
  if object then
    self.pool[class][object] = nil
    return object
  end
  return class.New()
end

function ObjectPool:Save(object)
  local class = object._class_type
  if not class then
    return
  end
  if not self.pool[class] then
    self.pool[class] = {}
    setmetatable(self.pool[class], {__mode = "k"})
  end
  self.pool[class][object] = true
end

return ObjectPool
