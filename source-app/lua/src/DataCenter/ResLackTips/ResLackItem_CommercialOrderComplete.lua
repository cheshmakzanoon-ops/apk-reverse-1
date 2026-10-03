local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_CommercialOrderComplete = BaseClass("ResLackItem_CommercialOrderComplete", ResLackItemBase)

function ResLackItem_CommercialOrderComplete:CheckIsOk(_resType, _needCnt)
  if CS.SceneManager.IsInPVE() then
    return false
  end
  local list = DataCenter.ResidentOrderDataManager:GetOrderList()
  for i, v in pairs(list) do
    if v.id > 0 then
      local state = DataCenter.ResidentOrderDataManager:GetOrderStateByOrderUuid(v.uuid)
      if state == ResidentOrderState.Yes then
        return true
      end
    end
  end
  return false
end

function ResLackItem_CommercialOrderComplete:TodoAction()
  GoToUtil.CloseAllWindows()
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_BUSINESS_CENTER)
  if buildList ~= nil and table.count(buildList) > 0 and buildList[1] ~= nil then
    local posEnd = buildList[1].pointId
    ResLackItemBase:TodoAction(SceneManagerSceneID.City, SceneUtils.TileIndexToWorld(posEnd, ForceChangeScene.City), nil, nil, function()
      local isArrow = 1
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBusinessCenter, isArrow)
    end)
  else
    GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_BUSINESS_CENTER)
  end
end

return ResLackItem_CommercialOrderComplete
