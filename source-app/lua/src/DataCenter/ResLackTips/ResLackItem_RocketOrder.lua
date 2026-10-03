local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_RocketOrder = BaseClass("ResLackItem_RocketOrder", ResLackItemBase)

function ResLackItem_RocketOrder:CheckIsOk(_resType, _needCnt)
  if CS.SceneManager.IsInPVE() then
    return false
  end
  local inHome = DataCenter.EarthOrderDataManager:IsShowEarthOrder()
  local isCanCall = DataCenter.EarthOrderDataManager:checkIsRecall()
  if inHome or isCanCall then
    return true
  end
  return false
end

function ResLackItem_RocketOrder:TodoAction()
  GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_MARKET, WorldTileBtnType.City_BusinessCenter)
end

return ResLackItem_RocketOrder
