local function CallBackDoGuide(self)
  self:CheckNoInput()
  
  self:CheckPlayDub()
  if self.template == nil then
    return
  end
  if self.template.type == GuideType.ShowTalk then
    local param = {}
    param.time = self.template:GetAutoDoNextTime() / 1000
    if self.template.para2 ~= nil then
      local spl = string.split_ss_array(self.template.para2, ",")
      if 3 < #spl then
        local spl2 = string.split_ss_array(spl[1], ";")
        local spl2Count = table.count(spl2)
        if 1 < spl2Count then
          local list = {}
          for i = 2, spl2Count do
            local dialogType = tonumber(spl2[i])
            if dialogType == GuideTalkDialogType.AllianceName then
              local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
              if allianceData ~= nil then
                table.insert(list, allianceData.allianceName)
              end
            end
          end
          param.dialog = Localization:GetString(spl2[1], table.unpack(list))
        else
          param.dialog = Localization:GetString(spl[1])
        end
        param.modelName = spl[2]
        param.modelAction = spl[3]
        param.modelPosition = tonumber(spl[4])
      end
    end
    local list = string.split_ss_array(self.template.para4, ";")
    if list ~= nil then
      param.cellParam = {}
      for k, v in ipairs(list) do
        local spl = string.split_ss_array(v, ",")
        if spl ~= nil and 1 < table.count(spl) then
          local param1 = {}
          param1.des = Localization:GetString(spl[1])
          param1.nextId = tonumber(spl[2])
          table.insert(param.cellParam, param1)
        end
      end
    end
    if self.template.para3 ~= nil or self.template.para3 ~= "" then
      param.canCloseTime = tonumber(self.template.para3) / 1000
    end
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideTalk) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideTalk, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide,
        playEffect = false
      }, param)
    else
      EventManager:GetInstance():Broadcast(EventId.RefreshGuideAnim, param)
    end
  elseif self:IsGuideArrowType() then
    local param = {}
    param.guideType = self.template.type
    param.obj = self.obj
    param.objPositionType = self.objPositionType
    param.objWorldPos = self.objWorldPos
    param.forceType = self.template.forcetype
    param.arrowType = self.template.arrowtype
    param.showCircleType = self.template.showcircletype
    param.arrowDirection = self.template.arrowdirection
    param.animSpeed = self.template.para5 == "" and 1 or tonumber(self.template.para5)
    param.useGuide = true
    if self.template.type == GuideType.ClickBuildFinishBox or self.template.type == GuideType.ClickBuild then
      if self.template.para1 ~= nil and self.template.para1 ~= "" then
        local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(tonumber(self.template.para1))
        if template ~= nil then
          param.buildTile = template.tileX
        end
      end
    elseif self.template.type == GuideType.ClickQuickBuildBtn then
      param.noAddClick = true
    end
    if self.template.para3 ~= nil and self.template.para3 ~= "" then
      local spl = string.split_ff_array(self.template.para3, ",")
      if 2 <= #spl then
        param.fingerOffset = Vector3.New(spl[1], spl[2], 0)
      end
    end
    param.moveCamera = self.template.type == GuideType.ClickBuildFinishBox
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideArrow) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideArrow, {anim = false, playEffect = false}, param)
    else
      EventManager:GetInstance():Broadcast(EventId.RefreshGuideAnim, param)
    end
  elseif self.template.type == GuideType.BuildRoad or self.template.type == GuideType.PlantFarm or self.template.type == GuideType.GetFarm or self.template.type == GuideType.PlantAnimal or self.template.type == GuideType.Factory or self.template.type == GuideType.DragCityTroop then
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideMoveArrow) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideMoveArrow, {anim = false, playEffect = false}, self.needParam)
    else
      EventManager:GetInstance():Broadcast(EventId.RefreshGuideAnim, self.needParam)
    end
  elseif self.template.type == GuideType.PlayMovie then
    if self.template.para5 ~= nil and self.template.para5 ~= "" then
      local param = {}
      param.gotoGuideId = tonumber(self.template.para5)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITimelineJump, {anim = false, playEffect = false}, param)
    end
    if self.template.para1 ~= nil then
      local movieType = tonumber(self.template.para1)
      if movieType == GuidePlayMovieType.Farm then
        DataCenter.GuideCityManager:PlayTimeline()
      elseif movieType == GuidePlayMovieType.Radar then
        self:DoNext()
      elseif movieType == GuidePlayMovieType.Wind then
        self:DoNext()
      elseif movieType == GuidePlayMovieType.SavePeople then
        CS.SceneManager.World:SetTouchInputControllerEnable(false)
        if self.template.para2 ~= nil then
          local spl = string.split_ss_array(self.template.para2, ",")
          if 1 < table.count(spl) then
            local vec = {}
            vec.x = DataCenter.BuildManager.main_city_pos.x + tonumber(spl[1])
            vec.y = DataCenter.BuildManager.main_city_pos.y + tonumber(spl[2])
            local pointId = SceneUtils.TilePosToIndex(vec)
            DataCenter.GuideCityAnimManager:LoadSavePeopleScene(pointId)
          end
        end
      elseif movieType == GuidePlayMovieType.FightGetPeople then
        self:DoNext()
        EventManager:GetInstance():Broadcast(EventId.CameraFollowCityTroop, false)
      elseif movieType == GuidePlayMovieType.GameStartRocketFall then
        DataCenter.GuideCityAnimManager:LoadScene()
        EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, false)
      elseif movieType == GuidePlayMovieType.ShowSandMonster then
        self:DoNext()
        EventManager:GetInstance():Broadcast(EventId.CameraFollowCityTroop, false)
      elseif movieType == GuidePlayMovieType.BaseZeroUpgrade then
        self:SetCanShowBuild(false)
        if self.template.para2 ~= nil then
          local spl = string.split_ss_array(self.template.para2, ",")
          if 1 < table.count(spl) then
            local vec = {}
            vec.x = DataCenter.BuildManager.main_city_pos.x + tonumber(spl[1])
            vec.y = DataCenter.BuildManager.main_city_pos.y + tonumber(spl[2])
            DataCenter.BuildZeroUpgradeEffectManager:ShowShowEffect(SceneUtils.TileToWorld(vec))
          end
        end
      elseif movieType == GuidePlayMovieType.ShowOstrichAnim then
        if self.template.para3 ~= nil then
          local getUuid = 0
          local list = DataCenter.QueueDataManager:GetAllQueueByType(NewQueueType.OstrichBarn)
          if list ~= nil then
            table.walksort(list, function(leftKey, rightKey)
              return list[leftKey].qid < list[rightKey].qid
            end, function(k, v)
              if v:GetParaState() == QueueProductState.DEFAULT and v:GetQueueState() == NewQueueState.Free and getUuid == 0 then
                getUuid = v.uuid
              end
            end)
          end
          if getUuid ~= 0 then
            DataCenter.GuideCityAnimManager:LoadShowOstrichScene(getUuid, tonumber(self.template.para3))
          end
        end
      elseif movieType == GuidePlayMovieType.MoveToWorld then
        if CS.SceneManager:IsInCity() then
          GoToUtil.CloseAllWindows()
          if 0 > LuaEntry.Player:GetMainWorldPos() then
            SFSNetwork.SendMessage(MsgDefines.MoveCityToWorld)
          end
          self:DoNext()
        else
          self:DoNext()
        end
      elseif movieType == GuidePlayMovieType.ShowGarbage then
        DataCenter.AirDropGarbageManager:LoadShowGarbageScene()
      elseif movieType == GuidePlayMovieType.FarmWithoutTimeLine then
        local sfsParam = {}
        sfsParam.queueList = {}
        local list = DataCenter.QueueDataManager:GetAllQueueByType(NewQueueType.Field)
        for k, v in pairs(list) do
          table.insert(sfsParam.queueList, k)
        end
        SFSNetwork.SendMessage(MsgDefines.FreeSpeedQueue, sfsParam)
        self:DoNext()
      elseif movieType == GuidePlayMovieType.BusinessPlaneArrive then
        DataCenter.GuideCityAnimManager:LoadBusinessPlaneArriveScene()
      elseif movieType == GuidePlayMovieType.ShowBusinessBubble then
        DataCenter.ResidentOrderDataManager:CheckRefreshOrder()
        DataCenter.GuideManager:SendSaveGuideMessage(SaveNoShowBusinessBubble, "")
        DataCenter.ResidentOrderDataManager:DoWhenBubbleGuideFinish()
        DataCenter.GuideManager:DoNext()
      elseif movieType == GuidePlayMovieType.ShowMigrateScene then
        local hideLockLandList
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          hideLockLandList = string.split_ii_array(self.template.para2, ",")
        end
        DataCenter.GuideCityAnimManager:LoadMigrateScene(hideLockLandList)
      elseif movieType == GuidePlayMovieType.ShowRobotScene then
        DataCenter.GuideCityAnimManager:LoadShowRobotScene()
      elseif movieType == GuidePlayMovieType.ShowBaseLight then
        if not CitySpaceMan:GetInstance():IsNeedCreate() then
          CitySpaceMan:GetInstance():Destroy()
        end
        DataCenter.GuideManager:DoNext()
      elseif movieType == GuidePlayMovieType.ShowChangeFarm then
        DataCenter.GuideManager:DoNext()
      elseif movieType == GuidePlayMovieType.FromMjBuildMainBuild then
        DataCenter.GuideCityAnimManager:LoadFromMjBuildMainBuildScene()
      elseif movieType == GuidePlayMovieType.MainZeroUpgradeScene then
        if DataCenter.BuildManager.MainLv == 0 then
          CS.BuildMainCityMessage.Instance:Send()
        end
        DataCenter.GuideCityAnimManager:LoadMainZeroUpgradeScene()
      elseif movieType == GuidePlayMovieType.SecondMigrateScene then
        local hideLockLandList
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          hideLockLandList = string.split_ii_array(self.template.para2, ",")
        end
        DataCenter.GuideCityAnimManager:LoadSecondMigrateScene(hideLockLandList)
      elseif movieType == GuidePlayMovieType.TilePlaneRuin then
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          DataCenter.GuideCityAnimManager:LoadTilePlaneRuin(tonumber(self.template.para2))
        end
      elseif movieType == GuidePlayMovieType.SaveBobScene then
        local pos
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          local spl = string.split_ii_array(self.template.para2, ",")
          if 1 < table.count(spl) then
            local vec = {}
            vec.x = spl[1]
            vec.y = spl[2]
            pos = SceneUtils.TileToWorld(vec)
          end
        end
        if pos ~= nil and self.template.para3 ~= nil and self.template.para3 ~= "" then
          DataCenter.BattleLevel:LoadSaveBobScene(pos, tonumber(self.template.para3))
        else
          DataCenter.GuideManager:DoNext()
        end
      elseif movieType == GuidePlayMovieType.PirateFightBobScene then
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          DataCenter.GuideCityAnimManager:LoadPirateFightBobScene(tonumber(self.template.para2))
        end
      elseif movieType == GuidePlayMovieType.PirateComeScene then
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          DataCenter.GuideCityAnimManager:LoadPirateComeScene(tonumber(self.template.para2))
        end
      elseif movieType == GuidePlayMovieType.PirateAwayScene then
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          DataCenter.GuideCityAnimManager:LoadPirateAwayScene(tonumber(self.template.para2))
        end
      elseif movieType == GuidePlayMovieType.PirateShowScene then
        DataCenter.BattleLevel:LoadPirateShowScene()
      elseif movieType == GuidePlayMovieType.RadarScanScene then
        DataCenter.GuideCityAnimManager:LoadRadarScanScene()
      elseif movieType == GuidePlayMovieType.ShowFakePlayerFlag then
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          local showFakePlayerFlagType = tonumber(self.template.para2)
          if showFakePlayerFlagType == ShowFakePlayerFlagType.Show then
            local pos = SceneUtils.TileIndexToWorld(LuaEntry.Player:GetMainWorldPos())
            DataCenter.GuideCityAnimManager:LoadShowFakePlayerFlagScene(pos)
          else
            DataCenter.GuideCityAnimManager:RemoveShowFakePlayerFlagScene()
          end
        end
      elseif movieType == GuidePlayMovieType.ShowRadarBubble then
        self:SendSaveGuideMessage(GuideNoShowRadarBubble, "")
        EventManager:GetInstance():Broadcast(EventId.DetectInfoChange)
        self:DoNext()
      elseif movieType == GuidePlayMovieType.ShowWorldCollectPoint then
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          local showType = tonumber(self.template.para2)
          if showType == ShowWorldCollectPointType.Show then
            self:SendSaveGuideMessage(GuideNoShowCollectPoint, "")
            local list = CS.SceneManager.World:GetGarbagePoint()
            if list ~= nil and 0 < list.Count then
              for i = 0, list.Count - 1 do
                CS.SceneManager.World:ShowObject(list[i])
              end
            end
          elseif showType == ShowWorldCollectPointType.Hide then
            self:SendSaveGuideMessage(GuideNoShowCollectPoint, SaveGuideDoneValue)
            local list = CS.SceneManager.World:GetGarbagePoint()
            if list ~= nil and 0 < list.Count then
              for i = 0, list.Count - 1 do
                CS.SceneManager.World:HideObject(list[i])
              end
            end
          end
        end
        self:DoNext()
      elseif movieType == GuidePlayMovieType.RadarWorldScanScene then
        DataCenter.GuideCityAnimManager:LoadRadarWorldScanScene()
        DataCenter.GuideManager:DoNext()
      elseif movieType == GuidePlayMovieType.PickUpWeaponScene then
        self:SendSaveGuideMessage(PrologueNoAttack, "")
        DataCenter.GuideCityAnimManager:LoadPickUpWeaponScene()
      elseif movieType == GuidePlayMovieType.TankScene then
        local param = {}
        local showType = tonumber(self.template.para2)
        if showType == TankShowType.Show then
          param.nextType = GuideNpcDoNextType.WaitWalk
          param.follow = true
          if self.template.para3 ~= nil and self.template.para3 ~= "" then
            param.posArr = {}
            local spl1 = string.split_ss_array(self.template.para3, ";")
            for k, v in ipairs(spl1) do
              local spl2 = string.split_ii_array(v, ",")
              if 1 < table.count(spl2) then
                local vec = {}
                vec.x = DataCenter.BuildManager.main_city_pos.x + spl2[1]
                vec.y = DataCenter.BuildManager.main_city_pos.y + spl2[2]
                table.insert(param.posArr, vec)
              end
            end
          end
          if self.template.para4 ~= nil and self.template.para4 ~= "" then
            param.angle = tonumber(self.template.para4)
          end
          if self.template.para5 ~= nil and self.template.para5 ~= "" then
            param.showEffect = true
          end
          if param.posArr ~= nil then
            local count = table.count(param.posArr)
            param.saveParam = param.posArr[count].x .. "," .. param.posArr[count].y
            if param.angle ~= nil then
              param.saveParam = param.saveParam .. "," .. param.angle
            end
          end
        elseif showType == TankShowType.Back then
          param.nextType = GuideNpcDoNextType.WaitWalkDelete
          param.posArr = {}
          local startPos
          local model = DataCenter.GuideNeedLoadManager:GetModel(GuideAnimObjectType.ShowTankScene)
          if model ~= nil then
            startPos = SceneUtils.WorldToTile(model:GetPosition())
            table.insert(param.posArr, startPos)
          end
          local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_TRAINFIELD_1)
          if buildData ~= nil and startPos ~= nil then
            local endPos = SceneUtils.WorldToTile(buildData:GetCenterVec())
            table.insert(param.posArr, endPos)
          end
        end
        if 0 < table.count(param.posArr) then
          DataCenter.GuideNeedLoadManager:LoadTankScene(param)
        end
        if param.nextType == GuideNpcDoNextType.Auto or param.nextType == GuideNpcDoNextType.WaitWalkDelete then
          self:DoNext()
        end
      elseif movieType == GuidePlayMovieType.FactoryShowFreeBtn then
        self:DoNext()
      elseif movieType == GuidePlayMovieType.PvePirateBoomScene then
        DataCenter.BattleLevel.timelineMgr:LoadPvePirateBoomScene()
        self:DoNext()
      elseif movieType == GuidePlayMovieType.ShowRadarMonsterScene then
        local info = DataCenter.RadarCenterDataManager:GetOneInfoByEventTypeAndState(tonumber(self.template.para2), tonumber(self.template.para3))
        if info ~= nil then
          DataCenter.GuideCityAnimManager:LoadShowRadarMonsterScene(info)
        end
        DataCenter.GuideManager:DoNext()
      elseif movieType == GuidePlayMovieType.PveThreeBombs then
        DataCenter.BattleLevel.timelineMgr:LoadPveThreeBombsScene()
        self:DoNext()
      elseif movieType == GuidePlayMovieType.PveDestroyHdc1 then
        DataCenter.BattleLevel.timelineMgr:LoadPveDestroyHdc1Scene()
        self:DoNext()
      elseif movieType == GuidePlayMovieType.PveDestroyHdc2 then
        DataCenter.BattleLevel.timelineMgr:LoadPveDestroyHdc2Scene()
        self:DoNext()
      elseif movieType == GuidePlayMovieType.PveDestroyHdc3 then
        DataCenter.BattleLevel.timelineMgr:LoadPveDestroyHdc3Scene()
        self:DoNext()
      elseif movieType == GuidePlayMovieType.PveMissileAttackMain then
        DataCenter.BattleLevel.timelineMgr:LoadPveMissileAttackMainScene()
        self:DoNext()
      elseif movieType == GuidePlayMovieType.PveHdc1Attack then
        DataCenter.BattleLevel.timelineMgr:LoadPveHdc1AttackScene()
        self:DoNext()
      elseif movieType == GuidePlayMovieType.PveHdc2Attack then
        DataCenter.BattleLevel.timelineMgr:LoadPveHdc2AttackScene()
        self:DoNext()
      elseif movieType == GuidePlayMovieType.PveTurretTurn then
        DataCenter.BattleLevel.timelineMgr:LoadPveTurretTurnScene()
        self:DoNext()
      elseif movieType == GuidePlayMovieType.PveDestroyMountain then
        DataCenter.BattleLevel.timelineMgr:LoadPveDestroyMountainScene()
        self:DoNext()
      elseif movieType == GuidePlayMovieType.PveHdc3Attack then
        DataCenter.BattleLevel.timelineMgr:LoadPveHdc3AttackScene()
        self:DoNext()
      elseif movieType == GuidePlayMovieType.PveMissileInSky then
        if tonumber(self.template.para3) == 1 then
          DataCenter.BattleLevel.timelineMgr:LoadPveMissileInSkyScene(self.template.para2)
        else
          DataCenter.BattleLevel.timelineMgr:DestroyOneScene(GuideAnimObjectType.PveMissileInSky)
        end
        self:DoNext()
      elseif movieType == GuidePlayMovieType.GuluOutFromBaseScene then
        local param = {}
        if self.template.para3 ~= nil and self.template.para3 ~= "" then
          local spl = string.split_ff_array(self.template.para3, ",")
          if 1 < table.count(spl) then
            param.pos = SceneUtils.TileToWorld({
              x = DataCenter.BuildManager.main_city_pos.x + spl[1],
              y = DataCenter.BuildManager.main_city_pos.y + spl[2]
            })
          end
        end
        DataCenter.GuideCityAnimManager:LoadGuluOutFromBaseScene(param)
        self:DoNext()
      elseif movieType == GuidePlayMovieType.GuideTimeline2Scene then
        local pos
        if self.template.para3 ~= nil and self.template.para3 ~= "" then
          local spl = string.split_ff_array(self.template.para3, ",")
          if 1 < table.count(spl) then
            local vec = {}
            vec.x = spl[1]
            vec.y = spl[2]
            pos = SceneUtils.TileToWorld(vec)
          end
        end
        local hideTriggerList
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          hideTriggerList = string.split_ii_array(self.template.para2, ";")
        end
        DataCenter.BattleLevel.timelineMgr:LoadGuideTimeline2Scene(pos, hideTriggerList)
        self:DoNext()
      elseif movieType == GuidePlayMovieType.PveMorganAttack then
        DataCenter.BattleLevel.timelineMgr:LoadPveMorganAttackScene()
        self:DoNext()
      elseif movieType == GuidePlayMovieType.PveHdcEscape then
        DataCenter.BattleLevel.timelineMgr:LoadPveHdcEscapeScene()
        self:DoNext()
      elseif movieType == GuidePlayMovieType.DefendWallScene then
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          local visible = tonumber(self.template.para2)
          if visible == GuideSetNormalVisible.Show then
            local param = {}
            param.pos = SceneUtils.TileToWorld({
              x = DataCenter.BuildManager.main_city_pos.x,
              y = DataCenter.BuildManager.main_city_pos.y
            })
            DataCenter.GuideCityAnimManager:LoadDefendWallScene(param)
          elseif visible == GuideSetNormalVisible.Hide then
            DataCenter.GuideCityAnimManager:RemoveDefendWallScene()
          end
        end
        self:DoNext()
      elseif movieType == GuidePlayMovieType.ShowEnemyAllianceCityEffect then
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          local visible = tonumber(self.template.para2)
          if visible == GuideSetNormalVisible.Show then
            if CS.SceneManager.World.GetMainByScreen ~= nil then
              TimerManager:GetInstance():DelayInvoke(function()
                local list = CS.SceneManager.World:GetMainByScreen()
                local id = DataCenter.AllianceCompeteDataManager:GetFightAllianceId()
                if id == "" then
                  id = 0
                end
                local showList = {}
                if 0 < list.Count then
                  for i = 0, list.Count - 1 do
                    if list[i].allianceId == id then
                      local param = {}
                      param.pointId = list[i].pointIndex
                      table.insert(showList, param)
                    end
                  end
                  if next(showList) then
                    local enemy = true
                    DataCenter.GuideAllianceMemberEffectManager:ShowAllianceMemberEffect(showList, nil, enemy)
                  end
                else
                  self:DoNext()
                end
              end, 1)
            end
          elseif visible == GuideSetNormalVisible.Hide then
            DataCenter.GuideAllianceMemberEffectManager:RemoveAll()
          end
        end
        self:DoNext()
      elseif movieType == GuidePlayMovieType.GuideTimeline3Scene then
        local pos
        if self.template.para3 ~= nil and self.template.para3 ~= "" then
          local spl = string.split_ff_array(self.template.para3, ",")
          if table.count(spl) > 1 then
            local vec = {}
            vec.x = spl[1]
            vec.y = spl[2]
            pos = SceneUtils.TileToWorld(vec)
          end
        end
        DataCenter.BattleLevel.timelineMgr:LoadGuideTimeline3Scene(pos)
        self:DoNext()
      elseif movieType == GuidePlayMovieType.PveHdcEscape31014 then
        DataCenter.BattleLevel.timelineMgr:LoadPveHdcEscape31014Scene()
        self:DoNext()
      elseif movieType == GuidePlayMovieType.ConnectElectricityScene then
        DataCenter.GuideCityAnimManager:LoadConnectElectricityScene()
        self:DoNext()
      elseif movieType == GuidePlayMovieType.Chapter2CameraMoveScene then
        DataCenter.GuideCityAnimManager:LoadChapter2CameraMoveScene()
        self:DoNext()
      end
    end
  elseif self.template.type == GuideType.WaitMovieComplete then
    DataCenter.GuideCityManager:SetTimeLineContinuePlay()
    DataCenter.GuideCityAnimManager:SetTimeLineContinuePlay(true)
  elseif self.template.type == GuideType.CityGarbageResultShow then
    if self.template.para1 ~= nil then
      local showType = tonumber(self.template.para1)
      if showType == CityGarbageResultShowType.People and not self:IsDoneThisGuide(self.template.id) then
        self:SaveCityTroopPeopleNum(self:GetCityTroopPeopleNum() + 1)
        EventManager:GetInstance():Broadcast(EventId.RefreshCityTroopPeopleNum)
      end
      if showType == CityGarbageResultShowType.NoUseItem then
        self:DoNext()
      else
        self:DoNext()
      end
    end
  elseif self.template.type == GuideType.WaitMessageFinish then
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      local waitType = tonumber(self.template.para1)
      if self.waitingMessage[waitType] then
        self:AddWaitLongDelayTimer(WaitMessageLongTime)
      else
        self:DoNext()
      end
    end
  elseif self.template.type == GuideType.ShowBlackUI then
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIShowBlack) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIShowBlack, {anim = true, playEffect = false})
    else
      EventManager:GetInstance():Broadcast(EventId.RefreshGuideAnim)
    end
  elseif self.template.type == GuideType.MoveCamera then
    local isInBattle = DataCenter.BattleLevel:IsInBattleLevel()
    if isInBattle then
      DataCenter.BattleLevel:SetFollowNpc()
    else
      DataCenter.CityNpcManager:SetFollowNpc()
    end
    local pos
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      local moveType = tonumber(self.template.para1)
      if moveType == GuideMoveCameraType.Point then
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          local spl = string.split_ii_array(self.template.para2, ",")
          if table.count(spl) > 1 then
            local vec = {}
            if isInBattle then
              vec.x = spl[1]
              vec.y = spl[2]
            else
              vec.x = DataCenter.BuildManager.main_city_pos.x + spl[1]
              vec.y = DataCenter.BuildManager.main_city_pos.y + spl[2]
            end
            pos = SceneUtils.TileToWorld(vec)
          end
        end
      elseif moveType == GuideMoveCameraType.Build then
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          local buildData = DataCenter.BuildManager:GetFunbuildByItemID(tonumber(self.template.para2))
          if buildData ~= nil then
            pos = buildData:GetCenterVec()
          end
        end
      elseif moveType == GuideMoveCameraType.CityTroop then
        local cityTroop = CS.SceneManager.World:GetCityTroop()
        if cityTroop ~= nil then
          pos = cityTroop.transform.position
        end
      elseif moveType == GuideMoveCameraType.AllianceChief then
        if LuaEntry.Player:IsInAlliance() then
          local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
          if baseData ~= nil and baseData.leaderUid and not baseData:CheckIfIsVirtualLeader() then
            local leaderData = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(baseData.leaderUid)
            if leaderData ~= nil and leaderData.pointId ~= 0 then
              pos = SceneUtils.TileIndexToWorld(leaderData.pointId)
            end
          end
        end
        if pos == nil or pos.x == 0 and pos.y == 0 and pos.z == 0 then
          local temp = self:GetSaveGuideValue(AllianceBornPoint)
          if temp ~= nil then
            pos = SceneUtils.TileIndexToWorld(tonumber(temp))
          end
        end
      elseif moveType == GuideMoveCameraType.AllianceMember then
        if LuaEntry.Player:IsInAlliance() then
          local member = DataCenter.AllianceMemberDataManager:GetNearMember()
          if member ~= nil then
            pos = SceneUtils.TileIndexToWorld(member.pointId)
          end
        end
        if pos == nil or pos.x == 0 and pos.y == 0 and pos.z == 0 then
          local temp = self:GetSaveGuideValue(AllianceBornPoint)
          if temp ~= nil then
            pos = SceneUtils.TileIndexToWorld(tonumber(temp))
          end
        end
      elseif moveType == GuideMoveCameraType.NewbieSpaceMan then
        if isInBattle then
          pos = DataCenter.BattleLevel:GetPosition()
        else
          pos = CitySpaceMan:GetInstance():GetPosition()
        end
      elseif moveType == GuideMoveCameraType.Npc then
        if isInBattle then
          pos = DataCenter.BattleLevel:GetNpcPositionByName(self.template.para2)
        else
          pos = DataCenter.CityNpcManager:GetNpcPositionByName(self.template.para2)
        end
      elseif moveType == GuideMoveCameraType.FollowNpc then
        if isInBattle then
          DataCenter.BattleLevel:SetFollowNpc(self.template.para2)
        else
          DataCenter.CityNpcManager:SetFollowNpc(self.template.para2)
        end
      elseif moveType == GuideMoveCameraType.CollectResource then
        if tonumber(self.template.para2) >= ResourceType.ResourceItem then
          SFSNetwork.SendMessage(MsgDefines.FindResourcePoint, ResourceType.ResourceItem, 0, self.template.para2)
        else
          SFSNetwork.SendMessage(MsgDefines.FindResourcePoint, tonumber(self.template.para2), 0)
        end
      elseif moveType == GuideMoveCameraType.Garbage then
        local list = CS.SceneManager.World:GetGarbagePoint()
        if list ~= nil and list.Count > 0 then
          for i = 0, list.Count - 1 do
            local pointId = list[i]
            local obj = CS.SceneManager.World:GetObjectByPoint(pointId)
            if obj ~= nil then
              pos = SceneUtils.TileIndexToWorld(pointId)
              break
            end
          end
        end
      elseif moveType == GuideMoveCameraType.MonsterReward then
        local list
        if CS.SceneManager:IsInCity() then
          list = DataCenter.CityPointDataManager:GetPointDataListByType(CityPointType.MonsterReward)
        else
          list = DataCenter.CollectRewardDataManager:GetRewardListBySort()
        end
        if list ~= nil or table.count(list) > 0 then
          local curTime = UITimeManager:GetInstance():GetServerTime()
          for k, v in ipairs(list) do
            if curTime <= v.expireTime then
              pos = SceneUtils.TileIndexToWorld(v.pointId)
              break
            end
          end
        end
      elseif moveType == GuideMoveCameraType.RadarMonster then
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          local spl = string.split_ii_array(self.template.para2, ";")
          if table.count(spl) > 1 then
            local info = DataCenter.RadarCenterDataManager:GetOneInfoByEventTypeAndState(spl[1], spl[2])
            if info ~= nil then
              pos = SceneUtils.TileIndexToWorld(info.pointId)
            end
          end
        end
      elseif moveType == GuideMoveCameraType.WorldCity then
        pos = SceneUtils.TileIndexToWorld(LuaEntry.Player:GetMainWorldPos())
      elseif moveType == GuideMoveCameraType.LandLock and self.template.para2 ~= nil and self.template.para2 ~= "" then
        local landLockId = tonumber(self.template.para2)
        local info = DataCenter.LandLockManager:GetLandLockDataById(landLockId)
        if info ~= nil then
          pos = info:GetCenterWorldPos()
        end
      end
    end
    local time = LookAtFocusTime
    if self.template.para4 ~= nil and self.template.para4 ~= "" then
      time = tonumber(self.template.para4) / 1000
    end
    if isInBattle then
      local zoom = DataCenter.BattleLevel:GetCameraZoom()
      if self.template.para3 ~= nil and self.template.para3 ~= "" then
        zoom = tonumber(self.template.para3)
        if DataCenter.CityPioneerManager:IsBeforePrologue() then
          CS.GameEntry.Setting:SetPrivateFloat(SettingKeys.DigCameraHeightSnap, zoom)
        end
        DataCenter.BattleLevel:SetGuideMaxHeight(zoom)
      end
      local nowPos = DataCenter.BattleLevel:GetCameraTarget()
      if zoom ~= nil then
        if pos == nil or pos.x == nowPos.x and pos.z == nowPos.z then
          DataCenter.BattleLevel:AutoZoom(zoom, time)
        else
          DataCenter.BattleLevel:AutoLookat(pos, zoom, time)
        end
      end
    else
      local zoom = CS.SceneManager.World.Zoom
      if self.template.para3 ~= nil and self.template.para3 ~= "" then
        zoom = tonumber(self.template.para3)
        if DataCenter.CityPioneerManager:IsBeforePrologue() then
          CS.GameEntry.Setting:SetPrivateFloat(SettingKeys.DigCameraHeightSnap, zoom)
        end
        CS.SceneManager.World:SetCameraMaxHeight(zoom)
      end
      local nowPos = CS.SceneManager.World.CurTarget
      if pos == nil or pos.x == nowPos.x and pos.z == nowPos.z then
        CS.SceneManager.World:AutoZoom(zoom, time)
      else
        GoToUtil.GotoPos(pos, zoom, time)
      end
    end
    local showUIMainType = GuideCameraShowUIMainType.None
    if self.template.para5 ~= nil and self.template.para5 ~= "" and not isInBattle then
      showUIMainType = tonumber(self.template.para5)
    end
    TimerManager:GetInstance():DelayInvoke(function()
      if self.template ~= nil and self.template.type == GuideType.MoveCamera then
        if showUIMainType == GuideCameraShowUIMainType.Hide then
          EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, false)
        elseif showUIMainType == GuideCameraShowUIMainType.Show then
          EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
        end
        self:DoNext()
      end
    end, time + GuideMovieCameraTimeDelta)
  elseif self.template.type == GuideType.CloseAllUI then
    GoToUtil.CloseAllWindows()
    if not DataCenter.BattleLevel:IsInBattleLevel() then
      EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
    end
    self:DoNext()
  elseif self.template.type == GuideType.ShowUIGuideGrow then
  elseif self.template.type == GuideType.SetRecommendShow then
    local showType = 0
    local showPara = 0
    local buildId = 0
    local buildUuid = 0
    local guideId = 0
    local showHeadPara = {}
    local focusPos
    local waitAnimType = UIGuideMoveArrowNeedWaitType.No
    if self.template.para1 ~= nil then
      local spl = string.split_ii_array(self.template.para1, ";")
      local splCount = table.count(spl)
      if splCount > 0 then
        showType = spl[1]
      end
      if splCount > 1 then
        showPara = spl[2]
      end
    end
    if self.template.para2 ~= nil then
      waitAnimType = tonumber(self.template.para2)
    end
    local uuidList = {}
    if self.template.para3 ~= nil then
      local spl = string.split_ss_array(self.template.para3, ";")
      if #spl >= 1 then
        buildId = tonumber(spl[1])
        if spl[2] ~= nil and spl[2] ~= "" then
          local spl2 = string.split_ss_array(spl[2], "|")
          for k, v in ipairs(spl2) do
            local spl1 = string.split_ss_array(v, ",")
            if table.count(spl1) > 1 then
              local vec = {}
              vec.x = DataCenter.BuildManager.main_city_pos.x + tonumber(spl1[1])
              vec.y = DataCenter.BuildManager.main_city_pos.y + tonumber(spl1[2])
              local pointId = SceneUtils.TilePosToIndex(vec)
              local buildData = DataCenter.BuildManager:GetBuildingDataByPointId(pointId)
              if buildData ~= nil and buildData.itemId == buildId then
                if buildUuid == 0 then
                  buildUuid = buildData.uuid
                end
                if (showType == RecommendShowType.FarmPlant or showType == RecommendShowType.FarmGet) and k == 2 then
                  focusPos = SceneUtils.TileToWorld(vec)
                end
                table.insert(uuidList, buildData.uuid)
              end
            end
          end
        end
      end
    end
    if buildUuid == 0 and buildId ~= 0 then
      local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
      if list ~= nil and table.count(list) > 0 then
        buildUuid = list[1].uuid
        table.insert(uuidList, buildUuid)
      end
    end
    if self.template.para4 ~= nil then
      guideId = tonumber(self.template.para4)
    end
    if self.template.para5 ~= nil and self.template.para5 ~= "" then
      local spl = string.split_ss_array(self.template.para5, "|")
      for k, v in ipairs(spl) do
        local spl1 = string.split_ss_array(v, ",")
        if 4 <= table.count(spl1) then
          local temp = {}
          temp.dialog = spl1[2]
          temp.modelName = spl1[3]
          temp.modelPosition = tonumber(spl1[4])
          showHeadPara[tonumber(spl1[1])] = temp
        end
      end
    end
    DataCenter.RecommendShowManager:AddOneParam(showType, showPara, buildId, buildUuid, guideId, uuidList, showHeadPara, focusPos, self.template.arrowtype, false, waitAnimType)
    self:DoNext()
  elseif self.template.type == GuideType.UnlockBtn then
    if not string.IsNullOrEmpty(self.template.para1) then
      local unlockType = tonumber(self.template.para1)
      if not string.IsNullOrEmpty(self.template.para2) then
        local spl = string.split_ss_array(self.template.para2, ",")
        local title = #spl >= 1 and Localization:GetString(spl[1]) or ""
        local intro = 2 <= #spl and Localization:GetString(spl[2]) or ""
        DataCenter.UnlockBtnManager:StartUnlockBtn(title, intro, unlockType)
      else
        self:DoNext()
        EventManager:GetInstance():Broadcast(EventId.ShowUnlockBtn, unlockType)
      end
    end
  elseif self.template.type == GuideType.ShowGuideTip then
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideTip) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideTip, {anim = true, playEffect = false})
    else
      EventManager:GetInstance():Broadcast(EventId.RefreshGuideAnim)
    end
  elseif self.template.type == GuideType.PlayEffectSound then
    self:DoNext()
  elseif self.template.type == GuideType.ShowChapterAnim then
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      local list = string.split_ss_array(self.template.para1, ";")
      if 3 < table.count(list) then
        local param = {}
        param.chapterId = tonumber(list[1])
        param.bgName = list[2]
        param.titleDes = Localization:GetString(list[3])
        param.des = Localization:GetString(list[4])
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          param.autoDoNext = tonumber(self.template.para2) / 1000
        end
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIRocketFailedLanding, {anim = true, playEffect = false}, param)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIChapterSwitch, {anim = true, playEffect = false}, tonumber(list[1]))
      end
    else
      self:DoNext()
    end
  elseif self.template.type == GuideType.StopAllEffectSound then
    self:StopAllEffectSound()
    self:DoNext()
  elseif self.template.type == GuideType.DoUIMainAnim then
    if self.template.para1 ~= nil then
      local showUIMainType = tonumber(self.template.para1)
      if DataCenter.BattleLevel:IsInBattleLevel() then
        EventManager:GetInstance():Broadcast(EventId.RefreshUIPveMainVisible, showUIMainType)
      elseif showUIMainType == GuideUIMainShowType.Hide then
        self:SetNoShowUIMain(true)
      elseif showUIMainType == GuideUIMainShowType.Show then
        self:SetNoShowUIMain(false)
      end
    end
    self:DoNext()
  elseif self.template.type == GuideType.PrologueShowNpc then
    local isInBattle = DataCenter.BattleLevel:IsInBattleLevel()
    local nextType = GuideNpcDoNextType.Auto
    if self.template.para3 ~= nil and self.template.para3 ~= "" then
      nextType = tonumber(self.template.para3)
    end
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      local posArr = {}
      local spl1 = string.split_ss_array(self.template.para1, ";")
      for k, v in ipairs(spl1) do
        local spl2 = string.split_ii_array(v, ",")
        if table.count(spl2) > 1 then
          local vec = {}
          if isInBattle then
            vec.x = spl2[1]
            vec.y = spl2[2]
          else
            vec.x = DataCenter.BuildManager.main_city_pos.x + spl2[1]
            vec.y = DataCenter.BuildManager.main_city_pos.y + spl2[2]
          end
          table.insert(posArr, vec)
        end
      end
      if isInBattle then
        local param = {}
        param.modelName = self.template.para2
        param.posArr = posArr
        param.animName = self.template.para4
        param.angle = tonumber(self.template.para5)
        param.nextType = nextType
        DataCenter.BattleLevel:AddOneNpc(param)
      else
        DataCenter.CityNpcManager:AddOneNpc(self.template.para2, posArr, self.template.para4, tonumber(self.template.para5), nextType)
        CityPioneerArchive:GetInstance():Save()
      end
    end
    if nextType == GuideNpcDoNextType.Auto or nextType == GuideNpcDoNextType.WaitWalkDelete then
      self:DoNext()
    end
  elseif self.template.type == GuideType.PrologueHideNpc then
    local isInBattle = DataCenter.BattleLevel:IsInBattleLevel()
    if isInBattle then
      DataCenter.BattleLevel:RemoveOneNpc(self.template.para2)
    else
      DataCenter.CityNpcManager:RemoveOneNpc(self.template.para2)
      CityPioneerArchive:GetInstance():Save()
    end
    self:DoNext()
  elseif self.template.type == GuideType.Wastelan_ShowFarm then
    if not string.IsNullOrEmpty(self.template.para1) then
      WastelandFarmManager:GetInstance():AddFarm(self.template.para1, self.template.para2)
    end
    self:DoNext()
  elseif self.template.type == GuideType.Wasteland_ShowTank then
    WastelandModelMgr:GetInstance():CreateTank(self.template.para1, self.template.para2)
    self:DoNext()
  elseif self.template.type == GuideType.Wasteland_ShowMonster then
    WastelandModelMgr:GetInstance():CreateMonster(self.template.para1, self.template.para2)
    self:DoNext()
  elseif self.template.type == GuideType.Wasteland_AttackDone then
    WastelandModelMgr:GetInstance():AttackFinishCurRound()
    self:DoNext()
  elseif self.template.type == GuideType.PrologueShowBuild then
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      local spl1 = string.split_ss_array(self.template.para1, ",")
      if table.count(spl1) > 1 then
        local vec = {}
        vec.x = DataCenter.BuildManager.main_city_pos.x + tonumber(spl1[1])
        vec.y = DataCenter.BuildManager.main_city_pos.y + tonumber(spl1[2])
        local pointId = SceneUtils.TilePosToIndex(vec)
        local buildname = self.template.para2
        local animation_name = self.template.para4
        local build = DataCenter.CityPrologueBuildManager:AddOneBuild(pointId, buildname, animation_name)
      end
    end
    self:DoNext()
  elseif self.template.type == GuideType.PrologueUnlockFog then
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      local spl1 = string.split_ii_array(self.template.para1, ",")
      CityPioneerFog:GetInstance():UnlockFog(spl1)
    end
    self:DoNext()
  elseif self.template.type == GuideType.PrologueShowTrigger then
    if self.template.para2 ~= nil and self.template.para2 ~= "" then
      local spl1 = string.split_ii_array(self.template.para2, ",")
      for k, v in ipairs(spl1) do
        DataCenter.CityTriggerPointDataManager:AddOneTrigger(v)
      end
    end
    self:DoNext()
  elseif self.template.type == GuideType.PrologueShowNoMovePoint then
    if self.template.para1 ~= nil and self.template.para1 ~= nil then
      local spl = string.split_ss_array(self.template.para1, "|")
      for k, v in ipairs(spl) do
        local spl1 = string.split_ii_array(v, ",")
        if table.count(spl1) > 1 then
          local vec = {}
          vec.x = DataCenter.BuildManager.main_city_pos.x + spl1[1]
          vec.y = DataCenter.BuildManager.main_city_pos.y + spl1[2]
          local pointId = SceneUtils.TilePosToIndex(vec)
          DataCenter.CityNoMovePointManager:AddOnePoint(pointId)
        end
      end
    end
    self:DoNext()
  elseif self.template.type == GuideType.PrologueShowSetManPosition then
    local isInBattle = DataCenter.BattleLevel:IsInBattleLevel()
    if isInBattle then
      if self.template.para1 ~= nil and self.template.para1 ~= "" then
        local posArr = {}
        local spl1 = string.split_ss_array(self.template.para1, ";")
        for k, v in ipairs(spl1) do
          local spl2 = string.split_ff_array(v, ",")
          if table.count(spl2) > 1 then
            table.insert(posArr, SceneUtils.TileToWorld({
              x = spl2[1],
              y = spl2[2]
            }))
          end
        end
        local player = DataCenter.BattleLevel:GetPlayer()
        if player ~= nil and #posArr > 0 then
          player:MoveTo(posArr)
        end
      end
      if self.template.para2 ~= nil and self.template.para2 ~= "" then
        local spl1 = string.split_ff_array(self.template.para2, ",")
        if table.count(spl1) > 1 then
          local vec = {}
          vec.x = spl1[1]
          vec.y = spl1[2]
          local player = DataCenter.BattleLevel:GetPlayer()
          if player ~= nil then
            player:TurnToPos(SceneUtils.TileToWorld(vec))
          end
        end
      end
    elseif self.template.para1 ~= nil and self.template.para1 ~= "" then
      local spl1 = string.split_ii_array(self.template.para1, ",")
      if table.count(spl1) > 1 then
        local vec = {}
        vec.x = DataCenter.BuildManager.main_city_pos.x + spl1[1]
        vec.y = DataCenter.BuildManager.main_city_pos.y + spl1[2]
        CitySpaceMan:GetInstance():SetTilePos(vec)
      end
    end
    local nextType = GuideNpcDoNextType.Auto
    if self.template.para3 ~= nil and self.template.para3 ~= "" then
      nextType = tonumber(self.template.para3)
    end
    if nextType == GuideNpcDoNextType.Auto then
      self:DoNext()
    end
  elseif self.template.type == GuideType.Wastelan_Guide then
    local flag = toInt(self.template.para1)
    if flag == GuidePrologueFlag.End then
      DataCenter.CityPioneerManager:EndDig()
      self:DoNext()
    elseif flag == GuidePrologueFlag.Start then
      self:SendSaveGuideMessage(BeforePrologue, SaveGuideDoneValue)
      DataCenter.CityPioneerManager:RefreshPrologueModel()
      if self.template.para2 ~= "" and self.template.para2 ~= nil then
        self:SendSaveGuideMessage(SaveErrorProloguePara, self.template.para2)
        CityTriggerPointManager:GetInstance():DoTriggerAndSave(tonumber(self.template.para2))
      end
    end
  elseif self.template.type == GuideType.Prologure_CarryingFlag then
    CitySpaceMan:GetInstance():HandFlag()
    self:DoNext()
  elseif self.template.type == GuideType.Prologure_PlantFlag then
    if toInt(self.template.para1) == 0 then
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_PlantFlag, false)
      CitySpaceMan:GetInstance():WaveFlag()
    elseif toInt(self.template.para1) == 1 then
      CitySpaceMan:GetInstance():RemoveAllFlag()
    end
    self:DoNext()
  elseif self.template.type == GuideType.Wastelan_ResetManState then
    CitySpaceMan:GetInstance():SetGameStateToNormal()
    self:DoNext()
  elseif self.template.type == GuideType.ShowAllianceCityEffect then
    local list = DataCenter.AllianceMemberDataManager:GetAllNearMember()
    if list ~= nil and table.count(list) > 0 and self.template.para1 ~= nil then
      DataCenter.GuideAllianceMemberEffectManager:ShowAllianceMemberEffect(list, tonumber(self.template.para1))
    else
      self:DoNext()
    end
  elseif self.template.type == GuideType.Wastelan_ShowNpcTalk then
    local prefabName = self.template.para1
    local dialogId = tonumber(self.template.para2)
    local isInBattle = DataCenter.BattleLevel:IsInBattleLevel()
    if isInBattle then
      DataCenter.BattleLevel:SetNpcDialog(prefabName, dialogId)
    else
      local height = self.template.para5 and tonumber(self.template.para5) or 2
      local bubbleStay = string.split_ss_array(self.template.para4, ";")
      local para4Count = table.count(bubbleStay)
      if para4Count > 0 then
        local stayType = tonumber(bubbleStay[1])
        if stayType == NpcBubbleStayType.Trigger then
          DataCenter.CityNpcManager:ToggleNpcTalkTrigger(prefabName, true, {dialogId = dialogId, height = height})
        elseif stayType == NpcBubbleStayType.All or stayType == NpcBubbleStayType.Time then
          DataCenter.CityNpcManager:ToggleNpcTalkTrigger(prefabName, false)
          local npc = DataCenter.CityNpcManager:GetNpcObjectByName(prefabName)
          if npc ~= nil then
            local talkParam = {}
            talkParam.talkType = NpcTalkType.Right
            talkParam.target = npc.transform
            talkParam.dialogId = dialogId
            talkParam.offset = Vector3.New(0, height, 0)
            if para4Count > 1 then
              talkParam.duration = tonumber(bubbleStay[2]) / 1000
            end
            EventManager:GetInstance():Broadcast(EventId.ShowTalkBubble, talkParam)
          end
        end
      end
    end
    self:DoNext()
  elseif self.template.type == GuideType.Wastelan_HideNpcTalk then
    local prefabName = self.template.para1
    local isInBattle = DataCenter.BattleLevel:IsInBattleLevel()
    if isInBattle then
      DataCenter.BattleLevel:SetNpcDialog(prefabName, nil)
    else
      local npc = DataCenter.CityNpcManager:GetNpcObjectByName(prefabName)
      if npc ~= nil then
        EventManager:GetInstance():Broadcast(EventId.HideTalkBubble, {
          target = npc.transform
        })
      end
      DataCenter.CityNpcManager:ToggleNpcTalkTrigger(prefabName, false)
    end
    self:DoNext()
  elseif self.template.type == GuideType.Wastelan_GuideNpcTalk then
    local prefabName = self.template.para1
    local blockTime = tonumber(self.template.para4)
    local height = self.template.para5 and tonumber(self.template.para5) or 2
    local npc = DataCenter.CityNpcManager:GetNpcObjectByName(prefabName)
    if npc ~= nil then
      local talkParam = {}
      talkParam.talkType = NpcTalkType.Right
      talkParam.target = npc.transform
      talkParam.dialogId = tonumber(self.template.para2)
      talkParam.offset = Vector3.New(0, height, 0)
      talkParam.blockTime = math.max(0.5, blockTime / 1000.0)
      EventManager:GetInstance():Broadcast(EventId.ShowTalkBubble, talkParam)
    end
    self:DoNext()
  elseif self.template.type == GuideType.Wastelan_ShowYellowArrow then
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      local posArr = {}
      local spl = string.split_ss_array(self.template.para1, ";")
      for k, v in ipairs(spl) do
        local height
        local splHeight = string.split_ss_array(v, "#")
        if table.count(splHeight) > 0 then
          height = tonumber(splHeight[2])
        end
        local spl1 = string.split_ii_array(splHeight[1], ",")
        if table.count(spl1) > 1 then
          local vec = {}
          vec.x = DataCenter.BuildManager.main_city_pos.x + spl1[1]
          vec.y = DataCenter.BuildManager.main_city_pos.y + spl1[2]
          local param = {}
          param.pos = SceneUtils.TileToWorld(vec)
          param.height = height
          table.insert(posArr, param)
        end
      end
      local param = table.remove(posArr, 1)
      DataCenter.CityPioneerYellowArrowManager:AddOneArrow(param.pos, param.height, posArr)
    end
    self:DoNext()
  elseif self.template.type == GuideType.Wastelan_CheckFarmArrow then
    WastelandFarmManager:GetInstance():ToggleArrowDetection(true)
    self:DoNext()
  elseif self.template.type == GuideType.ShowUIWindow then
    local windowName = self.template.para4
    if not UIManager:GetInstance():IsWindowOpen(windowName) then
      UIManager:GetInstance():OpenWindow(windowName)
    end
    self:DoNext()
  elseif self.template.type == GuideType.Prologure_ManJump then
    CitySpaceMan:GetInstance():Jump()
    self:DoNext()
  elseif self.template.type == GuideType.WaitTime then
    self:DoNext()
  elseif self.template.type == GuideType.FakeQuest then
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      local spl1 = string.split_ss_array(self.template.para1, ";")
      if table.count(spl1) >= 5 then
        local param = {}
        param.iconName = spl1[1]
        param.npcName = spl1[2]
        param.des = tonumber(spl1[3])
        param.state = tonumber(spl1[4])
        param.nextGuideId = tonumber(spl1[5])
        self.fakeQuest = param
      end
    end
    self:DoNext()
  elseif self.template.type == GuideType.PrologueManRotation then
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      CitySpaceMan:GetInstance():SetRotation(tonumber(self.template.para1))
    end
  elseif self.template.type == GuideType.ShowCommunicationTalk then
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideCommunicationTalk) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideCommunicationTalk, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide,
        playEffect = false
      })
    else
      EventManager:GetInstance():Broadcast(EventId.RefreshGuideAnim)
    end
  elseif self.template.type == GuideType.PrologueAddOneSpaceMan then
    CitySpaceMan:GetInstance():AddOneSpaceMan()
    self:DoNext()
  elseif self.template.type == GuideType.PVEFinishOneTrigger then
    if DataCenter.BattleLevel:IsInBattleLevel() then
      DataCenter.BattleLevel:DoTrigger(DataCenter.BattleLevel:GetTriggerByTriggerId(tonumber(self.template.para1)), true)
    end
    if self.template.type == GuideType.PVEFinishOneTrigger then
      self:DoNext()
    end
  elseif self.template.type == GuideType.SetLandLockBubbleVisible then
    local visible = tonumber(self.template.para1)
    if visible == LandLockBubbleVisibleType.Hide then
      self:SetLandLockBubbleActive(false)
    elseif visible == LandLockBubbleVisibleType.Show then
      self:SetLandLockBubbleActive(true)
    end
    self:DoNext()
  elseif self.template.type == GuideType.PveShowYellowArrow then
    local spl = string.split_ii_array(self.template.para1, ",")
    if table.count(spl) > 1 and DataCenter.BattleLevel:IsInBattleLevel() then
      local vec = {}
      vec.x = spl[1]
      vec.y = spl[2]
      local height
      local vec3 = SceneUtils.TileToWorld(vec)
      if self.template.para3 ~= nil and self.template.para3 ~= "" then
        local spl2 = string.split_ff_array(self.template.para3, ",")
        if 3 <= table.count(spl2) then
          vec3 = Vector3.New(spl2[1], spl2[2], spl2[3])
        end
      end
      if self.template.para2 ~= nil and self.template.para2 ~= "" then
        height = tonumber(self.template.para2)
        vec3.y = height
      end
      DataCenter.BattleLevel:AddOneArrow(SceneUtils.TileToWorld(vec), height, vec3)
    end
    self:DoNext()
  elseif self.template.type == GuideType.ShowUIBlackChangeMask then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBlackChangeMask, {anim = false, playEffect = false})
  elseif self.template.type == GuideType.PveShowBattleBloodLight then
    if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIPVEScene) then
      local luaWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIPVEScene)
      if luaWindow ~= nil and luaWindow.View ~= nil then
        luaWindow.View:ShowGrayMask(self.template.para1)
      end
    else
      self:DoNext()
    end
  elseif self.template.type == GuideType.PveHideYellowArrow then
    if DataCenter.BattleLevel:IsInBattleLevel() then
      DataCenter.BattleLevel:RemoveAllArrow()
    else
      DataCenter.CityPioneerYellowArrowManager:RemoveAll()
    end
    self:DoNext()
  elseif self.template.type == GuideType.WaitMarchFightEnd then
    local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
    if table.csCount(selfMarch) > 0 then
      local march = table.getFirst(selfMarch)
      local marchUuid = march.uuid
      CS.SceneManager.World:TrackMarch(marchUuid)
    end
  elseif self.template.type == GuideType.OpenSelectQuestionPanel then
    GoToUtil.CloseAllWindows()
    DataCenter.AllianceLeaderManager:TryOpenRoleSelect()
    self:DoNext()
  elseif self.template.type == GuideType.NoNpcTalk then
    local param = {}
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      param.autoNextTime = tonumber(self.template.para1) / 1000
    end
    if self.template.para2 ~= nil and self.template.para2 ~= "" then
      param.des = Localization:GetString(self.template.para2)
    end
    if self.template.para3 ~= nil and self.template.para3 ~= "" then
      param.canClickTime = tonumber(self.template.para3) / 1000
    end
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideNoNpcTalk) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideNoNpcTalk, {anim = true, playEffect = false}, param)
    end
  elseif self.template.type == GuideType.ShowFakeHero then
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      local heroId = tonumber(self.template.para1)
      local heroUuid = DataCenter.HeroDataManager:GetHeroUuidByHeroId(heroId)
      local fakeParam = {}
      fakeParam.type = RewardType.HERO
      fakeParam.value = {
        heroId = heroId,
        rewardAdd = 1,
        uuid = heroUuid
      }
      if fakeParam ~= nil then
        DataCenter.HeroEntrustManager:AddShowReward({
          reward = {fakeParam}
        })
        local param = {}
        param.heroId = heroId
        if self.template.para2 ~= nil and self.template.para2 ~= "" then
          param.canClickTime = tonumber(self.template.para2) / 1000
        end
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIShowFakeNewHero, {anim = false}, param)
      end
    end
  elseif self.template.type == GuideType.PrologueSubmitTrigger then
    local triggerId = tonumber(self.template.para1)
    local data = DataCenter.CityTriggerPointDataManager:GetTriggerPointDataFromId(triggerId)
    if data ~= nil then
      for k, v in pairs(data:GetAllNeedRes()) do
        data:SetGiveRes(k, v)
      end
      local obj = CityTriggerPointManager:GetInstance():GetTriggerObject(triggerId)
      if obj ~= nil then
        obj:RefreshShow()
      end
    end
    CityPioneerArchive:GetInstance():Save()
    self:DoNext()
  elseif self.template.type == GuideType.SetAttackSpecialStateFlag then
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      EventManager:GetInstance():Broadcast(EventId.AttackSpecialStateFlag, tonumber(self.template.para1))
    end
    self:DoNext()
  elseif self.template.type == GuideType.WaitPanelOpen then
    self:DoNext()
  elseif self.template.type == GuideType.LandLockChangeModel then
    DataCenter.LandLockManager:DoAlter(tonumber(self.template.para1), self.template.para2)
    self:DoNext()
  elseif self.template.type == GuideType.SetBubbleShow then
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      local showType = tonumber(self.template.para1)
      if showType == BubbleShowType.Show then
        DataCenter.BuildBubbleManager:ShowBubbleNode()
      elseif showType == BubbleShowType.Hide then
        DataCenter.BuildBubbleManager:HideBubbleNode()
      end
    end
    self:DoNext()
  elseif self.template.type == GuideType.AlliancePanelGuide then
    if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIAllianceMainTable) then
      local luaWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIAllianceMainTable)
      if luaWindow ~= nil and luaWindow.View ~= nil then
        local showParam = {}
        if self.template.para1 ~= nil and self.template.para1 ~= "" then
          local spl = string.split_ss_array(self.template.para1, "|")
          for k, v in ipairs(spl) do
            local spl1 = string.split_ss_array(v, ",")
            local count = table.count(spl1)
            local temp = {}
            if count >= 1 then
              temp.btnType = tonumber(spl1[1])
              table.insert(showParam, temp)
            end
            if 4 <= count then
              temp.dialog = spl1[2]
              temp.modelName = spl1[3]
              temp.modelPosition = tonumber(spl1[4])
            end
          end
        end
        luaWindow.View:DoSpecialGuide(showParam)
      end
    else
      self:DoNext()
    end
  elseif self.template.type == GuideType.DoQuestJump then
    local questId
    if self.template.para1 ~= nil then
      questId = tonumber(self.template.para1)
    end
    self:DoNext()
    if questId ~= nil then
      local template = DataCenter.QuestTemplateManager:GetQuestTemplate(questId)
      GoToUtil.GoToByQuestId(template)
    end
  elseif self.template.type == GuideType.CheckBecomeAllianceLeader then
    DataCenter.AllianceLeaderManager:SendCheckCanBeLeader()
  elseif self.template.type == GuideType.ShowLoadMask then
    if self.template.para1 ~= nil then
      local showLoadMaskType = tonumber(self.template.para1)
      if showLoadMaskType == ShowLoadMaskType.Show then
        if self.template.para3 == "" then
          local list = string.split_ss_array(self.template.para2, ";")
          if 3 < table.count(list) then
            local param = {}
            param.chapterId = tonumber(list[1])
            param.bgName = list[2]
            param.titleDes = Localization:GetString(list[3])
            param.des = Localization:GetString(list[4])
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideLoadMask, {anim = true, playEffect = false}, param)
          end
        else
          local param = {}
          param.des = Localization:GetString(self.template.para3)
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideLoadBlackMask, {anim = true, playEffect = false}, param)
        end
      elseif showLoadMaskType == ShowLoadMaskType.Hide then
        if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideLoadMask) then
          UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGuideLoadMask, {anim = true, playEffect = false})
        end
        if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideLoadBlackMask) then
          UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGuideLoadBlackMask, {anim = true, playEffect = false})
        end
      end
    end
    self:DoNext()
  elseif self.template.type == GuideType.SetShowLandLock then
    if self.template.para1 ~= nil then
      local showLandLockType = tonumber(self.template.para1)
      local list = string.split_ii_array(self.template.para2, ",")
      for k, v in ipairs(list) do
        local data = DataCenter.LandLockManager:GetLandLockDataById(v)
        if data ~= nil and data.state ~= LandLockState.Finished then
          if showLandLockType == ShowLandLockType.Show then
            CS.SceneManager.World:ShowObject(data:GetPointId())
          elseif showLandLockType == ShowLandLockType.Hide then
            CS.SceneManager.World:HideObject(data:GetPointId())
          end
        end
      end
    end
    self:DoNext()
  elseif self.template.type == GuideType.ChangeBgm then
    self:SendSaveGuideMessage(GuideBgmName, self.template.para1)
    CommonUtil.PlayGameBgMusic()
    self:DoNext()
  elseif self.template.type == GuideType.PVESetTriggerVisible then
    if self.template.para1 ~= nil then
      local visible = tonumber(self.template.para1) == PveTriggerVisibleType.Show
      local list = string.split_ii_array(self.template.para2, ",")
      for k, v in ipairs(list) do
        DataCenter.BattleLevel:SetOneTriggerVisible(v, visible)
      end
    end
    self:DoNext()
  elseif self.template.type == GuideType.ChangeBgmVolume then
    if DataCenter.LWSoundManager.useAudioMixer then
      DataCenter.LWSoundManager:ChangeVolume("MUSIC", tonumber(self.template.para1), tonumber(self.template.para2), true)
    else
      DataCenter.LWSoundManager:ChangeVolume("Music", tonumber(self.template.para1), tonumber(self.template.para2), false)
    end
    self:DoNext()
  elseif self.template.type == GuideType.WaitGolloesArrived then
    local worldMarch, formationInfo = DataCenter.GolloesCampManager:GetGolloesMarchByType(GolloesType.Explorer)
    if worldMarch then
      EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, false)
      CS.SceneManager.World:TrackMarch(worldMarch.uuid)
    end
  elseif self.template.type == GuideType.SetRadarMonsterVisible then
    local visible = tonumber(self.template.para1)
    if visible == GuideSetNormalVisible.Show then
      EventManager:GetInstance():Broadcast(EventId.ShowWorldMarchByType, NewMarchType.EXPLORE)
    elseif visible == GuideSetNormalVisible.Hide then
      EventManager:GetInstance():Broadcast(EventId.HideWorldMarchByType, NewMarchType.EXPLORE)
    end
    self:DoNext()
  elseif self.template.type == GuideType.SetCityPeopleAndCarVisible then
    local visible = tonumber(self.template.para1)
    if visible == GuideSetNormalVisible.Show then
      EventManager:GetInstance():Broadcast(EventId.SetCityPeopleAndCarVisible, CityPeopleAndCarVisibleType.AllShow)
    elseif visible == GuideSetNormalVisible.Hide then
      EventManager:GetInstance():Broadcast(EventId.SetCityPeopleAndCarVisible, CityPeopleAndCarVisibleType.AllHide)
    end
    self:DoNext()
  elseif self.template.type == GuideType.PveSkillVisible then
    local visible = tonumber(self.template.para1)
    if visible == GuideSetNormalVisible.Show then
      DataCenter.BattleLevel:SetHideSkill(false)
    elseif visible == GuideSetNormalVisible.Hide then
      DataCenter.BattleLevel:SetHideSkill(true)
    end
    EventManager:GetInstance():Broadcast(EventId.SetPveSkillVisible)
    self:DoNext()
  elseif self.template.type == GuideType.SetPveStaminaNpcVisible then
    self:DoNext()
  elseif self.template.type == GuideType.FullPveSkill then
    if self.template.para1 ~= "" then
      DataCenter.BattleLevel:ChangeSkillNum(tonumber(self.template.para1))
    end
    self:DoNext()
  elseif self.template.type == GuideType.SetPveBuyBuffShopEffectActive then
    EventManager:GetInstance():Broadcast(EventId.SetPveBuyBuffSShopEffectVisible, self.template.para1)
    self:DoNext()
  elseif self.template.type == GuideType.SetPveStopRefreshStamina then
    local param = {}
    local visible = tonumber(self.template.para1)
    if visible == GuideSetNormalVisible.Show then
      param.eventType = GuideMaskTypeSignalType.UIPveMainStaminaSliderShow
    elseif visible == GuideSetNormalVisible.Hide then
      param.eventType = GuideMaskTypeSignalType.UIPveMainStaminaSliderHide
    end
    EventManager:GetInstance():Broadcast(EventId.SetGuideMask, param)
    self:DoNext()
  elseif self.template.type == GuideType.SetPveNoClickStamina then
    EventManager:GetInstance():Broadcast(EventId.SetPveNoClickStamina, self.template.para1)
    self:DoNext()
  elseif self.template.type == GuideType.OpenHeadTalkPanel then
    if self.template.para2 ~= nil then
      local param = {}
      local list = string.split_ss_array(self.template.para2, "|")
      for k, v in ipairs(list) do
        local spl = string.split_ss_array(v, ";")
        local count = #spl
        if 4 <= count then
          local per = {}
          table.insert(param, per)
          per.dialog = Localization:GetString(spl[1])
          per.modelName = spl[2]
          per.modelPosition = spl[3]
          per.time = tonumber(spl[4]) / 1000
        end
      end
      if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIHeadTalk) then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeadTalk, {anim = true, playEffect = false}, param)
      else
        EventManager:GetInstance():Broadcast(EventId.RefreshUIHeadTalk, param)
      end
    end
    self:DoNext()
  elseif self.template.type == GuideType.CloseHeadTalkPanel then
    EventManager:GetInstance():Broadcast(EventId.CloseUIGuideHeadTalk)
    self:DoNext()
  elseif self.template.type == GuideType.SetPveBagGuide then
    local param = {}
    local visible = tonumber(self.template.para1)
    if visible == GuideSetNormalVisible.Show then
      param.eventType = GuideMaskTypeSignalType.UIPveMainResourceShow
    elseif visible == GuideSetNormalVisible.Hide then
      param.eventType = GuideMaskTypeSignalType.UIPveMainResourceHide
    end
    EventManager:GetInstance():Broadcast(EventId.SetGuideMask, param)
    self:DoNext()
  elseif self.template.type == GuideType.HeroAdvanceGuide then
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      local param = {}
      param.eventType = HeroAdvanceGuideSignalType.Enter
      param.quality = tonumber(self.template.para1)
      EventManager:GetInstance():Broadcast(EventId.HeroAdvanceGuide, param)
    end
    self:DoNext()
  elseif self.template.type == GuideType.SetHeroAdvanceGuideHeroVisible then
    local param = {}
    local visible = tonumber(self.template.para1)
    if visible == GuideSetNormalVisible.Show then
      param.eventType = HeroAdvanceGuideSignalType.ShowMainHeroBlack
    elseif visible == GuideSetNormalVisible.Hide then
      param.eventType = HeroAdvanceGuideSignalType.HideMainHeroBlack
    end
    EventManager:GetInstance():Broadcast(EventId.HeroAdvanceGuide, param)
    self:DoNext()
  elseif self.template.type == GuideType.SetHeroAdvanceGuideSubHeroVisible then
    local param = {}
    local visible = tonumber(self.template.para1)
    if visible == GuideSetNormalVisible.Show then
      param.eventType = HeroAdvanceGuideSignalType.ShowSubHeroBlack
    elseif visible == GuideSetNormalVisible.Hide then
      param.eventType = HeroAdvanceGuideSignalType.HideSubHeroBlack
    end
    EventManager:GetInstance():Broadcast(EventId.HeroAdvanceGuide, param)
    self:DoNext()
  elseif self.template.type == GuideType.ShakeCamera then
    if DataCenter.BattleLevel ~= nil then
      local paramSpls = string.split(self.template.para1, "|")
      local param = {}
      param.duration = tonumber(paramSpls[1]) or 0.5
      param.strength = tonumber(paramSpls[2]) or 1
      param.vibrato = tonumber(paramSpls[3]) or 20
      DataCenter.BattleLevel:ShakeCameraWithParam(param)
    end
    self:DoNext()
  elseif self.template.type == GuideType.SetAllVisible then
    local isInBattle = DataCenter.BattleLevel:IsInBattleLevel()
    local visible = tonumber(self.template.para1)
    if visible == GuideSetNormalVisible.Show then
      if isInBattle then
      else
        self:SetNoShowUIMain(false)
        DataCenter.BuildBubbleManager:ShowBubbleNode()
        DataCenter.WoundedCompensateManager:AddWoundedBubble()
        DataCenter.NpcTaskBubbleManager:AddTaskBubble()
        DataCenter.NpcQAManager:SetNpcQAVisible(true)
      end
    elseif visible ~= GuideSetNormalVisible.Hide or isInBattle then
    else
      self:SetNoShowUIMain(true)
      DataCenter.BuildBubbleManager:HideBubbleNode()
      DataCenter.WoundedCompensateManager:RemoveWoundedBubble()
      DataCenter.NpcTaskBubbleManager:RemoveTaskBubble()
      DataCenter.NpcQAManager:SetNpcQAVisible(false)
    end
    self:DoNext()
  elseif self.template.type == GuideType.SetWoundedBubbleVisible then
    local visible = tonumber(self.template.para1)
    if visible == GuideSetNormalVisible.Show then
      DataCenter.WoundedCompensateManager:AddWoundedBubble()
    elseif visible == GuideSetNormalVisible.Hide then
      DataCenter.WoundedCompensateManager:RemoveWoundedBubble()
    end
    self:DoNext()
  elseif self.template.type == GuideType.SetGuideQuestVisible then
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      EventManager:GetInstance():Broadcast(EventId.GuidControlQuest, tonumber(self.template.para1))
    end
    self:DoNext()
  elseif self.template.type == GuideType.ShowCurtain then
    local param = {}
    param.title = Localization:GetString(self.template.para1)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVECurtain, {anim = false}, param)
    self:DoNext()
  elseif self.template.type == GuideType.NetUnConnect then
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      CS.ApplicationLaunch.Instance:ReloadGame()
    else
      CS.ApplicationLaunch.Instance.Loading:ReConnect()
    end
    self:DoNext()
  elseif self.template.type == GuideType.UIBuildListSpecial then
    if self.template.para1 ~= nil and self.template.para1 ~= "" then
      local specialType = tonumber(self.template.para1)
      if specialType == GuideUIBuildListSpecialType.OpenUI then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildList)
      elseif specialType == GuideUIBuildListSpecialType.Move then
        local buildId = tonumber(self.template.para2)
        EventManager:GetInstance():Broadcast(EventId.UIBuildListScrollMove, buildId)
        self:DoNext()
      end
    end
  elseif self.template.type == GuideType.BackBuildCollectTime then
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_CONDOMINIUM)
    if buildData ~= nil then
      SFSNetwork.SendMessage(MsgDefines.BackBuildingCollectTime, {
        uuid = buildData.uuid
      })
    else
      self:DoNext()
    end
  elseif self.template.type == GuideType.SetHeroAdvanceMaskVisible then
    local param = {}
    local visible = tonumber(self.template.para1)
    if visible == GuideSetNormalVisible.Show then
      param.eventType = HeroAdvanceGuideSignalType.ShowHeroStarUpBlack
    elseif visible == GuideSetNormalVisible.Hide then
      param.eventType = HeroAdvanceGuideSignalType.HideHeroStarUpBlack
    end
    EventManager:GetInstance():Broadcast(EventId.HeroAdvanceGuide, param)
    self:DoNext()
  elseif self.template.type == GuideType.SetPveOutBagGuide then
    local param = {}
    local visible = tonumber(self.template.para1)
    if visible == GuideSetNormalVisible.Show then
      param.eventType = GuideMaskTypeSignalType.UIPveMainBagShow
    elseif visible == GuideSetNormalVisible.Hide then
      param.eventType = GuideMaskTypeSignalType.UIPveMainBagHide
    end
    EventManager:GetInstance():Broadcast(EventId.SetGuideMask, param)
    self:DoNext()
  elseif self.template.type == GuideType.SetQuestCanShowInGuide then
    local param = {}
    param.showType = tonumber(self.template.para1)
    param.showIndex = 1
    EventManager:GetInstance():Broadcast(EventId.SetQuestCanShowInGuide, param)
    self:DoNext()
  elseif self.template.type == GuideType.OpenPanel then
    local panelName = self.template.para1
    local panelType = tonumber(self.template.para2)
    if panelType == GuideOpenPanelType.Common and not UIManager:GetInstance():IsWindowOpen(panelName) then
      UIManager:GetInstance():OpenWindow(panelName)
    end
    self:DoNext()
  elseif self.template.type == GuideType.UIScrollToSomeWhere then
    EventManager:GetInstance():Broadcast(EventId.UIScrollToSomeWhere, self.template.para1)
    self:DoNext()
  elseif self.template.type == GuideType.ShowJumpBtn then
    local visible = tonumber(self.template.para1)
    if visible == GuideSetNormalVisible.Show then
      local param = {}
      if self.template.para2 ~= nil and self.template.para2 ~= "" then
        param.gotoGuideId = tonumber(self.template.para2)
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITimelineJump, {anim = false, playEffect = false}, param)
    elseif visible == GuideSetNormalVisible.Hide then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UITimelineJump, {anim = false, playEffect = false})
    end
    self:DoNext()
  elseif self.template.type == GuideType.BlackHoleMask then
    local visible = tonumber(self.template.para1)
    if visible == GuideSetNormalVisible.Show then
      local param = {}
      param.obj = self.obj
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIBlackHoleMask) then
        EventManager:GetInstance():Broadcast(EventId.RefreshGuideAnim, param)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBlackHoleMask, {anim = false, playEffect = false}, param)
      end
    elseif visible == GuideSetNormalVisible.Hide then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBlackHoleMask, {anim = false, playEffect = false})
    end
    self:DoNext()
  elseif self.template.type == GuideType.UIPathArrow then
    local visible = tonumber(self.template.para1)
    if visible == GuideSetNormalVisible.Show then
      local param = {}
      param.obj = self.obj
      param.extraPosition = Vector3.New(0, 0, 0)
      if self.template.para3 ~= nil and self.template.para3 ~= "" then
        local spl = string.split_ff_array(self.template.para3, ",")
        if #spl == 2 then
          param.extraPosition.x = spl[1]
          param.extraPosition.y = spl[2]
        end
      end
      param.rotation = Vector3.New(0, 0, 180)
      if self.template.para4 ~= nil and self.template.para4 ~= "" then
        param.rotation.z = tonumber(self.template.para4)
      end
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIPathArrow) then
        EventManager:GetInstance():Broadcast(EventId.RefreshGuideAnim, param)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIPathArrow, {anim = false, playEffect = false}, param)
      end
    elseif visible == GuideSetNormalVisible.Hide then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPathArrow, {anim = false, playEffect = false})
    end
    self:DoNext()
  elseif self.template.type == GuideType.BuildCanDoAnim then
    local eventId = 0
    local visible = tonumber(self.template.para1)
    if visible == GuideSetNormalVisible.Show then
      eventId = EventId.SetBuildCanDoAnim
    elseif visible == GuideSetNormalVisible.Hide then
      eventId = EventId.SetBuildNoDoAnim
    end
    local buildId = 0
    if self.template.para2 ~= nil and self.template.para2 ~= "" then
      buildId = tonumber(self.template.para2)
      local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
      if list ~= nil and table.count(list) > 0 then
        for k, v in ipairs(list) do
          EventManager:GetInstance():Broadcast(eventId, v.uuid)
        end
      end
    end
    self:DoNext()
  elseif self.template.type == GuideType.ShowNewHero then
    local heroId = tonumber(self.template.para2) or 0
    local heroUuid = tonumber(DataCenter.HeroDataManager:GetHeroUuidByHeroId(heroId)) or 0
    if heroUuid ~= 0 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UINewHero, heroUuid)
    end
    self:DoNext()
  elseif self.template.type == GuideType.SetWorldArrowVisible then
    local visible = tonumber(self.template.para1)
    if visible == GuideSetNormalVisible.Show then
      WorldArrowManager:GetInstance():SetGuidState(true)
    elseif visible == GuideSetNormalVisible.Hide then
      WorldArrowManager:GetInstance():SetGuidState(false)
    end
    self:DoNext()
  elseif self.template.type == GuideType.ShowWorldArrow then
    local showType = tonumber(self.template.para1)
    if showType == ShowWorldArrowType.FarmGet then
      local uuidList = DataCenter.QueueDataManager:GetBuildUuidInFinishQueueByType(NewQueueType.Field)
      if uuidList ~= nil then
        for k, v in ipairs(uuidList) do
          local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(v)
          if buildData ~= nil then
            WorldArrowManager:GetInstance():ShowArrowEffect(0, buildData:GetCenterVec(), ArrowType.Building)
            break
          end
        end
      end
    elseif showType == ShowWorldArrowType.FarmFree then
      local uuidList = DataCenter.QueueDataManager:GetBuildUuidInFreeQueueByType(NewQueueType.Field)
      if uuidList ~= nil then
        for k, v in ipairs(uuidList) do
          local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(v)
          if buildData ~= nil then
            WorldArrowManager:GetInstance():ShowArrowEffect(0, buildData:GetCenterVec(), ArrowType.Building)
            break
          end
        end
      end
    end
    self:DoNext()
  end
end
