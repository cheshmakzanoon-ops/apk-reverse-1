local ReplaceHeroIdAppearanceTriggerEvent = BaseClass("ReplaceHeroIdAppearanceTriggerEvent")

function ReplaceHeroIdAppearanceTriggerEvent:__init()
end

function ReplaceHeroIdAppearanceTriggerEvent:__delete()
end

function ReplaceHeroIdAppearanceTriggerEvent:Execute(param, extra, sourceId)
  if not extra then
    return
  end
  local newHeroId = 0
  local para = param.para
  if not string.IsNullOrEmpty(para) then
    local paraList = string.split(para, "|")
    if #paraList == 2 then
      newHeroId = tonumber(paraList[2])
    end
  end
  if DataCenter.LWBattleManager.logic.ReplaceHeroIdAppearance then
    DataCenter.LWBattleManager.logic:ReplaceHeroIdAppearance(param, extra, newHeroId)
  end
  if DataCenter.LWBattleManager.logic.TryCheatTriggerItem then
    local cheatHeroIds = {}
    table.insert(cheatHeroIds, extra + 2)
    table.insert(cheatHeroIds, newHeroId + 2)
    DataCenter.LWBattleManager.logic:TryCheatTriggerItem(param.id, cheatHeroIds, sourceId)
  end
end

return ReplaceHeroIdAppearanceTriggerEvent
