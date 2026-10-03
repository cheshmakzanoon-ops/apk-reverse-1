local base = require("Scene.LWBattle.ParkourBattle.Team.ParkourFormation")
local ParkourTeamFormation = BaseClass("ParkourTeamFormation", base)
local FirstXOffset = 1
local XOffset = 1
local ZOffset = 2
local ZStart = 2.5
local DefaultNormalFirstXOffset = 1
local DefaultNormalXOffset = 1
local DefaultNormalZOffset = 2
local DefaultNormalZStart = 2.5
local DefaultDefenseFirstXOffset = 1.8
local DefaultDefenseXOffset = 2.9
local DefaultDefenseZOffset = 2.5
local DefaultDefenseZStart = 2.5
local DefenseFirstXOffset = 1.8
local DefenseXOffset = 2.9
local DefenseZOffset = 2.5
local DefenseZStart = 2.5
local RowNumber = 3
local BaseCount = 5
local defaultWeaponPos = 6
local weaponPos = 6

function ParkourTeamFormation:__init(specialPos)
  self.pos = nil
  self.posCount = 0
  if specialPos and type(specialPos) == "table" and #specialPos == 4 then
    DefenseFirstXOffset = specialPos[1]
    DefenseXOffset = specialPos[2]
    DefenseZOffset = specialPos[3]
    DefenseZStart = specialPos[4]
    FirstXOffset = DefenseFirstXOffset
    XOffset = DefenseXOffset
    ZOffset = DefenseZOffset
    ZStart = DefenseZStart
  else
    DefenseFirstXOffset = DefaultDefenseFirstXOffset
    DefenseXOffset = DefaultDefenseXOffset
    DefenseZOffset = DefaultDefenseZOffset
    DefenseZStart = DefaultDefenseZStart
    FirstXOffset = DefaultNormalFirstXOffset
    XOffset = DefaultNormalXOffset
    ZOffset = DefaultNormalZOffset
    ZStart = DefaultNormalZStart
  end
end

function ParkourTeamFormation:__delete()
  self.pos = nil
  self.posCount = 0
end

function ParkourTeamFormation:Init(initBattleFormation, backwards, defense, formationSpecialType)
  base.Init(self, initBattleFormation, backwards, defense, formationSpecialType)
  self.backwards = backwards
  self.defense = defense
  local zStart = self.defense and DefenseZStart or ZStart
  if initBattleFormation then
    weaponPos = -1
    self.pos = {}
    self:ReSize(BaseCount, true)
  else
    self.pos = {
      [1] = Vector3.New(-2.3, 0, zStart),
      [2] = Vector3.New(2.3, 0, zStart),
      [3] = Vector3.New(-3.3, 0, zStart - 4),
      [4] = Vector3.New(0, 0, zStart - 4),
      [5] = Vector3.New(3.3, 0, zStart - 4)
    }
    self.posCount = 5
    local has = DataCenter.TacticalWeaponManager:HasTacticalWeapon()
    if has then
      weaponPos = defaultWeaponPos
    else
      weaponPos = -1
    end
  end
  self.canResize = true
end

function ParkourTeamFormation:ChangeToBattleFormation()
  base.ChangeToBattleFormation(self)
  self:ReSize(self.posCount, true)
end

function ParkourTeamFormation:GetOffsetByIndex(index)
  base.GetOffsetByIndex(self, index)
  if index > self.posCount then
    self:ReSize(index)
  end
  return self.pos[index]
end

function ParkourTeamFormation:ReSize(index, force)
  base.ReSize(self, index, force)
  local addCount = index - self.posCount
  if addCount <= 0 and not force then
    return self.posCount
  end
  local skipWeaponPos = 0
  if 0 < weaponPos and index >= weaponPos then
    skipWeaponPos = 1
  end
  local firstXOffset = self.defense and DefenseFirstXOffset or FirstXOffset
  local xOffset = self.defense and DefenseXOffset or XOffset
  local zOffset = self.defense and DefenseZOffset or ZOffset
  local zStart = self.defense and DefenseZStart or ZStart
  addCount = math.ceil(addCount / RowNumber) * RowNumber
  local newCount = self.posCount + addCount
  local StartZ = zStart
  if not self.backwards then
    local OffsetCount = newCount + skipWeaponPos - BaseCount
    local OffsetRow = math.floor(OffsetCount / RowNumber)
    local OffsetZ = OffsetRow / 2 * zOffset
    StartZ = zStart + OffsetZ
  end
  for i = 1, newCount do
    if i == 1 then
      self.pos[i] = Vector3.New(-firstXOffset, 0, StartZ)
    elseif i == 2 then
      self.pos[i] = Vector3.New(firstXOffset, 0, StartZ)
    elseif i <= BaseCount then
      local offset = i - 2
      local x = (offset - 1) % RowNumber
      local z = math.ceil(offset / RowNumber)
      self.pos[i] = Vector3.New(xOffset * (x - 1), 0, StartZ - z * zOffset)
    else
      local calcIndex = i
      if 0 < weaponPos and i >= weaponPos then
        calcIndex = calcIndex + 1
      end
      local offset = calcIndex - 2
      local x = (offset - 1) % RowNumber
      local z = math.ceil(offset / RowNumber)
      self.pos[i] = Vector3.New(xOffset * math.ceil(x / 2) * (-1) ^ x, 0, StartZ - z * zOffset)
    end
  end
  self.posCount = newCount
  return self.posCount
end

function ParkourTeamFormation:GetWeaponPos()
  base.GetWeaponPos(self)
  if not self.posCount then
    return Vector3.zero
  end
  local pos = self.pos[5]
  local posZ = pos.z - 3
  return Vector3.New(0, 0, posZ)
end

return ParkourTeamFormation
