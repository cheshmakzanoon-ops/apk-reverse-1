local AddHeroIdGlobalBuffTriggerEvent = BaseClass("AddHeroIdGlobalBuffTriggerEvent")

function AddHeroIdGlobalBuffTriggerEvent:__init()
end

function AddHeroIdGlobalBuffTriggerEvent:__delete()
end

function AddHeroIdGlobalBuffTriggerEvent:Execute(param, extra)
  if not extra then
    return
  end
  local para = param.para
  local buffList
  if not string.IsNullOrEmpty(para) then
    local buffMap = {}
    buffMap[extra] = {}
    local paraList = string.split(para, "|")
    if #paraList == 2 and not string.IsNullOrEmpty(paraList[2]) then
      buffList = string.split(paraList[2], ",")
    end
  end
  if buffList and DataCenter.LWBattleManager.logic.AddHeroIdGlobalBuff then
    DataCenter.LWBattleManager.logic:AddHeroIdGlobalBuff(param, extra, buffList)
  end
end

return AddHeroIdGlobalBuffTriggerEvent
