local LWEffectSourceTypeBaseLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeBaseLogic")
local LWEffectSourceTypeTacticalCardLogic = BaseClass("LWEffectSourceTypeTacticalCardLogic", LWEffectSourceTypeBaseLogic)
local base = LWEffectSourceTypeBaseLogic

function LWEffectSourceTypeTacticalCardLogic:__init()
  base.__init(self)
end

function LWEffectSourceTypeTacticalCardLogic:__delete()
  base.__delete(self)
end

function LWEffectSourceTypeTacticalCardLogic:RecalculateData()
  DataCenter.LWEffectOverviewManager:ResetEffectSourceTotalValue(EffectOverviewSourcePoint.TacticalCard)
  local cards = DataCenter.TacticalCardDataManager:GetAllEquipCardData()
  local allAttrs = {}
  if cards then
    for i = 1, #cards do
      local card = cards[i]
      if card then
        local cardAttrs = card:GetAllAttrs()
        for attrId, value in pairs(cardAttrs) do
          allAttrs[attrId] = value + (allAttrs[attrId] or 0)
        end
      end
    end
  end
  for attrId, value in pairs(allAttrs) do
    DataCenter.LWEffectOverviewManager:RefreshEffectSourceTotalValue(EffectOverviewSourcePoint.TacticalCard, attrId, value)
  end
end

return LWEffectSourceTypeTacticalCardLogic
