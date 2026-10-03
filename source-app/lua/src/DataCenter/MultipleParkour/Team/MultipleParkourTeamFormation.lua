local MultipleParkourTeamFormation = BaseClass("MultipleParkourTeamFormation")

function MultipleParkourTeamFormation:__init(startPos, posCount, left)
  self.startPos = startPos
  self.posCount = posCount
  self.left = left
  self.pos = nil
  self.maxZ = 0
end

function MultipleParkourTeamFormation:__delete()
  self.pos = nil
end

function MultipleParkourTeamFormation:Init(offsetX, offsetZ, countX)
  self.offsetX = offsetX
  self.offsetZ = offsetZ
  self.countX = countX
  self.pos = {}
  if self.left then
    self.pos[0] = Vector3.New(self.startPos + self.offsetX, 0, 0)
  else
    self.pos[0] = Vector3.New(self.startPos, 0, 0)
  end
  local start = self.startPos
  for i = 1, self.posCount do
    local index = i - 1
    local z = math.floor(index / self.countX) + 1
    local x = index % self.countX
    self.maxZ = self.offsetZ * z
    local pos = Vector3.New(start + x * self.offsetX, 0, -self.maxZ - 1.5)
    self.pos[i] = pos
  end
end

function MultipleParkourTeamFormation:GetPos(index)
  if index > self.posCount then
    return Vector3.zero
  end
  return self.pos[index]
end

function MultipleParkourTeamFormation:GetMaxZ()
  return self.maxZ or 0
end

return MultipleParkourTeamFormation
