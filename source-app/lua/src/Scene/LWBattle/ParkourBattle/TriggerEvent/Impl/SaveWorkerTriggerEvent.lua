local SaveWorkerTriggerEvent = BaseClass("SaveWorkerTriggerEvent")
local AddHeroEffect = "VFX_xishou_gaotouchuxian_jiangli"

function SaveWorkerTriggerEvent:__init()
end

function SaveWorkerTriggerEvent:__delete()
end

function SaveWorkerTriggerEvent:Execute(param)
  local spl = string.split(param.para, "|")
  local heros = {}
  for _, value in ipairs(spl) do
    table.insert(heros, tonumber(value))
  end
  if DataCenter.LWBattleManager.logic.AddDelayEvent then
    DataCenter.LWBattleManager.logic:AddDelayEvent(function()
      for _, heroId in ipairs(heros) do
        DataCenter.LWBattleManager.logic.team:AddWorker(heroId)
      end
    end, 0.5)
  else
    for _, heroId in ipairs(heros) do
      DataCenter.LWBattleManager.logic.team:AddWorker(heroId)
    end
  end
end

return SaveWorkerTriggerEvent
