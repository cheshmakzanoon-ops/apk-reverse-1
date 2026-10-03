local BattleStartTriggerTask = BaseClass("BattleStartTriggerTask")
local TriggerEnum = require("Scene.LWBattle.ParkourBattle.TriggerEvent.TriggerEnum")

function BattleStartTriggerTask:__init(triggerIdList)
  self.triggerIdList = triggerIdList
end

function BattleStartTriggerTask:__delete()
  self.triggerIdList = nil
end

function BattleStartTriggerTask:funcName()
end

function BattleStartTriggerTask:GetPreSelectHeroUuid(triggerMeta)
  local preSelectHeroUuid
  local triggerType = triggerMeta.type
  if triggerType == TriggerEnum.EventType.AddSingleHeroSkill or triggerType == TriggerEnum.EventType.AddSingleHeroBuff or triggerType == TriggerEnum.EventType.ReplaceSingleHeroNormalAttack then
    if DataCenter.LWBattleManager.logic.GetRandomInitUuid then
      preSelectHeroUuid = DataCenter.LWBattleManager.logic:GetRandomInitUuid()
    end
  elseif triggerType == TriggerEnum.EventType.AddSingleHeroIdBuff or triggerType == TriggerEnum.EventType.AddHeroIdGlobalBuff then
    local para = triggerMeta.para
    if not string.IsNullOrEmpty(para) then
      local paraList = string.split(para, "|")
      if #paraList == 2 then
        preSelectHeroUuid = tonumber(paraList[1]) or 0
      end
    end
  elseif triggerType == TriggerEnum.EventType.ReplaceHeroIdNormalAttack then
    local para = triggerMeta.para
    if not string.IsNullOrEmpty(para) then
      local paraList = string.split(para, "|")
      if #paraList == 2 then
        preSelectHeroUuid = tonumber(paraList[1]) or 0
      end
    end
  elseif triggerType == TriggerEnum.EventType.ReplaceHeroIdAppearance then
    local para = triggerMeta.para
    if not string.IsNullOrEmpty(para) then
      local paraList = string.split(para, "|")
      if #paraList == 2 then
        preSelectHeroUuid = tonumber(paraList[1]) or 0
      end
    end
  elseif triggerType == TriggerEnum.EventType.AddEnergy then
    local para = triggerMeta.para
    local index = tonumber(para) or 0
    if 0 < index and DataCenter.LWBattleManager.logic.GetInitUuidAuto then
      preSelectHeroUuid = DataCenter.LWBattleManager.logic:GetInitUuidAuto(index)
    end
  elseif triggerType == TriggerEnum.EventType.ThreeChoices then
    local triggerCount = triggerMeta.paraArray and #triggerMeta.paraArray or 0
    if 0 < triggerCount and DataCenter.LWBattleManager.logic.GetRandomInitUuid then
      preSelectHeroUuid = {}
      for i = 1, triggerCount do
        table.insert(preSelectHeroUuid, DataCenter.LWBattleManager.logic:GetRandomInitUuid())
      end
    end
  elseif triggerType == TriggerEnum.EventType.AddHero then
    preSelectHeroUuid = 1
  else
    Logger.LogError("\229\188\128\229\156\186TriggerTask GetPreSelectHeroUuid \230\156\170\229\164\132\231\144\134\231\154\132\231\177\187\229\158\139: " .. triggerType)
  end
  return preSelectHeroUuid
end

function BattleStartTriggerTask:Gen()
  if self.triggerIdList then
    for i, v in ipairs(self.triggerIdList) do
      local triggerMeta = DataCenter.LWTriggerItemTemplateManager:GetTemplate(v)
      if triggerMeta then
        DataCenter.LWBattleManager.logic.triggerEventMgr:Trigger(triggerMeta.type, triggerMeta, self:GetPreSelectHeroUuid(triggerMeta))
      end
    end
  end
end

return BattleStartTriggerTask
