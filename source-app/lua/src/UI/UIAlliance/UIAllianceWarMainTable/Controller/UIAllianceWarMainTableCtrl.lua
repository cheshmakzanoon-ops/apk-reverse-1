local AllianceWarItemShow = {
  leftName = "",
  rightName = "",
  leftPointId = 0,
  rightPointId = 0,
  leftDistance = 0,
  isAttack = false,
  cancel = false,
  join = false,
  inTeam = false,
  inMarch = false,
  currentSoldiers = 0,
  maxSoldiers = 0,
  waitTime = 0,
  createTime = 0,
  marchTime = 0,
  targetUuid = 0
}
local OneData = DataClass("OneData", AllianceWarItemShow)
local UIAllianceWarMainTableCtrl = BaseClass("UIAllianceWarMainTableCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  DataCenter.AllianceWarDataManager:CloseALWarMain()
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function InitData(self)
  SFSNetwork.SendMessage(MsgDefines.GetAllianceWarList, LuaEntry.Player:GetCurServerId())
end

local function GetWarDataDuration(wallData, curTime)
  if wallData then
    return -1
  end
  local curTimeS = math.modf(curTime / 1000)
  local waitTimeS = math.modf(wallData.waitTime / 1000)
  local marchTimeS = math.modf(wallData.marchTime / 1000)
  if curTimeS < waitTimeS then
    return true
  elseif curTimeS < marchTimeS then
    return true
  else
    return false
  end
end

local function SortWarList(a, b)
  if a.canJoin == b.canJoin then
    return a.duration < b.duration
  else
    return a.canJoin
  end
end

function UIAllianceWarMainTableCtrl:GetSortWarKeys(force)
  local mgr = DataCenter.AllianceWarDataManager
  local allWarList = mgr:GetAllianceData()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.lastWarList = force and {} or self.lastWarList or {}
  local list = {}
  local changedCount = 0
  local changedTab
  for key, warData in pairs(allWarList) do
    local marchDuration = mgr:GetAllianceWarDurationSec(warData, curTime)
    if marchDuration < 0 then
    else
      local data = {}
      data.key = key
      data.duration = marchDuration
      data.canJoin = mgr:CheckJoinAllianceWarByWarData(warData)
      if force then
        table.insert(list, data)
        self.lastWarList[key] = data
      else
        local last = self.lastWarList[key]
        changedTab = changedTab or {}
        if last then
          table.insert(list, data)
        else
          changedTab[key] = true
          changedCount = changedCount + 1
        end
      end
    end
  end
  if 0 < changedCount then
    changedTab.count = changedCount
  end
  self.lastWarList.count = #list
  table.sort(list, SortWarList)
  local rst = {}
  for k, v in ipairs(list) do
    table.insert(rst, v.key)
  end
  return rst, changedTab
end

local function GetAllianceWarIdList(self, index, arrowUuid, force)
  local list = {}
  if index == 1 then
    return self:GetWarEventsList()
  elseif index == 2 then
    return self:GetSortWarKeys(force)
  elseif index == 3 then
    list = DataCenter.AllianceAlertDataManager:GetAllianceAlertList()
    if arrowUuid ~= nil and table.hasvalue(list, arrowUuid) then
      table.removebyvalue(list, arrowUuid)
      table.insert(list, 1, arrowUuid)
    end
    local allEffectAlert = DataCenter.AllianceSkillManager:GetEffectAlert()
    if allEffectAlert then
      local now = UITimeManager:GetInstance():GetServerTime()
      for uuid, effect in pairs(allEffectAlert) do
        if effect and effect.mask_finish ~= true then
          if now < effect.activeTime then
            table.insert(list, effect)
          elseif effect.skill_flag ~= AlOfficialSkillType.GuardianTower then
            effect.mask_finish = true
          end
        end
      end
    end
  end
  return list
end

local function GetPersonalList(self)
  self.personalList = {}
  local virtualAllianceMemberList = DataCenter.AllianceHelpVirtualMarchManager:GetVirtualMemberList()
  for i = 1, #virtualAllianceMemberList do
    table.insert(self.personalList, virtualAllianceMemberList[i])
  end
  local allianceList = DataCenter.AllianceWarDataManager:GetAllianceWarIdList()
  for i = 1, #allianceList do
    local info = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(allianceList[i])
    if info.targetUid == LuaEntry.Player:GetUid() then
      table.insert(self.personalList, allianceList[i])
    end
  end
  local personalList = DataCenter.RadarAlarmDataManager:GetAllMarches()
  for _, v in pairs(personalList) do
    local temp = DataCenter.AllianceWarDataManager:GetWarningType(v)
    if temp == WarningType.Attack or temp == WarningType.Scout or temp == WarningType.Assistance then
      table.insert(self.personalList, v)
    end
  end
  local crossServer = DataCenter.AllianceWarDataManager:GetCrossServer()
  if crossServer and next(crossServer) then
    for i = 1, #crossServer do
      if crossServer[i] ~= LuaEntry.Player:GetCurServerId() then
        table.insert(self.personalList, {
          serverId = crossServer[i],
          isCross = true
        })
      end
    end
  end
  return self.personalList
end

local function HasChange(self, uuid, updateTime)
  local data = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(uuid)
  if data then
    return data.updateTime ~= updateTime
  end
  return true
end

local function GetWarItemData(self, uuid, splitNameLv)
  local oneData = OneData.New()
  local data = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(uuid)
  if data ~= nil then
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(data.attackUid, data.attackName)
    oneData.leftName = "[" .. data.attackAllianceAbbr .. "]" .. showName
    if data.targetAllianceAbbr ~= nil and data.targetAllianceAbbr ~= "" then
      oneData.rightName = "[" .. data.targetAllianceAbbr .. "]" .. data.targetName
    else
      oneData.rightName = data.targetName
    end
    oneData.serverId = data.server
    oneData.worldId = data.worldId
    oneData.worldType = data.worldType
    oneData.leftPointId = data.attackPointId
    oneData.rightPointId = data.targetPointId
    oneData.currentSoldiers = data.currentSoldiers
    oneData.maxSoldiers = data.maxSoldiers
    oneData.waitTime = data.waitTime
    oneData.marchTime = data.marchTime
    oneData.createTime = data.createTime
    oneData.type = data.type
    oneData.targetUid = data.targetUid
    oneData.targetIcon = data.targetIcon
    oneData.targetIconVer = data.targetIconVer
    oneData.targetHeadBg = data.leaderMarch:GetHeadBgImg()
    oneData.assemblyMarchMax = data.assemblyMarchMax
    oneData.canJoinNum = 1
    oneData.attackUid = data.attackUid
    oneData.attackIcon = data.leaderMarch.ownerIcon
    oneData.ownerIconVer = data.leaderMarch.ownerIconVer
    oneData.ownerHeadBg = data.leaderMarch:GetHeadBgImg()
    oneData.targetUuid = data.targetUuid
    oneData.targetContentId = data.targetContentId
    oneData.leaderMarchUuid = data.leaderMarch.uuid
    oneData.leaderRank = data.leaderRank
    oneData.leaderOffical = data.leaderOffical
    oneData.bossHP = data.bossHp
    oneData.updateTime = data.updateTime
    if next(data.memberList) then
      for i, v in pairs(data.memberList) do
        oneData.canJoinNum = oneData.canJoinNum + 1
      end
      oneData.canJoinNum = oneData.canJoinNum
    end
    oneData.rightHead = nil
    if oneData.type == AllianceTeamType.ATTACK_AL_CENTER and oneData.targetContentId then
      local mineTemplate = DataCenter.AllianceMineManager:GetAllianceMineTemplate(oneData.targetContentId)
      if mineTemplate ~= nil then
        local buildId = toInt(oneData.targetContentId)
        oneData.isSeasonPlayerBuilding = true
        oneData.rightName = Localization:GetString(mineTemplate.name)
        oneData.rightHead = mineTemplate:GetIconPath()
      end
    elseif oneData.type == AllianceTeamType.ATTACK_BOSS then
      local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(oneData.targetUid)
      if splitNameLv then
        oneData.rightName = Localization:GetString(monster.name)
        oneData.rightLv = Localization:GetString("300665", monster.level)
      else
        oneData.rightName = Localization:GetString("300665", monster.level) .. Localization:GetString(monster.name)
      end
      oneData.rightHead = UIUtil.GetFullPath(LoadPath.HeroIconsBigPath, monster.pic)
      oneData.monsterSpecialType = monster.special
    elseif oneData.type == AllianceTeamType.ATTACK_AL_CITY then
      local name = data.targetName
      local dataConfig = DataCenter.AllianceCityTemplateManager:GetTemplate(data.targetContentId)
      if name == nil or name == "" then
        name = dataConfig:GetName()
      end
      oneData.rightName = Localization:GetString("310161", name, dataConfig.level)
      oneData.rightHead = dataConfig:GetIconPath(data.targetAllianceAbbr == nil or data.targetAllianceAbbr == "")
    elseif oneData.type == AllianceTeamType.ATTACK_CITY then
      local targetBaseSkinId = data.targetBaseSkinId
      if targetBaseSkinId and 0 < targetBaseSkinId then
        local template = DataCenter.DecorationTemplateManager:GetTemplate(targetBaseSkinId)
        if template then
          oneData.rightHead = template.img
          oneData.rightHeadScale = 1.3
        end
      end
      if oneData.rightHead == nil then
        local targetLevel = data.targetLevel or 0
        local meta = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.FUN_BUILD_MAIN, targetLevel)
        if meta ~= nil then
          oneData.rightHead = meta:GetBuildIconOutCity()
        end
      end
      if oneData.rightHead == nil then
        oneData.rightHead = "Assets/Main/Sprites/BuildIconOutCity/A_build_daben_D"
      end
    elseif oneData.type == AllianceTeamType.ATTACK_EPIDEMIC_CITY then
      local targetBaseSkinId = data.targetBaseSkinId
      if targetBaseSkinId and 0 < targetBaseSkinId then
        local template = DataCenter.DecorationTemplateManager:GetTemplate(targetBaseSkinId)
        if template then
          oneData.rightHead = template.img
          oneData.rightHeadScale = 1.3
        end
      end
      if oneData.rightHead == nil then
        local targetLevel = data.targetLevel or 0
        local meta = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.FUN_BUILD_MAIN, targetLevel)
        if meta ~= nil then
          oneData.rightHead = meta:GetBuildIconOutCity()
        end
      end
      if oneData.rightHead == nil then
        oneData.rightHead = "Assets/Main/Sprites/BuildIconOutCity/A_build_daben_D"
      end
    elseif oneData.type == AllianceTeamType.ATTACK_BUILDING and oneData.targetContentId then
      local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(oneData.targetContentId)
      if buildTemplate ~= nil and buildTemplate.tab_type == UIBuildListTabType.SeasonBuild then
        local buildId = toInt(oneData.targetContentId)
        local level = buildId % 1000
        oneData.isSeasonPlayerBuilding = true
        oneData.rightName = Localization:GetString("310161", Localization:GetString(buildTemplate.name), level)
        oneData.rightHead = DataCenter.BuildManager:GetBuildIconPath(buildId, level)
      end
    elseif oneData.type == AllianceTeamType.ATTACK_DRAGON_BUILDING then
      local info = CS.SceneManager.World:GetPointInfo(data.targetPointId)
      if info ~= nil and info.detail ~= nil then
        local detailInfo = info.detail
        local buildId = detailInfo.BuildId or detailInfo.ItemId
        local template = DataCenter.DragonBuildTemplateManager:GetTemplate(buildId)
        if template then
          oneData.rightHead = template:GetDetailPath()
          oneData.rightName = Localization:GetString(template.name)
        end
      else
        local template = DataCenter.DragonBuildTemplateManager:GetTemplateByIndex(data.targetPointId)
        if template then
          oneData.rightHead = template:GetDetailPath()
          oneData.rightName = Localization:GetString(template.name)
        end
      end
    elseif oneData.type == AllianceTeamType.ATTACK_EPIDEMIC_BUILDING then
      local info = CS.SceneManager.World:GetPointInfo(data.targetPointId)
      if info ~= nil and info.detail ~= nil then
        local detailInfo = info.detail
        local buildId = detailInfo.BuildId or detailInfo.ItemId
        local template = BattleFieldUtil.GetBattlefieldBuildTemplate(buildId)
        if template then
          oneData.rightHead = template:GetRulesIconPath()
          oneData.rightName = Localization:GetString(template.name)
        end
      else
        local template = DataCenter.EpidemicBuildTemplateMgr:GetTemplateByIndex(data.targetPointId)
        if template then
          oneData.rightHead = template:GetRulesIconPath()
          oneData.rightName = Localization:GetString(template.name)
        end
      end
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    oneData.inMarch = curTime > data.marchTime and curTime > data.waitTime
    local mainIndex = LuaEntry.Player:GetMainWorldPos()
    local selfAllianceId = LuaEntry.Player.allianceId
    local selfUid = LuaEntry.Player.uid
    oneData.isAttack = selfAllianceId ~= data.attackAllianceId
    oneData.cancel = selfUid == data.attackUid
    oneData.isSelfAttack = selfUid == data.targetUid
    oneData.rightDistance = 0
    oneData.leftDistance = 0
    local bAttacked = data.targetAllianceId == selfAllianceId
    if BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) then
      oneData.isAttack = BattleFieldUtil.IsBattleFieldEnemy(data.attackAllianceId, BattleFieldType.EpidemicZone)
      bAttacked = not BattleFieldUtil.IsBattleFieldEnemy(data.targetAllianceId, BattleFieldType.EpidemicZone)
    end
    if mainIndex ~= nil and mainIndex ~= -1 and mainIndex ~= 0 then
      if oneData.isSelfAttack then
        local enemyPos = SceneUtils.IndexToTilePos(oneData.leftPointId, ForceChangeScene.World)
        oneData.rightDistance = math.ceil(SceneUtils.TileDistance(enemyPos, SceneUtils.IndexToTilePos(mainIndex, ForceChangeScene.World)))
      elseif not oneData.isSelfAttack and bAttacked then
        local allyPos = SceneUtils.IndexToTilePos(oneData.rightPointId, ForceChangeScene.World)
        oneData.leftDistance = math.ceil(SceneUtils.TileDistance(allyPos, SceneUtils.IndexToTilePos(mainIndex, ForceChangeScene.World)))
        local enemyPos = SceneUtils.IndexToTilePos(oneData.leftPointId, ForceChangeScene.World)
        oneData.rightDistance = math.ceil(SceneUtils.TileDistance(enemyPos, SceneUtils.IndexToTilePos(mainIndex, ForceChangeScene.World)))
      elseif oneData.cancel then
        local enemyPos = SceneUtils.IndexToTilePos(oneData.rightPointId, ForceChangeScene.World)
        oneData.rightDistance = math.ceil(SceneUtils.TileDistance(enemyPos, SceneUtils.IndexToTilePos(mainIndex, ForceChangeScene.World)))
      elseif not oneData.cancel and not oneData.isAttack then
        local allyPos = SceneUtils.IndexToTilePos(oneData.leftPointId, ForceChangeScene.World)
        oneData.leftDistance = math.ceil(SceneUtils.TileDistance(allyPos, SceneUtils.IndexToTilePos(mainIndex, ForceChangeScene.World)))
        local enemyPos = SceneUtils.IndexToTilePos(oneData.rightPointId, ForceChangeScene.World)
        oneData.rightDistance = math.ceil(SceneUtils.TileDistance(enemyPos, SceneUtils.IndexToTilePos(mainIndex, ForceChangeScene.World)))
      end
    end
    local canJoin = false
    local inTeam = false
    if oneData.cancel == false and oneData.isAttack == false then
      local count = table.count(data.memberList)
      if count < data.assemblyMarchMax then
        canJoin = true
        table.walk(data.memberList, function(k, v)
          if v.ownerUid == selfUid then
            inTeam = true
            canJoin = false
          end
        end)
      end
    end
    oneData.waitMemberTime = data.waitMemberTime
    oneData.teamUuid = data.leaderMarch.teamUuid
    oneData.join = canJoin
    oneData.inTeam = inTeam
    oneData.uuid = uuid
    oneData.isAlliance = true
    oneData.fixedSoldierType = data.fixedSoldierType
    oneData.teamHasLight = not not data.teamHasLight
    oneData.marchendTime = data.leaderMarch.endTime
  end
  return oneData
end

local function GetPersonalItemData(self, ownerFormationUuid)
  local data
  for i, v in pairs(self.personalList) do
    if type(v) ~= "number" and v.ownerFormationUuid == ownerFormationUuid then
      data = v
      break
    end
  end
  if not data then
    return
  end
  local oneData = {}
  data.allianceAbbr = data.allianceAbbr or ""
  if data.allianceAbbr == "" then
    oneData.leftName = data.ownerName
  else
    oneData.leftName = "[" .. data.allianceAbbr .. "]" .. data.ownerName
  end
  oneData.serverId = data.serverId
  oneData.attackUid = data.ownerUid
  oneData.attackIcon = data.pic
  oneData.ownerIconVer = data.picVer
  oneData.rightPointId = data.targetPos
  oneData.ownerHeadBg = data:GetHeadBgImg()
  local marchTargetType = data:GetMarchTargetType()
  if marchTargetType == MarchTargetType.RALLY_FOR_BUILDING or marchTargetType == MarchTargetType.ATTACK_BUILDING or marchTargetType == MarchTargetType.ATTACK_CITY or marchTargetType == MarchTargetType.ATTACK_WINTER_STORM_CITY or marchTargetType == MarchTargetType.ATTACK_EPIDEMIC_CITY or marchTargetType == MarchTargetType.SCOUT_BUILDING or marchTargetType == MarchTargetType.ASSISTANCE_CITY or marchTargetType == MarchTargetType.ASSISTANCE_WINTER_STORM_CITY or marchTargetType == MarchTargetType.ASSISTANCE_EPIDEMIC_CITY or marchTargetType == MarchTargetType.ASSISTANCE_BUILD or marchTargetType == MarchTargetType.SCOUT_CITY or marchTargetType == MarchTargetType.SCOUT_WINTER_STORM_CITY or marchTargetType == MarchTargetType.SCOUT_EPIDEMIC_CITY then
    local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(data.targetUuid)
    if buildingData ~= nil then
      local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildingData.itemId)
      oneData.rightName = Localization:GetString(buildTemplate.name)
    end
  elseif marchTargetType == MarchTargetType.ATTACK_ROAD then
    if DataCenter.BoardManager:GetBoardData(data.targetUuid) ~= nil then
      oneData.rightName = Localization:GetString("100308")
    end
  elseif marchTargetType == MarchTargetType.ATTACK_ARMY or marchTargetType == MarchTargetType.ATTACK_ARMY_COLLECT or marchTargetType == MarchTargetType.SCOUT_TROOP then
    oneData.rightName = Localization:GetString("110020")
  end
  oneData.uuid = data.uuid
  oneData.endTime = data.endTime
  if marchTargetType == MarchTargetType.SCOUT_BUILDING or marchTargetType == MarchTargetType.SCOUT_CITY or marchTargetType == MarchTargetType.SCOUT_WINTER_STORM_CITY or marchTargetType == MarchTargetType.SCOUT_EPIDEMIC_CITY or marchTargetType == MarchTargetType.SCOUT_ARMY_COLLECT then
    oneData.soldierNum = ""
  else
    oneData.soldierNum = Localization:GetString("310160", string.GetFormattedSeperatorNum(data:GetSoliderNum()))
  end
  oneData.ownerFormationUuid = ownerFormationUuid
  oneData.type = DataCenter.AllianceWarDataManager:GetWarningType(data)
  oneData.status = data:GetMarchStatus()
  oneData.isAlliance = false
  return oneData
end

local function OnClickPosBtn(self, pos, isV3, marchUuid, serverId, worldId, worldType)
  if not SceneUtils.CheckCanGotoWorld() then
    return
  end
  if pos ~= 0 then
    self:Close()
    EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
    if isV3 then
      GoToUtil.GotoWorldPos(pos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
        if marchUuid then
          CS.SceneManager.World.marchUuid = marchUuid
          CS.SceneManager.World:TrackMarch(marchUuid)
          WorldMarchTileUIManager:GetInstance():ShowTroop(marchUuid)
        end
      end, serverId, worldId, worldType)
    else
      GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pos, ForceChangeScene.World), CS.SceneManager.World.InitZoom, LookAtFocusTime, nil, serverId, worldId, worldType)
    end
  end
end

local function OnOpenClick(self, param, state, helpOrAttack)
  if type(param) == "number" then
    local data = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(param)
    if data ~= nil then
      if state then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceWarDetail, {anim = true, hideTop = true}, param, helpOrAttack)
        if helpOrAttack then
          if data.type == AllianceTeamType.ATTACK_BUILDING then
            SFSNetwork.SendMessage(MsgDefines.GetNewUserInfo, data.targetUid)
            SFSNetwork.SendMessage(MsgDefines.AllianceAssistanceInfo, data.targetUuid, AssistanceType.MainCity)
          elseif data.type == AllianceTeamType.ATTACK_CITY then
            SFSNetwork.SendMessage(MsgDefines.GetNewUserInfo, data.targetUid)
            SFSNetwork.SendMessage(MsgDefines.AllianceAssistanceInfo, data.targetUuid, AssistanceType.MainCity)
          elseif data.type == AllianceTeamType.ATTACK_EPIDEMIC_CITY then
            SFSNetwork.SendMessage(MsgDefines.GetNewUserInfo, data.targetUid)
            SFSNetwork.SendMessage(MsgDefines.AllianceAssistanceInfo, data.targetUuid, AssistanceType.MainCity)
          elseif data.type == AllianceTeamType.ATTACK_AL_CITY then
            SFSNetwork.SendMessage(MsgDefines.AllianceAssistanceInfo, data.targetUuid, AssistanceType.AllianceCity)
          end
        end
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIPersonalWar, {anim = true, hideTop = true}, param)
      end
      return
    end
  end
  local data
  for i, v in pairs(self.personalList) do
    if type(v) ~= "number" and v.ownerFormationUuid == param.ownerFormationUuid then
      data = v
    end
  end
  if data then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPersonalWar, {anim = true}, data)
  end
end

local function OpenAlertInfo(self, param, type)
  if param.type == AllianceAlertType.BUILDING then
    SFSNetwork.SendMessage(MsgDefines.GetAllianceAlertMarch, param.targetUid, param.type, 0, type)
  elseif param.type == AllianceAlertType.COLLECT then
    SFSNetwork.SendMessage(MsgDefines.GetAllianceAlertMarch, param.targetUid, param.type, param.content, 2)
  elseif param.type == AllianceAlertType.ALLIANCE_CITY then
    SFSNetwork.SendMessage(MsgDefines.GetAllianceAlertMarch, param.targetUid, param.type, param.content, 2)
  end
end

local function OnJoinClick(self, uuid, monsterSpecialType, fixedSoldierType)
  self:Close()
  local data = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(uuid)
  if data ~= nil then
    local targetType
    local isPVP = false
    if data.type == AllianceTeamType.ATTACK_BOSS then
      targetType = MarchTargetType.RALLY_FOR_BOSS
    elseif data.type == AllianceTeamType.ATTACK_BUILDING then
      targetType = MarchTargetType.RALLY_FOR_BUILDING
    elseif data.type == AllianceTeamType.ATTACK_AL_CITY then
      targetType = MarchTargetType.RALLY_FOR_ALLIANCE_CITY
    elseif data.type == AllianceTeamType.ATTACK_CITY then
      targetType = MarchTargetType.RALLY_FOR_CITY
    elseif data.type == AllianceTeamType.ATTACK_EPIDEMIC_CITY then
      targetType = MarchTargetType.RALLY_EPIDEMIC_CITY
    elseif data.type == AllianceTeamType.ATTACK_CITY_STRONGHOLD then
      targetType = MarchTargetType.RALLY_CITY_STRONGHOLD
    end
    if not BattleFieldUtil.InBattleField() and isPVP and LuaEntry.Effect:CheckCityBuff(CityBuffType.CityShield) then
      UIUtil.ShowShieldBreakTip(Localization:GetString("458215"), 2, GameDialogDefine.CANCEL, GameDialogDefine.CONFIRM, function()
      end, function()
        MarchUtil.OnClickStartMarch(MarchTargetType.JOIN_RALLY, data.leaderMarch.startId, uuid, -1, 1, targetType, data.server, data.worldId, monsterSpecialType)
      end, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, UIUtil.BtnColorSpriteName.Blue, UIUtil.BtnColorSpriteName.Red)
    else
      MarchUtil.OnClickStartMarch(MarchTargetType.JOIN_RALLY, data.leaderMarch.startId, uuid, -1, 1, targetType, data.server, data.worldId, monsterSpecialType)
    end
  end
end

local function OnCancelClick(self, uuid)
  SFSNetwork.SendMessage(MsgDefines.AllianceWarCancel, uuid)
end

local function OnRetreatClick(self, uuid, marchUuid)
  local info = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(uuid)
  if marchUuid ~= 0 and info ~= nil and info.memberList[marchUuid] ~= nil then
    local data = info.memberList[marchUuid]
    SFSNetwork.SendMessage(MsgDefines.AllianceWarRetreat, data.teamUuid, marchUuid)
  end
end

local function GetInMarchState(self, uuid)
  local inMarch = false
  local info = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(uuid)
  if info ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    inMarch = curTime > info.marchTime and curTime > info.waitTime
  end
  return inMarch
end

local function OnCloseClick(self)
  self:CloseSelf()
end

local function GetAllSoldiersInfo(self, uuid)
  local info = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(uuid)
  local SoldiersInfo = {}
  local typeNum = {}
  local num = 0
  if info ~= nil then
    if next(info.memberList) then
      local data = info.memberList
      table.walk(data, function(k, v)
        table.walk(v.armyInfos.soldiers, function(i, n)
          if SoldiersInfo[n.armsId] == nil then
            SoldiersInfo[n.armsId] = {}
            SoldiersInfo[n.armsId].num = n.total - n.lost
            SoldiersInfo[n.armsId].type = n.type
          else
            SoldiersInfo[n.armsId].num = SoldiersInfo[n.armsId].num + (n.total - n.lost)
          end
        end)
      end)
    end
    if next(info.leaderMarch) then
      local data = info.leaderMarch
      if data.armyInfo ~= nil then
        local soldiers = data.armyInfo.soldiers
        table.walk(soldiers, function(k, v)
          if SoldiersInfo[v.armsId] == nil then
            SoldiersInfo[v.armsId] = {}
            SoldiersInfo[v.armsId].num = v.total - v.lost
            SoldiersInfo[v.armsId].type = v.type
          else
            SoldiersInfo[v.armsId].num = SoldiersInfo[v.armsId].num + (v.total - v.lost)
          end
        end)
      end
    end
  end
  if next(SoldiersInfo) then
    table.walk(SoldiersInfo, function(k, v)
      if typeNum[v.type] == nil then
        typeNum[v.type] = v.num
        num = num + v.num
      else
        typeNum[v.type] = typeNum[v.type] + v.num
        num = num + typeNum[v.type]
      end
    end)
  end
  return typeNum
end

local function IsHaveMeMarch(self, uuid)
  local list = {}
  local info = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(uuid)
  local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
  for _, v in pairs(selfMarch) do
    table.insert(list, v.uuid)
  end
  if info ~= nil then
    for i, v in pairs(info.memberList) do
      for k = 1, #list do
        if i == list[k] then
          return i
        end
      end
    end
  end
  return 0
end

local function OnLeftPlayerInfoClick(self, userUid)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, userUid)
end

function UIAllianceWarMainTableCtrl:ClearAllianceWarRecord()
  self.lastWarList = nil
end

function UIAllianceWarMainTableCtrl:GetWarEventsList()
  local dict = DataCenter.AllianceWarEventDataManager:GetWarEventsDict()
  local list = {}
  for _, v in pairs(dict) do
    table.insert(list, v)
  end
  if 0 < #list then
    table.sort(list, function(a, b)
      if a.reminder ~= b.reminder then
        return a.reminder
      elseif a.template.weight ~= b.template.weight then
        return a.template.weight > b.template.weight
      else
        return a.endTime - a.startTime < b.endTime - b.startTime
      end
    end)
  end
  return list
end

UIAllianceWarMainTableCtrl.CloseSelf = CloseSelf
UIAllianceWarMainTableCtrl.Close = Close
UIAllianceWarMainTableCtrl.GetAllianceWarIdList = GetAllianceWarIdList
UIAllianceWarMainTableCtrl.GetPersonalList = GetPersonalList
UIAllianceWarMainTableCtrl.InitData = InitData
UIAllianceWarMainTableCtrl.GetWarItemData = GetWarItemData
UIAllianceWarMainTableCtrl.OnClickPosBtn = OnClickPosBtn
UIAllianceWarMainTableCtrl.OnOpenClick = OnOpenClick
UIAllianceWarMainTableCtrl.OpenAlertInfo = OpenAlertInfo
UIAllianceWarMainTableCtrl.OnJoinClick = OnJoinClick
UIAllianceWarMainTableCtrl.OnCancelClick = OnCancelClick
UIAllianceWarMainTableCtrl.GetInMarchState = GetInMarchState
UIAllianceWarMainTableCtrl.OnCloseClick = OnCloseClick
UIAllianceWarMainTableCtrl.GetPersonalItemData = GetPersonalItemData
UIAllianceWarMainTableCtrl.GetAllSoldiersInfo = GetAllSoldiersInfo
UIAllianceWarMainTableCtrl.OnRetreatClick = OnRetreatClick
UIAllianceWarMainTableCtrl.IsHaveMeMarch = IsHaveMeMarch
UIAllianceWarMainTableCtrl.OnLeftPlayerInfoClick = OnLeftPlayerInfoClick
UIAllianceWarMainTableCtrl.HasChange = HasChange
return UIAllianceWarMainTableCtrl
