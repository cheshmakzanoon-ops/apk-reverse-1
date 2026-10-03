local ValentineDataManager = BaseClass("ValentineDataManager")
local SendGiftListData = require("DataCenter/ValentineDataManager/ValentineSendGiftListData")
local ReceiveGiftListData = require("DataCenter/ValentineDataManager/ValentineReceiveGiftListData")
local ActValentineSendTemplate = require("DataCenter/ValentineDataManager/ActValentineSendTemplate")
local ValentineRankData = require("DataCenter/ValentineDataManager/ValentineRankData")
local ValentineNpcData = require("DataCenter.ValentineDataManager.ValentineNpcData")
local actSendGiftRankDataExpiredTime = 10000
local actReceiveGiftExpiredTime = 10000
local SendFastGiftItemIndexKey = "SendFastGiftItemIndex"
local ActSendGiftAutoSendSaveKey = "ActSendGiftAutoSendSave"
local ActNoChocolateMessage = "ActNoChocolateMessage"
local ActValentineMatchTipsShow = "ActValentineMatchTipsShow"

local function __init(self)
  self:AddListener()
  self.allActSendGiftDataList = {}
  self.npcGiftDataDic = {}
  self.actSendGiftActIdToTempIdDict = {}
  self.actSendGiftTempDict = {}
  self.actSendGiftRankData = {}
  self.actSendGiftRankRewardData = {}
  self.actReceiveGiftDataDic = {}
  self.SendGiftRecordData = {}
  self.ReceiveGiftRecordData = {}
  self.actRankData = {}
  self.sendFastGiftItemIndexDict = {}
  self.autoSendSaveDict = {}
  self.noGiftMessageDict = {}
  self.showMatchTips = {}
  self.matchSuccessDataDict = {}
  self.matchSuccessRedPointDict = {}
  self.matchRequestingRedPointDict = {}
  self.newMutualFollow = {}
  self.matchList = {}
  self.curIndex = {}
  self.functionOnMatch = nil
end

local function __delete(self)
  self:RemoveListener()
  self.allActSendGiftDataList = nil
  self.actSendGiftActIdToTempIdDict = nil
  self.actSendGiftTempDict = nil
  self.actSendGiftRankData = nil
  self.actSendGiftRankRewardData = nil
  self.SendGiftRecordData = nil
  self.ReceiveGiftRecordData = nil
  self.actReceiveGiftDataDic = nil
  self.actRankData = nil
  self.sendFastGiftItemIndexDict = nil
  self.autoSendSaveDict = nil
  self.noGiftMessageDict = nil
  self.showMatchTips = nil
  self.newMutualFollow = nil
  self.matchList = nil
  self.matchSuccessDataDict = nil
  self.matchSuccessRedPointDict = nil
  self.curIndex = nil
  self.functionOnMatch = nil
  self.npcGiftDataDic = nil
  self:ClearOtherPlayerGiftHotAddCache()
  self:ClearPlayerFollowHotAdd()
end

local function AddListener(self)
end

local function RemoveListener(self)
end

function ValentineDataManager:ClearSendGiftListData()
  table.clear(self.allActSendGiftDataList)
end

function ValentineDataManager:GetSendGiftListData(activityId, scope, gender, startIndex, endIndex)
  local targetData = self:GetTargetSendGiftListData(activityId, scope, gender)
  if not targetData then
    targetData = SendGiftListData.New()
    targetData:Init(activityId, scope, gender)
    table.insert(self.allActSendGiftDataList, targetData)
  end
  local cacheData = targetData:ReqData(startIndex, endIndex)
  return cacheData
end

function ValentineDataManager:UpdateSendGiftListData(activityId, scope, gender, startIndex, endIndex, data, npcArr)
  local targetData = self:GetTargetSendGiftListData(activityId, scope, gender)
  if not targetData then
    targetData = SendGiftListData.New()
    targetData:Init(activityId, scope, gender)
    table.insert(self.allActSendGiftDataList, targetData)
  end
  targetData:UpdateData(startIndex, endIndex, data, npcArr)
end

function ValentineDataManager:GetTargetSendGiftPlayerData(activityId, scope, gender, targetIndex)
  local targetData = self:GetTargetSendGiftListData(activityId, scope, gender)
  if not targetData then
    return nil
  end
  return targetData:GetDataByIndex(targetIndex)
end

function ValentineDataManager:GetTargetSendGiftListData(activityId, scope, gender)
  local ret
  for _, v in ipairs(self.allActSendGiftDataList) do
    if v.activityId == activityId and v.scope == scope and v.gender == gender then
      ret = v
      break
    end
  end
  return ret
end

function ValentineDataManager:GetActSendTempByActId(actId)
  local temp
  local actId = toInt(actId) or 0
  if actId <= 0 then
    return temp
  end
  if self.actSendGiftActIdToTempIdDict[actId] == nil then
    local actTempData = LocalController:instance():getLine(TableName.Activity, toInt(actId))
    if actTempData then
      local subType = tonumber(actTempData.tableInfoType) or 0
      self.actSendGiftActIdToTempIdDict[actId] = subType
    else
      return temp
    end
  end
  local tempId = self.actSendGiftActIdToTempIdDict[actId]
  temp = self:GetActSendGiftTemplate(tempId)
  return temp
end

function ValentineDataManager:GetActSendGiftTemplate(templateId)
  local template
  if self.actSendGiftTempDict[templateId] == nil then
    self.actSendGiftTempDict[templateId] = ActValentineSendTemplate.New()
    local cfg = LocalController:instance():getLine(TableName.Activity_Valentine_Send, templateId)
    if cfg then
      self.actSendGiftTempDict[templateId]:InitData(cfg)
    end
  end
  template = self.actSendGiftTempDict[templateId]
  return template
end

function ValentineDataManager:SetActSendGiftRecordData(message)
  local activityId = message.activityId
  if activityId == nil then
    return
  end
  if self.SendGiftRecordData[activityId] == nil then
    self.SendGiftRecordData[activityId] = {
      recordList = {},
      recordCount = 0,
      isNeedRefresh = true,
      totalSendHistory = {}
    }
  end
  local start = message.start
  if start == ValentineRankType.SelfServer then
    self.SendGiftRecordData[activityId].recordList = message.historyArr
  elseif start == #self.SendGiftRecordData[activityId].recordList + 1 then
    for k, v in ipairs(message.historyArr) do
      table.insert(self.SendGiftRecordData[activityId].recordList, v)
    end
  end
  self.SendGiftRecordData[activityId].recordCount = message.total
  self.SendGiftRecordData[activityId].isNeedRefresh = false
  self.SendGiftRecordData[activityId].totalSendHistory = message.totalSendHistory
end

function ValentineDataManager:GetActSendGiftRecordData(activityId)
  local data = self.SendGiftRecordData[activityId]
  return data
end

function ValentineDataManager:CheckActSendGiftRecordDataNeedRefresh(activityId)
  local isNeedRefresh = true
  if self.SendGiftRecordData[activityId] then
    isNeedRefresh = self.SendGiftRecordData[activityId].isNeedRefresh
  end
  return isNeedRefresh
end

function ValentineDataManager:SetActivityIdCache(activityId)
  self.cacheActivityId = activityId
end

function ValentineDataManager:SetActSendGiftRecordDataDirty()
  for _, v in pairs(self.SendGiftRecordData) do
    v.isNeedRefresh = true
  end
end

function ValentineDataManager:CacheOtherPlayerGiftHotAdd(msg)
  if not msg.otherPlayerInfo or not msg.itemId then
    return
  end
  local template = self:GetActSendTempByActId(self.cacheActivityId)
  if not template then
    return
  end
  if not self.sendToOtherPlayerGiftHotAdd then
    self.sendToOtherPlayerGiftHotAdd = {}
  end
  local num = msg.num or 0
  local playerUid = msg.otherPlayerInfo.uid
  local giftItemId = msg.itemId
  local hotAddMap = template:GetGiftHotAdd()
  local hotAdd = hotAddMap[giftItemId] or 0
  hotAdd = hotAdd * num
  if not self.sendToOtherPlayerGiftHotAdd[playerUid] then
    self.sendToOtherPlayerGiftHotAdd[playerUid] = 0
  end
  self.sendToOtherPlayerGiftHotAdd[playerUid] = self.sendToOtherPlayerGiftHotAdd[playerUid] + hotAdd
end

function ValentineDataManager:GetOtherPlayerGiftHotAddCache(uid)
  if not self.sendToOtherPlayerGiftHotAdd then
    return 0
  end
  local hotAdd = self.sendToOtherPlayerGiftHotAdd[uid] or 0
  return hotAdd
end

function ValentineDataManager:ClearOtherPlayerGiftHotAddCache()
  self.sendToOtherPlayerGiftHotAdd = nil
end

function ValentineDataManager:CachePlayerFollowHotAdd(msg)
  local template = self:GetActSendTempByActId(self.cacheActivityId)
  if not template then
    return
  end
  if not self.followToOtherPlayerCacheHotAdd then
    self.followToOtherPlayerCacheHotAdd = {}
  end
  if not string.IsNullOrEmpty(msg.otherUid) then
    self.followToOtherPlayerCacheHotAdd[msg.otherUid] = template.love_like
  end
end

function ValentineDataManager:GetPlayerFollowHotAdd(uid)
  if not self.followToOtherPlayerCacheHotAdd then
    return 0
  end
  local hotAdd = self.followToOtherPlayerCacheHotAdd[uid] or 0
  return hotAdd
end

function ValentineDataManager:ClearPlayerFollowHotAdd()
  self.followToOtherPlayerCacheHotAdd = nil
end

function ValentineDataManager:ClearHotAddCache()
  self.cacheActivityId = nil
  self:ClearPlayerFollowHotAdd()
  self:ClearOtherPlayerGiftHotAddCache()
end

function ValentineDataManager:SetActReceiveGiftRecordData(message)
  local activityId = message.activityId
  if activityId == nil then
    return
  end
  if self.ReceiveGiftRecordData[activityId] == nil then
    self.ReceiveGiftRecordData[activityId] = {
      recordList = {},
      recordCount = 0,
      expiredTime = 0
    }
  end
  local start = message.start
  if start == 1 then
    self.ReceiveGiftRecordData[activityId].recordList = message.historyArr
  elseif start == #self.ReceiveGiftRecordData[activityId].recordList + 1 then
    for k, v in ipairs(message.historyArr) do
      table.insert(self.ReceiveGiftRecordData[activityId].recordList, v)
    end
  end
  self.ReceiveGiftRecordData[activityId].recordCount = message.total
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.ReceiveGiftRecordData[activityId].expiredTime = curTime + actReceiveGiftExpiredTime
end

function ValentineDataManager:GetActReceiveGiftRecordData(activityId)
  local data = self.ReceiveGiftRecordData[activityId]
  return data
end

function ValentineDataManager:CheckActReceiveGiftRecordDataNeedRefresh(activityId)
  local isNeedRefresh = true
  if self.ReceiveGiftRecordData[activityId] then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    isNeedRefresh = curTime > self.ReceiveGiftRecordData[activityId].expiredTime
  end
  return isNeedRefresh
end

function ValentineDataManager:SetActSendRankData(msg)
  local activityId = msg.activityId
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.actSendGiftRankData[activityId] == nil then
    self.actSendGiftRankData[activityId] = {
      expiredTime = 0,
      owner = nil,
      rankArr = nil,
      matchServerInfo = nil
    }
  end
  local targetData = self.actSendGiftRankData[activityId]
  targetData.expiredTime = curTime + actSendGiftRankDataExpiredTime
  targetData.owner = msg.owner
  targetData.rankArr = msg.rankArr
  targetData.matchServerInfo = msg.serverStr
end

function ValentineDataManager:CheckActSendRankDataNeedRefresh(activityId)
  local expiredTime = 0
  if self.actSendGiftRankData[activityId] then
    expiredTime = self.actSendGiftRankData[activityId].expiredTime
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  return expiredTime < curTime
end

function ValentineDataManager:GetActSendRankData(activityId)
  return self.actSendGiftRankData[activityId]
end

function ValentineDataManager:SetActSendRankRewardData(msg)
  local activityId = msg.activityId
  self.actSendGiftRankRewardData[activityId] = msg.rankRewards
  local rData = self:GetActivityReceiveData(activityId)
  if rData then
    rData.rankReward = msg.rankRewards
  end
end

function ValentineDataManager:GetActSendRankRewardData(activityId)
  return self.actSendGiftRankRewardData[activityId]
end

function ValentineDataManager:UpdateReceiveActivityData(activityId, data)
  local activityData = self.actReceiveGiftDataDic[activityId]
  if not activityData then
    activityData = ReceiveGiftListData.New()
    self.actReceiveGiftDataDic[activityId] = activityData
  end
  activityData:UpdateServerData(data)
  EventManager:GetInstance():Broadcast(EventId.ValentineGetActivityReceiveData)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ValentineDataManager:UpdateReceiveActivityLastRankId(activityId, lastRankId)
  local data = self:GetActivityReceiveData(activityId)
  if not data then
    return
  end
  data.lastRankId = toInt(lastRankId)
end

function ValentineDataManager:UpdateReceiveActivityBoxId(activityId, boxId)
  local data = self:GetActivityReceiveData(activityId)
  if not data then
    return
  end
  data.boxId = toInt(boxId)
end

function ValentineDataManager:UpdateReceiveActivityLastStarId(activityId, lastStarId)
  local data = self:GetActivityReceiveData(activityId)
  if not data then
    return
  end
  data.lastStarId = toInt(lastStarId)
end

function ValentineDataManager:UpdateReceiveActivityLastOpenDay(activityId, lastOpenDay)
  local data = self:GetActivityReceiveData(activityId)
  if not data then
    return
  end
  data.lastOpenDay = toInt(lastOpenDay)
end

function ValentineDataManager:UpdateTargetActivityStarRewardNum(activityId, num)
  local data = self:GetActivityReceiveData(activityId)
  if not data then
    return
  end
  data.starRewardNum = num
end

function ValentineDataManager:GetActivityReceiveData(activityId)
  return self.actReceiveGiftDataDic[activityId]
end

function ValentineDataManager:UpdateReceiveTotalReward(message)
  if not (message and message.activityId) or not message.totalRewardArr then
    return
  end
  if self.actReceiveGiftDataDic[message.activityId] then
    self.actReceiveGiftDataDic[message.activityId]:UpdateTotalReward(message.totalRewardArr)
  end
end

function ValentineDataManager:OnOpenBoxSuccess(t)
  local oldRankData
  if t.activityId then
    local activityId = toInt(t.activityId)
    local rData = DataCenter.ValentineDataManager:GetActivityReceiveData(activityId)
    if rData then
      local rankData = rData:GetCurRankData()
      if rankData then
        oldRankData = rankData
      end
    end
    if t.starRewardNum then
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    end
  end
  if t.reward then
    DataCenter.RewardManager:AddRewardsAndRes(t)
  end
  local newRankData
  if t.activityId then
    local activityId = toInt(t.activityId)
    local rData = DataCenter.ValentineDataManager:GetActivityReceiveData(activityId)
    local rankData = rData:GetCurRankData()
    if rData and rankData then
      newRankData = rankData
    end
  end
end

function ValentineDataManager:RequestRankData(channelType, activityId)
  local param = {}
  param.activityId = activityId
  param.start = 1
  local requestRange = 200
  param["end"] = requestRange
  if channelType == ValentineRankType.SelfServer then
    SFSNetwork.SendMessage(MsgDefines.ValentineLocalServerRank, param)
  end
  if channelType == ValentineRankType.ZoneServer then
    SFSNetwork.SendMessage(MsgDefines.ValentineGroupServerRank, param)
  end
end

function ValentineDataManager:UpdateRankData(channelType, message)
  local rankData = ValentineRankData.New()
  rankData:UpdateServerData(channelType, message)
  self.actRankData[channelType] = rankData
  EventManager:GetInstance():Broadcast(EventId.ValentineReceiveRankData)
end

function ValentineDataManager:GetRankData(channelType)
  return self.actRankData[channelType]
end

function ValentineDataManager:GetSendFastSaveKey(activityId)
  return SendFastGiftItemIndexKey .. activityId
end

function ValentineDataManager:GetSendFastIndexData(activityId)
  if self.sendFastGiftItemIndexDict[activityId] == nil then
    self.sendFastGiftItemIndexDict[activityId] = {index = 0, dirty = true}
  end
  if self.sendFastGiftItemIndexDict[activityId].dirty then
    local key = self:GetSendFastSaveKey(activityId)
    local index = Setting:GetInt(key, 0)
    self.sendFastGiftItemIndexDict[activityId].index = index
    self.sendFastGiftItemIndexDict[activityId].dirty = false
  end
  return self.sendFastGiftItemIndexDict[activityId].index
end

function ValentineDataManager:SetSendFastIndexData(activityId, index)
  local key = self:GetSendFastSaveKey(activityId)
  Setting:SetInt(key, index)
  if self.sendFastGiftItemIndexDict[activityId] then
    self.sendFastGiftItemIndexDict[activityId].index = index
    self.sendFastGiftItemIndexDict[activityId].dirty = false
  end
end

function ValentineDataManager:GetSendFastItemId(activityId)
  local itemId = 0
  local index = self:GetSendFastIndexData(activityId)
  if 0 < index then
    local temp = self:GetActSendTempByActId(activityId)
    if temp and temp.send_fast[index] then
      itemId = temp.send_fast[index]
    end
  end
  return itemId
end

function ValentineDataManager:GetRankDataById(id)
  local config = LocalController:instance():getLine(TableName.ValentineRank, id)
  if config then
    return config
  end
  return nil
end

function ValentineDataManager:GetMaxRank()
  local result = 0
  LocalController:instance():visitTable(TableName.ValentineRank, function(id, lineData)
    if lineData then
      local rank = lineData:getValue("type")
      if rank and rank > result then
        result = rank
      end
    end
  end)
  return result
end

function ValentineDataManager:GetCurRankMaxStar(rankType)
  local result = 0
  LocalController:instance():visitTable(TableName.ValentineRank, function(id, lineData)
    if lineData then
      local rank = lineData:getValue("type")
      if rank == rankType then
        local star = lineData:getValue("star")
        if star and star > result then
          result = star
        end
      end
    end
  end)
  return result
end

function ValentineDataManager:GetIsAutoSend(actId)
  if self.autoSendSaveDict[actId] == nil then
    local keyName = ActSendGiftAutoSendSaveKey .. actId .. "_" .. LuaEntry.Player.uid
    self.autoSendSaveDict[actId] = Setting:GetBool(keyName, false)
  end
  local ret = self.autoSendSaveDict[actId]
  return ret
end

function ValentineDataManager:SetIsAutoSend(actId, isAutoSend)
  self.autoSendSaveDict[actId] = isAutoSend
  local keyName = ActSendGiftAutoSendSaveKey .. actId .. "_" .. LuaEntry.Player.uid
  Setting:SetBool(keyName, isAutoSend)
end

function ValentineDataManager:GetActRed(activityId)
  local rData = self:GetActivityReceiveData(activityId)
  if not rData then
    return
  end
  if rData.openBoxInfo then
    for _, v in ipairs(rData.openBoxInfo) do
      local itemId = v
      local itemCount = DataCenter.ItemData:GetItemCount(itemId)
      if 0 < itemCount then
        return 1
      end
    end
  end
  if rData.boxDataDic and rData.activityGetData then
    local boxData = rData.boxDataDic[rData.boxId]
    local fragItem = rData.activityGetData.pieces
    if boxData and fragItem then
      local curFragItemCount = DataCenter.ItemData:GetItemCount(fragItem)
      local costItemNum = toInt(boxData.cost)
      if curFragItemCount >= costItemNum then
        return 1
      end
    end
  end
  if rData:CheckIsExistRankReward() then
    return 1
  end
  if 0 < rData.starRewardNum then
    return 1
  end
  return 0
end

function ValentineDataManager:GetSendGiftActRed(activityId)
  local actTemp = DataCenter.ValentineDataManager:GetActSendTempByActId(activityId)
  if not actTemp then
    return 0
  end
  local costId = actTemp.res_good[1] or 0
  local costNum = actTemp.res_good[2] or 1
  if costId <= 0 then
    return 0
  end
  local curHaveNum = DataCenter.ItemData:GetItemCount(costId)
  return costNum < curHaveNum and 1 or 0
end

function ValentineDataManager:GetIsNoGiftMessage(actId)
  if self.noGiftMessageDict[actId] == nil then
    local keyName = ActNoChocolateMessage .. actId .. "_" .. LuaEntry.Player.uid
    self.noGiftMessageDict[actId] = Setting:GetBool(keyName, false)
  end
  local ret = self.noGiftMessageDict[actId]
  return ret
end

function ValentineDataManager:SetIsNoGiftMessage(actId, isNoGiftMessage)
  self.noGiftMessageDict[actId] = isNoGiftMessage
  local keyName = ActNoChocolateMessage .. actId .. "_" .. LuaEntry.Player.uid
  Setting:SetBool(keyName, isNoGiftMessage)
end

function ValentineDataManager:SetNewMutualFollow(activityId, num)
  self.newMutualFollow[activityId] = toInt(num)
end

function ValentineDataManager:GetNewMutualFollow(activityId)
  return self.newMutualFollow[activityId] or 0
end

function ValentineDataManager:SetMatchList(activityId, playerInfoArr)
  if not activityId or not playerInfoArr then
    return
  end
  self.matchList[activityId] = playerInfoArr
end

function ValentineDataManager:ClearNewMutualFollow(activityId)
  self.newMutualFollow[activityId] = 0
  EventManager:GetInstance():Broadcast(EventId.ValentineSendActRecInfo)
end

function ValentineDataManager:GetMatchList(activityId)
  return self.matchList[activityId]
end

function ValentineDataManager:ParseMatchSuccessListData(msg)
  if msg == nil or msg.activityId == nil then
    return
  end
  self.matchSuccessDataDict[msg.activityId] = {
    followSize = toInt(msg.followSize) or 0,
    mutualFollowSize = toInt(msg.mutualFollowSize) or 0,
    playerArr = msg.playerArr or {}
  }
end

function ValentineDataManager:GetActMatchSuccessData(activityId)
  local data = self.matchSuccessDataDict[activityId]
  return data
end

function ValentineDataManager:GetAnyMatchSuccess()
  local activityList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.ActValentineSendGift.Type)
  local targetActId = 0
  if activityList and 0 < #activityList then
    targetActId = tonumber(activityList[1].id) or 0
  else
    return false
  end
  local open = DataCenter.ActivityListDataManager:IsActivityOpen(EnumActivity.ActValentineSendGift.Type)
  if not open then
    return false
  end
  if not self:GetIfOpenMatch() then
    return false
  end
  local data = self.matchSuccessDataDict[targetActId]
  if data and data.playerArr and 0 < table.length(data.playerArr) then
    return true
  end
  return false
end

function ValentineDataManager:GetIfMatchSuccess(playerUuid)
  local activityList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.ActValentineSendGift.Type)
  local targetActId = 0
  if activityList and 0 < #activityList then
    targetActId = tonumber(activityList[1].id) or 0
  end
  local data = self.matchSuccessDataDict[targetActId]
  if not data or not data.playerArr then
    return false
  end
  local open = DataCenter.ActivityListDataManager:IsActivityOpen(EnumActivity.ActValentineSendGift.Type)
  if not open then
    return false
  end
  if not self:GetIfOpenMatch() then
    return false
  end
  for _, v in ipairs(data.playerArr) do
    if v.uid == playerUuid then
      return true
    end
  end
  return false
end

function ValentineDataManager:RequestMatchRedPoint(activityId, playerUuid)
  if not activityId or not playerUuid then
    return
  end
  self.matchRequestingRedPointDict[activityId] = self.matchRequestingRedPointDict[activityId] or {}
  if self.matchRequestingRedPointDict[activityId][playerUuid] then
    return
  end
  self.matchRequestingRedPointDict[activityId][playerUuid] = ChatInterface.GetUtil().GeneratePrivateRoomId(playerUuid)
  if self.delayTimer == nil then
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      local redPointDic = self.matchRequestingRedPointDict[activityId]
      local roomIdList = {}
      for k, v in pairs(redPointDic) do
        table.insert(roomIdList, v)
      end
      local param = {}
      param.activityId = activityId
      param.roomIdList = roomIdList
      ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.ChatRoomNotRead, param)
      self.matchRequestingRedPointDict[activityId] = nil
      self.delayTimer:Stop()
      self.delayTimer = nil
    end, 0.3)
  end
end

function ValentineDataManager:GetMatchRedPoint(activityId, playerUuid)
  if not activityId or not playerUuid then
    return -1
  end
  self.matchSuccessRedPointDict[activityId] = self.matchSuccessRedPointDict[activityId] or {}
  if self.matchSuccessRedPointDict[activityId][playerUuid] then
    return self.matchSuccessRedPointDict[activityId][playerUuid]
  end
  return -1
end

function ValentineDataManager:ParseMatchSuccessRedPoint(msg)
  if msg == nil or msg.result == nil then
    return
  end
  local activityId = msg.result.activityId
  local redPointDic = msg.result.readInfo
  for k, v in pairs(redPointDic) do
    local targetUuid = ChatInterface.GetUtil().GetPlayerUuidByPrivateRoomId(k)
    self:SetMatchRedPoint(activityId, targetUuid, v)
    EventManager:GetInstance():Broadcast(EventId.RefreshValentineMatchSuccessRedPoint, {targetuuid = targetUuid, matchRedPoint = v})
  end
end

function ValentineDataManager:SetMatchRedPoint(activityId, playerUuid, matchRedPoint)
  if not activityId or not playerUuid then
    return
  end
  self.matchSuccessRedPointDict[activityId] = self.matchSuccessRedPointDict[activityId] or {}
  self.matchSuccessRedPointDict[activityId][playerUuid] = toInt(matchRedPoint) or 0
end

function ValentineDataManager:ClearAllMatchRedPointDict(activityId)
  if not activityId then
    return
  end
  self.matchSuccessRedPointDict[activityId] = {}
  self.matchRequestingRedPointDict[activityId] = {}
end

function ValentineDataManager:GetGetTmpDataByActivityId(activityId)
  local activityData = LocalController:instance():getLine(TableName.Activity, toInt(activityId))
  if not activityData or string.IsNullOrEmpty(activityData.tableInfo) or string.IsNullOrEmpty(activityData.tableInfoType) then
    return nil
  end
  local getLineData = LocalController:instance():getLine(activityData.tableInfo, toInt(activityData.tableInfoType))
  if not getLineData then
    return nil
  end
  return getLineData
end

function ValentineDataManager:GetIfOpenMatch()
  if self.functionOnMatch == nil then
    self.functionOnMatch = LuaEntry.DataConfig:CheckSwitch("valentine_match")
  end
  return not CoppaUtil.IsCoppaLimit() and self.functionOnMatch
end

function ValentineDataManager:UpdateNpcData(msgData)
  local data = self.npcGiftDataDic[msgData.npcId]
  if not data then
    data = ValentineNpcData.New()
    self.npcGiftDataDic[msgData.npcId] = data
  end
  data:UpdateData(msgData)
  return data
end

function ValentineDataManager:GetNpcData(npcId)
  local data = self.npcGiftDataDic[npcId]
  return data
end

function ValentineDataManager:GetNeedBubbleNpc()
  local list = {}
  local num = 0
  local curTime = UITimeManager:GetInstance():GetServerTime() * 0.001
  for i, v in pairs(self.npcGiftDataDic) do
    if v:IsNeedBubble(curTime) then
      table.insert(list, v)
      num = num + 1
    end
  end
  if 0 < num then
    table.sort(list, function(a, b)
      return a.rank < b.rank
    end)
  end
  return list, num
end

function ValentineDataManager:GetCompleteNpc()
  local list = {}
  local num = 0
  for i, v in pairs(self.npcGiftDataDic) do
    if v:IsComplete() then
      table.insert(list, v)
      num = num + 1
    end
  end
  if 0 < num then
    table.sort(list, function(a, b)
      return a.rank < b.rank
    end)
  end
  return list, num
end

function ValentineDataManager:ReqGetNpcReward(activityId, type, npcId)
  SFSNetwork.SendMessage(MsgDefines.ValentineSendNpcReward, {
    activityId = tonumber(activityId),
    type = type,
    npcId = npcId
  })
end

function ValentineDataManager:OnNpcRewardGet(msg)
  local npcData = self:GetNpcData(msg.npcId)
  if npcData then
    npcData:UpdateRewardStatus(msg)
    DataCenter.RewardManager:AddRewards(msg.reward)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIValentineNpcRewardCard, {anim = true}, npcData, msg.type, msg.reward, true)
    EventManager:GetInstance():Broadcast(EventId.ValentineNpcRewardGet, msg.npcId)
  end
end

function ValentineDataManager:OnNpcHistoryDataUpdate(msg)
  if not msg or not msg.npcArr then
    return
  end
  for i, v in ipairs(msg.npcArr) do
    self:UpdateNpcData(v)
  end
  EventManager:GetInstance():Broadcast(EventId.ValentineNpcHistoryUpdate)
end

function ValentineDataManager:GetHotAddByLikeDelta(activityId, startValue, endValue)
  local actTemp = DataCenter.ValentineDataManager:GetActSendTempByActId(activityId)
  local rangeList = actTemp:GetLikeAndHotValueRange()
  local hotAdd = 0
  local final = rangeList[#rangeList]
  if startValue >= final.rangeMin then
    hotAdd = (endValue - startValue) * final.hotAdd
    return hotAdd
  end
  for i, v in ipairs(rangeList) do
    if startValue >= v.rangeMin and startValue <= v.rangeMax then
      if endValue <= v.rangeMax then
        hotAdd = (endValue - startValue) * v.hotAdd
        break
      else
        hotAdd = hotAdd + (v.rangeMax - startValue) * v.hotAdd
      end
    elseif startValue < v.rangeMin and endValue >= v.rangeMin then
      hotAdd = hotAdd + (endValue - v.rangeMin + 1) * v.hotAdd
    end
  end
  return hotAdd
end

function ValentineDataManager:PopGetKingOfLoveRewardCountInfoStr(activityId)
  if not activityId then
    return nil
  end
  local curCount = DataCenter.ActivityReceiveDataManager:GetCurNumByActId(activityId) or 0
  local maxCount = DataCenter.ActivityReceiveDataManager:GetMaxNumOneDayByActId(activityId) or 0
  TimerManager:GetInstance():DelayInvoke(function()
    UIUtil.ShowTips(CS.GameEntry.Localization:GetString("activity_Valentine_getbubble_tips", maxCount, curCount))
  end, 1)
end

function ValentineDataManager:GetIfShowMatchTips(actId)
  if self.showMatchTips[actId] == nil then
    local keyName = ActValentineMatchTipsShow .. actId .. "_" .. LuaEntry.Player.uid
    self.showMatchTips[actId] = Setting:GetBool(keyName, false)
  end
  local ret = self.showMatchTips[actId]
  return ret
end

function ValentineDataManager:SetShowMatchTips(actId, haveShowTips)
  local keyName = ActValentineMatchTipsShow .. actId .. "_" .. LuaEntry.Player.uid
  Setting:SetBool(keyName, haveShowTips)
  self.showMatchTips[actId] = haveShowTips
end

ValentineDataManager.__init = __init
ValentineDataManager.__delete = __delete
ValentineDataManager.AddListener = AddListener
ValentineDataManager.RemoveListener = RemoveListener
return ValentineDataManager
