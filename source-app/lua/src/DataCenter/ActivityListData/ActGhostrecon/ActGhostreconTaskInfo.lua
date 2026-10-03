local ActGhostreconTaskInfo = BaseClass("ActGhostreconTaskInfo")
local ActGhostreconStealInfo = require("DataCenter.ActivityListData.ActGhostrecon.ActGhostreconStealInfo")
local ActGhostreconMemberInfo = require("DataCenter.ActivityListData.ActGhostrecon.ActGhostreconMemberInfo")

local function __init(self)
  self:AddListener()
  self.uuid = 0
  self.ownerId = ""
  self.cfgId = 0
  self.ownerServer = 0
  self.targetServer = 0
  self.completionTime = 0
  self.pointId = 0
  self.state = 0
  self.allianceId = ""
  self.teamStartTime = 0
  self.sendChatTime = 0
  self.remindTime = 0
  self.taskExpireTime = 0
  self.actEndTime = 0
  self.stealList = nil
  self.memberList = nil
  self.noLeaderMemberList = nil
  self.bubbleType = nil
  self.leaderMemberInfo = nil
  self.useHeroUUidList = {}
end

local function __delete(self)
  self.uuid = nil
  self.ownerId = nil
  self.cfgId = nil
  self.ownerServer = nil
  self.targetServer = nil
  self.completionTime = nil
  self.pointId = nil
  self.state = nil
  self.allianceId = nil
  self.teamStartTime = nil
  self.sendChatTime = nil
  self.remindTime = nil
  self.taskExpireTime = nil
  self.actEndTime = nil
  self.stealList = nil
  self.memberList = nil
  self.noLeaderMemberList = nil
  self.bubbleType = nil
  self.leaderMemberInfo = nil
  self.useHeroUUidList = nil
  self:RemoveListener()
end

local function AddListener(self)
end

local function RemoveListener(self)
end

local function ParseData(self, msg, formGetAll)
  if msg == nil then
    return
  end
  self.uuid = msg.uuid
  self.ownerId = msg.ownerId
  self.cfgId = msg.cfgId
  self.ownerServer = msg.ownerServer
  self.targetServer = msg.targetServer
  self.completionTime = msg.completionTime
  self.pointId = msg.pointId
  self.state = msg.state
  self.allianceId = msg.allianceId
  self.teamStartTime = msg.teamStartTime
  if msg.sendChatTime then
    self.sendChatTime = msg.sendChatTime
  end
  if msg.remindTime then
    self.remindTime = msg.remindTime
  end
  self.taskExpireTime = msg.taskExpireTime
  self.actEndTime = msg.actEndTime
  if msg.stealList then
    self.stealList = {}
    for index, value in ipairs(msg.stealList) do
      local stealInfo = ActGhostreconStealInfo.New()
      stealInfo:ParseData(value)
      table.insert(self.stealList, stealInfo)
    end
  else
    self.stealList = nil
  end
  if msg.memberList then
    self.memberList = {}
    self.noLeaderMemberList = {}
    for index, value in ipairs(msg.memberList) do
      local memberInfo = ActGhostreconMemberInfo.New()
      memberInfo:ParseData(value)
      table.insert(self.memberList, memberInfo)
      if memberInfo.uid == self.ownerId then
        self.leaderMemberInfo = memberInfo
      else
        table.insert(self.noLeaderMemberList, memberInfo)
      end
    end
  else
    self.memberList = nil
    self.noLeaderMemberList = nil
  end
  self:RefreshBubbleType(formGetAll)
end

local function RefreshBubbleType(self, formGetAll)
  local taskType = GhostreconTaskType.Own_Runing
  local now = UITimeManager:GetInstance():GetServerTime()
  local isOwn = self.ownerId == LuaEntry.Player.uid
  local isAlliance = LuaEntry.Player.allianceId and self.allianceId == LuaEntry.Player.allianceId
  if isOwn then
    if self.teamStartTime == nil or self.teamStartTime == 0 then
      taskType = GhostreconTaskType.Own_NotExecuted
    elseif self.completionTime == nil or self.completionTime == 0 then
      taskType = GhostreconTaskType.Own_TeamingUp
    elseif now <= self.completionTime then
      taskType = GhostreconTaskType.Own_Runing
    elseif self:OwnIsRewarded() then
      taskType = GhostreconTaskType.Own_Claimed
    else
      taskType = GhostreconTaskType.Own_WaitClaim
    end
  elseif isAlliance or self:OwnIsJoined() then
    if self.completionTime == nil or self.completionTime == 0 then
      taskType = GhostreconTaskType.Alliance_TeamingUp
    elseif now <= self.completionTime then
      taskType = GhostreconTaskType.Alliance_Runing
    elseif self:OwnIsRewarded() then
      taskType = GhostreconTaskType.Alliance_Claimed
    else
      taskType = GhostreconTaskType.Alliance_WaitClaim
    end
  end
  if self.bubbleType ~= taskType and not formGetAll then
    EventManager:GetInstance():Broadcast(EventId.GhostreconRefreshRedPoint)
  end
  self.bubbleType = taskType
end

local function GetLeaderMemberInfo(self)
  return self.leaderMemberInfo
end

local function GetOwnMemberInfo(self)
  local memberInfo
  for index, value in ipairs(self.memberList) do
    if value.uid == LuaEntry.Player.uid then
      memberInfo = value
      break
    end
  end
  return memberInfo
end

local function OwnIsLeader(self)
  local isLeader = false
  if self.ownerId == LuaEntry.Player.uid then
    isLeader = true
  end
  return isLeader
end

local function OwnIsJoined(self)
  local joined = false
  for index, value in ipairs(self.memberList) do
    if value.uid == LuaEntry.Player.uid then
      joined = true
      break
    end
  end
  return joined
end

local function OwnIsRewarded(self)
  local rewarded = true
  for index, value in ipairs(self.memberList) do
    if value.uid == LuaEntry.Player.uid then
      rewarded = value.rewarded == 1
      break
    end
  end
  return rewarded
end

local function MemberIsFull(self)
  local isFull = false
  if self.memberList then
    isFull = #self.memberList >= DataCenter.ActGhostreconManager:GetTeamMaxMemberNum()
  end
  return isFull
end

ActGhostreconTaskInfo.__init = __init
ActGhostreconTaskInfo.__delete = __delete
ActGhostreconTaskInfo.AddListener = AddListener
ActGhostreconTaskInfo.RemoveListener = RemoveListener
ActGhostreconTaskInfo.ParseData = ParseData
ActGhostreconTaskInfo.RefreshBubbleType = RefreshBubbleType
ActGhostreconTaskInfo.GetLeaderMemberInfo = GetLeaderMemberInfo
ActGhostreconTaskInfo.GetOwnMemberInfo = GetOwnMemberInfo
ActGhostreconTaskInfo.OwnIsLeader = OwnIsLeader
ActGhostreconTaskInfo.OwnIsJoined = OwnIsJoined
ActGhostreconTaskInfo.OwnIsRewarded = OwnIsRewarded
ActGhostreconTaskInfo.MemberIsFull = MemberIsFull
return ActGhostreconTaskInfo
