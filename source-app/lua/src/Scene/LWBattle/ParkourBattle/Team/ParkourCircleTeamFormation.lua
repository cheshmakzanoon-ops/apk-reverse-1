local base = require("Scene.LWBattle.ParkourBattle.Team.ParkourFormation")
local ParkourCircleTeamFormation = BaseClass("ParkourCircleTeamFormation", base)

function ParkourCircleTeamFormation:__init(specialPos)
  self.specialPos = specialPos
  self.pos = nil
  self.posCount = 0
  self.specialPosIndex = 0
  self.specialPosCount = #self.specialPos
end

function ParkourCircleTeamFormation:__delete()
  self.specialPos = nil
end

function ParkourCircleTeamFormation:Init(initBattleFormation, backwards, defense, formationSpecialType)
  base.Init(self, initBattleFormation, backwards, defense, formationSpecialType)
  self.pos = {}
  self.specialPosIndex = self.specialPosIndex + 1
  local posData = self.specialPos[self.specialPosIndex]
  if posData == nil then
    Logger.LogError("ParkourCircleTeamFormation.Init posData error !")
    self.canResize = false
    return
  end
  local radius = posData.radius
  local count = posData.count
  local t = 360 / count
  for i = 1, count do
    local rad = math.rad(t * i)
    local x = math.cos(rad) * radius
    local z = math.sin(rad) * radius
    table.insert(self.pos, Vector3.New(x, 0, z))
  end
  self.posCount = count
  self.canResize = self.specialPos[self.specialPosIndex + 1] ~= nil
end

function ParkourCircleTeamFormation:ChangeToBattleFormation()
  base.ChangeToBattleFormation(self)
end

function ParkourCircleTeamFormation:GetOffsetByIndex(index)
  base.GetOffsetByIndex(self, index)
  if index > self.posCount then
    self:ReSize(index)
  end
  if index <= self.posCount then
    return self.pos[index]
  end
  return self.pos[self.posCount]
end

function ParkourCircleTeamFormation:ReSize(index, force)
  base.ReSize(self, index, force)
  local start = self.specialPosIndex + 1
  for i = start, self.specialPosCount do
    local posData = self.specialPos[i]
    local radius = posData.radius
    local count = posData.count
    local t = 360 / count
    for j = 1, count do
      local rad = math.rad(t * j)
      local x = math.cos(rad) * radius
      local z = math.sin(rad) * radius
      table.insert(self.pos, Vector3.New(x, 0, z))
    end
    self.posCount = self.posCount + count
    self.specialPosIndex = i
    if index <= self.posCount then
      break
    end
  end
  self.canResize = self.specialPos[self.specialPosIndex + 1] ~= nil
  return self.posCount
end

function ParkourCircleTeamFormation:GetWeaponPos()
  base.GetWeaponPos(self)
  return self.pos[1]
end

return ParkourCircleTeamFormation
