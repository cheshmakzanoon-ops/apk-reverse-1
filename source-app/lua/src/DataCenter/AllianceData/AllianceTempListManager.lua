local AllianceTempListManager = BaseClass("AllianceTempListManager")

local function __init(self)
  self.tempAllianceList = {}
  self.tempAllMemberList = {}
  self.tempAllianceOfficial = {}
  self.tempAllianceInviteList = {}
  self.allianceIdListInOrder = {}
  self.r4MaxMemberNum = 0
end

local function __delete(self)
  self.tempAllianceList = nil
  self.tempAllMemberList = nil
  self.tempAllianceOfficial = nil
  self.tempAllianceInviteList = nil
  self.allianceIdListInOrder = nil
  self.r4MaxMemberNum = nil
end

local function RefreshSearchAllianceList(self, message)
  if message.list ~= nil then
    self.tempAllianceList = {}
    self.allianceIdListInOrder = {}
    table.walk(message.list, function(k, v)
      local alliance = AllianceBaseInfo.New()
      alliance:ParseData(v, false)
      if alliance.uid ~= nil and alliance.uid ~= "" then
        self.tempAllianceList[alliance.uid] = alliance
        table.insert(self.allianceIdListInOrder, alliance.uid)
      end
    end)
    table.sort(self.allianceIdListInOrder, function(idA, idB)
      local a = self.tempAllianceList[idA]
      local b = self.tempAllianceList[idB]
      if a and b then
        if a.comprehensiveScore and b.comprehensiveScore and a.comprehensiveScore ~= b.comprehensiveScore then
          return a.comprehensiveScore > b.comprehensiveScore
        end
        if a.fightPower and b.fightPower and a.fightPower ~= b.fightPower then
          return a.fightPower > b.fightPower
        end
      end
    end)
  end
end

local function RefreshAllianceData(self, message)
  local alliance = AllianceBaseInfo.New()
  alliance:ParseDataNew(message, false)
  if alliance.uid ~= nil and alliance.uid ~= "" then
    self.tempAllianceList[alliance.uid] = alliance
  end
end

local function GetSearchAllianceDataByUid(self, alUid)
  return self.tempAllianceList[alUid]
end

local function UpdateAllianceOfficial(self, message)
  if message.allianceOfficialArr ~= nil then
    local official = message.allianceOfficialArr
    if official[1] ~= nil then
      self.tempAllianceOfficial[official[1].type] = official[1].uid
    end
    if official[2] ~= nil then
      self.tempAllianceOfficial[official[2].type] = official[2].uid
    end
    if official[3] ~= nil then
      self.tempAllianceOfficial[official[3].type] = official[3].uid
    end
    if official[4] ~= nil then
      self.tempAllianceOfficial[official[4].type] = official[4].uid
    end
  end
end

local function GetOfficialByUid(self, uid)
  local officialPos = ""
  table.walk(self.tempAllianceOfficial, function(k, v)
    if v == uid then
      officialPos = k
    end
  end)
  return officialPos
end

local function GetSearchAllianceIdList(self)
  return self.allianceIdListInOrder
end

function AllianceTempListManager:GetFastJoinAllianceId()
  local allianceInfo
  for _, v in ipairs(self.allianceIdListInOrder) do
    allianceInfo = self:GetSearchAllianceDataByUid(v)
    local isEnoughCondition = true
    if allianceInfo.applyLevelLimit > 0 or 0 < allianceInfo.applyPowerLimit then
      local playerPower = LuaEntry.Player.power
      if playerPower < allianceInfo.applyPowerLimit then
        isEnoughCondition = false
      end
      local baseLevel = DataCenter.BuildManager.MainLv
      if baseLevel < allianceInfo.applyLevelLimit then
        isEnoughCondition = false
      end
    end
    if allianceInfo.recruitTotal == 0 and allianceInfo.curMember < allianceInfo.maxMember and isEnoughCondition then
      return v
    end
  end
end

local function ApplyAllianceByUid(self, alUid)
  if self.tempAllianceList[alUid] ~= nil then
    self.tempAllianceList[alUid]:SetApplyState(1)
  end
end

local function CancelApplyAllianceByUid(self, alUid)
  if self.tempAllianceList[alUid] ~= nil then
    self.tempAllianceList[alUid]:SetApplyState(0)
  end
end

local function UpdateAllianceMemberList(self, message)
  if message.list ~= nil then
    self.tempAllMemberList = {}
    table.walk(message.list, function(k, v)
      local member = AllianceMemberInfo.New()
      member:ParseData(v)
      if member.uid ~= nil and member.uid ~= "" then
        self.tempAllMemberList[member.uid] = member
      end
    end)
  end
  if message.r4MaxNum then
    self.r4MaxMemberNum = message.r4MaxNum
  end
end

local function GetR4MaxMemberNum(self)
  return self.r4MaxMemberNum
end

local function GetAllianceMemberByUid(self, uid)
  return self.tempAllMemberList[uid]
end

local function GetAllianceMemberListByRank(self, rank)
  local list = {}
  table.walk(self.tempAllMemberList, function(k, v)
    if v.rank == rank then
      table.insert(list, v)
    end
  end)
  return list
end

local function GetMemberInfoByOfficialPos(self, pos)
  if not self.tempAllianceOfficial then
    return nil
  end
  local u = self.tempAllianceOfficial[pos]
  if u then
    return self:GetAllianceMemberByUid(u)
  end
end

local function RefreshAllianceInviteList(self, message)
  if message.list ~= nil then
    self.tempAllianceInviteList = {}
    table.walk(message.list, function(k, v)
      local member = AllianceInviteMemberData.New()
      member:ParseData(v)
      if member.uid ~= nil then
        self.tempAllianceInviteList[member.uid] = member
      end
    end)
  end
end

local function GetAllianceInviteListByUid(self, playerUid)
  return self.tempAllianceInviteList[playerUid]
end

local function SetInvitedStateForAllianceInviteListByUid(self, playerUid)
  if self.tempAllianceInviteList[playerUid] ~= nil then
    self.tempAllianceInviteList[playerUid].invite = true
  end
end

local function GetAllianceInviteIdList(self, sortType)
  if sortType ~= nil then
    if sortType == 1 then
      table.sort(self.tempAllianceInviteList, function(a, b)
        return a.power < b.power
      end)
    elseif sortType == 2 then
      table.sort(self.tempAllianceInviteList, function(a, b)
        return a.level < b.level
      end)
    end
  end
  return table.keys(self.tempAllianceInviteList)
end

AllianceTempListManager.__init = __init
AllianceTempListManager.__delete = __delete
AllianceTempListManager.RefreshSearchAllianceList = RefreshSearchAllianceList
AllianceTempListManager.GetSearchAllianceDataByUid = GetSearchAllianceDataByUid
AllianceTempListManager.GetSearchAllianceIdList = GetSearchAllianceIdList
AllianceTempListManager.ApplyAllianceByUid = ApplyAllianceByUid
AllianceTempListManager.CancelApplyAllianceByUid = CancelApplyAllianceByUid
AllianceTempListManager.UpdateAllianceOfficial = UpdateAllianceOfficial
AllianceTempListManager.GetOfficialByUid = GetOfficialByUid
AllianceTempListManager.UpdateAllianceMemberList = UpdateAllianceMemberList
AllianceTempListManager.GetAllianceMemberByUid = GetAllianceMemberByUid
AllianceTempListManager.GetMemberInfoByOfficialPos = GetMemberInfoByOfficialPos
AllianceTempListManager.GetAllianceMemberListByRank = GetAllianceMemberListByRank
AllianceTempListManager.RefreshAllianceInviteList = RefreshAllianceInviteList
AllianceTempListManager.GetAllianceInviteListByUid = GetAllianceInviteListByUid
AllianceTempListManager.GetAllianceInviteIdList = GetAllianceInviteIdList
AllianceTempListManager.SetInvitedStateForAllianceInviteListByUid = SetInvitedStateForAllianceInviteListByUid
AllianceTempListManager.RefreshAllianceData = RefreshAllianceData
AllianceTempListManager.GetR4MaxMemberNum = GetR4MaxMemberNum
return AllianceTempListManager
