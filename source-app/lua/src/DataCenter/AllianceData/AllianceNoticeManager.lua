local AllianceNoticeManager = BaseClass("AllianceNoticeManager")
local AllianceNoticeData = require("DataCenter/AllianceData/AllianceNoticeData")
local LWChatPinData = require("DataCenter.LWChat.LWChatPinData")
local ADV_TIMES_PER_DAY = 3

function AllianceNoticeManager:__init()
  self.noticeData = {}
  self.noticeInfoDic = {}
  self.noticeInfoList = {}
  self.noticePinnedList = {}
  self.seqId = 0
  self.redNumber = 0
  EventManager:GetInstance():AddListener(EventId.PlayerMessageInfo, self.OnUserInfoUpdate)
  self.isWaitClickRespondCache = {}
  self.resetClickTimerCache = {}
  self.resetClickInternal = 1
  self.isNoticeClickedLikeCache = {}
  self.firstNormalNotice = nil
  self.firstR4R5Notice = nil
  self.isRefreshFirstNoticesData = false
  self.voteItemPlayerList = {}
  self.noticePhotoMaxNum = nil
end

function AllianceNoticeManager:__delete()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self.noticeListInfo = nil
  self.noticePinnedList = {}
  EventManager:GetInstance():RemoveListener(EventId.PlayerMessageInfo, self.OnUserInfoUpdate)
  self.noticeData = nil
  self.isWaitClickRespondCache = {}
  if self.resetClickTimerCache then
    for k, v in pairs(self.resetClickTimerCache) do
      self:KillNoticeWaitTimer(k)
    end
    self.resetClickTimerCache = {}
  end
  self.isNoticeClickedLikeCache = {}
  self.firstNormalNotice = nil
  self.firstR4R5Notice = nil
  self.voteItemPlayerList = nil
  self.noticePhotoMaxNum = nil
end

function AllianceNoticeManager:Startup()
  self:StartNextDayTimer()
end

function AllianceNoticeManager:GetTotalFristNotice()
  if self.noticeInfoList == nil then
    return nil
  end
  return self.noticeInfoList[1]
end

function AllianceNoticeManager:GetFirstNotice()
  if self.noticeInfoList == nil then
    return nil
  end
  for i = 1, #self.noticeInfoList do
    if self.noticeInfoList[i] and not self.noticeInfoList[i]:GetIsR4R5() then
      return self.noticeInfoList[i]
    end
  end
  return nil
end

function AllianceNoticeManager:GetFirstR4R5Notice()
  if self.noticeInfoList == nil then
    return nil
  end
  for i = 1, #self.noticeInfoList do
    if self.noticeInfoList[i] and self.noticeInfoList[i]:GetIsR4R5() then
      return self.noticeInfoList[i]
    end
  end
  return nil
end

function AllianceNoticeManager:ChangeNoticeToFirst(uuid)
  local changeSuccess = false
  if self.noticeInfoList == nil then
    return changeSuccess
  end
  local changeIndex = -1
  for i = 1, #self.noticeInfoList do
    local data = self.noticeInfoList[i]
    if data.uid == uuid then
      changeIndex = i
      break
    end
  end
  if 1 < changeIndex then
    changeSuccess = true
    local changeData = self.noticeInfoList[changeIndex]
    for i = changeIndex, 2, -1 do
      self.noticeInfoList[i] = self.noticeInfoList[i - 1]
    end
    self.noticeInfoList[1] = changeData
  end
  return changeSuccess
end

function AllianceNoticeManager:AddPlayerUidToPlayerInfoList(noticeUid, itemId, playerUid)
  self.voteItemPlayerList[noticeUid] = self.voteItemPlayerList[noticeUid] or {}
  self.voteItemPlayerList[noticeUid][itemId] = self.voteItemPlayerList[noticeUid][itemId] or {}
  table.insert(self.voteItemPlayerList[noticeUid][itemId], {uid = playerUid})
end

function AllianceNoticeManager:UpdateVoteItemPlayerInfoList(noticeUid, PlayerList)
  self.voteItemPlayerList[noticeUid] = PlayerList
  if self.noticeInfoDic[noticeUid] then
    self.noticeInfoDic[noticeUid]:UpdateVoteDataByPlayerList(PlayerList)
  end
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_REFRESH_VIEW)
end

function AllianceNoticeManager:GetVoteItemPlayerInfoList(noticeUid)
  return self.voteItemPlayerList[noticeUid]
end

function AllianceNoticeManager:AllianceNoticeChangeDeal(node)
  if not self.noticeInfoDic[node.uuid] then
    self.noticeInfoDic[node.uuid] = AllianceNoticeData:New()
    self.noticeInfoDic[node.uuid]:UpdateInfo(node)
    self.noticeInfoDic[node.uuid]:UpdateLikeAndDislikeInfo(node)
    table.insert(self.noticeInfoList, 1, self.noticeInfoDic[node.uuid])
    self:RefreshFirstNoticeData()
    self:RefreshRedDotNumber(self.noticeInfoDic[node.uuid])
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ALLIANCE_NOTICELIST_ADD)
    EventManager:GetInstance():Broadcast(EventId.ChatPinUpdate)
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ALLIANCE_NOTICELIST_UPDATE)
  else
    local changeListSuccess = false
    if node.noticeIsAdv == 1 then
      changeListSuccess = self:ChangeNoticeToFirst(node.uuid)
      if changeListSuccess then
        self:RefreshFirstNoticeData()
      end
    end
    DataCenter.AllianceNoticeManager:UpdatePinnedNoticeData(node, 2)
    if node.uuid and self.noticeInfoDic[node.uuid] and not self.noticeInfoDic[node.uuid]:GetIsAdv() then
      local lastAdvNoticeTime = node.adv > 0 and self.noticeData.lastAdvNoticeTime or nil
      if self.firstNormalNotice and self.firstNormalNotice.uid == node.uuid then
        self.firstNormalNotice:SetLastAdvNoticeTime(lastAdvNoticeTime)
        EventManager:GetInstance():Broadcast(EventId.ChatPinUpdate)
      elseif self.firstR4R5Notice and self.firstR4R5Notice.uid == node.uuid then
        self.firstR4R5Notice:SetLastAdvNoticeTime(lastAdvNoticeTime)
        EventManager:GetInstance():Broadcast(EventId.ChatPinUpdate)
      end
    end
    self.noticeInfoDic[node.uuid]:UpdateInfo(node)
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ALLIANCE_NOTICEDATA_UPDATE, {
      uuid = node.uuid,
      isSkipRefreshTmpShow = true
    })
    if changeListSuccess then
      EventManager:GetInstance():Broadcast(EventId.ChatPinUpdate)
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ALLIANCE_NOTICELIST_UPDATE)
    end
  end
end

function AllianceNoticeManager:AddOneNoticeData(node)
  DataCenter.AllianceNoticeManager:UpdatePinnedNoticeData(node, 1)
  if self.noticeInfoDic[node.uuid] then
    return true
  end
  self.noticeInfoDic[node.uuid] = AllianceNoticeData:New()
  self.noticeInfoDic[node.uuid]:UpdateInfo(node)
  self.noticeInfoDic[node.uuid]:UpdateLikeAndDislikeInfo(node)
  table.insert(self.noticeInfoList, 1, self.noticeInfoDic[node.uuid])
end

function AllianceNoticeManager:RefreshOneNoticeData(node, noticeRefreshType)
  DataCenter.AllianceNoticeManager:UpdatePinnedNoticeData(node, noticeRefreshType)
  if self.noticeInfoDic[node.uuid] == nil then
    return
  end
  self.noticeInfoDic[node.uuid]:UpdateInfo(node)
  if noticeRefreshType == 1 then
    self.noticeInfoDic[node.uuid]:UpdateLikeAndDislikeInfo(node)
  end
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ALLIANCE_NOTICEDATA_UPDATE, {
    uuid = node.uuid,
    isSkipRefreshTmpShow = true
  })
end

function AllianceNoticeManager:UpdatePinnedNoticeData(node, noticeRefreshType)
  if node == nil or node.uuid == nil then
    return
  end
  local pos = self:GetPinnedNoticePosition(node.uuid)
  if pos == nil then
    return
  end
  self.noticePinnedList[pos]:UpdateInfo(node)
  if noticeRefreshType == 1 then
    self.noticePinnedList[pos]:UpdateLikeAndDislikeInfo(node)
  end
end

function AllianceNoticeManager:UpdateVote(node)
  if self.noticeInfoDic[node.uuid] then
    self.noticeInfoDic[node.uuid]:UpdateVote(node)
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ALLIANCE_NOTICEDATA_UPDATE, {
      uuid = node.uuid,
      isSkipRefreshTmpShow = false
    })
  end
end

function AllianceNoticeManager:GetIndexById(uid)
  if self.noticeInfoList == nil then
    return nil
  end
  for index = 1, #self.noticeInfoList do
    if self.noticeInfoList[index].uid == uid then
      return index
    end
  end
end

function AllianceNoticeManager:RemoveAllNoticen()
  self.noticeInfoDic = {}
  self.noticeInfoList = {}
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ALLIANCE_NOTICELIST_UPDATE)
end

function AllianceNoticeManager:RemoveNoticen(message)
  if message and message.uuid then
    local pos = self:GetPinnedNoticePosition(message.uuid)
    if pos then
      table.remove(self.noticePinnedList, pos)
    end
  end
  if message and message.uuid and self.noticeInfoDic[message.uuid] then
    self:RefreshRedDotNumber(self.noticeInfoDic[message.uuid], true)
    self.noticeInfoDic[message.uuid] = nil
    self:UpdateVoteItemPlayerInfoList(message.uuid, nil)
    local index = self:GetIndexById(message.uuid)
    if index then
      table.remove(self.noticeInfoList, index)
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ALLIANCE_NOTICELIST_UPDATE)
      self:RefreshFirstNoticeByUid(message.uuid)
    end
  end
end

function AllianceNoticeManager:RemoveNoticenList(message)
  local removeUuids = message.removeUuids
  if removeUuids == nil or #removeUuids == 0 then
    return
  end
  for i = 1, #removeUuids do
    local targetUuid = removeUuids[i]
    if targetUuid then
      local pos = self:GetPinnedNoticePosition(targetUuid)
      if pos then
        table.remove(self.noticePinnedList, pos)
      end
    end
    if targetUuid and self.noticeInfoDic[targetUuid] then
      self:RefreshRedDotNumber(self.noticeInfoDic[targetUuid], true)
      self.noticeInfoDic[targetUuid] = nil
      self.voteItemPlayerList[targetUuid] = nil
      local index = self:GetIndexById(targetUuid)
      if index then
        table.remove(self.noticeInfoList, index)
      end
    end
  end
  local firstNoticeDict = {}
  if self.firstNormalNotice then
    firstNoticeDict[self.firstNormalNotice.uid] = self.firstNormalNotice
  end
  if self.firstR4R5Notice then
    firstNoticeDict[self.firstR4R5Notice.uid] = self.firstR4R5Notice
  end
  for i = 1, #removeUuids do
    local targetUuid = removeUuids[i]
    if targetUuid and firstNoticeDict[targetUuid] then
      self:RefreshFirstNoticeByUid(targetUuid)
    end
  end
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_REFRESH_VIEW)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ALLIANCE_NOTICELIST_UPDATE)
end

function AllianceNoticeManager:GetNoticeListInfo()
  local isR4orR5 = DataCenter.AllianceBaseDataManager:IsR4orR5()
  if not isR4orR5 then
    local normalNoticeInfoList = {}
    for i = 1, #self.noticeInfoList do
      if not self.noticeInfoList[i]:GetIsR4R5() then
        table.insert(normalNoticeInfoList, self.noticeInfoList[i])
      end
    end
    return normalNoticeInfoList
  end
  return self.noticeInfoList
end

function AllianceNoticeManager:GetNoticePinnedListInfo()
  local isR4orR5 = DataCenter.AllianceBaseDataManager:IsR4orR5()
  if not isR4orR5 then
    local normalNoticeInfoList = {}
    for i = 1, #self.noticePinnedList do
      if not self.noticePinnedList[i]:GetIsR4R5() then
        table.insert(normalNoticeInfoList, self.noticePinnedList[i])
      end
    end
    return normalNoticeInfoList
  end
  return self.noticePinnedList
end

function AllianceNoticeManager:GetNoticeDataById(uid)
  local data = self.noticeInfoDic[uid]
  if data == nil then
    data = self:GetNoticePinnedDataById(uid)
  end
  return data
end

function AllianceNoticeManager:GetNoticeDataWithoutPinnedById(uid)
  if self.noticeInfoDic == nil then
    return nil
  end
  local data = self.noticeInfoDic[uid]
  return data
end

function AllianceNoticeManager:GetNoticePinnedDataById(uid)
  for _, v in pairs(self.noticePinnedList) do
    if v.uid == uid then
      return v
    end
  end
end

function AllianceNoticeManager:SaveTranslatedContentById(uid, text, index)
  local data = self:GetNoticeDataById(uid)
  if data then
    data:SaveTransText(text, index)
  end
end

function AllianceNoticeManager:GetNoticeList()
  if LuaEntry.Player:IsInAlliance() then
    SFSNetwork.SendMessage(MsgDefines.AllianceNoticeListInfo, 0, 30)
    SFSNetwork.SendMessage(MsgDefines.AllianceNoticePinnedListInfo, 0, 30)
  end
end

function AllianceNoticeManager:GetRedDotNumber()
  return self.redNumber or 0
end

function AllianceNoticeManager:UpdateNoticeList(notices)
  if notices then
    for i = #notices, 1, -1 do
      notices[i].index = i
      local isExist = self:AddOneNoticeData(notices[i])
      if isExist then
        self:RefreshOneNoticeData(notices[i], 1)
      end
    end
    table.sort(self.noticeInfoList, function(a, b)
      return a.time > b.time
    end)
    self:RefreshFirstNoticeData()
    self.redNumber = self:InitRedDotNumber()
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ALLIANCE_NOTICELIST_UPDATE)
    if not self.isRefreshFirstNoticesData then
      self:RefreshFirstNoticeData()
      self.isRefreshFirstNoticesData = true
    end
  end
end

function AllianceNoticeManager:RefreshFirstNoticeData()
  self.firstNormalNotice = self:GetFirstNotice()
  self.firstR4R5Notice = self:GetFirstR4R5Notice()
end

function AllianceNoticeManager:UpdateNoticePinnedList(notices)
  self.noticePinnedList = {}
  if type(notices) == "table" then
    for _, v in pairs(notices) do
      local data = AllianceNoticeData:New()
      data:UpdateInfo(v)
      data:UpdateLikeAndDislikeInfo(v)
      data.isPinned = true
      table.insert(self.noticePinnedList, data)
    end
    table.sort(self.noticePinnedList, function(a, b)
      if a.pinnedTime and b.pinnedTime then
        return a.pinnedTime > b.pinnedTime
      end
      return a.time > b.time
    end)
  end
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ALLIANCE_NOTICELIST_UPDATE)
end

function AllianceNoticeManager:UpdateNoticePinned(notice)
  local find = false
  for k, v in pairs(self.noticePinnedList) do
    if v.uid == notice.uuid then
      if notice.pinnedTime and notice.pinnedTime ~= 0 then
        v:UpdateInfo(notice)
      else
        table.remove(self.noticePinnedList, k)
      end
      find = true
      break
    end
  end
  if not find then
    local data = AllianceNoticeData:New()
    data:UpdateInfo(notice)
    data.isPinned = true
    table.insert(self.noticePinnedList, data)
  end
  table.sort(self.noticePinnedList, function(a, b)
    if a.pinnedTime and b.pinnedTime then
      return a.pinnedTime > b.pinnedTime
    end
    return a.time > b.time
  end)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ALLIANCE_NOTICELIST_UPDATE)
end

function AllianceNoticeManager:GetPinnedNoticePosition(uid)
  for k, v in pairs(self.noticePinnedList) do
    if v.uid == uid then
      return k
    end
  end
end

function AllianceNoticeManager:StartNextDayTimer()
  local toNextDay = UITimeManager:GetInstance():GetResSecondsTo24() + 1
  if 0 < toNextDay then
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
      if self.noticeData then
        self.noticeData.restTimes = ADV_TIMES_PER_DAY
        self:StartNextDayTimer()
      end
    end, toNextDay)
  end
end

function AllianceNoticeManager:UpdateAllianceFirstNoticeData(msg)
  if self.noticeData then
    self.noticeData.content = msg.notice
    local isAdv = msg.noticeIsAdv or 0
    self.noticeData.time = 0 < isAdv and msg.lastAdvNoticeTime or msg.lastNormalNoticeTime or 0
    self.noticeData.lastAdvNoticeTime = msg.lastAdvNoticeTime or 0
    self.noticeData.restTimes = msg.noticeRestTimes or ADV_TIMES_PER_DAY
    self.noticeData.isAdv = msg.noticeIsAdv and msg.noticeIsAdv > 0 or false
    self.noticeData.publisherUid = msg.noticePublisherUid
    ChatManager2:GetInstance().User:requestSingleUserInfo(self.noticeData.publisherUid, true)
    EventManager:GetInstance():Broadcast(EventId.AllianceNoticeUpdate)
  end
end

function AllianceNoticeManager:IsNoticeManuallyClosed()
  local time = CommonUtil.PlayerPrefsGetString("AL_Notice_Manually_Close", "")
  local pinTimeFlag = self:GetNoticeSavePinTime(self.firstNormalNotice)
  return time == (tostring(pinTimeFlag) or "")
end

function AllianceNoticeManager:ManuallyCloseNotice(noticeDataTime)
  CommonUtil.PlayerPrefsSetString("AL_Notice_Manually_Close", tostring(noticeDataTime) or "")
end

function AllianceNoticeManager:IsR4R5NoticeManuallyClosed()
  local time = CommonUtil.PlayerPrefsGetString("AL_Notice_R4R5_Manually_Close", "")
  local pinTimeFlag = self:GetNoticeSavePinTime(self.firstR4R5Notice)
  return time == (tostring(pinTimeFlag) or "")
end

function AllianceNoticeManager:ManuallyCloseR4R5Notice(noticeDataTime)
  CommonUtil.PlayerPrefsSetString("AL_Notice_R4R5_Manually_Close", tostring(noticeDataTime) or "")
end

function AllianceNoticeManager:RefreshFirstNoticeByUid(uid)
  if self.firstNormalNotice and self.firstNormalNotice.uid == uid then
    self.firstNormalNotice = self:GetFirstNotice()
    local pinTimeFlag = self:GetNoticeSavePinTime(self.firstNormalNotice)
    self:ManuallyCloseNotice(pinTimeFlag or "")
    EventManager:GetInstance():Broadcast(EventId.ChatPinUpdate)
  elseif self.firstR4R5Notice and self.firstR4R5Notice.uid == uid then
    self.firstR4R5Notice = self:GetFirstR4R5Notice()
    local pinTimeFlag = self:GetNoticeSavePinTime(self.firstR4R5Notice)
    self:ManuallyCloseR4R5Notice(pinTimeFlag or "")
    EventManager:GetInstance():Broadcast(EventId.ChatPinUpdate)
  end
end

function AllianceNoticeManager:RefreshIsClosePinNotice(uid)
  local firstNotice = self:GetFirstNotice()
  local firstR4R5Notice = self:GetFirstR4R5Notice()
  if firstNotice and firstNotice.uid == uid then
    local pinTimeFlag = self:GetNoticeSavePinTime(self.firstNormalNotice)
    self:ManuallyCloseNotice(pinTimeFlag or "")
    EventManager:GetInstance():Broadcast(EventId.ChatPinUpdate)
  elseif firstR4R5Notice and firstR4R5Notice.uid == uid then
    local pinTimeFlag = self:GetNoticeSavePinTime(self.firstR4R5Notice)
    self:ManuallyCloseR4R5Notice(pinTimeFlag or "")
    EventManager:GetInstance():Broadcast(EventId.ChatPinUpdate)
  end
end

function AllianceNoticeManager:CloseFirstPinNotice(notice)
  local pinTimeFlag = self:GetNoticeSavePinTime(notice)
  if not notice:GetIsR4R5() then
    self:ManuallyCloseNotice(pinTimeFlag or "")
  else
    self:ManuallyCloseR4R5Notice(pinTimeFlag or "")
  end
end

function AllianceNoticeManager:GetNoticeSavePinTime(notice)
  if notice == nil then
    return nil
  end
  return notice:GetLastAdvNoticeTime() and notice:GetLastAdvNoticeTime() or notice:GetTime()
end

function AllianceNoticeManager:SaveTranslatedContent(translatedContent)
  if not self.noticeData or not self.noticeData.time then
    return nil
  end
  CommonUtil.PlayerPrefsSetString("AL_Notice_Translation_Raw", tostring(self.noticeData.content))
  CommonUtil.PlayerPrefsSetString("AL_Notice_Translated_Content", translatedContent)
end

local function GetFristTime(self)
  local dataTime = self:GetTotalFristNotice()
  if dataTime then
    dataTime = dataTime.time
  else
    dataTime = UITimeManager:GetInstance():GetServerTime()
  end
  return dataTime
end

function AllianceNoticeManager:SaveReadTime()
  local aid = ChatInterface.getAllianceId()
  local time = GetFristTime(self)
  if not time or string.IsNullOrEmpty(time) then
    time = UITimeManager:GetInstance():GetServerTime()
  end
  CommonUtil.PlayerPrefsSetString("AL_Notice_Read_time", aid .. "|" .. tostring(time))
  self.redNumber = 0
  return time
end

function AllianceNoticeManager:GetSaveTime()
  local time = CommonUtil.PlayerPrefsGetString("AL_Notice_Read_time")
  if not string.IsNullOrEmpty(time) then
    time = string.split(time, "|")
    local aid = ChatInterface.getAllianceId()
    if aid == time[1] then
      return tonumber(time[2])
    end
  end
end

function AllianceNoticeManager:RefreshRedDotNumber(node, isRemove)
  local time = self:GetSaveTime()
  time = time or self:SaveReadTime()
  if node and node.time and tonumber(node.time) > tonumber(time) then
    self.redNumber = isRemove and self.redNumber - 1 or self.redNumber + 1
  end
end

function AllianceNoticeManager:InitRedDotNumber()
  local time = self:GetSaveTime()
  time = time or self:SaveReadTime()
  local number = 0
  for i = 1, #self.noticeInfoList do
    if time < tonumber(self.noticeInfoList[i].time) then
      number = number + 1
    end
  end
  return number
end

function AllianceNoticeManager:GetTranslatedContent()
  if not self.noticeData or not self.noticeData.time then
    return nil
  end
  local rawText = CommonUtil.PlayerPrefsGetString("AL_Notice_Translation_Raw", "")
  if rawText == self.noticeData.content then
    return CommonUtil.PlayerPrefsGetString("AL_Notice_Translated_Content", nil)
  end
  return nil
end

function AllianceNoticeManager.OnUserInfoUpdate(uid)
  local noticeData = DataCenter.AllianceNoticeManager.noticeData
  if noticeData and noticeData.publisherUid and tostring(noticeData.publisherUid) == tostring(uid) then
    EventManager:GetInstance():Broadcast(EventId.ChatPinUpdate)
  end
end

function AllianceNoticeManager:SetIsWaitClickLikeCache(uid, state)
  if uid == nil then
    return
  end
  self.isWaitClickRespondCache = self.isWaitClickRespondCache or {}
  if self.isWaitClickRespondCache[uid] then
    self.isWaitClickRespondCache[uid][1] = state
  else
    self.isWaitClickRespondCache[uid] = {state, false}
  end
  self:SetWaitTimerByState(uid, state, 1)
  if state then
    self:SetIsNoticeClickedLike(uid)
  end
end

function AllianceNoticeManager:SetIsWaitClickDisLikeCache(uid, state)
  if uid == nil then
    return
  end
  self.isWaitClickRespondCache = self.isWaitClickRespondCache or {}
  if self.isWaitClickRespondCache[uid] then
    self.isWaitClickRespondCache[uid][2] = state
  else
    self.isWaitClickRespondCache[uid] = {false, state}
  end
  self:SetWaitTimerByState(uid, state, 2)
end

function AllianceNoticeManager:SetWaitTimerByState(uid, state, emojiType)
end

function AllianceNoticeManager:GetIsWaitClickRespondCache(uid)
  self.isWaitClickRespondCache = self.isWaitClickRespondCache or {}
  if self.isWaitClickRespondCache[uid] == nil then
    return nil
  end
  return self.isWaitClickRespondCache[uid]
end

function AllianceNoticeManager:GetIsNoticeClickedLike(uid)
  if uid == nil then
    return
  end
  self.isNoticeClickedLikeCache = self.isNoticeClickedLikeCache or {}
  return self.isNoticeClickedLikeCache[uid]
end

function AllianceNoticeManager:SetIsNoticeClickedLike(uid)
  if uid == nil then
    return
  end
  self.isNoticeClickedLikeCache = self.isNoticeClickedLikeCache or {}
  self.isNoticeClickedLikeCache[uid] = true
end

function AllianceNoticeManager:KillNoticeWaitTimer(uid)
  if uid == nil then
    return
  end
  local timerPair = self.resetClickTimerCache[uid]
  if timerPair then
    if timerPair[1] then
      timerPair[1]:Stop()
      timerPair[1] = nil
    end
    if timerPair[2] then
      timerPair[2]:Stop()
      timerPair[2] = nil
    end
  end
end

function AllianceNoticeManager:GetNoticeMaxPhotoNum()
  if self.noticePhotoMaxNum == nil then
    self.noticePhotoMaxNum = LuaEntry.DataConfig:TryGetNum("alliance_announcement_multiple_images", "k2", 0)
  end
  return self.noticePhotoMaxNum
end

function AllianceNoticeManager:GetVoteSelectTimeDataByCurTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local halfHourTime = 1800000
  local selectTimeFirst = self:GetVoteSelectFirstTimeByCurTime()
  local curLocalTimeData = UITimeManager:GetInstance():TimeStampToLocalDate(curTime)
  local curLerverTimeData = UITimeManager:GetInstance():TimeStampToServerDate(curTime)
  local timeList = {}
  local maxAddNum = 200
  local maxLocalDayNum = 4
  for i = 1, maxAddNum do
    timeList[i] = selectTimeFirst + (i - 1) * halfHourTime
  end
  local localDataList = {}
  local serverDataList = {}
  local localDataDayNum = 0
  local serverDataDayNum = 0
  for i = 1, maxAddNum do
    local time = timeList[i]
    local localData = UITimeManager:GetInstance():TimeStampToLocalDate(time)
    local serverData = UITimeManager:GetInstance():TimeStampToServerDate(time)
    local canAdd = false
    local preLocalDayData
    if 0 < #localDataList then
      preLocalDayData = localDataList[#localDataList]
    end
    if preLocalDayData == nil then
      if localData.year == curLocalTimeData.year and localData.month == curLocalTimeData.month and localData.day == curLocalTimeData.day then
        if maxLocalDayNum >= localDataDayNum + 1 then
          canAdd = true
          localDataDayNum = localDataDayNum + 1
        end
      elseif maxLocalDayNum >= localDataDayNum + 2 then
        canAdd = true
        localDataDayNum = localDataDayNum + 2
      end
    elseif localData.year == preLocalDayData.year and localData.month == preLocalDayData.month and localData.day == preLocalDayData.day then
      canAdd = true
    elseif maxLocalDayNum >= localDataDayNum + 1 then
      canAdd = true
      localDataDayNum = localDataDayNum + 1
    end
    if canAdd then
      local preServerDayData
      if 0 < #serverDataList then
        preServerDayData = serverDataList[#serverDataList]
      end
      local addNewLocalData = false
      if preLocalDayData == nil then
        addNewLocalData = true
      elseif localData.year == preLocalDayData.year and localData.month == preLocalDayData.month and localData.day == preLocalDayData.day then
        addNewLocalData = false
      else
        addNewLocalData = true
      end
      if addNewLocalData then
        local addData = {
          year = localData.year,
          month = localData.month,
          day = localData.day,
          timeDataList = {}
        }
        table.insert(localDataList, addData)
      end
      local curLocalData = localDataList[#localDataList]
      local addData = {
        hour = localData.hour,
        min = localData.min,
        sec = localData.sec,
        time = time
      }
      table.insert(curLocalData.timeDataList, addData)
      local addNewServerData = false
      if preServerDayData == nil then
        addNewServerData = true
      elseif serverData.year == preServerDayData.year and serverData.month == preServerDayData.month and serverData.day == preServerDayData.day then
        addNewServerData = false
      else
        addNewServerData = true
      end
      if addNewServerData then
        local addData = {
          year = serverData.year,
          month = serverData.month,
          day = serverData.day,
          timeDataList = {}
        }
        table.insert(serverDataList, addData)
      end
      local curServerData = serverDataList[#serverDataList]
      local addData2 = {
        hour = serverData.hour,
        min = serverData.min,
        sec = serverData.sec,
        time = time
      }
      table.insert(curServerData.timeDataList, addData2)
    else
      break
    end
  end
  local retData = {
    localDataList = localDataList,
    serverDataList = serverDataList,
    timeList = timeList
  }
  return retData
end

function AllianceNoticeManager:GetVoteSelectFirstTimeByCurTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local halfHourTime = 1800000
  local selectTimeFirst = math.ceil(curTime / halfHourTime) * halfHourTime + halfHourTime * 2
  return selectTimeFirst
end

return AllianceNoticeManager
