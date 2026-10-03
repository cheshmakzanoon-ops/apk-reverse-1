local LWEffectSourceTypeBaseLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeBaseLogic")
local LWEffectSourceTypeProfessionSpecializationLogic = BaseClass("LWEffectSourceTypeProfessionSpecializationLogic", LWEffectSourceTypeBaseLogic)
local base = LWEffectSourceTypeBaseLogic

function LWEffectSourceTypeProfessionSpecializationLogic:__init()
  base.__init(self)
end

function LWEffectSourceTypeProfessionSpecializationLogic:__delete()
  base.__delete(self)
end

function LWEffectSourceTypeProfessionSpecializationLogic:RecalculateData()
  DataCenter.LWEffectOverviewManager:ResetEffectSourceTotalValue(EffectOverviewSourcePoint.ProfessionSpecialization)
  local masteryData = DataCenter.MasteryManager:GetData()
  if masteryData and masteryData.home_id > 0 then
    local masteryPlanData = masteryData:GetCurPlan()
    if masteryPlanData then
      local groupLevelDict = masteryPlanData:GetGroupLevelDict()
      if groupLevelDict then
        for groupId, level in pairs(groupLevelDict) do
          if 0 < level then
            local masteryTemplate = DataCenter.MasteryManager:GetTempByGroupIdAndLevel(groupId, level)
            if masteryTemplate and masteryTemplate.skill == 0 then
              for effectId, effectValue in pairs(masteryTemplate.effectDict) do
                DataCenter.LWEffectOverviewManager:RefreshEffectSourceTotalValue(EffectOverviewSourcePoint.ProfessionSpecialization, effectId, effectValue)
              end
            end
          end
        end
      end
    end
  end
  local dataList = DataCenter.StatusManager:GetAllBuffData()
  for i = 1, #dataList do
    local statusMeta = dataList[i]
    if statusMeta and toInt(statusMeta.meta.effect_overview_type) == EffectOverviewSourceType.ProfessionSpecialization then
      local effectId = statusMeta.meta.effect
      local effectValue = statusMeta.meta.effect_num
      DataCenter.LWEffectOverviewManager:RefreshEffectSourceTotalValue(EffectOverviewSourcePoint.ProfessionSpecialization, tonumber(effectId), tonumber(effectValue))
    end
  end
end

return LWEffectSourceTypeProfessionSpecializationLogic
