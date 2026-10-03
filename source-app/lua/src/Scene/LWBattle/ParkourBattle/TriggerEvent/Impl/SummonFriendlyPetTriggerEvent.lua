local SummonFriendlyPetTriggerEvent = BaseClass("SummonFriendlyPetTriggerEvent")

function SummonFriendlyPetTriggerEvent:__init()
end

function SummonFriendlyPetTriggerEvent:__delete()
end

function SummonFriendlyPetTriggerEvent:Execute(param, extra, sourceId)
  if DataCenter.LWBattleManager.logic and DataCenter.LWBattleManager.logic.SummonFriendlyPetByTrigger then
    DataCenter.LWBattleManager.logic:SummonFriendlyPetByTrigger(param, extra, sourceId)
  else
    Logger.LogError("[SummonFriendlyPetTriggerEvent.Execute] battle logic is invalid, sourceId\228\184\186:" .. tostring(sourceId))
  end
end

return SummonFriendlyPetTriggerEvent
