local AddBuffTriggerEvent = BaseClass("AddBuffTriggerEvent")

function AddBuffTriggerEvent:__init()
end

function AddBuffTriggerEvent:__delete()
end

function AddBuffTriggerEvent:Execute(param)
  local gain_effect = param.gain_effect
  local heros = DataCenter.LWBattleManager.logic.team.teamUnits
  for _, hero in pairs(heros) do
    hero:AddBuff(param.para)
    if not string.IsNullOrEmpty(gain_effect) and hero.transform then
      DataCenter.LWBattleManager.logic:ShowEffectObj(gain_effect, nil, nil, 5, hero.transform)
    end
  end
end

return AddBuffTriggerEvent
