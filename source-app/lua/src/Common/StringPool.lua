local StringPool = BaseClass("StringPool")

function StringPool:__init(str, separator)
  if not string.IsNullOrEmpty(str) then
    self.pool = string.split(str, separator)
    self.poolLength = #self.pool
  end
end

function StringPool:__delete()
  self.pool = nil
end

function StringPool:GetRandom()
  if self.pool then
    local rand = math.random(self.poolLength)
    return self.pool[rand]
  end
  return nil
end

function StringPool:GetRandomStable(number)
  if self.pool then
    local rand = number % self.poolLength
    return self.pool[rand + 1]
  end
  return nil
end

return StringPool
