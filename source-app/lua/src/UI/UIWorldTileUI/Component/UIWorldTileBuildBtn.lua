local UIWorldTileBuildBtn = BaseClass("UIWorldTileBuildBtn", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Param = DataClass("Param", ParamData)
local ParamData = {
  btnType,
  info,
  position
}
local this_path = ""
local btn_image_path = "BtnImage"
local effect_path = "effect"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, btn_image_path)
  self.btnImage = self:AddComponent(UIImage, btn_image_path)
  self.anim = self:TryAddComponent(UIAnimator, this_path)
  if self.anim then
    self.anim:Enable(false)
  end
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.effect = self:AddComponent(UIBaseContainer, effect_path)
  self.effect:SetActive(false)
  self.needChangeGray = false
end

local function ComponentDestroy(self)
  if self.needChangeGray then
    CS.UIGray.SetGray(self.btnImage.transform, false, true)
  end
  self.btn = nil
  self.btnImage = nil
  self.anim = nil
end

local function DataDefine(self)
  self.param = nil
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  local iconStr = WorldTileBtnTypeImage[param.btnType]
  self.param = param
  if self.param.btnType == WorldTileBtnType.City_Robot_Set then
    local queue = DataCenter.BuildQueueManager:GetQueueDataByBuildUuid(self.param.info.uuid, false, false)
    if queue ~= nil then
      iconStr = GetTableData(TableName.Robot, queue.robotId, "icon1")
    end
  end
  if iconStr then
    if string.startswith(iconStr, "Assets/Main/") then
      self.btnImage:LoadSpriteAuto(iconStr)
    else
      self.btnImage:LoadSpriteAuto(UIUtil.GetFullPath(LoadPath.UIBuildBtns, iconStr))
    end
  end
  self.btnImage:SetLocalPosition(param.position)
  self.effect:SetLocalPosition(param.position)
  self.needChangeGray = false
  if param.btnType == WorldTileBtnType.WormHoleToC and CrossServerUtil:GetCanShowCrossSubway() == false then
    self.needChangeGray = true
  end
  if self.needChangeGray then
    CS.UIGray.SetGray(self.btnImage.transform, true, true)
  end
  if self.param.btnType == WorldTileBtnType.City_SpeedUp then
    local info = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.info.uuid)
    local k1 = LuaEntry.DataConfig:TryGetNum("acc_information", "k1")
    if k1 >= info.level then
      self.effect:SetActive(true)
    else
      self.effect:SetActive(false)
    end
  else
    self.effect:SetActive(false)
  end
  EventManager:GetInstance():Broadcast(EventId.GF_building_menu_btn_popout, self.param)
end

local function UpdateTime(self)
end

local function OnBtnClick(self)
  if not LuaEntry.Player:IsInSelfServer() and not BattleFieldUtil.InBattleField() and SceneUtils.GetIsInWorld() and self.param.btnType ~= WorldTileBtnType.City_Upgrade and self.param.btnType ~= WorldTileBtnType.City_SpeedUp then
    if SeasonUtil.InSeasonBigMapMode(self.view.serverId) then
      if self.param.btnType ~= WorldTileBtnType.MummyMainUI then
        UIUtil.ShowTipsId("season_tips143")
        return
      end
    else
      UIUtil.ShowTipsId("season_tips143")
      return
    end
  end
  local buildId = self.param.info.itemId
  if self.param.btnType == WorldTileBtnType.OpenSeasonBountyShop then
    SeasonUtil.OpenSeasonActivityByType(EnumActivity.SeasonBountyShop.Type)
  elseif self.param.btnType == WorldTileBtnType.OpenSeasonMilitary then
    SeasonUtil.OpenSeasonActivityByType(EnumActivity.SeasonMilitary.Type)
  elseif self.param.btnType == WorldTileBtnType.OpenSeasonMilitaryElite then
    SeasonUtil.OpenSeasonActivityByType(EnumActivity.SeasonMilitaryElite.Type)
  elseif self.param.btnType == WorldTileBtnType.LightHouseMainUI then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPowerHouse, {anim = true}, 1)
  elseif self.param.btnType == WorldTileBtnType.SeasonBigPhoto then
    UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonPhotoList, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  elseif self.param.btnType == WorldTileBtnType.SeasonWorld then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWSeasonWorld, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  elseif self.param.btnType == WorldTileBtnType.MummyMainUI then
    SeasonUtil.ShowSeasonUI(UIWindowNames.UILWMummyMain)
  elseif self.param.btnType == WorldTileBtnType.Mastery then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMastery, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  elseif self.param.btnType == WorldTileBtnType.MasterySkill then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMasterySkillUse, {anim = true, playEffect = false})
  elseif self.param.btnType == WorldTileBtnType.SeasonBuildPickUp then
    local uuid = self.param.info.uuid
    UIUtil.ShowMessage(Localization:GetString("season_build_pickup_tips"), 2, nil, nil, function()
      SFSNetwork.SendMessage(MsgDefines.FreeBuildingFoldUpNew, {buildUuid = uuid})
    end, nil)
  elseif self.param.btnType == WorldTileBtnType.AssistanceSeasonBuild then
    local mainLv = DataCenter.BuildManager.MainLv
    local needMainLv = LuaEntry.DataConfig:TryGetNum("assistance_open", "k1")
    if mainLv >= needMainLv then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAssistance, self.param.info.uuid, LuaEntry.Player.uid, self.param.info.pointIndex, AssistanceType.Build)
    else
      UIUtil.ShowTips(Localization:GetString("121005", needMainLv))
    end
  elseif self.param.btnType == WorldTileBtnType.Season then
    SeasonUtil.ShowSeasonUI(UIWindowNames.UILWSeasonMain, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  elseif self.param.btnType == WorldTileBtnType.City_MyProfile then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, self.param.info.ownerUid)
  elseif self.param.btnType == WorldTileBtnType.City_Upgrade then
    DataCenter.LWSoundManager:PlaySound(62261, false)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, self.param.info.uuid)
    if not SeasonUtil.IsSeasonPlayerBuilding(self.param.info.itemId) then
      EventManager:GetInstance():Broadcast(EventId.GF_building_menu_upgrade_clicked, self.param.info)
    end
  elseif self.param.btnType == WorldTileBtnType.City_SpeedUp then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed, ItemSpdMenu.ItemSpdMenu_City, self.param.info.uuid)
    if not SeasonUtil.IsSeasonPlayerBuilding(self.param.info.itemId) then
      EventManager:GetInstance():Broadcast(EventId.GF_building_menu_speedup_clicked, self.param.info)
    end
  elseif self.param.btnType == WorldTileBtnType.City_SpeedUpRuins then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed, ItemSpdMenu.ItemSpdMenu_Fix_Ruins, self.param.info.uuid)
  elseif self.param.btnType == WorldTileBtnType.City_Attack then
  elseif self.param.btnType == WorldTileBtnType.HeroBounty then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroBountyMain, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  elseif self.param.btnType == WorldTileBtnType.City_TrainingAircraft or self.param.btnType == WorldTileBtnType.City_TrainingTank or self.param.btnType == WorldTileBtnType.City_TrainingInfantry then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITrain, self.param.info.itemId)
  elseif self.param.btnType == WorldTileBtnType.City_Science then
    GoToUtil.GotoScience(nil, nil, self.param.info.uuid)
    return
  elseif self.param.btnType == WorldTileBtnType.City_Recovery then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Repair, false)
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIHospital, self.param.info.uuid)
  elseif self.param.btnType == WorldTileBtnType.TrainList then
    RailwayUtil.OpenUITrainList(TrainTab.Enemy)
    return
  elseif self.param.btnType == WorldTileBtnType.WormHole_Enter then
    local mainBuildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
    if mainBuildData ~= nil then
      MarchUtil.OnClickStartMarch(MarchTargetType.GO_WORM_HOLE, LuaEntry.Player:GetMainWorldPos(), mainBuildData.uuid)
    end
  elseif self.param.btnType == WorldTileBtnType.WormHole_Create then
    local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
    for _, march in pairs(selfMarch) do
      if march:GetMarchStatus() == MarchStatus.BUILD_WORM_HOLE then
        return UIUtil.ShowTipsId(121268)
      end
      if march:GetMarchTargetType() == MarchTargetType.BUILD_WORM_HOLE then
        return UIUtil.ShowTipsId(121267)
      end
    end
    MarchUtil.OnClickStartMarch(MarchTargetType.BUILD_WORM_HOLE, self.param.info.mainIndex, self.param.info.uuid)
  elseif self.param.btnType == WorldTileBtnType.WormHole_Dismantle then
    local uuid = self.param.info.uuid
    UIUtil.ShowMessage(Localization:GetString("121046"), 2, nil, nil, function()
      SFSNetwork.SendMessage(MsgDefines.FreeBuildingFoldUpNew, {buildUuid = uuid})
    end, nil)
  elseif self.param.btnType == WorldTileBtnType.WormHoleToB then
    local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.APS_BUILD_WORMHOLE_SUB)
    if 0 < #list then
      local buildData = list[1]
      local targetServerId = buildData.server
      local pointId = buildData.pointId
      if 0 < pointId then
        do
          local position = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
          position.x = position.x - 1
          position.y = position.y
          position.z = position.z - 1
          UIUtil.ShowMessage(Localization:GetString("121265", Localization:GetString("156012")), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
            GoToUtil.GotoWorldPos(position, nil, nil, function()
              WorldArrowManager:GetInstance():ShowArrowEffect(0, position, ArrowType.Building)
            end, targetServerId)
          end)
        end
      end
    else
      UIUtil.ShowTips(Localization:GetString("140259"))
    end
  elseif self.param.btnType == WorldTileBtnType.WormHoleToC then
    if CrossServerUtil:GetCanShowCrossSubway() then
      local crossBuildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.WORM_HOLE_CROSS)
      if crossBuildData ~= nil then
        local targetServerId = crossBuildData.server
        local pointId = crossBuildData.pointId
        if 0 < pointId then
          do
            local position = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
            position.x = position.x - 1
            position.y = position.y
            position.z = position.z - 1
            UIUtil.ShowMessage(Localization:GetString("142502", targetServerId), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
              GoToUtil.GotoWorldPos(position, nil, nil, function()
                WorldArrowManager:GetInstance():ShowArrowEffect(0, position, ArrowType.Building)
              end, targetServerId)
            end)
          end
        end
      else
        UIUtil.ShowTips(Localization:GetString("104273"))
      end
    else
      UIUtil.ShowTips(Localization:GetString("104274"))
    end
  elseif self.param.btnType == WorldTileBtnType.CrossWormHoleEnter then
    if CrossServerUtil:GetCanShowCrossSubway() then
      local crossBuildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.WORM_HOLE_CROSS)
      if crossBuildData ~= nil then
        local targetServerId = crossBuildData.server
        MarchUtil.OnClickStartMarch(MarchTargetType.CROSS_SERVER_WORM, LuaEntry.Player:GetMainWorldPos(), crossBuildData.uuid, nil, nil, nil, targetServerId)
      else
        UIUtil.ShowTips(Localization:GetString("104273"))
      end
    else
      UIUtil.ShowTips(Localization:GetString("104274"))
    end
  elseif self.param.btnType == WorldTileBtnType.SeasonBuildDetails then
    if buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION1 or buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION2 or buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION3 or buildId == BuildingTypes.LW_BUILD_SEASON4_POWER_STATION4 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, self.param.info.uuid)
    end
  elseif self.param.btnType == WorldTileBtnType.City_Details then
    if buildId == BuildingTypes.LW_BUILD_LIBRARY then
    else
      UIUtil.OpenLWUIBuildDetailsView(tostring(self.param.info.pointIndex))
    end
    if buildId == BuildingTypes.FUN_BUILD_MAIN then
      local taylorWorkerId = 13303
      local unlockTaylor = DataCenter.WorkerDataManager:GetWorkerById(taylorWorkerId) ~= nil
      local taylorDispatchableState = WorkerUtil.IsExistDispatchableTaylorWorker()
      local hasTaylor = unlockTaylor or taylorDispatchableState
      PostEventLog.Track(PostEventLog.Defines.c_open_build_main_detail_way, {
        i_para1 = 2,
        i_para2 = hasTaylor and 1 or 2,
        i_para3 = DataCenter.BuildManager.MainLv,
        i_para4 = DataCenter.MonopolyManager.player.curId
      })
    end
  elseif self.param.btnType == WorldTileBtnType.Wall_Deployment then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWCityDefence)
  elseif self.param.btnType == WorldTileBtnType.PoliceStation then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPoliceStation)
  elseif self.param.btnType == WorldTileBtnType.City_PickUp then
    local tempBuild = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.info.uuid)
    local toggleState = DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.DecorationPickUp)
    local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.param.info.itemId)
    if toggleState and template.tab_type == UIBuildListTabType.Decorate then
      local param = self.param
      DataCenter.LWSoundManager:PlaySound(62261, false)
      UIUtil.ShowSecondMessage(Localization:GetString("building_center_title2"), Localization:GetString("building_center_desc20"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        self:PickUpBuilding(param, tempBuild)
      end, function(needPickUpConfirm)
        DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.DecorationPickUp, needPickUpConfirm)
      end, nil, function()
      end, nil, Localization:GetString(GameDialogDefine.TODAY_NO_SHOW), nil, nil, nil)
    else
      self:PickUpBuilding(self.param, tempBuild)
    end
  elseif self.param.btnType == WorldTileBtnType.City_EarthOrder then
    if LuaEntry.Effect:GetGameEffect(EffectDefine.EARTH_ORDER_UNLOCK) == 1 then
      local info = DataCenter.EarthOrderDataManager:GetOneEarthOrder()
      if info ~= nil then
        if BuildingUtils.IsRocketPlayingArrive(self.param.info.pointIndex) == true then
          UIUtil.ShowTipsId(GameDialogDefine.PLEASE_WAIT_ROCKET_STOP)
        elseif DataCenter.EarthOrderDataManager:IsPreviewStatus() then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UINoEarthOrder, NextBusinessComeType.EARTH_ORDER)
        else
          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Repair, false)
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIEarthOrder, {
            anim = true,
            UIMainAnim = UIMainAnimType.AllHide
          }, info.uuid)
        end
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UINoEarthOrder, NextBusinessComeType.EARTH_ORDER)
      end
    else
      UIUtil.ShowTipsId(129000)
      return
    end
  elseif self.param.btnType == WorldTileBtnType.City_Product then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFactory, self.param.info.uuid)
  elseif self.param.btnType == WorldTileBtnType.City_BusinessCenter then
    UIUtil.CheckAndOpenBusinessCenter()
  elseif self.param.btnType == WorldTileBtnType.City_ColdCapacity then
    if self.param.info.itemId == BuildingTypes.FUN_BUILD_COLD_STORAGE then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityTable, UICapacityTableTab.Farming)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityTable)
    end
  elseif self.param.btnType == WorldTileBtnType.City_IntegratedWarehouse then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityTable, UICapacityTableTab.Farming)
  elseif self.param.btnType == WorldTileBtnType.City_ResourceTransport then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITransportRes, self.param.info.uuid)
  elseif self.param.btnType == WorldTileBtnType.Hero_Advance then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroAdvance, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllHide
    })
  elseif self.param.btnType == WorldTileBtnType.Hero_Bag then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroBag, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllHide
    })
  elseif self.param.btnType == WorldTileBtnType.GolloesCamp then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGolloesCamp, {anim = true})
  elseif self.param.btnType == WorldTileBtnType.Hero_Recruit then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruit, {anim = true})
  elseif self.param.btnType == WorldTileBtnType.Hospital_soldier then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIHospital)
  elseif self.param.btnType == WorldTileBtnType.City_SpeedUpTrain then
    local queue = DataCenter.QueueDataManager:GetQueueByType(DataCenter.ArmyManager:GetArmyQueueTypeByBuildId(self.param.info.itemId))
    if queue ~= nil then
      local state = queue:GetQueueState()
      if state == NewQueueState.Work then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed, ItemSpdMenu.ItemSpdMenu_Soldier, queue.uuid)
      end
    end
  elseif self.param.btnType == WorldTileBtnType.City_SpeedUpScience then
    local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(self.param.info.uuid)
    if queue ~= nil then
      local state = queue:GetQueueState()
      if state == NewQueueState.Work then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed, ItemSpdMenu.ItemSpdMenu_Science, queue.uuid)
      end
    end
  elseif self.param.btnType == WorldTileBtnType.City_SpeedUpHospital then
    local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.Hospital)
    if queue ~= nil then
      local state = queue:GetQueueState()
      if state == NewQueueState.Work then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed, ItemSpdMenu.ItemSpdMenu_Heal, queue.uuid)
      end
    end
  elseif self.param.btnType == WorldTileBtnType.City_IntegratedWarehouse then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityTable, UICapacityTableTab.Farming)
  elseif self.param.btnType == WorldTileBtnType.City_Defence then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationDefenceTable)
  elseif self.param.btnType == WorldTileBtnType.City_BatteryrAttack then
  elseif self.param.btnType == WorldTileBtnType.City_Assistance then
    local selfUid = LuaEntry.Player.uid
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAssistance, self.param.info.uuid, selfUid, self.param.info.mainIndex, AssistanceType.MainCity)
  elseif self.param.btnType == WorldTileBtnType.RadarCenter_Alert then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  elseif self.param.btnType == WorldTileBtnType.RadarCenter_Detective then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  elseif self.param.btnType == WorldTileBtnType.City_Repair then
    local uuid = self.param.info.uuid
    local buildData = self.param.info.buildData
    local buildTemplate = self.param.info.buildTemplate
    if buildTemplate ~= nil and buildData ~= nil and buildTemplate:CheckQuestConditionStatus(buildData, false, true, 0.2, true) then
      return
    elseif buildTemplate ~= nil and buildData ~= nil then
      local taskStatus, taskId = buildTemplate:GetQuestConditionStatus(buildData)
      if taskStatus >= TaskState.NoComplete and taskStatus ~= TaskState.Received then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, uuid)
      else
        SFSNetwork.SendMessage(MsgDefines.UserStartFixBuilding, uuid)
      end
    else
      SFSNetwork.SendMessage(MsgDefines.UserStartFixBuilding, uuid)
    end
  elseif self.param.btnType == WorldTileBtnType.AllianceEntrance then
    if LuaEntry.Player:IsInAlliance() == false then
      UIUtil.ShowTipsId(390172)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceMainTable)
    end
  elseif self.param.btnType == WorldTileBtnType.AllianceResSupport then
    if not LuaEntry.Player:IsInAlliance() then
      UIUtil.ShowTipsId(390838)
      return
    end
    local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceMemberDetail, {anim = true}, data.uid, AllianceMemberOpenType.ResSupport)
  elseif self.param.btnType == WorldTileBtnType.AllianceBattle then
    if not LuaEntry.Player:IsInAlliance() then
      UIUtil.ShowTipsId(390536)
      return
    end
    DataCenter.AllianceWarDataManager:OpenALWarMain(nil, AllianceWarTabType.Rally)
  elseif self.param.btnType == WorldTileBtnType.City_GROCERY_STORE then
    local reachLimit = DataCenter.GroceryStoreOrderDataManager:IsReachMax()
    if reachLimit == true then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIReachLimit, NextBusinessComeType.GROCERY_STORE)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGroceryStore)
    end
  elseif self.param.btnType == WorldTileBtnType.City_Robot_Set then
  elseif self.param.btnType == WorldTileBtnType.ARMY then
    DataCenter.LWSoundManager:PlaySound(62261, false)
    if self.param.info.itemId == BuildingTypes.LW_BUILD_ARMY_YARD then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UISoldierDetails, self.param.info.uuid)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIArmyInfo)
    end
  elseif self.param.btnType == WorldTileBtnType.WorldNews then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldBattleNews)
  elseif self.param.btnType == WorldTileBtnType.Hero_Station then
    UIUtil.OpenHeroStationByBuildUuid(self.param.info.uuid)
  elseif self.param.btnType == WorldTileBtnType.StorageShop then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIStorageShopMain)
  elseif self.param.btnType == WorldTileBtnType.CommonShop then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop)
  elseif self.param.btnType == WorldTileBtnType.Konbini then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIKonbini, self.param.info.uuid)
  elseif self.param.btnType == WorldTileBtnType.WorldTrend then
    DataCenter.WorldTrendManager:RequestWorldTrendServerData()
  elseif self.param.btnType == WorldTileBtnType.Talent then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITalentInfo, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, DataCenter.TalentDataManager.specialShowTalentId)
  elseif self.param.btnType == WorldTileBtnType.HeroResetShop then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroResetShop)
  elseif self.param.btnType == WorldTileBtnType.Train_Soldier then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMilitaryCampPanel, {anim = true}, self.param.info.uuid)
  elseif self.param.btnType == WorldTileBtnType.Collect_Soldier then
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.info.uuid)
    BuildingUtils.CollectSoldier(buildData)
  elseif self.param.btnType == WorldTileBtnType.Worker_List then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorkerList, {anim = true})
  elseif self.param.btnType == WorldTileBtnType.WorkerOverview then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorkerOverviewList, {anim = true})
  elseif self.param.btnType == WorldTileBtnType.Worker_BuildQueue then
    local canBuyQueueId = DataCenter.BuildQueueManager:GetCanBuyQueue()
    if canBuyQueueId then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWWorkerQueue, {anim = true}, canBuyQueueId)
    end
  elseif self.param.btnType == WorldTileBtnType.Equip then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIEquipMainPanel, {anim = false}, self.param.info.uuid)
  elseif self.param.btnType == WorldTileBtnType.TacticalChipFactory then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalChipFactory, {anim = false}, self.param.info.uuid)
  elseif self.param.btnType == WorldTileBtnType.City_Shield then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWCityShield, {anim = true})
  elseif self.param.btnType == WorldTileBtnType.HeroSquad then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPVPFormation, {anim = true}, EnterHeroSquadPanelWay.ParkingLotBuilding, self.param.info.uuid)
  elseif self.param.btnType == WorldTileBtnType.EffectOverview then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWEffectOverview, {anim = true})
  elseif self.param.btnType == WorldTileBtnType.JumpStage then
    UIUtil.StageJump()
  elseif self.param.btnType == WorldTileBtnType.ChangeNation then
    local tempNation = LuaEntry.Player.countryFlag
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISetPlayerNation, {anim = true}, {
      nation = tempNation,
      callback = function(tempSelected)
        SFSNetwork.SendMessage(MsgDefines.SetCountryFlag, tempSelected)
        ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.GetUserInfoMulti, {
          LuaEntry.Player.uid
        })
        SFSNetwork.SendMessage(MsgDefines.GetNewUserInfo, LuaEntry.Player.uid)
      end
    })
  elseif self.param.btnType == WorldTileBtnType.Decoration then
    EventManager:GetInstance():Broadcast(EventId.UIDecorationMainViewOpen)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDecorationMain, {anim = true})
  elseif self.param.btnType == WorldTileBtnType.SquadEquip then
  elseif self.param.btnType == WorldTileBtnType.Decirate_Details then
    local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.param.info.itemId)
    if template.tab_type == UIBuildListTabType.Decorate then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, self.param.info.uuid)
      EventManager:GetInstance():Broadcast(EventId.GF_building_menu_upgrade_clicked, self.param.info)
    end
  elseif self.param.btnType == WorldTileBtnType.PVPArena then
    local peakArenastate = DataCenter.LWPVPArenaManager.state
    local arena3V3State = DataCenter.LW3V3ArenaManager.state
    local newbieArenaV2State = DataCenter.LWNewbieArenaV2Manager:GetState()
    local newPeakArenaState = DataCenter.NewPeakArenaManager.state
    local newGaleArenaState = DataCenter.NewGaleArenaManager.state
    if peakArenastate == PVPArenaState.Invalide and arena3V3State == PVPArenaState.Invalide and newbieArenaV2State == ActivityArenaState.None and newPeakArenaState == NewPeakArenaState.Invalide and newGaleArenaState == NewPeakArenaState.Invalide then
      local newbieArenaState = DataCenter.LWNewbieArenaManager:GetState()
      if newbieArenaState ~= ActivityArenaState.None then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCenterTable, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide
        }, DataCenter.LWNewbieArenaManager:GetArenaInfoId())
      else
        UIUtil.ShowTipsId(801141)
      end
    else
      DataCenter.LWPVPArenaManager.ShowPVPArenaMain()
    end
  elseif self.param.btnType == WorldTileBtnType.ChampionDuel then
    if not LuaEntry.Player:IsLoginSourceServer() then
      UIUtil.ShowTipsId("entrance_config_tips001")
      return
    end
    DataCenter.NewPeakArenaManager:GoToChampionDuelMain()
  elseif self.param.btnType == WorldTileBtnType.HeroHOF then
    local heroType = HeroType.Tank
    if self.param.info.itemId == BuildingTypes.LW_BUILD_ARTILLERYCENTER then
      heroType = HeroType.Missile
    elseif self.param.info.itemId == BuildingTypes.LW_BUILD_AIRCRAFTCENTER then
      heroType = HeroType.Aircraft
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHeroHOF, {anim = true}, heroType)
  elseif self.param.btnType == WorldTileBtnType.SaveGirl then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSaveGirl)
  elseif self.param.btnType == WorldTileBtnType.TacticalWeapon then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeapon, {anim = true})
  elseif self.param.btnType == WorldTileBtnType.SeasonWeekCard then
    GoToUtil.GotoSeasonWeekCardView()
  elseif self.param.btnType == WorldTileBtnType.PersonalFurnace then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildingPersonalFurnace, self.param.info.uuid)
  elseif self.param.btnType == WorldTileBtnType.City_BuildingFullLevelDetail then
    DataCenter.LWSoundManager:PlaySound(62261, false)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, self.param.info.uuid)
  elseif self.param.btnType == WorldTileBtnType.DecorationPlaySound then
    DataCenter.DecorationBGMManager:PlayDecorationBGM(self.param.info.itemId)
  elseif self.param.btnType == WorldTileBtnType.RebirthHospital then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIRebirthHospital, self.param.info.uuid)
  elseif self.param.btnType == WorldTileBtnType.AlertTowerTrail then
    DataCenter.LWTrailTowerManager:OpenTrailTowerMainPanel(TrailTowerTabType.TrailTower)
  elseif self.param.btnType == WorldTileBtnType.DominatorMain then
    DataCenter.DominatorManager:OnMainBuildingEntranceClick()
  elseif self.param.btnType == WorldTileBtnType.DominatorTrain then
    DataCenter.DominatorManager:OnTrainBuildingEntranceClick()
  elseif self.param.btnType == WorldTileBtnType.TacticalCard then
    TacticalCardUtil.OpenTacticalCardMain()
  elseif self.param.btnType == WorldTileBtnType.City_BuildingHelper then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIBuildingHelperView, self.param.info.itemId)
  elseif self.param.btnType == WorldTileBtnType.T11Research then
    UIManager:GetInstance():OpenWindow(UIWindowNames.T11MainView)
  elseif self.param.btnType == WorldTileBtnType.T11IdleGameEntrance then
    DataCenter.T11IdleGameManager:OnCityEntranceButtonClick()
  elseif self.param.btnType == WorldTileBtnType.SeasonTowerEntrance then
    DataCenter.LWSeasonTowerManager:OnCityEntranceButtonClick()
  elseif self.param.btnType == WorldTileBtnType.MakingCoffee then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWMakingCoffeeView)
  elseif self.param.btnType == WorldTileBtnType.CivilizationSparkFrontBreak then
    DataCenter.LWTrailTowerManager:OpenTrailTowerMainPanelWithScene(TrailTowerTabType.IntegratedStageFeatureChapter)
  elseif self.param.btnType == WorldTileBtnType.CivilizationSparkUpgrade then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUICivilizationSparkUpgrade, {anim = true}, {
      needShowArrow = self.view.worldTileBtnType == WorldTileBtnType.CivilizationSparkUpgrade
    })
  end
  if self.view and self.view.ctrl then
    self.view.ctrl:CloseSelf(true)
  end
end

local function PlayAnim(self, name)
  if self.anim then
    self.anim:Play(name, 0, 0)
  end
end

local function GetPosition(self)
  return self.btn.transform.position
end

local function PickUpBuilding(self, param, tempBuild)
  if tempBuild ~= nil then
    local resourceType = DataCenter.BuildManager:GetOutResourceTypeByBuildId(tempBuild.itemId)
    if resourceType ~= ResourceType.None then
      if tempBuild.state == BuildingStateType.Normal then
        local num = DataCenter.BuildManager:GetOutResourceNum(param.info.uuid)
        if 0 < num then
          local worldPos = SceneUtils.TileIndexToWorld(tempBuild.pointId)
          local pos = CS.SceneManager.World:WorldToScreenPoint(worldPos)
          DataCenter.DecResourceEffectManager:DecOneItemEffect(worldPos + FlyGetResourceDelta, DataCenter.ResourceManager:GetResourceIconByType(resourceType), num, param.info.uuid)
        end
      end
      local itemId
      local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(tempBuild.itemId, tempBuild.level)
      if levelTemplate ~= nil and resourceType == ResourceType.ResourceItem then
        local resourceItemId = levelTemplate:GetOutResourceItemId()
        itemId = resourceItemId
      end
      SFSNetwork.SendMessage(MsgDefines.UserResSynNew, {resourceType = resourceType, itemId = itemId})
    end
    if DataCenter.BuildManager:IsCanOutItemByBuildId(tempBuild.itemId) and tempBuild.state == BuildingStateType.Normal and DataCenter.BuildManager:IsHaveItem(param.info.uuid) then
      SFSNetwork.SendMessage(MsgDefines.ReceiveBuildingGrowValReward, {
        uuid = param.info.uuid
      })
    end
  end
  SFSNetwork.SendMessage(MsgDefines.FreeBuildingFoldUpNew, {
    buildUuid = param.info.uuid
  })
end

UIWorldTileBuildBtn.OnCreate = OnCreate
UIWorldTileBuildBtn.OnDestroy = OnDestroy
UIWorldTileBuildBtn.Param = Param
UIWorldTileBuildBtn.OnEnable = OnEnable
UIWorldTileBuildBtn.OnDisable = OnDisable
UIWorldTileBuildBtn.ComponentDefine = ComponentDefine
UIWorldTileBuildBtn.ComponentDestroy = ComponentDestroy
UIWorldTileBuildBtn.DataDefine = DataDefine
UIWorldTileBuildBtn.DataDestroy = DataDestroy
UIWorldTileBuildBtn.ReInit = ReInit
UIWorldTileBuildBtn.OnBtnClick = OnBtnClick
UIWorldTileBuildBtn.PlayAnim = PlayAnim
UIWorldTileBuildBtn.UpdateTime = UpdateTime
UIWorldTileBuildBtn.GetPosition = GetPosition
UIWorldTileBuildBtn.PickUpBuilding = PickUpBuilding
return UIWorldTileBuildBtn
