local ChatViewTipBubbleDataManager = BaseClass("ChatViewTipBubbleDataManager")
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization

function ChatViewTipBubbleDataManager:__init()
  self.roomGroup = nil
  self.isHaveInitRoomIdDict = {}
  self.curShowTipBubbleData = nil
  self.isCurDataNeedRefresh = true
  self.needInitRoomGroup = {
    [ChatGroupType.GROUP_COUNTRY] = true,
    [ChatGroupType.GROUP_LANGUAGE] = true,
    [ChatGroupType.GROUP_ALLIANCE] = true,
    [ChatGroupType.GROUP_ALLIANCE_MANAGER] = true
  }
  self.tipBubbleTypePriority = {
    [ChatViewTipBubbleType.TrainTip] = 8000,
    [ChatViewTipBubbleType.RedPackage] = 6000,
    [ChatViewTipBubbleType.Treasure] = 4000,
    [ChatViewTipBubbleType.HighFive] = 3000,
    [ChatViewTipBubbleType.AlHelp] = 2000,
    [ChatViewTipBubbleType.AllianceCongratulation] = 1000
  }
  self.chatPostTypeToTipBubbleType = {
    [PostType.RedPackge_New] = ChatViewTipBubbleType.RedPackage,
    [PostType.Detect_Treasure_Reward_Fin_Info] = ChatViewTipBubbleType.Treasure,
    [PostType.Text_PointShare_Alliance] = ChatViewTipBubbleType.Treasure,
    [PostType.FirstJoinAlliance] = ChatViewTipBubbleType.HighFive
  }
  self.alHelpNumIsShow = false
  self.alHelpRoomIsShow = false
  self.isTrainTipShow = false
  self.trainTipExpireTime = 0
  self.redPackageSeqIdDict = {}
  self.redPackageSeqIdList = {}
  self.treasureSeqIdDict = {}
  self.treasureUuidDict = {}
  self.treasureSeqIdList = {}
  self.isAllianceCongratulationTipShow = false
  self.allianceCongratulationList = nil
  self.timer = nil
  
  function self.timer_action()
    self.On1000MSTimeAction()
  end
  
  self:AddListener()
  self:TryInitAllRoomData()
  self:SetAlHelpNumData()
  self:ResetTrainTipData()
end

function ChatViewTipBubbleDataManager:__delete()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
  self.isAllianceCongratulationTipShow = nil
  self.allianceCongratulationList = nil
  self:RemoveListener()
end

function ChatViewTipBubbleDataManager:AddListener()
  EventManager:GetInstance():AddListener(ChatEventEnum.CHAT_REQUEST_HISTORY_MSG_RESULT, self.OnRequestHistoryResult)
  EventManager:GetInstance():AddListener(ChatEventEnum.CHAT_REFRESH_CHANNEL, self.OnRefreshChannel)
  EventManager:GetInstance():AddListener(ChatEventEnum.CHAT_RECIEVE_ROOM_MSG, self.OnGetNewChatMsg)
  EventManager:GetInstance():AddListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateChatMsg)
  EventManager:GetInstance():AddListener(ChatEventEnum.RefreshMainAlEvent, self.OnMyAlHelpNumChange)
  EventManager:GetInstance():AddListener(ChatEventEnum.AllianceQuitOK, self.OnMyAlHelpNumChange)
  EventManager:GetInstance():AddListener(ChatEventEnum.UpdateAllianceGiftNum, self.OnMyAlHelpNumChange)
  EventManager:GetInstance():AddListener(ChatEventEnum.UpdateAllianceHelpNum, self.OnMyAlHelpNumChange)
  EventManager:GetInstance():AddListener(ChatEventEnum.UpdateMainAllianceRedCount, self.OnMyAlHelpNumChange)
  EventManager:GetInstance():AddListener(ChatEventEnum.RefreshTrainStationView, self.OnMyTrainTipChange)
  EventManager:GetInstance():AddListener(ChatEventEnum.AllianceTrainVipInfo, self.OnMyTrainTipChange)
  EventManager:GetInstance():AddListener(ChatEventEnum.AllianceTrainVipSetInfo, self.OnMyTrainTipChange)
  EventManager:GetInstance():AddListener(ChatEventEnum.OnAllianceTrainStartInfoChanged, self.OnMyTrainTipChange)
  EventManager:GetInstance():AddListener(ChatEventEnum.AllianceCongratulationListNew, self.OnMyAllianceCongratulationChange)
  EventManager:GetInstance():AddListener(ChatEventEnum.CHAT_HIGH_FIVE_RECEIVE, self.OnHighFiveNumChange)
end

function ChatViewTipBubbleDataManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(ChatEventEnum.CHAT_REQUEST_HISTORY_MSG_RESULT, self.OnRequestHistoryResult)
  EventManager:GetInstance():RemoveListener(ChatEventEnum.CHAT_REFRESH_CHANNEL, self.OnRefreshChannel)
  EventManager:GetInstance():RemoveListener(ChatEventEnum.CHAT_RECIEVE_ROOM_MSG, self.OnGetNewChatMsg)
  EventManager:GetInstance():RemoveListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateChatMsg)
  EventManager:GetInstance():RemoveListener(ChatEventEnum.RefreshMainAlEvent, self.OnMyAlHelpNumChange)
  EventManager:GetInstance():RemoveListener(ChatEventEnum.AllianceQuitOK, self.OnMyAlHelpNumChange)
  EventManager:GetInstance():RemoveListener(ChatEventEnum.UpdateAllianceGiftNum, self.OnMyAlHelpNumChange)
  EventManager:GetInstance():RemoveListener(ChatEventEnum.UpdateAllianceHelpNum, self.OnMyAlHelpNumChange)
  EventManager:GetInstance():RemoveListener(ChatEventEnum.UpdateMainAllianceRedCount, self.OnMyAlHelpNumChange)
  EventManager:GetInstance():RemoveListener(ChatEventEnum.RefreshTrainStationView, self.OnMyTrainTipChange)
  EventManager:GetInstance():RemoveListener(ChatEventEnum.AllianceTrainVipInfo, self.OnMyTrainTipChange)
  EventManager:GetInstance():RemoveListener(ChatEventEnum.AllianceTrainVipSetInfo, self.OnMyTrainTipChange)
  EventManager:GetInstance():RemoveListener(ChatEventEnum.OnAllianceTrainStartInfoChanged, self.OnMyTrainTipChange)
  EventManager:GetInstance():RemoveListener(ChatEventEnum.AllianceCongratulationListNew, self.OnMyAllianceCongratulationChange)
  EventManager:GetInstance():RemoveListener(ChatEventEnum.CHAT_HIGH_FIVE_RECEIVE, self.OnHighFiveNumChange)
end

function ChatViewTipBubbleDataManager:GetCurShowTipBubbleData()
  self:TryRefreshCurShowData()
  return self.curShowTipBubbleData
end

function ChatViewTipBubbleDataManager:SetCurRoomData(group)
  local isHaveChange = false
  local changeBubbleType
  local isRoomShowChange = false
  local oldShowType = self:CheckRoomGroupCanShowBubble(self.roomGroup)
  local newShowType = self:CheckRoomGroupCanShowBubble(group)
  if oldShowType ~= newShowType then
    isRoomShowChange = true
  end
  self.roomGroup = group
  isHaveChange, changeBubbleType = self:OnRoomDataChange()
  if isRoomShowChange or isHaveChange and self:CheckIsNeedChangeCurShowDataCompareCurData(changeBubbleType) then
    self:TrySendRefreshCurShowDataMsg()
  end
end

function ChatViewTipBubbleDataManager.OnGetNewChatMsg(chatData)
  local self = DataCenter.ChatViewTipBubbleDataManager
  if self:CheckChatDataIsCanUse(chatData) == false then
    return
  end
  local isHaveRead = false
  local roomId = chatData.roomId
  local seqId = chatData.seqId
  local roomData = ChatManager2:GetInstance().Room:GetRoomData(roomId)
  if roomData and seqId <= roomData.readSeqId then
    isHaveRead = true
  end
  if isHaveRead then
    return
  end
  local isHaveChange = false
  local changeBubbleType
  isHaveChange, changeBubbleType = self:AddOnNewMessage(chatData)
  if isHaveChange and self:CheckIsNeedChangeCurShowDataCompareCurData(changeBubbleType) then
    self:TrySendRefreshCurShowDataMsg()
  end
end

function ChatViewTipBubbleDataManager.OnUpdateChatMsg(chatData)
  local self = DataCenter.ChatViewTipBubbleDataManager
  if self:CheckChatDataIsCanUse(chatData) == false then
    return
  end
  local isHaveChange = false
  local changeBubbleType
  isHaveChange, changeBubbleType = self:UpdateOnNewMessage(chatData)
  if isHaveChange and self:CheckIsNeedChangeCurShowDataCompareCurData(changeBubbleType) then
    self:TrySendRefreshCurShowDataMsg()
  end
end

function ChatViewTipBubbleDataManager:OnCreateChatItem(roomId, seqId, chatData)
  if self:CheckChatDataIsCanUse(chatData) == false then
    return
  end
  local isHaveChange = false
  local changeBubbleType
  isHaveChange, changeBubbleType = self:OnCreateChatItemType(chatData)
  if isHaveChange and self:CheckIsNeedChangeCurShowDataCompareCurData(changeBubbleType) then
    self:TrySendRefreshCurShowDataMsg()
  end
end

function ChatViewTipBubbleDataManager.OnRequestHistoryResult(serverData)
  local self = DataCenter.ChatViewTipBubbleDataManager
  if serverData == nil then
    return
  end
  if serverData.result == nil then
    return
  end
  local roomDatas = serverData.result.rooms
  if roomDatas == nil or #roomDatas == 0 then
    return
  end
  local isHaveDataChange = false
  local isShowBubble
  for _, data in pairs(roomDatas) do
    local roomId = data.roomId
    local roomData = ChatManager2:GetInstance().Room:GetRoomData(roomId)
    local group = roomData.group
    isShowBubble = ChatManager2:GetInstance().Room:IsShowBubbleAllianceHelp(group)
    local isNeedInit = roomData ~= nil and self.isHaveInitRoomIdDict[roomId] == nil and isShowBubble
    if isNeedInit then
      local msgs = roomData:GetMsgs()
      local readSeqId = roomData.readSeqId
      local curMinSeqId = 0 < #msgs and msgs[1].seqId - 1 or 0
      local minSeqId = math.max(readSeqId, curMinSeqId)
      self.isHaveInitRoomIdDict[roomId] = {group = group, minSeqId = minSeqId}
      for _, chatData in ipairs(msgs) do
        local isCanUse = self:CheckChatDataIsCanUse(chatData)
        if isCanUse then
          local isHaveChange = self:AddOnNewMessage(chatData)
          if isHaveChange then
            isHaveDataChange = true
          end
        end
      end
    end
  end
  if isHaveDataChange then
    self:TrySendRefreshCurShowDataMsg()
  end
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
    self.timer:Start()
  end
end

function ChatViewTipBubbleDataManager:TryInitAllRoomData()
  local roomDatas = ChatInterface.getRoomMgr():GetRoomDatas()
  local isHaveDataChange = false
  local isShowBubble
  for _, data in pairs(roomDatas) do
    local roomId = data.roomId
    local roomData = data
    local group = roomData.group
    isShowBubble = ChatManager2:GetInstance().Room:IsShowBubbleAllianceHelp(group)
    local isNeedInit = roomData ~= nil and self.isHaveInitRoomIdDict[roomId] == nil and isShowBubble
    if isNeedInit then
      local msgs = roomData:GetMsgs()
      local readSeqId = roomData.readSeqId
      local curMinSeqId = 0 < #msgs and msgs[1].seqId - 1 or 0
      local minSeqId = math.max(readSeqId, curMinSeqId)
      self.isHaveInitRoomIdDict[roomId] = {group = group, minSeqId = minSeqId}
      for _, chatData in ipairs(msgs) do
        local isCanUse = self:CheckChatDataIsCanUse(chatData)
        if isCanUse then
          local isHaveChange = self:AddOnNewMessage(chatData)
          if isHaveChange then
            isHaveDataChange = true
          end
        end
      end
    end
  end
  if isHaveDataChange then
    self:TrySendRefreshCurShowDataMsg()
  end
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
    self.timer:Start()
  end
end

function ChatViewTipBubbleDataManager.OnRefreshChannel(data)
  local self = DataCenter.ChatViewTipBubbleDataManager
  if data == nil then
    return
  end
  local roomId = data.roomId
  local group = data.group
  if roomId == nil then
    return
  end
  if self.isHaveInitRoomIdDict[roomId] == nil then
    return
  end
  self.isHaveInitRoomIdDict[roomId] = nil
  local isHaveChange = false
  local changeBubbleType
  isHaveChange, changeBubbleType = self:OnRemoveRoomIdType(roomId)
  if isHaveChange and self:CheckIsNeedChangeCurShowDataCompareCurData(changeBubbleType) then
    self:TrySendRefreshCurShowDataMsg()
  end
end

function ChatViewTipBubbleDataManager:TrySendRefreshCurShowDataMsg()
  if self.isCurDataNeedRefresh == false then
    self.isCurDataNeedRefresh = true
    EventManager:GetInstance():Broadcast(ChatEventEnum.ChatViewTipBubbleStateChange)
  end
end

function ChatViewTipBubbleDataManager:CheckIsNeedChangeCurShowDataCompareCurData(bubbleType)
  local isNeed = false
  if self.curShowTipBubbleData == nil then
    isNeed = true
  else
    local curBubbleType = self.curShowTipBubbleData.type
    local priority = self:GetBubbleTypePriority(bubbleType)
    local curPriority = self:GetBubbleTypePriority(curBubbleType)
    if priority and curPriority and priority >= curPriority then
      isNeed = true
    end
  end
  return isNeed
end

function ChatViewTipBubbleDataManager:CheckRoomSeqIdIsCanUse(chatData)
  local isCanUse = false
  if chatData == nil then
    return isCanUse
  end
  local roomId = chatData.roomId
  local seqId = chatData.seqId
  if roomId == nil or seqId == nil then
    return isCanUse
  end
  local roomInitData = self.isHaveInitRoomIdDict[roomId]
  if roomInitData and seqId > roomInitData.minSeqId then
    isCanUse = true
  end
  return isCanUse
end

function ChatViewTipBubbleDataManager:CheckChatDataPostTypeNeedUse(chatData)
  local isCanUse = false
  if chatData == nil then
    return isCanUse
  end
  local postType = chatData.post
  if self.chatPostTypeToTipBubbleType[postType] then
    isCanUse = true
  end
  return isCanUse
end

function ChatViewTipBubbleDataManager:CheckChatDataIsCanUse(chatData)
  local isCanUse = self:CheckRoomSeqIdIsCanUse(chatData) and self:CheckChatDataPostTypeNeedUse(chatData)
  return isCanUse
end

function ChatViewTipBubbleDataManager:GetBubbleTypePriority(bubbleType)
  local priority = 0
  if self.tipBubbleTypePriority[bubbleType] then
    priority = self.tipBubbleTypePriority[bubbleType]
  end
  return priority
end

function ChatViewTipBubbleDataManager:ClearCurShowData()
  local isHaveChange = false
  local changeBubbleType
  isHaveChange, changeBubbleType = self:ClearCurShowDataType()
  if isHaveChange and self:CheckIsNeedChangeCurShowDataCompareCurData(changeBubbleType) then
    self:TrySendRefreshCurShowDataMsg()
  end
end

function ChatViewTipBubbleDataManager:TryRefreshCurShowData()
  if self.isCurDataNeedRefresh == false then
    return
  end
  self.isCurDataNeedRefresh = false
  self.curShowTipBubbleData = nil
  if self:CheckRoomGroupCanShowBubble(self.roomGroup) == false then
    return
  end
  if self.curShowTipBubbleData == nil then
    self.curShowTipBubbleData = self:TryGetCurDataInTrainInviteType()
  end
  if self.curShowTipBubbleData == nil then
    self.curShowTipBubbleData = self:TryGetCurDataInRedPackageType()
  end
  if self.curShowTipBubbleData == nil then
    self.curShowTipBubbleData = self:TryGetCurDataInTreasureType()
  end
  if self.curShowTipBubbleData == nil then
    self.curShowTipBubbleData = self:TryGetCurDataInHighFiveType()
  end
  if self.curShowTipBubbleData == nil then
    self.curShowTipBubbleData = self:TryGetCurDataInAlHelpType()
  end
  if self.curShowTipBubbleData == nil then
    self.curShowTipBubbleData = self:TryGetCurDataInAllianceCongratulationType()
  end
end

function ChatViewTipBubbleDataManager.On1000MSTimeAction()
  local self = DataCenter.ChatViewTipBubbleDataManager
  if self.curShowTipBubbleData == nil then
    return
  end
  if self.isCurDataNeedRefresh == true then
    return
  end
  if self.curShowTipBubbleData.type == ChatViewTipBubbleType.RedPackage then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local expiredTime = self.curShowTipBubbleData.extra.expiredTime
    if curTime > expiredTime then
      self:TrySendRefreshCurShowDataMsg()
    end
  elseif self.curShowTipBubbleData.type == ChatViewTipBubbleType.TrainTip then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local expiredTime = self.trainTipExpireTime
    if curTime > expiredTime then
      self:TrySendRefreshCurShowDataMsg()
    end
  elseif self.curShowTipBubbleData.type == ChatViewTipBubbleType.AllianceCongratulation and (self:ResetAllianceCongratulationTipData() or not self.isAllianceCongratulationTipShow) then
    self:TrySendRefreshCurShowDataMsg()
  end
end

function ChatViewTipBubbleDataManager:AddOnNewMessage(chatData)
  local isHaveChange = false
  local changeBubbleType
  if chatData == nil then
    return isHaveChange, changeBubbleType
  end
  local tipBubbleType = self.chatPostTypeToTipBubbleType[chatData.post]
  changeBubbleType = tipBubbleType
  if tipBubbleType == ChatViewTipBubbleType.RedPackage then
    isHaveChange = self:AddOnNewMessageRedPackageType(chatData)
  elseif tipBubbleType == ChatViewTipBubbleType.Treasure then
    isHaveChange = self:AddOnNewMessageTreasureType(chatData)
  end
  return isHaveChange, changeBubbleType
end

function ChatViewTipBubbleDataManager:UpdateOnNewMessage(chatData)
  local isHaveChange = false
  local changeBubbleType
  local tipBubbleType = self.chatPostTypeToTipBubbleType[chatData.post]
  if tipBubbleType == ChatViewTipBubbleType.RedPackage then
    isHaveChange = self:UpdateOnNewMessageRedPackageType(chatData)
  elseif tipBubbleType == ChatViewTipBubbleType.Treasure then
    isHaveChange = self:UpdateTreasureType(chatData)
  end
  return isHaveChange, changeBubbleType
end

function ChatViewTipBubbleDataManager:OnRoomDataChange()
  local isHaveChange = false
  local changeBubbleType
  local priority = 0
  local curHaveChange, curBubbleType
  
  local function compareFunc(curHaveChange, curBubbleType)
    if curHaveChange then
      local curPriority = self:GetBubbleTypePriority(curBubbleType)
      if curPriority > priority then
        priority = curPriority
        changeBubbleType = curBubbleType
        isHaveChange = true
      end
    end
  end
  
  curBubbleType = ChatViewTipBubbleType.AlHelp
  curHaveChange = self:OnRoomDataChangeAlHelpType()
  compareFunc(curHaveChange, curBubbleType)
  return isHaveChange, changeBubbleType
end

function ChatViewTipBubbleDataManager:OnCreateChatItemType(chatData)
  local isHaveChange = false
  local changeBubbleType
  local tipBubbleType = self.chatPostTypeToTipBubbleType[chatData.post]
  changeBubbleType = tipBubbleType
  if tipBubbleType == ChatViewTipBubbleType.RedPackage then
    isHaveChange = self:OnCreateChatItemRedPackageType(chatData)
  elseif tipBubbleType == ChatViewTipBubbleType.Treasure then
    isHaveChange = self:OnCreateChatItemTreasureType(chatData)
  end
  return isHaveChange, changeBubbleType
end

function ChatViewTipBubbleDataManager:OnRemoveRoomIdType(roomId)
  local isHaveChange = false
  local changeBubbleType
  local priority = 0
  local curHaveChange, curBubbleType
  
  local function compareFunc(curHaveChange, curBubbleType)
    if curHaveChange then
      local curPriority = self:GetBubbleTypePriority(curBubbleType)
      if curPriority > priority then
        priority = curPriority
        changeBubbleType = curBubbleType
        isHaveChange = true
      end
    end
  end
  
  curBubbleType = ChatViewTipBubbleType.RedPackage
  curHaveChange = self:OnRemoveRoomIdTypeRedPackageType(roomId)
  compareFunc(curHaveChange, curBubbleType)
  curBubbleType = ChatViewTipBubbleType.Treasure
  curHaveChange = self:OnRemoveRoomIdTypeTreasureType(roomId)
  compareFunc(curHaveChange, curBubbleType)
  return isHaveChange, changeBubbleType
end

function ChatViewTipBubbleDataManager:ClearCurShowDataType()
  local isHaveChange = false
  local changeBubbleType
  if self.curShowTipBubbleData then
    local curBubbleType = self.curShowTipBubbleData.type
    changeBubbleType = curBubbleType
    if curBubbleType == ChatViewTipBubbleType.RedPackage then
      isHaveChange = true
      local roomId = self.curShowTipBubbleData.extra.roomId
      local seqId = self.curShowTipBubbleData.extra.seqId
      if self.redPackageSeqIdDict[roomId] and self.redPackageSeqIdDict[roomId][seqId] then
        local seqData = self.redPackageSeqIdDict[roomId][seqId]
        local index = seqData.index
        table.remove(self.redPackageSeqIdList[roomId], index)
        self.redPackageSeqIdDict[roomId][seqId] = nil
        for k, v in pairs(self.redPackageSeqIdDict[roomId]) do
          if index < v.index then
            v.index = v.index - 1
          end
        end
      end
    elseif curBubbleType == ChatViewTipBubbleType.Treasure then
      isHaveChange = true
      local roomId = self.curShowTipBubbleData.extra.roomId
      local seqId = self.curShowTipBubbleData.extra.seqId
      if self.treasureSeqIdDict[roomId] and self.treasureSeqIdDict[roomId][seqId] then
        local seqData = self.treasureSeqIdDict[roomId][seqId]
        local index = seqData.index
        table.remove(self.treasureSeqIdList[roomId], index)
        self.treasureSeqIdDict[roomId][seqId] = nil
        for k, v in pairs(self.treasureSeqIdDict[roomId]) do
          if index < v.index then
            v.index = v.index - 1
          end
        end
      end
    elseif curBubbleType == ChatViewTipBubbleType.HighFive then
      isHaveChange = true
      local player = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(LuaEntry.Player.uid)
      if player then
        player.highFiveCount = player.joinAllianceThumbsUpCount
      end
    end
  end
  return isHaveChange, changeBubbleType
end

function ChatViewTipBubbleDataManager.OnMyAlHelpNumChange()
  local self = DataCenter.ChatViewTipBubbleDataManager
  local oldAlHelpNumIsShow = self.alHelpNumIsShow
  self:SetAlHelpNumData()
  if oldAlHelpNumIsShow ~= self.alHelpNumIsShow and self:CheckIsNeedChangeCurShowDataCompareCurData(ChatViewTipBubbleType.AlHelp) then
    self:TrySendRefreshCurShowDataMsg()
  end
end

function ChatViewTipBubbleDataManager.OnMyTrainTipChange()
  local self = DataCenter.ChatViewTipBubbleDataManager
  local isHaveChange = self:ResetTrainTipData()
  if isHaveChange then
    self:TrySendRefreshCurShowDataMsg()
  end
end

function ChatViewTipBubbleDataManager.OnMyAllianceCongratulationChange()
  local self = DataCenter.ChatViewTipBubbleDataManager
  local isHaveChange = self:ResetAllianceCongratulationTipData()
  if isHaveChange then
    self:TrySendRefreshCurShowDataMsg()
  end
end

function ChatViewTipBubbleDataManager:OnHighFiveNumChange()
  local self = DataCenter.ChatViewTipBubbleDataManager
  self:TrySendRefreshCurShowDataMsg()
end

function ChatViewTipBubbleDataManager:SetAlHelpNumData()
  local alHelpNum = DataCenter.AllianceHelpDataManager:GetHelpNum()
  self.alHelpNumIsShow = 0 < alHelpNum
end

function ChatViewTipBubbleDataManager:SetAlHelpRoomData()
  local isShowBubble = false
  if self.roomGroup then
    isShowBubble = ChatManager2:GetInstance().Room:IsShowBubbleAllianceHelp(self.roomGroup)
  end
  self.alHelpRoomIsShow = isShowBubble
end

function ChatViewTipBubbleDataManager:TryGetCurDataInAlHelpType()
  local curData
  if self.alHelpNumIsShow and self.alHelpRoomIsShow then
    curData = {
      type = ChatViewTipBubbleType.AlHelp
    }
  end
  return curData
end

function ChatViewTipBubbleDataManager:OnRoomDataChangeAlHelpType()
  local isHaveChange = false
  local oldCanShow = self.alHelpNumIsShow and self.alHelpRoomIsShow
  self:SetAlHelpNumData()
  self:SetAlHelpRoomData()
  local newCanShow = self.alHelpNumIsShow and self.alHelpRoomIsShow
  if oldCanShow ~= newCanShow then
    isHaveChange = true
  end
  return isHaveChange
end

function ChatViewTipBubbleDataManager:GetRedPackageDataInChatData(chatData)
  local isUse = false
  local expiredTime = 0
  local uids = {}
  local extraJson
  if chatData.clientUpdateExtra then
    local temp = string.split(chatData.clientUpdateExtra, "|")
    if not string.IsNullOrEmpty(temp[2]) then
      uids = string.split(temp[2], ",")
    end
  end
  if chatData.extra ~= nil and chatData.extra.customJsonParam ~= nil then
    extraJson = rapidjson.decode(chatData.extra.customJsonParam)
  end
  local expiredTime = 0
  if extraJson and extraJson.expiredTime then
    expiredTime = tonumber(extraJson.expiredTime) or 0
  end
  if not DataCenter.RedPacketManager:GetIsOverdue(extraJson) and not DataCenter.RedPacketManager:GetIsReceive(chatData, uids) and not DataCenter.RedPacketManager:GetIsNone(extraJson, uids) then
    isUse = true
  end
  return isUse, expiredTime
end

function ChatViewTipBubbleDataManager:AddOnNewMessageRedPackageType(chatData)
  local isChange = false
  if chatData == nil then
    return isChange
  end
  if ChatManager2:GetInstance().Restrict:isInRestrictList(chatData.senderUid, RestrictType.BLOCK) then
    return isChange
  end
  local isUse, expiredTime = self:GetRedPackageDataInChatData(chatData)
  if isUse then
    isChange = true
    local roomId = chatData.roomId
    local seqId = chatData.seqId
    if self.redPackageSeqIdList[roomId] == nil then
      self.redPackageSeqIdList[roomId] = {}
    end
    if self.redPackageSeqIdDict[roomId] == nil then
      self.redPackageSeqIdDict[roomId] = {}
    end
    table.insert(self.redPackageSeqIdList[roomId], seqId)
    local seqData = {
      chatData = chatData,
      expiredTime = expiredTime,
      index = #self.redPackageSeqIdList[roomId]
    }
    self.redPackageSeqIdDict[roomId][seqId] = seqData
  end
  return isChange
end

function ChatViewTipBubbleDataManager:UpdateTreasureType(chatData)
  local isChange = false
  local roomId = chatData.roomId
  local seqId = chatData.seqId
  if self.treasureSeqIdDict[roomId] and self.treasureSeqIdDict[roomId][seqId] and chatData.clientUpdateExtra == "complete" then
    isChange = true
    local param
    if not string.IsNullOrEmpty(chatData.attachmentId) then
      param = rapidjson.decode(chatData.attachmentId)
    end
    if param then
      self.treasureUuidDict[param.uuid] = nil
    end
    if self.treasureSeqIdDict[roomId] and self.treasureSeqIdDict[roomId][seqId] then
      local seqData = self.treasureSeqIdDict[roomId][seqId]
      local index = seqData.index
      table.remove(self.treasureSeqIdList[roomId], index)
      self.treasureSeqIdDict[roomId][seqId] = nil
      for k, v in pairs(self.treasureSeqIdDict[roomId]) do
        if index < v.index then
          v.index = v.index - 1
        end
      end
    end
  end
  return isChange
end

function ChatViewTipBubbleDataManager:UpdateOnNewMessageRedPackageType(chatData)
  local isChange = false
  local roomId = chatData.roomId
  local seqId = chatData.seqId
  if self.redPackageSeqIdDict[roomId] and self.redPackageSeqIdDict[roomId][seqId] then
    local isUse, expiredTime = self:GetRedPackageDataInChatData(chatData)
    if not isUse then
      isChange = true
      local seqData = self.redPackageSeqIdDict[roomId][seqId]
      local index = seqData.index
      table.remove(self.redPackageSeqIdList[roomId], index)
      self.redPackageSeqIdDict[roomId][seqId] = nil
      for k, v in pairs(self.redPackageSeqIdDict[roomId]) do
        if index < v.index then
          v.index = v.index - 1
        end
      end
    end
  end
  return isChange
end

function ChatViewTipBubbleDataManager:TryGetCurDataInRedPackageType()
  local curData
  local roomIdList = {}
  local index = 1
  for roomId, roomInitData in pairs(self.redPackageSeqIdList) do
    if self.isHaveInitRoomIdDict[roomId] and self.redPackageSeqIdList[roomId] and #self.redPackageSeqIdList[roomId] > 0 then
      local group = self.isHaveInitRoomIdDict[roomId].group
      table.insert(roomIdList, {
        roomId = roomId,
        group = group,
        index = index
      })
      index = index + 1
    end
  end
  table.sort(roomIdList, function(a, b)
    if a.group == b.group then
      return a.index < b.index
    elseif a.group == ChatGroupType.GROUP_COUNTRY or b.group == ChatGroupType.GROUP_COUNTRY then
      if a.group == ChatGroupType.GROUP_COUNTRY then
        return true
      else
        return false
      end
    elseif a.group == ChatGroupType.GROUP_LANGUAGE or b.group == ChatGroupType.GROUP_LANGUAGE then
      if a.group == ChatGroupType.GROUP_LANGUAGE then
        return true
      else
        return false
      end
    else
      return a.index < b.index
    end
  end)
  for _, roomData in ipairs(roomIdList) do
    local roomId = roomData.roomId
    local seqIdList = self.redPackageSeqIdList[roomId]
    for i = #seqIdList, 1, -1 do
      local seqId = seqIdList[i]
      local seqData = self.redPackageSeqIdDict[roomId][seqId]
      if seqData then
        local chatData = seqData.chatData
        local expiredTime = seqData.expiredTime
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if expiredTime > curTime then
          curData = {
            type = ChatViewTipBubbleType.RedPackage,
            extra = {
              roomId = roomId,
              seqId = seqId,
              expiredTime = expiredTime,
              chatData = chatData
            }
          }
          break
        else
          table.remove(seqIdList, i)
          self.redPackageSeqIdDict[roomId][seqId] = nil
        end
      end
    end
  end
  return curData
end

function ChatViewTipBubbleDataManager:OnCreateChatItemRedPackageType(chatData)
  local isChange = false
  local roomId = chatData.roomId
  local seqId = chatData.seqId
  if self.redPackageSeqIdDict[roomId] and self.redPackageSeqIdDict[roomId][seqId] then
    isChange = true
    local seqData = self.redPackageSeqIdDict[roomId][seqId]
    local index = seqData.index
    table.remove(self.redPackageSeqIdList[roomId], index)
    self.redPackageSeqIdDict[roomId][seqId] = nil
    for k, v in pairs(self.redPackageSeqIdDict[roomId]) do
      if index < v.index then
        v.index = v.index - 1
      end
    end
  end
  return isChange
end

function ChatViewTipBubbleDataManager:OnRemoveRoomIdTypeRedPackageType(roomId)
  local isChange = false
  if self.redPackageSeqIdList[roomId] then
    isChange = true
    self.redPackageSeqIdList[roomId] = {}
    self.redPackageSeqIdDict[roomId] = {}
  end
  return isChange
end

function ChatViewTipBubbleDataManager:TryGetCurDataInTreasureType()
  local curData
  local roomIdList = {}
  for roomId, roomInitData in pairs(self.treasureSeqIdList) do
    if self.isHaveInitRoomIdDict[roomId] and self.treasureSeqIdList[roomId] and #self.treasureSeqIdList[roomId] > 0 then
      local group = self.isHaveInitRoomIdDict[roomId].group
      table.insert(roomIdList, {roomId = roomId, group = group})
    end
  end
  if 0 < #roomIdList then
    local roomData = roomIdList[1]
    local roomId = roomData.roomId
    local seqIdList = self.treasureSeqIdList[roomId]
    local seqId = seqIdList[#seqIdList]
    local eventId = 0
    if self.treasureSeqIdDict[roomId] and self.treasureSeqIdDict[roomId][seqId] then
      eventId = self.treasureSeqIdDict[roomId][seqId].eventId
    end
    curData = {
      type = ChatViewTipBubbleType.Treasure,
      extra = {
        roomId = roomId,
        seqId = seqId,
        eventId = eventId
      }
    }
  end
  return curData
end

function ChatViewTipBubbleDataManager:AddOnNewMessageTreasureType(chatData)
  local isChange = false
  local postType = chatData.post
  if postType == PostType.Text_PointShare_Alliance then
    local param
    if not string.IsNullOrEmpty(chatData.attachmentId) then
      param = rapidjson.decode(chatData.attachmentId)
    end
    if param and param.oname and param.shareType == WorldPointUIType.Treasure and param.uuid and self.treasureUuidDict[param.uuid] == nil and not chatData.clientUpdateExtra then
      local uuid = param.uuid
      local roomId = chatData.roomId
      local seqId = chatData.seqId
      local eventId = tonumber(param.treasureId) or 0
      if self.treasureSeqIdList[roomId] == nil then
        self.treasureSeqIdList[roomId] = {}
      end
      table.insert(self.treasureSeqIdList[roomId], seqId)
      if self.treasureSeqIdDict[roomId] == nil then
        self.treasureSeqIdDict[roomId] = {}
      end
      self.treasureSeqIdDict[roomId][seqId] = {
        chatData = chatData,
        uuid = uuid,
        index = #self.treasureSeqIdList[roomId],
        eventId = eventId
      }
      self.treasureUuidDict[uuid] = {roomId = roomId, seqId = seqId}
      isChange = true
    end
  end
  return isChange
end

function ChatViewTipBubbleDataManager:OnCreateChatItemTreasureType(chatData)
  local isChange = false
  local postType = chatData.post
  if postType == PostType.Text_PointShare_Alliance then
    local roomId = chatData.roomId
    local seqId = chatData.seqId
    if self.treasureSeqIdDict[roomId] and self.treasureSeqIdDict[roomId][seqId] then
      isChange = true
      local index = self.treasureSeqIdDict[roomId][seqId].index
      local uuid = self.treasureSeqIdDict[roomId][seqId].uuid
      self.treasureUuidDict[uuid] = nil
      table.remove(self.treasureSeqIdList[roomId], index)
      self.treasureSeqIdDict[roomId][seqId] = nil
      for k, v in pairs(self.treasureSeqIdDict[roomId]) do
        if index < v.index then
          v.index = v.index - 1
        end
      end
    end
  end
  return isChange
end

function ChatViewTipBubbleDataManager:OnRemoveRoomIdTypeTreasureType(roomId)
  local isChange = false
  if self.treasureSeqIdList[roomId] then
    isChange = true
    for k, v in pairs(self.treasureSeqIdDict[roomId]) do
      local uuid = v.uuid
      self.treasureUuidDict[uuid] = nil
    end
    self.treasureSeqIdList[roomId] = {}
    self.treasureSeqIdDict[roomId] = {}
    self.treasureUuidDict = {}
  end
  return isChange
end

function ChatViewTipBubbleDataManager:ResetTrainTipData()
  local isHaveChange = false
  local oldCanShow = self.isTrainTipShow
  self.isTrainTipShow = false
  local platform = DataCenter.LWAllyStationDataManager:GetPlatform(1)
  local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
  if trainData and trainData.vipInfo then
    self.isTrainTipShow = false
  elseif platform and platform.vipInvite and platform.vipInvite.vipId == LuaEntry.Player.uid then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < platform.vipInvite.endTime then
      self.isTrainTipShow = true
      self.trainTipExpireTime = platform.vipInvite.endTime
    end
  end
  isHaveChange = oldCanShow ~= self.isTrainTipShow
  return isHaveChange
end

function ChatViewTipBubbleDataManager:TryGetCurDataInTrainInviteType()
  self:ResetTrainTipData()
  local curData
  if self.isTrainTipShow then
    curData = {
      type = ChatViewTipBubbleType.TrainTip
    }
  end
  return curData
end

function ChatViewTipBubbleDataManager:TryGetCurDataInAllianceCongratulationType()
  self:ResetAllianceCongratulationTipData()
  local curData
  if self.isAllianceCongratulationTipShow then
    curData = {
      type = ChatViewTipBubbleType.AllianceCongratulation
    }
  end
  return curData
end

function ChatViewTipBubbleDataManager:ResetAllianceCongratulationTipData()
  local isHaveChange = false
  local oldCanShow = self.isAllianceCongratulationTipShow
  self.isAllianceCongratulationTipShow = DataCenter.AllianceCongratulationDataManager:AllianceCongratulationBubbleState()
  isHaveChange = oldCanShow ~= self.isAllianceCongratulationTipShow
  return isHaveChange
end

function ChatViewTipBubbleDataManager:TryGetCurDataInHighFiveType()
  local curData
  local list = DataCenter.AllianceMemberDataManager:GetNewJoinMembersInfo()
  local info
  for _, v in pairs(list) do
    if v.uid == LuaEntry.Player.uid then
      local player = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(LuaEntry.Player.uid, true)
      if player then
        local thumbsUpCount = player.joinAllianceThumbsUpCount - player.highFiveCount
        if 0 < thumbsUpCount then
          info = v
        end
      end
      break
    end
  end
  if info == nil then
    return
  end
  curData = {
    type = ChatViewTipBubbleType.HighFive,
    extra = {
      roomId = info.roomId,
      seqId = info.seqId,
      uuid = info.uuid,
      senderUid = info.uid,
      expireTime = info.expireTime
    }
  }
  return curData
end

function ChatViewTipBubbleDataManager:CheckRoomGroupCanShowBubble(roomGroup)
  local isShowBubble = ChatManager2:GetInstance().Room:IsShowBubbleAllianceHelp(roomGroup)
  return isShowBubble
end

return ChatViewTipBubbleDataManager
