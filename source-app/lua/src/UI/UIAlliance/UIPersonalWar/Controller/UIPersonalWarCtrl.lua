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
  marchTime = 0
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
local UIPersonalWarCtrl = BaseClass("UIPersonalWarCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPersonalWar)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function SetSelfData(self, data)
  self.data = data
end

local function GetSelfData(self)
  return self.data
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
    oneData.serverId = data.server
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
    oneData.assemblyMarchMax = data.assemblyMarchMax
    oneData.canJoinNum = 1
    oneData.attackUid = data.attackUid
    oneData.attackIcon = data.leaderMarch.ownerIcon
    oneData.ownerIconVer = data.leaderMarch.ownerIconVer
    oneData.leaderMarchUuid = data.leaderMarch.uuid
    if next(data.memberList) then
      for i, v in pairs(data.memberList) do
        oneData.canJoinNum = oneData.canJoinNum + 1
      end
      oneData.canJoinNum = oneData.canJoinNum
    end
    if oneData.type == AllianceTeamType.ATTACK_BOSS then
      local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(oneData.targetUid)
      oneData.rightName = monster.name
    end
    local selfAllianceId = LuaEntry.Player.allianceId
    local selfUid = LuaEntry.Player.uid
    oneData.isAttack = selfAllianceId ~= data.attackAllianceId
    oneData.cancel = selfUid == data.attackUid
    if oneData.cancel == false and oneData.isAttack == false then
      oneData.leftDistance = SceneUtils.TileDistanceToMyHome(oneData.leftPointId)
    elseif data.targetAllianceId == selfAllianceId then
      oneData.leftDistance = SceneUtils.TileDistanceToMyHome(oneData.rightPointId)
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
    oneData.join = canJoin
    oneData.inTeam = inTeam
    oneData.uuid = uuid
    oneData.isAlliance = true
    oneData.marchendTime = data.leaderMarch.endTime
  end
  return oneData
end

local function OnClickPosBtn(self, pos, isV3, marchUuid, serverId)
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
      end, serverId)
    else
      GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pos, ForceChangeScene.World), CS.SceneManager.World.InitZoom, LookAtFocusTime, nil, serverId)
    end
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

local function OnCancelClick(self, uuid)
  SFSNetwork.SendMessage(MsgDefines.AllianceWarCancel, uuid)
end

local function GetPlayerIdList(self)
  local list = {}
  local info = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(self:GetSelfData())
  if info ~= nil then
    if info.leaderMarch ~= nil then
      table.insert(list, info.leaderMarch.uuid)
    end
    table.insertto(list, table.keys(info.memberList))
  end
  return list
end

local function GetPlayerItemData(self, marchUuid)
  local oneData = OnePlayerData.New()
  local info = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(self:GetSelfData())
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

local function GetPlayerSoldierData(self, marchUuid)
  local info = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(self:GetSelfData())
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
          showList.heros[i].rankLv = heros[i].rankLv
          showList.heros[i].stage = heros[i].stage
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
            showList.heros[i].rankLv = heros[i].rankLv
            showList.heros[i].stage = heros[i].stage
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

local function GetAllSoldiersInfo(self)
  local info = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(self:GetSelfData())
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

local function GetPersonalItemData(self, ownerFormationUuid)
  local data
  local personalList = DataCenter.RadarAlarmDataManager:GetAllMarches()
  for i, v in pairs(personalList) do
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
  oneData.data = data
  oneData.isAlliance = false
  return oneData
end

local function OnRetreatClick(self, marchUuid)
  local info = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(self:GetSelfData())
  if info ~= nil and info.memberList[marchUuid] ~= nil then
    local data = info.memberList[marchUuid]
    SFSNetwork.SendMessage(MsgDefines.AllianceWarRetreat, data.teamUuid, marchUuid)
  end
end

local function GetInMarchState(self, uuid)
  local inMarch = false
  local info = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(uuid)
  if info ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    inMarch = curTime > info.marchTime and curTime > info.marchTime
  end
  return inMarch
end

local function OnLeftPlayerInfoClick(self, userUid)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, userUid)
end

UIPersonalWarCtrl.CloseSelf = CloseSelf
UIPersonalWarCtrl.Close = Close
UIPersonalWarCtrl.GetWarItemData = GetWarItemData
UIPersonalWarCtrl.OnClickPosBtn = OnClickPosBtn
UIPersonalWarCtrl.OnOpenClick = OnOpenClick
UIPersonalWarCtrl.GetPersonalItemData = GetPersonalItemData
UIPersonalWarCtrl.OnCancelClick = OnCancelClick
UIPersonalWarCtrl.SetSelfData = SetSelfData
UIPersonalWarCtrl.GetSelfData = GetSelfData
UIPersonalWarCtrl.GetPlayerSoldierData = GetPlayerSoldierData
UIPersonalWarCtrl.GetPlayerIdList = GetPlayerIdList
UIPersonalWarCtrl.GetPlayerItemData = GetPlayerItemData
UIPersonalWarCtrl.OnRetreatClick = OnRetreatClick
UIPersonalWarCtrl.OnCloseClick = OnCloseClick
UIPersonalWarCtrl.GetInMarchState = GetInMarchState
UIPersonalWarCtrl.GetAllSoldiersInfo = GetAllSoldiersInfo
UIPersonalWarCtrl.CloseMainTable = CloseMainTable
UIPersonalWarCtrl.OnLeftPlayerInfoClick = OnLeftPlayerInfoClick
return UIPersonalWarCtrl
