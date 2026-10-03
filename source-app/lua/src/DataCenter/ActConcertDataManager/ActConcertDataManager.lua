local ActConcertDataManager = BaseClass("ActConcertDataManager")
local Localization = CS.GameEntry.Localization
local ActConcertData = require("DataCenter.ActConcertDataManager.ActConcertData")
local ActConcertTemplate = require("DataCenter.ActConcertDataManager.ActConcertTemplate")
local BuildMainGetSpecialRewardRecordData = require("DataCenter.ActConcertDataManager.BuildMainSpecialRewardRecordData")

function ActConcertDataManager:__init()
  self.concertList = {}
  self.concertConfig = {}
  self.buildMainRewardRecordDic = {}
  self.curClaimRewardCountDic = {}
  self.lastClickConcertBubbleTime = 0
  self.shareCd = -1
  self:InitConfig()
  EventManager:GetInstance():AddListener(EventId.OnPassDay, self.OnPassDay)
end

function ActConcertDataManager:__delete()
  EventManager:GetInstance():RemoveListener(EventId.OnPassDay, self.OnPassDay)
  self.concertList = nil
  self.concertConfig = nil
  self.buildMainRewardRecordDic = nil
  self.lastClickConcertBubbleTime = nil
  self.shareCd = nil
end

function ActConcertDataManager:InitConfig()
  LocalController:instance():visitTable(TableName.ACT_CONCERT, function(id, line)
    local template = ActConcertTemplate.New()
    template:InitData(line)
    self.concertConfig[template.id] = template
  end)
end

function ActConcertDataManager:InitData(t)
  self:InitBuildMainRewardRecord(t.statusReceiveArr)
  local recordData = {}
  if t.music_party_times then
    recordData = t.music_party_times[1] or {}
  end
  for k, v in pairs(recordData) do
    self.curClaimRewardCountDic[tonumber(k)] = v
  end
end

function ActConcertDataManager:RequestSkinPartyList(activityId)
  SFSNetwork.SendMessage(MsgDefines.SkinPartyList, activityId)
end

function ActConcertDataManager:OnRecSkinPartyList(message)
  if not message or not message.partyArr then
    Logger.LogError("ActConcertDataManager:OnRecSkinPartyList - message or message.partyArr is nil")
    return
  end
  self.concertList = {}
  for _, concertData in ipairs(message.partyArr) do
    local data = ActConcertData.New()
    data:ParseData(concertData)
    table.insert(self.concertList, data)
  end
  EventManager:GetInstance():Broadcast(EventId.OnRecSkinPartyList)
end

function ActConcertDataManager:GetConcertList()
  return self.concertList
end

function ActConcertDataManager:RemoveConcertFromList(partyId)
  if not partyId then
    Logger.LogError("ActConcertDataManager:RemoveConcertFromList - partyId is nil")
    return
  end
  for i = #self.concertList, 1, -1 do
    if self.concertList[i].partyId == partyId then
      table.remove(self.concertList, i)
      break
    end
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshSkinPartyList)
end

function ActConcertDataManager:GetConcertListViewConfig(activityId)
  local result = {}
  local activityConfig = LocalController:instance():getLine(TableName.Activity, toInt(activityId))
  if activityConfig == nil then
    return result
  end
  local id = tonumber(activityConfig.para_8)
  if not self.concertConfig or not self.concertConfig[id] then
    Logger.LogError("concertConfig not contain id ==" .. id)
    return result
  end
  local config = self.concertConfig[id]
  result.bgPicPath = config.bgPicPath
  result.bannerPicPath = config.bannerPicPath
  result.scrollPicPath = config.scrollPicPath
  result.title = config.title
  result.emptyText = config.emptyText
  result.bubbleLimit = config.bubbleLimit
  result.getText = config.getText
  result.status = config.status
  return result
end

function ActConcertDataManager:GetGoodsId(activityId)
  local result = {}
  local activityConfig = LocalController:instance():getLine(TableName.Activity, toInt(activityId))
  if activityConfig == nil then
    return result
  end
  local id = tonumber(activityConfig.para_8)
  if not self.concertConfig or not self.concertConfig[id] then
    Logger.LogError("concertConfig not contain id ==" .. id)
    return result
  end
  local config = self.concertConfig[id]
  return config.goods_id
end

function ActConcertDataManager:InitBuildMainRewardRecord(dataList)
  self.buildMainRewardRecordDic = {}
  if dataList == nil then
    return
  end
  for i = 1, #dataList do
    local recordKey = dataList[i]
    local strList = string.split(recordKey, "_")
    local playerUid = strList[1]
    local param = {
      playerUid = playerUid,
      statusId = tonumber(strList[2]),
      endTimestamp = tonumber(strList[3])
    }
    if self.buildMainRewardRecordDic[recordKey] == nil then
      local script = BuildMainGetSpecialRewardRecordData.New()
      script:ParseData(param)
      self.buildMainRewardRecordDic[recordKey] = script
    else
      self.buildMainRewardRecordDic[recordKey]:ParseData(param)
    end
  end
end

function ActConcertDataManager:AddBuildMainSpecialRewardRecord(recordKey)
  if recordKey == nil then
    return
  end
  local strList = string.split(recordKey, "_")
  local playerUid = strList[1]
  local param = {
    playerUid = playerUid,
    statusId = tonumber(strList[2]),
    endTimestamp = tonumber(strList[3])
  }
  if self.buildMainRewardRecordDic[recordKey] == nil then
    local script = BuildMainGetSpecialRewardRecordData.New()
    script:ParseData(param)
    self.buildMainRewardRecordDic[recordKey] = script
  else
    self.buildMainRewardRecordDic[recordKey]:ParseData(param)
  end
  EventManager:GetInstance():Broadcast(EventId.GetBuildMainPartyRewardRefresh, playerUid)
end

function ActConcertDataManager:HasGotBuildMainReward(recordKey)
  if recordKey == nil then
    Logger.LogError("\233\159\179\228\185\144\232\138\130  AddBuildMainSpecialRewardRecord \228\188\160\229\133\165\229\143\130\230\149\176\228\184\186\231\169\186\239\188\129")
    return false
  end
  return self.buildMainRewardRecordDic[recordKey] ~= nil
end

function ActConcertDataManager:CanGetCurClaimRewardByStatusId(statusId)
  self.curClaimRewardCountDic = self.curClaimRewardCountDic or {}
  if self.curClaimRewardCountDic[statusId] == nil then
    return true
  end
  local curClaimRewardCount = self.curClaimRewardCountDic[statusId]
  for k, v in pairs(self.concertConfig) do
    if tonumber(v.status) == statusId then
      return curClaimRewardCount < v.bubbleLimit
    end
  end
  return true
end

function ActConcertDataManager:GetConcertConfigByStatusId(statusId)
  for k, v in pairs(self.concertConfig) do
    if tonumber(v.status) == statusId then
      return v
    end
  end
  return nil
end

function ActConcertDataManager:RefreshClaimRewardCount(status, count)
  if self.curClaimRewardCountDic == nil then
    return
  end
  self.curClaimRewardCountDic[status] = count
end

function ActConcertDataManager:ResetClaimRewardCount()
  for k, v in pairs(self.curClaimRewardCountDic) do
    self.curClaimRewardCountDic[k] = 0
  end
end

function ActConcertDataManager:GetClaimRewardCount(statusId)
  if self.curClaimRewardCountDic == nil then
    return 0
  end
  if self.curClaimRewardCountDic[statusId] == nil then
    return 0
  end
  return self.curClaimRewardCountDic[statusId]
end

function ActConcertDataManager:OnPassDay()
  DataCenter.ActConcertDataManager:ResetClaimRewardCount()
end

function ActConcertDataManager:GetMaxStatus(activityId)
  local result = ""
  local activityConfig = LocalController:instance():getLine(TableName.Activity, toInt(activityId))
  if activityConfig == nil then
    return result
  end
  local id = tonumber(activityConfig.para_8)
  local config = self.concertConfig[id]
  if not config then
    Logger.LogError("concertConfig not contain id ==" .. id)
    return result
  end
  local status = tonumber(config.status)
  local statusInfo = LocalController:instance():getLine(TableName.StatusTab, status)
  if statusInfo == nil or not statusInfo.max_layer then
    Logger.LogError("StatusTab config is wrong id ==" .. status)
    return result
  end
  return tonumber(statusInfo.max_layer)
end

function ActConcertDataManager:ShareToChat(pointId, playerName)
  local share_param = {}
  share_param.post = PostType.ActConcertReward
  share_param.postType = PostType.ActConcertReward
  local concertRewardParam = {}
  concertRewardParam.pointId = pointId
  concertRewardParam.playerName = playerName
  share_param.param = concertRewardParam
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
end

function ActConcertDataManager:GetShareCd(id)
  local stateMeta = LocalController:instance():getLine(TableName.StatusTab, id)
  if stateMeta and stateMeta.para1 ~= nil and toInt(stateMeta.para1) then
    return toInt(stateMeta.para1)
  end
  return 0
end

function ActConcertDataManager:GetIfClickConcertBubble(id)
  if not self.shareCd or self.shareCd < 0 then
    self.shareCd = self:GetShareCd(id)
  end
  local currentTime = UITimeManager:GetInstance():GetServerTime()
  local delta = currentTime - self.lastClickConcertBubbleTime
  return delta / 1000 >= self.shareCd
end

function ActConcertDataManager:UpdateLastShareBubbleTime()
  self.lastClickConcertBubbleTime = UITimeManager:GetInstance():GetServerTime()
end

function ActConcertDataManager:GetDeltaTime(id)
  if self.lastClickConcertBubbleTime == nil then
    return 0
  end
  local currentTime = UITimeManager:GetInstance():GetServerTime()
  if not self.shareCd or 0 > self.shareCd then
    self.shareCd = self:GetShareCd(id)
  end
  local delta = self.lastClickConcertBubbleTime / 1000 + self.shareCd - currentTime / 1000
  return math.floor(delta)
end

return ActConcertDataManager
