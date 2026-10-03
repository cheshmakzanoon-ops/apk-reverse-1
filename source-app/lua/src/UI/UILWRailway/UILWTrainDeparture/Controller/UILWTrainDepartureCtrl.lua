local UILWTrainDepartureCtrl = BaseClass("UILWTrainDepartureCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTrainDeparture)
end

local function InitData(self, formationType, marchTargetType, pointIndex, uuid, index, backHome, rallyType, targetServerId)
  self.currentFormationUuid = 0
  self.formationType = 1
  self.targetType = MarchTargetType.TRAIN_MOVE
  self.targetPoint = -1
  self.targetUuid = tonumber(uuid) or 0
  self.timeIndex = -1
  self.autoBackHome = tonumber(backHome) or MarchAutoBackType.Back
  self.directionWaitResult = false
  self.selectFormationUuid = 0
  self.targetServerId = tonumber(targetServerId) or -1
  self.rallyType = tonumber(rallyType) or nil
  self.RallyTimeList = {}
  local k1 = LuaEntry.DataConfig:TryGetStr("world_rally", "k1")
  local k2 = LuaEntry.DataConfig:TryGetStr("world_rally", "k2")
  local k3 = LuaEntry.DataConfig:TryGetStr("world_rally", "k3")
  local k4 = LuaEntry.DataConfig:TryGetStr("world_rally", "k4")
  local k5 = LuaEntry.DataConfig:TryGetStr("world_rally", "k5")
  if self.targetType == MarchTargetType.RALLY_FOR_BOSS then
    self.RallyTimeList[1] = k5
    self.RallyTimeList[2] = k1
    self.RallyTimeList[3] = k2
    self.RallyTimeList[4] = k3
  else
    self.RallyTimeList[1] = k1
    self.RallyTimeList[2] = k2
    self.RallyTimeList[3] = k3
    self.RallyTimeList[4] = k4
  end
end

local function InitScoutData(self)
end

local function GetAllScoutFormations(self)
  local formations = DataCenter.ArmyFormationDataManager:GetInvestigateFormationList()
  table.sort(formations, function(a, b)
    if a.index ~= b.index then
      return a.index < b.index
    else
      return false
    end
  end)
  return formations
end

local function GetInvesFormationUnlockLv(self, formationIndex)
  local unlockLv = self.InvesFormationUnlockLvs[formationIndex]
  return unlockLv and unlockLv or 0
end

local function GetInvesFormationInfoByIndex(self, tempIndex)
  local retParam = {}
  local tempFormationInfo = DataCenter.ArmyFormationDataManager:GetInvestigateFormationInfoByIndex(tempIndex)
  retParam.FormationInfo = tempFormationInfo
  if tempFormationInfo and tempFormationInfo.state == 1 then
    local marchInfo = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, tempFormationInfo.uuid, LuaEntry.Player.allianceId)
    retParam.MarchInfo = marchInfo
  else
    retParam.MarchInfo = nil
  end
  return retParam
end

local function GetAllMarch(self)
  local allMarch = {}
  local allianceId = LuaEntry.Player.allianceId
  local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, allianceId)
  if selfMarch ~= nil then
    table.walk(selfMarch, function(k, v)
      if v:GetMarchStatus() ~= MarchStatus.IN_TEAM then
        table.insert(allMarch, v)
      else
        local march = DataCenter.WorldMarchDataManager:GetAllianceMarchesInTeam(allianceId, v.teamUuid)
        if march ~= nil then
          table.insert(allMarch, march)
        end
      end
    end)
  end
  return allMarch
end

local function GetInvesDistance(self, targetPointID, formationIndex)
  local startPointID = self:GetScoutStartPoint(formationIndex)
  local distance = Vector3.Distance(SceneUtils.TileIndexToWorld(startPointID), SceneUtils.TileIndexToWorld(targetPointID))
  distance = distance / CS.SceneManager.World.TileSize
  return distance
end

local function GetScoutStartPoint(self, formationIndex)
  local startPointID = 0
  if formationIndex then
    local tempFormationInfo = self:GetInvesFormationInfoByIndex(formationIndex)
    local formationUuid = tempFormationInfo.FormationInfo.uuid
    local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, formationUuid, LuaEntry.Player.allianceId)
    if march ~= nil then
      local troop = CS.SceneManager.World:GetTroop(march.uuid)
      if troop ~= nil then
        startPointID = SceneUtils.WorldToTileIndex(troop:GetPosition())
      else
        startPointID = SceneUtils.WorldToTileIndex(march:GetMarchCurPos())
      end
    else
      startPointID = MarchUtil.GetFormationStartPos()
    end
  else
    startPointID = MarchUtil.GetFormationStartPos()
  end
  return startPointID
end

local function GetElecCost(self, targetPointID, formationIndex)
  local tempCost = LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k11")
  return tempCost
end

local function StartInvestigate(self, scoutType, targetUuid, pointId, formationUuid)
  local realPoint = pointId
  if scoutType == MarchTargetType.SCOUT_BUILDING then
    local pointInfo = CS.SceneManager.World:GetPointInfoByUuid(targetUuid)
    if pointInfo.PointType == WorldPointType.PlayerBuilding then
      cast(pointInfo, typeof(CS.BuildPointInfo))
      if pointInfo then
        if pointInfo.itemId == BuildingTypes.FUN_BUILD_MAIN then
          scoutType = MarchTargetType.SCOUT_CITY
          if BattleFieldUtil.InBattleField(BattleFieldType.WinterStorm) then
            scoutType = MarchTargetType.SCOUT_WINTER_STORM_CITY
          elseif BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) then
            scoutType = MarchTargetType.SCOUT_EPIDEMIC_CITY
          end
        else
          scoutType = MarchTargetType.SCOUT_BUILDING
        end
      end
    end
  elseif scoutType == MarchTargetType.SCOUT_ALLIANCE_CITY then
    local worldPos = SceneUtils.TileIndexToWorld(pointId)
    worldPos.x = worldPos.x
    worldPos.z = worldPos.z
    realPoint = SceneUtils.WorldToTileIndex(worldPos)
  end
  local sfsObj = SFSObject.New()
  sfsObj:PutLong("uuid", formationUuid)
  local formationArray = SFSArray.New()
  sfsObj:PutSFSArray("formations", formationArray)
  local heroArray = SFSArray.New()
  sfsObj:PutSFSArray("heroInfos", heroArray)
  local dataObj = sfsObj
  local pos = MarchUtil.GetFormationStartPos()
  local curServerId = LuaEntry.Player:GetCurServerId()
  if CrossServerUtil:GetIsCrossServer() then
    local crossBuildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.WORM_HOLE_CROSS)
    if crossBuildData ~= nil and crossBuildData.server == curServerId then
      pos = crossBuildData.pointId
      MarchUtil.StartMarch(scoutType, realPoint, targetUuid, -1, 0, formationUuid, 1, dataObj, pos, curServerId)
    end
    self:CloseSelf()
    return
  end
  MarchUtil.StartMarch(scoutType, realPoint, targetUuid, -1, 0, formationUuid, 1, dataObj, pos)
  self:CloseSelf()
end

local function GetRallyTimeList(self)
  return self.RallyTimeList
end

local function GetFormationItemData(self, uuid)
  local oneData = {}
  local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(uuid)
  local Player = LuaEntry.Player
  if formation ~= nil then
    oneData.uuid = formation.uuid
    oneData.index = formation.index
    oneData.canMove = false
    oneData.stamina = DataCenter.ArmyFormationDataManager:GetCurStaminaByUuid(formation.uuid)
    local config = DataCenter.ArmyFormationDataManager:GetConfigData()
    if config ~= nil then
      oneData.maxStamina = config.FormationStaminaMax
    end
    local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(Player.uid, formation.uuid, Player.allianceId)
    oneData.isMarch = 0
    oneData.power = 0
    oneData.startPos = 0
    oneData.targetUuid = 0
    oneData.isBattle = false
    oneData.useForm = false
    oneData.speed = 1
    oneData.startTime = 0
    oneData.endTime = 0
    oneData.serverId = -1
    if march ~= nil then
      oneData.pointInfo = march.StationPointInfo
      oneData.armyInfo = march:GetArmyInfoIndexOne()
      oneData.power = self:GetFormationPowerByUuid(formation.uuid)
      oneData.isMarch = 1
      if march:GetMarchType() == NewMarchType.ASSEMBLY_MARCH or march:GetMarchType() == NewMarchType.EXPLORE or march:GetMarchStatus() == WAIT_RALLY or march:GetMarchStatus() == IN_TEAM or march:GetMarchType() == NewMarchType.DIRECT_MOVE_MARCH then
        oneData.canMove = true
      end
      if march:GetMarchStatus() == IN_TEAM then
        local teamMarch = DataCenter.WorldMarchDataManager:GetAllianceMarchesInTeam(Player.allianceId, march.teamUuid)
        if teamMarch ~= nil then
          march = teamMarch
        end
      end
      oneData.marchUuid = march.uuid
      oneData.targetUuid = march.targetUuid
      oneData.isBattle = march.inBattle
      oneData.serverId = march.serverId
      oneData.speed = march.speed
      if march:GetMarchStatus() == MarchStatus.DESTROY_WAIT then
        oneData.isBattle = true
      end
      if march:GetMarchStatus() == MarchStatus.CHASING or march:GetMarchStatus() == MarchStatus.MOVING or march:GetMarchStatus() == MarchStatus.IN_WORM_HOLE or march:GetMarchStatus() == MarchStatus.COLLECTING or march:GetMarchStatus() == MarchStatus.CROSS_SERVER then
        oneData.startTime = march.startTime
        oneData.endTime = march.endTime
      end
      local troop = CS.SceneManager.World:GetTroop(march.uuid)
      if troop ~= nil then
        local point = SceneUtils.WorldToTileIndex(troop:GetPosition())
        oneData.startPos = point
      else
        oneData.startPos = SceneUtils.WorldToTileIndex(march:GetMarchCurPos())
      end
      oneData.stateImg = MarchUtil.GetMarchStateIconByType(march)
      oneData.maxhp = march:GetMaxHP()
      oneData.hp = march:GetHP()
      oneData.heroDataList = {}
      local heroData = formation.heroes
      if heroData ~= nil and 0 < table.count(heroData) then
        table.walksort(heroData, function(leftKey, rightKey)
          return heroData[leftKey] < heroData[rightKey]
        end, function(k, v)
          if k ~= nil then
            local heroOneData = {}
            heroOneData.heroUuid = k
            heroOneData.index = v
            table.insert(oneData.heroDataList, heroOneData)
          end
        end)
      end
    else
      oneData.startPos = MarchUtil.GetFormationStartPos()
      local formationForm = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(uuid)
      if formationForm ~= nil then
        local allHeroes = formationForm.heroes
        if 0 < table.count(allHeroes) then
          oneData.useForm = true
        end
      end
      if oneData.useForm == false and formation.state == ArmyFormationState.March then
        local allHeroes = formation.heroes
        if 0 < table.count(allHeroes) then
          oneData.useForm = true
        end
      end
      if oneData.useForm == true then
        oneData.power = self:GetFormationPowerByUuid(formation.uuid)
        oneData.heroDataList = {}
        local heroData = formation.heroes
        if heroData ~= nil and 0 < table.count(heroData) then
          table.walksort(heroData, function(leftKey, rightKey)
            return heroData[leftKey] < heroData[rightKey]
          end, function(k, v)
            if k ~= nil then
              local heroOneData = {}
              heroOneData.heroUuid = k
              heroOneData.index = v
              table.insert(oneData.heroDataList, heroOneData)
            end
          end)
        end
      end
    end
  end
  return oneData
end

local function OnEditClick(self, uuid, needAutoFix, destroyTimeIndex)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPVPFormation, {anim = true}, EnterHeroSquadPanelWay.ToMarch, uuid, function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Start_March, false)
    self:OnCheckTime(uuid, destroyTimeIndex)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroPVPFormation)
  end)
end

local function OnAtkClick(self, uuid, attackTimesIndex)
  if self.targetType >= 0 then
    local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, uuid, LuaEntry.Player.allianceId)
    if march ~= nil then
      if march:GetMarchStatus() ~= MarchStatus.CHASING and march:GetMarchStatus() ~= MarchStatus.MOVING or self.targetType ~= MarchTargetType.BACK_HOME then
      end
      if self.targetType == MarchTargetType.TRANSPORT_ACT_BOSS then
        local time = self:GetTimeFormCurPosToTarPos(uuid)
        local limitTime = LuaEntry.DataConfig:TryGetNum("ship_boss", "k13")
        local showFlag = Setting:GetPrivateInt("SHOW_TRANS_WARN", 1)
        if time < limitTime and showFlag == 1 then
          UIUtil.ShowSecondMessage(Localization:GetString("100378"), Localization:GetString("302194"), 2, "", "", function()
            self:ChangeMarchByType(uuid)
          end, function()
            Setting:SetPrivateInt("SHOW_TRANS_WARN", 0)
          end)
        else
          self:ChangeMarchByType(uuid)
        end
      elseif self.targetType == MarchTargetType.JOIN_RALLY or self.rallyType == MarchTargetType.RALLY_FOR_BOSS then
        local time = self:GetTimeFormCurPosToTarPos(uuid)
        local timeLimit = LuaEntry.DataConfig:TryGetNum("assembly_monster_toplimit", "k3")
        if 0 < timeLimit and time > timeLimit * 60 then
          UIUtil.ShowMessage(Localization:GetString("110204", timeLimit), 2, GameDialogDefine.CANCEL, "400027", nil, function()
            self:ChangeMarchByType(uuid)
          end)
        else
          self:ChangeMarchByType(uuid)
        end
      elseif self.targetType == MarchTargetType.ATTACK_ALLIANCE_CITY then
        self:ChangeMarchByType(uuid, attackTimesIndex)
      else
        self:ChangeMarchByType(uuid)
      end
    end
  else
    UIUtil.ShowSingleTip(Localization:GetString("120090"))
  end
  self:CloseSelf()
end

local function OnCheckTime(self, uuid, destroyTimeIndex)
  local time = self:GetTimeFormCurPosToTarPos(uuid)
  if self.targetType == MarchTargetType.TRANSPORT_ACT_BOSS then
    local limitTime = LuaEntry.DataConfig:TryGetNum("ship_boss", "k13")
    local showFlag = Setting:GetPrivateInt("SHOW_TRANS_WARN", 1)
    if time < limitTime and showFlag == 1 then
      UIUtil.ShowSecondMessage(Localization:GetString("100378"), Localization:GetString("302194"), 2, "", "", function()
        self:OnCreateClick(uuid)
      end, function()
        Setting:SetPrivateInt("SHOW_TRANS_WARN", 0)
      end)
    else
      self:OnCreateClick(uuid)
    end
  elseif self.targetType == MarchTargetType.DIRECT_ATTACK_ACT_BOSS then
    self:OnCreateClick(uuid)
  elseif 1200 < time then
    local state = DataCenter.ArmyFormationDataManager:GetConfirmFlag()
    if state then
      UIUtil.ShowSecondMessage(Localization:GetString("100378"), Localization:GetString("120997"), 2, "", "", function()
        self:OnCreateClick(uuid, destroyTimeIndex)
      end, function()
        DataCenter.ArmyFormationDataManager:SetConfirmFlag(false)
      end)
    else
      self:OnCreateClick(uuid, destroyTimeIndex)
    end
  elseif self.targetType == MarchTargetType.JOIN_RALLY or self.rallyType == MarchTargetType.RALLY_FOR_BOSS then
    local timeLimit = LuaEntry.DataConfig:TryGetNum("assembly_monster_toplimit", "k3")
    if 0 < timeLimit and time > timeLimit * 60 then
      UIUtil.ShowMessage(Localization:GetString("110204", timeLimit), 2, GameDialogDefine.CANCEL, "400027", nil, function()
        self:OnCreateClick(uuid)
      end)
    else
      self:OnCreateClick(uuid)
    end
  else
    self:OnCreateClick(uuid, destroyTimeIndex)
  end
end

local function OnCreateClick(self, uuid, destroyTimeIndex)
  if self.targetType >= 0 then
    if self:CheckCanBattle(uuid) then
      local showGuide = self.directionWaitResult
      local targetMonsterLevel = 0
      if self.targetType ~= MarchTargetType.STATE and self.targetType ~= MarchTargetType.SCOUT_ALLIANCE_CITY and self.targetType ~= MarchTargetType.SCOUT_ARMY_COLLECT and self.targetType ~= MarchTargetType.SCOUT_BUILDING and self.targetType ~= MarchTargetType.SCOUT_CITY and self.targetType ~= MarchTargetType.SCOUT_WINTER_STORM_CITY and self.targetType ~= MarchTargetType.SCOUT_EPIDEMIC_CITY and self.targetType ~= MarchTargetType.SCOUT_TROOP and self.targetType ~= MarchTargetType.SCOUT_DRAGON_BUILDING and self.targetType ~= MarchTargetType.SCOUT_WINTER_ENTITY and self.targetType ~= MarchTargetType.SCOUT_EPIDEMIC_BUILDING then
        local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(uuid)
        if formation ~= nil then
          if self.targetType ~= MarchTargetType.ATTACK_MONSTER or showGuide == false then
            local canAddNum = MarchUtil.GetCanAddHeroNum(formation.heroes, formation.index)
            if 0 < canAddNum then
              local show = Setting:GetPrivateInt("SHOW_ADD_HERO", 0)
              if show <= 0 then
                UIUtil.ShowSecondMessage(Localization:GetString("121006"), Localization:GetString("121007"), 1, 121008, "", function()
                  self:OnEditClick(uuid, false)
                end, function(needSellConfirm)
                  if needSellConfirm == false then
                    Setting:SetPrivateInt("SHOW_ADD_HERO", 1)
                  else
                    Setting:SetPrivateInt("SHOW_ADD_HERO", 0)
                  end
                end)
                if showGuide == true then
                  EventManager:GetInstance():Broadcast(EventId.StartAttackMonsterWithoutMsgTip, 0)
                end
                return
              end
            end
            if self.targetType ~= MarchTargetType.COLLECT then
              local k5 = LuaEntry.DataConfig:TryGetNum("res_lack", "k5")
              local heroUuid, targetHeroUuid = DataCenter.ArmyFormationDataManager:GetFormationHeroCanChangeHigherUuid(uuid)
              if k5 >= DataCenter.BuildManager.MainLv and heroUuid ~= nil and heroUuid ~= 0 and targetHeroUuid ~= nil and targetHeroUuid ~= 0 then
                UIUtil.ShowMessage(Localization:GetString("104245"), 1, 121008, "", function()
                  self:OnEditClick(uuid, false)
                end)
                if showGuide == true then
                  EventManager:GetInstance():Broadcast(EventId.StartAttackMonsterWithoutMsgTip, 0)
                end
                return
              end
            end
          end
          if self.targetType == MarchTargetType.ATTACK_MONSTER then
            local needShow = Setting:GetPrivateInt("SHOW_ADD_SOLDIER", 0)
            if needShow <= 0 then
              local totalPower = MarchUtil.GetFormationPower(formation.heroes, formation.soldiers, formation.index, MarchUtil.GetCampAddParam(formation.heroes))
              local targetPower = 0
              local targetLevel = 0
              local marchInfo = CS.SceneManager.World:GetMarch(self.targetUuid)
              local isCheckPower = false
              if marchInfo ~= nil then
                if marchInfo:GetMarchType() == NewMarchType.CHALLENGE_BOSS or marchInfo:GetMarchType() == NewMarchType.PUZZLE_BOSS then
                  isCheckPower = false
                end
                local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(marchInfo.monsterId)
                if monster ~= nil then
                  targetPower = tonumber(monster.recommend_power)
                  targetLevel = tonumber(monster.level)
                  targetMonsterLevel = targetLevel
                  if monster.power_tip == 1 then
                    targetPower = 0
                  end
                end
              end
              if isCheckPower then
                local percent = (totalPower - targetPower) / math.max(1, targetPower)
                if percent < 0 then
                  local k2 = LuaEntry.DataConfig:TryGetNum("res_lack", "k2")
                  local configOpenState = LuaEntry.DataConfig:CheckSwitch("detect_monster")
                  if configOpenState then
                    UIUtil.ShowMessage(Localization:GetString("121010"), 1, nil, nil, nil, nil, function(needSellConfirm)
                      if needSellConfirm == false then
                        Setting:SetPrivateInt("SHOW_ADD_SOLDIER", 1)
                      else
                        Setting:SetPrivateInt("SHOW_ADD_SOLDIER", 0)
                      end
                    end, 121009)
                  else
                    UIUtil.ShowSecondMessage(Localization:GetString("121009"), Localization:GetString("121010"), 1, 150122, "", function()
                      MarchUtil.SendCreateMarchMessage(uuid, self.targetType, self.targetPoint, self.targetUuid, self.timeIndex, self.autoBackHome, true, self.targetServerId)
                    end, function(needSellConfirm)
                      if needSellConfirm == false then
                        Setting:SetPrivateInt("SHOW_ADD_SOLDIER", 1)
                      else
                        Setting:SetPrivateInt("SHOW_ADD_SOLDIER", 0)
                      end
                    end)
                  end
                  if showGuide == true then
                    EventManager:GetInstance():Broadcast(EventId.StartAttackMonsterWithoutMsgTip, 0)
                  end
                  return
                end
              end
            end
          end
        end
      end
      if self.targetType == MarchTargetType.JOIN_RALLY then
        local data = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(self.targetUuid)
        local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(data.targetUid)
        if monster ~= nil then
          local pow = monster.recommend_power / data.assemblyMarchMax * 0.5
          local selfPow = self:GetFormationPowerByUuid(uuid)
          if pow > selfPow then
            UIUtil.ShowMessage(Localization:GetString("141079"), 2, "", "", function()
              if self:NeedTakeArmy() == false then
                MarchUtil.SendCreateMarchMessage(uuid, self.targetType, self.targetPoint, self.targetUuid, self.timeIndex, self.autoBackHome, false, self.targetServerId)
              else
                MarchUtil.SendCreateMarchMessage(uuid, self.targetType, self.targetPoint, self.targetUuid, self.timeIndex, self.autoBackHome, true, self.targetServerId)
              end
              self:CloseSelf()
            end)
            return
          end
        end
      end
      if self:NeedTakeArmy() == false then
        MarchUtil.SendCreateMarchMessage(uuid, self.targetType, self.targetPoint, self.targetUuid, self.timeIndex, self.autoBackHome, false, self.targetServerId)
      else
        if self.targetType == MarchTargetType.ATTACK_MONSTER and showGuide == true then
          EventManager:GetInstance():Broadcast(EventId.StartAttackMonsterWithoutMsgTip, 1)
        end
        MarchUtil.SendCreateMarchMessage(uuid, self.targetType, self.targetPoint, self.targetUuid, self.timeIndex, self.autoBackHome, false, self.targetServerId, destroyTimeIndex)
      end
    end
  else
    UIUtil.ShowTipsId(120090)
  end
  self:CloseSelf()
end

local function NeedTakeArmy(self)
  return self.targetType ~= MarchTargetType.EXPLORE
end

local function ChangeMarchByType(self, formationUuid, attackTimesIndex)
  if self.targetType > -1 then
    local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, formationUuid, LuaEntry.Player.allianceId)
    if march ~= nil then
      if march:GetIsBroken() == true then
        UIUtil.ShowTipsId(120003)
        return
      end
      local marchUuid = march.uuid
      if self.targetType == MarchTargetType.ATTACK_MONSTER then
        local curStamina = DataCenter.ArmyFormationDataManager:GetCurStaminaByUuid(formationUuid)
        local info = CS.SceneManager.World:GetMarch(self.targetUuid)
        if info ~= nil then
          MarchUtil.OnAttackMonster(marchUuid, info, curStamina, nil, self.autoBackHome, self.directionWaitResult)
        end
      elseif self.targetType == MarchTargetType.ATTACK_ARMY then
        local curStamina = DataCenter.ArmyFormationDataManager:GetCurStaminaByUuid(formationUuid)
        local info = CS.SceneManager.World:GetMarch(self.targetUuid)
        if info ~= nil then
          MarchUtil.OnAttackArmy(marchUuid, info, curStamina)
        end
      elseif self.targetType == MarchTargetType.SAMPLE then
        local curStamina = DataCenter.ArmyFormationDataManager:GetCurStaminaByUuid(formationUuid)
        local pointInfo = CS.SceneManager.World:GetPointInfo(self.targetPoint)
        if pointInfo ~= nil then
          cast(pointInfo, typeof(CS.SamplePointInfo))
          if pointInfo ~= nil then
            MarchUtil.OnCollectSimple(marchUuid, pointInfo, curStamina)
          end
        end
      elseif self.targetType == MarchTargetType.ATTACK_ARMY_COLLECT then
        local curStamina = DataCenter.ArmyFormationDataManager:GetCurStaminaByUuid(formationUuid)
        local pointInfo = CS.SceneManager.World:GetPointInfo(self.targetPoint)
        if pointInfo ~= nil then
          cast(pointInfo, typeof(CS.ResPointInfo))
          if pointInfo ~= nil then
            MarchUtil.OnAttackCollectBuild(marchUuid, pointInfo, curStamina)
          end
        end
      elseif self.targetType == MarchTargetType.ASSISTANCE_BUILD then
        local pointInfo = CS.SceneManager.World:GetPointInfo(self.targetPoint)
        cast(pointInfo, typeof(CS.BuildPointInfo))
        if pointInfo ~= nil then
          MarchUtil.OnAssistanceBuild(marchUuid, pointInfo)
        end
      elseif self.targetType == MarchTargetType.ASSISTANCE_CITY or self.targetType == MarchTargetType.ASSISTANCE_WINTER_STORM_CITY or self.targetType == MarchTargetType.ASSISTANCE_EPIDEMIC_CITY then
        local pointInfo = CS.SceneManager.World:GetPointInfo(self.targetPoint)
        cast(pointInfo, typeof(CS.BuildPointInfo))
        if pointInfo ~= nil then
          MarchUtil.OnAssistanceOtherCity(marchUuid, pointInfo)
        end
      elseif self.targetType == MarchTargetType.ASSISTANCE_DESERT then
        MarchUtil.OnAssistanceDesert(marchUuid, self.targetPoint, self.targetUuid, false)
      elseif self.targetType == MarchTargetType.ASSISTANCE_ALLIANCE_CITY then
        local pointInfo = CS.SceneManager.World:GetPointInfo(self.targetPoint)
        if pointInfo ~= nil then
          MarchUtil.OnAssistanceAllianceCity(marchUuid, pointInfo)
        end
      elseif self.targetType == MarchTargetType.ATTACK_ALLIANCE_CITY then
        local curStamina = DataCenter.ArmyFormationDataManager:GetCurStaminaByUuid(formationUuid)
        local pointInfo = CS.SceneManager.World:GetPointInfo(self.targetPoint)
        if pointInfo ~= nil then
          attackTimesIndex = attackTimesIndex or 1
          MarchUtil.OnAttackAllianceCity(marchUuid, pointInfo, curStamina, nil, attackTimesIndex)
        end
      elseif self.targetType == MarchTargetType.ATTACK_BUILDING then
        local curStamina = DataCenter.ArmyFormationDataManager:GetCurStaminaByUuid(formationUuid)
        local pointInfo = CS.SceneManager.World:GetPointInfo(self.targetPoint)
        cast(pointInfo, typeof(CS.BuildPointInfo))
        if pointInfo ~= nil then
          MarchUtil.OnAttackOtherBuild(marchUuid, pointInfo, curStamina)
        end
      elseif self.targetType == MarchTargetType.ATTACK_CITY or self.targetType == MarchTargetType.ATTACK_WINTER_STORM_CITY or self.targetType == MarchTargetType.ATTACK_EPIDEMIC_CITY then
        local curStamina = DataCenter.ArmyFormationDataManager:GetCurStaminaByUuid(formationUuid)
        local pointInfo = CS.SceneManager.World:GetPointInfo(self.targetPoint)
        cast(pointInfo, typeof(CS.BuildPointInfo))
        if pointInfo ~= nil then
          MarchUtil.OnAttackOtherCity(marchUuid, pointInfo, curStamina)
        end
      elseif self.targetType == MarchTargetType.ATTACK_ROAD then
        local curStamina = DataCenter.ArmyFormationDataManager:GetCurStaminaByUuid(formationUuid)
        local pointInfo = CS.SceneManager.World:GetPointInfo(self.targetPoint)
        cast(pointInfo, typeof(CS.BoardPointInfo))
        if pointInfo ~= nil then
          MarchUtil.OnAttackOtherRoad(marchUuid, pointInfo, curStamina)
        end
      elseif self.targetType == MarchTargetType.EXPLORE then
        local curStamina = DataCenter.ArmyFormationDataManager:GetCurStaminaByUuid(formationUuid)
        local pointInfo = CS.SceneManager.World:GetExplorePointInfoByIndex(self.targetPoint)
        if pointInfo ~= nil then
          MarchUtil.OnExplore(marchUuid, pointInfo, curStamina)
        end
      elseif self.targetType == MarchTargetType.PICK_GARBAGE then
        local curStamina = DataCenter.ArmyFormationDataManager:GetCurStaminaByUuid(formationUuid)
        local pointInfo = CS.SceneManager.World:GetGarbagePointInfoByIndex(self.targetPoint)
        if pointInfo ~= nil then
          MarchUtil.OnCollectGarbage(marchUuid, pointInfo, curStamina)
        end
      elseif self.targetType == MarchTargetType.GO_WORM_HOLE then
        UIUtil.ShowTipsId(143611)
      elseif self.targetType == MarchTargetType.CROSS_SERVER_WORM then
        MarchUtil.OnGotoCrossServerWormHole(marchUuid, false, self.targetServerId)
      elseif self.targetType == MarchTargetType.BUILD_WORM_HOLE then
        local pointInfo = CS.SceneManager.World:GetPointInfo(self.targetPoint)
        cast(pointInfo, typeof(CS.BuildPointInfo))
        if pointInfo ~= nil then
          MarchUtil.OnBuildWormHole(marchUuid, pointInfo)
        end
      elseif self.targetType == MarchTargetType.COLLECT then
        local collectPoint = CS.SceneManager.World:GetResourcePointInfoByIndex(self.targetPoint)
        if collectPoint ~= nil then
          MarchUtil.OnGotoCollect(marchUuid, collectPoint, self.targetPoint, false)
        end
      elseif self.targetType == MarchTargetType.ATTACK_DESERT or self.targetType == MarchTargetType.ATTACK_EMPTY_DESERT then
        MarchUtil.OnAttackDesert(marchUuid, self.targetPoint, false, self.targetType)
      elseif self.targetType == MarchTargetType.JOIN_RALLY then
        local curStamina = DataCenter.ArmyFormationDataManager:GetCurStaminaByUuid(formationUuid)
        local data = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(self.targetUuid)
        local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(data.targetUid)
        if monster ~= nil then
          local pow = monster.recommend_power / data.assemblyMarchMax * 0.5
          local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(formationUuid)
          if formation ~= nil then
            local totalPower = MarchUtil.GetFormationPower(formation.heroes, formation.soldiers, formation.index, MarchUtil.GetCampAddParam(formation.heroes))
            if pow > totalPower then
              UIUtil.ShowMessage(Localization:GetString("141079"), 2, "", "", function()
                MarchUtil.OnJoinRally(marchUuid, self.rallyType, self.targetUuid, self.targetPoint, curStamina)
              end)
              return
            end
          end
        end
        MarchUtil.OnJoinRally(marchUuid, self.rallyType, self.targetUuid, self.targetPoint, curStamina)
      elseif self.targetType == MarchTargetType.STATE then
        MarchUtil.OnStation(marchUuid, self.targetPoint)
      elseif self.targetType == MarchTargetType.ATTACK_DRAGON_BUILDING or self.targetType == MarchTargetType.ATTACK_WINTER_ENTITY or self.targetType == MarchTargetType.ATTACK_EPIDEMIC_BUILDING then
        local curStamina = DataCenter.ArmyFormationDataManager:GetCurStaminaByUuid(formationUuid)
        local pointInfo = CS.SceneManager.World:GetPointInfo(self.targetPoint)
        if pointInfo ~= nil then
          MarchUtil.OnAttackBattleFieldBuild(marchUuid, pointInfo, curStamina, false, self.targetType)
        end
      elseif self.targetType == MarchTargetType.ASSISTANCE_DRAGON_BUILDING or self.targetType == MarchTargetType.ASSISTANCE_WINTER_ENTITY or self.targetType == MarchTargetType.ASSISTANCE_EPIDEMIC_BUILDING then
        local pointInfo = CS.SceneManager.World:GetPointInfo(self.targetPoint)
        if pointInfo ~= nil then
          MarchUtil.OnAssistanceBattleFieldBuild(marchUuid, pointInfo, false, self.targetType)
        end
      else
        MarchUtil.StartMarch(self.targetType, self.targetPoint, self.targetUuid, self.timeIndex, 0, self.selectFormationUuid, self.autoBackHome, nil, 0, self.targetServerId)
      end
    end
  end
end

local function CheckCanBattle(self, uuid)
  local canBattle = false
  local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(uuid)
  if formation ~= nil then
    if self.targetType == MarchTargetType.COLLECT then
      local info = CS.SceneManager.World:GetResourcePointInfoByIndex(self.targetPoint)
      if info ~= nil then
        if false then
          local scienceId = GetTableData(TableName.GatherResource, info.id, "unlock_science")
          if scienceId ~= "" and not DataCenter.ScienceManager:HasScienceByIdAndLevel(tonumber(scienceId), 1) then
            local template = DataCenter.ScienceTemplateManager:GetScienceTemplate(scienceId, 1)
            UIUtil.ShowTips(Localization:GetString("129055", Localization:GetString(template.name), Localization:GetString(GetTableData(TableName.GatherResource, info.id, "name"))))
          end
        else
          canBattle = true
        end
      end
    elseif self.targetType == MarchTargetType.PICK_GARBAGE then
      local k2 = LuaEntry.DataConfig:TryGetNum("Reconnaissance_power_consumption", "k3")
      local own = LuaEntry.Resource:GetCntByResType(ResourceType.Electricity)
      if k2 > own then
        UIUtil.ShowTipsId(129023)
        local lackTab = {}
        local param = {}
        param.type = ResLackType.Res
        param.resType = ResourceType.Electricity
        param.targetNum = k2
        table.insert(lackTab, param)
        GoToResLack.GoToItemResLackList(lackTab)
      else
        canBattle = true
      end
    elseif self.targetType == MarchTargetType.SAMPLE then
      local k3 = LuaEntry.DataConfig:TryGetNum("Reconnaissance_power_consumption", "k3")
      local own = LuaEntry.Resource:GetCntByResType(ResourceType.Electricity)
      if k3 > own then
        UIUtil.ShowTipsId(129023)
        local lackTab = {}
        local param = {}
        param.type = ResLackType.Res
        param.resType = ResourceType.Electricity
        param.targetNum = k3
        table.insert(lackTab, param)
        GoToResLack.GoToItemResLackList(lackTab)
      else
        canBattle = true
      end
    elseif self.targetType == MarchTargetType.ATTACK_ALLIANCE_CITY then
      local protectTime = 0
      local openTime = 0
      local curTime = UITimeManager:GetInstance():GetServerSeconds()
      local info = CS.SceneManager.World:GetPointInfo(self.targetPoint)
      if info ~= nil and info ~= nil then
        local allianceCityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(info.PointType, info.extraInfo, info)
        if allianceCityPointInfo ~= nil then
          openTime = allianceCityPointInfo.openTime or 0
          if curTime < openTime or openTime == -1 then
            UIUtil.ShowTipsId(300708)
            return false
          end
          protectTime = allianceCityPointInfo.protectTime or 0
          if curTime < protectTime then
            UIUtil.ShowTipsId(300709)
            return false
          end
          local cityId = allianceCityPointInfo.cityId
          local level = GetTableData(TableName.WorldCity, cityId, "level")
          if SeasonUtil.IsInSeasonCityStrongholdMode() and SeasonUtil.CanAttackCityStronghold(cityId) then
            return true
          elseif DataCenter.WorldAllianceCityDataManager:GetAllianceAlreadyHaveCity(LuaEntry.Player.allianceId) == true then
            if DataCenter.WorldAllianceCityDataManager:GetCityIsNearBySelfAlliance(LuaEntry.Player.allianceId, cityId) == false then
              UIUtil.ShowTipsId(300711)
              return false
            end
          elseif 1 < level then
            UIUtil.ShowTipsId(300710)
            return false
          end
          local staminaCost = MarchUtil.GetCostStaminaByTargetType(MarchTargetType.ATTACK_ALLIANCE_CITY)
          local curStamina = DataCenter.ArmyFormationDataManager:GetCurStaminaByUuid(uuid)
          if staminaCost > curStamina then
            UIUtil.ShowTipsId(GameDialogDefine.STAMINA_IS_NOT_ENOUGH)
            return false
          end
          return true
        end
      end
    else
      local cost = self:GetCostStaminaByTargetType(self.targetType)
      if 0 < cost then
        local curStamina = DataCenter.ArmyFormationDataManager:GetCurStaminaByUuid(uuid)
        if cost > curStamina then
          UIUtil.ShowTipsId(GameDialogDefine.STAMINA_IS_NOT_ENOUGH)
        else
          canBattle = true
        end
      else
        canBattle = true
      end
    end
  else
    UIUtil.ShowTipsId(300007)
  end
  return canBattle
end

local function SetSelectFormationUuid(self, uuid)
  self.selectFormationUuid = uuid
  if uuid and 0 < uuid then
    CommonUtil.PlayerPrefsSetString("FORMATION_SELECT_HISTORY", tostring(uuid))
  end
end

local function GetTimeFormCurPosToTarPos(self, uuid)
  local data = self:GetFormationItemData(uuid)
  local speed = 1
  local distance = Vector3.Distance(SceneUtils.TileIndexToWorld(data.startPos), SceneUtils.TileIndexToWorld(self.targetPoint))
  if data.isMarch == 1 then
    speed = data.speed * CS.SceneManager.World.TileSize
  else
    local k1 = LuaEntry.DataConfig:TryGetNum("armyspeed", "k1")
    local detectEvent = DataCenter.RadarCenterDataManager:GetDetectEventInfoByPointId(self.targetPoint)
    local k7 = 1
    if detectEvent ~= nil then
      k7 = LuaEntry.DataConfig:TryGetNum("armyspeed", "k7")
      if k7 == 0 then
        k7 = 1
      end
      speed = CS.SceneManager.World.TileSize * k1 * k7
    else
      local addEffect = LuaEntry.Effect:GetGameEffect(EffectDefine.ARMY_SPEED_ADD)
      local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(uuid)
      if formation ~= nil then
        local heroes = formation.heroes
        for k, v in pairs(heroes) do
          local heroData = DataCenter.HeroDataManager:GetHeroByUuid(k)
          if heroData ~= nil then
            addEffect = addEffect + heroData:GetEffectNum(EffectDefine.ARMY_SPEED_ADD)
          end
        end
        local indexAdd = MarchUtil.GetFormationSpeedAddByIndex(formation.index)
        local joinAddSpeed = 0
        local joinRallyForBossSpeed = 0
        if self.targetType == MarchTargetType.JOIN_RALLY then
          joinAddSpeed = LuaEntry.Effect:GetGameEffect(EffectDefine.CAREER_JOIN_TEAM_SPEED_ADD_PERCENT)
          if self.rallyType == MarchTargetType.RALLY_FOR_BOSS then
            joinRallyForBossSpeed = LuaEntry.DataConfig:TryGetNum("armyspeed", "k5")
          end
        end
        local alScienceEff = 0
        if self.targetType == MarchTargetType.ASSISTANCE_BUILD or self.targetType == MarchTargetType.ASSISTANCE_CITY or self.targetType == MarchTargetType.ASSISTANCE_WINTER_STORM_CITY or self.targetType == MarchTargetType.ASSISTANCE_EPIDEMIC_CITY or self.targetType == MarchTargetType.ASSISTANCE_ALLIANCE_CITY or self.targetType == MarchTargetType.ASSISTANCE_DESERT then
          alScienceEff = LuaEntry.Effect:GetGameEffect(EffectDefine.ASSIST_SPEED_ADD)
        end
        speed = CS.SceneManager.World.TileSize * k1 * (1 + addEffect / 100 + indexAdd / 100 + joinAddSpeed / 100 + alScienceEff / 100 + joinRallyForBossSpeed)
      end
    end
  end
  local time = distance / speed
  if self.targetType == MarchTargetType.CROSS_SERVER_WORM then
    local wormTime = LuaEntry.DataConfig:TryGetNum("crossServerFight", "k1")
    time = time + wormTime
  end
  return time
end

local function SetTargetPoint(self, pos)
  self.targetPoint = pos
end

local function GetIsAssemble(self)
  return self.targetType
end

local function GetCostStaminaByTargetType(self, type)
  return MarchUtil.GetCostStaminaByTargetType(type, self.rallyType, self.selectFormationUuid, self.destroyTimes)
end

local function GetFormationPowerByUuid(self, formationUuid)
  local totalPower = 0
  local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(formationUuid)
  if formation ~= nil then
    totalPower = formation:GetTotalCapacity()
  end
  return totalPower
end

local function GetExploreFormationPowerByUuidAndEventId(self, formationUuid, eventId)
  local totalPower = 0
  local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(formationUuid)
  if formation ~= nil then
    totalPower = MarchUtil.GetExploreFormationPower(formation.heroes, eventId, formation.index, MarchUtil.GetCampAddParam(formation.heroes))
  end
  return totalPower
end

local function GetMaxCanAddSoldierNum(self, formationUuid)
  local totalNum = 0
  local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(formationUuid)
  if formation ~= nil then
    totalNum = MarchUtil.GetMaxCanAddSoldierNum(formation.heroes, formation.index)
  end
  return totalNum
end

local function GetFormationFormMaxNum(self, formationUuid)
  local maxNum = 0
  local formationForm = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(formationUuid)
  if formationForm ~= nil then
    maxNum = formationForm.maxNum
  end
  return maxNum
end

local function GetCurSoldierNum(self, formationUuid)
  local totalNum = 0
  local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(formationUuid)
  if formation ~= nil then
    table.walk(formation.soldiers, function(k, v)
      if 0 < v then
        totalNum = totalNum + v
      end
    end)
  end
  return totalNum
end

local function GetFormationBuildNameByIndex(self, index)
  local name = ""
  local buildId = MarchUtil.GetFormationBuildNameByIndex(index)
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if buildTemplate ~= nil then
    name = Localization:GetString(buildTemplate.name)
  end
  return name
end

local function ShowCost(self, marchTargetType)
  return marchTargetType ~= MarchTargetType.EXPLORE
end

local function ShowExplorePower(self, marchTargetType)
  return marchTargetType == MarchTargetType.EXPLORE
end

local function GetCanGatherResourceNum(self, formationUuid, resourceType, itemId)
  local totalNum = 0
  local Player = LuaEntry.Player
  local partNum = 0.001
  if tonumber(resourceType) >= ResourceType.ResourceItem then
    local num = GetTableData(TableName.Aps_Resource_Item, tonumber(itemId), "weight")
    partNum = tonumber(num)
  else
    local strK = "k" .. resourceType + 1
    local basePartNum = LuaEntry.DataConfig:TryGetNum("res_weight", strK)
    local minPartNum = LuaEntry.DataConfig:TryGetNum("res_weight_min", strK)
    local percent = 1
    if resourceType == ResourceType.Food then
      percent = LuaEntry.Effect:GetGameEffect(EffectDefine.APS_MONEY_WEIGHT_PERCENT)
    end
    local realNum = basePartNum * (1 - percent / 100)
    partNum = math.max(minPartNum, realNum)
  end
  if partNum == nil or partNum <= 0 then
    Logger.LogError("can not get weight")
    partNum = 1
  end
  local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(Player.uid, formationUuid, Player.allianceId)
  if march ~= nil then
    local weight = march.armyWeight
    local curNum = march:GetCurArmyWeight()
    local value = math.max(weight - curNum, 0)
    totalNum = math.max(value / partNum, 0)
  else
    local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(formationUuid)
    if formation ~= nil then
      local value = 0
      local soldiers = formation.soldiers
      local heroes = formation.heroes
      local totalSoliderLoadNum = 0
      local index = formation.index
      if soldiers then
        for k, v in pairs(soldiers) do
          local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(k)
          if template ~= nil then
            local load = template.load
            totalSoliderLoadNum = totalSoliderLoadNum + load * v
          end
        end
      end
      local effectNum = LuaEntry.Effect:GetGameEffect(EffectDefine.ARMY_CARRY_WEIGHT_ADD_PERCENT)
      for k, v in pairs(heroes) do
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(k)
        if heroData ~= nil then
          effectNum = effectNum + heroData:GetEffectNum(EffectDefine.ARMY_CARRY_WEIGHT_ADD_PERCENT)
        end
      end
      local addValue = MarchUtil.GetFormationAddWeightPercentByFormationIndex(index)
      local careerValue = LuaEntry.Effect:GetGameEffect(EffectDefine.CAREER_COLLECT_ADD_PERCENT)
      local addNum = MarchUtil.GetFormationAddWeightNumByFormationIndex(index)
      value = totalSoliderLoadNum * (careerValue / 100 + effectNum / 100 + addValue / 100 + 1) + addNum
      totalNum = math.max(value / partNum, 0)
    end
  end
  return totalNum
end

local function SetTimeIndex(self, timeIndex)
  if self.targetType == MarchTargetType.RALLY_FOR_BOSS then
    timeIndex = (timeIndex + 3) % 5 + 1
  end
  self.timeIndex = timeIndex
end

local function OnCreateMarchInGuide(self, uuid, needAutoFix)
  local needFix = 0
  if needAutoFix == true then
    needFix = 1
  end
  local data = self:GetFormationItemData(uuid)
  if data ~= nil then
    self:CloseSelf()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationTableNew, uuid, self.targetType, self.targetPoint, self.targetUuid, self.timeIndex, self.autoBackHome, data.startPos, self.rallyType, needFix)
  end
end

local function SetAttackTimes(self, tempTimes)
  self.destroyTimes = tempTimes
end

UILWTrainDepartureCtrl.CloseSelf = CloseSelf
UILWTrainDepartureCtrl.InitData = InitData
UILWTrainDepartureCtrl.SetSelectFormationUuid = SetSelectFormationUuid
UILWTrainDepartureCtrl.GetFormationItemData = GetFormationItemData
UILWTrainDepartureCtrl.OnAtkClick = OnAtkClick
UILWTrainDepartureCtrl.CheckCanBattle = CheckCanBattle
UILWTrainDepartureCtrl.GetTimeFormCurPosToTarPos = GetTimeFormCurPosToTarPos
UILWTrainDepartureCtrl.SetTargetPoint = SetTargetPoint
UILWTrainDepartureCtrl.GetIsAssemble = GetIsAssemble
UILWTrainDepartureCtrl.GetCostStaminaByTargetType = GetCostStaminaByTargetType
UILWTrainDepartureCtrl.GetFormationPowerByUuid = GetFormationPowerByUuid
UILWTrainDepartureCtrl.ChangeMarchByType = ChangeMarchByType
UILWTrainDepartureCtrl.GetFormationBuildNameByIndex = GetFormationBuildNameByIndex
UILWTrainDepartureCtrl.NeedTakeArmy = NeedTakeArmy
UILWTrainDepartureCtrl.OnCheckTime = OnCheckTime
UILWTrainDepartureCtrl.OnCreateClick = OnCreateClick
UILWTrainDepartureCtrl.OnEditClick = OnEditClick
UILWTrainDepartureCtrl.GetCurSoldierNum = GetCurSoldierNum
UILWTrainDepartureCtrl.GetMaxCanAddSoldierNum = GetMaxCanAddSoldierNum
UILWTrainDepartureCtrl.ShowCost = ShowCost
UILWTrainDepartureCtrl.ShowExplorePower = ShowExplorePower
UILWTrainDepartureCtrl.GetExploreFormationPowerByUuidAndEventId = GetExploreFormationPowerByUuidAndEventId
UILWTrainDepartureCtrl.SetTimeIndex = SetTimeIndex
UILWTrainDepartureCtrl.GetRallyTimeList = GetRallyTimeList
UILWTrainDepartureCtrl.OnCreateMarchInGuide = OnCreateMarchInGuide
UILWTrainDepartureCtrl.GetCanGatherResourceNum = GetCanGatherResourceNum
UILWTrainDepartureCtrl.InitScoutData = InitScoutData
UILWTrainDepartureCtrl.GetAllScoutFormations = GetAllScoutFormations
UILWTrainDepartureCtrl.GetInvesFormationUnlockLv = GetInvesFormationUnlockLv
UILWTrainDepartureCtrl.GetInvesFormationInfoByIndex = GetInvesFormationInfoByIndex
UILWTrainDepartureCtrl.GetInvesDistance = GetInvesDistance
UILWTrainDepartureCtrl.GetScoutStartPoint = GetScoutStartPoint
UILWTrainDepartureCtrl.GetElecCost = GetElecCost
UILWTrainDepartureCtrl.StartInvestigate = StartInvestigate
UILWTrainDepartureCtrl.GetAllMarch = GetAllMarch
UILWTrainDepartureCtrl.GetFormationFormMaxNum = GetFormationFormMaxNum
UILWTrainDepartureCtrl.SetAttackTimes = SetAttackTimes
UILWTrainDepartureCtrl.CloseSelf = CloseSelf
UILWTrainDepartureCtrl.GetFormationItemData = GetFormationItemData
return UILWTrainDepartureCtrl
