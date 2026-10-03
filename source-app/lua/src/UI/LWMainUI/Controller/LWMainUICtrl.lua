local LWMainUICtrl = BaseClass("LWMainUICtrl", UIBaseCtrl)
local MainChatUtil = require("UI.LWMainUI.Controller.UIMainChatUtil")

local function CloseSelf(self)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Scene, false)
end

local function GetGoldNum(self)
  return LuaEntry.Player.gold
end

local function OnClickGoldBtn(self)
  SFSNetwork.SendMessage(MsgDefines.GMAddResourceMessage, 15, 100000)
end

local function GetResourceIconName(self, resourceType, mainUI)
  return DataCenter.ResourceManager:GetResourceIconByType(resourceType, nil, nil, mainUI)
end

local function OnClickResourceBtn(self, resourceType)
  if resourceType == ResourceType.BatteryPower then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPowerSource)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.GMAddResourceMessage, resourceType, 100000)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWResourceInfo, {anim = true}, resourceType)
  UIUtil.CheckEventTrigger(OpMode.ClickBtnResource, resourceType)
end

local function GetCntByResType(self, resourceType)
  if resourceType > ResourceType.Max and DataCenter.ItemTemplateManager:GetItemTemplate(resourceType) ~= nil then
    local item = DataCenter.ItemData:GetItemById(resourceType)
    if item ~= nil then
      return item.count
    end
    return 0
  end
  return LuaEntry.Resource:GetCntByResType(resourceType)
end

local function OnFunctionClick(self, type, ...)
  if not DataCenter.GuideManager:IsDragGuide() then
    if type == UIMainFunctionInfo.Alliance then
      if LuaEntry.Player:IsInAlliance() == false then
        if LuaEntry.Player:IsFirstJoinAlliance() == true then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
          return
        end
        local params = {guide = false}
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
      else
        local alData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
        if alData ~= nil then
          GoToUtil.GotoOpenView(UIWindowNames.UILWAlMain)
        end
      end
    elseif type == UIMainFunctionInfo.Trade then
    elseif type == UIMainFunctionInfo.Hero then
      local unlock, lockTips = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.MainUI_HeroBtn)
      if not unlock then
        UIUtil.ShowTipsId(lockTips)
        return
      end
      local UIHeroList = UIManager:GetInstance():GetWindow(UIWindowNames.UIHeroListPanel)
      if UIHeroList == nil then
        GoToUtil.GotoOpenView(UIWindowNames.UIHeroListPanel, {
          anim = false,
          UIMainAnim = UIMainAnimType.AllHide
        })
        local num = DataCenter.HeroDataManager:GetHeroRedNum()
        if 0 < num then
          DataCenter.HeroDataManager:MarkHeroRedPoint()
        end
      end
    elseif type == UIMainFunctionInfo.Goods then
      GoToUtil.GotoOpenView(UIWindowNames.UILWBagMain)
    elseif type == UIMainFunctionInfo.Mail then
      GoToUtil.GotoOpenView(UIWindowNames.UILWMailMain)
      CommonUtil.FeatureExplorationTrack(FeatureExplorationType.Mail)
    elseif type == UIMainFunctionInfo.Task then
    elseif type == UIMainFunctionInfo.Build then
      local guide1 = DataCenter.LWGuideFlowManager:ReadDone(4506)
      local guide2 = DataCenter.LWGuideFlowManager:ReadDone(4507)
      if guide1 and not guide2 then
        GoToUtil.GotoOpenView(UIWindowNames.UIBuildList, DataCenter.BuildManager:HaveRedDotBattleCenterBuilding())
      elseif SeasonUtil.IsOpenSeasonBuildInCity() then
        GoToUtil.GotoOpenView(UIWindowNames.UIBuildList)
      else
        GoToUtil.GotoOpenView(UIWindowNames.UIBuildList, DataCenter.BuildManager:GetFirstRedDotBuildingId())
      end
    elseif type == UIMainFunctionInfo.Info then
      GoToUtil.GotoOpenView(UIWindowNames.UILWPlayerDetail, LuaEntry.Player.uid, self:GetAccountTask())
      self:SetAccountTask(nil)
    elseif type == UIMainFunctionInfo.Chat then
      local roomId = (...) or ""
      local param = {}
      param.roomId = roomId
      self.isClickChat = true
      GoToUtil.OpenChatView(true, {anim = false}, param)
    elseif type == UIMainFunctionInfo.Position then
      GoToUtil.GotoOpenView(UIWindowNames.UIPositionFavorite)
    elseif type == UIMainFunctionInfo.Warning then
      GoToUtil.GotoOpenView(UIWindowNames.UIAllianceWarMainTable)
    elseif type == UIMainFunctionInfo.AllianceTaskShare then
      GoToUtil.GotoOpenView(UIWindowNames.UIAllianceTask)
    elseif type == UIMainFunctionInfo.Detect then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      })
    elseif type == UIMainFunctionInfo.VIP then
      GoToUtil.GotoOpenView(UIWindowNames.UIVip)
    end
  end
end

local function SetAccountTask(self, isArrow)
  self.accountTask = isArrow
end

local function GetAccountTask(self)
  return self.accountTask
end

local function InitVisibleState(self)
  if self.visible == nil then
    self.visible = DataCenter.GuideManager:IsCanDoUIMainAnim()
  end
end

local function SetVisibleState(self, visible)
  self.visible = visible
  if visible then
    EventManager:GetInstance():Broadcast(EventId.UIMainFlyReward)
  else
    EventManager:GetInstance():Broadcast(EventId.UIMainStopFlyReward)
  end
end

local function IsVisible(self)
  return self.visible
end

local function GetRedPotCountByType(self, type, param)
  local count = 0
  local rewardCount = 0
  local tipCount = 0
  if type == UIMainFunctionInfo.Hero then
    local unlock = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.MainUI_HeroBtn)
    if not unlock then
      return 0, 0, 0
    end
    tipCount = HeroRedPointManager:GetInstance():CheckCanShowRedPoint(HeroRedPointType.MainUI) and 1 or 0
    return tipCount, 0, tipCount
  elseif type == UIMainFunctionInfo.Mail then
    rewardCount = DataCenter.MailDataManager:GetMainUIUnRewardCount()
    tipCount = DataCenter.MailDataManager:GetMailUnReadCountAll()
    count = tipCount
  elseif type == UIMainFunctionInfo.Alliance then
    local isInSeason = SeasonUtil.IsInSeason(false)
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    rewardCount = DataCenter.AllianceGiftDataManager:GetGiftNum()
    tipCount = tipCount + DataCenter.AllianceScienceDataManager:GetAllianceScienceRedpointCount()
    tipCount = tipCount + DataCenter.AllianceWarDataManager:GetAllianceWarRed()
    tipCount = tipCount + DataCenter.AllianceWarDataManager:GetAlertNum()
    tipCount = tipCount + DataCenter.AllianceAlertDataManager:GetAlertNum()
    tipCount = tipCount + DataCenter.AllianceMemberDataManager:GetAllianceApplyRedCount()
    tipCount = tipCount + DataCenter.CommonShopManager:GetRedCount(CommonShopType.AllianceShop)
    tipCount = tipCount + DataCenter.SeasonFarmerManager:CountOfBuildReward()
    tipCount = tipCount + DataCenter.AllianceMilitaryPayDataManager:GetRedPointNum()
    tipCount = tipCount + DataCenter.CampScienceDataManager:GetRedPointNum()
    tipCount = tipCount + DataCenter.AllianceGovernmentCommonSkillManager:GetRedPointNum()
    if DataCenter.AllianceTaskManager:CheckIfAllianceTaskOpen() then
      tipCount = tipCount + DataCenter.AllianceTaskManager:GetTaskRedCount()
    end
    if DataCenter.AllianceSeasonTaskManager:CheckIfAllianceTaskOpen() then
      tipCount = tipCount + DataCenter.AllianceSeasonTaskManager:GetTaskRedCount()
    end
    if SeasonUtil.GetSeasonType() == SeasonMapType.Darkness and DataCenter.BloodyNightDataManager:IsBloodyNight() then
      tipCount = tipCount + DataCenter.AllianceWarDataManager:GetGhostTipNum()
    end
    if DataCenter.ActivityListDataManager:IsContainActivityGroup(CommonActivityGroupEnum.Alliance) then
      local num1, num2, num3 = DataCenter.ActivityListDataManager:GetActivityRedCountByGroupId(CommonActivityGroupEnum.Alliance)
      tipCount = tipCount + num3
      rewardCount = rewardCount + num2
    end
    if DataCenter.AllianceMineManager:IsAllianceCenterHasProduce() then
      tipCount = tipCount + 1
    end
    if isInSeason and SeasonUtil.CanAllianceMakeFriends(mySourceServerId) then
      local allyCombinedList = DataCenter.SeasonAllyFriendManager:GetAllyCombinedList()
      if allyCombinedList ~= nil then
        tipCount = tipCount + table.count(allyCombinedList.recList)
      end
      if DataCenter.SeasonAllyFriendManager.friendMarkDirty then
        tipCount = tipCount + 1
      end
      if tipCount == 0 then
        tipCount = DataCenter.SeasonAllyFriendManager:GetNewLogCount()
      end
    end
    count = tipCount + rewardCount
  elseif type == UIMainFunctionInfo.Detect then
    rewardCount = DataCenter.RadarCenterDataManager:GetFinishedDetectEventNum()
    count = rewardCount
    if rewardCount == 0 then
      tipCount = DataCenter.RadarCenterDataManager:GetCurEventNum()
      count = tipCount
    end
    local vipRewardCount = 0
    local vipManager = DataCenter.VipGiftActDataManager
    local showEntrance, activityInfo = vipManager:CanShowRadarEntrance()
    if showEntrance and activityInfo then
      local actId = tonumber(activityInfo.id)
      if actId and 0 < actId and vipManager:HasFreeReward(actId) then
        vipRewardCount = 1
      end
    end
    rewardCount = rewardCount + vipRewardCount
    count = count + vipRewardCount
  elseif type == UIMainFunctionInfo.Build then
    local inBuildNum = DataCenter.BuildManager:GetBuildRedDotByTabType(UIBuildListTabType.Economy)
    local outBuildNum = DataCenter.BuildManager:GetBuildRedDotByTabType(UIBuildListTabType.Military)
    local decorateNum = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.BuildListDecorate) and DataCenter.BuildManager:GetBuildRedDotByTabType(UIBuildListTabType.Decorate) or 0
    local seasonBuildNum = 0
    if SeasonUtil.IsOpenSeasonBuildInCity() then
      seasonBuildNum = DataCenter.BuildManager:GetBuildRedDotByTabType(UIBuildListTabType.SeasonCityBuild)
    end
    tipCount = inBuildNum + outBuildNum + decorateNum + seasonBuildNum
    count = tipCount
  elseif type == UIMainFunctionInfo.HeroDrop then
    tipCount = DataCenter.BuildHeroManager:GetNewHeroNum()
    count = tipCount
  elseif type == UIMainFunctionInfo.Visitor then
    tipCount = DataCenter.CityVisitorManager:GetAllVisitorCount()
    count = tipCount
  elseif type == UIMainFunctionInfo.Truck or type == UIMainFunctionInfo.Train then
    count = 0
    local states = DataCenter.LWMyStationDataManager:GetAllTruckStationState()
    for _, v in pairs(states) do
      if v == TruckStationState.Reward then
        count = count + 1
      end
    end
    rewardCount = count
    if rewardCount == 0 and type == UIMainFunctionInfo.Truck then
      local ready = DataCenter.LWMyStationDataManager:GetRealReadyCount()
      tipCount = ready
      count = tipCount
    end
  elseif type == UIMainFunctionInfo.Alarm then
    if LuaEntry.DataConfig:CheckSwitch("alarm_beta") then
      local alarmDataList = MarchUtil.GetaLlarmList()
      local curShowType = param
      local isScout = curShowType == MarchTargetType.SCOUT_CITY or curShowType == MarchTargetType.SCOUT_WINTER_STORM_CITY
      local isAssistance = curShowType == MarchTargetType.ASSISTANCE_CITY or curShowType == MarchTargetType.ASSISTANCE_WINTER_STORM_CITY
      for i = 1, #alarmDataList do
        local alarmDataMarchType = alarmDataList[i].march:GetMarchTargetType()
        if isScout or isAssistance then
          if alarmDataMarchType == curShowType then
            count = count + 1
          end
        else
          local isAttack = alarmDataMarchType ~= MarchTargetType.SCOUT_CITY and alarmDataMarchType ~= MarchTargetType.SCOUT_WINTER_STORM_CITY and alarmDataMarchType ~= MarchTargetType.ASSISTANCE_CITY and alarmDataMarchType ~= MarchTargetType.ASSISTANCE_WINTER_STORM_CITY
          if isAttack then
            count = count + 1
            local rallyData = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(alarmDataList[i].march.teamUuid)
            if rallyData then
              local memberList = table.values(rallyData.memberList)
              for j = 1, #memberList do
                local memberData = memberList[j]
                if memberData then
                  count = count + 1
                end
              end
            end
          end
        end
      end
    else
      local alarmDataList = MarchUtil.GetaLlarmList()
      for i = 1, #alarmDataList do
        if not alarmDataList[i].isMask then
          count = count + 1
        end
      end
    end
    local allEffectAlert = DataCenter.AllianceSkillManager:GetEffectAlert()
    if allEffectAlert then
      local now = UITimeManager:GetInstance():GetServerTime()
      for uuid, effect in pairs(allEffectAlert) do
        if effect and effect.mask_finish ~= true and effect.overTime ~= nil and now < effect.overTime and effect.skill_flag == AlOfficialSkillType.GuardianTower then
          count = count + 1
        end
      end
    end
    tipCount = count
  elseif type == UIMainFunctionInfo.DispatchTask then
    if LuaEntry.Player:IsInSourceServer() or DataCenter.ActDispatchTaskDataManager:IsCrossServerSwitchOpen() then
      local normal, rewardable = DataCenter.ActDispatchTaskDataManager:GetSingleTaskNormalCount()
      if DataCenter.ActDispatchTaskDataManager:GetMainUIRedPointShow() then
        tipCount = tipCount + normal
      end
      if DataCenter.ActDispatchTreasureManager:GetMainBtnRedPoint() then
        tipCount = tipCount + 1
      end
      local explorerTreasureCount = DataCenter.ExplorerTreasureManager:GetRedPointCount()
      rewardCount = rewardable
      tipCount = tipCount + DataCenter.ActGhostreconManager:GetMainBtnRedPoint() + explorerTreasureCount
      count = rewardCount + tipCount
    else
      tipCount = DataCenter.ActGhostreconManager:GetMainBtnRedPoint()
      count = tipCount
    end
  elseif type == UIMainFunctionInfo.Goods then
    local success, ret = pcall(function()
      return DataCenter.ItemData:GetItemsRedDotCount()
    end)
    if success then
      tipCount = ret
      count = tipCount
    end
  end
  return count, rewardCount, tipCount
end

local function IsRedPotShowByType(self, type)
  local num, rewardNum, tipNum = self:GetRedPotCountByType(type)
  local isShow = 0 < num
  return isShow, num, rewardNum or 0, tipNum or 0
end

local function GetRedPotShowTxtByType(self, type, num)
  if 0 < num then
    return num
  elseif type == UIMainFunctionInfo.Detect then
    local currentNum = DataCenter.RadarCenterDataManager:GetCurEventNum()
    return currentNum
  else
    return num
  end
end

local function GetAllMarch(self)
  local allMarch = {}
  local allianceId = LuaEntry.Player.allianceId
  local world = CS.SceneManager.World
  if world then
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
  end
  return allMarch
end

local function InitData(self)
  self.currentFormationUuid = 0
  self.formationType = 1
  self.targetType = -1
  self.targetPoint = -1
  self.targetUuid = 0
  self.timeIndex = -1
  self.autoBackHome = 1
  self.selectFormationUuid = 0
  if self.targetType > -1 then
    CS.SceneManager.World:AutoFocus(SceneUtils.TileIndexToWorld(pointIndex), CS.LookAtFocusState.Formation, LookAtFocusTime)
  end
  self.rallyType = nil
  self.RallyTimeList = {}
  local k1 = LuaEntry.DataConfig:TryGetStr("world_rally", "k1")
  local k2 = LuaEntry.DataConfig:TryGetStr("world_rally", "k2")
  local k3 = LuaEntry.DataConfig:TryGetStr("world_rally", "k3")
  local k4 = LuaEntry.DataConfig:TryGetStr("world_rally", "k4")
  self.RallyTimeList[1] = k1
  self.RallyTimeList[2] = k2
  self.RallyTimeList[3] = k3
  self.RallyTimeList[4] = k4
  self.isClickChat = false
end

local function GetRallyTimeList(self)
  return self.RallyTimeList
end

local function InitScoutData(self)
  self.InvesFormationUnlockLvs = {}
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.FUN_BUILD_RADAR_CENTER)
  if buildTemplate ~= nil then
    local vecPara1 = string.split(buildTemplate.para1, "|")
    for i, v in ipairs(vecPara1) do
      local ver1 = string.split(v, ";")
      if 2 <= #ver1 then
        self.InvesFormationUnlockLvs[tonumber(ver1[2])] = ver1[1]
      end
    end
  end
end

local function GetFormationListData(self)
  local oneData = {}
  oneData.curMarchNum = DataCenter.ArmyFormationDataManager:GetAlreadySetCountInArmyFormation()
  oneData.curFreeNum = DataCenter.ArmyFormationDataManager:GetFreeCountInArmyFormation()
  oneData.maxNum = FormationMaxNum
  oneData.list = DataCenter.ArmyFormationDataManager:GetArmyFormationIdList()
  return oneData
end

local function SetSelectFormationUuid(self, uuid)
  self.selectFormationUuid = uuid
end

local function GetTimeFormCurPosToTarPos(self, uuid)
  local data = self:GetFormationItemData(uuid)
  local speed = 1
  local distance = Vector3.Distance(SceneUtils.TileIndexToWorld(data.startPos), SceneUtils.TileIndexToWorld(self.targetPoint))
  if data.isMarch == 1 then
    speed = data.speed * CS.SceneManager.World.TileSize
  else
    local k1 = LuaEntry.DataConfig:TryGetNum("armyspeed", "k1")
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
      speed = CS.SceneManager.World.TileSize * k1 * (1 + addEffect / 100 + indexAdd / 100 + joinAddSpeed / 100 + joinRallyForBossSpeed)
    end
  end
  local time = distance / speed
  return time
end

local function OnEditClick(self, uuid, needAutoFix)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPVPFormation, {anim = true}, EnterHeroSquadPanelWay.MainUI, uuid)
end

local function OnCreateMarchInGuide(self, uuid, needAutoFix)
  local needFix = 0
  if needAutoFix == true then
    needFix = 1
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationTableNew, uuid, -1, -1, 0, -1, 1, 0, nil, needFix)
end

local function GetSelfUidArmyInfo(armyInfoList)
  local selfArmyInfo
  if not table.IsNullOrEmpty(armyInfoList) then
    table.walk(armyInfoList, function(k, v)
      if v.uid == LuaEntry.Player.uid then
        selfArmyInfo = v
      end
    end)
  end
  return selfArmyInfo
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
    oneData.startTime = 0
    oneData.endTime = 0
    oneData.speed = 1
    oneData.serverId = -1
    if march ~= nil then
      oneData.pointInfo = march.StationPointInfo
      oneData.power = self:GetFormationPowerByUuid(formation.uuid)
      oneData.isMarch = 1
      oneData.isAssistance = march:GetMarchStatus() == MarchStatus.ASSISTANCE or march:GetMarchStatus() == MarchStatus.TREASURE_DIGGING
      if march:GetMarchTargetType() == MarchTargetType.ALLIANCE_RESOURCE_COLLECT and march:GetMarchStatus() == MarchStatus.COLLECTING then
        oneData.isAssistance = true
      end
      if march:GetMarchType() == NewMarchType.ASSEMBLY_MARCH or march:GetMarchType() == NewMarchType.EXPLORE or march:GetMarchStatus() == MarchStatus.WAIT_RALLY or march:GetMarchStatus() == MarchStatus.IN_TEAM then
        oneData.canMove = true
      end
      if march:GetMarchStatus() == MarchStatus.IN_TEAM then
        local teamMarch = DataCenter.WorldMarchDataManager:GetAllianceMarchesInTeam(Player.allianceId, march.teamUuid)
        if teamMarch ~= nil then
          local selfTeamArmyInfo = GetSelfUidArmyInfo(teamMarch.armyInfos)
          local selfArmyInfo = GetSelfUidArmyInfo(march.armyInfos)
          if selfArmyInfo and not selfTeamArmyInfo then
            if type(teamMarch.armyInfos) == "table" then
              table.insert(teamMarch.armyInfos, selfArmyInfo)
            else
              teamMarch.armyInfos:Add(selfArmyInfo)
            end
          end
          march = teamMarch
        end
      end
      oneData.marchUuid = march.uuid
      oneData.targetUuid = march.targetUuid
      oneData.serverId = march.serverId
      oneData.worldId = march.worldId
      oneData.worldType = march:GetWorldType()
      oneData.isBattle = march.inBattle
      oneData.speed = 1
      oneData.ownerLightUuid = march.ownerLightUuid
      oneData.catchZombieNum = march.catchZombieNum
      if march:GetMarchStatus() == MarchStatus.DESTROY_WAIT then
        oneData.isBattle = true
      end
      if march:GetMarchStatus() == MarchStatus.CHASING or march:GetMarchStatus() == MarchStatus.MOVING or march:GetMarchStatus() == MarchStatus.IN_WORM_HOLE or march:GetMarchStatus() == MarchStatus.COLLECTING or march:GetMarchStatus() == MarchStatus.WAIT_RALLY or march:GetMarchStatus() == MarchStatus.IN_TEAM or march:GetMarchStatus() == MarchStatus.CROSS_SERVER then
        oneData.startTime = march.startTime
        oneData.endTime = march.endTime
      end
      local troop
      if SceneUtils.GetIsInWorld() then
        troop = CS.SceneManager.World:GetTroop(march.uuid)
      end
      if troop ~= nil then
        local point = SceneUtils.WorldToTileIndex(troop:GetPosition())
        oneData.startPos = point
      else
        oneData.startPos = SceneUtils.WorldToTileIndex(march:GetMarchCurPos())
      end
      oneData.stateImg = MarchUtil.GetMarchStateIconByType(march)
      oneData.stateTxt = MarchUtil.GetMarchStateTextByType(march)
      oneData.btnImg = MarchUtil.GetMarchBtnImgByType(march)
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
            table.insert(oneData.heroDataList, heroOneData)
          end
        end)
      end
      oneData.dominatorUuid = formation:GetDominatorUuid()
    else
    end
  end
  return oneData
end

function LWMainUICtrl:GetDisguiseFormationItemData(marchUuid)
  local oneData = {}
  oneData.uuid = 0
  oneData.index = 5
  oneData.canMove = false
  oneData.stamina = DataCenter.ArmyFormationDataManager:GetCurStaminaByUuid()
  local config = DataCenter.ArmyFormationDataManager:GetConfigData()
  if config ~= nil then
    oneData.maxStamina = config.FormationStaminaMax
  end
  local march = DataCenter.WorldMarchDataManager:GetMarch(marchUuid)
  oneData.isMarch = 0
  oneData.power = 0
  oneData.startPos = 0
  oneData.targetUuid = 0
  oneData.isBattle = false
  oneData.useForm = false
  oneData.startTime = 0
  oneData.endTime = 0
  oneData.speed = 1
  oneData.serverId = -1
  if march ~= nil then
    oneData.power = 0
    oneData.isMarch = 1
    oneData.isAssistance = march:GetMarchStatus() == MarchStatus.ASSISTANCE or march:GetMarchStatus() == MarchStatus.TREASURE_DIGGING
    if march:GetMarchTargetType() == MarchTargetType.ALLIANCE_RESOURCE_COLLECT and march:GetMarchStatus() == MarchStatus.COLLECTING then
      oneData.isAssistance = true
    end
    if march:GetMarchType() == NewMarchType.ASSEMBLY_MARCH or march:GetMarchType() == NewMarchType.EXPLORE or march:GetMarchStatus() == MarchStatus.WAIT_RALLY or march:GetMarchStatus() == MarchStatus.IN_TEAM then
      oneData.canMove = true
    end
    oneData.marchUuid = march.uuid
    oneData.targetUuid = march.targetUuid
    oneData.serverId = march.serverId
    oneData.worldId = march.worldId
    oneData.worldType = march:GetWorldType()
    oneData.isBattle = march.inBattle
    oneData.speed = 1
    if march:GetMarchStatus() == MarchStatus.DESTROY_WAIT then
      oneData.isBattle = true
    end
    if march:GetMarchStatus() == MarchStatus.CHASING or march:GetMarchStatus() == MarchStatus.MOVING or march:GetMarchStatus() == MarchStatus.IN_WORM_HOLE or march:GetMarchStatus() == MarchStatus.COLLECTING or march:GetMarchStatus() == MarchStatus.WAIT_RALLY or march:GetMarchStatus() == MarchStatus.IN_TEAM or march:GetMarchStatus() == MarchStatus.CROSS_SERVER then
      oneData.startTime = march.startTime
      oneData.endTime = march.endTime
    end
    local troop
    if SceneUtils.GetIsInWorld() then
      troop = CS.SceneManager.World:GetTroop(march.uuid)
    end
    if troop ~= nil then
      local point = SceneUtils.WorldToTileIndex(troop:GetPosition())
      oneData.startPos = point
    else
      oneData.startPos = SceneUtils.WorldToTileIndex(march:GetMarchCurPos())
    end
    oneData.stateImg = MarchUtil.GetMarchStateIconByType(march)
    oneData.stateTxt = MarchUtil.GetMarchStateTextByType(march)
    oneData.btnImg = MarchUtil.GetMarchBtnImgByType(march)
    oneData.maxhp = march:GetMaxHP()
    oneData.hp = march:GetHP()
    oneData.heroDataList = {}
    oneData.dominatorUuid = nil
  end
  return oneData
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

local function IsExistMarchInvesFormation(self)
  local list = DataCenter.ArmyFormationDataManager:GetInvestigateFormationList()
  for k, v in pairs(list) do
    if v.state == 1 then
      return true
    end
  end
  return false
end

local function GetFormationPowerByUuid(self, formationUuid)
  local totalPower = 0
  local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(formationUuid)
  if formation ~= nil then
    totalPower = MarchUtil.GetFormationPower(formation.heroes, formation.soldiers, formation.index, MarchUtil.GetCampAddParam(formation.heroes))
  end
  return totalPower
end

local function OnClickSearchBtn(self)
  GoToUtil.GotoOpenView(UIWindowNames.UISearch)
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

local function OnClickBackHomeBtn(self, targetPos)
  if UIManager:GetInstance():IsWindowOpen("UIFarm") then
    UIManager:GetInstance():DestroyWindow("UIFarm")
  end
  if UIManager:GetInstance():IsWindowOpen("UIFarmGather") then
    UIManager:GetInstance():DestroyWindow("UIFarmGather")
  end
  local selfServerId = LuaEntry.Player:GetSelfServerId()
  if targetPos == nil then
    targetPos = SceneUtils.TileIndexToWorld(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World, selfServerId)
  end
  local world = CS.SceneManager.World
  self.selectFormationUuid = 0
  if world then
    world:StopCameraMove()
    GoToUtil.GotoPos(targetPos, world.Zoom, 0.1, nil, selfServerId, 0)
  else
    GoToUtil.GotoPos(targetPos, nil, 0.1, nil, selfServerId, 0)
  end
end

local function OnClickJumpOtherPlayerBtn(self, targetPos, targetServerId)
  if UIManager:GetInstance():IsWindowOpen("UIFarm") then
    UIManager:GetInstance():DestroyWindow("UIFarm")
  end
  if UIManager:GetInstance():IsWindowOpen("UIFarmGather") then
    UIManager:GetInstance():DestroyWindow("UIFarmGather")
  end
  local serverId = targetServerId or LuaEntry.Player:GetSelfServerId()
  if targetPos == nil then
    targetPos = SceneUtils.TileIndexToWorld(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World, serverId)
  end
  local world = CS.SceneManager.World
  self.selectFormationUuid = 0
  if world then
    world:StopCameraMove()
    GoToUtil.GotoPos(targetPos, world.Zoom, 0.1, nil, serverId, 0)
  else
    GoToUtil.GotoPos(targetPos, nil, 0.1, nil, serverId, 0)
  end
end

local function ShowExplorePower(self, marchTargetType)
  return marchTargetType == MarchTargetType.EXPLORE
end

local function InitAnim(self, viewTrans)
  self.animComps = {}
  self.animTweens = {}
  if IsNull(viewTrans) then
    return
  end
  local animBook = require("UI.LWMainUI.Controller.LWMainUIAnimBook")
  local tCanvas = typeof(CS.UnityEngine.Canvas)
  for flag, entries in pairs(animBook) do
    self.animComps[flag] = {}
    self.animTweens[flag] = {}
    for _, entry in ipairs(entries) do
      local comp = viewTrans:Find(entry.path)
      if comp then
        local animComp = {trans = comp, cfg = entry}
        local x, y = comp:Get_anchoredPosition()
        animComp.origPos = Vector2(x, y)
        local canvas = comp:GetComponent(tCanvas)
        if not IsNull(canvas) then
          animComp.canvas = canvas
        end
        table.insert(self.animComps[flag], animComp)
      end
    end
  end
end

local function PlayAnim(self, mask, isShow)
  if not self.animComps then
    return
  end
  for flag, comps in pairs(self.animComps) do
    if BitOps.And(flag, mask) > 0 then
      if self.animTweens then
        local oldTweens = self.animTweens[flag]
        if oldTweens then
          for _, tween in ipairs(oldTweens) do
            if not IsNull(tween) then
              tween:Kill()
            end
          end
        end
        self.animTweens[flag] = {}
      end
      for _, comp in ipairs(comps) do
        if comp.trans then
          if isShow then
            comp.trans:Set_anchoredPosition(comp.cfg.hidePos.x, comp.cfg.hidePos.y)
            if comp.canvas then
              comp.canvas.enabled = true
            end
          else
            comp.trans:Set_anchoredPosition(comp.origPos.x, comp.origPos.y)
          end
          local tween = comp.trans:DOAnchorPos(isShow and comp.origPos or comp.cfg.hidePos, comp.cfg.duration):SetDelay(comp.cfg.delay):SetEase(comp.cfg.ease)
          local _c = comp
          if comp.canvas and not isShow then
            tween:OnComplete(function()
              _c.canvas.enabled = false
            end)
          end
          table.insert(self.animTweens[flag], tween)
        end
      end
    end
  end
end

local function GetIsShowHeroBubble()
  if SceneUtils.GetIsInCity() then
    local minLevel = LuaEntry.DataConfig:TryGetNum("hero_up_guide_level", "k1")
    local maxLevel = LuaEntry.DataConfig:TryGetNum("hero_up_guide_level", "k2")
    minLevel = minLevel and minLevel or 1
    maxLevel = maxLevel and maxLevel or 5
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
    if buildData and minLevel <= buildData.level and maxLevel >= buildData.level then
      return true
    end
  end
end

local function GetUpLevelHero()
  if not GetIsShowHeroBubble() then
    return
  end
  local allHeroes = DataCenter.HeroDataManager:GetAllHeroList()
  local heroList = {}
  for _, hero in pairs(allHeroes) do
    local idx = DataCenter.ArmyFormationDataManager:GetHeroSquadIndex(hero.uuid)
    if idx ~= nil then
      local expCount = DataCenter.ResourceItemDataManager:GetHeroExpCount()
      if hero:ShowUpGradeRedPoint(expCount) then
        table.insert(heroList, hero)
      end
    end
  end
  if #heroList == 0 then
    return nil
  end
  if #heroList == 1 then
    return heroList[1]
  end
  table.sort(heroList, function(a, b)
    if a.quality > b.quality then
      return true
    end
    if a.quality == b.quality and a.heroId < b.heroId then
      return true
    end
  end)
  return heroList[1]
end

local function GetActivityCenterBtnShow(self)
  local unlock = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.MainUI_Activity)
  local unlockLevel = LuaEntry.DataConfig:TryGetNum("funcion_on_config", "k3")
  if unlock and unlockLevel >= DataCenter.BuildManager.MainLv then
    local retGroups = DataCenter.ActivityListDataManager:GetActivityCenterGroupList()
    unlock = retGroups and table.count(retGroups) > 0
  end
  return unlock
end

local function GetChatBubble(ChatData)
  return MainChatUtil.GetBubble(ChatData)
end

local function GetShowBubbleInfo()
  return MainChatUtil.GetShowBubbleInfo()
end

local function GetIsTreasure(chatData)
  return MainChatUtil.GetIsTreasure(chatData)
end

local function GetCureBtnTextSetting(self, progress)
  if self.cureBtnTextSettings == nil then
    self.cureBtnTextSettings = {}
    local cfg = LuaEntry.DataConfig:TryGetStr("hospital_warning", "k4")
    if not string.IsNullOrEmpty(cfg) then
      local split1 = string.split(cfg, "|")
      for i, v in ipairs(split1) do
        local split2 = string.split(v, ";")
        local data = {}
        data.min = tonumber(split2[1])
        data.max = tonumber(split2[2])
        data.color = split2[3]
        data.showAnim = split2[4] == "1"
        table.insert(self.cureBtnTextSettings, data)
      end
    end
  end
  for i, v in ipairs(self.cureBtnTextSettings) do
    if progress >= v.min and progress <= v.max then
      return v
    end
  end
  return nil
end

function LWMainUICtrl:GetNonChatBubble()
  return MainChatUtil.GetNonChatBubble()
end

LWMainUICtrl.CloseSelf = CloseSelf
LWMainUICtrl.Close = Close
LWMainUICtrl.GetGoldNum = GetGoldNum
LWMainUICtrl.OnClickGoldBtn = OnClickGoldBtn
LWMainUICtrl.GetResourceIconName = GetResourceIconName
LWMainUICtrl.OnClickResourceBtn = OnClickResourceBtn
LWMainUICtrl.GetCntByResType = GetCntByResType
LWMainUICtrl.OnFunctionClick = OnFunctionClick
LWMainUICtrl.SetAccountTask = SetAccountTask
LWMainUICtrl.GetAccountTask = GetAccountTask
LWMainUICtrl.GetRedPotCountByType = GetRedPotCountByType
LWMainUICtrl.IsRedPotShowByType = IsRedPotShowByType
LWMainUICtrl.GetRedPotShowTxtByType = GetRedPotShowTxtByType
LWMainUICtrl.InitVisibleState = InitVisibleState
LWMainUICtrl.SetVisibleState = SetVisibleState
LWMainUICtrl.IsVisible = IsVisible
LWMainUICtrl.OnClickSearchBtn = OnClickSearchBtn
LWMainUICtrl.ShowExplorePower = ShowExplorePower
LWMainUICtrl.GetAllMarch = GetAllMarch
LWMainUICtrl.InitData = InitData
LWMainUICtrl.GetRallyTimeList = GetRallyTimeList
LWMainUICtrl.InitScoutData = InitScoutData
LWMainUICtrl.GetFormationListData = GetFormationListData
LWMainUICtrl.SetSelectFormationUuid = SetSelectFormationUuid
LWMainUICtrl.GetTimeFormCurPosToTarPos = GetTimeFormCurPosToTarPos
LWMainUICtrl.OnEditClick = OnEditClick
LWMainUICtrl.OnCreateMarchInGuide = OnCreateMarchInGuide
LWMainUICtrl.GetFormationItemData = GetFormationItemData
LWMainUICtrl.GetFormationBuildNameByIndex = GetFormationBuildNameByIndex
LWMainUICtrl.GetInvesFormationInfoByIndex = GetInvesFormationInfoByIndex
LWMainUICtrl.IsExistMarchInvesFormation = IsExistMarchInvesFormation
LWMainUICtrl.GetFormationPowerByUuid = GetFormationPowerByUuid
LWMainUICtrl.GetAllScoutFormations = GetAllScoutFormations
LWMainUICtrl.OnClickBackHomeBtn = OnClickBackHomeBtn
LWMainUICtrl.OnClickJumpOtherPlayerBtn = OnClickJumpOtherPlayerBtn
LWMainUICtrl.InitAnim = InitAnim
LWMainUICtrl.PlayAnim = PlayAnim
LWMainUICtrl.GetUpLevelHero = GetUpLevelHero
LWMainUICtrl.GetActivityCenterBtnShow = GetActivityCenterBtnShow
LWMainUICtrl.GetChatBubble = GetChatBubble
LWMainUICtrl.GetShowBubbleInfo = GetShowBubbleInfo
LWMainUICtrl.GetIsTreasure = GetIsTreasure
LWMainUICtrl.GetCureBtnTextSetting = GetCureBtnTextSetting
return LWMainUICtrl
