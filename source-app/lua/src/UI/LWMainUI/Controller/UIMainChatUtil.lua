local UIMainChatUtil = BaseClass("UIMainChatUtil")
local rapidjson = require("rapidjson")
local BubbleTypeConfig = {
  [BubbleType.LuckyBuffPacket] = {
    iconPath = "Assets/Main/Sprites/UI/UIGetLucky/zxl_haoyun_qipao.png",
    type = BubbleType.RedPackage,
    sort = 15
  },
  [BubbleType.RedPackage] = {
    iconPath = "Assets/Main/Sprites/UI/UIMain/UIMainBubble/zyf_liaotianqipao_jindan_icon.png",
    type = BubbleType.RedPackage,
    sort = 15
  },
  [BubbleType.Notice] = {
    iconPath = "Assets/Main/Sprites/UI/UIMain/UIMainBubble/zyf_liaotianqipao_tongmenggonggao_icon.png",
    type = BubbleType.Notice,
    sort = 13
  },
  [BubbleType.Treasure] = {
    iconPath = "Assets/Main/Sprites/UI/UIMain/UIMainBubble/zyf_liaotianqipao_wajueji_icon.png",
    type = BubbleType.Treasure,
    sort = 14,
    jumpRoom = true
  },
  [BubbleType.Private] = {
    type = BubbleType.Private,
    sort = 10
  },
  [BubbleType.GroupChat] = {
    type = BubbleType.GroupChat,
    sort = 10,
    jumpRoom = true
  },
  [BubbleType.Gift] = {
    type = BubbleType.Gift,
    sort = 10.1,
    jumpRoom = true,
    size = {x = 90, y = 90}
  },
  [BubbleType.CustomerService] = {
    type = BubbleType.CustomerService,
    sort = 11,
    iconPath = "Assets/Main/Sprites/UI/UIMain/UIMainBubble/zyf_kefuzhongxin_qipao_icon.png"
  },
  [BubbleType.At] = {
    type = BubbleType.At,
    iconPath = "Assets/Main/Sprites/UI/UIMain/UIMainBubble/zyf_liaotian_at_qipao_icon.png",
    sort = 12,
    jumpRoom = true
  },
  [BubbleType.ElectricianGather] = {
    type = BubbleType.ElectricianGather,
    iconPath = "Assets/Main/SeasonRes/S4/Sprites/Common/PowerHouseIcon/ljq_saijis4_rukou_dianliang_09.png",
    sort = 10
  },
  [BubbleType.NewThumpsUp] = {
    type = BubbleType.NewThumpsUp,
    iconPath = "Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/ChatItems/mjc_lianmeng_jizhang_liaotian_bg03.png",
    sort = 16
  },
  [BubbleType.NewsCenter] = {
    type = BubbleType.NewsCenter,
    iconPath = "Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/NewCenter/zxl_hongdian_xin_da.png",
    sort = 9
  },
  [BubbleType.FireworkGiftBox] = {
    type = BubbleType.FireworkGiftBox,
    iconPath = "Assets/Main/Sprites/UI/UIMain/LWMainUI/mjc_yanhua_icon_liaotiantixing.png",
    sort = 13
  },
  [BubbleType.S0AllianceBoss] = {
    type = BubbleType.S0AllianceBoss,
    iconPath = "Assets/Main/Sprites/UI/UIMain/LWMainUI/LXY_tmjy_02.png",
    sort = 13
  }
}

function UIMainChatUtil.GetIsTreasure(chatData)
  local param
  if not string.IsNullOrEmpty(chatData.attachmentId) then
    param = rapidjson.decode(chatData.attachmentId)
  end
  if param and param.oname and param.shareType == WorldPointUIType.Treasure then
    local path = ""
    local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(param.treasureId)
    if template then
      path = template:GetChatBubblePath()
    end
    return true, path
  end
end

function UIMainChatUtil.GetBubble(chatData)
  if not chatData then
    return
  end
  local room = ChatInterface.getRoomData(chatData.roomId)
  if not room or room:GetNotDisturbing() then
    return
  end
  local info
  if chatData.post == PostType.RedPackge_New then
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
    if not DataCenter.RedPacketManager:GetIsOverdue(extraJson) and not DataCenter.RedPacketManager:GetIsReceive(chatData, uids) and not DataCenter.RedPacketManager:GetIsNone(extraJson, uids) then
      if extraJson and extraJson.luckSiphonId ~= nil then
        info = BubbleTypeConfig[BubbleType.LuckyBuffPacket]
      else
        info = BubbleTypeConfig[BubbleType.RedPackage]
      end
    end
  elseif chatData.post == PostType.Text_PointShare_Alliance then
    local isTreasure, iconPath = UIMainChatUtil.GetIsTreasure(chatData)
    if isTreasure then
      info = DeepCopy(BubbleTypeConfig[BubbleType.Treasure])
      if not string.IsNullOrEmpty(iconPath) then
        info.iconPath = iconPath
      end
    end
  elseif chatData.post == PostType.Electrician_Gather then
    local skillTemplate = DataCenter.MasteryManager:GetSkillTemplateByType(MasterySkill.ElectricianGather)
    if skillTemplate and UITimeManager:GetInstance():GetServerTime() < chatData.serverTime + skillTemplate.values[1] * 1000 then
      info = BubbleTypeConfig[BubbleType.ElectricianGather]
    end
  elseif chatData.post == PostType.Text_AllianceNotice then
    info = BubbleTypeConfig[BubbleType.Notice]
  elseif chatData.post == PostType.GiftGiving and room:isPrivateChat() then
    if room.giftInfo and room.giftInfo.seqId == chatData.seqId then
      local iconPath = DataCenter.GiftSystemManager:GetGiftIconByGroup(room.giftInfo.itemId, room.giftInfo.num)
      if iconPath then
        info = DeepCopy(BubbleTypeConfig[BubbleType.Gift])
        info.iconPath = iconPath
        info.chatData = chatData
      end
    end
  elseif chatData.group == ChatGroupType.GROUP_CUSTOM and LuaEntry.Player.uid ~= chatData.senderUid then
    local room = ChatInterface.getRoomData(chatData.roomId)
    if room:isPrivateChat() and chatData.post ~= PostType.Text_FightReport and chatData.post ~= PostType.HELP_STOP_FIRE_PERSION then
      info = BubbleTypeConfig[BubbleType.Private]
    end
  elseif chatData.post == PostType.FIREWORK_GIFT_REWARD then
    if chatData.extra ~= nil and chatData.extra.customJsonParam ~= nil then
      local uids = {}
      local extraJson = rapidjson.decode(chatData.extra.customJsonParam)
      if chatData.clientUpdateExtra then
        local tempList = string.split(chatData.clientUpdateExtra, "|")
        for k, v in ipairs(tempList) do
          table.insert(uids, v)
        end
      end
      local isFull = #uids >= UIMainChatUtil.GetFireworkMaxNum(extraJson)
      local isGot = DataCenter.LWFireworkGiftManager:IsThisGiftUuidGot(extraJson.uuid)
      local isViewed = DataCenter.LWFireworkGiftManager:IsThisChatViewed(extraJson.uuid)
      if not isGot and not isViewed and not isFull then
        info = BubbleTypeConfig[BubbleType.FireworkGiftBox]
      end
      DataCenter.LWFireworkGiftManager:SetNewFireworkGiftInChat(chatData)
    end
  elseif chatData.group == ChatGroupType.GROUP_CUSTOM_GROUP and LuaEntry.Player.uid ~= chatData.senderUid then
    if chatData.post ~= PostType.Text_FightReport and chatData.post ~= PostType.HELP_STOP_FIRE_PERSION then
      info = BubbleTypeConfig[BubbleType.GroupChat]
    end
  elseif chatData.post == PostType.S0_ALLIANCE_BOSS_GIFT_REWARD and chatData.extra ~= nil and chatData.extra.customJsonParam ~= nil then
    local uids = {}
    local extraJson = rapidjson.decode(chatData.extra.customJsonParam)
    if chatData.clientUpdateExtra then
      local tempList = string.split(chatData.clientUpdateExtra, "|")
      for k, v in ipairs(tempList) do
        table.insert(uids, v)
      end
    end
    local isFull = #uids >= UIMainChatUtil.GetFireworkMaxNum(extraJson)
    local isGot = DataCenter.LWFireworkGiftManager:IsThisGiftUuidGot(extraJson.uuid)
    local isViewed = DataCenter.LWFireworkGiftManager:IsThisChatViewed(extraJson.uuid)
    if not isGot and not isViewed and not isFull then
      info = BubbleTypeConfig[BubbleType.S0AllianceBoss]
    end
    DataCenter.LWFireworkGiftManager:SetNewFireworkGiftInChat(chatData)
  end
  if info then
    info.chatData = chatData
    return info
  end
end

function UIMainChatUtil.CheckTreasureFinish(roomData, chatData)
  local uuid
  if not string.IsNullOrEmpty(chatData.attachmentId) then
    local param = rapidjson.decode(chatData.attachmentId)
    if param and param.oname and param.shareType == WorldPointUIType.Treasure then
      uuid = param.uuid
    end
  end
  if uuid == nil then
    return false
  end
  if chatData.clientUpdateExtra == "complete" then
    return true
  end
  return false
end

function UIMainChatUtil.GetNewsMessage(roomData)
  local bubbleInfo, tempInfo
  local bubbleList = {}
  local msgs = roomData:GetUnblockedChatDatas()
  for i, chatData in pairs(msgs) do
    if chatData.seqId > roomData.readSeqId then
      tempInfo = UIMainChatUtil.GetBubble(chatData)
      if tempInfo then
        local isFinishedTreasure = false
        if tempInfo.type == BubbleType.Treasure then
          isFinishedTreasure = UIMainChatUtil.CheckTreasureFinish(roomData, chatData)
        end
        if not isFinishedTreasure then
          bubbleInfo = tempInfo
          bubbleInfo.chatData = chatData
          table.insert(bubbleList, bubbleInfo)
        end
      end
    end
  end
  if 0 < #bubbleList then
    UIMainChatUtil.GetSortBubbleList(bubbleList)
    return bubbleList[#bubbleList]
  end
end

function UIMainChatUtil.GetShowBubble(bubbleInfoList)
  table.sort(bubbleInfoList)
end

function UIMainChatUtil.GetFakeChatData(chatRoom, serverTime)
  local chatData = {}
  chatData.senderUid = chatRoom:GetPrivateUser()
  local userInfo = ChatManager2:GetInstance().User:getChatUserInfo(chatData.senderUid, false)
  chatData.senderName = userInfo.name
  chatData.serverTime = serverTime
  chatData.roomId = chatRoom.roomId
  chatData.group = chatRoom.group
  return chatData
end

function UIMainChatUtil.GetSortBubbleList(bubbleList)
  table.sort(bubbleList, function(a, b)
    if a.sort < b.sort then
      return true
    elseif a.sort == b.sort and a.chatData.serverTime < b.chatData.serverTime then
      return true
    end
  end)
  return bubbleList
end

function UIMainChatUtil.HandleNonChatBubbles(bubbleList)
  local bubbleInfo
  if ChatInterface.ServiceBubbleIsOpen() then
    local show = DataCenter.LWCustomerServiceManager:GetCustomerServiceRedPointData()
    if show then
      bubbleInfo = BubbleTypeConfig[BubbleType.CustomerService]
      table.insert(bubbleList, bubbleInfo)
    end
  end
  local canShow = DataCenter.LWNewsCenterManager:GetIsShowBubble()
  local clientUnlock = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.NewsCenter)
  if canShow and clientUnlock then
    local newsRed = DataCenter.LWNewsCenterManager:GetNewsRed()
    if newsRed then
      bubbleInfo = BubbleTypeConfig[BubbleType.NewsCenter]
      table.insert(bubbleList, bubbleInfo)
    end
  end
  local canShowCon = DataCenter.AllianceCongratulationDataManager:AllianceCongratulationBubbleState()
  if canShowCon then
    bubbleInfo = BubbleTypeConfig[BubbleType.NewThumpsUp]
    table.insert(bubbleList, bubbleInfo)
  end
  return bubbleList
end

function UIMainChatUtil.GetShowBubbleInfo()
  local result = {
    total = 0,
    private = 0,
    latestPrivateMsg = nil
  }
  local roomDatas = ChatInterface.getRoomMgr():GetRoomDatas()
  local latestPrivateMsgTime = 0
  local otherUser, isBlock, bubbleInfo
  local bubbleList = {}
  local num
  for _, roomData in ipairs(roomDatas) do
    num = roomData:getNewMsgNum()
    if 0 < num then
      bubbleInfo = nil
      if not roomData:GetNotDisturbing() then
        if roomData:isPrivateChat() then
          otherUser = roomData:GetPrivateUser()
          isBlock = ChatManager2:GetInstance().Restrict:isInRestrictList(otherUser, RestrictType.BLOCK)
          if otherUser and not isBlock and roomData.lastSeqId ~= -1 then
            if roomData.giftInfo then
              local iconPath = DataCenter.GiftSystemManager:GetGiftIconByGroup(roomData.giftInfo.itemId, roomData.giftInfo.num)
              if iconPath then
                bubbleInfo = DeepCopy(BubbleTypeConfig[BubbleType.Gift])
                bubbleInfo.iconPath = iconPath
                local chatData = UIMainChatUtil.GetFakeChatData(roomData, roomData.giftInfo.timestamp)
                chatData.seqId = roomData.giftInfo.seqId
                bubbleInfo.chatData = chatData
              end
            elseif latestPrivateMsgTime < roomData.filterLastTime then
              latestPrivateMsgTime = roomData.filterLastTime
              bubbleInfo = UIMainChatUtil.GetBubble(UIMainChatUtil.GetFakeChatData(roomData, roomData.filterLastTime))
            end
          end
        elseif roomData.group == ChatGroupType.GROUP_CUSTOM_GROUP then
          bubbleInfo, latestPrivateMsgTime = UIMainChatUtil.GetGroupChatBubble(roomData, latestPrivateMsgTime)
        elseif roomData.category == ChatRoomCategory.ALLIANCE or roomData.category == ChatRoomCategory.WORLD then
          bubbleInfo = UIMainChatUtil.GetNewsMessage(roomData)
        end
        if bubbleInfo then
          table.insert(bubbleList, bubbleInfo)
        end
      end
    end
    if roomData:GetAtSeqId() then
      local info = roomData:GetAtSeqInfo()
      bubbleInfo = DeepCopy(BubbleTypeConfig[BubbleType.At])
      bubbleInfo.chatData = {
        roomId = roomData.roomId,
        seqId = roomData:GetAtSeqId(),
        serverTime = info.time or UITimeManager:GetInstance():GetServerTime()
      }
      table.insert(bubbleList, bubbleInfo)
    end
  end
  bubbleList = UIMainChatUtil.HandleNonChatBubbles(bubbleList)
  bubbleList = UIMainChatUtil.GetSortBubbleList(bubbleList)
  if 0 >= table.count(bubbleList) then
    return result
  end
  result.bubbleInfo = bubbleList[#bubbleList]
  return result
end

function UIMainChatUtil.GetGroupChatBubble(roomData, latestPrivateMsgTime)
  local bubbleInfo
  if roomData:IsKickedRoom() then
    if latestPrivateMsgTime < roomData.lastMsgTime then
      latestPrivateMsgTime = roomData.lastMsgTime
      bubbleInfo = UIMainChatUtil.GetBubble({
        serverTime = roomData.lastMsgTime,
        roomId = roomData.roomId,
        group = ChatGroupType.GROUP_CUSTOM_GROUP
      })
    end
  else
    local lastMsg = roomData:getLastChatData()
    if lastMsg and latestPrivateMsgTime < lastMsg.serverTime and roomData.lastSeqId ~= -1 then
      bubbleInfo = UIMainChatUtil.GetBubble(lastMsg)
      if bubbleInfo then
        latestPrivateMsgTime = lastMsg.serverTime
      end
    end
  end
  return bubbleInfo, latestPrivateMsgTime
end

function UIMainChatUtil.GetNonChatBubble()
  local bubbleList = {}
  UIMainChatUtil.HandleNonChatBubbles(bubbleList)
  bubbleList = UIMainChatUtil.GetSortBubbleList(bubbleList)
  return bubbleList[#bubbleList]
end

function UIMainChatUtil.GetFireworkMaxNum(extraJson)
  local fireworkBoxMaxNum = 0
  if extraJson and extraJson.configId then
    local fireworkLineData = LocalController:instance():getLine(TableName.Firework, extraJson.configId)
    if fireworkLineData then
      local rewardListStr = fireworkLineData.reward
      local rewardList = string.split(rewardListStr, "|")
      extraJson.index = extraJson.index or 0
      local boxDataStr = rewardList[extraJson.index + 1]
      if boxDataStr then
        local boxDataList = string.split(boxDataStr, ";")
        if 3 <= #boxDataList then
          fireworkBoxMaxNum = tonumber(boxDataList[3])
        end
      end
    end
  end
  return fireworkBoxMaxNum
end

return UIMainChatUtil
