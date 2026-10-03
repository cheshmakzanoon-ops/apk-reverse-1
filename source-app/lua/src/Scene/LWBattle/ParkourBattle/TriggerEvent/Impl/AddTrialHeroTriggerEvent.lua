local AddTrialHeroTriggerEvent = BaseClass("AddTrialHeroTriggerEvent")

function AddTrialHeroTriggerEvent:__init()
end

function AddTrialHeroTriggerEvent:__delete()
end

function AddTrialHeroTriggerEvent:Execute(param)
  local spl = string.split(param.para, ",")
  if #spl == 3 and DataCenter.LWBattleManager.logic.team and DataCenter.LWBattleManager.logic.team.AddTrialHero then
    DataCenter.LWBattleManager.logic.team:AddTrialHero(tonumber(spl[1]), tonumber(spl[2]), tonumber(spl[3]))
  end
end

return AddTrialHeroTriggerEvent
