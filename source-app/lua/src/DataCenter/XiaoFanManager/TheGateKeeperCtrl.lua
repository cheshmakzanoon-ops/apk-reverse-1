local ctrl = {}
ctrl.askingForBuildingObj = false
ctrl.gateBuildingOpened = false

function ctrl.OnEnterCity()
  if DataCenter.LWOpeningStageManager:IsStageDone(3) and not DataCenter.LWOpeningStageManager:IsStageDone(4) and DataCenter.LWGuideFlowManager:ReadDone(1002) then
    ctrl.askingForBuildingObj = true
    ctrl.gateBuildingOpened = false
  end
end

function ctrl.OnUpdate()
  if ctrl.askingForBuildingObj and not ctrl.gateBuildingOpened and CS.SceneManager.World then
    local gateBuildingObj = CS.SceneManager.World and CS.SceneManager.World:GetBuildingByPoint(3951) or nil
    if not IsNull(gateBuildingObj) and gateBuildingObj.name == "building_10107000(Clone)" then
      local animComp = gateBuildingObj:GetComponentInChildren(typeof(CS.SimpleAnimation))
      if not IsNull(animComp) then
        animComp:Play("open")
      end
      ctrl.gateBuildingOpened = true
    end
  end
end

function ctrl.OnGuideFlowDone(flowId)
  if flowId == 1002 then
    ctrl.askingForBuildingObj = true
    ctrl.gateBuildingOpened = false
  end
end

function ctrl.Clear()
  ctrl.askingForBuildingObj = false
  ctrl.gateBuildingOpened = false
end

return ctrl
