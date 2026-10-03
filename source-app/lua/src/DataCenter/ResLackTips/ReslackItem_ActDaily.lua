local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ReslackItem_ActDaily = BaseClass("ReslackItem_ActDaily", ResLackItemBase)

function ReslackItem_ActDaily:CheckIsOk(_itemId, _needCnt)
  local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.IndividualOrder.Type)
  if actList and 0 < #actList and actList[1].needMainCityLevel <= DataCenter.BuildManager.MainLv then
    return true
  end
  return false
end

function ReslackItem_ActDaily:TodoAction()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDailyActivity, 3)
end

return ReslackItem_ActDaily
