local ParkourFormation = BaseClass("ParkourFormation")

function ParkourFormation:Init(initBattleFormation, backwards, defense, formationSpecialType)
end

function ParkourFormation:ChangeToBattleFormation()
end

function ParkourFormation:GetOffsetByIndex(index)
end

function ParkourFormation:ReSize(index, force)
end

function ParkourFormation:GetWeaponPos()
end

function ParkourFormation:OnReplaceAppearance(newHeroId)
  return false
end

return ParkourFormation
