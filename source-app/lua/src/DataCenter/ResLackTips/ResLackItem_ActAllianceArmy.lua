local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_ActAllianceArmy = BaseClass("ResLackItem_ActAllianceArmy", ResLackItemBase)

function ResLackItem_ActAllianceArmy:CheckIsOk(_resType, _needCnt)
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  self.index = 0
  if activityInfo ~= nil then
    local eventInfo = activityInfo:GetEventInfo()
    if eventInfo == nil then
      return false
    end
    local targetReward = eventInfo.targetReward
    if targetReward then
      local stage = {}
      for i, v in pairs(targetReward) do
        for k = 1, table.count(v) do
          if tonumber(v[k].itemId) == _resType then
            table.insert(stage, i)
          end
        end
      end
      local str = string.split(eventInfo.target, "|")
      for i = 1, table.count(str) do
        for k = 1, table.count(stage) do
          if stage[k] == tonumber(str[i]) and DataCenter.AllianceCompeteDataManager:Check9BoxUnlock(i) and eventInfo.newRewardFlagList and eventInfo.newRewardFlagList[i] ~= i then
            self.index = i
            return true
          end
        end
      end
    end
  end
  return false
end

function ResLackItem_ActAllianceArmy:TodoAction()
  GoToUtil.CloseAllWindows()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCompeteNew, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, 1, self.index)
end

return ResLackItem_ActAllianceArmy
