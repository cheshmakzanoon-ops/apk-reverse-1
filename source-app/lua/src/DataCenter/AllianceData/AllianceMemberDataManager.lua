local AllianceMemberDataManager = BaseClass("AllianceMemberDataManager")
local PlayerBuilding = CS.WorldPointType.PlayerBuilding
local AllianceMemberShowInfo = require("DataCenter.AllianceData.AllianceMemberShowInfo")

local function __init(self)
  self.allianceMembers = {}
  self.memberApplyList = {}
  self.allianceOfficial = {}
  self.cacheApplyList = {}
  self.alliancePositionDic = {}
  self.allianceMembersHomePos = {}
  self.alreadyShowLeaderAlert = false
  self.r4MaxMemberNum = 0
  self.curPointId = 0
  self.curServerId = 0
  self.curUid = ""
  self.memberChanged = false
  self.newJoinMembersInfo = {}
  self.allianceRankName = {}
  self.allianceRankVisible = 1
  self.myAllianceR4MemberList = {}
  self.needShowR4Recommend = false
  self.r4RecommendMemberList = {}
  self.r4RecommendTagConfig = {}
  self.reqAlRankTime = 0
  EventManager:GetInstance():AddListener(EventId.OnPassDay, self.OnPassDay)
end

local function __delete(self)
  self.allianceMembers = nil
  self.memberApplyList = nil
  self.allianceOfficial = nil
  self.cacheApplyList = nil
  self.alliancePositionDic = nil
  self.allianceMembersHomePos = nil
  self.alreadyShowLeaderAlert = false
  self.r4MaxMemberNum = nil
  self.curPointId = nil
  self.curServerId = nil
  self.curUid = nil
  self.memberChanged = false
  self.newJoinMembersInfo = {}
  self.allianceRankName = {}
  self.allianceRankVisible = 1
  self.myAllianceR4MemberList = nil
  self.needShowR4Recommend = false
  self.r4RecommendMemberList = nil
  self.r4RecommendTagConfig = nil
  self.reqAlRankTime = 0
  EventManager:GetInstance():RemoveListener(EventId.OnPassDay, self.OnPassDay)
end

function AllianceMemberDataManager:OnPassDay()
  local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if data then
    local tempAlId = data.uid
    if tempAlId and tempAlId ~= "" and DataCenter.AllianceBaseDataManager:IsSelfLeader() then
      SFSNetwork.SendMessage(MsgDefines.AllianceRecommendR4CandidateCheck)
    end
  end
end

local function TryInitMemberList(self, forceUpdate)
  if not forceUpdate and self.allianceMembers and table.count(self.allianceMembers) > 0 then
    return
  end
  local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if data then
    local tempAlId = data.uid
    if tempAlId and tempAlId ~= "" then
      SFSNetwork.SendMessage(MsgDefines.AlRank, tempAlId)
      if DataCenter.AllianceBaseDataManager:IsSelfLeader() then
        SFSNetwork.SendMessage(MsgDefines.AllianceRecommendR4CandidateCheck)
      end
    end
  end
end

local function UpdateMemberPoint(self, message)
  if message.pointId ~= nil then
    self.curPointId = message.pointId
  end
  if message.serverId ~= nil then
    self.curServerId = message.serverId
  end
  EventManager:GetInstance():Broadcast(EventId.Al_MemberPoint)
end

local function UpdateMemberUid(self, uid)
  self.curUid = uid
end

local function GetMemberPoint(self)
  return self.curPointId, self.curServerId, self.curUid
end

local function UpdateAllianceApplyList(self, message)
  if message.list ~= nil then
    self.memberApplyList = {}
    self.cacheApplyList = {}
    if #message.list == 0 then
      EventManager:GetInstance():Broadcast(EventId.OnGetNewAlJoinReq)
      EventManager:GetInstance():Broadcast(EventId.UpdateMainAllianceRedCount)
      return
    end
    table.walk(message.list, function(k, v)
      local member = AllianceMemberInfo.New()
      member:ParseData(v)
      if member.uid ~= nil and member.uid ~= "" then
        self.memberApplyList[member.uid] = member
        self:OnRecvNewApplyReq(member.uid, 1)
      end
    end)
  end
end

local function UpdateAllianceMemberList(self, message)
  self.reqAlRankTime = UITimeManager:GetInstance():GetServerTime()
  if message.list ~= nil then
    self.memberChanged = false
    self.allianceMembers = {}
    table.walk(message.list, function(k, v)
      local member = AllianceMemberInfo.New()
      member:ParseData(v)
      if member.uid ~= nil and member.uid ~= "" then
        self.allianceMembers[member.uid] = member
        self.allianceMembersHomePos[member.pointId] = member.uid
      end
    end)
    DataCenter.WorldMarchDataProxy:CacheAllianceMembersHomePos()
  end
  if message.r4MaxNum then
    self.r4MaxMemberNum = message.r4MaxNum
  end
end

local function UpdateAllianceOfficial(self, message)
  if message.allianceOfficial ~= nil then
    local official = message.allianceOfficial
    if official["1"] ~= nil then
      self.allianceOfficial["1"] = official["1"]
    end
    if official["2"] ~= nil then
      self.allianceOfficial["2"] = official["2"]
    end
    if official["3"] ~= nil then
      self.allianceOfficial["3"] = official["3"]
    end
    if official["4"] ~= nil then
      self.allianceOfficial["4"] = official["4"]
    end
  end
end

local function DeleteAllianceOfficial(self, message)
  if message.rank ~= nil and message.playerId ~= nil then
    local rank = message.rank
    local playerUid = message.playerId
    local officialPos = self:GetOfficialByUid(playerUid)
    self.allianceOfficial[officialPos] = ""
    local memberData = self:GetAllianceMemberByUid(playerUid)
    if memberData ~= nil then
      memberData:SetRank(rank)
    end
  end
end

local function GetOfficialByUid(self, uid)
  local officialPos = ""
  table.walk(self.allianceOfficial, function(k, v)
    if v == uid then
      officialPos = k
    end
  end)
  return officialPos
end

local function SetAllianceRank(self, message)
  if message.playerId ~= nil then
    local playerId = message.playerId
    local member = self:GetAllianceMemberByUid(playerId)
    if member ~= nil and message.rank ~= nil then
      member:SetRank(message.rank)
    end
    if message.officalType ~= nil then
      self:UpdateOneAlliancePos(message.officalType, playerId)
    end
    if message.rank ~= nil then
      if message.rank ~= 4 then
        self:DeleteR4MemberData(playerId)
      else
        self:AddR4MemberData(message)
      end
    end
  end
end

local function GetAllianceApplyRedCount(self)
  if DataCenter.AllianceBaseDataManager:IsR4orR5() then
    return self:GetApplyCount()
  else
    return 0
  end
end

local function GetApplyCount(self)
  return table.count(self.cacheApplyList)
end

local function ClearCacheApplyList(self)
  self.cacheApplyList = {}
end

local function GetAllianceMemberByUid(self, uid)
  return self.allianceMembers[uid]
end

local function GetAllianceMemberMyself(self)
  return self.allianceMembers[LuaEntry.Player.uid]
end

local function GetAllianceMemberCount(self)
  return table.count(self.allianceMembers)
end

local function GetRandomMember(self)
  local count = self:GetAllianceMemberCount()
  if count == 0 then
    return nil
  end
  local randomIndex = math.random(count)
  local index = 0
  for _, v in pairs(self.allianceMembers) do
    index = index + 1
    if index == randomIndex then
      return v
    end
  end
end

local function GetApplyMemberList(self)
  return self.memberApplyList
end

function AllianceMemberDataManager:IsMemberHouse(pointId)
  local uid = self.allianceMembersHomePos[pointId]
  if uid ~= nil then
    if self.allianceMembers[uid] == nil then
      self.allianceMembersHomePos[pointId] = nil
      return false
    end
    return true
  end
  return false
end

local function GetAllianceMemberListByRank(self, rank)
  local list = {}
  local onlineNum = 0
  table.walk(self.allianceMembers, function(k, v)
    if v.rank == rank then
      if v.online == true then
        onlineNum = onlineNum + 1
      end
      table.insert(list, v)
    end
  end)
  table.sort(list, function(a, b)
    if a.online ~= b.online then
      return a.online
    elseif a.online then
      return a.uid < b.uid
    elseif a.offLineTime ~= b.offLineTime then
      return a.offLineTime > b.offLineTime
    else
      return a.uid < b.uid
    end
  end)
  return list, onlineNum
end

local function RemoveAllianceMemberByUid(self, uid)
  local member = self.allianceMembers[uid]
  if member ~= nil then
    self.allianceMembersHomePos[member.pointId] = nil
    self.allianceMembers[uid] = nil
  end
end

local function AllianceLeaderChange(self, oldLeaderUid, newLeaderUid, oldLeaderRank)
  if self.allianceMembers[oldLeaderUid] ~= nil then
    self.allianceMembers[oldLeaderUid]:SetRank(oldLeaderRank)
  end
  if self.allianceMembers[newLeaderUid] ~= nil then
    local officialPos = self:GetOfficialByUid(newLeaderUid)
    if officialPos ~= nil and officialPos ~= "" then
      self.allianceOfficial[officialPos] = ""
    end
    self.allianceMembers[newLeaderUid]:SetRank(5)
  end
end

local function UpdateOneAllianceApply(self, uid, isAccept)
  if self.memberApplyList[uid] ~= nil then
    self.memberApplyList[uid] = nil
  end
end

local function GetAllianceMemberByPointId(self, pointId)
  for k, v in pairs(self.allianceMembers) do
    if v.pointId == pointId then
      return v
    end
  end
end

local function GetNearMember(self)
  local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
  if mainBuild ~= nil then
    local vec2 = SceneUtils.IndexToTilePos(mainBuild.pointId)
    local list = DataCenter.BirthPointTemplateManager:GetPointInMyBaseRange(vec2.x, vec2.y)
    for k, v in pairs(list) do
      local perIndex = SceneUtils.TilePosToIndex(v)
      if perIndex ~= mainBuild.pointId then
        local member = self:GetAllianceMemberByPointId(perIndex)
        if member ~= nil then
          return member
        end
      end
    end
  end
end

local function GetAllNearMember(self)
  local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
  if mainBuild ~= nil then
    local vec2 = SceneUtils.IndexToTilePos(mainBuild.pointId)
    local list = DataCenter.BirthPointTemplateManager:GetAllPointsByOffset(vec2.x, vec2.y, ScreenAllianceBirthCount, ScreenAllianceBirthCount)
    local result = {}
    for k, v in pairs(list) do
      local perIndex = SceneUtils.TilePosToIndex(v)
      if perIndex ~= mainBuild.pointId then
        local member = self:GetAllianceMemberByPointId(perIndex)
        if member ~= nil then
          table.insert(result, member)
        end
      end
    end
    if table.count(result) > 0 then
      return result
    end
  end
end

local function OnRecvNewApplyReq(self, uid, add)
  if add and add == 1 then
    if not table.hasvalue(self.cacheApplyList, uid) then
      table.insert(self.cacheApplyList, uid)
    end
  else
    table.removebyvalue(self.cacheApplyList, uid)
  end
  EventManager:GetInstance():Broadcast(EventId.OnGetNewAlJoinReq)
  EventManager:GetInstance():Broadcast(EventId.UpdateMainAllianceRedCount)
end

local function UpdateAlMemberRecommendNum(self, t)
  if t.recommendUserSize then
    self.recommendUserSize = t.recommendUserSize
  end
end

local function UpdateAlMemberRecommendList(self, t)
  if t.recommendUserList then
    self.recommendUserList = {}
    for i, v in pairs(t.recommendUserList) do
      local newOne = AllianceMemberInfo.New()
      newOne:ParseData(v)
      table.insert(self.recommendUserList, newOne)
    end
  end
  if self.recommendUserList and #self.recommendUserList > 0 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAlMemberRecommend)
  end
end

local function UpdateAlliancePosition(self, t)
  self.alliancePositionDic = {}
  if t.allianceOfficialArr then
    for i, v in ipairs(t.allianceOfficialArr) do
      local uid = v.uid
      local pos = v.type
      self.alliancePositionDic[pos] = uid
    end
  end
end

local function UpdateOneAlliancePos(self, type, uid)
  for i, v in pairs(self.alliancePositionDic) do
    if v == uid then
      self.alliancePositionDic[i] = nil
    end
  end
  if 0 < type then
    self.alliancePositionDic[type] = uid
  end
  EventManager:GetInstance():Broadcast(EventId.OnAllianceOfficialPosChange)
end

local function GetMemberInfoByOfficialPos(self, pos)
  local uid = self.alliancePositionDic[pos]
  if uid then
    return self:GetAllianceMemberByUid(uid)
  end
end

local function GetOfficialPosByUid(self, uid)
  for i, v in pairs(self.alliancePositionDic) do
    if v == uid then
      return i
    end
  end
end

local function CheckIfHasRecommendMember(self)
  return self.recommendUserSize and self.recommendUserSize > 0
end

local function GetRecommendMemberList(self)
  return self.recommendUserList
end

local function GetAllMember(self)
  return self.allianceMembers
end

local function GetInactivePlayerCount(self, rank)
  if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
    return 0
  end
  local memberList = {}
  if rank then
    memberList = self:GetAllianceMemberListByRank(rank)
  else
    memberList = self:GetAllMember()
  end
  local retNum = 0
  for i, v in pairs(memberList) do
    if v:CheckIfIsInactivePlayer() then
      retNum = retNum + 1
    end
  end
  return retNum
end

local function GetInactiveConfTime(self, power)
  if not self.activeConfList then
    self.activeConfList = {}
    local k1 = LuaEntry.DataConfig:TryGetStr("member_not_active", "k1")
    if string.IsNullOrEmpty(k1) then
      k1 = "5000;1|20000;2|;3"
    end
    local confArr = string.split(k1, "|")
    for i, v in ipairs(confArr) do
      local strArr = string.split(v, ";")
      local newOne = {}
      newOne.power = string.IsNullOrEmpty(strArr[1]) and LongMaxValue or tonumber(strArr[1])
      newOne.timeH = tonumber(strArr[2])
      table.insert(self.activeConfList, newOne)
    end
    table.sort(self.activeConfList, function(a, b)
      if a.power ~= b.power then
        return a.power < b.power
      else
        return false
      end
    end)
  end
  local returnT = 0
  for i, v in ipairs(self.activeConfList) do
    if power < v.power then
      returnT = v.timeH
      break
    end
  end
  return returnT
end

local function GetAllianceMemberRedCount(self)
  if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
    return 0
  end
  if self.checkedInactiveMember then
    return 0
  end
  local count = self:GetInactivePlayerCount()
  return count
end

local function SetCheckedInactiveMember(self, isChecked)
  self.checkedInactiveMember = isChecked
end

local function CheckIfNeedInactiveMemberBubble(self)
  local strK = "InactiveMemberBubble_" .. LuaEntry.Player.uid
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local lastTimeS = CS.GameEntry.Setting:GetInt(strK, 0)
  if not UITimeManager:GetInstance():IsSameDayForServer(lastTimeS, curTime) then
    local inactiveCount = self:GetInactivePlayerCount()
    if 0 < inactiveCount then
      return inactiveCount
    end
  end
  return 0
end

local function SetInactiveMemberBubbleT(self)
  local strK = "InactiveMemberBubble_" .. LuaEntry.Player.uid
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  CS.GameEntry.Setting:SetInt(strK, curTime)
end

local function GetTableIndex(self, rank, official)
  if rank == 1 then
    return LWAlMemberAuthorityType.Rank_1
  elseif rank == 2 then
    return LWAlMemberAuthorityType.Rank_2
  elseif rank == 3 then
    return LWAlMemberAuthorityType.Rank_3
  elseif rank == 4 then
    if official == nil or official == "" then
      return LWAlMemberAuthorityType.Rank_4
    elseif official == 1 then
      return LWAlMemberAuthorityType.Official_1
    elseif official == 2 then
      return LWAlMemberAuthorityType.Official_2
    elseif official == 3 then
      return LWAlMemberAuthorityType.Official_3
    elseif official == 4 then
      return LWAlMemberAuthorityType.Official_4
    end
  elseif rank == 5 then
    return LWAlMemberAuthorityType.Rank_5
  end
  return nil
end

function AllianceMemberDataManager:GetAllianceMembersHomePosCount()
  return table.count(self.allianceMembersHomePos)
end

function AllianceMemberDataManager:GetAllianceMembersHomePos()
  return self.allianceMembersHomePos
end

function AllianceMemberDataManager:CheckPowerAndCount(count, power)
  local memList = self.allianceMembers
  if memList then
    local memCount = 0
    local powerOK = 0
    local checkCount = toInt(count)
    local checkPower = toInt(power)
    for _, data in pairs(memList) do
      if data then
        if checkPower <= toInt(data.power) then
          powerOK = powerOK + 1
        end
        memCount = memCount + 1
      end
    end
    return checkCount <= memCount, checkCount <= powerOK
  end
  return false, false
end

local function GetR4MaxMemberNum(self)
  return self.r4MaxMemberNum
end

local function SetCurMembers(self, curMembers)
  if curMembers == nil then
    return
  end
  local num = table.count(self.allianceMembers)
  if curMembers ~= num then
    self.memberChanged = true
  end
end

local function HasMemberChanged(self)
  return self.memberChanged
end

local function SetNewJoinMembersInfo(self, info)
  for _, v in pairs(info) do
    self.newJoinMembersInfo[v.uid] = v
  end
end

local function GetNewJoinMembersInfo(self)
  if not ChatInterface.IsJoinAlHighFiveOpen() then
    return {}
  end
  return self.newJoinMembersInfo or {}
end

local function GetHighFiveData(self, info)
  if not ChatInterface.IsJoinAlHighFiveOpen() then
    return
  end
  local pointType = info.pointType
  local ownerUid = info.ownerUid
  local allianceId = info.allianceId
  if pointType ~= PlayerBuilding then
    return
  end
  if not LuaEntry.Player:IsInAlliance() or allianceId ~= LuaEntry.Player.allianceId then
    return
  end
  if self.newJoinMembersInfo[ownerUid] == nil then
    return
  end
  if ownerUid ~= LuaEntry.Player.uid and self.newJoinMembersInfo[ownerUid].self == true then
    return
  end
  return self.newJoinMembersInfo[ownerUid]
end

function AllianceMemberDataManager:SendAllianceSetRank(uid, rankIndex, offcialIndex)
  local fireOffical = 0
  if rankIndex == 4 and offcialIndex == 0 then
    fireOffical = self:GetOfficialPosByUid(uid) or 0
  end
  SFSNetwork.SendMessage(MsgDefines.AllianceSetRank, uid, rankIndex, offcialIndex, fireOffical)
end

function AllianceMemberDataManager:GetAllShowData(rankGroupShowMember, keyword, fromSearch, autoShowMax)
  local allianceMembers = DataCenter.AllianceMemberDataManager.allianceMembers
  if allianceMembers == nil or rankGroupShowMember == nil then
    return {}
  end
  local rankMax = 4
  local rankGroupMember = {}
  local groupOnlineInfo = {}
  local originAllNum = {}
  local r4Num = 0
  for i = 1, rankMax do
    rankGroupMember[i] = {}
    groupOnlineInfo[i] = {online = 0, all = 0}
    originAllNum[i] = 0
  end
  for k, v in pairs(allianceMembers) do
    if rankMax >= v.rank then
      originAllNum[v.rank] = originAllNum[v.rank] + 1
      local isFind = true
      if not string.IsNullOrEmpty(keyword) then
        keyword = string.lower(keyword)
        local lowerName = string.lower(v.name)
        if not string.find(lowerName, keyword, 1, true) then
          local remarkName, haveRemark = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(v.uid, v.name)
          if haveRemark then
            remarkName = string.lower(remarkName)
            isFind = string.find(remarkName, keyword, 1, true)
          else
            isFind = false
          end
        end
      end
      if isFind then
        local memberData = ObjectPool:GetInstance():Load(AllianceMemberShowInfo)
        memberData:ParseItemData(v)
        table.insert(rankGroupMember[v.rank], memberData)
        if memberData.online == true then
          groupOnlineInfo[v.rank].online = groupOnlineInfo[v.rank].online + 1
        end
        groupOnlineInfo[v.rank].all = groupOnlineInfo[v.rank].all + 1
      end
    end
  end
  if autoShowMax then
    for i = rankMax, 1, -1 do
      if 0 < originAllNum[i] then
        rankGroupShowMember[i] = true
        break
      end
    end
  end
  for i, list in ipairs(rankGroupMember) do
    table.sort(list, function(a, b)
      if a.online ~= b.online then
        return a.online
      elseif a.online then
        return a.uid < b.uid
      elseif a.offLineTime ~= b.offLineTime then
        return a.offLineTime > b.offLineTime
      else
        return a.uid < b.uid
      end
    end)
  end
  local showList = {}
  if string.IsNullOrEmpty(keyword) then
    for i = rankMax, 1, -1 do
      local listData = ObjectPool:GetInstance():Load(AllianceMemberShowInfo)
      local data = {}
      data.showMember = rankGroupShowMember[i]
      data.onlineInfo = groupOnlineInfo[i]
      data.rankId = i
      data.originAllNum = originAllNum[i]
      listData:ParseListItemData(data)
      table.insert(showList, listData)
      if rankGroupShowMember[i] then
        for index, memberData in ipairs(rankGroupMember[i]) do
          table.insert(showList, memberData)
        end
      end
    end
  else
    for i = rankMax, 1, -1 do
      if rankGroupMember[i] and 0 < #rankGroupMember[i] then
        local listData = ObjectPool:GetInstance():Load(AllianceMemberShowInfo)
        local data = {}
        if fromSearch then
          rankGroupShowMember[i] = true
        end
        data.showMember = rankGroupShowMember[i]
        data.onlineInfo = groupOnlineInfo[i]
        data.rankId = i
        data.originAllNum = originAllNum[i]
        listData:ParseListItemData(data)
        table.insert(showList, listData)
        if rankGroupShowMember[i] then
          for index, memberData in ipairs(rankGroupMember[i]) do
            table.insert(showList, memberData)
          end
        end
      end
    end
  end
  return showList
end

function AllianceMemberDataManager:GetPositionByUid(uid)
  if uid ~= nil and uid ~= "" and uid ~= 0 then
    local mine = LuaEntry.Player
    if uid == mine.uid then
      return mine:GetSelfServerId(), mine:GetMainWorldPos()
    end
    local allMembers = self:GetAllMember()
    if allMembers ~= nil then
      for _, v in pairs(allMembers) do
        if v ~= nil and v.uid == uid then
          return v.curServerId or v.serverId, v.pointId
        end
      end
    end
  end
  return 0, 0
end

function AllianceMemberDataManager:NeedShowInactiveTag(rankId)
  for i, v in pairs(self.allianceMembers) do
    if rankId == nil or v.rank == rankId then
      local inactive = v:CheckIfInactiveV2Player()
      if inactive then
        return true
      end
    end
  end
  return false
end

function AllianceMemberDataManager:CheckOpenAlMainNeedReqAlRank()
  if DataCenter.AllianceBaseDataManager:IsR4orR5() then
    local now = UITimeManager:GetInstance():GetServerTime()
    if now - self.reqAlRankTime > 600000 then
      return true
    end
  end
  return false
end

function AllianceMemberDataManager:RefreshMemberHonorState(msg)
  if self.allianceMembers then
    local member = self.allianceMembers[msg.targetUid]
    if member then
      member.isHonorMember = msg.isHonorMember
      EventManager:GetInstance():Broadcast(EventId.AllianceRefreshMemberHonorState, msg.targetUid)
    end
  end
end

function AllianceMemberDataManager:GetOnlineText(isOnline, offLineTime)
  if isOnline == nil or offLineTime == nil then
    return ""
  end
  if isOnline then
    return CS.GameEntry.Localization:GetString("390188")
  end
  if offLineTime <= 0 then
    return ""
  end
  local deltaTime = UITimeManager:GetInstance():GetServerTime() - offLineTime
  if 86400000 < deltaTime then
    local day = math.floor(deltaTime / 86400000)
    return CS.GameEntry.Localization:GetString("390506", day)
  elseif 3600000 < deltaTime then
    local hour = math.floor(deltaTime / 3600000)
    return CS.GameEntry.Localization:GetString("390505", hour)
  elseif 60000 < deltaTime then
    local minute = math.floor(deltaTime / 60000)
    return CS.GameEntry.Localization:GetString("390504", minute)
  else
    return CS.GameEntry.Localization:GetString("390504", 1)
  end
end

function AllianceMemberDataManager:UpdateAllianceRankName(groupDescription)
  if groupDescription ~= nil then
    for index = 1, 5 do
      self.allianceRankName[index] = groupDescription[index] or ""
    end
  end
end

function AllianceMemberDataManager:GetAllianceRankName()
  return self.allianceRankName or {}
end

function AllianceMemberDataManager:GetAllianceRankNameByRank(rank)
  return self.allianceRankName[rank] or ""
end

function AllianceMemberDataManager:UpdateAllianceRankVisible(viewOpen)
  if viewOpen and 0 <= viewOpen then
    self.allianceRankVisible = viewOpen
  end
end

function AllianceMemberDataManager:GetAllianceRankVisible()
  if not self:CheckIsRankEditSwitch() then
    return 0
  end
  return self.allianceRankVisible
end

function AllianceMemberDataManager:CountOnlinePlayerNum()
  local online_num = 0
  for _, v in pairs(self.allianceMembers) do
    if v.online == true then
      online_num = online_num + 1
    end
  end
  return online_num
end

function AllianceMemberDataManager:CheckIsRankEditSwitch()
  return LuaEntry.DataConfig:CheckSwitch("alliance_rankEdit_switch")
end

function AllianceMemberDataManager:UpdateR4MemberList(message)
  if message.list ~= nil then
    self.myAllianceR4MemberList = {}
    for _, v in pairs(message.list) do
      local message_uid = v.uid
      if v.rank ~= nil and v.rank == 4 and message_uid ~= nil and message_uid ~= "" then
        self.myAllianceR4MemberList[message_uid] = true
      end
    end
  end
end

function AllianceMemberDataManager:IsOurR4MemberByUid(uid)
  if uid == nil or uid == "" or uid == 0 then
    return false
  end
  return self:GetR4MemberDataByUid(uid) ~= nil
end

function AllianceMemberDataManager:AddR4MemberData(message)
  local player_uid = message.playerId
  if player_uid == nil or player_uid == "" or player_uid == 0 then
    return
  end
  local r4MemberData = self:GetR4MemberDataByUid(player_uid)
  if r4MemberData == nil then
    self.myAllianceR4MemberList[player_uid] = true
  end
end

function AllianceMemberDataManager:DeleteR4MemberData(uid)
  if uid == nil or uid == "" or uid == 0 then
    return nil
  end
  if self.myAllianceR4MemberList ~= nil then
    self.myAllianceR4MemberList[uid] = nil
  end
end

function AllianceMemberDataManager:GetR4MemberDataByUid(uid)
  if uid == nil or uid == "" or uid == 0 then
    return nil
  end
  return self.myAllianceR4MemberList[uid] or nil
end

function AllianceMemberDataManager:SetNeedShowR4Recommend(needShow)
  self.needShowR4Recommend = needShow or false
end

function AllianceMemberDataManager:GetNeedShowR4Recommend()
  return self.needShowR4Recommend or false
end

function AllianceMemberDataManager:UpdateR4RecommendMemberList(message)
  self.r4RecommendMemberList = {}
  if table.IsNullOrEmpty(message.candidate) then
    UIUtil.ShowTipsId("r4Recommend_tips_listEmpty")
    return
  end
  self.r4RecommendMemberList = {}
  for _, v in ipairs(message.candidate) do
    table.insert(self.r4RecommendMemberList, v)
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAlR4RecommendPopup, {anim = true}, self.r4RecommendMemberList)
end

function AllianceMemberDataManager:GetR4RecommendTagConfig(tag_id)
  if not self.r4RecommendTagConfig[tag_id] then
    self.r4RecommendTagConfig[tag_id] = LocalController:instance():getLine(TableName.LW_R4_RECOMMEND, tag_id) or {}
  end
  return self.r4RecommendTagConfig[tag_id]
end

function AllianceMemberDataManager:CheckTagVisible(tag_id)
  local tag_show_state = self:GetR4RecommendTagConfig(tag_id).is_show
  if tag_show_state and tag_show_state == 1 then
    return true
  end
  return false
end

AllianceMemberDataManager.__init = __init
AllianceMemberDataManager.__delete = __delete
AllianceMemberDataManager.UpdateAllianceApplyList = UpdateAllianceApplyList
AllianceMemberDataManager.UpdateAllianceMemberList = UpdateAllianceMemberList
AllianceMemberDataManager.GetApplyCount = GetApplyCount
AllianceMemberDataManager.GetAllianceMemberByUid = GetAllianceMemberByUid
AllianceMemberDataManager.GetAllianceMemberMyself = GetAllianceMemberMyself
AllianceMemberDataManager.GetApplyMemberList = GetApplyMemberList
AllianceMemberDataManager.UpdateAllianceOfficial = UpdateAllianceOfficial
AllianceMemberDataManager.DeleteAllianceOfficial = DeleteAllianceOfficial
AllianceMemberDataManager.GetOfficialByUid = GetOfficialByUid
AllianceMemberDataManager.SetAllianceRank = SetAllianceRank
AllianceMemberDataManager.GetAllianceMemberListByRank = GetAllianceMemberListByRank
AllianceMemberDataManager.RemoveAllianceMemberByUid = RemoveAllianceMemberByUid
AllianceMemberDataManager.AllianceLeaderChange = AllianceLeaderChange
AllianceMemberDataManager.UpdateOneAllianceApply = UpdateOneAllianceApply
AllianceMemberDataManager.GetAllianceMemberCount = GetAllianceMemberCount
AllianceMemberDataManager.GetRandomMember = GetRandomMember
AllianceMemberDataManager.TryInitMemberList = TryInitMemberList
AllianceMemberDataManager.GetNearMember = GetNearMember
AllianceMemberDataManager.GetAllianceMemberByPointId = GetAllianceMemberByPointId
AllianceMemberDataManager.OnRecvNewApplyReq = OnRecvNewApplyReq
AllianceMemberDataManager.ClearCacheApplyList = ClearCacheApplyList
AllianceMemberDataManager.GetAllNearMember = GetAllNearMember
AllianceMemberDataManager.UpdateAlMemberRecommendNum = UpdateAlMemberRecommendNum
AllianceMemberDataManager.UpdateAlMemberRecommendList = UpdateAlMemberRecommendList
AllianceMemberDataManager.GetRecommendMemberList = GetRecommendMemberList
AllianceMemberDataManager.CheckIfHasRecommendMember = CheckIfHasRecommendMember
AllianceMemberDataManager.UpdateAlliancePosition = UpdateAlliancePosition
AllianceMemberDataManager.GetAllMember = GetAllMember
AllianceMemberDataManager.GetAllianceApplyRedCount = GetAllianceApplyRedCount
AllianceMemberDataManager.GetInactiveConfTime = GetInactiveConfTime
AllianceMemberDataManager.GetInactivePlayerCount = GetInactivePlayerCount
AllianceMemberDataManager.GetAllianceMemberRedCount = GetAllianceMemberRedCount
AllianceMemberDataManager.CheckIfNeedInactiveMemberBubble = CheckIfNeedInactiveMemberBubble
AllianceMemberDataManager.SetCheckedInactiveMember = SetCheckedInactiveMember
AllianceMemberDataManager.SetInactiveMemberBubbleT = SetInactiveMemberBubbleT
AllianceMemberDataManager.GetMemberInfoByOfficialPos = GetMemberInfoByOfficialPos
AllianceMemberDataManager.UpdateOneAlliancePos = UpdateOneAlliancePos
AllianceMemberDataManager.GetOfficialPosByUid = GetOfficialPosByUid
AllianceMemberDataManager.GetTableIndex = GetTableIndex
AllianceMemberDataManager.GetR4MaxMemberNum = GetR4MaxMemberNum
AllianceMemberDataManager.UpdateMemberPoint = UpdateMemberPoint
AllianceMemberDataManager.GetMemberPoint = GetMemberPoint
AllianceMemberDataManager.UpdateMemberUid = UpdateMemberUid
AllianceMemberDataManager.SetCurMembers = SetCurMembers
AllianceMemberDataManager.HasMemberChanged = HasMemberChanged
AllianceMemberDataManager.SetNewJoinMembersInfo = SetNewJoinMembersInfo
AllianceMemberDataManager.GetNewJoinMembersInfo = GetNewJoinMembersInfo
AllianceMemberDataManager.GetHighFiveData = GetHighFiveData
return AllianceMemberDataManager
