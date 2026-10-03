local LWOpeningStageEventDealer = {}

function LWOpeningStageEventDealer:Setup()
  if self.inited then
    return
  end
  EventManager:GetInstance():AddListener(EventId.GF_pve_battle_exit, self.OnPVEBattleExit)
  EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.OnEnterCity)
  EventManager:GetInstance():AddListener(EventId.PlotGroupDone, self.OnPlotGroupDone)
  EventManager:GetInstance():AddListener(EventId.GF_goto_pve_battle_loaded, self.OnPVEBattleLoaded)
  EventManager:GetInstance():AddListener(EventId.GF_parkour_battle_win, self.OnParkourBattleWin)
  EventManager:GetInstance():AddListener(EventId.GF_parkour_battle_lose, self.OnParkourBattleLose)
  EventManager:GetInstance():AddListener(EventId.GF_count_battle_win, self.OnCountBattleWin)
  EventManager:GetInstance():AddListener(EventId.GF_count_battle_lose, self.OnCountBattleLose)
  EventManager:GetInstance():AddListener(EventId.GF_building_upgrade_done, self.OnBuildingUpgradeDone)
  EventManager:GetInstance():AddListener(EventId.OpeningStageZakuZombieDestroyed, self.OnZakuZombieDestroyed)
  EventManager:GetInstance():AddListener(EventId.GF_get_new_hero, self.OnGetNewHero)
  EventManager:GetInstance():AddListener(EventId.GF_gate_building_bubble_create, self.OnBuildingBubbleCreate)
  EventManager:GetInstance():AddListener(EventId.GF_building_hammer_bubble_click, self.OnHammerBuildingBubbleClick)
  EventManager:GetInstance():AddListener(EventId.GF_building_upgrade_time_over, self.OnBuildingUpgradeTime)
  EventManager:GetInstance():AddListener(EventId.BUILD_IN_VIEW, self.OnBuildingUpdate)
  EventManager:GetInstance():AddListener(EventId.GF_window_closed, self.OnUIWindowClose)
  EventManager:GetInstance():AddListener(EventId.PlotGroupStart, self.OnPlotGroupStart)
  self.inited = true
end

function LWOpeningStageEventDealer:Dispose()
  if not self.inited then
    return
  end
  EventManager:GetInstance():RemoveListener(EventId.GF_pve_battle_exit, self.OnPVEBattleExit)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.OnEnterCity)
  EventManager:GetInstance():RemoveListener(EventId.PlotGroupDone, self.OnPlotGroupDone)
  EventManager:GetInstance():RemoveListener(EventId.GF_goto_pve_battle_loaded, self.OnPVEBattleLoaded)
  EventManager:GetInstance():RemoveListener(EventId.GF_parkour_battle_win, self.OnParkourBattleWin)
  EventManager:GetInstance():RemoveListener(EventId.GF_parkour_battle_lose, self.OnParkourBattleLose)
  EventManager:GetInstance():RemoveListener(EventId.GF_count_battle_win, self.OnCountBattleWin)
  EventManager:GetInstance():RemoveListener(EventId.GF_count_battle_lose, self.OnCountBattleLose)
  EventManager:GetInstance():RemoveListener(EventId.GF_building_upgrade_done, self.OnBuildingUpgradeDone)
  EventManager:GetInstance():RemoveListener(EventId.OpeningStageZakuZombieDestroyed, self.OnZakuZombieDestroyed)
  EventManager:GetInstance():RemoveListener(EventId.GF_get_new_hero, self.OnGetNewHero)
  EventManager:GetInstance():RemoveListener(EventId.GF_gate_building_bubble_create, self.OnBuildingBubbleCreate)
  EventManager:GetInstance():RemoveListener(EventId.GF_building_hammer_bubble_click, self.OnHammerBuildingBubbleClick)
  EventManager:GetInstance():RemoveListener(EventId.GF_building_upgrade_time_over, self.OnBuildingUpgradeTime)
  EventManager:GetInstance():RemoveListener(EventId.BUILD_IN_VIEW, self.OnBuildingUpdate)
  EventManager:GetInstance():RemoveListener(EventId.GF_window_closed, self.OnUIWindowClose)
  EventManager:GetInstance():RemoveListener(EventId.PlotGroupStart, self.OnPlotGroupStart)
  self.inited = false
end

function LWOpeningStageEventDealer.OnPVEBattleExit()
  if #DataCenter.LWOpeningStageManager.openStages > 0 then
    DataCenter.LWOpeningStageManager:SetupStages()
  end
end

function LWOpeningStageEventDealer.OnEnterCity()
  if #DataCenter.LWOpeningStageManager.openStages > 0 and CS.SceneManager:IsInCity() then
    DataCenter.LWOpeningStageManager:UpdateCurrStageState()
    DataCenter.LWOpeningStageManager:PostprocessOfFlags()
  else
    DataCenter.LWOpeningStageManager.eventDealer:Dispose()
  end
  local delay = DataCenter.LWCivilizationSparkExtend:LWOpeningStageEventDealer_getDirtyWorksdDoDelay()
  TimerManager:GetInstance():DelayInvoke(function()
    DataCenter.LWOpeningStageManager.dirtyWorks:Do(false)
  end, delay)
end

function LWOpeningStageEventDealer.OnPlotGroupStart(plotGroupId)
  if #DataCenter.LWOpeningStageManager.closeStages > 0 and plotGroupId == DataCenter.LWOpeningStageManager.closeStages[1].over_plot and DataCenter.LWOpeningStageManager.closeStages[1].id == 3 then
    DataCenter.BuildBubbleManager:HideBubbleNode()
  end
end

function LWOpeningStageEventDealer.OnPlotGroupDone(plotGroupId)
  if #DataCenter.LWOpeningStageManager.openStages > 0 and plotGroupId == DataCenter.LWOpeningStageManager.openStages[1].plot then
    DataCenter.LWOpeningStageManager:OnMarchBegin()
  elseif 0 < #DataCenter.LWOpeningStageManager.closeStages and plotGroupId == DataCenter.LWOpeningStageManager.closeStages[1].over_plot then
    DataCenter.LWOpeningStageManager.squadProxy:WelcomeNewFellow()
    DataCenter.LWOpeningStageManager.dirtyWorks:PlotGroupDone(plotGroupId)
  end
end

function LWOpeningStageEventDealer.OnPVEBattleLoaded(battleParams)
  DataCenter.LWOpeningStageManager:ClearStages()
end

function LWOpeningStageEventDealer.OnParkourBattleWin(levelId)
  if levelId == tonumber(DataCenter.LWOpeningStageManager.openStages[1].param) then
    DataCenter.LWOpeningStageManager:OnStageWin(levelId)
  end
end

function LWOpeningStageEventDealer.OnParkourBattleLose(levelId)
  if levelId == tonumber(DataCenter.LWOpeningStageManager.openStages[1].param) then
    DataCenter.LWOpeningStageManager:OnStageLose(levelId)
  end
end

function LWOpeningStageEventDealer.OnCountBattleWin(levelId)
  if levelId == tonumber(DataCenter.LWOpeningStageManager.openStages[1].param) then
    DataCenter.LWOpeningStageManager:OnStageWin(levelId)
  end
end

function LWOpeningStageEventDealer.OnCountBattleLose(levelId)
  if levelId == tonumber(DataCenter.LWOpeningStageManager.openStages[1].param) then
    DataCenter.LWOpeningStageManager:OnStageLose(levelId)
  end
end

function LWOpeningStageEventDealer.OnBuildingUpgradeDone(info)
  local buildingId = info.itemId
  local pointId = info.pointId
  local newLevel = info.level
  local rewardId = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.Building), buildingId + newLevel, "reward")
  if not string.IsNullOrEmpty(rewardId) then
    local resItemTypes = LocalController:instance():getValue("reward", rewardId, "resource_item_random_type")
    local resItemRate = LocalController:instance():getValue("reward", rewardId, "resource_item_rate")
    local resItemTypesArr = string.split(resItemTypes, "|")
    local resItemRateArr = string.split(resItemRate, "|")
    for i = 1, #resItemTypesArr do
      local resItemType = tonumber(resItemTypesArr[i])
      local resItemRate = resItemRateArr[i]
      if tonumber(resItemType) == ResourceItemRealType.OpeningHeroStar then
        local count = tonumber(string.split(resItemRate, ";")[1])
        DataCenter.LWOpeningStageManager.dirtyWorks:AbsorbStars(count, buildingId, pointId)
      end
    end
  end
  DataCenter.LWOpeningStageManager.utils.UpdateStageBubbleVisible(true)
  if not DataCenter.LWCivilizationSparkExtend:UseCivilizationSparkGuide() and newLevel == 1 then
    if buildingId == BuildingTypes.LW_BUILD_GATE then
      DataCenter.LWOpeningStageManager.dirtyWorks:GateFixed()
    else
      DataCenter.LWOpeningStageManager.dirtyWorks:TryOnBuildUpgradeFinish(pointId)
    end
  end
end

function LWOpeningStageEventDealer.OnZakuZombieDestroyed(zaku)
  local utils = DataCenter.LWOpeningStageManager.utils
  utils.CreateZakuZombie(zaku.config)
end

function LWOpeningStageEventDealer.OnGetNewHero(heroData)
  DataCenter.LWOpeningStageManager.squadProxy.newHero = heroData
end

function LWOpeningStageEventDealer.OnUIWindowClose(windowName)
  if DataCenter.LWCivilizationSparkExtend:UseCivilizationSparkGuide() then
    return
  end
  DataCenter.LWOpeningStageManager.dirtyWorks.OnUIWindowClose(windowName)
end

function LWOpeningStageEventDealer.OnBuildingBubbleCreate(buildingParam)
  if DataCenter.LWCivilizationSparkExtend:UseCivilizationSparkGuide() then
    return
  end
  DataCenter.LWOpeningStageManager.dirtyWorks.LoadFingerBubbleByBuildingBubble(buildingParam)
end

function LWOpeningStageEventDealer.OnHammerBuildingBubbleClick(buildingData)
  local utils = DataCenter.LWOpeningStageManager.utils
  utils.ClearAllFingers()
end

function LWOpeningStageEventDealer.OnBuildingUpdate(buildingUuid)
  if DataCenter.LWCivilizationSparkExtend:UseCivilizationSparkGuide() then
    return
  end
  if DataCenter.LWOpeningStageManager:IsStageDone(4) then
    return
  end
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(buildingUuid)
  local utils = DataCenter.LWOpeningStageManager.utils
  if buildData and buildData.itemId == BuildingTypes.LW_BUILD_GATE and buildData.level == 0 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    utils.ClearAllFingers()
    if buildData.state == BuildingStateType.Upgrading and curTime >= buildData.updateTime then
      local pos = SceneUtils.TileIndexToWorld(buildData.pointId)
      local newPos = Vector3.New(pos.x - 3, pos.y + 4, pos.z)
      DataCenter.LWOpeningStageManager.dirtyWorks.LoadFingerBubble(newPos, 4)
    end
  elseif buildData and buildData.itemId == BuildingTypes.LW_BUILD_GATE and buildData.level == 1 then
    utils.ClearAllFingers()
  end
end

function LWOpeningStageEventDealer.OnBuildingUpgradeTime(buildData)
  LWOpeningStageEventDealer.OnBuildingUpdate(buildData.uuid)
  LWOpeningStageEventDealer.OnBuildTimeEnd(buildData)
end

function LWOpeningStageEventDealer.OnBuildTimeEnd(buildData)
  if DataCenter.LWCivilizationSparkExtend:UseCivilizationSparkGuide() then
    return
  end
  DataCenter.LWOpeningStageManager.dirtyWorks:TryOnBuildTimeEnd(buildData)
end

return LWOpeningStageEventDealer
