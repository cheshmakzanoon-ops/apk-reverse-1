local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_Explore = BaseClass("ResLackItem_Explore", ResLackItemBase)

function ResLackItem_Explore:CheckIsOk(_resType, _needCnt)
  if CS.SceneManager.IsInPVE() then
    return false
  end
  self.buildId = tonumber(self._config:getValue("para1"))
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(tonumber(self.buildId))
  if list ~= nil and table.count(list) > 0 then
    return true
  end
  return false
end

function ResLackItem_Explore:TodoAction()
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(tonumber(self.buildId))
  if buildList ~= nil and table.count(buildList) > 0 and buildList[1] ~= nil then
  else
    GoToUtil.GotoCityByBuildId(tonumber(self.buildId))
  end
end

return ResLackItem_Explore
