local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_GolloesOrderComplete = BaseClass("ResLackItem_GolloesOrderComplete", ResLackItemBase)

function ResLackItem_GolloesOrderComplete:CheckIsOk(_resType, _needCnt)
  if CS.SceneManager.IsInPVE() then
    return false
  end
  local list = DataCenter.GroceryStoreOrderDataManager.groceryStoreOrderDic
  for i, v in pairs(list) do
    if v:CanSend() then
      return true
    end
  end
  return false
end

function ResLackItem_GolloesOrderComplete:TodoAction()
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_GROCERY_STORE)
  if buildList ~= nil and table.count(buildList) > 0 and buildList[1] ~= nil then
    local posEnd = buildList[1].pointId
    GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(posEnd), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      local isArrow = 1
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGroceryStore, isArrow)
    end)
  else
    GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_GROCERY_STORE)
  end
end

return ResLackItem_GolloesOrderComplete
