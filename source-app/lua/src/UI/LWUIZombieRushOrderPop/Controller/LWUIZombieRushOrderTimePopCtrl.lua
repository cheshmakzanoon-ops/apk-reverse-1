local LWUIZombieRushOrderTimePopCtrl = BaseClass("LWUIZombieRushOrderTimePopCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function LWUIZombieRushOrderTimePopCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUIZombieRushOrderTimePop)
end

function LWUIZombieRushOrderTimePopCtrl:GetHourParamByHourAndMinute(hour, minute, minuteSplit)
  local minStep = 60 / minuteSplit
  local minuteIndex = minuteSplit - 1
  for i = 0, minuteSplit - 1 do
    if minute <= minStep * i then
      minuteIndex = i
      break
    end
  end
  local min = minuteIndex / minuteSplit
  return hour + min
end

function LWUIZombieRushOrderTimePopCtrl:GetHourAndMinuteByHour(hourParam)
  local hour, min = math.modf(hourParam)
  min = min * 60
  return hour, min
end

function LWUIZombieRushOrderTimePopCtrl:GetStartHourAndMinuteByData(date, minuteSplit)
  local startHour = date.hour
  local min = date.min
  local minStep = 60 / minuteSplit
  local startMin
  for i = 0, minuteSplit - 1 do
    if min < minStep * i then
      startMin = minStep * i
      break
    end
  end
  if startMin == nil then
    startHour = startHour + 1
    startMin = 0
  end
  return startHour, startMin
end

return LWUIZombieRushOrderTimePopCtrl
