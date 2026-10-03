local ReplaceHeroIdNormalAttackTriggerEvent = BaseClass("ReplaceHeroIdNormalAttackTriggerEvent")

function ReplaceHeroIdNormalAttackTriggerEvent:__init()
end

function ReplaceHeroIdNormalAttackTriggerEvent:__delete()
end

function ReplaceHeroIdNormalAttackTriggerEvent:Execute(param, extra)
  if not extra then
    return
  end
  local skillId = 0
  local para = param.para
  if not string.IsNullOrEmpty(para) then
    local paraList = string.split(para, "|")
    if #paraList == 2 then
      skillId = tonumber(paraList[2])
    end
  end
  if DataCenter.LWBattleManager.logic.ReplaceHeroIdNormalAttack then
    DataCenter.LWBattleManager.logic:ReplaceHeroIdNormalAttack(param, extra, skillId)
  end
end

return ReplaceHeroIdNormalAttackTriggerEvent
