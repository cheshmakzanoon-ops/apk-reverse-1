local SaveHeroTriggerEvent = BaseClass("SaveHeroTriggerEvent")
local AddHeroEffect = "VFX_xishou_gaotouchuxian_jiangli"

function SaveHeroTriggerEvent:__init()
end

function SaveHeroTriggerEvent:__delete()
end

function SaveHeroTriggerEvent:Execute(param)
  local spl = string.split(param.para, "|")
  local heros = {}
  for _, value in ipairs(spl) do
    table.insert(heros, tonumber(value))
  end
  if DataCenter.LWBattleManager.logic.AddDelayEvent then
    DataCenter.LWBattleManager.logic:AddDelayEvent(function()
      for _, heroId in ipairs(heros) do
        DataCenter.LWBattleManager.logic.team:SaveHero(heroId)
      end
    end, 0.5)
  else
    for _, heroId in ipairs(heros) do
      DataCenter.LWBattleManager.logic.team:SaveHero(heroId)
    end
  end
end

return SaveHeroTriggerEvent
