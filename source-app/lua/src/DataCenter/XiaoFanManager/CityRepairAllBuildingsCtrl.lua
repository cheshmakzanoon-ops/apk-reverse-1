local ctrl = {}
ctrl.buildingUuidList = {}

function ctrl.OnEnterCity()
  ctrl.buildingUuidList = {}
  local buildingDataList = {}
  local datas = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_GOLD_MILL)
  table.insertto(buildingDataList, datas)
  datas = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_FARMLAND)
  table.insertto(buildingDataList, datas)
  datas = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_QUARRY)
  table.insertto(buildingDataList, datas)
  datas = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_TRAINING_CENTER)
  table.insertto(buildingDataList, datas)
  for k, v in pairs(buildingDataList) do
    table.insert(ctrl.buildingUuidList, v.uuid)
  end
end

function ctrl.OnBuildingUpgrade()
end

function ctrl.OnUpdate()
  if ctrl.upgradingBuildingUuidList then
    for k, v in pairs(ctrl.upgradingBuildingUuidList) do
      local isCantSendFinish = DataCenter.BuildManager:CheckSendBuildFinish(v)
      if not isCantSendFinish then
        ctrl.upgradingBuildingUuidList[k] = nil
      end
    end
  end
end

function ctrl.Clear()
  ctrl.buildingUuidList = nil
  ctrl.upgradingBuildingUuidList = nil
end

function ctrl.OnMainBuildingUpgrade()
  for k, v in pairs(ctrl.buildingUuidList) do
    local isCantSendFinish = DataCenter.BuildManager:CheckSendBuildFinish(v)
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(v)
    if isCantSendFinish and buildData.level == 0 and buildData.state == BuildingStateType.Normal then
      local randomSecond = math.random(5, 25) / 10
      TimerManager:GetInstance():DelayInvoke(function()
        local param = {}
        param.uuid = tostring(v)
        param.gold = BuildUpgradeUseGoldType.No
        param.upLevel = 1
        param.clientParam = ""
        param.truckId = 0
        param.pathTime = 0
        param.robotUuid = 0
        SFSNetwork.SendMessage(MsgDefines.FreeBuildingUpNew, param)
      end, randomSecond)
    else
      ctrl.buildingUuidList[k] = nil
    end
  end
end

return ctrl
