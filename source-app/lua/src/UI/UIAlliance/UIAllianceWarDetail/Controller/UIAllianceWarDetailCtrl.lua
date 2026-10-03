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
  maxSoldiers = 0,
  waitTime = 0,
  createTime = 0,
  marchTime = 0,
  targetUuid = 0
}
local AllianceWarMemberShow = {
  ownerName = "",
  leader = false,
  cancel = false,
  status = MarchStatus.DEFAULT,
  endTime = 0,
  startTime = 0
}
local OneWarData = DataClass("OneWarData", AllianceWarItemShow)
local OnePlayerData = DataClass("OnePlayerData", AllianceWarMemberShow)
local UIAllianceWarDetailCtrl = BaseClass("UIAllianceWarDetailCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceWarDetail)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function SetSelfUuid(self, uuid)
  self.uuid = uuid
end

local function GetSelfUuid(self)
  return self.uuid
end

local function GetWarItemData(self, uuid)
  local oneData = OneWarData.New()
  local data = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(uuid)
  if data ~= nil then
    oneData.leftName = "[" .. data.attackAllianceAbbr .. "]" .. data.attackName
    if data.targetAllianceAbbr ~= "" then
      oneData.rightName = "[" .. data.targetAllianceAbbr .. "]" .. data.targetName
    else
      oneData.rightName = data.targetName
    end
    oneData.leftPointId = data.attackPointId
    oneData.rightPointId = data.targetPointId
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
    oneData.ownerHeadBg = data:GetHeadBgImg()
    oneData.targetUuid = data.targetUuid
    if next(data.memberList) then
      for i, v in pairs(data.memberList) do
        oneData.canJoinNum = oneData.canJoinNum + 1
      end
      oneData.canJoinNum = oneData.canJoinNum
    end
    if oneData.type == AllianceTeamType.ATTACK_BOSS then
      local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(oneData.targetUid)
      oneData.rightName = Localization:GetString("300665", monster.level) .. Localization:GetString(monster.name)
    elseif oneData.type == AllianceTeamType.ATTACK_AL_CITY then
      local name = data.targetName
      if name == nil or name == "" then
        name = GetTableData(TableName.WorldCity, data.targetContentId, "name")
        name = Localization:GetString(name)
      end
      local lv = GetTableData(TableName.WorldCity, data.targetContentId, "level")
      oneData.rightName = Localization:GetString("310161", name, lv)
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    oneData.inMarch = curTime > data.marchTime and curTime > data.waitTime
    local selfAllianceId = LuaEntry.Player.allianceId
    local selfUid = LuaEntry.Player.uid
    oneData.isAttack = selfAllianceId ~= data.attackAllianceId
    oneData.cancel = selfUid == data.attackUid
    oneData.isSelfAttack = selfUid == data.targetUid
    oneData.rightDistance = 0
    oneData.leftDistance = 0
    if oneData.isSelfAttack then
      local enemyPos = SceneUtils.IndexToTilePos(oneData.leftPointId, ForceChangeScene.World)
      oneData.rightDistance = math.ceil(SceneUtils.TileDistance(enemyPos, SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)))
    elseif not oneData.isSelfAttack and data.targetAllianceId == selfAllianceId then
      local allyPos = SceneUtils.IndexToTilePos(oneData.rightPointId, ForceChangeScene.World)
      oneData.leftDistance = math.ceil(SceneUtils.TileDistance(allyPos, SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)))
      local enemyPos = SceneUtils.IndexToTilePos(oneData.leftPointId, ForceChangeScene.World)
      oneData.rightDistance = math.ceil(SceneUtils.TileDistance(enemyPos, SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)))
    elseif oneData.cancel then
      local enemyPos = SceneUtils.IndexToTilePos(oneData.rightPointId, ForceChangeScene.World)
      oneData.rightDistance = math.ceil(SceneUtils.TileDistance(enemyPos, SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)))
    elseif not oneData.cancel and not oneData.isAttack then
      local allyPos = SceneUtils.IndexToTilePos(oneData.leftPointId, ForceChangeScene.World)
      oneData.leftDistance = math.ceil(SceneUtils.TileDistance(allyPos, SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)))
      local enemyPos = SceneUtils.IndexToTilePos(oneData.rightPointId, ForceChangeScene.World)
      oneData.rightDistance = math.ceil(SceneUtils.TileDistance(enemyPos, SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)))
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
    oneData.marchendTime = data.leaderMarch.endTime
  end
  return oneData
end

local function OnClickPosBtn(self, pos)
  if pos ~= 0 then
    self:Close()
    EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
    GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pos, ForceChangeScene.World), CS.SceneManager.World.InitZoom)
  end
end

local function OnOpenClick(self, uuid)
end

local function OnCloseClick(self)
  self:CloseSelf()
end

local function CloseMainTable(self)
  self:CloseSelf()
  DataCenter.AllianceWarDataManager:CloseALWarMain()
end

local function OnJoinClick(self, uuid, helpData)
  self:Close()
  if helpData then
    local mainLv = DataCenter.BuildManager.MainLv
    local needMainLv = LuaEntry.DataConfig:TryGetNum("assistance_open", "k1")
    if mainLv < needMainLv then
      UIUtil.ShowTips(Localization:GetString("121005", needMainLv))
      return
    end
    local info = DataCenter.FormationAssistanceDataManager:GetAssistanceData(helpData.targetUuid)
    if info ~= nil then
      self:Close()
      local pointInfos = CS.SceneManager.World:GetPointInfo(helpData.rightPointId)
      if pointInfos == nil then
        GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(helpData.rightPointId, ForceChangeScene.World), CS.SceneManager.World.InitZoom, LookAtFocusTime)
        return
      end
      if helpData.type == AllianceTeamType.ATTACK_BUILDING then
        MarchUtil.OnClickStartMarch(MarchTargetType.ASSISTANCE_BUILD, helpData.rightPointId, helpData.targetUuid)
      elseif helpData.type == AllianceTeamType.ATTACK_CITY then
        local marchTargetType = MarchTargetType.ASSISTANCE_CITY
        if BattleFieldUtil.InBattleField(BattleFieldType.WinterStorm) then
          marchTargetType = MarchTargetType.ASSISTANCE_WINTER_STORM_CITY
        elseif BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) or BattleFieldUtil.InBattleField(BattleFieldType.DsbDuel) then
          marchTargetType = MarchTargetType.ASSISTANCE_EPIDEMIC_CITY
        end
        MarchUtil.OnClickStartMarch(marchTargetType, helpData.rightPointId, helpData.targetUuid)
      elseif helpData.type == AllianceTeamType.ATTACK_EPIDEMIC_CITY then
        MarchUtil.OnClickStartMarch(MarchTargetType.ASSISTANCE_EPIDEMIC_CITY, helpData.rightPointId, helpData.targetUuid)
      elseif helpData.type == AllianceTeamType.ATTACK_AL_CITY then
        MarchUtil.OnClickStartMarch(MarchTargetType.ASSISTANCE_ALLIANCE_CITY, helpData.rightPointId, helpData.targetUuid)
      end
    end
    return
  end
  local data = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(uuid)
  if data ~= nil then
    local targetType
    if data.type == AllianceTeamType.ATTACK_BOSS then
      targetType = MarchTargetType.RALLY_FOR_BOSS
    elseif data.type == AllianceTeamType.ATTACK_BUILDING then
      targetType = MarchTargetType.RALLY_FOR_BUILDING
    elseif data.type == AllianceTeamType.ATTACK_CITY then
      targetType = MarchTargetType.RALLY_FOR_CITY
    elseif data.type == AllianceTeamType.ATTACK_EPIDEMIC_CITY then
      targetType = MarchTargetType.RALLY_EPIDEMIC_CITY
    end
    MarchUtil.OnClickStartMarch(MarchTargetType.JOIN_RALLY, data.leaderMarch.startId, uuid, -1, 1, targetType)
  end
end

local function OnCancelClick(self, uuid)
  SFSNetwork.SendMessage(MsgDefines.AllianceWarCancel, uuid)
end

local function GetPlayerIdList(self)
  local list = {}
  local info = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(self:GetSelfUuid())
  if info ~= nil then
    if info.leaderMarch ~= nil then
      table.insert(list, info.leaderMarch.uuid)
    end
    table.insertto(list, table.keys(info.memberList))
  end
  return list
end

local function GetPlayerItemData(self, marchUuid, helpData)
  local oneData = OnePlayerData.New()
  local info
  if helpData then
    info = DataCenter.FormationAssistanceDataManager:GetAssistanceData(helpData.targetUuid)
  else
    info = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(self:GetSelfUuid())
  end
  local selfUid = LuaEntry.Player.uid
  if info ~= nil then
    if info.memberList[marchUuid] ~= nil then
      local data = info.memberList[marchUuid]
      oneData.ownerName = data.ownerName
      oneData.status = data.status
      oneData.endTime = data.endTime
      oneData.startTime = data.startTime
      oneData.leader = false
      oneData.cancel = data.ownerUid == selfUid or info.attackUid == selfUid
      oneData.ownerUid = data.ownerUid
      oneData.teamUuid = data.teamUuid
      oneData.attackUid = info.attackUid
      oneData.ownerIcon = data.ownerIcon
      oneData.ownerIconVer = data.ownerIconVer
      oneData.headBg = data:GetHeadBgImg()
    elseif info.leaderMarch ~= nil and info.leaderMarch.uuid == marchUuid then
      local data = info.leaderMarch
      oneData.ownerName = data.ownerName
      oneData.status = data.status
      oneData.endTime = data.endTime
      oneData.startTime = data.startTime
      oneData.leader = true
      oneData.cancel = data.ownerUid == selfUid
      oneData.ownerUid = data.ownerUid
      oneData.teamUuid = data.teamUuid
      oneData.attackUid = info.attackUid
      oneData.ownerIcon = data.ownerIcon
      oneData.ownerIconVer = data.ownerIconVer
      oneData.headBg = data:GetHeadBgImg()
    end
  end
  return oneData
end

local function GetPlayerSoldierData(self, marchUuid, helpData)
  local info
  if helpData then
    info = DataCenter.FormationAssistanceDataManager:GetAssistanceData(helpData.targetUuid)
  else
    info = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(self:GetSelfUuid())
  end
  local showList = {}
  if info ~= nil then
    if next(info.memberList) and info.memberList[marchUuid] then
      local data = info.memberList[marchUuid].armyInfos
      local heros = data.heros
      showList.heros = {}
      for i = 1, #heros do
        if not heros[i].index or not (heros[i].index >= ArmyFormationSlot.Dominator) then
          showList.heros[i] = {}
          showList.heros[i].heroId = heros[i].heroId
          showList.heros[i].quality = heros[i].heroQuality
          showList.heros[i].lv = heros[i].heroLevel
          showList.heros[i].skillInfos = heros[i].skillInfos
          showList.heros[i].rankId = 1
          local config = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heros[i].heroId)
          if config == nil then
            Logger.LogError("hero config not found! heroId:" .. heros[i].heroId)
            return
          end
          local maxMilitaryRankId = config.max_rank_level or 1
          for rankId = 1, maxMilitaryRankId do
            local mailLevel = GetTableData(TableName.HeroMilitaryRankLv, rankId, "level")
            if heros[i].rankLv == mailLevel then
              showList.heros[i].rankId = rankId
              break
            end
          end
        end
      end
      local soldiers = data.soldiers
      showList.soldiers = {}
      for i = 1, #soldiers do
        if not soldiers[i].armsId or not (soldiers[i].armsId >= ArmyFormationSlot.Dominator) then
          showList.soldiers[i] = {}
          showList.soldiers[i].armsId = soldiers[i].armsId
          showList.soldiers[i].type = soldiers[i].type
          showList.soldiers[i].data = DataCenter.ArmyTemplateManager:GetArmyTemplate(soldiers[i].armsId)
          showList.soldiers[i].count = soldiers[i].total - soldiers[i].lost
        end
      end
    elseif next(info.leaderMarch) and info.leaderMarch.uuid == marchUuid then
      local data = info.leaderMarch
      if data.armyInfo ~= nil then
        local heros = data.armyInfo.heros
        showList.heros = {}
        for i = 1, #heros do
          if not heros[i].index or not (heros[i].index >= ArmyFormationSlot.Dominator) then
            showList.heros[i] = {}
            showList.heros[i].heroId = heros[i].heroId
            showList.heros[i].quality = heros[i].heroQuality
            showList.heros[i].lv = heros[i].heroLevel
            showList.heros[i].skillInfos = heros[i].skillInfos
            showList.heros[i].rankId = 1
            local config = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heros[i].heroId)
            if config == nil then
              Logger.LogError("hero config not found! heroId:" .. heros[i].heroId)
              return
            end
            local maxMilitaryRankId = config.max_rank_level or 1
            for rankId = 1, maxMilitaryRankId do
              local mailLevel = GetTableData(TableName.HeroMilitaryRankLv, rankId, "level")
              if heros[i].rankLv == mailLevel then
                showList.heros[i].rankId = rankId
                break
              end
            end
          end
        end
        local soldiers = data.armyInfo.soldiers
        showList.soldiers = {}
        for i = 1, #soldiers do
          if not soldiers[i].armsId or not (soldiers[i].armsId >= ArmyFormationSlot.Dominator) then
            showList.soldiers[i] = {}
            showList.soldiers[i].armsId = soldiers[i].armsId
            showList.soldiers[i].type = soldiers[i].type
            showList.soldiers[i].data = DataCenter.ArmyTemplateManager:GetArmyTemplate(soldiers[i].armsId)
            showList.soldiers[i].count = soldiers[i].total - soldiers[i].lost
          end
        end
      end
    end
  end
  return showList
end

local function GetAllSoldiersInfo(self, helpData)
  local info
  if helpData then
    info = DataCenter.FormationAssistanceDataManager:GetAssistanceData(helpData.targetUuid)
  else
    info = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(self:GetSelfUuid())
  end
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
    if info.leaderMarch and next(info.leaderMarch) then
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

local function OnRetreatClick(self, uuid, marchUuid)
  local info = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(uuid)
  if marchUuid ~= 0 and info ~= nil and info.memberList[marchUuid] ~= nil then
    local data = info.memberList[marchUuid]
    SFSNetwork.SendMessage(MsgDefines.AllianceWarRetreat, data.teamUuid, marchUuid)
  end
end

local function OnRetreatClicks(self, marchUuid)
  local info = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(self:GetSelfUuid())
  if marchUuid ~= 0 and info ~= nil and info.memberList[marchUuid] ~= nil then
    local data = info.memberList[marchUuid]
    SFSNetwork.SendMessage(MsgDefines.AllianceWarRetreat, data.teamUuid, marchUuid)
  end
end

local function OnLevelClick(self, marchUuid, buildUuid)
  local info = DataCenter.FormationAssistanceDataManager:GetAssistanceData(buildUuid)
  if info ~= nil and info.memberList ~= nil and info.memberList[marchUuid] ~= nil then
    info.memberList[marchUuid] = nil
    DataCenter.FormationAssistanceDataManager:TryRetreatMarchTeam(buildUuid, marchUuid)
    self:CloseSelf()
    DataCenter.AllianceWarDataManager:CloseALWarMain()
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

local function GetHelpIdList(self, data)
  local list = {}
  local info = DataCenter.FormationAssistanceDataManager:GetAssistanceData(data.targetUuid)
  if info ~= nil and info.memberList ~= nil then
    table.insertto(list, table.keys(info.memberList))
  end
  return list
end

local function GetBuildData(self, data)
  local param = {}
  param.maxNum = 0
  param.join = true
  local info = DataCenter.FormationAssistanceDataManager:GetAssistanceData(data.targetUuid)
  if info ~= nil then
    param.maxNum = info.maxAssistance
    if info.memberList ~= nil then
      local count = table.count(info.memberList)
      if count >= param.maxNum then
        param.join = false
      end
    end
  end
  local list = DataCenter.FormationAssistanceDataManager:GetAssistanceData(data.targetUuid)
  if list ~= nil and list.memberList ~= nil then
    for i, v in pairs(list.memberList) do
      if v.ownerUid == LuaEntry.Player:GetUid() then
        param.join = false
      end
    end
  end
  return param
end

local function IsHaveMeMarch(self, uuid)
  local info = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(uuid)
  if not info or not info.memberList then
    return 0
  end
  local list = {}
  local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
  for _, v in pairs(selfMarch) do
    table.insert(list, v.uuid)
  end
  if #list == 0 then
    return 0
  end
  for i, _ in pairs(info.memberList) do
    for _, v in pairs(list) do
      if i == v then
        return i
      end
    end
  end
  return 0
end

UIAllianceWarDetailCtrl.CloseSelf = CloseSelf
UIAllianceWarDetailCtrl.Close = Close
UIAllianceWarDetailCtrl.GetWarItemData = GetWarItemData
UIAllianceWarDetailCtrl.OnClickPosBtn = OnClickPosBtn
UIAllianceWarDetailCtrl.OnOpenClick = OnOpenClick
UIAllianceWarDetailCtrl.OnJoinClick = OnJoinClick
UIAllianceWarDetailCtrl.OnCancelClick = OnCancelClick
UIAllianceWarDetailCtrl.SetSelfUuid = SetSelfUuid
UIAllianceWarDetailCtrl.GetSelfUuid = GetSelfUuid
UIAllianceWarDetailCtrl.GetPlayerSoldierData = GetPlayerSoldierData
UIAllianceWarDetailCtrl.GetPlayerIdList = GetPlayerIdList
UIAllianceWarDetailCtrl.GetPlayerItemData = GetPlayerItemData
UIAllianceWarDetailCtrl.OnRetreatClick = OnRetreatClick
UIAllianceWarDetailCtrl.OnCloseClick = OnCloseClick
UIAllianceWarDetailCtrl.GetInMarchState = GetInMarchState
UIAllianceWarDetailCtrl.GetAllSoldiersInfo = GetAllSoldiersInfo
UIAllianceWarDetailCtrl.CloseMainTable = CloseMainTable
UIAllianceWarDetailCtrl.GetHelpIdList = GetHelpIdList
UIAllianceWarDetailCtrl.GetBuildData = GetBuildData
UIAllianceWarDetailCtrl.IsHaveMeMarch = IsHaveMeMarch
UIAllianceWarDetailCtrl.OnRetreatClicks = OnRetreatClicks
UIAllianceWarDetailCtrl.OnLevelClick = OnLevelClick
return UIAllianceWarDetailCtrl
