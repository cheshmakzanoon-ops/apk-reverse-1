local LWGGGoResult = BaseClass("LWGGGoResult")

function LWGGGoResult:__init()
  self.data = {}
  self.boot = nil
  self.type = nil
end

function LWGGGoResult:__delete()
  self.data = nil
  self.boot = nil
  self.type = nil
end

function LWGGGoResult:BindGameLiftResult(gameLiftResult)
  self.data.gameLiftResult = gameLiftResult
  self:ResultUIEvent()
end

function LWGGGoResult:BindServerResult(serverResult)
  self.data.serverResult = serverResult
  self:ResultUIEvent()
end

function LWGGGoResult:BindBoot(boot, type)
  self.boot = boot
  self.type = type
end

function LWGGGoResult:ResultUIEvent()
  if self.data.serverResult ~= nil and self:GetResult() == 4 then
    EventManager:GetInstance():Broadcast(EventId.SeasonGGGoPvpValidationEnd)
    return
  end
  if self.data.serverResult ~= nil and self.data.gameLiftResult ~= nil then
    EventManager:GetInstance():Broadcast(EventId.SeasonGGGoPvpValidationEnd)
  end
end

function LWGGGoResult:GetUserInfos()
  local serverResult = self.data.serverResult
  local aUser, bUser = serverResult.aUser, serverResult.bUser
  local otherHead = aUser.uid == serverResult.shareUid and bUser or aUser
  local selfHead = aUser.uid == serverResult.shareUid and aUser or bUser
  local result = self:GetResult()
  local showHead
  if result == 1 then
    showHead = selfHead
  elseif result == 2 then
    showHead = otherHead
  end
  return selfHead, otherHead, showHead
end

function LWGGGoResult:GetWinLoseUsers()
  local serverResult = self.data.serverResult
  local aUser, bUser = serverResult.aUser, serverResult.bUser
  local otherHead = aUser.uid == serverResult.shareUid and bUser or aUser
  local selfHead = aUser.uid == serverResult.shareUid and aUser or bUser
  local result = self:GetResult()
  if result == 1 then
    return selfHead, otherHead
  elseif result == 2 then
    return otherHead, selfHead
  end
  return selfHead, otherHead
end

function LWGGGoResult:GetBattleTime()
  local gameLiftResult = self.data.gameLiftResult
  return gameLiftResult.battleTimeMills / 1000
end

function LWGGGoResult:GetResult()
  return self.data.serverResult.result
end

function LWGGGoResult:GetServerResult()
  return self.data.serverResult
end

function LWGGGoResult:GetType()
  return self.type
end

function LWGGGoResult:GetBoot()
  return self.boot
end

function LWGGGoResult:Clear()
  self.data = {}
  self.boot = nil
  self.type = nil
end

return LWGGGoResult
