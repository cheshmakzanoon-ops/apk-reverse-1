local ActEasterEggMainData = BaseClass("ActEasterEggMainData")
local ActEasterEggFromLastReceiveData = require("DataCenter.ActEasterEggManager.ActEasterEggFromLastReceiveData")
local ActEasterEggAmazingEggData = require("DataCenter.ActEasterEggManager.ActEasterEggAmazingEggData")

function ActEasterEggMainData:__init()
  self:AddListener()
  self.activityId = 0
  self.fromLastReceive = nil
  self.unpackedAmazingEggArr = {}
  self.anonymousHeadId = 0
  self.anonymousName = ""
  self.anonymousState = true
  self.taskArr = {}
  self.pickUpNumLimit = 0
  self.pickUpNum = 0
  self.throwNumLimit = 0
  self.throwNum = 0
end

function ActEasterEggMainData:__delete()
  self:RemoveListener()
  self.activityId = nil
  self.fromLastReceive = nil
  self.unpackedAmazingEggArr = nil
  self.anonymousHeadId = nil
  self.anonymousName = nil
  self.anonymousState = nil
  self.taskArr = nil
  self.pickUpNumLimit = nil
  self.pickUpNum = nil
  self.throwNumLimit = nil
  self.throwNum = nil
end

function ActEasterEggMainData:AddListener()
end

function ActEasterEggMainData:RemoveListener()
end

function ActEasterEggMainData:UpdateServerData(message)
  self.activityId = message.activityId
  self.fromLastReceive = ActEasterEggFromLastReceiveData.New()
  self.fromLastReceive:UpdateServerData(message.fromLastReceive)
  self.unpackedAmazingEggArr = {}
  local unpackedAmazingEggArr = message.amazingEggArr
  if unpackedAmazingEggArr then
    for k, v in pairs(unpackedAmazingEggArr) do
      local amazingEgg = ActEasterEggAmazingEggData.New()
      amazingEgg:ParseEggInfo(v)
      table.insert(self.unpackedAmazingEggArr, amazingEgg)
    end
  end
  local anonymousArr = string.split(message.anonymousAndHead, ";")
  self.anonymousName = anonymousArr[1]
  self.anonymousHeadId = tonumber(anonymousArr[2])
  self.anonymousState = tonumber(anonymousArr[3]) == 0
  self.taskArr = message.taskArr
  self.pickUpNumLimit = message.pickUpNumLimit or 0
  self.pickUpNum = message.pickUpNum or 0
  self.throwNumLimit = message.throwNumLimit or 0
  self.throwNum = message.throwNum or 0
end

function ActEasterEggMainData:GetFirstUnpackedAmazingEgg()
  if self.unpackedAmazingEggArr and #self.unpackedAmazingEggArr >= 1 and self.unpackedAmazingEggArr[1] and self.unpackedAmazingEggArr[1].receive == 0 then
    return self.unpackedAmazingEggArr[1]
  end
end

function ActEasterEggMainData:DeleteUnpackAmazingEgg(uuid)
  if not self.unpackedAmazingEggArr then
    return
  end
  local result
  for k, v in pairs(self.unpackedAmazingEggArr) do
    if v and v.uuid == uuid then
      result = k
      break
    end
  end
  if result then
    table.remove(self.unpackedAmazingEggArr, result)
  end
end

function ActEasterEggMainData:UpdateAnonymousInfo(anonymousAndHead, anonymous, type)
  if string.IsNullOrEmpty(anonymousAndHead) or anonymous == nil then
    Logger.LogError("info is nil")
    return
  end
  local anonymousArr = string.split(anonymousAndHead, ";")
  if type == ActEasterAnonymousRequestType.RequestRandomName then
    self.anonymousName = anonymousArr[1]
    EventManager:GetInstance():Broadcast(EventId.EasterEggGetActivityUpdateAnonymousName)
  elseif type == ActEasterAnonymousRequestType.RequestSetAnonymousAvatar then
    self.anonymousHeadId = tonumber(anonymousArr[2])
    EventManager:GetInstance():Broadcast(EventId.EasterEggGetActivityUpdateAnonymousHead)
    UIUtil.ShowTipsId("activity_99144_5")
  elseif type == ActEasterAnonymousRequestType.RequestSetAnonymousState then
    self.anonymousState = anonymous == 0
    EventManager:GetInstance():Broadcast(EventId.EasterEggGetActivityUpdateAnonymousState)
  end
end

function ActEasterEggMainData:UpdateTodayPickUpNum(pickUpNumLimit, pickUpNum)
  if pickUpNumLimit then
    self.pickUpNumLimit = pickUpNumLimit
  end
  if pickUpNum then
    self.pickUpNum = pickUpNum
  end
end

function ActEasterEggMainData:UpdateThrowNum(throwNumLimit, throwNum)
  if throwNum then
    self.throwNum = throwNum
  end
  if throwNumLimit then
    self.throwNumLimit = throwNumLimit
  end
end

function ActEasterEggMainData:ReachThrowLimit()
  if self.throwNum and self.throwNumLimit then
    return self.throwNum >= self.throwNumLimit
  end
  return false
end

function ActEasterEggMainData:ReachPickUpLimit()
  if self.pickUpNum and self.pickUpNumLimit then
    return self.pickUpNum >= self.pickUpNumLimit
  end
  return false
end

function ActEasterEggMainData:GetAnonymousState()
  return self.anonymousState
end

function ActEasterEggMainData:SetAnonymousState(state)
  if state == nil then
    Logger.LogError("state is nil")
    return
  end
  local anonymousState = 1
  if state then
    anonymousState = 0
  end
  local activityData = DataCenter.ActEasterEggManager:GetActivityData()
  if not activityData then
    Logger.LogError("activityData ia nil")
    return
  end
  local activityId = activityData.activityId
  local configData = DataCenter.ActEasterEggManager:GetEggConfigData()
  local index = 0
  local headList = configData and configData.heroHeadList
  for k, v in pairs(headList) do
    if v and v == self.anonymousHeadId then
      index = k
      break
    end
  end
  if index == 0 then
    Logger.LogError("headId is not in configData")
    return
  end
  SFSNetwork.SendMessage(MsgDefines.EasterChangeAnonymous, activityId, anonymousState, index - 1, 3)
end

function ActEasterEggMainData:GetCurAnonymousInfo()
  local isAnonymous = DataCenter.ActEasterEggManager:GetIsAnonymousState()
  local sendStr = isAnonymous and "0" or "1"
  return self.anonymousName .. ";" .. tostring(self.anonymousHeadId) .. ";" .. sendStr
end

return ActEasterEggMainData
