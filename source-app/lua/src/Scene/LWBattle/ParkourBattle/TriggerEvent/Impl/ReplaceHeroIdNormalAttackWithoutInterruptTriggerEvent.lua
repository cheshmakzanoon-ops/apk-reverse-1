local ReplaceHeroIdNormalAttackWithoutInterruptTriggerEvent = BaseClass("ReplaceHeroIdNormalAttackWithoutInterruptTriggerEvent")

function ReplaceHeroIdNormalAttackWithoutInterruptTriggerEvent:__init()
end

function ReplaceHeroIdNormalAttackWithoutInterruptTriggerEvent:__delete()
end

function ReplaceHeroIdNormalAttackWithoutInterruptTriggerEvent:Execute(param, extra)
  if not extra then
    return
  end
  local newSkillId = 0
  local para = param.para
  if not string.IsNullOrEmpty(para) then
    local paraList = string.split(para, "|")
    if #paraList == 2 then
      newSkillId = tonumber(paraList[2])
    end
  end
  if 0 < newSkillId and DataCenter.LWBattleManager.logic.ReplaceHeroIdNormalAttackWithoutInterrupt then
    DataCenter.LWBattleManager.logic:ReplaceHeroIdNormalAttackWithoutInterrupt(param, extra, newSkillId)
  end
end

return ReplaceHeroIdNormalAttackWithoutInterruptTriggerEvent
