local AddSingleHeroBuffTriggerEvent = BaseClass("AddSingleHeroBuffTriggerEvent")

function AddSingleHeroBuffTriggerEvent:__init()
end

function AddSingleHeroBuffTriggerEvent:__delete()
end

function AddSingleHeroBuffTriggerEvent:Execute(param, extra)
  if not extra then
    return
  end
  local gain_effect = param.gain_effect
  local heros = DataCenter.LWBattleManager.logic.team.teamUnits
  if heros then
    for _, hero in pairs(heros) do
      if hero.hero and hero.hero.uuid and hero.hero.uuid == extra then
        hero:AddBuff(param.para)
        if not string.IsNullOrEmpty(gain_effect) and hero.transform then
          DataCenter.LWBattleManager.logic:ShowEffectObj(gain_effect, nil, nil, 5, hero.transform)
        end
        break
      end
    end
  end
end

return AddSingleHeroBuffTriggerEvent
