local LWBiuBiuResult = BaseClass("LWBiuBiuResult")

function LWBiuBiuResult:__init()
  self.data = {}
  self.boot = nil
  self.type = nil
end

function LWBiuBiuResult:__delete()
  self.data = nil
  self.boot = nil
  self.type = nil
end

function LWBiuBiuResult:BindGameLiftResult(gameLiftResult)
  self.data.gameLiftResult = gameLiftResult
  self:ResultUIEvent()
end

function LWBiuBiuResult:BindServerResult(serverResult)
  self.data.serverResult = serverResult
  self:ResultUIEvent()
end

function LWBiuBiuResult:BindBoot(boot, type)
  self.boot = boot
  self.type = type
end

function LWBiuBiuResult:ResultUIEvent()
  if self.data.serverResult ~= nil and self:GetResult() == 4 then
    EventManager:GetInstance():Broadcast(EventId.SeasonBiuBiuPvpValidationEnd)
    return
  end
  if self.data.serverResult ~= nil and self.data.gameLiftResult ~= nil then
    EventManager:GetInstance():Broadcast(EventId.SeasonBiuBiuPvpValidationEnd)
  end
end

function LWBiuBiuResult:GetUserInfos()
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

function LWBiuBiuResult:GetWinLoseUsers()
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

function LWBiuBiuResult:GetFireCount()
  local gameLiftResult = self.data.gameLiftResult
  local selfFireCount = gameLiftResult.fireCount[gameLiftResult.SelfPlayerID]
  local otherPlayerID = gameLiftResult.SelfPlayerID == 1 and 2 or 1
  local otherFireCount = gameLiftResult.fireCount[otherPlayerID]
  return selfFireCount, otherFireCount
end

function LWBiuBiuResult:GetBattleTime()
  local gameLiftResult = self.data.gameLiftResult
  return toInt(gameLiftResult.battleTimeMills / 1000)
end

function LWBiuBiuResult:GetHeadShot()
  local gameLiftResult = self.data.gameLiftResult
  return gameLiftResult.HeadShot or false
end

function LWBiuBiuResult:GetResult()
  return self.data.serverResult.result
end

function LWBiuBiuResult:GetServerResult()
  return self.data.serverResult
end

function LWBiuBiuResult:GetType()
  return self.type
end

function LWBiuBiuResult:GetBoot()
  return self.boot
end

function LWBiuBiuResult:Clear()
  self.data = {}
  self.boot = nil
  self.type = nil
end

return LWBiuBiuResult
