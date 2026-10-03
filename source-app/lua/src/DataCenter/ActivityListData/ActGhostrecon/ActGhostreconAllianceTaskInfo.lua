local ActGhostreconAllianceTaskInfo = BaseClass("ActGhostreconAllianceTaskInfo")
local ActGhostreconMemberInfo = require("DataCenter.ActivityListData.ActGhostrecon.ActGhostreconMemberInfo")

local function __init(self)
  self:AddListener()
  self.uuid = ""
  self.cfgId = ""
  self.targetServer = 0
  self.pointId = 0
  self.teamStartTime = 0
  self.ownerId = 0
  self.memberList = nil
  self.noLeaderMemberList = nil
  self.leaderMemberInfo = nil
end

local function __delete(self)
  self.uuid = nil
  self.cfgId = nil
  self.targetServer = nil
  self.pointId = nil
  self.teamStartTime = nil
  self.memberList = nil
  self.noLeaderMemberList = nil
  self:RemoveListener()
end

local function AddListener(self)
end

local function RemoveListener(self)
end

local function ParseData(self, msg)
  if msg == nil then
    return
  end
  self.uuid = msg.uuid
  self.cfgId = msg.cfgId
  self.targetServer = msg.targetServer
  self.pointId = msg.pointId
  self.teamStartTime = msg.teamStartTime
  self.ownerId = msg.ownerId
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
end

local function OwnIsLeader(self)
  local isLeader = false
  if self.leaderMemberInfo and self.leaderMemberInfo.uid == LuaEntry.Player.uid then
    isLeader = true
  end
  return isLeader
end

local function OwnIsJoined(self)
  local joined = false
  if self.memberList then
    for index, value in ipairs(self.memberList) do
      if value.uid == LuaEntry.Player.uid then
        joined = true
        break
      end
    end
  end
  return joined
end

ActGhostreconAllianceTaskInfo.__init = __init
ActGhostreconAllianceTaskInfo.__delete = __delete
ActGhostreconAllianceTaskInfo.AddListener = AddListener
ActGhostreconAllianceTaskInfo.RemoveListener = RemoveListener
ActGhostreconAllianceTaskInfo.ParseData = ParseData
ActGhostreconAllianceTaskInfo.OwnIsLeader = OwnIsLeader
ActGhostreconAllianceTaskInfo.OwnIsJoined = OwnIsJoined
return ActGhostreconAllianceTaskInfo
