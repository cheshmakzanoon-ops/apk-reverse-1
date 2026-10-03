local DsbDuelBlockRange = {}
local BattleFieldBlockRangeUtil = require("Util.BattleFieldBlockRangeUtil")
local accessor = BattleFieldBlockRangeUtil.CreateBlockRangeAccessor("Util.BattleFieldBlockRange.DsbDuel")

function DsbDuelBlockRange.SetBlockRangeData(idx)
  return accessor.SetBlockRangeData(idx)
end

function DsbDuelBlockRange.GetBlockRangeValue(pointId)
  return accessor.GetBlockRangeValue(pointId)
end

function DsbDuelBlockRange.IsInBlockRange(pointId)
  local t = DsbDuelBlockRange.GetBlockRangeValue(pointId)
  if t == 0 then
    return
  end
  if t == 1 then
    return true
  end
  local myRole = BattlefieldDsbDuelUtils.GetMyRoleId()
  return t ~= myRole + 1
end

return ConstClass("DsbDuelBlockRange", DsbDuelBlockRange)
