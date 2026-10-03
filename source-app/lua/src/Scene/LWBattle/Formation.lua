local Const = require("Scene.LWBattle.Const")
local Formation = BaseClass("Formation")

function Formation:__init(squad)
  self.squad = squad
  self.memberCount = nil
  self.pos = nil
  self.hasDominator = nil
  self.positionType = nil
end

function Formation:__delete()
  self.squad = nil
  self.pos = nil
  self.hasDominator = nil
  self.positionType = nil
end

function Formation:RefreshPositions(hasDominator, positionType)
  if self.hasDominator == hasDominator and self.positionType == positionType then
    return false
  end
  if positionType == ArmyFormationPositionType.DominatorAndHero345 then
    self.pos = Const.ArmyFormationPositionDominatorAndHero345
  elseif positionType == ArmyFormationPositionType.OnlyDominator then
    self.pos = Const.ArmyFormationPositionOnlyDominator
  elseif hasDominator then
    self.pos = Const.ArmyFormationPositionNormalWithDominator
  else
    self.pos = Const.ArmyFormationPositionNormalWithoutDominator
  end
  if hasDominator == nil then
    hasDominator = false
  end
  if positionType == nil then
    positionType = ArmyFormationPositionType.Normal
  end
  self.hasDominator = hasDominator
  self.positionType = positionType
  return true
end

function Formation:Init(hasDominator, positionType)
  self.memberCount = #self.squad.members
  self:RefreshPositions(hasDominator, positionType)
  self.weaponPos = Vector3.New(0, 0, -6)
  if hasDominator == nil then
    self.hasDominator = false
  else
    self.hasDominator = hasDominator
  end
end

function Formation:GetOffsetByIndex(index)
  return self.pos[index]
end

function Formation:GetWeaponOffset()
  return self.weaponPos
end

return Formation
