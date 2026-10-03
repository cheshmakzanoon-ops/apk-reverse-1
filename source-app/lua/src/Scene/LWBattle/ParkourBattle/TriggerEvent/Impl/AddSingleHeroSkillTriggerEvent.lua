local AddSingleHeroSkillTriggerEvent = BaseClass("AddSingleHeroSkillTriggerEvent")

function AddSingleHeroSkillTriggerEvent:__init()
end

function AddSingleHeroSkillTriggerEvent:__delete()
end

function AddSingleHeroSkillTriggerEvent:Execute(param, extra)
  if not extra then
    return
  end
  if DataCenter.LWBattleManager.logic.AddHeroUuidSkill then
    DataCenter.LWBattleManager.logic:AddHeroUuidSkill(param, extra, tonumber(param.para))
  end
end

return AddSingleHeroSkillTriggerEvent
