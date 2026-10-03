local TimeBarUtil = {}

local function CheckIsNeedChangeBar(finishDeltaTime, LastChanceDeltaTime, totalTime, totalWidth)
  local perInterVal = totalTime / (totalWidth * 2)
  if 2000 < perInterVal then
    perInterVal = 2000
  end
  local interval = math.abs(LastChanceDeltaTime - finishDeltaTime)
  if perInterVal < interval then
    return true
  end
  return false
end

local function CheckIsNeedChangeText(finishDeltaTime, LastChanceDeltaTime)
  if 0 < finishDeltaTime and LastChanceDeltaTime / 1000 ~= finishDeltaTime / 1000 then
    return true
  end
  return false
end

TimeBarUtil.CheckIsNeedChangeText = CheckIsNeedChangeText
TimeBarUtil.CheckIsNeedChangeBar = CheckIsNeedChangeBar
return ConstClass("TimeBarUtil", TimeBarUtil)
