local DragonBlockRange = {}
local BattleFieldBlockRangeUtil = require("Util.BattleFieldBlockRangeUtil")
local accessor = BattleFieldBlockRangeUtil.CreateBlockRangeAccessor("Util.BattleFieldBlockRange.Desert")

function DragonBlockRange.SetBlockRangeData(idx)
  return accessor.SetBlockRangeData(idx)
end

function DragonBlockRange.IsInBlockRange(pointId)
  local t = accessor.GetBlockRangeValue(pointId)
  if t == 0 then
    return false
  end
  if t == 1 then
    return true
  end
  local BattleInfo = DataCenter.ActDragonManager:GetCurBattleInfo()
  if BattleInfo == nil then
    return false
  end
  if BattleInfo.selfSide == 0 then
    return t == 2
  else
    return t == 3
  end
  return false
end

return ConstClass("DragonBlockRange", DragonBlockRange)
