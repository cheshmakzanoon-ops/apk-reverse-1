local ReplaceHeroIdActiveAttackWithoutInterruptTriggerEvent = BaseClass("ReplaceHeroIdActiveAttackWithoutInterruptTriggerEvent")

function ReplaceHeroIdActiveAttackWithoutInterruptTriggerEvent:__init()
end

function ReplaceHeroIdActiveAttackWithoutInterruptTriggerEvent:__delete()
end

function ReplaceHeroIdActiveAttackWithoutInterruptTriggerEvent:Execute(param, extra)
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
  if 0 < newSkillId and DataCenter.LWBattleManager.logic.ReplaceHeroIdActiveAttackWithoutInterrupt then
    DataCenter.LWBattleManager.logic:ReplaceHeroIdActiveAttackWithoutInterrupt(param, extra, newSkillId)
  end
end

return ReplaceHeroIdActiveAttackWithoutInterruptTriggerEvent
