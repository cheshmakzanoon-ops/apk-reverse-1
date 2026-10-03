local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_AttackMonster = BaseClass("ResLackItem_AttackMonster", ResLackItemBase)

function ResLackItem_AttackMonster:CheckIsOk(_resType, _needCnt)
  if CS.SceneManager.IsInPVE() then
    return false
  end
  local list_427000 = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_TRAINFIELD_1)
  local list_793000 = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_TRAINFIELD_2)
  local list_794000 = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_TRAINFIELD_3)
  local list_795000 = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_TRAINFIELD_4)
  local existTroopBuilding = false
  if table.count(list_427000) > 0 or table.count(list_793000) > 0 or table.count(list_794000) > 0 or table.count(list_795000) > 0 then
    existTroopBuilding = true
  end
  if existTroopBuilding then
    return true
  end
  return false
end

function ResLackItem_AttackMonster:TodoAction()
  GoToUtil.CloseAllWindows()
  SceneUtils.ChangeToWorld(function()
    GoToUtil.GotoOpenView(UIWindowNames.UISearch, UISearchType.Monster)
  end)
end

return ResLackItem_AttackMonster
