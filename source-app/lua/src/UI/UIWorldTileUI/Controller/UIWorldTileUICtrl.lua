local UIWorldTileUICtrl = BaseClass("UIWorldTileUICtrl", UIBaseCtrl)

local function CloseSelf(self, hidAnim)
  if hidAnim ~= nil and hidAnim == true then
    UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldTileUI, {
      anim = true,
      playEffect = false,
      UIMainAnim = UIMainAnimType.LeftRightBottomShow
    })
  else
    UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldTileUI)
  end
end

local shieldCityDetails = {
  BuildingTypes.LW_BUILD_PARKINGLOT,
  BuildingTypes.LW_BUILD_PARKINGLOT_TWO,
  BuildingTypes.LW_BUILD_PARKINGLOT_THREE,
  BuildingTypes.LW_BUILD_PARKINGLOT_FOUR,
  BuildingTypes.LW_BUILD_TANKCENTER,
  BuildingTypes.LW_BUILD_ARTILLERYCENTER,
  BuildingTypes.LW_BUILD_AIRCRAFTCENTER,
  BuildingTypes.LW_BUILD_FLAG,
  BuildingTypes.LW_BUILD_GATE
}

local function GetIsShield(itemId)
  for i, v in pairs(shieldCityDetails) do
    if itemId == v then
      return true
    end
  end
end

local function GetBuildBtn(self, buildInfo)
  local buttonList = {}
  if buildInfo ~= nil and (SceneUtils.GetIsInCity() or SceneUtils.GetIsInWorld() and (SeasonUtil.IsSeasonPlayerBuilding(buildInfo.itemId) or buildInfo.itemId == BuildingTypes.APS_BUILD_WORMHOLE_SUB or buildInfo.itemId == BuildingTypes.WORM_HOLE_CROSS)) then
    if buildInfo.ownerUid == LuaEntry.Player.uid then
      local uuid = buildInfo.uuid
      local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
      if buildData ~= nil then
        local buildId = buildData.itemId
        local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
        if buildTemplate ~= nil then
          if buildTemplate.tab_type == UIBuildListTabType.Decorate then
            table.insert(buttonList, WorldTileBtnType.City_PickUp)
          end
          if buildData.level >= 0 then
            local buildingLvTemplate
            if buildData.level > 0 then
              buildingLvTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
            elseif buildTemplate:CheckQuestConditionStatus(buildData) then
              table.insert(buttonList, WorldTileBtnType.City_Repair)
            else
              local taskStatus, taskId = buildTemplate:GetQuestConditionStatus(buildData)
              if taskStatus >= TaskState.NoComplete and taskStatus ~= TaskState.Received then
                table.insert(buttonList, WorldTileBtnType.City_Repair)
              end
            end
            if 0 < buildData.destroyStartTime then
              local curTime = UITimeManager:GetInstance():GetServerTime()
              if curTime < buildData.destroyEndTime then
                table.insert(buttonList, WorldTileBtnType.City_SpeedUpRuins)
              elseif 0 >= buildData.destroyEndTime then
                table.insert(buttonList, WorldTileBtnType.City_Repair)
              end
            else
              local curTime = UITimeManager:GetInstance():GetServerTime()
              local isSpeedUp = false
              if curTime < buildData.updateTime then
                isSpeedUp = true
              else
                if buildId == BuildingTypes.LW_BUILD_RAILWAY_STATION then
                  local state = DataCenter.LWMyStationDataManager:GetRailwayStationState()
                  if state ~= RailwayStationState.Disable and state ~= RailwayStationState.WarmUp then
                    table.insert(buttonList, WorldTileBtnType.TrainList)
                  end
                end
                if buildTemplate.tab_type == UIBuildListTabType.Decorate then
                  if buildData.level >= buildTemplate.max_level then
                    table.insert(buttonList, WorldTileBtnType.Decirate_Details)
                  end
                  local soundName = DataCenter.DecorationBGMManager:GetSoundNameByBuildId(checknumber(buildTemplate.id))
                  if not string.IsNullOrEmpty(soundName) then
                    table.insert(buttonList, WorldTileBtnType.DecorationPlaySound)
                  end
                end
                local canShowUpgrade = buildTemplate.max_level > buildData.level and buildData.level > 0
                if canShowUpgrade and buildingLvTemplate ~= nil and not buildingLvTemplate:IsTimeConditionValid() then
                  canShowUpgrade = false
                end
                if SeasonUtil.IsMummyYardBuilding(buildId) then
                  if buildData.level == 0 then
                    canShowUpgrade = true
                  end
                  table.insert(buttonList, WorldTileBtnType.MummyMainUI)
                end
                if buildId == BuildingTypes.LW_BUILD_SEASON4_LIGHTHOUSE then
                  if buildData.level == 0 then
                    canShowUpgrade = true
                  else
                    table.insert(buttonList, WorldTileBtnType.LightHouseMainUI)
                  end
                end
                if canShowUpgrade and buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB then
                  table.insert(buttonList, WorldTileBtnType.City_Upgrade)
                end
                local isCurBuildingMaxLevel = BuildingUtils.IsBuildMaxLevel(buildTemplate, buildingLvTemplate)
                if isCurBuildingMaxLevel and buildTemplate.tab_type ~= UIBuildListTabType.Decorate and buildId ~= BuildingTypes.LW_BUILD_SEASON_BIG_PHOTO and buildId ~= BuildingTypes.SEASON_CAREER_BUILD and buildId ~= BuildingTypes.LW_CIVILIZATION_SPARK then
                  table.insert(buttonList, WorldTileBtnType.City_BuildingFullLevelDetail)
                end
              end
              if buildTemplate.tab_type == UIBuildListTabType.SeasonBuild then
                buttonList = {}
                if isSpeedUp then
                  table.insert(buttonList, WorldTileBtnType.City_SpeedUp)
                else
                  table.insert(buttonList, WorldTileBtnType.SeasonBuildPickUp)
                  table.insert(buttonList, WorldTileBtnType.City_Upgrade)
                end
                table.insert(buttonList, WorldTileBtnType.AssistanceSeasonBuild)
                return buttonList
              end
              if buildId == BuildingTypes.FUN_BUILD_CAR_BARRACK or buildId == BuildingTypes.FUN_BUILD_INFANTRY_BARRACK or buildId == BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK then
                local queue = DataCenter.QueueDataManager:GetQueueByType(DataCenter.ArmyManager:GetArmyQueueTypeByBuildId(buildId))
                if queue ~= nil then
                  if buildId == BuildingTypes.FUN_BUILD_CAR_BARRACK then
                    table.insert(buttonList, WorldTileBtnType.City_TrainingTank)
                  elseif buildId == BuildingTypes.FUN_BUILD_INFANTRY_BARRACK then
                    table.insert(buttonList, WorldTileBtnType.City_TrainingInfantry)
                  elseif buildId == BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK then
                    table.insert(buttonList, WorldTileBtnType.City_TrainingAircraft)
                  end
                  local state = queue:GetQueueState()
                  if state == NewQueueState.Finish then
                    SFSNetwork.SendMessage(MsgDefines.QueueFinish, {
                      uuid = queue.uuid
                    })
                  elseif state == NewQueueState.Work then
                  end
                end
              elseif buildId == BuildingTypes.FUN_BUILD_ARROW_TOWER then
              elseif buildId == BuildingTypes.FUN_BUILD_POLICE_STATION then
                table.insert(buttonList, WorldTileBtnType.PoliceStation)
              elseif buildId == BuildingTypes.FUN_BUILD_SMITHY then
                table.insert(buttonList, WorldTileBtnType.AllianceBattle)
              elseif buildId == BuildingTypes.FUND_BUILD_ALLIANCE_CENTER then
                table.insert(buttonList, WorldTileBtnType.AllianceEntrance)
              elseif buildId == BuildingTypes.LW_BUILD_BATTLE_HANGUP_REWARD then
                table.insert(buttonList, WorldTileBtnType.JumpStage)
              elseif buildId == BuildingTypes.LW_BUILD_PVP_ARENA then
                table.insert(buttonList, WorldTileBtnType.PVPArena)
                if DataCenter.NewPeakArenaManager:GetChampionDuelIsOpen() then
                  table.insert(buttonList, WorldTileBtnType.ChampionDuel)
                  DataCenter.LoginGuideManager:PlayChampionGuide()
                end
              elseif buildId == BuildingTypes.LW_BUILD_SEASON_BIG_PHOTO then
                if DataCenter.SeasonPhotoManager:HasPhotoSimpleArr() or DataCenter.SeasonPhotoManager:IsActive() then
                  table.insert(buttonList, WorldTileBtnType.SeasonBigPhoto)
                end
                table.insert(buttonList, WorldTileBtnType.SeasonWorld)
              elseif buildId == BuildingTypes.LW_BUILD_TANKCENTER or buildId == BuildingTypes.LW_BUILD_ARTILLERYCENTER or buildId == BuildingTypes.LW_BUILD_AIRCRAFTCENTER then
                local lockLevel = LuaEntry.DataConfig:TryGetNum("honor_wall_unlock", "k1", 1)
                if lockLevel <= buildData.level then
                  table.insert(buttonList, WorldTileBtnType.HeroHOF)
                end
              end
              if buildData.level > 0 and buildingLvTemplate ~= nil and 0 < buildingLvTemplate.hero_slots and buildTemplate.tab_type ~= UIBuildListTabType.Decorate and buildTemplate.tab_type ~= UIBuildListTabType.SeasonBuild then
                if buildId == BuildingTypes.FUN_BUILD_MAIN then
                  local unlock = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.TileBtn_MainCityDetails)
                  local taylorWorkerId = 13303
                  local taylorState = DataCenter.WorkerDataManager:GetTargetWorkerStateByCfgId(taylorWorkerId)
                  local hasUnlockTaylor = taylorState == WorkerState.WORKER or taylorState == WorkerState.RESIDENTA
                  local sherryWorkerId = 13304
                  local sherryState = DataCenter.WorkerDataManager:GetTargetWorkerStateByCfgId(sherryWorkerId)
                  local hasUnlockSherry = sherryState == WorkerState.WORKER or sherryState == WorkerState.RESIDENTA
                  if unlock or 0 < DataCenter.ItemData:GetItemCount(813303) or 0 < DataCenter.ItemData:GetItemCount(813304) or hasUnlockTaylor or hasUnlockSherry then
                    table.insert(buttonList, WorldTileBtnType.City_Details)
                  end
                else
                  table.insert(buttonList, WorldTileBtnType.City_Details)
                end
              end
              if buildId == BuildingTypes.APS_BUILD_WORMHOLE_MAIN then
                table.insert(buttonList, WorldTileBtnType.WormHoleToB)
                table.insert(buttonList, WorldTileBtnType.WormHoleToC)
              elseif buildId == BuildingTypes.WORM_HOLE_CROSS then
                table.insert(buttonList, WorldTileBtnType.CrossWormHoleEnter)
              elseif buildId == BuildingTypes.APS_BUILD_WORMHOLE_SUB then
                if buildData.level == 0 then
                  isSpeedUp = false
                  table.insert(buttonList, WorldTileBtnType.WormHole_Create)
                  table.insert(buttonList, WorldTileBtnType.WormHole_Dismantle)
                elseif buildData.level == 1 then
                  table.insert(buttonList, WorldTileBtnType.WormHole_Enter)
                end
              end
              if buildId == BuildingTypes.FUN_BUILD_MARKET then
                table.insert(buttonList, WorldTileBtnType.City_Call)
                table.insert(buttonList, WorldTileBtnType.City_QiFei)
              elseif buildId == BuildingTypes.FUN_BUILD_TRADING_CENTER then
                if buildData.level > 0 then
                  local recall = DataCenter.EarthOrderDataManager:checkIsRecall()
                  if recall == false then
                    table.insert(buttonList, WorldTileBtnType.City_EarthOrder)
                  end
                end
              elseif DataCenter.BuildManager:IsFactoryBuild(buildId) then
                if DataCenter.FactoryDataManager:HasUnlockItemByBuildId(buildId) then
                  table.insert(buttonList, WorldTileBtnType.City_Product)
                  local open = LuaEntry.Effect:GetGameEffect(EffectDefine.ROBOT_IN_FACTORY)
                  if 0 < open then
                    table.insert(buttonList, WorldTileBtnType.City_Robot_Set)
                  end
                end
              elseif buildId == BuildingTypes.APS_BUILD_PASTURE_CATTLE or buildId == BuildingTypes.APS_BUILD_PASTURE_OSTRICH or buildId == BuildingTypes.APS_BUILD_PASTURE_SANDWORM then
                local open = LuaEntry.Effect:GetGameEffect(EffectDefine.ROBOT_IN_PASTURE)
                if 0 < open then
                  table.insert(buttonList, WorldTileBtnType.City_Robot_Set)
                end
              elseif buildId == BuildingTypes.APS_BUILD_FARM then
                local open = LuaEntry.Effect:GetGameEffect(EffectDefine.ROBOT_IN_FARM)
                if 0 < open then
                  table.insert(buttonList, WorldTileBtnType.City_Robot_Set)
                end
              elseif buildId == BuildingTypes.FUN_BUILD_KONBINI then
                if DataCenter.StorageShopManager:CheckIfIsActive() then
                  table.insert(buttonList, WorldTileBtnType.StorageShop)
                end
                table.insert(buttonList, WorldTileBtnType.Konbini)
              elseif buildId == BuildingTypes.FUN_BUILD_BUSINESS_CENTER then
                if 0 >= DataCenter.ResidentOrderDataManager:GetOrderSendLeftTime() then
                  table.insert(buttonList, WorldTileBtnType.City_BusinessCenter)
                end
              elseif buildId == BuildingTypes.FUN_BUILD_COLD_STORAGE then
                table.insert(buttonList, WorldTileBtnType.City_ColdCapacity)
              elseif buildId == BuildingTypes.FUN_BUILD_WATER_STORAGE then
                table.insert(buttonList, WorldTileBtnType.City_ColdCapacity)
              elseif buildId == BuildingTypes.APS_BUILD_PUB then
                table.insert(buttonList, WorldTileBtnType.Hero_Bag)
                if self:CheckPubButtonOpen(WorldTileBtnType.Hero_Recruit) then
                  table.insert(buttonList, WorldTileBtnType.Hero_Recruit)
                end
              elseif buildId == BuildingTypes.LW_BUILD_HOSPITL then
                local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.Hospital)
                if queue ~= nil then
                  local state = queue:GetQueueState()
                  if state == NewQueueState.Finish then
                    table.insert(buttonList, WorldTileBtnType.City_Recovery)
                  elseif state == NewQueueState.Work then
                    if not isSpeedUp then
                      table.insert(buttonList, WorldTileBtnType.City_Recovery)
                    end
                  else
                    table.insert(buttonList, WorldTileBtnType.City_Recovery)
                  end
                end
              elseif buildId == BuildingTypes.LW_BUILDING_REBIRTH_HOSPITAL then
                table.insert(buttonList, WorldTileBtnType.RebirthHospital)
              elseif buildId == BuildingTypes.FUN_BUILD_COMPREHENSIVE_STORAGE then
                table.insert(buttonList, WorldTileBtnType.City_IntegratedWarehouse)
              elseif buildId == BuildingTypes.FUN_BUILD_ELECTRICITY then
                table.insert(buttonList, WorldTileBtnType.City_ResourceTransport)
              elseif buildId == BuildingTypes.FUN_BUILD_DEFENCE_CENTER then
                table.insert(buttonList, WorldTileBtnType.City_Defence)
              elseif buildId == BuildingTypes.FUN_BUILD_RADAR_CENTER then
              elseif buildId == BuildingTypes.FUN_BUILD_GROCERY_STORE or buildId == BuildingTypes.LW_BUILD_SHOP then
                if DataCenter.CommonShopManager:CheckIfModuleOpen() then
                  table.insert(buttonList, WorldTileBtnType.CommonShop)
                end
                if DataCenter.EnergyOrderManager:Enabled() then
                end
              elseif buildId == BuildingTypes.FUN_BUILD_BARRACKS then
                if buildData.level > 0 then
                  table.insert(buttonList, WorldTileBtnType.ARMY)
                  table.insert(buttonList, WorldTileBtnType.WorldNews)
                end
              elseif buildId == BuildingTypes.FUN_BUILD_MAIN then
                if buildData.level > 0 then
                  local effect = Mathf.Round(LuaEntry.Effect:GetGameEffect(EffectDefine.DETECT_EVENT_FUNCTION_OPEN))
                  if 0 < effect then
                    table.insert(buttonList, WorldTileBtnType.RadarCenter_Detective)
                  end
                end
                if DataCenter.LWEffectOverviewManager:CheckCanShow() and DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.MainBuild_Addition) then
                  table.insert(buttonList, WorldTileBtnType.EffectOverview)
                end
                if DataCenter.DecorationDataManager:IsSystemOpen() then
                  table.insert(buttonList, WorldTileBtnType.Decoration)
                end
                if DataCenter.LWSaveGirlManager:IsShowBubble() then
                  table.insert(buttonList, WorldTileBtnType.SaveGirl)
                end
              elseif buildId == BuildingTypes.FUN_BUILD_DRONE then
                if DataCenter.WorldTrendManager:CheckOpen() and DataCenter.BuildManager.MainLv >= 4 then
                  table.insert(buttonList, WorldTileBtnType.WorldTrend)
                end
              elseif buildId == BuildingTypes.LW_BUILD_TALENT_HALL then
                table.insert(buttonList, WorldTileBtnType.WorkerOverview)
              elseif buildId == BuildingTypes.FUN_BUILD_HERO_BOUNTY then
                if buildData.level > 0 then
                  table.insert(buttonList, WorldTileBtnType.HeroBounty)
                end
              elseif buildId == BuildingTypes.FUN_BUILD_HERO_OFFICE then
                table.insert(buttonList, WorldTileBtnType.HeroOfficial)
              elseif buildId == BuildingTypes.FUN_BUILD_HERO_BAR then
                table.insert(buttonList, WorldTileBtnType.LevelExplore)
              elseif buildId == BuildingTypes.FUN_BUILD_CONDOMINIUM then
                if DataCenter.EnergyOrderManager:Enabled() then
                end
              elseif buildId == BuildingTypes.LW_BUILD_MILITARY_CAMP then
                if buildData.level > 0 then
                  local isTrain = BuildingUtils.IsBuildingFunctioning(buildData)
                  local finishTrain = BuildingUtils.IsBuildingFinishFunctioning(buildData)
                  if isTrain and finishTrain then
                    table.insert(buttonList, WorldTileBtnType.Collect_Soldier)
                  else
                    table.insert(buttonList, WorldTileBtnType.Train_Soldier)
                  end
                end
              elseif buildId == BuildingTypes.LW_BUILDING_SEASON5_SHOP or buildId == BuildingTypes.LW_BUILD_SEASON6_BUILD1 then
                if buildData.level > 0 then
                  table.insert(buttonList, WorldTileBtnType.OpenSeasonBountyShop)
                  table.insert(buttonList, WorldTileBtnType.OpenSeasonMilitary)
                  table.insert(buttonList, WorldTileBtnType.OpenSeasonMilitaryElite)
                end
              elseif buildId == BuildingTypes.SEASON_CAREER_BUILD then
                table.insert(buttonList, WorldTileBtnType.Mastery)
                if DataCenter.MasteryManager:IsShowWorldMasteryBtn() then
                  table.insert(buttonList, WorldTileBtnType.MasterySkill)
                end
                if TacticalCardUtil.IsFunctionOpen() then
                  table.insert(buttonList, WorldTileBtnType.TacticalCard)
                end
              elseif buildId == BuildingTypes.LW_BUILD_PUB then
                if buildData.level > 0 then
                  table.insert(buttonList, WorldTileBtnType.Hero_Recruit)
                end
              elseif buildId == BuildingTypes.LW_BUILD_WORKER_HOUSE then
                if buildData.level > 0 and DataCenter.BuildQueueManager:GetCanBuyQueue() ~= nil then
                  table.insert(buttonList, WorldTileBtnType.Worker_BuildQueue)
                end
              elseif buildId == BuildingTypes.LW_BUILD_SMITH_SHOP then
                if buildData.level > 0 then
                  table.insert(buttonList, WorldTileBtnType.Equip)
                end
              elseif buildId == BuildingTypes.LW_BUILDING_TACTICAL_CHIP_FACTORY then
                if buildData.level > 0 then
                  table.insert(buttonList, WorldTileBtnType.TacticalChipFactory)
                end
              elseif buildId == BuildingTypes.LW_BUILD_GATE then
                if buildData.level > 0 then
                  table.insert(buttonList, WorldTileBtnType.Wall_Deployment)
                end
              elseif buildId == BuildingTypes.LW_BUILD_ARMY_YARD then
                if buildData.level > 0 then
                  table.insert(buttonList, WorldTileBtnType.ARMY)
                end
              elseif buildId == BuildingTypes.LW_BUILD_PARKINGLOT_FOUR or buildId == BuildingTypes.LW_BUILD_PARKINGLOT_THREE or buildId == BuildingTypes.LW_BUILD_PARKINGLOT_TWO or buildId == BuildingTypes.LW_BUILD_PARKINGLOT then
                table.insert(buttonList, WorldTileBtnType.HeroSquad)
              elseif buildId == BuildingTypes.LW_BUILD_FLAG then
                if buildData.level > 0 and not LuaEntry.Player:IsFromBIGCHINAorUsingLangZH() then
                  table.insert(buttonList, WorldTileBtnType.ChangeNation)
                end
              elseif buildId == BuildingTypes.FUN_BUILD_SCIENE or buildId == BuildingTypes.FUN_BUILD_SCIENCE_PART or buildId == BuildingTypes.LW_BUILE_SCIENCE_TWO or buildId == BuildingTypes.LW_BUILE_SCIENCE_THREE then
                local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(uuid)
                if queue ~= nil then
                  table.insert(buttonList, WorldTileBtnType.City_Science)
                  local state = queue:GetQueueState()
                  if state == NewQueueState.Finish then
                  elseif state == NewQueueState.Work and not isSpeedUp then
                    table.insert(buttonList, WorldTileBtnType.City_SpeedUpScience)
                  end
                end
              elseif buildId == BuildingTypes.LW_BUILD_TACTICAL_CENTER then
                if buildData.level > 0 then
                  table.insert(buttonList, WorldTileBtnType.TacticalWeapon)
                end
              elseif buildId == BuildingTypes.LW_BUILD_ALERTTOWER then
                local isT11IdleGameOn = DataCenter.T11IdleGameManager:IsT11IdleGameFunctionOn()
                if not isT11IdleGameOn then
                  if DataCenter.LWTrailTowerManager:ShowAlertTowerEntrance() and DataCenter.BuildManager.MainLv >= DataCenter.LWTrailTowerManager:GetCfgTrailTowerBaseLevel() then
                    table.insert(buttonList, WorldTileBtnType.AlertTowerTrail)
                  end
                elseif DataCenter.T11IdleGameManager:IsShowCityAlertTowerEntrance() then
                  table.insert(buttonList, WorldTileBtnType.T11IdleGameEntrance)
                end
                if DataCenter.LWSeasonTowerManager:IsShowEntrance() then
                  table.insert(buttonList, WorldTileBtnType.SeasonTowerEntrance)
                end
              elseif buildId == BuildingTypes.LW_BUILD_DOMINATOR_MAIN then
                table.insert(buttonList, WorldTileBtnType.DominatorMain)
              elseif buildId == BuildingTypes.LW_BUILDING_SEASON5_RESEARCH then
                if buildData.level > 0 then
                  table.insert(buttonList, WorldTileBtnType.MakingCoffee)
                end
              elseif buildId == BuildingTypes.LW_BUILD_DOMINATOR_TRAIN then
              elseif buildId == BuildingTypes.LW_T11_Research then
                table.insert(buttonList, WorldTileBtnType.T11Research)
              elseif buildId == BuildingTypes.LW_CIVILIZATION_SPARK then
                table.insert(buttonList, WorldTileBtnType.CivilizationSparkFrontBreak)
                local level = DataCenter.LWCivilizationSparkManager:GetLevel()
                if 0 < level then
                  table.insert(buttonList, WorldTileBtnType.CivilizationSparkUpgrade)
                end
              end
              if isSpeedUp then
                if #buttonList == 1 then
                  table.insert(buttonList, 1, WorldTileBtnType.City_SpeedUp)
                elseif #buttonList == 0 then
                  table.insert(buttonList, WorldTileBtnType.City_SpeedUp)
                else
                  table.insert(buttonList, 2, WorldTileBtnType.City_SpeedUp)
                end
              end
              if buildId == BuildingTypes.APS_BUILD_PUB then
              end
              if DataCenter.HeroStationManager:Enabled() and DataCenter.HeroStationManager:GetStationIdByBuildId(buildId) ~= nil then
                table.insert(buttonList, WorldTileBtnType.Hero_Station)
              end
              if buildId == BuildingTypes.LW_BUILDING_SEASON2_PERSONAL_FURNACE then
                table.insert(buttonList, WorldTileBtnType.PersonalFurnace)
              end
              if BuildingUtils.IsSeasonWeekCardCityBuilding(buildId) then
                local flag = true
                local seasonConfig = DataCenter.SeasonDataManager:GetSeasonConfig()
                if seasonConfig then
                  local cardData = DataCenter.SeasonPeriodicCardManager:GetCardData(tonumber(seasonConfig.week_card))
                  if cardData and cardData:IsBought() then
                    flag = false
                  end
                end
                if flag then
                  buttonList = {}
                  table.insert(buttonList, WorldTileBtnType.SeasonWeekCard)
                end
              end
              table.sort(buttonList, function(a, b)
                if a == WorldTileBtnType.City_BuildingHelper then
                  return false
                end
                if b == WorldTileBtnType.City_BuildingHelper then
                  return true
                end
                if a == WorldTileBtnType.Talent then
                  return false
                end
                if b == WorldTileBtnType.Talent then
                  return true
                end
                if a == WorldTileBtnType.JumpStage then
                  return false
                end
                if b == WorldTileBtnType.JumpStage then
                  return true
                end
                if a == WorldTileBtnType.City_Details then
                  return false
                end
                if b == WorldTileBtnType.City_Details then
                  return true
                end
                if a == WorldTileBtnType.City_Upgrade then
                  return true
                end
                if b == WorldTileBtnType.City_Upgrade then
                  return false
                end
                if a == WorldTileBtnType.City_SpeedUp then
                  return true
                end
                if b == WorldTileBtnType.City_SpeedUp then
                  return false
                end
                if a == WorldTileBtnType.City_BuildingFullLevelDetail then
                  return true
                end
                if b == WorldTileBtnType.City_BuildingFullLevelDetail then
                  return false
                end
                return b < a
              end)
            end
          end
        end
      end
    else
      local Player = LuaEntry.Player
      if Player:IsInAlliance() and buildInfo.allianceId == Player.allianceId then
      else
        table.insert(buttonList, WorldTileBtnType.City_Rally)
        table.insert(buttonList, WorldTileBtnType.City_Attack)
      end
    end
  end
  return buttonList
end

local function GetBuildBtnEnumName(self, btnValue)
  for k, v in pairs(WorldTileBtnType) do
    if v == btnValue then
      return k
    end
  end
end

local function CheckPubButtonOpen(self, btnType)
  local k2 = LuaEntry.DataConfig:TryGetStr("free_heroes", "k2")
  if string.IsNullOrEmpty(k2) then
    return true
  end
  local vec = string.split(k2, ";")
  local mainLv = DataCenter.BuildManager.MainLv
  local index = -1
  if btnType == WorldTileBtnType.Hero_Recruit then
    index = 1
  elseif btnType == WorldTileBtnType.Hero_Advance then
    index = 2
  elseif btnType == WorldTileBtnType.HeroResetShop then
    index = 3
  elseif btnType == WorldTileBtnType.City_Details then
    index = 4
  end
  if index < 0 or index > table.count(vec) then
    return true
  end
  return mainLv >= toInt(vec[index])
end

UIWorldTileUICtrl.CloseSelf = CloseSelf
UIWorldTileUICtrl.GetBuildBtn = GetBuildBtn
UIWorldTileUICtrl.GetBuildBtnEnumName = GetBuildBtnEnumName
UIWorldTileUICtrl.CheckPubButtonOpen = CheckPubButtonOpen
return UIWorldTileUICtrl
