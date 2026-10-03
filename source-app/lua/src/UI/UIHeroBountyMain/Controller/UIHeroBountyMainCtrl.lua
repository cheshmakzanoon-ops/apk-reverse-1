local UIHeroBountyMainCtrl = BaseClass("UIHeroBountyMainCtrl", UIBaseCtrl)
local showState = {
  None = 0,
  Finish = 1,
  Idle = 2,
  Doing = 3,
  Wait = 4,
  Lock_Add_num = 5,
  lock_add_rarity = 6
}

function UIHeroBountyMainCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.UIHeroBountyMain)
end

function UIHeroBountyMainCtrl:GetTaskList()
  local list = {}
  local slotList = DataCenter.HeroBountyDataManager:GetSlotDataByBuildData()
  if 0 < #slotList then
    for k, v in pairs(slotList) do
      local data = self:GetTaskOneDataByIndex(k)
      if data ~= nil then
        table.insert(list, data)
      end
    end
  end
  table.sort(list, function(a, b)
    if a.state ~= b.state then
      return a.state < b.state
    end
    if a.rarity ~= b.rarity then
      return a.rarity > b.rarity
    end
    return a.index < b.index
  end)
  local theLastIndex = #slotList + 1
  local lastData = self:GetTaskOneDataByIndex(theLastIndex)
  if lastData ~= nil then
    table.insert(list, lastData)
  end
  return list
end

function UIHeroBountyMainCtrl:GetTaskOneDataByIndex(index)
  local slotList = DataCenter.HeroBountyDataManager:GetSlotDataByBuildData()
  if index <= #slotList then
    local taskData = DataCenter.HeroBountyDataManager:GetTaskDataByIndex(index)
    local oneData = {}
    if taskData ~= nil then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      oneData.id = taskData.id
      oneData.index = taskData.index
      oneData.startTime = taskData.startTime
      oneData.endTime = taskData.endTime
      oneData.waitEndTime = 0
      oneData.name = taskData.name
      oneData.taskTime = tonumber(taskData.taskTime)
      local exp = tonumber(taskData.exp_hero)
      local effectValue = LuaEntry.Effect:GetGameEffect(EffectDefine.GLOBAL_HERO_EXP_EXTRA_PERCENT)
      oneData.exp_hero = Mathf.Round(exp * (1 + effectValue / 100))
      oneData.rarity = taskData.rarity
      if oneData.startTime ~= 0 and curTime < oneData.endTime then
        oneData.state = showState.Doing
      elseif oneData.startTime ~= 0 and curTime >= oneData.endTime then
        oneData.state = showState.Finish
      else
        oneData.state = showState.Idle
      end
      return oneData
    else
      oneData.state = showState.Wait
      oneData.index = index
      oneData.rarity = 1
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local todayTime = UITimeManager:GetInstance():GetTodayZeroServerTime(curTime / 1000)
      local tomorrowTime = todayTime + 86400
      oneData.waitEndTime = tomorrowTime * 1000
      return oneData
    end
  else
    local unLockMsg = DataCenter.HeroBountyDataManager:GetNextLevelBuildUnlockMsg()
    if 2 <= #unLockMsg then
      local type = tonumber(unLockMsg[1])
      local level = tonumber(unLockMsg[2])
      if type == 1 then
        local oneData = {}
        oneData.state = showState.Lock_Add_num
        oneData.index = index
        oneData.rarity = 1
        oneData.buildLv = level
        return oneData
      elseif type == 2 then
        local oneData = {}
        oneData.state = showState.lock_add_rarity
        oneData.index = index
        oneData.rarity = 1
        oneData.buildLv = level
        return oneData
      end
    end
  end
end

return UIHeroBountyMainCtrl
