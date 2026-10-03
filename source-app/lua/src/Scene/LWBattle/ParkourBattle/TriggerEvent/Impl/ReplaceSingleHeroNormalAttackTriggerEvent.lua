local ReplaceSingleHeroNormalAttackTriggerEvent = BaseClass("ReplaceSingleHeroNormalAttack")

function ReplaceSingleHeroNormalAttackTriggerEvent:__init()
end

function ReplaceSingleHeroNormalAttackTriggerEvent:__delete()
end

function ReplaceSingleHeroNormalAttackTriggerEvent:Execute(param, extra)
  if not extra then
    return
  end
  if DataCenter.LWBattleManager.logic.ReplaceHeroUuidNormalAttack then
    DataCenter.LWBattleManager.logic:ReplaceHeroUuidNormalAttack(param, extra, tonumber(param.para))
  end
end

return ReplaceSingleHeroNormalAttackTriggerEvent
