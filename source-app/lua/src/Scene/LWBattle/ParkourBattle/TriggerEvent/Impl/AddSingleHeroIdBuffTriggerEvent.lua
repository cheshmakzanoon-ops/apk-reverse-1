local AddSingleHeroIdBuffTriggerEvent = BaseClass("AddSingleHeroIdBuffTriggerEvent")

function AddSingleHeroIdBuffTriggerEvent:__init()
end

function AddSingleHeroIdBuffTriggerEvent:__delete()
end

function AddSingleHeroIdBuffTriggerEvent:Execute(param, extra)
  if not extra then
    return
  end
  local gain_effect = param.gain_effect
  local heros = DataCenter.LWBattleManager.logic.team.teamUnits
  if heros then
    for _, hero in pairs(heros) do
      if hero.hero and hero.hero.heroId and hero.hero.heroId == extra then
        local para = param.para
        if not string.IsNullOrEmpty(para) then
          local paraList = string.split(para, "|")
          if #paraList == 2 and not string.IsNullOrEmpty(paraList[2]) then
            local buffList = string.split(paraList[2], ",")
            for _, buffId in ipairs(buffList) do
              hero:AddBuff(buffId)
            end
            if not string.IsNullOrEmpty(gain_effect) and hero.transform then
              DataCenter.LWBattleManager.logic:ShowEffectObj(gain_effect, nil, nil, 5, hero.transform)
            end
          end
        end
        break
      end
    end
  end
end

return AddSingleHeroIdBuffTriggerEvent
