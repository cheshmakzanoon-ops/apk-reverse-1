local LWKOFBattleManager = BaseClass("LWKOFBattleManager", Singleton)
local Localization = CS.GameEntry.Localization

function LWKOFBattleManager:__init()
  self.curType = nil
  self.atkTeams = nil
  self.playersDefTeams = nil
  self.atkTeamsTrain = {}
  self.playersDefTeamsTrain = {}
  self.atkTeamsNewPeakArena = {}
  self.playersDefTeamsNewPeakArena = {}
  self.atk = {
    [TypeKOF.Train] = self.atkTeamsTrain,
    [TypeKOF.NewPeakArena] = self.atkTeamsNewPeakArena
  }
  self.def = {
    [TypeKOF.Train] = self.playersDefTeamsTrain,
    [TypeKOF.NewPeakArena] = self.playersDefTeamsNewPeakArena
  }
  self.recordsMailState = {}
  self.playerWeaponInfos = {}
  self.isQuickRob = false
end

function LWKOFBattleManager:__delete()
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
  self.atkTeamsTrain = nil
  self.atk = nil
  self.def = nil
  self.playersDefTeamsTrain = nil
  self.recordsMailState = nil
  self.atkTeamsNewPeakArena = nil
  self.playersDefTeamsNewPeakArena = nil
end

function LWKOFBattleManager:SetType(typeKOF)
  self.curType = typeKOF
  self.atkTeams = self.atk[typeKOF]
  self.playersDefTeams = self.def[typeKOF]
end

function LWKOFBattleManager:GetType()
  return self.curType
end

function LWKOFBattleManager:GetAtkTeamByIndex(index)
  if self.atkTeams[index] == nil then
    local teamInfo = ArenaArmyFormationInfo.New()
    self.atkTeams[index] = teamInfo
  end
  return self.atkTeams[index]
end

function LWKOFBattleManager:GetAtkTeamPower()
  local power = 0
  for i = 1, 3 do
    local atkTeam = self:GetAtkTeamByIndex(i)
    power = power + atkTeam:GetTotalCapacity()
  end
  return power
end

function LWKOFBattleManager:GetDefTeamByIndex(uuid, index)
  if not self.playersDefTeams[uuid] then
    return nil
  end
  return self.playersDefTeams[uuid][index]
end

function LWKOFBattleManager:ParseOneDefenseTeam(typeKOF, uuid, index, data)
  if not data or not index then
    return
  end
  if index < 1 or 3 < index then
    return
  end
  local playersDefTeams = self.def[typeKOF]
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

function LWKOFBattleManager:ParseOneAtkTeam(typeKOF, index, data)
  if not data or not index then
    if self.atkTeams and self.atkTeams[index] then
      self.atkTeams[index] = nil
    end
    return
  end
  if index < 1 or 3 < index then
    return
  end
  local atkTeams = self.atk[typeKOF]
  local info = atkTeams[index]
  info = info or ArenaArmyFormationInfo.New()
  data.index = index
  info:ParseData(data, true)
  atkTeams[index] = info
end

function LWKOFBattleManager:SetOpponentData(data)
  self.opponentData = data
end

function LWKOFBattleManager:GetOpponentData()
  return self.opponentData
end

function LWKOFBattleManager:GetOpponentDefenceTeam(index)
  if not self.opponentData then
    return nil
  end
  return self.opponentData.teams[index]
end

function LWKOFBattleManager:SwitchAtkTeam(index1, index2)
  if not self.atkTeams then
    return
  end
  local team1 = self.atkTeams[index1]
  local team2 = self.atkTeams[index2]
  self.atkTeams[index1] = team2
  self.atkTeams[index2] = team1
end

function LWKOFBattleManager:GetHeroInAtkTeamIndex(uuid)
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

function LWKOFBattleManager:GetCurrentTeamBuffBuildingUuid(squadIndex)
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

function LWKOFBattleManager:GetTeamIndexUsingBuff(buffIndex)
  if not self.atkTeams then
    return nil
  end
  for i, v in pairs(self.atkTeams) do
    if v.localSquadNo == buffIndex then
      return i
    end
  end
end

function LWKOFBattleManager:GetDefTeamIndexUsingBuff(buffIndex)
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

function LWKOFBattleManager:SetTeamUsingBuff(teamIndex, buffIndex)
  if not self.atkTeams then
    return
  end
  local team = self.atkTeams[teamIndex]
  if not team then
    return
  end
  team.localSquadNo = buffIndex
end

function LWKOFBattleManager:SetDefTeamUsingBuff(teamIndex, buffIndex)
  local defTeams = self:GetSelfDefTeams()
  if not defTeams then
    return
  end
  local team = defTeams[teamIndex]
  if not team then
    return
  end
  team.localSquadNo = buffIndex
end

function LWKOFBattleManager:CheckNilTeamIndex()
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

function LWKOFBattleManager:StartBattle()
  if not self.opponentData then
    return false
  end
  local atkTeams = self.atkTeams
  if table.IsNullOrEmpty(atkTeams) then
    return false
  end
  for i = 1, 3 do
    local team = atkTeams[i]
    if not team or table.IsNullOrEmpty(team:GetLocalAllHeroes()) then
      UIUtil.ShowTips(Localization:GetString("500253", i))
      return false
    end
  end
  local sfsArray = self:FormationToSFS(atkTeams)
  if self.curType == TypeKOF.Train then
    local trainData = self.opponentData.trainData
    SFSNetwork.SendMessage(MsgDefines.AllianceTrainAttackKOF, trainData.uuid, trainData.serverId, sfsArray)
  elseif self.curType == TypeKOF.NewPeakArena then
    local playerInfo = self.opponentData.playerInfo
    SFSNetwork.SendMessage(MsgDefines.NewArenaKofBattleMessage, playerInfo.uid, sfsArray)
  end
  return true
end

function LWKOFBattleManager:RobTrain()
  local curType = DataCenter.LWBattleManager:GetCurBattleType()
  local curEnterType = DataCenter.LWBattleManager:GetPVEEnterType()
  if curType == PVEType.KOF and curEnterType == PVEEnterType.TrainRob then
    return
  end
  local param = {}
  param.type = PVEType.KOF
  param.enterType = PVEEnterType.TrainRob
  param.levelId = -1
  param.sceneId = 51
  param.extraData = {}
  param.extraData.squadIndex = 1
  param.extraData.openWindow = true
  param.extraData.trainData = self.opponentData.trainData
  DataCenter.LWBattleManager:Enter(param)
end

function LWKOFBattleManager:TryRefreshRobTrain(uuid)
  if self.opponentData and self.opponentData.trainData and self.opponentData.trainData.uuid == uuid and self.opponentData.teams then
    for i, v in pairs(self.opponentData.trainData.teamList) do
      self.opponentData.teams[i] = RailwayUtil.ParseTeamInfo(v)
    end
    self.opponentData.power = self.opponentData.trainData.power or 0
    EventManager:GetInstance():Broadcast(EventId.RobTrainTryRefreshView, uuid)
  end
end

function LWKOFBattleManager:GetSelfDefTeams()
  if not self.playersDefTeams then
    return nil
  end
  local uuid = LuaEntry.Player.uid
  return self.playersDefTeams[uuid]
end

function LWKOFBattleManager:GetSelfDefTeamByIndex(index)
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

function LWKOFBattleManager:GetSelfEmptyDefTeam()
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

function LWKOFBattleManager:SaveDefTeams()
  local defTeams = self:GetSelfDefTeams()
  if table.IsNullOrEmpty(defTeams) then
    return
  end
  local hasEmptyTeam = self:GetSelfEmptyDefTeam() ~= nil
  if hasEmptyTeam then
    return
  end
  local changedTeams
  if self.curType == TypeKOF.Train then
    changedTeams = self:GetDirtySelfDefTeams()
  elseif self.curType == TypeKOF.NewPeakArena then
    local uuid = LuaEntry.Player.uid
    changedTeams = self.playersDefTeams[uuid]
  end
  if table.IsNullOrEmpty(changedTeams) then
    return
  end
  local sfsArray = self:FormationToSFS(changedTeams)
  if self.curType == TypeKOF.Train then
    SFSNetwork.SendMessage(MsgDefines.AllianceTrainAssignArmy, sfsArray)
  elseif self.curType == TypeKOF.NewPeakArena then
    SFSNetwork.SendMessage(MsgDefines.NewArenaKofSaveMessage, sfsArray)
  end
end

function LWKOFBattleManager:FormationToSFS(teams)
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

function LWKOFBattleManager:GetDirtySelfDefTeams()
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

function LWKOFBattleManager:GetHeroInSelfDefTeamIndex(uuid)
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

function LWKOFBattleManager:SwitchSelfDefTeam(index1, index2)
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
  EventManager:GetInstance():Broadcast(EventId.KOFSwitchDefTeamOrder, {oldIndex = index1, newIndex = index2})
end

function LWKOFBattleManager:GetSelfAtkTeamOrderByIdx(index)
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

function LWKOFBattleManager:GetSelfDefTeamOrderByIdx(index)
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

function LWKOFBattleManager:PackSelfPlayerInfo(score)
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
    score = score
  }
  return selfPlayerInfo
end

function LWKOFBattleManager:RequestRecordsMails(record)
  local log = record
  local mailUid = log.mailUid
  if not string.IsNullOrEmpty(mailUid) then
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

function LWKOFBattleManager:IsMailRequested(mailUid)
  local state = self.recordsMailState[mailUid]
  if state == nil then
    state = 0
  end
  return state == 1 or state == 2
end

function LWKOFBattleManager:IsMailParsed(mailUid)
  local state = self.recordsMailState[mailUid]
  if state == nil then
    state = 0
  end
  return state == 2
end

function LWKOFBattleManager:IsRecordsParsed(record)
  if not record then
    return false
  end
  if not self:IsMailParsed(record.mailUid) then
    return false
  end
  return true
end

function LWKOFBattleManager:IsRecordRequested(record)
  if not record then
    return false
  end
  if not self:IsMailRequested(record.mailUid) then
    return false
  end
  return true
end

function LWKOFBattleManager:ParseWeaponInfo(msg)
  if not msg then
    return
  end
  if msg then
    local onwerInfo = msg
    local uuid = onwerInfo.playerInfo.uid
    self.playerWeaponInfos[uuid] = onwerInfo.weapon
  end
end

function LWKOFBattleManager:GetWeaponInfo(uuid)
  if not self.playerWeaponInfos then
    return nil
  end
  return self.playerWeaponInfos[uuid]
end

function LWKOFBattleManager:GetOpponentWeaponInfo()
  if not self.opponentData then
    return nil
  end
  local uuid = self.opponentData.playerInfo.uid
  return self:GetWeaponInfo(uuid)
end

function LWKOFBattleManager:SetDefTeamUsingChipSet(index, chipSetId)
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

function LWKOFBattleManager:GetDefTeamUsingChipSet(index)
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

function LWKOFBattleManager:SetTeamUsingChipSet(index, chipSetId)
  if not self.atkTeams then
    return
  end
  local team = self.atkTeams[index]
  if not team then
    return
  end
  team.localChipSetId = chipSetId
end

function LWKOFBattleManager:GetTeamUsingChipSet(index)
  if not self.atkTeams then
    return nil
  end
  local team = self.atkTeams[index]
  if not team then
    return nil
  end
  return team.localChipSetId
end

function LWKOFBattleManager:OpenBattleResultView(battleMsg, finialAtkLoseNoMap, finialDefLoseNoMap, atkKillMap, defKillMap)
  if self.curType == TypeKOF.Train then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITrainKOFBattleResult, {anim = false}, battleMsg, finialAtkLoseNoMap, finialDefLoseNoMap, atkKillMap, defKillMap)
  elseif self.curType == TypeKOF.NewPeakArena then
    UIManager:GetInstance():OpenWindow(UIWindowNames.NewPeakArenaKOFBattleResult, {anim = false}, battleMsg, finialAtkLoseNoMap, finialDefLoseNoMap, atkKillMap, defKillMap)
  end
end

function LWKOFBattleManager:SetIsQuickRob(isQuick)
  self.isQuickRob = isQuick
end

function LWKOFBattleManager:GetIsQuickRob()
  return self.isQuickRob
end

return LWKOFBattleManager
