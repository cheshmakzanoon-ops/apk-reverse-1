local MainBuildingGuideCtrl = {}
local guideFlowId = 1017

function MainBuildingGuideCtrl.OnEnterCity()
  if not DataCenter.LWOpeningStageManager:IsAllDone() then
    return
  end
  if DataCenter.LWGuideFlowManager:ReadDone(guideFlowId) then
    return
  end
  MainBuildingGuideCtrl.delay = TimerManager:GetInstance():DelayInvoke(function()
    MainBuildingGuideCtrl.delay = nil
    MainBuildingGuideCtrl.Retry()
  end, 2)
end

function MainBuildingGuideCtrl.Retry()
  if not DataCenter.LWOpeningStageManager:IsAllDone() then
    return
  end
  if DataCenter.LWGuideFlowManager:ReadDone(guideFlowId) then
    return
  end
  if DataCenter.LWGuideFlowManager.Runner == nil or DataCenter.LWGuideFlowManager.Runner.runningFlowId == guideFlowId then
    return
  end
  local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
  if mainBuild ~= nil and mainBuild.level < 1 then
    local pos = Vector3.New(96.07, 5, DataCenter.LWCivilizationSparkExtend:MainBuildingGuideCtrl_getMainFingerZ())
    TimerManager:GetInstance():DelayInvoke(function()
      DataCenter.LWOpeningStageManager.utils.ClearAllFingers()
      DataCenter.LWOpeningStageManager.utils.ShowFingerClick(pos, nil, 2)
    end, 2)
  end
end

function MainBuildingGuideCtrl.OnGuideFlowDone(flowId)
  if not DataCenter.LWOpeningStageManager:IsAllDone() then
    return
  end
  if flowId == guideFlowId then
    local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
    if mainBuild ~= nil and mainBuild.level < 1 then
      local pos = Vector3.New(96.07, 5, DataCenter.LWCivilizationSparkExtend:MainBuildingGuideCtrl_getMainFingerZ())
      TimerManager:GetInstance():DelayInvoke(function()
        local mainBuilding = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
        if mainBuilding ~= nil and mainBuilding.level == 0 and mainBuilding.state == BuildingStateType.Normal then
          DataCenter.LWOpeningStageManager.utils.ClearAllFingers()
          DataCenter.LWOpeningStageManager.utils.ShowFingerClick(pos, nil, 2)
        end
      end, 2)
    end
  end
end

function MainBuildingGuideCtrl.OnBuildingUpgrade(buildData)
  if not DataCenter.LWOpeningStageManager:IsAllDone() then
    return
  end
  if buildData.itemId == BuildingTypes.FUN_BUILD_MAIN and buildData.level == 0 and not buildData:IsUpgradeFinish() then
    DataCenter.LWOpeningStageManager.utils.ClearAllFingers()
  end
end

function MainBuildingGuideCtrl.OnBuildingUpgradeTimeOver(buildData)
  if not DataCenter.LWOpeningStageManager:IsAllDone() then
    return
  end
  if buildData.itemId == BuildingTypes.FUN_BUILD_MAIN and buildData.level == 0 and buildData:IsUpgradeFinish() then
    local pos = Vector3.New(96.07, 5, DataCenter.LWCivilizationSparkExtend:MainBuildingGuideCtrl_getMainFingerZ())
    DataCenter.LWOpeningStageManager.utils.ClearAllFingers()
    DataCenter.LWOpeningStageManager.utils.ShowFingerClick(pos, nil, 2)
  end
end

function MainBuildingGuideCtrl.OnBuildingUpgradeDone(buildData)
  if not DataCenter.LWOpeningStageManager:IsAllDone() then
    return
  end
  if buildData.itemId == BuildingTypes.FUN_BUILD_MAIN then
    local level = buildData.level
    if level == 1 then
      DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.ProductLineFull)
      DataCenter.BuildBubbleManager:CheckShowByBubbleType(BuildBubbleType.ProductLineNormal)
    elseif level == 2 then
      local buildDataList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_HOSPITL)
      if buildDataList ~= nil and table.count(buildDataList) > 0 then
        for _, data in ipairs(buildDataList) do
          DataCenter.BuildBubbleManager:CheckShowBubble(data.uuid)
        end
      end
      buildDataList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_WORKER_HOUSE)
      if buildDataList ~= nil and table.count(buildDataList) > 0 then
        for _, data in ipairs(buildDataList) do
          DataCenter.BuildBubbleManager:CheckShowBubble(data.uuid)
        end
      end
      buildDataList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_STEEL_MILL)
      if buildDataList ~= nil and table.count(buildDataList) > 0 then
        for _, data in ipairs(buildDataList) do
          DataCenter.BuildBubbleManager:CheckShowBubble(data.uuid)
        end
      end
      buildDataList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_ARMY_YARD)
      if buildDataList ~= nil and table.count(buildDataList) > 0 then
        for _, data in ipairs(buildDataList) do
          DataCenter.BuildBubbleManager:CheckShowBubble(data.uuid)
        end
      end
      buildDataList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_PARKINGLOT)
      if buildDataList ~= nil and table.count(buildDataList) > 0 then
        for _, data in ipairs(buildDataList) do
          DataCenter.BuildBubbleManager:CheckShowBubble(data.uuid)
        end
      end
      buildDataList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_BAKERY)
      if buildDataList ~= nil and table.count(buildDataList) > 0 then
        for _, data in ipairs(buildDataList) do
          DataCenter.BuildBubbleManager:CheckShowBubble(data.uuid)
        end
      end
    end
    if 0 < level then
      DataCenter.LWOpeningStageManager.utils.ClearAllFingers()
    end
  end
end

function MainBuildingGuideCtrl.Clear()
  if MainBuildingGuideCtrl.delayCam then
    MainBuildingGuideCtrl.delayCam:Stop()
    MainBuildingGuideCtrl.delayCam = nil
  end
  if MainBuildingGuideCtrl.delay then
    MainBuildingGuideCtrl.delay:Stop()
    MainBuildingGuideCtrl.delay = nil
  end
  DataCenter.LWOpeningStageManager.utils.ClearAllFingers()
end

return MainBuildingGuideCtrl
