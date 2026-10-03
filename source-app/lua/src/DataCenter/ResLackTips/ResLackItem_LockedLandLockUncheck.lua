local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_LockedLandLockUncheck = BaseClass("ResLackItem_LockedLandLockUncheck", ResLackItemBase)
local landLockId

function ResLackItem_LockedLandLockUncheck:CheckIsOk(_resType, _needCnt)
  local strs = string.split(self._config:getValue("para1") or "", "|")
  local landLockStrs = string.split(strs[1] or "", ";")
  local questStrs = string.split(strs[2] or "", ";")
  for i, landLockStr in ipairs(landLockStrs) do
    local id = tonumber(landLockStr) or 0
    local data = DataCenter.LandLockManager:GetLandLockDataById(id)
    if data ~= nil and data.state ~= LandLockState.Finished then
      if not string.IsNullOrEmpty(questStrs[i]) then
        local questIds = string.split(questStrs[i], ",")
        for _, questId in ipairs(questIds) do
          if not DataCenter.TaskManager:IsFinishTask(questId) then
            landLockId = id
            return true
          end
        end
      else
        landLockId = id
        return true
      end
    end
  end
  return false
end

function ResLackItem_LockedLandLockUncheck:TodoAction()
  GoToUtil.CloseAllWindows()
  if landLockId ~= nil then
    GoToUtil.GoLandLockById(landLockId, true)
  end
end

return ResLackItem_LockedLandLockUncheck
