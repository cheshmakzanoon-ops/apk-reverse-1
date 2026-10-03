local LWEffectSourceTypeBaseLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeBaseLogic")
local LWEffectSourceTypeTechLogic = BaseClass("LWEffectSourceTypeTechLogic", LWEffectSourceTypeBaseLogic)
local base = LWEffectSourceTypeBaseLogic

function LWEffectSourceTypeTechLogic:__init()
  base.__init(self)
end

function LWEffectSourceTypeTechLogic:__delete()
  base.__delete(self)
end

function LWEffectSourceTypeTechLogic:RecalculateData()
  DataCenter.LWEffectOverviewManager:ResetEffectSourceTotalValue(EffectOverviewSourcePoint.Tech)
  local scienceList = DataCenter.ScienceDataManager:GetAllScienceOnlyRead()
  for k, v in pairs(scienceList) do
    if v.level > 0 then
      local id = v.itemId
      local level = v.level
      local template = DataCenter.ScienceTemplateManager:GetScienceTemplate(id, level)
      if template ~= nil then
        for effectK, effectV in pairs(template.effect) do
          local effectId = tonumber(effectV.effectId)
          local effectVal = tonumber(effectV.effectValue)
          if DataCenter.LWEffectOverviewManager:IsContainsSourcePointData(EffectOverviewSourcePoint.Tech, effectId) then
            DataCenter.LWEffectOverviewManager:RefreshEffectSourceTotalValue(EffectOverviewSourcePoint.Tech, effectId, effectVal)
          end
        end
      end
    end
  end
end

return LWEffectSourceTypeTechLogic
