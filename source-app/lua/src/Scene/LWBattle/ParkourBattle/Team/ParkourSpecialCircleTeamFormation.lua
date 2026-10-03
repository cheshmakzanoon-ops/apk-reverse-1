local base = require("Scene.LWBattle.ParkourBattle.Team.ParkourFormation")
local ParkourSpecialCircleTeamFormation = BaseClass("ParkourSpecialCircleTeamFormation", base)
local Const = require("Scene.LWBattle.Const")

function ParkourSpecialCircleTeamFormation:__init(specialPos)
  self.specialPos = specialPos
  self.pos = nil
  self.posCount = 0
  self.specialPosIndex = 0
  self.specialPosCount = #self.specialPos
end

function ParkourSpecialCircleTeamFormation:__delete()
  self.specialPos = nil
end

function ParkourSpecialCircleTeamFormation:Init(initBattleFormation, backwards, defense, formationSpecialType)
  base.Init(self, initBattleFormation, backwards, defense, formationSpecialType)
  self.formationSpecialType = formationSpecialType
  if formationSpecialType then
    self:ReInitPos(initBattleFormation, formationSpecialType, true)
    self.posCount = #self.pos
  else
    if initBattleFormation then
      self.pos = {
        [1] = Vector3.New(-1.8, 0, 2.5),
        [2] = Vector3.New(1.8, 0, 2.5),
        [3] = Vector3.New(-2.9, 0, 0),
        [4] = Vector3.New(0, 0, 0),
        [5] = Vector3.New(2.9, 0, 0)
      }
    else
      self.pos = {
        [1] = Vector3.New(-2.3, 0, 2.5),
        [2] = Vector3.New(2.3, 0, 2.5),
        [3] = Vector3.New(-3.3, 0, -1.5),
        [4] = Vector3.New(0, 0, -1.5),
        [5] = Vector3.New(3.3, 0, -1.5)
      }
    end
    self.posCount = 5
  end
  self.specialPosIndex = 0
  self.canResize = self.specialPos[self.specialPosIndex + 1] ~= nil
end

function ParkourSpecialCircleTeamFormation:ChangeToBattleFormation()
  base.ChangeToBattleFormation(self)
  self:ReSize(self.posCount, true)
end

function ParkourSpecialCircleTeamFormation:GetOffsetByIndex(index)
  base.GetOffsetByIndex(self, index)
  if index > self.posCount then
    self:ReSize(index)
  end
  if index <= self.posCount then
    return self.pos[index]
  end
  return self.pos[self.posCount]
end

function ParkourSpecialCircleTeamFormation:ReSize(index, force)
  base.ReSize(self, index, force)
  local addCount = index - self.posCount
  if addCount <= 0 and not force then
    return self.posCount
  end
  if self.formationSpecialType then
    self:ReInitPos(true, self.formationSpecialType, false)
  elseif self.pos == nil then
    self.pos = {
      [1] = Vector3.New(-1.8, 0, 2.5),
      [2] = Vector3.New(1.8, 0, 2.5),
      [3] = Vector3.New(-2.9, 0, 0),
      [4] = Vector3.New(0, 0, 0),
      [5] = Vector3.New(2.9, 0, 0)
    }
  else
    self.pos[1] = Vector3.New(-1.8, 0, 2.5)
    self.pos[2] = Vector3.New(1.8, 0, 2.5)
    self.pos[3] = Vector3.New(-2.9, 0, 0)
    self.pos[4] = Vector3.New(0, 0, 0)
    self.pos[5] = Vector3.New(2.9, 0, 0)
  end
  local start = self.specialPosIndex + 1
  for i = start, self.specialPosCount do
    local posData = self.specialPos[i]
    local radius = posData.x
    local count = posData.y
    local t = 360 / count
    for j = 1, count do
      local rad = math.rad(t * j - 180)
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

function ParkourSpecialCircleTeamFormation:GetWeaponPos()
  base.GetWeaponPos(self)
  return self.pos[1]
end

function ParkourSpecialCircleTeamFormation:ReInitPos(initBattleFormation, formationSpecialType, force)
  local formationPos = Const.ParkourSpecialCircleTeamFormationPosition.UnInitBattleFormation[formationSpecialType]
  if initBattleFormation then
    formationPos = Const.ParkourSpecialCircleTeamFormationPosition.InitBattleFormation[formationSpecialType]
  end
  if self.pos == nil or force then
    self.pos = {}
    for i = 1, #formationPos do
      self.pos[i] = formationPos[i]:Clone()
    end
  else
    for i = 1, #formationPos do
      self.pos[i] = formationPos[i]:Clone()
    end
  end
end

return ParkourSpecialCircleTeamFormation
