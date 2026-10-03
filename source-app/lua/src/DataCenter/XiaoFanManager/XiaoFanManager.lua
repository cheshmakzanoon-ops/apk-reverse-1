local XiaoFanManager = BaseClass("XiaoFanManager")
local fenceDisplayCtrl = require("DataCenter.XiaoFanManager.FenceDisplayCtrl")
local fakeRoadDisplayCtrl = require("DataCenter.XiaoFanManager.CityFakeRoadCtrl")
local sillySoildersDisplayCtrl = require("DataCenter.XiaoFanManager.CityFakeSoilderCtrl")
local theGateKeeperCtrl = require("DataCenter.XiaoFanManager.TheGateKeeperCtrl")
local flagBuildingCtrl = require("DataCenter.XiaoFanManager.FlagBuildingCtrl")
local cityFakeZombiesCtrl = require("DataCenter.XiaoFanManager.CityFakeZombiesCtrl")
local cityRepairAllBuildingsCtrl = require("DataCenter.XiaoFanManager.CityRepairAllBuildingsCtrl")
local mainBuildingGuideCtrl = require("DataCenter.XiaoFanManager.MainBuildingGuideCtrl")

local function __init(self)
  self.AddListener(self)
  UpdateManager:GetInstance():AddUpdate(self.OnUpdate)
end

local function __delete(self)
  self.RemoveListener(self)
  UpdateManager:GetInstance():RemoveUpdate(self.OnUpdate)
  fenceDisplayCtrl.Clear()
  fakeRoadDisplayCtrl.Clear()
  sillySoildersDisplayCtrl.Clear()
  theGateKeeperCtrl.Clear()
  flagBuildingCtrl.Clear()
  cityFakeZombiesCtrl.Clear()
  mainBuildingGuideCtrl.Clear()
  self:ClearAllDelayTimers()
end

local function OnEnterGame()
end

local function Startup()
end

local function OnUpdate()
  theGateKeeperCtrl.OnUpdate()
  flagBuildingCtrl.OnUpdate()
  cityFakeZombiesCtrl.OnUpdate()
end

local function OnEnterCity()
  fakeRoadDisplayCtrl.Update()
  sillySoildersDisplayCtrl.Update()
  theGateKeeperCtrl.OnEnterCity()
  flagBuildingCtrl.OnEnterCity()
  cityFakeZombiesCtrl.OnEnterCity()
  mainBuildingGuideCtrl.OnEnterCity()
end

local function SaveSquadData(heroInfo)
  local hero_uuid = DataCenter.HeroDataManager:GetHeroUuidByHeroId(heroInfo.herorId)
  if hero_uuid == nil then
    return
  end
  local squad_data = DataCenter.ArmyFormationDataManager:GetFormationByType(EnterHeroSquadPanelWay.ParkingLotBuilding, heroInfo.teamIndex)
  if squad_data == nil then
    return
  end
  squad_data:SetLocalHero(heroInfo.index, hero_uuid)
  SFSNetwork.SendMessage(MsgDefines.NormalFormationInfoSave, squad_data.uuid, squad_data:GenerateServerHeroArray(), 0)
end

function XiaoFanManager.OnBuildingUpgrade(buildingDate)
  mainBuildingGuideCtrl.OnBuildingUpgrade(buildingDate)
end

function XiaoFanManager.OnBuildingUpgradeTimeOver(buildingDate)
  mainBuildingGuideCtrl.OnBuildingUpgradeTimeOver(buildingDate)
end

local function OnBuildingUpgradeDone(buildingData)
  if buildingData.itemId == BuildingTypes.FUN_BUILD_MAIN then
    fakeRoadDisplayCtrl.Update()
    mainBuildingGuideCtrl.OnBuildingUpgradeDone(buildingData)
  elseif buildingData.itemId == BuildingTypes.LW_BUILD_PARKINGLOT and buildingData.level == 1 then
    TimerManager:GetInstance():DelayInvoke(function()
      DataCenter.BuildHeroManager:RemoveBuildHero(30005)
      DataCenter.BuildHeroManager:RemoveBuildHero(40020)
      local info = DataCenter.CityCarbarnManager:GetVacancyPos()
      info.herorId = 30005
      SaveSquadData(info)
      info = DataCenter.CityCarbarnManager:GetVacancyPos()
      info.herorId = 40020
      SaveSquadData(info)
    end, 0.5)
  elseif buildingData.itemId == BuildingTypes.LW_BUILD_FLAG then
    sillySoildersDisplayCtrl.ShowSoilders(true)
    flagBuildingCtrl.OnBuildingUpgrade()
  elseif buildingData.itemId == BuildingTypes.LW_BUILD_ARMY_YARD then
    sillySoildersDisplayCtrl.RunBabyRun()
    DataCenter.LWSoundManager:PlaySound(62244, false)
  elseif buildingData.itemId == BuildingTypes.LW_BUILD_GATE then
    DataCenter.LWCivilizationSparkExtend:XiaoFanManager_onGateBuildingUpgradeDone(buildingData, fenceDisplayCtrl)
  end
end

local function OnBeforeReleaseCity()
  fenceDisplayCtrl.HideTheBadOne()
  fakeRoadDisplayCtrl.HideTheOne()
  sillySoildersDisplayCtrl.HideSoilders()
  cityFakeZombiesCtrl.Clear()
  mainBuildingGuideCtrl.Clear()
  DataCenter.XiaoFanManager:ClearAllDelayTimers()
end

local function OnGuideFlowDone(flowId)
  fenceDisplayCtrl.Update()
  theGateKeeperCtrl.OnGuideFlowDone(flowId)
  cityFakeZombiesCtrl.OnGuideFlowDone(flowId)
  mainBuildingGuideCtrl.OnGuideFlowDone(flowId)
end

local function OnGuideFlowCanceled(flowId)
  cityFakeZombiesCtrl.OnGuideFlowCanceled(flowId)
end

local function OnCountBattleWin(stageId)
  cityFakeZombiesCtrl.OnCountStageWin(stageId)
end

local function OnParkourStageWin(stageId)
  cityFakeZombiesCtrl.OnParkourStageWin(stageId)
end

local function OnPlotGroupStart(plotId)
  cityFakeZombiesCtrl.OnPlotGroupStart(plotId)
  local mainLv = DataCenter.BuildManager.MainLv
  if mainLv and mainLv < 1 and #DataCenter.LWOpeningStageManager.closeStages > 0 and DataCenter.LWOpeningStageManager.closeStages[1].id == 7 and plotId == 2078 then
    DataCenter.BuildBubbleManager:HideBubbleNode()
  end
end

local function OnPlotGroupDone(plotId)
  cityFakeZombiesCtrl.OnPlotGroupDone(plotId)
  local mainLv = DataCenter.BuildManager.MainLv
  if mainLv and mainLv < 1 and #DataCenter.LWOpeningStageManager.closeStages > 0 and DataCenter.LWOpeningStageManager.closeStages[1].id == 7 and plotId == 2078 then
    DataCenter.BuildBubbleManager:ShowBubbleNode()
  end
end

local function OnPlotViewClosedAbnormally(plotId)
  local mainLv = DataCenter.BuildManager.MainLv
  if mainLv and mainLv < 1 and #DataCenter.LWOpeningStageManager.closeStages > 0 and DataCenter.LWOpeningStageManager.closeStages[1].id == 7 and plotId == 2078 then
    DataCenter.BuildBubbleManager:ShowBubbleNode()
  end
end

local function OnGuideFlowStepDone(behaviour)
end

local function OnGetNewUserInfoSucc()
  flagBuildingCtrl.UpdateFlagTexture()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.GF_enter_city, self.OnEnterCity)
  EventManager:GetInstance():AddListener(EventId.GF_building_upgrade_done, self.OnBuildingUpgradeDone)
  EventManager:GetInstance():AddListener(EventId.GF_city_zone_loaded, fenceDisplayCtrl.Update)
  EventManager:GetInstance():AddListener(EventId.GF_guide_done, self.OnGuideFlowDone)
  EventManager:GetInstance():AddListener(EventId.GF_guide_canceled, self.OnGuideFlowCanceled)
  EventManager:GetInstance():AddListener(EventId.GF_guide_step_done, self.OnGuideFlowStepDone)
  EventManager:GetInstance():AddListener(EventId.BeforeReleaseCity, self.OnBeforeReleaseCity)
  EventManager:GetInstance():AddListener(EventId.GetNewUserInfoSucc, self.OnGetNewUserInfoSucc)
  EventManager:GetInstance():AddListener(EventId.PlotGroupDone, self.OnPlotGroupDone)
  EventManager:GetInstance():AddListener(EventId.GF_parkour_battle_win, self.OnParkourStageWin)
  EventManager:GetInstance():AddListener(EventId.PlotGroupStart, self.OnPlotGroupStart)
  EventManager:GetInstance():AddListener(EventId.GF_building_upgrade_started, self.OnBuildingUpgrade)
  EventManager:GetInstance():AddListener(EventId.GF_building_upgrade_time_over, self.OnBuildingUpgradeTimeOver)
  EventManager:GetInstance():AddListener(EventId.PlotViewClosedAbnormally, self.OnPlotViewClosedAbnormally)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.GF_enter_city, self.OnEnterCity)
  EventManager:GetInstance():RemoveListener(EventId.GF_building_upgrade_done, self.OnBuildingUpgradeDone)
  EventManager:GetInstance():RemoveListener(EventId.GF_city_zone_loaded, fenceDisplayCtrl.Update)
  EventManager:GetInstance():RemoveListener(EventId.GF_guide_done, self.OnGuideFlowDone)
  EventManager:GetInstance():RemoveListener(EventId.GF_guide_canceled, self.OnGuideFlowCanceled)
  EventManager:GetInstance():RemoveListener(EventId.GF_guide_step_done, self.OnGuideFlowStepDone)
  EventManager:GetInstance():RemoveListener(EventId.BeforeReleaseCity, self.OnBeforeReleaseCity)
  EventManager:GetInstance():RemoveListener(EventId.GetNewUserInfoSucc, self.OnGetNewUserInfoSucc)
  EventManager:GetInstance():RemoveListener(EventId.PlotGroupDone, self.OnPlotGroupDone)
  EventManager:GetInstance():RemoveListener(EventId.GF_parkour_battle_win, self.OnParkourStageWin)
  EventManager:GetInstance():RemoveListener(EventId.PlotGroupStart, self.OnPlotGroupStart)
  EventManager:GetInstance():RemoveListener(EventId.GF_building_upgrade_started, self.OnBuildingUpgrade)
  EventManager:GetInstance():RemoveListener(EventId.GF_building_upgrade_time_over, self.OnBuildingUpgradeTimeOver)
  EventManager:GetInstance():RemoveListener(EventId.PlotViewClosedAbnormally, self.OnPlotViewClosedAbnormally)
end

function XiaoFanManager:CreateDelayTimer(callback, delay, timerName)
  if self.delayTimers == nil then
    self.delayTimers = {}
  end
  timerName = timerName or "timer_" .. tostring(#self.delayTimers + 1)
  local timer = TimerManager:GetInstance():DelayInvoke(function()
    if self.delayTimers[timerName] then
      self.delayTimers[timerName] = nil
    end
    callback()
  end, delay)
  self.delayTimers[timerName] = timer
  return timer
end

function XiaoFanManager:ClearAllDelayTimers()
  if self.delayTimers then
    for name, timer in pairs(self.delayTimers) do
      if timer then
        timer:Stop()
      end
    end
    self.delayTimers = {}
  end
end

function XiaoFanManager:HideBadOneDoor()
  fenceDisplayCtrl.HideBadOneDoor()
end

function XiaoFanManager:ShowBadOneDoor()
  fenceDisplayCtrl.ShowBadOneDoor()
end

function XiaoFanManager:HideBadOneWall()
  fenceDisplayCtrl.HideBadOneWall()
end

function XiaoFanManager:SoliderRunToYard()
  sillySoildersDisplayCtrl.RunBabyRun()
  DataCenter.LWSoundManager:PlaySound(62244, false)
end

XiaoFanManager.__init = __init
XiaoFanManager.__delete = __delete
XiaoFanManager.OnEnterGame = OnEnterGame
XiaoFanManager.Startup = Startup
XiaoFanManager.AddListener = AddListener
XiaoFanManager.RemoveListener = RemoveListener
XiaoFanManager.OnUpdate = OnUpdate
XiaoFanManager.OnEnterCity = OnEnterCity
XiaoFanManager.OnBuildingUpgradeDone = OnBuildingUpgradeDone
XiaoFanManager.OnBeforeReleaseCity = OnBeforeReleaseCity
XiaoFanManager.OnGuideFlowDone = OnGuideFlowDone
XiaoFanManager.OnGuideFlowCanceled = OnGuideFlowCanceled
XiaoFanManager.OnGuideFlowStepDone = OnGuideFlowStepDone
XiaoFanManager.OnGetNewUserInfoSucc = OnGetNewUserInfoSucc
XiaoFanManager.OnCountBattleWin = OnCountBattleWin
XiaoFanManager.OnPlotGroupDone = OnPlotGroupDone
XiaoFanManager.OnParkourStageWin = OnParkourStageWin
XiaoFanManager.OnPlotGroupStart = OnPlotGroupStart
XiaoFanManager.OnPlotViewClosedAbnormally = OnPlotViewClosedAbnormally
return XiaoFanManager
