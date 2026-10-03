local SummonMonsterBatchTriggerEvent = BaseClass("SummonMonsterBatchTriggerEvent")

function SummonMonsterBatchTriggerEvent:__init()
end

function SummonMonsterBatchTriggerEvent:__delete()
end

function SummonMonsterBatchTriggerEvent:Execute(param, extra)
  if not extra then
    return
  end
  if DataCenter.LWBattleManager.logic.SummonMonsterBatch then
    DataCenter.LWBattleManager.logic:SummonMonsterBatch(extra.fromPos, extra.summonMonsterId, extra.summonCount, extra.posOffset, extra.hp, extra.monsterMeta)
  end
end

return SummonMonsterBatchTriggerEvent
