local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_CommercialOrder = BaseClass("ResLackItem_CommercialOrder", ResLackItemBase)

function ResLackItem_CommercialOrder:CheckIsOk(_resType, _needCnt)
  if CS.SceneManager.IsInPVE() then
    return false
  end
  return true
end

function ResLackItem_CommercialOrder:TodoAction()
  GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_BUSINESS_CENTER, WorldTileBtnType.City_BusinessCenter)
end

return ResLackItem_CommercialOrder
