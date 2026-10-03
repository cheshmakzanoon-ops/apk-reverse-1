local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_GoActWin = BaseClass("ResLackItem_GoActWin", ResLackItemBase)

function ResLackItem_GoActWin:CheckIsOk(_resType, _needCnt)
  local para1 = self._config.para1
  local list = string.split(para1, "|")
  if table.count(list) == 1 then
    self.actId = tonumber(list[1])
  elseif table.count(list) == 2 then
    self.actId = tonumber(list[2])
  end
  self.data = {}
  local actListData = DataCenter.ActivityListDataManager:GetActivityDataById(self.actId)
  if actListData and DataCenter.ActivityListDataManager:CheckIsSend(actListData) then
    for k, v in pairs(list) do
      table.insert(self.data, tonumber(v))
    end
    return true
  end
  return false
end

function ResLackItem_GoActWin:TodoAction()
  GoToUtil.GoActWindow(self.data)
end

return ResLackItem_GoActWin
