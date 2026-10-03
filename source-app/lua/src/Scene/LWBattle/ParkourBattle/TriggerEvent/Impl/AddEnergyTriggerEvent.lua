local AddEnergyTriggerEvent = BaseClass("AddEnergyTriggerEvent")

function AddEnergyTriggerEvent:__init()
end

function AddEnergyTriggerEvent:__delete()
end

function AddEnergyTriggerEvent:Execute(param, extra)
  if not extra then
    return
  end
  if DataCenter.LWBattleManager.logic.AddHeroUuidEnergy then
    DataCenter.LWBattleManager.logic:AddHeroUuidEnergy(param, extra)
  end
end

return AddEnergyTriggerEvent
