local ctrl = {}
local TheOneResPath = "Assets/Main/Prefabs/LWOpeningStage/opening_city_road.prefab"
ctrl.theOneHandle = nil
local needShow

function ctrl.Update()
  local building = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.FUN_BUILD_MAIN)[1]
  if building and 1 <= building.level then
    ctrl.ShowTheOne()
  end
end

function ctrl.ShowTheOne()
  needShow = true
  if IsNull(ctrl.theOneHandle) then
    local path = DataCenter.LWCivilizationSparkExtend:CityFakeRoadCtrl_getTheOneResPath(TheOneResPath)
    ctrl.theOneHandle = CS.GameEntry.Resource:InstantiateAsync(path)
    ctrl.theOneHandle:completed("+", function(handle)
      ctrl.theOneHandle.gameObject:SetActive(needShow)
    end)
  elseif not IsNull(ctrl.theOneHandle.gameObject) then
    ctrl.theOneHandle.gameObject:SetActive(true)
  end
end

function ctrl.HideTheOne()
  needShow = false
  if not IsNull(ctrl.theOneHandle) and not IsNull(ctrl.theOneHandle.gameObject) then
    ctrl.theOneHandle.gameObject:SetActive(false)
  end
end

function ctrl.Clear()
  if not IsNull(ctrl.theOneHandle) then
    ctrl.theOneHandle:RealDestroy()
    ctrl.theOneHandle = nil
  end
end

return ctrl
