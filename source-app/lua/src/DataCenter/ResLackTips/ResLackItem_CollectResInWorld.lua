local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_CollectResInWorld = BaseClass("ResLackItem_CollectResInWorld", ResLackItemBase)

function ResLackItem_CollectResInWorld:CheckIsOk(_resType, _needCnt)
  if CS.SceneManager.IsInPVE() then
    return false
  end
  self._resType = _resType
  local scienceId = self._config:getValue("para1")
  if string.IsNullOrEmpty(scienceId) then
    return false
  end
  scienceId = tonumber(scienceId)
  local scienceLv = DataCenter.ScienceManager:GetScienceLevel(scienceId)
  if 0 < scienceLv then
    return true
  end
  return false
end

function ResLackItem_CollectResInWorld:TodoAction()
  GoToUtil.GotoWorldResource(self._resType)
end

return ResLackItem_CollectResInWorld
