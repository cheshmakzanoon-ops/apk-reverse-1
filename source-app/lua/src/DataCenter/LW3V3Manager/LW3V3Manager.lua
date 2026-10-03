local LW3V3Manager = BaseClass("LW3V3Manager", Singleton)
local Localization = CS.GameEntry.Localization

function LW3V3Manager:__init()
  self.curType = nil
  self.atkTeams = nil
  self.playersDefTeams = nil
  self.atkTeamsArena = {}
  self.playersDefTeamsArena = {}
  self.atkTeamsTrain = {}
  self.playersDefTeamsTrain = {}
  self.atk = {
    [Type3v3.Arena] = self.atkTeamsArena,
    [Type3v3.Train] = self.atkTeamsTrain
  }
  self.def = {
    [Type3v3.Arena] = self.playersDefTeamsArena,
    [Type3v3.Train] = self.playersDefTeamsTrain
  }
  self.recordsMailState = {}
  self.playerWeaponInfos = {}
end

function LW3V3Manager:__delete()
  for _, teamList in pairs(self.atk) do
    for _, team in pairs(teamList) do
      team:Delete()
    end
  end
  for _, type in pairs(self.def) do
    for _, teamList in pairs(type) do
      for _, team in pairs(teamList) do
        team:Delete()
      end
    end
  end
  self.atkTeams = nil
  self.playersDefTeams = nil
  self.atkTeamsArena = nil
  self.playersDefTeamsArena = nil
  self.atkTeamsTrain = nil
  self.atk = nil
  self.def = nil
  self.playersDefTeamsTrain = nil
  self.recordsMailState = nil
end

function LW3V3Manager:SetType(type3v3)
  self.curType = type3v3
  self.atkTeams = self.atk[type3v3]
  self.playersDefTeams = self.def[type3v3]
end

function LW3V3Manager:GetType()
  return self.curType
end

function LW3V3Manager:GetAtkTeamByIndex(index)
  if self.atkTeams[index] == nil then
    local teamInfo = ArenaArmyFormationInfo.New()
    self.atkTeams[index] = teamInfo
  end
  return self.atkTeams[index]
end

function LW3V3Manager:GetDefTeamByIndex(uuid, index)
  if not self.playersDefTeams[uuid] then
    return nil
  end
  return self.playersDefTeams[uuid][index]
end

function LW3V3Manager:ParseOneDefenseTeam(type3v3, uuid, index, data)
  if not data or not index then
    return
  end
  if index < 1 or 3 < index then
    return
  end
  local playersDefTeams = self.def[type3v3]
  local infos = playersDefTeams[uuid]
  infos = infos or {}
  local info = infos[index]
  info = info or ArenaArmyFormationInfo.New()
  data.index = index
  info:ParseData(data, true)
  info.power = data.power
  infos[index] = info
  playersDefTeams[uuid] = infos
end

function LW3V3Manager:ParseOneAtkTeam(type3v3, index, data)
  if not data or not index then
    return
  end
  if index < 1 or 3 < index then
    return
  end
  local atkTeams = self.atk[type3v3]
  local info = atkTeams[index]
  info = info or ArenaArmyFormationInfo.New()
  data.index = index
  info:ParseData(data, true)
  atkTeams[index] = info
end

function LW3V3Manager:SetOpponentData(data)
  self.opponentData = data
end

function LW3V3Manager:GetOpponentData()
  return self.opponentData
end

function LW3V3Manager:GetOpponentDefenceTeam(index)
  if not self.opponentData then
    return nil
  end
  return self.opponentData.teams[index]
end

function LW3V3Manager:SwitchAtkTeam(index1, index2)
  if not self.atkTeams then
    return
  end
  local team1 = self.atkTeams[index1]
  local team2 = self.atkTeams[index2]
  self.atkTeams[index1] = team2
  self.atkTeams[index2] = team1
end

function LW3V3Manager:GetHeroInAtkTeamIndex(uuid)
  if not uuid then
    return nil
  end
  if not self.atkTeams then
    return nil
  end
  for i, v in pairs(self.atkTeams) do
    if v:HasLocalHero(uuid) then
      return i
    end
  end
end

function LW3V3Manager:GetCurrentTeamBuffBuildingUuid(squadIndex)
  local index = squadIndex
  local buildingEnum = {
    BuildingTypes.LW_BUILD_PARKINGLOT,
    BuildingTypes.LW_BUILD_PARKINGLOT_TWO,
    BuildingTypes.LW_BUILD_PARKINGLOT_THREE,
    BuildingTypes.LW_BUILD_PARKINGLOT_FOUR
  }
  local b = DataCenter.BuildManager:GetBuildingDatasByBuildingId(buildingEnum[index])[1]
  if b and b.uuid then
    return b.uuid
  else
    return 0
  end
end

function LW3V3Manager:GetTeamIndexUsingBuff(buffIndex)
  if not self.atkTeams then
    return nil
  end
  for i, v in pairs(self.atkTeams) do
    if v.localSquadNo == buffIndex then
      return i
    end
  end
end

function LW3V3Manager:GetDefTeamIndexUsingBuff(buffIndex)
  local defTeams = self:GetSelfDefTeams()
  if not defTeams then
    return nil
  end
  for i, v in pairs(defTeams) do
    if v.localSquadNo == buffIndex then
      return i
    end
  end
end

function LW3V3Manager:SetTeamUsingBuff(teamIndex, buffIndex)
  if not self.atkTeams then
    return
  end
  local team = self.atkTeams[teamIndex]
  if not team then
    return
  end
  team.localSquadNo = buffIndex
  EventManager:GetInstance():Broadcast(EventId.Arena3V3BuffChange)
end

function LW3V3Manager:SetDefTeamUsingBuff(teamIndex, buffIndex)
  local defTeams = self:GetSelfDefTeams()
  if not defTeams then
    return
  end
  local team = defTeams[teamIndex]
  if not team then
    return
  end
  team.localSquadNo = buffIndex
  EventManager:GetInstance():Broadcast(EventId.Arena3V3BuffChange)
end

function LW3V3Manager:CheckNilTeamIndex()
  local nilIndex
  if self.atkTeams then
    for i = 1, 3 do
      local team = self.atkTeams[i]
      if not team or table.IsNullOrEmpty(team:GetLocalAllHeroes()) then
        nilIndex = i
        break
      end
    end
  end
  return nilIndex
end

function LW3V3Manager:GetSelfAtkTeamOrderByIdx(index)
  local selfAtkTeams = self.atkTeams
  if not selfAtkTeams then
    return nil
  end
  for i, v in pairs(selfAtkTeams) do
    if v.index == index then
      return i
    end
  end
end

function LW3V3Manager:GetSelfDefTeamOrderByIdx(index)
  local selfDefTeams = self:GetSelfDefTeams()
  if not selfDefTeams then
    return nil
  end
  for i, v in pairs(selfDefTeams) do
    if v.index == index then
      return i
    end
  end
end

function LW3V3Manager:StartBattle()
  if not self.opponentData then
    return
  end
  local atkTeams = self.atkTeams
  if table.IsNullOrEmpty(atkTeams) then
    return
  end
  local nilIndex = self:CheckNilTeamIndex()
  if nilIndex then
    UIUtil.ShowTips(Localization:GetString("500253", nilIndex))
  end
  local opponentUid = self.opponentData.playerInfo.uid
  local sfsArray = self:FormationToSFS(atkTeams)
  if self.curType == Type3v3.Arena then
    SFSNetwork.SendMessage(MsgDefines.Arena3V3Battle, opponentUid, sfsArray, self:CheckIsRevenge())
  elseif self.curType == Type3v3.Train then
    local trainData = self.opponentData.trainData
    SFSNetwork.SendMessage(MsgDefines.AllianceTrainAttack, trainData.uuid, trainData.serverId, sfsArray)
  end
end

function LW3V3Manager:RobTrain()
  local curType = DataCenter.LWBattleManager:GetCurBattleType()
  local curEnterType = DataCenter.LWBattleManager:GetPVEEnterType()
  if curType == PVEType.Arena3V3 and curEnterType == PVEEnterType.TrainRob then
    return
  end
  local param = {}
  param.type = PVEType.Arena3V3
  param.enterType = PVEEnterType.TrainRob
  param.levelId = -1
  param.sceneId = 51
  param.extraData = {}
  param.extraData.squadIndex = 1
  param.extraData.openWindow = true
  param.extraData.trainData = self.opponentData.trainData
  DataCenter.LWBattleManager:Enter(param)
end

function LW3V3Manager:TryRefreshRobTrain(uuid)
  if self.opponentData and self.opponentData.trainData and self.opponentData.trainData.uuid == uuid and self.opponentData.teams then
    for i, v in pairs(self.opponentData.trainData.teamList) do
      self.opponentData.teams[i] = RailwayUtil.ParseTeamInfo(v)
    end
    self.opponentData.power = self.opponentData.trainData.power or 0
    EventManager:GetInstance():Broadcast(EventId.RobTrainTryRefreshView, uuid)
  end
end

function LW3V3Manager:GetSelfDefTeams()
  if not self.playersDefTeams then
    return nil
  end
  local uuid = LuaEntry.Player.uid
  return self.playersDefTeams[uuid]
end

function LW3V3Manager:GetSelfDefTeamByIndex(index)
  if not self.playersDefTeams then
    return nil
  end
  local uuid = LuaEntry.Player.uid
  if not self.playersDefTeams[uuid] then
    self.playersDefTeams[uuid] = {}
  end
  local info = self.playersDefTeams[uuid][index]
  if not info then
    info = ArenaArmyFormationInfo.New()
    self.playersDefTeams[uuid][index] = info
  end
  return info
end

function LW3V3Manager:GetSelfEmptyDefTeam()
  local defTeams = self:GetSelfDefTeams()
  if table.IsNullOrEmpty(defTeams) then
    return nil
  end
  for i = 1, 3 do
    local team = defTeams[i]
    if not team or table.IsNullOrEmpty(team:GetLocalAllHeroes()) then
      return i
    end
  end
  return nil
end

function LW3V3Manager:SaveDefTeams()
  local defTeams = self:GetSelfDefTeams()
  if table.IsNullOrEmpty(defTeams) then
    return
  end
  local hasEmptyTeam = self:GetSelfEmptyDefTeam() ~= nil
  if hasEmptyTeam then
    return
  end
  local changedTeams = self:GetDirtySelfDefTeams()
  if table.IsNullOrEmpty(changedTeams) then
    return
  end
  local sfsArray = self:FormationToSFS(changedTeams)
  if self.curType == Type3v3.Arena then
    SFSNetwork.SendMessage(MsgDefines.Save3V3ArenaFormation, 2, sfsArray)
  elseif self.curType == Type3v3.Train then
    SFSNetwork.SendMessage(MsgDefines.AllianceTrainAssignArmy, sfsArray)
  end
end

function LW3V3Manager:FormationToSFS(teams)
  local ret = SFSArray.New()
  if not table.IsNullOrEmpty(teams) then
    for i, v in pairs(teams) do
      local teamInfo = SFSObject.New()
      teamInfo:PutInt("teamNo", i)
      teamInfo:PutInt("squadNo", v.localSquadNo)
      local heroArray = v:GenerateServerHeroArray()
      teamInfo:PutSFSArray("heroInfos", heroArray)
      if v.localChipSetId and v.localChipSetId > 0 and v.localChipSetId <= 4 then
        teamInfo:PutInt("chipEquipGroup", v.localChipSetId)
      end
      ret:AddSFSObject(teamInfo)
    end
  end
  return ret
end

function LW3V3Manager:GetDirtySelfDefTeams()
  if not self.playersDefTeams then
    return nil
  end
  local uuid = LuaEntry.Player.uid
  local defTeams = self.playersDefTeams[uuid]
  if table.IsNullOrEmpty(defTeams) then
    return nil
  end
  local changedTeams = {}
  for i = 1, 3 do
    local team = defTeams[i]
    if team and (team:CheckLoacalRemoteDiff() or team.index ~= i) then
      changedTeams[i] = team
    end
  end
  return changedTeams
end

function LW3V3Manager:GetHeroInSelfDefTeamIndex(uuid)
  if not uuid then
    return nil
  end
  local defTeams = self:GetSelfDefTeams()
  if table.IsNullOrEmpty(defTeams) then
    return nil
  end
  for i, v in pairs(defTeams) do
    if v:HasLocalHero(uuid) then
      return i
    end
  end
end

function LW3V3Manager:SwitchSelfDefTeam(index1, index2)
  if not self.playersDefTeams then
    return
  end
  local uuid = LuaEntry.Player.uid
  local defTeams = self.playersDefTeams[uuid]
  if not defTeams then
    return
  end
  local team1 = defTeams[index1]
  local team2 = defTeams[index2]
  defTeams[index1] = team2
  defTeams[index2] = team1
  EventManager:GetInstance():Broadcast(EventId.Arena3V3SwitchDefTeamOrder, {oldIndex = index1, newIndex = index2})
end

function LW3V3Manager:PackSelfPlayerInfo(score)
  local selfAllianceAbbr
  if not string.IsNullOrEmpty(LuaEntry.Player.allianceId) then
    local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    selfAllianceAbbr = data.abbr
  end
  local selfPlayerInfo = {
    uid = LuaEntry.Player.uid,
    pic = LuaEntry.Player.pic,
    picver = LuaEntry.Player.picVer,
    headSkinId = DataCenter.DecorationDataManager:GetSelfHeadFrameId(),
    name = LuaEntry.Player.name,
    abbr = selfAllianceAbbr,
    serverId = LuaEntry.Player.serverId,
    power = LuaEntry.Player.power,
    score = score,
    srcServer = LuaEntry.Player:GetSourceServerId()
  }
  return selfPlayerInfo
end

function LW3V3Manager:RequestRecordsMails(record)
  local log = record
  if not table.IsNullOrEmpty(log.battleArr) then
    local mailUids = {}
    for _, battle in pairs(log.battleArr) do
      if battle.mailUid then
        table.insert(mailUids, battle.mailUid)
      end
    end
    if not table.IsNullOrEmpty(mailUids) then
      for _, mailUid in pairs(mailUids) do
        DataCenter.MailDataManager:ReqMailById(mailUid, function(mailData)
          if mailData then
            self.recordsMailState[mailUid] = 2
          else
            self.recordsMailState[mailUid] = nil
          end
        end)
        self.recordsMailState[mailUid] = 1
      end
    end
  end
end

function LW3V3Manager:IsMailRequested(mailUid)
  local state = self.recordsMailState[mailUid]
  if state == nil then
    state = 0
  end
  return state == 1 or state == 2
end

function LW3V3Manager:IsMailParsed(mailUid)
  local state = self.recordsMailState[mailUid]
  if state == nil then
    state = 0
  end
  return state == 2
end

function LW3V3Manager:IsRecordsParsed(record)
  if not record then
    return false
  end
  if not table.IsNullOrEmpty(record.battleArr) then
    for _, battle in pairs(record.battleArr) do
      if not self:IsMailParsed(battle.mailUid) then
        return false
      end
    end
  end
  return true
end

function LW3V3Manager:IsRecordRequested(record)
  if not record then
    return false
  end
  if not table.IsNullOrEmpty(record.battleArr) then
    for _, battle in pairs(record.battleArr) do
      if not self:IsMailRequested(battle.mailUid) then
        return false
      end
    end
  end
  return true
end

function LW3V3Manager:ParseWeaponInfo(msg)
  if not msg then
    return
  end
  if msg then
    local onwerInfo = msg
    local uuid = onwerInfo.playerInfo.uid
    self.playerWeaponInfos[uuid] = onwerInfo.weapon
  end
end

function LW3V3Manager:GetWeaponInfo(uuid)
  if not self.playerWeaponInfos then
    return nil
  end
  return self.playerWeaponInfos[uuid]
end

function LW3V3Manager:GetOpponentWeaponInfo()
  if not self.opponentData then
    return nil
  end
  local uuid = self.opponentData.playerInfo.uid
  return self:GetWeaponInfo(uuid)
end

function LW3V3Manager:SetDefTeamUsingChipSet(index, chipSetId)
  local defTeams = self:GetSelfDefTeams()
  if not defTeams then
    return
  end
  local team = defTeams[index]
  if not team then
    return
  end
  team.localChipSetId = chipSetId
end

function LW3V3Manager:GetDefTeamUsingChipSet(index)
  local defTeams = self:GetSelfDefTeams()
  if not defTeams then
    return nil
  end
  local team = defTeams[index]
  if not team then
    return nil
  end
  return team.localChipSetId
end

function LW3V3Manager:SetTeamUsingChipSet(index, chipSetId)
  if not self.atkTeams then
    return
  end
  local team = self.atkTeams[index]
  if not team then
    return
  end
  team.localChipSetId = chipSetId
end

function LW3V3Manager:GetTeamUsingChipSet(index)
  if not self.atkTeams then
    return nil
  end
  local team = self.atkTeams[index]
  if not team then
    return nil
  end
  return team.localChipSetId
end

function LW3V3Manager:CheckIsRevenge()
  return self.opponentData and self.opponentData.is3V3Revenge
end

function LW3V3Manager:ClearRevenge()
  if self.opponentData then
    self.opponentData.is3V3Revenge = nil
  end
end

return LW3V3Manager
