local LWEffectSourceTypeBaseLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeBaseLogic")
local LWEffectSourceTypeTacticalWeaponChipLogic = BaseClass("LWEffectSourceTypeTacticalWeaponChipLogic", LWEffectSourceTypeBaseLogic)
local base = LWEffectSourceTypeBaseLogic

function LWEffectSourceTypeTacticalWeaponChipLogic:__init()
  base.__init(self)
end

function LWEffectSourceTypeTacticalWeaponChipLogic:__delete()
  base.__delete(self)
end

function LWEffectSourceTypeTacticalWeaponChipLogic:RecalculateData()
  DataCenter.LWEffectOverviewManager:ResetEffectSourceTotalValue(EffectOverviewSourcePoint.TacticalWeaponChip)
end

return LWEffectSourceTypeTacticalWeaponChipLogic
