local AccountAllianceLeaderListManager = BaseClass("AccountAllianceLeaderListManager")

function AccountAllianceLeaderListManager:__init()
  self.leaderNum = 0
  self.list = {}
end

function AccountAllianceLeaderListManager:__delete()
  self.leaderNum = nil
  self.list = nil
end

function AccountAllianceLeaderListManager:GetLeaderNum()
  return self.leaderNum
end

function AccountAllianceLeaderListManager:GetLeaderList()
  return self.list
end

function AccountAllianceLeaderListManager:SetAllianceLeaderInfo(message)
  if message.leaderNum then
    self.leaderNum = message.leaderNum
  end
  if message.list then
    self.list = message.list
  end
end

return AccountAllianceLeaderListManager
