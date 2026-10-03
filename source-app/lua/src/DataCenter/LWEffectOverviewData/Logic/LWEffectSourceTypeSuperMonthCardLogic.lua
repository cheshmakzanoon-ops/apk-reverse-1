local LWEffectSourceTypeBaseLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeBaseLogic")
local LWEffectSourceTypeSuperMonthCardLogic = BaseClass("LWEffectSourceTypeSuperMonthCardLogic", LWEffectSourceTypeBaseLogic)
local base = LWEffectSourceTypeBaseLogic

function LWEffectSourceTypeSuperMonthCardLogic:__init()
  base.__init(self)
end

function LWEffectSourceTypeSuperMonthCardLogic:__delete()
  base.__delete(self)
end

function LWEffectSourceTypeSuperMonthCardLogic:RecalculateData()
  DataCenter.LWEffectOverviewManager:ResetEffectSourceTotalValue(EffectOverviewSourcePoint.SuperMonthCard)
  local monthCardActive = DataCenter.MonthCardNewManager:CheckIfMonthCardActive()
  if monthCardActive then
    local monthCardInfo = DataCenter.MonthCardNewManager:GetGolloesMonthCard()
    local monthCardTemplate = LocalController:instance():getLine("monthcard", monthCardInfo:GetId())
    if monthCardTemplate and not string.IsNullOrEmpty(monthCardTemplate.effect) then
      local effectStr = string.split(monthCardTemplate.effect, "|")
      for i = 1, table.count(effectStr) do
        local effectData = string.split(effectStr[i], ";")
        if table.count(effectData) == 2 then
          local effectId = tonumber(effectData[1])
          local effectValue = tonumber(effectData[2])
          DataCenter.LWEffectOverviewManager:RefreshEffectSourceTotalValue(EffectOverviewSourcePoint.SuperMonthCard, effectId, effectValue)
        end
      end
    end
  end
end

return LWEffectSourceTypeSuperMonthCardLogic
