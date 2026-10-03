local base = require("Scene.Battlefield.Common.BattlefieldBuildTemplate")
local BattlefieldWinterStormBuildTemplate = BaseClass("BattlefieldWinterStormBuildTemplate", base)

function BattlefieldWinterStormBuildTemplate:IsBuild()
  local cType = self.type
  return 201 <= cType and cType < 300
end

function BattlefieldWinterStormBuildTemplate:IsDefence()
  local cType = self.type
  return cType == 201 or cType == 202 or cType == 203
end

function BattlefieldWinterStormBuildTemplate:IsScoreBox()
  local cType = self.type
  return 401 <= cType and cType < 500
end

function BattlefieldWinterStormBuildTemplate:IsDrop()
  local cType = self.type
  return 301 <= cType and cType < 400
end

return BattlefieldWinterStormBuildTemplate
