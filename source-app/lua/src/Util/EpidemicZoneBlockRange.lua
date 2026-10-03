local EpidemicZoneBlockRange = {}
local BattleFieldBlockRangeUtil = require("Util.BattleFieldBlockRangeUtil")
local accessor = BattleFieldBlockRangeUtil.CreateBlockRangeAccessor("Util.BattleFieldBlockRange.Epidemic")

function EpidemicZoneBlockRange.SetBlockRangeData(idx)
  return accessor.SetBlockRangeData(idx)
end

function EpidemicZoneBlockRange.GetBlockRangeValue(pointId)
  return accessor.GetBlockRangeValue(pointId)
end

function EpidemicZoneBlockRange.IsInBlockRange(pointId)
  local t = EpidemicZoneBlockRange.GetBlockRangeValue(pointId)
  if t == 0 then
    return false
  end
  if t == 1 then
    return true
  end
  local curSide = DataCenter.ActEpidemicZoneManager:GetCurSide()
  if curSide == 0 then
    return true
  end
  if t == 2 or t == 3 then
    return curSide ~= 1
  elseif t == 4 then
    return curSide ~= 2
  elseif t == 5 then
    return curSide ~= 3
  end
  return true
end

function EpidemicZoneBlockRange.GetNearSafePoint(pointId, targetI)
  local curSide = DataCenter.ActEpidemicZoneManager:GetCurSide()
  local posV2 = accessor._GetPos(pointId)
  local mAbs = math.abs
  local tX, tY, disX, disY, tmpX, tmpY, midX
  local flag = false
  local BlockArea = accessor._GetBlockArea()
  for y, list in pairs(BlockArea) do
    tmpY = mAbs(y - posV2.y)
    if disY == nil or disY > tmpY then
      for _, info in pairs(list) do
        if targetI ~= nil then
          flag = info.i == targetI
        else
          flag = curSide == 1 and (info.i == 2 or info.i == 3) or curSide == 2 and info.i == 4 or curSide == 3 and info.i == 5
        end
        if flag then
          tY = y
          disY = tmpY
          midX = (info.t + info.f) / 2
          tmpX = mAbs(midX - posV2.x)
          if tX == nil or disX > tmpX then
            disX = tmpX
            tX = midX
          end
        end
      end
    end
  end
  return tX, tY
end

return ConstClass("EpidemicZoneBlockRange", EpidemicZoneBlockRange)
