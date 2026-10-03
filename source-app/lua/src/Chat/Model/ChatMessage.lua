local ChatMessage = BaseClass("ChatMessage")
local rapidjson = require("rapidjson")
local ChatMessageHelper = require("Chat.Other.ChatMessageHelper")
local Localization = CS.GameEntry.Localization

function ChatMessage:__init()
  self.appId = ""
  self.roomId = ""
  self.group = ""
  self.type = 0
  self.translateState = 0
  self.translateType = nil
  self.canRefreshTranslate = 0
  self._id = 0
  self.seqId = 1000
  self.senderUid = ""
  self.senderName = ""
  self.serverTime = 0
  self.sendLocalTime = 0
  self.post = 0
  self.msg = ""
  self.originalLang = ""
  self.translateMsg = ""
  self.translatedLang = ""
  self.sendState = SendStateType.OK
  self.attachmentId = ""
  self.media = ""
  self.msgMask = ""
  self.extra = nil
  self.extraJson = nil
  self.extraJsonData = nil
  self.picJson = nil
  self.picJsonData = nil
  self.attachmentMsg = nil
  self.fulltext = nil
  self.interactLike = 0
  self.interactDisLike = 0
  self.emoji_info = nil
  self.replyMsg = nil
  self.emojis = {}
  self.commentNum = 0
  self.self_comment = false
  self.friendsCircleLikeUids = {}
  self.msgId = 0
  self.clientNoSeqIDIndex = 0
  self.readOnly = 0
  self.isAtMe = nil
  self.cacheEmojis = {}
  self.transJson = nil
  self.timeline = nil
end

function ChatMessage:isMyChat()
  return not self:isSystemOrFestivalRedPack() and self.senderUid == ChatInterface.getPlayerUid()
end

function ChatMessage:isMySendChat()
  return self:isMyChat() and not self:isSystemChat() and not self:isRedPack()
end

function ChatMessage:isRedPack()
  return self.post == PostType.RedPackge
end

function ChatMessage:isSystemOrFestivalRedPack()
  if self:isRedPack() then
    local msgType = self:getChatMessageType()
    return msgType ~= ChatMessageType.COMMON
  else
    return false
  end
end

function ChatMessage:isShowTranslateBtn()
  if string.find(self.media, "photo") then
    return false
  end
  if self.post == PostType.Text_Normal then
    return true
  end
  return false
end

function ChatMessage:ignoreNewFlag()
  if self.senderUid == LuaEntry.Player.uid then
    return true
  end
  if self.post == PostType.Text_FightReport then
    local recv_msg_battle = Setting:GetBool("recv_battle_chat_" .. LuaEntry.Player.uid, true)
    if not recv_msg_battle then
      return true
    end
  end
  if self.post == PostType.Text_PointShare or self.post == PostType.Text_PointShare_Alliance or self.post == PostType.March then
    local recv_msg_pos = Setting:GetBool("recv_pos_chat_" .. LuaEntry.Player.uid, true)
    if not recv_msg_pos then
      return true
    end
  end
  return false
end

function ChatMessage:isSystemChat()
  return self.post ~= PostType.Text_Normal and self.post ~= PostType.RedPackge and self.post ~= PostType.Text_Audio_Message and self.post ~= PostType.Text_AllianceNotice
end

function ChatMessage:isVoiceChat()
  return self.post == PostType.VOICE
end

function ChatMessage:UpdateTransJson(transTable)
  if not transTable then
    return
  end
  self.transJson = transTable
end

function ChatMessage:setTranslationMsg(translateMsg)
  self.translateMsg = translateMsg
end

function ChatMessage:getTranslationMsg()
  return self.translateMsg
end

function ChatMessage:setOriginalLang(originalLang)
  self.originalLang = originalLang
end

function ChatMessage:setTranslatedLang(translatedLang)
  self.translatedLang = translatedLang
end

function ChatMessage:setSendState(sendingState)
  self.sendState = sendingState
end

function ChatMessage:setTranslateState(translateState)
  self.translateState = translateState
end

function ChatMessage:GetTranslateState()
  return self.translateState
end

function ChatMessage:IsTranslating()
  return self.translateState == 1
end

function ChatMessage:IsTranslatError()
  return self.translateState == -1
end

function ChatMessage:SetTranslateType(translateType)
  self.translateType = translateType
end

function ChatMessage:GetTranslateType()
  return self.translateType
end

function ChatMessage:SetCanRefreshTranslate(canRefreshTranslate)
  self.canRefreshTranslate = canRefreshTranslate
end

function ChatMessage:GetCanRefreshTranslate()
  return self.canRefreshTranslate
end

function ChatMessage:setSeqId(sequenceId)
  self.seqId = sequenceId
end

function ChatMessage:getSeqId()
  return self.seqId
end

function ChatMessage:getMsg()
  return self.msg
end

function ChatMessage:getExtra()
  return self.extra
end

function ChatMessage:getPost()
  return self.post
end

function ChatMessage:getSenderUid()
  return self.senderUid
end

function ChatMessage:getLikeNum()
  return self.interactLike
end

function ChatMessage:getDisLikeNum()
  return self.interactDisLike
end

function ChatMessage:getEmojiList()
  return self.emojis
end

function ChatMessage:changeEmojiState(emoji)
  if self:isPlayerFollowEmoji(emoji) then
    self:removeEmojiCount(emoji)
  else
    self:addEmojiCount(emoji)
  end
end

function ChatMessage:isPlayerFollowEmoji(emoji)
  if type(self.emojis) ~= "table" then
    return false
  end
  for _, v in pairs(self.emojis) do
    if v.emoji == emoji then
      return v.self == 1
    end
  end
  return false
end

function ChatMessage:cacheEmojiState(emoji)
  self.cacheEmojis = self.cacheEmojis or {}
  table.insert(self.cacheEmojis, {
    key = emoji,
    data = DeepCopy(self.emojis)
  })
end

function ChatMessage:addEmojiCount(emoji)
  if type(self.emojis) ~= "table" then
    return
  end
  for _, v in pairs(self.emojis) do
    if v.emoji == emoji and v.self ~= 1 then
      v.count = v.count + 1
      v.self = 1
      return
    end
  end
  table.insert(self.emojis, {
    emoji = emoji,
    count = 1,
    self = 1
  })
  if ChatInterface.getMoment():GetIsMomentBody(self.post) then
    local isInsert = true
    local playerUid = LuaEntry.Player.uid
    for i = 1, #self.friendsCircleLikeUids do
      if self.friendsCircleLikeUids[i] == playerUid then
        isInsert = false
      end
    end
    if isInsert then
      table.insert(self.friendsCircleLikeUids, LuaEntry.Player.uid)
    end
  end
  table.sort(self.emojis, function(a, b)
    return a.emoji < b.emoji
  end)
end

function ChatMessage:getEmojiCount(emoji)
  local count = 0
  if type(self.emojis) ~= "table" then
    return count
  end
  for i, v in pairs(self.emojis) do
    if v.emoji == emoji then
      count = v.count or 0
    end
  end
  return count
end

function ChatMessage:removeEmojiCount(emoji)
  if type(self.emojis) ~= "table" then
    return
  end
  if ChatInterface.getMoment():GetIsMomentBody(self.post) then
    local playerUid = LuaEntry.Player.uid
    for i = #self.friendsCircleLikeUids, 1, -1 do
      if self.friendsCircleLikeUids[i] == playerUid then
        table.remove(self.friendsCircleLikeUids, i)
      end
    end
  end
  for i, v in pairs(self.emojis) do
    if v.emoji == emoji and v.self == 1 then
      if 1 < v.count then
        v.count = v.count - 1
        v.self = 0
      else
        table.remove(self.emojis, i)
      end
      return
    end
  end
end

function ChatMessage:SetClientNoSeqIDIndex(clientIndex)
  self.clientNoSeqIDIndex = clientIndex
end

function ChatMessage:GetClientNoSeqIDIndex()
  return self.clientNoSeqIDIndex
end

function ChatMessage:getChatMessageType()
  local msgType = ChatMessageType.COMMON
  if self.post == PostType.RedPackge then
    local arr = string.split(self.attachmentId, "|")
    if #arr == 3 then
      msgType = checknumber(arr[3])
    end
  elseif self.post == PostType.Text_Use_Item_Share or self.post == PostType.Text_AreaMsg or self.post == PostType.Text_FBAllianceGift_Share then
    msgType = ChatMessageType.System
  end
  return msgType
end

function ChatMessage:getSenderInfo()
  local userInfo = ChatManager2:GetInstance().User:getChatUserInfo(self.senderUid, false)
  return userInfo
end

function ChatMessage:getSenderName()
  local name = ""
  if self:isFromAI() then
    local theCharacter = self:tryGetAICharacter()
    if theCharacter ~= nil then
      return theCharacter:GetName()
    end
  end
  local msgType = self:getChatMessageType()
  if msgType == ChatMessageType.COMMON then
    local userInfo = self:getSenderInfo()
    if userInfo then
      name = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.senderUid, userInfo.userName)
    end
  elseif msgType == ChatMessageType.SYSTEM then
    name = ChatInterface.getString("310002")
  elseif msgType == ChatMessageType.FESTIVAL then
    name = ChatInterface.getString("100347")
  end
  return name
end

function ChatMessage:getSenderNameWithAlliance()
  local msgType = self:getChatMessageType()
  if msgType == ChatMessageType.COMMON and self.group ~= ChatGroupType.GROUP_ALLIANCE then
    local userInfo = self:getSenderInfo()
    if userInfo and not string.IsNullOrEmpty(userInfo.allianceSimpleName) then
      return string.format("[%s]%s", userInfo.allianceSimpleName, self:getSenderName())
    end
  end
  return self:getSenderName()
end

function ChatMessage:getServerTime()
  return self.serverTime
end

function ChatMessage:getCreateTime()
  local t = self:getServerTime() / 1000
  return math.ceil(t)
end

function ChatMessage:NextSeqId(seq)
  local step = 1.0E-4
  local nextSeq = seq + step
  if math.floor(nextSeq) > math.floor(seq) then
    return nil
  end
  return nextSeq
end

function ChatMessage:GetIsBlockMessages()
  return self.seqId % 1 ~= 0 or self.seqId == 0
end

function ChatMessage:onParseServerData(tabData)
  if type(tabData) ~= "table" then
    return
  end
  self.roomId = tabData.roomId
  self.group = tabData.group
  self.appId = tabData.appId
  self.post = 0
  if tabData.msg then
    self.msg = tabData.msg
  end
  if tabData.auth then
    self.auth = tabData.auth
  end
  if tabData.timeline then
    self.timeline = tabData.timeline
    self.auth = tabData.timeline.auth
  end
  if tabData.commentNum then
    self.commentNum = tabData.commentNum
  end
  if tabData.self_comment then
    self.self_comment = tabData.self_comment
  end
  if tabData.bucketType then
    self.bucket = tabData.bucketType
  end
  if tabData.friendsCircleLikeUids then
    self.friendsCircleLikeUids = tabData.friendsCircleLikeUids
  end
  if tabData.reply then
    self.replyMsg = tabData.reply
  end
  if tabData.senderLevel ~= nil or tabData.mainBuildingLevel ~= nil then
    self.senderLevel = tabData.senderLevel or tabData.mainBuildingLevel
  end
  if tabData.interact ~= nil then
    self.emojis = {}
    if tabData.emoji and 0 < #tabData.emoji then
      for i = 1, #tabData.emoji do
        if tabData.emoji[i].count and 0 < tabData.emoji[i].count and tabData.emoji[i].emoji then
          table.insert(self.emojis, tabData.emoji[i])
        end
      end
      table.sort(self.emojis, function(a, b)
        return a.emoji < b.emoji
      end)
    end
    self.interactLike = tabData.interact.like
    self.interactDisLike = tabData.interact.dislike
  end
  if tabData.emoFeedback ~= nil then
    local emoji_info = {}
    for emoji_id, value in pairs(tabData.emoFeedback) do
      local count = tonumber(value)
      if 0 < count then
        table.insert(emoji_info, {
          emoji_id = tonumber(emoji_id),
          count = count
        })
      end
    end
    self.emoji_info = emoji_info
  end
  ChatMessageHelper:onParseExtraData(self, tabData.extra)
  if tabData.seqId then
    self.seqId = tabData.seqId
    if self.seqId == 0 then
      self.clientNoSeqIDIndex = ChatManager2:GetInstance().Room:GetSendingIndex()
    end
  end
  if tabData.extra then
    if self.extra and self.extra.attachmentId and (tabData.extra.post == PostType.TorchRelayCheer or tabData.extra.post == PostType.STAGE_FEATURE_CHAPTER or tabData.extra.post == PostType.Text_MemberJoin or tabData.extra.post == PostType.Text_MemberQuit or tabData.extra.post == PostType.FrontBreakSunday) then
      local jsonObj = rapidjson.decode(self.extra.attachmentId)
      self.attachmentIdJsonObj = jsonObj
    end
    if tabData.extra.extraJson then
      self.extraJson = tabData.extra.extraJson
      if not string.IsNullOrEmpty(self.extraJson) then
        self.extraJsonData = rapidjson.decode(self.extraJson)
      end
    end
    if tabData.extra.picJson then
      self.picJson = tabData.extra.picJson
      if not string.IsNullOrEmpty(self.picJson) then
        self.picJsonData = rapidjson.decode(self.picJson)
      end
    end
  end
  if ChatInterface.getMoment():GetIsMomentData(tabData.post) then
    self.post = tabData.post
  end
  if tabData.sendState then
    self.sendState = tabData.sendState
  end
  if tabData.msgId then
    self.msgId = tabData.msgId
  end
  self.senderUid = tabData.sender
  local sendTime = tabData.sendTime
  if sendTime then
    if string.len(sendTime) == 13 then
      self.sendLocalTime = math.floor(sendTime / 1000)
    else
      self.sendLocalTime = sendTime
    end
  end
  if tabData.serverTime then
    if isInteger(tabData.serverTime) and string.len(tabData.serverTime) == 10 then
      self.serverTime = tabData.serverTime * 1000
    else
      self.serverTime = tabData.serverTime
    end
  end
  if tabData.clientUpdateExtra then
    self.clientUpdateExtra = tabData.clientUpdateExtra
  end
  if tabData.originalLang then
    if string.IsNullOrEmpty(tabData.originalLang) then
      local t = 0
    end
    self.originalLang = tabData.originalLang
  end
  if tabData.translationMsg then
    self.translateMsg = tabData.translationMsg
  else
    ChatManager2:GetInstance().Translate:UpdateTranslateInfo(self)
  end
  if tabData.type and 0 < checknumber(tabData.type) and (tostring(self.group) == ChatGroupType.GROUP_CUSTOM or self.group == ChatGroupType.GROUP_CUSTOM_GROUP) and tabData.type ~= PostType.Alliance_War and tabData.type ~= PostType.GHOST_RECON_TASK_TEAM and tabData.type ~= PostType.HELP_STOP_FIRE_PERSION and tabData.type ~= PostType.UseMasterySkill and tabData.type ~= PostType.ZOMBIE_ATTACK_CITY_ASSISTANCE_DEFEND and tabData.type ~= PostType.GHOST_RECON_REMIND_LEADER and tabData.type ~= PostType.GiftGiving and tabData.type ~= PostType.StageFeatureHelpInvite and tabData.type ~= PostType.StageFeatureHelpAccept and tabData.type ~= PostType.StageFeatureComplete and tabData.type ~= PostType.SKILL_ADD_MUMMY_ARMY and tabData.type ~= PostType.TrainVipInvite and tabData.type ~= PostType.Alliance_Feature_Invite and tabData.type ~= PostType.GroupChatInviter and tabData.type ~= PostType.Season_BiuBiuInvite and tabData.type ~= PostType.Season_LittleGame_Invite and tabData.type ~= PostType.NewsCenterLink then
    self.type = tabData.type
    self.post = PostType.Text_ChatRoomSystemMsg
  end
  if tabData.msg_mask then
    self.msgMask = tabData.msg_mask
  elseif tabData.msgMask then
    self.msgMask = tabData.msgMask
  else
    self.msgMask = ChatManager2:GetInstance().Filter:filterSensitiveWord(self.msg)
  end
  if tabData.readOnly then
    self.readOnly = tabData.readOnly
  end
  self:InitDiceRolled()
  if self.extra and self.extra.atPlayers and not tabData.isLocal then
    local atPlayers = self.extra.atPlayers
    local atAllName = Localization:GetString("at_all_text1")
    local isAtAll
    for _, v in ipairs(atPlayers) do
      if v.uid == "atAll" then
        v.name = atAllName
        isAtAll = true
        break
      end
    end
    if isAtAll then
      self.msg = string.gsub(self.msg, ATTag.atAllTag, atAllName)
      self.msgMask = string.gsub(self.msgMask, ATTag.atAllTag, atAllName)
    end
  end
end

function ChatMessage:onParseFakeData(chatTabData)
  if type(chatTabData) ~= "table" then
    return
  end
  self.roomId = chatTabData.roomId
  self.group = chatTabData.group
  self.post = chatTabData.post
  if chatTabData.msg then
    self.msg = chatTabData.msg
  end
  self.extra = chatTabData.extra or {}
  local roomMgr = ChatManager2:GetInstance().Room
  local playerUid = ChatInterface.getPlayerUid()
  if string.IsNullOrEmpty(playerUid) then
    Logger.LogError("\232\129\138\229\164\169\229\143\145\233\128\129\229\129\135\230\182\136\230\129\175\230\151\182\232\142\183\229\143\150 \228\184\170\228\186\186uid \228\184\186\231\169\186\239\188\129")
  end
  self.senderUid = playerUid
  local data = UIUtil.GetPlayerInfoShowByUid(playerUid)
  if not data then
    Logger.LogError("\232\129\138\229\164\169\229\143\145\233\128\129\229\129\135\230\182\136\230\129\175\230\151\182\232\142\183\229\143\150 \228\184\170\228\186\186\228\191\161\230\129\175 \228\184\186\231\169\186\239\188\129")
  end
  self.senderLevel = data.level
  self.extra.post = self.post
  self.extra.senderLevel = self.senderLevel
  self.seqId = 0
  self.clientNoSeqIDIndex = roomMgr:GetSendingIndex()
  self.sendLocalTime = roomMgr:getChatServerTime() * 1000
  self.serverTime = roomMgr:getChatServerTime() * 1000
  if self.msg then
    self.msgMask = ChatManager2:GetInstance().Filter:filterSensitiveWord(self.msg)
  end
end

function ChatMessage:isSystemMsg()
  return self.post == PostType.Text_ChatRoomSystemMsg
end

function ChatMessage:getMaskMsg()
  if self:IsLWEmoji() then
    return "[emoji]"
  end
  if not string.IsNullOrEmpty(self.msgMask) or self:isFromAI() then
  else
    self.msgMask = ChatManager2:GetInstance().Filter:filterSensitiveWord(self.msg)
  end
  return self.msgMask
end

function ChatMessage:IsLWEmoji()
  if string.IsNullOrEmpty(self.msg) then
    return false
  end
  if string.startswith(self.msg, "<lwEmoji:") and string.endswith(self.msg, ":>") then
    return not self.extra.isNormalMsg
  else
    return false
  end
end

function ChatMessage:getMessageWithExtra(isFullMsg)
  if isFullMsg ~= false then
    isFullMsg = true
  end
  return ChatMessageHelper:getMessageWithExtra(self, isFullMsg)
end

function ChatMessage:getMessageParam()
  return ChatMessageHelper.getShowParam(self)
end

function ChatMessage:CheckSYS()
  if self.post == PostType.Text_AllianceMemberInOut then
    return true
  end
  return false
end

function ChatMessage:getMediaInfo(key)
  if string.IsNullOrEmpty(self.media) then
    return ""
  end
  local mediaStr = ""
  local mediaJson = rapidjson.decode(self.media)
  if mediaJson[key] then
    mediaStr = mediaJson[key]
  end
  return mediaStr
end

function ChatMessage:canSkip()
  local skip = ChatInterface.isCanSkip(self.post)
  if not skip and self.post == PostType.ChatGPT_Assistant and self.extra ~= nil and self.extra.customJsonParam ~= nil then
    local extraJson = rapidjson.decode(self.extra.customJsonParam)
    if extraJson == nil or extraJson.room_id == nil then
      return true
    end
    local theRoomData = DataCenter.LWChatAIManager:GetChatRoomConfigById(extraJson.room_id)
    if theRoomData == nil then
      return true
    end
    skip = not theRoomData:SwitchOn()
  end
  return skip
end

function ChatMessage:CheckCanShow()
  local canShow = true
  if canShow == true and self.readOnly and self.readOnly == 1 and self.senderUid ~= LuaEntry.Player.uid then
    canShow = false
  end
  return canShow
end

function ChatMessage:isFromAI()
  return self.post == PostType.ChatGPT_Assistant or self.post == PostType.ChatGPT_Assistant_Private
end

function ChatMessage:isEmojiOnAndFromAI()
  local isFromAI = self.post == PostType.ChatGPT_Assistant or self.post == PostType.ChatGPT_Assistant_Private
  if isFromAI and self.extra ~= nil and self.extra.customJsonParam ~= nil then
    local isEmojiOn = string.find(self.extra.customJsonParam, "emojiOn", 1, true)
    return isEmojiOn ~= nil and 0 < isEmojiOn
  end
  return false
end

function ChatMessage:tryGetAICharacter()
  if self.theCharacterData ~= nil then
    return self.theCharacterData
  end
  if self.post == PostType.ChatGPT_Assistant_Private then
    local character_id = string.match(self.roomId, "custom_ai_(%d+)_")
    if character_id ~= nil and character_id ~= "" then
      local theCharacterData = DataCenter.LWChatAIManager:GetChatAICharacterData(character_id)
      self.theCharacterData = theCharacterData
      return theCharacterData
    end
  elseif self.post == PostType.ChatGPT_Assistant and self.extra ~= nil and self.extra.customJsonParam ~= nil then
    local jsonObj = rapidjson.decode(self.extra.customJsonParam)
    if jsonObj ~= nil then
      local theCharacterData = DataCenter.LWChatAIManager:GetChatAICharacterData(jsonObj.character_id)
      self.theCharacterData = theCharacterData
      return theCharacterData
    end
  end
  return nil
end

function ChatMessage:getSuperParsedResult()
  return self.mSuperParsedResult
end

function ChatMessage:setSuperParsedResult(value)
  self.mSuperParsedResult = value
end

function ChatMessage:getRoomId()
  return self.roomId
end

function ChatMessage:IsFakePhotoChatData()
  return self:GetIsBlockMessages() and self:GetClientNoSeqIDIndex() ~= 0 and self:getPost() == PostType.Chat_SendPhoto and self:getMsg() == ChatFakePhotoMsg
end

function ChatMessage:SetDiceRollState(isFinished)
  if self.post ~= PostType.Chat_Stickers then
    Logger.LogError("\229\189\147\229\137\141ChatData\231\154\132PostType\228\184\141\230\152\175Sticker\239\188\140\228\189\134\230\152\175\229\141\180\232\176\131\231\148\168\228\186\134\229\189\147\229\137\141\229\135\189\230\149\176\227\128\130")
  end
  self.extra.isDiceRolled = isFinished
end

function ChatMessage:InitDiceRolled()
  if self.post == PostType.Chat_Stickers and self.msg then
    local strList = string.split(self.msg, ":")
    if tonumber(strList[2]) == 5 then
      self.extra.isDiceRolled = true
    end
  end
end

function ChatMessage:GetHaveDiceRolled()
  return self.extra.isDiceRolled
end

function ChatMessage:GetDiceResult()
  if self.msg then
    local strList = string.split(self.msg, ":")
    return strList[3]
  end
  return nil
end

function ChatMessage:GetIsTextFolding()
  return self.isTextFolding
end

function ChatMessage:SetIsTextFolding(state)
  self.isTextFolding = state
end

function ChatMessage:GetEmojiLikeData()
  for _, v in pairs(self.emojis) do
    if v.emoji == EmojiCommentsType.Up then
      return v
    end
  end
end

function ChatMessage:GetNoticePicData()
  local smallHeight = 0
  local smallWidth = 0
  local bigHeight = 0
  local bigWidth = 0
  local noticePicVer = 0
  local picSenderUid = ""
  local isHavePicVer = false
  if self.extra then
    if self.extra.noticePicVer then
      noticePicVer = self.extra.noticePicVer
    end
    if self.extra.smallHeight then
      smallHeight = self.extra.smallHeight
    end
    if self.extra.smallWidth then
      smallWidth = self.extra.smallWidth
    end
    if self.extra.bigHeight then
      bigHeight = self.extra.bigHeight
    end
    if self.extra.bigWidth then
      bigWidth = self.extra.bigWidth
    end
    if self.extra.picSenderUid then
      picSenderUid = self.extra.picSenderUid
    end
    isHavePicVer = 0 < noticePicVer and not string.IsNullOrEmpty(picSenderUid)
  end
  return isHavePicVer, noticePicVer, picSenderUid, smallHeight, smallWidth, bigHeight, bigWidth
end

function ChatMessage:IsNoticeHavePicListData()
  local haveOldPicData = false
  if self.extra then
    local noticePicVer = self.extra.noticePicVer
    if noticePicVer and 0 < noticePicVer then
      haveOldPicData = true
    end
  end
  local havePicData = self.picJsonData ~= nil
  return haveOldPicData or havePicData
end

function ChatMessage:GetNoticePicListData()
  local dataList
  if self.picJsonData then
    dataList = self.picJsonData
  elseif self.extra and self.extra.noticePicVer and self.extra.noticePicVer > 0 then
    local data = {
      [AlNoticePicDataType.SenderUid] = self.extra.picSenderUid,
      [AlNoticePicDataType.PicVer] = self.extra.noticePicVer,
      [AlNoticePicDataType.SmallWidth] = self.extra.smallWidth,
      [AlNoticePicDataType.SmallHeight] = self.extra.smallHeight,
      [AlNoticePicDataType.BigWidth] = self.extra.bigWidth,
      [AlNoticePicDataType.BigHeight] = self.extra.bigHeight
    }
    dataList = {
      [1] = data
    }
  end
  return dataList
end

function ChatMessage:IsNoticeEdited()
  local isEdited = false
  if self.extra and self.extra.currEdited == 1 then
    isEdited = true
  end
  return isEdited
end

function ChatMessage:IsMessageAtMe()
  if self.senderUid == LuaEntry.Player.uid then
    return false
  end
  if self.isAtMe == nil then
    local atUids = self.extra and self.extra.atUids
    if atUids then
      if self.extra.atAll then
        self.isAtMe = true
      else
        for _, v in pairs(atUids) do
          if v == LuaEntry.Player.uid then
            self.isAtMe = true
            break
          end
        end
      end
    end
  end
  return self.isAtMe == true
end

local function byte_to_char_pos(str, byte_pos)
  local len = 0
  local i = 1
  while byte_pos >= i do
    local c = string.byte(str, i)
    if 0 <= c and c <= 127 then
      i = i + 1
    elseif 192 <= c and c < 224 then
      i = i + 2
    elseif 224 <= c and c < 240 then
      i = i + 3
    elseif 240 <= c and c < 248 then
      i = i + 4
    else
      i = i + 1
    end
    len = len + 1
  end
  return len
end

function ChatMessage:GetAtInfoMatches()
  if self.atMatches then
    return self.atMatches
  end
  local atPlayers = self.extra.atPlayers
  if atPlayers ~= nil then
    local matches = {}
    local dialog = self:getMessageWithExtra(false)
    for _, v in ipairs(atPlayers) do
      local start = 1
      local atStr = "@" .. v.name
      atStr = ChatInterface.CheckMessage(atStr)
      while true do
        local s, e = string.find(dialog, atStr, start, true)
        if not s then
          break
        end
        local cs = byte_to_char_pos(dialog, s)
        local ce = byte_to_char_pos(dialog, e)
        table.insert(matches, cs - 1)
        table.insert(matches, ce - 1)
        table.insert(matches, v.uid)
        start = e + 1
      end
    end
    self.atMatches = matches
  end
  return self.atMatches
end

function ChatMessage:ChangeInviteState(state)
  if self.extra and self.extra.inviteCode then
    self.extra.inviteCode = state
  end
end

function ChatMessage:IsSelfComment()
  return self.self_comment
end

function ChatMessage:GetNeedTranslateText()
  local chatData = self
  local msg = chatData.msg
  if chatData.post == PostType.GiftGiving then
    local extraJson
    if type(chatData.extra.customJsonParam) == "string" then
      extraJson = rapidjson.decode(chatData.extra.customJsonParam)
    elseif type(chatData.extra.customJsonParam) == "table" then
      extraJson = chatData.extra.customJsonParam
    end
    if not string.IsNullOrEmpty(extraJson.context) then
      msg = extraJson.context
    end
  elseif chatData.post == PostType.Text_AllianceNotice then
    if self.extraJsonData then
      local showNotice, noticeAddExtraJsonData = ChatInterface.GetShowNoticeAndAddTempData(chatData:getMsg(), chatData.extraJsonData, true)
      msg = showNotice
    end
  elseif chatData.post == PostType.Season_BiuBiuInvite or chatData.post == PostType.Season_LittleGame_Invite then
    if chatData.extra.attachmentId ~= nil then
      local jsonObj = rapidjson.decode(chatData.extra.attachmentId)
      msg = jsonObj.speak
    end
  elseif chatData.post == PostType.ALLIANCE_INVITE_SHARE_NEW then
    local isSwitchOn = LuaEntry.DataConfig:CheckSwitch("alliance_inviteLinkNew_switch")
    if not string.IsNullOrEmpty(chatData.extra.introductionEx) and isSwitchOn then
      msg = chatData.extra.introductionEx
    else
      msg = ""
    end
  end
  return msg
end

function ChatMessage:GetDeleteTimestamp()
  local extra = self:getExtra()
  if extra == nil then
    return 0
  end
  if type(extra.countdown_timestamp) == "string" and not string.IsNullOrEmpty(extra.countdown_timestamp) then
    return tonumber(extra.countdown_timestamp)
  elseif type(extra.countdown_timestamp) == "number" then
    return extra.countdown_timestamp
  end
  return 0
end

function ChatMessage:UpdateAuth(auth)
  self.auth = auth
end

function ChatMessage:GetVisibility()
  if self.auth then
    for key, value in pairs(self.auth) do
      if value == 1 then
        return key
      end
    end
  end
end

function ChatMessage:UpdateMomentMessage(data)
  local isUpdate
  if data.auth then
    self.auth = data.auth
    isUpdate = true
  end
  if data.commentNum then
    isUpdate = true
    self.commentNum = data.commentNum
  end
  if data.self_comment then
    isUpdate = true
    self.self_comment = data.self_comment
  end
  if isUpdate then
    EventManager:GetInstance():Broadcast(ChatEventEnum.UPDATE_USER_MSG, self)
  end
end

return ChatMessage
