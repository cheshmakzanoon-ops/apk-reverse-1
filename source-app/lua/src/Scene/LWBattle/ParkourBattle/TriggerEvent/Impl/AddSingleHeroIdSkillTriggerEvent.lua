local AddSingleHeroIdSkillTriggerEvent = BaseClass("AddSingleHeroIdSkillTriggerEvent")

function AddSingleHeroIdSkillTriggerEvent:__init()
end

function AddSingleHeroIdSkillTriggerEvent:__delete()
end

function AddSingleHeroIdSkillTriggerEvent:Execute(param, extra)
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
  if DataCenter.LWBattleManager.logic.AddHeroIdSkill then
    DataCenter.LWBattleManager.logic:AddHeroIdSkill(param, extra, skillId)
  end
end

return AddSingleHeroIdSkillTriggerEvent
