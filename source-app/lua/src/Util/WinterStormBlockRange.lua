local WinterStormBlockRange = {}
local BattleFieldBlockRangeUtil = require("Util.BattleFieldBlockRangeUtil")
local accessor = BattleFieldBlockRangeUtil.CreateBlockRangeAccessor("Util.BattleFieldBlockRange.Winter")

function WinterStormBlockRange.SetBlockRangeData(idx)
  return accessor.SetBlockRangeData(idx)
end

function WinterStormBlockRange.IsInBlockRange(pointId)
  local t = accessor.GetBlockRangeValue(pointId)
  if t == 0 then
    return false
  end
  if t == 1 then
    return true
  end
  local mySide = DataCenter.ActWinterStormManager:GetMySide()
  local checkNum = 0
  if mySide == 1 then
    checkNum = 2
  elseif mySide == 2 then
    checkNum = 3
  end
  return t == checkNum
end

return ConstClass("WinterStormBlockRange", WinterStormBlockRange)
