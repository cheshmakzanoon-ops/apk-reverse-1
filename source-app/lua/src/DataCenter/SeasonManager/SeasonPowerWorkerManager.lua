local SeasonPowerWorkerManager = BaseClass("SeasonPowerWorkerManager")
local BuildIds = {
  BuildingTypes.LW_BUILD_SEASON4_POWER_STATION1,
  BuildingTypes.LW_BUILD_SEASON4_POWER_STATION2,
  BuildingTypes.LW_BUILD_SEASON4_POWER_STATION3,
  BuildingTypes.LW_BUILD_SEASON4_POWER_STATION4
}
local TaskIds = {
  604000001,
  604000002,
  604000003,
  604000004
}

function SeasonPowerWorkerManager:__init()
  self.powerWorkerDict = {}
end

function SeasonPowerWorkerManager:__delete()
  self.powerWorkerDict = {}
end

function SeasonPowerWorkerManager:SwitchBuildAnim(buildId, bUuid, buildData)
  if not SceneUtils.GetIsInCity() then
    return
  end
  if (bUuid == nil or buildData == nil) and buildId then
    local dataList = DataCenter.BuildManager:GetBuildingDatasByBuildingId(buildId)
    if dataList and 0 < #dataList and dataList[1] then
      buildData = dataList[1]
      bUuid = buildData.uuid
    end
  end
  local world = CS.SceneManager.World
  if world ~= nil and buildData ~= nil and buildData.level ~= 0 and (buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION1 or buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION2 or buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION3 or buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION4 or buildId == BuildingTypes.LW_BUILD_SEASON4_LIGHTHOUSE) then
    local obj = world:GetBuildingByPoint(buildData.pointId)
    if obj ~= nil then
      local gameObject = obj.gameObject
      if gameObject ~= nil then
        if buildId == BuildingTypes.LW_BUILD_SEASON4_LIGHTHOUSE then
          local cs = gameObject:GetComponent(typeof(CS.BuildLightHouse))
          if cs then
            local WorkStatus = {
              false,
              false,
              false,
              false
            }
            local status = {
              false,
              false,
              false,
              false
            }
            for index, powerBuildId in ipairs(BuildIds) do
              local dataList = DataCenter.BuildManager:GetBuildingDatasByBuildingId(powerBuildId)
              if dataList and 0 < #dataList and dataList[1] then
                local worker = self:GetPowerWorkerByBuild(powerBuildId, dataList[1].uuid)
                local formation = self:GetFormationByBuild(powerBuildId, dataList[1].uuid)
                if formation ~= nil or worker ~= nil then
                  status[index] = true
                end
                if worker and worker.state == PowerWorkerStatus.CHARGE_SELF then
                  WorkStatus[index] = true
                end
              end
            end
            if self.lightHouseStatus ~= nil then
              cs:UpdateData(toInt(self.lightHouseStatus.brightnessLevel), status[1], status[2], status[3], status[4])
            else
              cs:UpdateData(0, status[1], status[2], status[3], status[4])
            end
            if self.lightHouseStatus ~= nil and self.lightHouseStatus.active then
              cs:UpdateLineStatus(WorkStatus[1], WorkStatus[2], WorkStatus[3], WorkStatus[4])
            else
              cs:UpdateLineStatus(false, false, false, false)
            end
          end
        else
          local cs = gameObject:GetComponent(typeof(CS.BuildPowerFactory))
          if cs then
            local worker = self:GetPowerWorkerByBuild(buildId, bUuid)
            local formation = self:GetFormationByBuild(buildId, bUuid)
            if formation ~= nil or worker ~= nil then
              cs:SetWorkModeOn(true)
            else
              cs:SetWorkModeOn(false)
            end
            if worker then
              cs:SetWorkerStatus(toInt(worker.state))
            else
              cs:SetWorkerStatus(-1)
            end
          end
        end
      end
    end
  end
end

function SeasonPowerWorkerManager:RegisterPowerStation(buildId, bUuid)
  if self.PowerStationList == nil then
    self.PowerStationList = {}
  end
  self.PowerStationList[buildId] = bUuid
end

function SeasonPowerWorkerManager:UpdatePowerStationBubble()
  self.delayUpdateBubble = nil
  if self.PowerStationList then
    for buildId, bUuid in pairs(self.PowerStationList) do
      if buildId and bUuid then
        EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, bUuid)
      end
    end
  end
end

function SeasonPowerWorkerManager:HasPowerBuildTask()
  if self:GetFormationCount() >= 4 or 4 <= self:GetPowerWorkerCount() then
    return false
  end
  local taskInfo
  local mgrBuildMeta = DataCenter.BuildTemplateManager
  local mgrTask = DataCenter.TaskManager
  for index, buildId in ipairs(BuildIds) do
    local cfg = mgrBuildMeta:GetBuildingLevelTemplate(buildId, 1)
    if cfg ~= nil then
      taskInfo = mgrTask:FindTaskInfo(cfg.finish_quest)
    else
      taskInfo = mgrTask:FindTaskInfo(TaskIds[index])
    end
    if taskInfo and taskInfo.state ~= TaskState.Received then
      return true
    end
  end
  return false
end

function SeasonPowerWorkerManager:GetPowerBuildInfo()
  local data = {}
  local taskInfo
  local mgrBuildMeta = DataCenter.BuildTemplateManager
  local mgrBuild = DataCenter.BuildManager
  local mgrTask = DataCenter.TaskManager
  for index, buildId in ipairs(BuildIds) do
    local cfg = mgrBuildMeta:GetBuildingLevelTemplate(buildId, 1)
    if cfg ~= nil then
      taskInfo = mgrTask:FindTaskInfo(cfg.finish_quest)
    else
      taskInfo = mgrTask:FindTaskInfo(TaskIds[index])
    end
    local buildUuid
    local dataBuild = mgrBuild:GetMaxLvBuildDataByBuildId(buildId, true)
    if dataBuild and dataBuild.level ~= 0 then
      buildUuid = data.uuid
    end
    data[buildId] = {}
    data[buildId].taskInfo = taskInfo
    data[buildId].formation = self:GetFormationByBuild(buildId, buildUuid)
    data[buildId].worker = self:GetPowerWorkerByBuild(buildId, buildUuid)
  end
  return data
end

function SeasonPowerWorkerManager:CalcPowerInput()
  if self.lightHouseStatus == nil or not self.lightHouseStatus.active then
    return 0, 0
  end
  local level = toInt(self.lightHouseStatus.lv)
  local selfWorkerNum = math.min(toInt(self.lightHouseStatus.selfWorkerNum), 4)
  local otherWorkerNum = toInt(self.lightHouseStatus.otherWorkerNum)
  local assistanceMaxCount = 1
  local cfg = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.LW_BUILD_SEASON4_LIGHTHOUSE)
  if cfg ~= nil then
    cfg = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.LW_BUILD_SEASON4_LIGHTHOUSE, level)
    if cfg ~= nil then
      assistanceMaxCount = toInt(cfg.para2)
      otherWorkerNum = math.min(otherWorkerNum, assistanceMaxCount)
    end
    cfg = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.LW_BUILD_SEASON4_LIGHTHOUSE, cfg.max_level)
    if cfg ~= nil then
      assistanceMaxCount = toInt(cfg.para2)
      otherWorkerNum = math.min(otherWorkerNum, assistanceMaxCount)
    end
  end
  local workerCount = selfWorkerNum + otherWorkerNum
  local workerSpeed = 1
  cfg = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.LW_BUILD_SEASON4_POWER_STATION1, 1)
  if cfg ~= nil then
    workerSpeed = toInt(cfg.para1)
  end
  local para4 = 0
  local para5 = 0
  cfg = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.LW_BUILD_SEASON4_LIGHTHOUSE, math.max(level, 1))
  if cfg ~= nil then
    para4 = toInt(cfg.para4)
    para5 = toInt(cfg.para5)
  end
  local alBuildSpeed = toInt(self.lightHouseStatus.alBuildSpeed)
  local inputNow = workerCount * workerSpeed + alBuildSpeed
  local inputMax = (4 + assistanceMaxCount) * workerSpeed + alBuildSpeed
  if para4 ~= nil and 0 < para4 then
    inputMax = para4
  end
  return inputNow, inputMax
end

function SeasonPowerWorkerManager:CalcPowerOutput()
  if self.lightHouseStatus == nil or not self.lightHouseStatus.active then
    return 0, 0
  end
  local workerSpeed = 1
  local cfg = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.LW_BUILD_SEASON4_POWER_STATION1, 1)
  if cfg ~= nil then
    workerSpeed = toInt(cfg.para1)
  end
  local level = toInt(self.lightHouseStatus.lv)
  local para4 = 0
  local para5 = 0
  cfg = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.LW_BUILD_SEASON4_LIGHTHOUSE, math.max(level, 1))
  if cfg ~= nil then
    para4 = toInt(cfg.para4)
    para5 = toInt(cfg.para5)
  end
  local usePower = 0
  local electricity_use_max = 0
  local brightnessLevel = toInt(self.lightHouseStatus.brightnessLevel)
  local buff_add = DataCenter.SeasonLightDataManager:GetBloodyNightElectricityUseBuff()
  if 0 < brightnessLevel then
    cfg = LocalController:instance():getLine(TableName.LW_LIGHTS_ON_S4, brightnessLevel)
    if cfg and cfg.electricity_use ~= nil then
      usePower = toInt(cfg.electricity_use) + buff_add
      electricity_use_max = usePower
    end
  end
  cfg = LocalController:instance():getLine(TableName.LW_LIGHTS_ON_S4, 4)
  if cfg and cfg.electricity_use ~= nil then
    electricity_use_max = toInt(cfg.electricity_use) + buff_add
  end
  local outputNow = usePower
  local outputMax = electricity_use_max + 4 * workerSpeed
  if para5 ~= nil and 0 < para5 then
    outputMax = para5
  end
  return outputNow, outputMax
end

function SeasonPowerWorkerManager:CalcBatteryPowerTime(brightnessLevel)
  if self.lightHouseStatus == nil or self.lightHouseStatus.active ~= true or brightnessLevel == 0 or brightnessLevel == nil then
    return 0, "00:00:00"
  end
  local cfg = LocalController:instance():getLine(TableName.LW_LIGHTS_ON_S4, brightnessLevel)
  if cfg and cfg.electricity_use ~= nil then
    local buff_add = DataCenter.SeasonLightDataManager:GetBloodyNightElectricityUseBuff()
    local inputNow = self:CalcPowerInput()
    local electricity_use = toInt(cfg.electricity_use) + buff_add
    if inputNow >= electricity_use then
      return -1, "\226\136\158"
    end
    local powerNow, powerMax, powerSpeed = self:GetBatteryPowerResourceInfo()
    if powerNow == 0 then
      return 0, "00:00:00"
    end
    local delta = electricity_use - inputNow
    local useTime = math.floor(powerNow / delta)
    if 1 < useTime then
      local txt = UITimeManager:GetInstance():SecondToFmtString(useTime)
      return useTime, txt
    end
  end
  return 0, "00:00:00"
end

function SeasonPowerWorkerManager:GetBatteryPowerResourceInfo()
  if self.lightHouseStatus == nil or not self.lightHouseStatus.active then
    return 0, 0, 0
  end
  local powerSpeed = toInt(self.lightHouseStatus.speed)
  local powerNow = toInt(self.lightHouseStatus.power)
  local lastTime = toInt(self.lightHouseStatus.syncTime)
  local now = UITimeManager:GetInstance():GetServerTime()
  local powerMax = powerNow
  local level = toInt(self.lightHouseStatus.lv)
  local cfg = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.LW_BUILD_SEASON4_LIGHTHOUSE, level)
  if cfg ~= nil then
    powerMax = toInt(cfg.para1)
  end
  powerNow = powerNow + powerSpeed * math.floor((now - lastTime) / 1000)
  powerNow = math.max(0, math.min(powerMax, powerNow))
  if powerMax <= powerNow then
    powerSpeed = 0
  end
  return powerNow, powerMax, powerSpeed
end

function SeasonPowerWorkerManager:GetPowerWorkerSpeed()
  local workerSpeed = 1
  local cfg = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.LW_BUILD_SEASON4_POWER_STATION1, 1)
  if cfg ~= nil then
    workerSpeed = toInt(cfg.para1)
  end
  return workerSpeed
end

function SeasonPowerWorkerManager:UpdateLightHouse(lightHouseStatus)
  local old = self.lightHouseStatus
  local isSunrise = DataCenter.BloodyNightDataManager:IsSunrise()
  if lightHouseStatus ~= nil and lightHouseStatus.alBuildSpeed ~= 0 then
    local theStoveCenter = DataCenter.AllianceMineManager:GetAllianceStoveCenter()
    if theStoveCenter ~= nil and theStoveCenter.status == AllianceMineStatus.FoldUp then
      lightHouseStatus.alBuildSpeed = 0
    end
  end
  self.lightHouseStatus = lightHouseStatus
  self.lightHouseStatusPre = old
  if old ~= nil then
    if old.alBuildSpeed ~= lightHouseStatus.alBuildSpeed then
      EventManager:GetInstance():DelayBroadcast(0.1, EventId.LuaEntryEffectRefreshStatus)
      if not isSunrise and (old.alBuildSpeed == nil or old.alBuildSpeed == 0) then
        TimerManager:GetInstance():DelayInvoke(function()
          local player = LuaEntry.Player
          local prefabPath = "Assets/Main/SeasonRes/S4/Prefabs/Effect/S4_Light/Eff_s_S4_shusongdianli.prefab"
          SceneUtils.PlayWorldEffect(player:GetMainWorldPos(), player:GetSelfServerId(), prefabPath, 3)
        end, 2)
      end
    end
    if self.delayUpdateBubble == nil then
      self.delayUpdateBubble = TimerManager:GetInstance():DelayInvoke(function()
        EventManager:GetInstance():DelayBroadcast(0.1, EventId.ResourceUpdated)
        EventManager:GetInstance():DelayBroadcast(0.1, EventId.BatteryPowerResourceUpdated)
        DataCenter.SeasonPowerWorkerManager:UpdatePowerStationBubble()
      end, 0.2)
    end
  end
  if old == nil then
    if lightHouseStatus.active then
      local level = toInt(lightHouseStatus.lv)
      local cfg = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.LW_BUILD_SEASON4_LIGHTHOUSE, level)
      if cfg ~= nil then
        local powerSpeed = toInt(lightHouseStatus.speed)
        local powerNow = toInt(lightHouseStatus.power)
        local powerMax = toInt(cfg.para1)
        if powerMax ~= 0 then
          if powerMax == powerNow and 0 <= powerSpeed then
            UIUtil.ShowTipsId("season_s4_building_ui_info54")
          elseif powerNow == 0 and powerSpeed <= 0 then
            UIUtil.ShowTipsId("season_s4_building_ui_info55")
          end
        end
      end
    end
  elseif not isSunrise and (old.active ~= lightHouseStatus.active or old.brightnessLevel ~= lightHouseStatus.brightnessLevel) then
    SFSNetwork.SendMessage(MsgDefines.FetchCityLightStatusInfo)
  end
  if self.delaySwitchBuildAnim == nil and SceneUtils.GetIsInCity() then
    self.delaySwitchBuildAnim = TimerManager:GetInstance():DelayInvoke(function()
      local mgr = DataCenter.SeasonPowerWorkerManager
      mgr.delaySwitchBuildAnim = nil
      if SceneUtils.GetIsInCity() then
        mgr:SwitchBuildAnim(BuildingTypes.LW_BUILD_SEASON4_LIGHTHOUSE)
        mgr:SwitchBuildAnim(BuildingTypes.LW_BUILD_SEASON4_POWER_STATION1)
        mgr:SwitchBuildAnim(BuildingTypes.LW_BUILD_SEASON4_POWER_STATION2)
        mgr:SwitchBuildAnim(BuildingTypes.LW_BUILD_SEASON4_POWER_STATION3)
        mgr:SwitchBuildAnim(BuildingTypes.LW_BUILD_SEASON4_POWER_STATION4)
      end
    end, 0.3)
  end
  if lightHouseStatus.active then
    UIUtil.CheckEventTrigger(OpMode.ClickBtnActiveLightHouse)
  end
end

function SeasonPowerWorkerManager:CheckMv()
  local isSunrise = DataCenter.BloodyNightDataManager:IsSunrise()
  if isSunrise then
    return
  end
  local theWorld = CS.SceneManager.World
  if theWorld ~= nil and self.lightHouseStatus and self.lightHouseStatus.active and self.lightHouseStatusPre and self.lightHouseStatusPre.active then
    local oldSpeed = toInt(self.lightHouseStatusPre.alBuildSpeed)
    local newSpeed = toInt(self.lightHouseStatus.alBuildSpeed)
    if oldSpeed == 0 and 0 < newSpeed then
      local effectPath = "Assets/Main/SeasonRes/S4/Prefabs/Effect/VFX_get_power.prefab"
      theWorld:CreateBattleVFX(effectPath, 2, function(go)
        if SceneUtils.GetIsInWorld() and go ~= nil then
          local curServerId = LuaEntry.Player:GetCurServerId()
          go.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
          go.transform.position = SceneUtils.TileIndexToWorld(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World, curServerId)
          go.transform:Set_localScale(0.1, 0.1, 0.1)
          go:SetActive(true)
        end
      end)
    end
  end
end

function SeasonPowerWorkerManager:IsLightHouseActive()
  return self.lightHouseStatus and self.lightHouseStatus.active
end

function SeasonPowerWorkerManager:UpdatePowerWorkerFormation(power_worker_formation_list)
  self.powerWorkerFormations = power_worker_formation_list
end

function SeasonPowerWorkerManager:GetFreeFormation()
  if self.powerWorkerFormations == nil then
    return nil
  end
  for k, v in pairs(self.powerWorkerFormations) do
    if v and v.state == ArmyFormationState.Free then
      return v
    end
  end
  return nil
end

function SeasonPowerWorkerManager:GetFormationCount()
  return table.count(self.powerWorkerFormations)
end

function SeasonPowerWorkerManager:GetFormationByBuild(buildId, buildUuid)
  if self.powerWorkerFormations == nil then
    return nil
  end
  if buildUuid == nil then
    if buildId == nil then
      return nil
    end
    local data = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(buildId, true)
    if data and data.level ~= 0 then
      buildUuid = data.uuid
    end
  end
  if buildUuid == nil then
    return nil
  end
  for k, v in pairs(self.powerWorkerFormations) do
    if v and v.buildingUuid == buildUuid then
      return v
    end
  end
  return nil
end

function SeasonPowerWorkerManager:UpdatePowerWorkers(workerList)
  if workerList then
    for _, worker in pairs(workerList) do
      self:UpdatePowerWorker(worker)
    end
  end
end

function SeasonPowerWorkerManager:UpdatePowerWorker(worker)
  if worker and worker.uuid then
    local buildData
    if worker.buildingId then
      buildData = DataCenter.BuildManager:GetFunbuildByItemID(worker.buildingId)
    elseif worker.buildUuid then
      buildData = DataCenter.BuildManager:GetBuildingDataByUuid(worker.buildUuid)
    end
    if buildData == nil then
      return
    end
    local isSunrise = DataCenter.BloodyNightDataManager:IsSunrise()
    local old = self.powerWorkerDict[worker.uuid]
    self.powerWorkerDict[worker.uuid] = worker
    self:SwitchBuildAnim(buildData.itemId, worker.buildUuid, buildData)
    if old and worker and old.state ~= worker.state then
      if old.state == PowerWorkerStatus.MARCH or old.state == PowerWorkerStatus.CHARGE_OTHER then
        if worker.state == PowerWorkerStatus.WAIT or worker.state == PowerWorkerStatus.CHARGE_SELF then
          local itemId = buildData.itemId
          local theIndex = toInt((toInt(itemId) - 807000) * 0.001)
          local msg = CS.GameEntry.Localization:GetString("season4_tips008", theIndex)
          UIUtil.ShowTips(msg)
        end
      elseif (old.state == PowerWorkerStatus.WAIT or old.state == PowerWorkerStatus.CHARGE_SELF) and worker.state == PowerWorkerStatus.MARCH then
        local marchUuid = worker.marchUuid
        TimerManager:GetInstance():DelayInvoke(function()
          local marchInfo = DataCenter.WorldMarchDataManager:GetMarch(marchUuid)
          if marchInfo ~= nil then
            local marchTargetType = marchInfo:GetMarchTargetType()
            if marchTargetType == MarchTargetType.POWER_WORK_HELPER_CHARGE then
              local itemId = buildData.itemId
              local theIndex = toInt((toInt(itemId) - 807000) * 0.001)
              local msg = CS.GameEntry.Localization:GetString("season_mastery_s4_tips_12", theIndex)
              UIUtil.ShowTips(msg)
            end
          end
        end, 0.5)
      end
      if worker.state == PowerWorkerStatus.CHARGE_OTHER then
        local itemId = buildData.itemId
        local theIndex = toInt((toInt(itemId) - 807000) * 0.001)
        if worker.userInfo and worker.userInfo.name then
          local msg = CS.GameEntry.Localization:GetString("season4_tips006", theIndex, worker.userInfo.name or "")
          UIUtil.ShowTips(msg)
        end
      end
      if worker.state == PowerWorkerStatus.CHARGE_OTHER or worker.state == PowerWorkerStatus.CHARGE_SUPPLIES then
        do
          local uid = worker.userInfo and worker.userInfo.uid
          local member
          if uid then
            member = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(uid)
          end
          local pointId = worker.pointId
          local serverId = worker.serverId
          if member then
            pointId = worker.pointId or member.pointId
            serverId = worker.serverId or member.serverId
          end
          if not isSunrise and pointId and serverId == LuaEntry.Player:GetCurServerId() then
            do
              local theWorld = CS.SceneManager.World
              if theWorld ~= nil then
                local effectPath = "Assets/Main/SeasonRes/S4/Prefabs/Effect/VX/Eff_ui_season4_chongdian.prefab"
                theWorld:CreateBattleVFX(effectPath, 2, function(go)
                  if SceneUtils.GetIsInWorld() and go ~= nil then
                    local curServerId = LuaEntry.Player:GetCurServerId()
                    go.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
                    go.transform.position = SceneUtils.TileIndexToWorld(toInt(pointId), ForceChangeScene.World, curServerId)
                    go.transform:Set_localScale(1, 1, 1)
                    go:SetActive(true)
                  end
                end)
              end
            end
          end
        end
      end
    end
  end
end

function SeasonPowerWorkerManager:GetPowerWorkerCount()
  return table.count(self.powerWorkerDict)
end

function SeasonPowerWorkerManager:GetFreeWorker()
  if self.powerWorkerDict == nil then
    return nil
  end
  for k, v in pairs(self.powerWorkerDict) do
    if v and (v.state == PowerWorkerStatus.WAIT or v.state == PowerWorkerStatus.CHARGE_SELF) then
      return v
    end
  end
  return nil
end

function SeasonPowerWorkerManager:GetPowerWorkerByBuild(buildId, buildUuid)
  if self.powerWorkerDict == nil then
    return nil
  end
  if buildUuid == nil then
    if buildId == nil then
      return nil
    end
    local data = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(buildId, true)
    if data and data.level ~= 0 then
      buildUuid = data.uuid
    end
  end
  if buildUuid == nil then
    return nil
  end
  for k, v in pairs(self.powerWorkerDict) do
    if v and (v.buildUuid == buildUuid or v.buildingId == buildId) then
      return v
    end
  end
  return nil
end

function SeasonPowerWorkerManager:GetPowerWorkerByPointId(pointId, serverId_)
  serverId_ = serverId_ or LuaEntry.Player:GetCurServerId()
  for k, v in pairs(self.powerWorkerDict) do
    if v.pointId == pointId and v.serverId == serverId_ then
      return v
    end
  end
end

function SeasonPowerWorkerManager:GetWorkerByTargetUser(targetUid)
  if self.powerWorkerDict == nil then
    return nil
  end
  for k, v in pairs(self.powerWorkerDict) do
    if v and v.userInfo and v.userInfo.uid == targetUid then
      return v
    end
  end
  return nil
end

function SeasonPowerWorkerManager:HasHelpWorker(targetUid)
  if self.powerWorkerDict == nil then
    return false
  end
  for k, v in pairs(self.powerWorkerDict) do
    if v and v.userInfo and v.userInfo.uid == targetUid then
      return true
    end
  end
  return false
end

function SeasonPowerWorkerManager:ShowWorkerMan(buildUuid)
  local theWorld = CS.SceneManager.World
  if theWorld == nil or not SceneUtils.GetIsInCity() then
    return
  end
  local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(buildUuid)
  if buildingData == nil then
    return
  end
  local WorkerManAnim = require("UI.LWSeason4.Component.WorkerManAnim")
  local theNewEffect = WorkerManAnim.New("PowerWorkerMan", theWorld.DynamicObjNode, "Assets/Main/SeasonRes/S4/Prefabs/World/PowerWorkerMan.prefab")
  theNewEffect:ReInit(buildUuid, buildingData)
  if self.workerManEffect == nil then
    self.workerManEffect = {}
  end
  table.insert(self.workerManEffect, theNewEffect)
  local worldPointPos = buildingData:GetCenterVec()
  GoToUtil.CloseAllWindows()
  GoToUtil.GotoPos(worldPointPos, CS.SceneManager.World.InitZoom, 0.2)
end

function SeasonPowerWorkerManager:DestroyWorkerMan()
  if self.workerManEffect ~= nil then
    for _, node in pairs(self.workerManEffect) do
      if node and type(node.Delete) == "function" then
        pcall(node.Delete, node)
      end
    end
    self.workerManEffect = nil
  end
end

function SeasonPowerWorkerManager:GetMaxBrightnessLevel()
  local brightnessMaxLevel = 4
  local maxLevel = DataCenter.BuildManager:GetMaxBuildingLevel(BuildingTypes.LW_BUILD_SEASON4_INSTITUTE)
  local cfg = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.LW_BUILD_SEASON4_INSTITUTE, maxLevel)
  if cfg ~= nil then
    brightnessMaxLevel = toInt(cfg.para3)
  end
  return brightnessMaxLevel
end

function SeasonPowerWorkerManager:GetBrightnessNeedBuildLevel(brightnessLevel)
  if self.Brightness2BuildLevel then
    return self.Brightness2BuildLevel[toInt(brightnessLevel)]
  end
  local mgr = DataCenter.BuildTemplateManager
  local buildId = BuildingTypes.LW_BUILD_SEASON4_INSTITUTE
  local cfg
  local Brightness2BuildLevel = {}
  local max_level = 99
  local brightnessMaxLevel = 0
  for buildLevel = 1, max_level do
    cfg = mgr:GetBuildingLevelTemplate(buildId, buildLevel)
    if cfg ~= nil then
      brightnessMaxLevel = toInt(cfg.para3)
      max_level = toInt(cfg.max_level)
      if Brightness2BuildLevel[brightnessMaxLevel] == nil then
        Brightness2BuildLevel[brightnessMaxLevel] = buildLevel
      end
    end
    if buildLevel >= max_level then
      break
    end
  end
  self.Brightness2BuildLevel = Brightness2BuildLevel
  return Brightness2BuildLevel[toInt(brightnessLevel)]
end

function SeasonPowerWorkerManager:UpdateSimpleInfo(pointId, data)
  if self.thePointSimpleInfo == nil then
    self.thePointSimpleInfo = {}
  end
  self.thePointSimpleInfo[pointId] = data
end

function SeasonPowerWorkerManager:GetSimpleInfo(pointId)
  if self.thePointSimpleInfo == nil then
    return nil
  end
  return self.thePointSimpleInfo[pointId]
end

function SeasonPowerWorkerManager:DeleteSimpleInfo(pointId)
  if self.thePointSimpleInfo ~= nil then
    self.thePointSimpleInfo[pointId] = nil
  end
end

function SeasonPowerWorkerManager:SendElectricianToAlly(playerUid, pointId, targetUuid)
  if self:HasHelpWorker(playerUid) then
    UIUtil.ShowTipsId("season_s4_building_ui_info57")
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPowerHouse, {anim = true}, 2)
  else
    local scoutType = MarchTargetType.POWER_WORK_HELPER_CHARGE
    MarchUtil.LaunchPowerHelp(scoutType, pointId, targetUuid)
  end
end

return SeasonPowerWorkerManager
