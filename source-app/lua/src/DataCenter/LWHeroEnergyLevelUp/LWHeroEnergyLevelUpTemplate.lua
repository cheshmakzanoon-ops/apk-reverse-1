local LWHeroEnergyLevelUpTemplate = BaseClass("LWHeroEnergyLevelUpTemplate")

function LWHeroEnergyLevelUpTemplate:__init()
end

function LWHeroEnergyLevelUpTemplate:__delete()
end

function LWHeroEnergyLevelUpTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.energy_lv1 = row:getValue("energy_lv1")
  self.energy_lv2 = row:getValue("energy_lv2")
  self.energy_lv3 = row:getValue("energy_lv3")
  self.energy_extra = row:getValue("energy_extra")
end

function LWHeroEnergyLevelUpTemplate:GetEnergyEffect(energyCount)
  if energyCount == 1 then
    return self.energy_lv1
  elseif energyCount == 2 then
    return self.energy_lv2
  elseif energyCount == 3 then
    return self.energy_lv3
  elseif 3 < energyCount then
    return self.energy_extra
  else
    return nil
  end
end

return LWHeroEnergyLevelUpTemplate
