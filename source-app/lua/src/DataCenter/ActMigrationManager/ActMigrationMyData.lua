local ActMigrationMyData = BaseClass("ActMigrationMyData")
local ActMigrationPlayerData = require("DataCenter.ActMigrationManager.ActMigrationPlayerData")
local ALL_SERVER_ID = 0

local function ClearTable(t)
  if t == nil then
    return
  end
  for k in pairs(t) do
    t[k] = nil
  end
end

function ActMigrationMyData:__init()
  self.serverId = 0
  self.applyState = 0
  self.applyMessage = ""
  self.score = 0
  self.identity = ActMigrationIdentity.Low
  self.approverInfo = nil
  self.approveTime = 0
  self.migrated = 0
  self.shareCdTime = 0
  self.mailUuid = ""
  self.applyRedNum = 0
  self.markedUids = {}
  self.markedServerList = {}
  self.markedCount = 0
end

function ActMigrationMyData:ResetMarkedData()
  if self.markedUids == nil then
    self.markedUids = {}
  else
    ClearTable(self.markedUids)
  end
  if self.markedServerList == nil then
    self.markedServerList = {}
  else
    for serverId, uidList in pairs(self.markedServerList) do
      if type(uidList) == "table" then
        ClearTable(uidList)
      end
      self.markedServerList[serverId] = nil
    end
  end
  self.markedCount = 0
end

function ActMigrationMyData:__delete()
  self.serverId = 0
  self.applyState = 0
  self.applyMessage = ""
  self.score = 0
  self.identity = ActMigrationIdentity.Low
  self.approverInfo = nil
  self.approveTime = 0
  self.migrated = 0
  self.shareCdTime = 0
  self.mailUuid = ""
  self.applyRedNum = 0
  self.markedUids = nil
  self.markedServerList = nil
  self.markedCount = 0
end

function ActMigrationMyData:ParseData(t)
  if t == nil then
    return
  end
  if t.serverId then
    self.serverId = t.serverId
  end
  if t.applyState then
    self.applyState = t.applyState
  end
  local approverInfo = t.approverInfo
  if approverInfo then
    if self.approverInfo == nil then
      self.approverInfo = ActMigrationPlayerData.New()
    end
    self.approverInfo:ParseData(approverInfo)
  end
  if t.applyMessage then
    self.applyMessage = t.applyMessage
  end
  if t.score then
    self.score = t.score
  end
  if t.identity then
    self.identity = t.identity
  end
  if t.approveTime then
    self.approveTime = t.approveTime
  end
  if t.migrated then
    self.migrated = t.migrated
  end
  if t.shareCdTime then
    self.shareCdTime = t.shareCdTime
  end
  if t.mailUuid then
    self.mailUuid = t.mailUuid
  end
  if t.applyRedNum then
    self.applyRedNum = t.applyRedNum
  end
  local markedUids = t.markedUids
  if markedUids then
    self:ResetMarkedData()
    for uuid, sId in pairs(markedUids) do
      self:SetMarkedUid(uuid, sId, true)
    end
  end
end

function ActMigrationMyData:SetMarkedUid(uid, serverId, isMarked)
  if self.markedUids == nil then
    return
  end
  local sId = tonumber(serverId)
  if sId == nil then
    return
  end
  local isExist = self.markedUids[uid] ~= nil
  self.markedUids[uid] = isMarked and sId or nil
  if isMarked and not isExist then
    self.markedCount = self.markedCount + 1
  elseif not isMarked and isExist then
    self.markedCount = self.markedCount - 1
  end
  if isMarked then
    if self.markedServerList[ALL_SERVER_ID] == nil then
      self.markedServerList[ALL_SERVER_ID] = {}
    end
    table.insert(self.markedServerList[ALL_SERVER_ID], uid)
    if self.markedServerList[sId] == nil then
      self.markedServerList[sId] = {}
    end
    table.insert(self.markedServerList[sId], uid)
  else
    if self.markedServerList[ALL_SERVER_ID] ~= nil then
      table.removebyvalue(self.markedServerList[ALL_SERVER_ID], uid)
    end
    if self.markedServerList[sId] ~= nil then
      table.removebyvalue(self.markedServerList[sId], uid)
    end
  end
end

function ActMigrationMyData:GetMarkServerId(uid)
  if self.markedUids == nil then
    return false
  end
  return self.markedUids[uid]
end

function ActMigrationMyData:GetAllMarkUids()
  if self.markedServerList == nil then
    self.markedServerList = {}
  end
  return self.markedServerList
end

return ActMigrationMyData
