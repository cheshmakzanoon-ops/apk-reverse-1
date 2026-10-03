local LWEffectSourceTypeBaseLogic = require("DataCenter.LWEffectOverviewData.Logic.LWEffectSourceTypeBaseLogic")
local LWEffectSourceTypeTacticalWeaponLevelLogic = BaseClass("LWEffectSourceTypeTacticalWeaponLevelLogic", LWEffectSourceTypeBaseLogic)
local base = LWEffectSourceTypeBaseLogic

function LWEffectSourceTypeTacticalWeaponLevelLogic:__init()
  base.__init(self)
end

function LWEffectSourceTypeTacticalWeaponLevelLogic:__delete()
  base.__delete(self)
end

function LWEffectSourceTypeTacticalWeaponLevelLogic:RecalculateData()
  DataCenter.LWEffectOverviewManager:ResetEffectSourceTotalValue(EffectOverviewSourcePoint.TacticalWeaponLevel)
end

return LWEffectSourceTypeTacticalWeaponLevelLogic
