local LWEffectSourceTypeBaseLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeBaseLogic")
local LWEffectSourceTypeServerLogic = BaseClass("LWEffectSourceTypeServerLogic", LWEffectSourceTypeBaseLogic)
local base = LWEffectSourceTypeBaseLogic

function LWEffectSourceTypeServerLogic:__init()
  base.__init(self)
end

function LWEffectSourceTypeServerLogic:__delete()
  base.__delete(self)
end

function LWEffectSourceTypeServerLogic:RecalculateData()
  DataCenter.LWEffectOverviewManager:ResetEffectSourceTotalValue(EffectOverviewSourcePoint.Server)
  local effectData = DataCenter.LWEffectOverviewManager:GetEffectDataByEffectOverviewSourcePoint(EffectOverviewSourcePoint.Server)
  if effectData then
    for effectId, configIds in pairs(effectData) do
      local effectValue = DataCenter.ServerStatusManager:GetEffectById(effectId)
      DataCenter.LWEffectOverviewManager:RefreshEffectSourceTotalValue(EffectOverviewSourcePoint.Server, effectId, effectValue)
    end
  end
end

return LWEffectSourceTypeServerLogic
