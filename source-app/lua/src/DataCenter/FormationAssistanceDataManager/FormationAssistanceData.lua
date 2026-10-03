local FormationAssistanceData = BaseClass("FormationAssistanceData")

local function __init(self)
  self.uid = 0
  self.uuid = 0
  self.type = 0
  self.targetUuid = 0
  self.memberList = {}
  self.holdMemberList = {}
  self.showList = {}
  self.maxAssistance = 0
  self.warFeverTime = 0
end

local function __delete(self)
  self.uid = nil
  self.uuid = nil
  self.type = nil
  self.targetUuid = nil
  self.memberList = nil
  self.holdMemberList = nil
  self.showList = nil
  self.maxAssistance = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.uid ~= nil then
    self.uid = message.uid
  end
  if message.uuid ~= nil then
    self.uuid = message.uuid
  end
  if message.type ~= nil then
    self.type = message.type
  end
  if message.targetUuid ~= nil then
    self.targetUuid = message.targetUuid
  end
  if message.serverId ~= nil then
    self.serverId = message.serverId
  end
  if message.maxAssistance ~= nil then
    self.maxAssistance = message.maxAssistance
  end
  if message.warFeverTime ~= nil then
    self.warFeverTime = message.warFeverTime
  end
  if message.members ~= nil then
    self.memberList = {}
    self.showList = {}
    local list = message.members
    table.walk(list, function(k, v)
      local data = AllianceWarMemberData.New()
      data:ParseData(v)
      if data.uuid ~= nil and data.uuid ~= "" then
        self.memberList[data.uuid] = data
        table.insert(self.showList, 1, data)
      end
    end)
  end
  if message.holdMembers ~= nil then
    self.holdMemberList = {}
    self.showList = self.showList or {}
    local list = message.holdMembers
    table.walk(list, function(k, v)
      local data = AllianceWarMemberData.New()
      data:ParseData(v)
      if data.uuid ~= nil and data.uuid ~= "" then
        self.holdMemberList[data.uuid] = data
        table.insert(self.showList, 1, data)
      end
    end)
  end
end

function FormationAssistanceData:GetMemberCount(theMarchStatus)
  if self.memberList == nil then
    return 0
  end
  if theMarchStatus == nil then
    return table.count(self.memberList)
  end
  local count = 0
  for k, v in pairs(self.memberList) do
    if v and v.status == theMarchStatus then
      count = count + 1
    end
  end
  return count
end

function FormationAssistanceData:GetHoldMemberCount(theMarchStatus)
  if self.holdMemberList == nil then
    return 0
  end
  if theMarchStatus == nil then
    return table.count(self.holdMemberList)
  end
  local count = 0
  for k, v in pairs(self.holdMemberList) do
    if v and v.status == theMarchStatus then
      count = count + 1
    end
  end
  return count
end

local function IsWarFever(self)
  local now = UITimeManager:GetInstance():GetServerTime()
  return now < self.warFeverTime
end

FormationAssistanceData.__init = __init
FormationAssistanceData.__delete = __delete
FormationAssistanceData.ParseData = ParseData
FormationAssistanceData.IsWarFever = IsWarFever
return FormationAssistanceData
