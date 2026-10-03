local ActEpidemicZoneActivityInfo = BaseClass("ActEpidemicZoneActivityInfo")
local ActEpidemicZoneActivityRoleInfo = require("DataCenter.ActEpidemicZoneManager.ActEpidemicZoneActivityRoleInfo")

function ActEpidemicZoneActivityInfo:__init()
  self.actId = 0
  self.currentStage = -1
  self.stageEndTime = 0
  self.allianceIcon = nil
  self.selfGroup = 0
  self.selfAssigned = 0
  self.leaveCDTime = 0
  self.groupA = {}
  self.groupB = {}
  self.hadTeam2 = 0
  self.groupCloseEndTime = 0
  self.sCfgId = 0
  self.season = 0
  self.seasonMapInfo = nil
end

function ActEpidemicZoneActivityInfo:__delete()
end

function ActEpidemicZoneActivityInfo:GetStage()
  return self.currentStage
end

function ActEpidemicZoneActivityInfo:CanAssignPlayer()
  return self.currentStage == EpidemicZoneStage.SignIn
end

function ActEpidemicZoneActivityInfo:GetRoleByGroup(group)
  local _g = group == ActEpidemicUtils.Group1 and self.groupA or self.groupB
  return _g.selfRole or EpidemicZoneRole.Default
end

function ActEpidemicZoneActivityInfo:GetRoleInfoByGroupAndSide(group, side)
  local _g = group == ActEpidemicUtils.Group1 and self.groupA or self.groupB
  if _g then
    return _g.rolesBySide[side]
  end
  return nil
end

function ActEpidemicZoneActivityInfo:Refresh(msg)
  ActEpidemicUtils.Log("\229\136\183\230\150\176\230\180\187\229\138\168\228\191\161\230\129\175...")
  local newStage = msg.stage
  local stageChanged = newStage ~= self.currentStage
  self.currentStage = newStage
  self.stageEndTime = msg.stageEndTime or 0
  self.allianceIcon = msg.allianceIcon or ""
  self.selfGroup = 0
  self.selfAssigned = 0
  self.leaveCDTime = msg.leaveCDTime or 0
  self.editorUid = msg.editorUid or ""
  self.actId = msg.actId or 0
  self.groupCloseEndTime = msg.groupCloseEndTime or 0
  self.sCfgId = msg.battleFieldConfigId or 0
  self.season = msg.season or 0
  local battleTimes = msg.battleTimes
  self.battleTimes = {}
  if battleTimes then
    for _, v in ipairs(battleTimes) do
      local bp = v.battlePeriod
      self.battleTimes[bp] = {
        battlePeriod = bp,
        startTime = v.startTime,
        endTime = v.endTime,
        readyTime = v.readyTime
      }
    end
  end
  if msg.group then
    local group
    for k, v in ipairs(msg.group) do
      group = k == ActEpidemicUtils.Group1 and self.groupA or self.groupB
      group.group = k
      group.state = v.state
      group.battlePeriod = v.battlePeriod or 0
      group.lastBattlePeriod = v.lastBattlePeriod or 0
      local bts = self.battleTimes[group.battlePeriod] or self.battleTimes[1] or {}
      group.startTime = (bts.startTime or 0) / 1000
      group.endTime = (bts.endTime or 0) / 1000
      group.readyTime = (bts.readyTime or 0) / 1000
      group.selfAssigned = v.selfAssigned or 0
      group.roles = {}
      group.rolesBySide = {}
      group.selfSide = EpidemicBattleSide.Default
      group.selfRole = EpidemicZoneRole.Default
      group.selfRoleInfo = nil
      group.roleGroupId = v.roleGroupId
      group.lordRandomSkillId = -1
      group.lordBattleInfo = {}
      group.lordBattleInfo.score = 0
      group.lordBattleInfo.count = 0
      group.farmerBattleInfo = {}
      group.farmerBattleInfo.score = 0
      group.farmerBattleInfo.count = 0
      group.totalBattleMemberCount = group.lordBattleInfo.count + group.farmerBattleInfo.count
      group.battleServerId = v.battleServerId
      group.battleWorldId = v.battleWorldId
      if group.state ~= EpidemicZoneSignState.StateSignNone then
        if 0 < group.selfAssigned then
          self.selfGroup = k
          self.selfAssigned = v.selfAssigned
        end
        if not table.IsNullOrEmpty(v.roleInfo) then
          for _, _role in ipairs(v.roleInfo) do
            if not table.IsNullOrEmpty(_role) then
              local role = ActEpidemicZoneActivityRoleInfo.New()
              role:Update(_role)
              table.insert(group.roles, role)
              if role.oneself then
                group.selfSide = role.side
                group.selfRole = role.role
                group.selfRoleInfo = role
              end
              if role.role == EpidemicZoneRole.Lord then
                group.lordRandomSkillId = role.randomSkillId
              end
              group.rolesBySide[role.side] = role
            end
          end
        end
        if v.showInfo then
          group.showInfo = {}
          group.showInfo.isWin = v.showInfo.isWin
          if v.showInfo.mvp then
            group.showInfo.mvp = {}
            group.showInfo.mvp.score = v.showInfo.mvp.score
            group.showInfo.mvp.name = v.showInfo.mvp.name
            group.showInfo.mvp.uid = v.showInfo.mvp.uid
            group.showInfo.mvp.pic = v.showInfo.mvp.pic
            group.showInfo.mvp.picVer = v.showInfo.mvp.picVer
            group.showInfo.mvp.abbr = v.showInfo.mvp.abbr
          end
        end
      end
    end
  end
  self:RefreshHadTeam2()
  if stageChanged then
    EventManager:GetInstance():Broadcast(EventId.ActEpidemicOnActInfoStageChanged)
  end
  EventManager:GetInstance():Broadcast(EventId.ActEpidemicOnActInfoRefresh)
end

function ActEpidemicZoneActivityInfo:RefreshHadTeam2()
  local bState = ActEpidemicUtils.GetTeamBState()
  local flag
  if self:CanAssignPlayer() then
    flag = bState ~= EpidemicZoneSignState.StateBan
  else
    flag = bState == EpidemicZoneSignState.StateSignSuc or bState == EpidemicZoneSignState.StateMatchSuc
  end
  self.hadTeam2 = flag and 1 or 0
end

function ActEpidemicZoneActivityInfo:GetMyGroupIdx()
  return self.selfGroup
end

function ActEpidemicZoneActivityInfo:GetMyGroup()
  return self:GetGroup(self:GetMyGroupIdx())
end

function ActEpidemicZoneActivityInfo:GetGroup(idx)
  if idx == 1 then
    return self.groupA
  end
  if idx == 2 then
    return self.groupB
  end
  return nil
end

function ActEpidemicZoneActivityInfo:GetGroupSignState(idx)
  local group = self:GetGroup(idx)
  if not group then
    return nil
  end
  return group.state
end

function ActEpidemicZoneActivityInfo:GetSideByGroup(group)
  local groupInfo = self:GetGroup(group)
  if groupInfo then
    return groupInfo.selfSide
  end
  return EpidemicBattleSide.Default
end

function ActEpidemicZoneActivityInfo:GetRoleByGroup(group)
  local groupInfo = self:GetGroup(group)
  if groupInfo then
    return groupInfo.selfRole
  end
  return EpidemicZoneRole.Default
end

function ActEpidemicZoneActivityInfo:GetRoleInfoByGroup(group)
  local groupInfo = self:GetGroup(group)
  if groupInfo and #groupInfo.roles > 0 then
    local selfAllianceId = LuaEntry.Player:GetAllianceUid()
    for _, v in ipairs(groupInfo.roles) do
      if v.allianceId == selfAllianceId then
        return v
      end
    end
  end
  return nil
end

function ActEpidemicZoneActivityInfo:GetAllianceById(id)
  local allianceIds = self:GetAlliances()
  for _, v in pairs(allianceIds) do
    if v.allianceId == id then
      return v
    end
  end
  return nil
end

function ActEpidemicZoneActivityInfo:GetAlliances()
  local allianceIds = {}
  if self.groupA and #self.groupA.roles > 0 then
    for _, v in ipairs(self.groupA.roles) do
      allianceIds[v.allianceId] = v
    end
  end
  if self.groupB and 0 < #self.groupB.roles then
    for _, v in ipairs(self.groupB.roles) do
      allianceIds[v.allianceId] = v
    end
  end
  return allianceIds
end

function ActEpidemicZoneActivityInfo:GetAlNameAndIcon(id)
  local alInfo = self:GetAllianceById(id)
  if alInfo then
    return alInfo.abbr, alInfo.name, alInfo.icon
  end
  return "", "", ""
end

function ActEpidemicZoneActivityInfo:FetchAllianceMemberData(group)
  local groupInfo = self:GetGroup(group)
  if groupInfo then
    for _, v in ipairs(groupInfo.roles) do
      SFSNetwork.SendMessage(MsgDefines.AlRank, v.allianceId)
    end
  end
end

function ActEpidemicZoneActivityInfo:BSelfArbiter(group)
  local roleInfo = self:GetRoleInfoByGroup(group)
  local arbiter = roleInfo ~= nil and roleInfo.arbiter or nil
  local uid = arbiter ~= nil and arbiter.uid or nil
  if uid == LuaEntry.Player:GetUid() then
    return true
  end
  return false
end

function ActEpidemicZoneActivityInfo:UpdateSignUpState(group, role, battlePeriod)
  local _g = group == ActEpidemicUtils.Group1 and self.groupA or self.groupB
  if role ~= nil then
    _g.role = role
  end
  _g.state = EpidemicZoneSignState.StateSignSuc
  if battlePeriod ~= nil then
    _g.battlePeriod = battlePeriod
  end
  ActEpidemicUtils.Log("\230\137\139\229\138\168\228\191\174\230\148\185\228\186\134\230\180\187\229\138\168\230\150\176\231\154\132\230\138\165\229\144\141\231\138\182\230\128\129~")
end

function ActEpidemicZoneActivityInfo:GetActStartTime()
  local actBaseInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.actId)
  if not actBaseInfo then
    return 0
  end
  return actBaseInfo.startTime
end

function ActEpidemicZoneActivityInfo:GetMvpShowInfo(group)
  local group = group == ActEpidemicUtils.Group1 and self.groupA or self.groupB
  return group and group.showInfo
end

function ActEpidemicZoneActivityInfo:UpdateBattleScore(groupIndex, data)
  local group
  if groupIndex == ActEpidemicUtils.Group1 then
    group = self.groupA
  elseif groupIndex == ActEpidemicUtils.Group2 then
    group = self.groupB
  end
  if not group then
    return
  end
  for k, v in ipairs(data) do
    local role = v.role
    if role == EpidemicZoneRole.Lord then
      group.lordBattleInfo.score = v.score
      group.lordBattleInfo.count = v.count
    elseif role == EpidemicZoneRole.Farmer then
      group.farmerBattleInfo.score = v.score
      group.farmerBattleInfo.count = v.count
    end
  end
end

function ActEpidemicZoneActivityInfo:Description()
  local sb = StringBuilder.New()
  local time = UITimeManager:GetInstance()
  local stateConvert = {
    [EpidemicZoneSignState.StateSignNone] = "\230\156\170\230\138\165\229\144\141(0)",
    [EpidemicZoneSignState.StateSignSuc] = "\229\183\178\230\138\165\229\144\141(1)",
    [EpidemicZoneSignState.StateBan] = "\229\183\178\230\148\190\229\188\131(2)",
    [EpidemicZoneSignState.StateMatchFailed] = "\229\140\185\233\133\141\229\164\177\232\180\165(3)",
    [EpidemicZoneSignState.StateMatchSuc] = "\229\140\185\233\133\141\230\136\144\229\138\159(4)"
  }
  local roleConvert = {
    [EpidemicBattleSide.Default] = "\230\151\160(0)",
    [EpidemicBattleSide.Lord] = "\229\156\176\228\184\187(1)",
    [EpidemicBattleSide.FarmerL] = "\229\134\156\230\176\145(\229\183\166)(2)",
    [EpidemicBattleSide.FarmerR] = "\229\134\156\230\176\145(\229\143\179)(2)"
  }
  sb:AppendFormatLine("\230\180\187\229\138\168Id\239\188\154%s", self.actId)
  local actBaseInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.actId)
  if not actBaseInfo then
    sb:AppendFormatLine("!!\230\137\190\228\184\141\229\136\176\230\180\187\229\138\168\229\136\151\232\161\168\228\184\173\231\154\132\228\191\161\230\129\175")
  else
    sb:AppendFormatLine(actBaseInfo:Description())
  end
  sb:AppendFormatLine("\232\181\155\229\173\163:%s", self.season)
  sb:AppendFormatLine("\229\189\147\229\137\141\233\152\182\230\174\181\239\188\154%s[%s]", self.currentStage, ActEpidemicUtils.DebugGetStageName(self.currentStage))
  sb:AppendFormatLine("\229\189\147\229\137\141\233\152\182\230\174\181\231\187\147\230\157\159\230\151\182\233\151\180\239\188\136\230\156\172\229\156\176\239\188\137:%s", time:TimeStampToTimeForLocal(self.stageEndTime * 1000))
  sb:AppendFormatLine("\230\180\187\229\138\168\229\188\128\229\167\139\230\151\182\233\151\180\239\188\136\230\156\172\229\156\176\239\188\137:%s", time:TimeStampToTimeForLocal(self:GetActStartTime()))
  sb:AppendFormatLine("\229\189\147\229\137\141\230\151\182\233\151\180\239\188\136\230\156\172\229\156\176\239\188\137:%s", time:TimeStampToTimeForLocal(time:GetServerTime()))
  sb:AppendFormatLine("\232\135\170\229\183\177\230\152\175\229\144\166\230\138\165\229\144\141 :%s", self.selfAssigned)
  sb:AppendFormatLine("\232\135\170\229\183\177\231\154\132\231\187\132 :%s", self.selfGroup)
  sb:AppendFormatLine("\232\135\170\229\183\177\231\166\187\229\188\128\230\136\152\229\156\186CD\231\187\147\230\157\159\230\151\182\233\151\180\239\188\136\230\156\172\229\156\176\239\188\137:%s", time:TimeStampToTimeForLocal(self.leaveCDTime * 1000))
  sb:AppendFormatLine("\230\180\187\229\138\168\232\175\166\230\131\133\239\188\154")
  local _ = {
    self.groupA,
    self.groupB
  }
  for k, group in ipairs(_) do
    sb:AppendFormatLine(k == 1 and "---A\231\187\132---" or "---B\231\187\132---")
    sb:AppendFormatLine("\230\138\165\229\144\141\231\138\182\230\128\129:%s,", stateConvert[group.state] or group.state)
    sb:AppendFormatLine("\230\156\172\232\129\148\231\155\159\232\167\146\232\137\178:%s,", roleConvert[group.selfRole] or group.selfRole)
    sb:AppendFormatLine("battleServerId:%s,", group.battleServerId)
    sb:AppendFormatLine("battleWorldId:%s,", group.battleWorldId)
    if group.roles then
      sb:AppendFormatLine("\230\136\144\229\145\152\230\149\176:%s", #group.roles)
      for _, r in ipairs(group.roles) do
        sb:AppendFormatLine(r:Description())
      end
      sb:AppendLine("------")
    else
      sb:AppendLine("\230\137\190\228\184\141\229\136\176\230\136\144\229\145\152\228\191\161\230\129\175")
    end
  end
  return sb:ToString()
end

return ActEpidemicZoneActivityInfo
