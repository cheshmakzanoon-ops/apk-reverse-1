local UserDesertHistoryData = BaseClass("UserDesertHistoryData")

function UserDesertHistoryData:__init()
  self.type = 3
  self.dataId = nil
  self.time = nil
  self.desId = nil
  self.pointId = nil
  self.serverId = nil
  self.eventType = nil
  self.otherUid = nil
  self.otherUserInfo = nil
end

function UserDesertHistoryData:__delete()
end

function UserDesertHistoryData:SetDat(message, id)
  self.dataId = id
  if message.time then
    self.time = message.time
  end
  if message.desId then
    self.desId = message.desId
  end
  if message.pointId then
    self.pointId = message.pointId
  end
  if message.serverId then
    self.serverId = message.serverId
  end
  if message.eventType then
    self.eventType = message.eventType
  end
  if message.otherUid then
    self.otherUid = message.otherUid
  end
  if message.otherUserInfo then
    self.otherUserInfo = message.otherUserInfo
  end
end

function UserDesertHistoryData:GetOtherUserFullName()
  if not string.IsNullOrEmpty(self.otherUid) and self.otherUserInfo then
    local server = self.otherUserInfo.serverId
    if not string.IsNullOrEmpty(self.otherUserInfo.abbr) then
      return string.format("#%d", server) .. "[" .. self.otherUserInfo.abbr .. "] " .. self.otherUserInfo.name
    end
    return string.format("#%d", server) .. self.otherUserInfo.name
  end
  return ""
end

function UserDesertHistoryData:GetOtherUserInfo()
  if not string.IsNullOrEmpty(self.otherUid) and self.otherUserInfo then
    return self.otherUserInfo
  end
  return nil
end

return UserDesertHistoryData
