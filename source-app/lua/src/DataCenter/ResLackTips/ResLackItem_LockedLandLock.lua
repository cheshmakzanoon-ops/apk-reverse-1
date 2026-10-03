local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_LockedLandLock = BaseClass("ResLackItem_LockedLandLock", ResLackItemBase)
local landLockId

function ResLackItem_LockedLandLock:CheckIsOk(_resType, _needCnt)
  local itemId = _resType
  local dataList = DataCenter.LandLockManager:GetLandLockDataListByState(LandLockState.Any)
  for _, data in ipairs(dataList) do
    if data.state == LandLockState.Locked or data.state == LandLockState.Unlocked then
      local template = DataCenter.LandLockManager:GetTemplate(data.id)
      if table.hasvalue(template.rewardItemList, itemId) then
        landLockId = data.id
        return true
      end
    end
  end
  return false
end

function ResLackItem_LockedLandLock:TodoAction()
  GoToUtil.CloseAllWindows()
  if landLockId ~= nil then
    GoToUtil.GoLandLockById(landLockId)
  end
end

return ResLackItem_LockedLandLock
