local AddHeroIdEnergyTriggerEvent = BaseClass("AddHeroIdEnergyTriggerEvent")

function AddHeroIdEnergyTriggerEvent:__init()
end

function AddHeroIdEnergyTriggerEvent:__delete()
end

function AddHeroIdEnergyTriggerEvent:Execute(param, extra)
  if not extra then
    return
  end
  if DataCenter.LWBattleManager.logic.AddHeroUuidEnergy then
    DataCenter.LWBattleManager.logic:AddHeroUuidEnergy(param, extra)
  end
end

return AddHeroIdEnergyTriggerEvent
