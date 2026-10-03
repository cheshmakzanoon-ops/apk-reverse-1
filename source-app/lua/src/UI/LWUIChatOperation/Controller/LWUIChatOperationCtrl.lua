local LWUIChatOperationCtrl = BaseClass("LWUIChatOperationCtrl", UIBaseCtrl)
local typeSort = {
  [ChatOperationBtnType.Copy] = 1,
  [ChatOperationBtnType.Translate] = 2,
  [ChatOperationBtnType.Reply] = 3,
  [ChatOperationBtnType.Share] = 4,
  [ChatOperationBtnType.Reaction] = 5,
  [ChatOperationBtnType.Recall] = 6,
  [ChatOperationBtnType.Report] = 7
}
local operations = {
  {
    {
      type = ChatOperationBtnType.Copy,
      iconPath = "ChatWindow/zyf_tanchumianban_copy.png",
      text = "121069"
    }
  },
  {
    {
      type = ChatOperationBtnType.Translate,
      iconPath = "ChatWindow/zyf_tanchumianban_translate.png",
      text = "290042"
    },
    {
      type = ChatOperationBtnType.TranslateAll,
      iconPath = "ChatWindow/zyf_zhengyefanyi_icon.png",
      text = "full_page_translation"
    }
  },
  {
    {
      type = ChatOperationBtnType.Reply,
      iconPath = "ChatWindow/zyf_tanchumianban_report.png",
      text = "2900032"
    }
  },
  {
    {
      type = ChatOperationBtnType.Report,
      iconPath = "ChatWindow/zyf_tanchumianban_chat.png",
      text = "208251"
    }
  }
}
local selfOperations = {
  {
    {
      type = ChatOperationBtnType.Copy,
      iconPath = "ChatWindow/zyf_tanchumianban_copy.png",
      text = "121069"
    }
  },
  {
    {
      type = ChatOperationBtnType.Reply,
      iconPath = "ChatWindow/zyf_tanchumianban_report.png",
      text = "2900032"
    }
  }
}
local emojis = {
  {
    {
      type = ChatOperationBtnType.Up,
      iconPath = "ChatWindow/icon_great_light.png"
    }
  },
  {
    {
      type = ChatOperationBtnType.Emoji,
      iconPath = "ChatWindow/mjc_liaotiangonggao_sahua.png",
      IsHideEmoji = function(chatData)
        if chatData and chatData.post == PostType.EasterEggChat then
          return true
        end
        return false
      end
    }
  }
}
local shareData = {
  {
    type = ChatOperationBtnType.Share,
    iconPath = "ChatWindow/zyf_tanchumianban_reply.png",
    text = "im_btn_repost"
  }
}
local recallData = {
  {
    type = ChatOperationBtnType.Recall,
    iconPath = "ChatWindow/zyf_tanchumianban_chat.png",
    text = "btn_recall"
  }
}
local onlyReportData = {
  {
    type = ChatOperationBtnType.Report,
    iconPath = "ChatWindow/zyf_tanchumianban_chat.png",
    text = "208251"
  }
}
local deleteData = {
  {
    type = ChatOperationBtnType.Delete,
    iconPath = "ChatWindow/lrb_shanchu_chat.png",
    text = "100190"
  }
}
local translateData = {
  {
    type = ChatOperationBtnType.Translate,
    iconPath = "ChatWindow/zyf_tanchumianban_translate.png",
    text = "290042"
  }
}
local replyData = {
  {
    type = ChatOperationBtnType.Reply,
    iconPath = "ChatWindow/zyf_tanchumianban_report.png",
    text = "2900032"
  }
}
local reaction = {
  {
    type = ChatOperationBtnType.Reaction,
    iconPath = "ChatWindow/zyf_reaction_icon.png",
    text = "chat_reaction"
  }
}

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUIChatOperation)
end

local function GetMessage(chatData)
  if not chatData then
    return
  end
  local message = chatData:getSuperParsedResult()
  if message == nil then
    message = chatData:getMessageWithExtra(false)
    chatData:setSuperParsedResult(message)
  end
  return message
end

local function GetReactionEmojis(chatData)
  local emojiList = DeepCopy(chatData.emojis)
  for i = #emojiList, 1, -1 do
    if emojiList[i].emoji == EmojiCommentsType.HighFive then
      table.remove(emojiList, i)
    end
  end
  return emojiList
end

local function GetOperations(chatData, onlyEmoji, detailsData)
  local operationList = {}
  if chatData.post == PostType.MessageRecall or chatData.post == PostType.GiftGiving then
    table.insert(operationList, onlyReportData)
    return operationList
  elseif chatData.post == PostType.EasterEggChat then
    if chatData.chatScrollItemType == ActEasterEggChatScrollItemType.Post then
      table.insert(operationList, translateData)
      table.insert(operationList, onlyReportData)
    elseif chatData.chatScrollItemType == ActEasterEggChatScrollItemType.Comment then
      if chatData:isMyChat() then
        if ChatInterface.IsCanRecall(chatData.post) then
          table.insert(operationList, recallData)
        end
      else
        table.insert(operationList, translateData)
        table.insert(operationList, onlyReportData)
        table.insert(operationList, replyData)
      end
    end
    return operationList
  elseif chatData.post == PostType.NewsCenterLink then
    table.insert(operationList, replyData)
  elseif chatData.post == PostType.ALLIANCE_INVITE_SHARE_NEW then
    if not chatData:isMyChat() then
      local isSwitchOn = LuaEntry.DataConfig:CheckSwitch("alliance_inviteLinkNew_switch")
      if isSwitchOn then
        table.insert(operationList, translateData)
      end
      table.insert(operationList, onlyReportData)
    end
    return operationList
  end
  if onlyEmoji then
    if chatData.post == PostType.Chat_SendPhoto then
      table.insert(operationList, replyData)
    end
  elseif chatData:isMyChat() then
    operationList = DeepCopy(selfOperations)
    if chatData.post == PostType.Chat_Moment then
      table.insert(operationList, deleteData)
    end
  else
    local msg = GetMessage(chatData)
    local isSingleEmoji = ChatInterface.GetOldEmojiStr(msg)
    if isSingleEmoji then
      operationList = DeepCopy(selfOperations)
    else
      operationList = DeepCopy(operations)
    end
    if chatData.post == PostType.Chat_Moment and detailsData and detailsData.senderUid == LuaEntry.Player.uid then
      table.insert(operationList, deleteData)
    end
  end
  local room = ChatInterface.getRoomData(chatData.roomId)
  local emojiList = GetReactionEmojis(chatData)
  if room and not room:isPrivateChat() and emojiList and 0 < #emojiList and chatData.post ~= PostType.FriendsCirleBody and chatData.post ~= PostType.FriendsCirleBodyHasIcon and chatData.serverTime > 1767924000000 then
    table.insert(operationList, reaction)
  end
  if ChatInterface.IsCanShare(chatData.post) then
    table.insert(operationList, shareData)
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if ChatInterface.IsCanRecall(chatData.post) and chatData:isMyChat() and now - chatData.serverTime < 120000 then
    table.insert(operationList, recallData)
  end
  table.sort(operationList, function(a, b)
    local aType = typeSort[a[1].type] or math.huge
    local bType = typeSort[b[1].type] or math.huge
    return aType < bType
  end)
  return operationList
end

local function GetEmojis()
  return emojis
end

LWUIChatOperationCtrl.CloseSelf = CloseSelf
LWUIChatOperationCtrl.GetOperations = GetOperations
LWUIChatOperationCtrl.GetEmojis = GetEmojis
LWUIChatOperationCtrl.GetReactionEmojis = GetReactionEmojis
return LWUIChatOperationCtrl
