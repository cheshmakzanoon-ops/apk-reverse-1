local cmd = {}
local languages = {
  English = "Welcome\238\128\136\238\128\136 to the world\238\128\135\238\128\135\238\128\135 of technology\238\128\134\238\128\134!",
  ChineseTraditional = "\230\173\161\232\191\142\238\128\136\238\128\136\228\190\134\229\136\176\231\167\145\230\138\128\231\154\132\238\128\135\238\128\135\238\128\135\228\184\150\231\149\140\238\128\134\238\128\134\239\188\129",
  Spanish = "\194\161Bienvenido\238\128\136\238\128\136 al mundo\238\128\135\238\128\135\238\128\135 de la tecnolog\195\173a\238\128\134\238\128\134!",
  Japanese = "\227\131\134\227\130\175\227\131\142\227\131\173\227\130\184\227\131\188\238\128\136\238\128\136\227\129\174\228\184\150\231\149\140\227\129\184\227\130\136\227\129\134\227\129\147\227\129\157\238\128\135\238\128\135\238\128\135\239\188\129\238\128\134\238\128\134",
  German = "Willkommen\238\128\136\238\128\136 in der Welt\238\128\135\238\128\135\238\128\135 der Technologie\238\128\134\238\128\134!",
  French = "Bienvenue\238\128\136\238\128\136 dans le monde\238\128\135\238\128\135\238\128\135 de la technologie\238\128\134\238\128\134!",
  Arabic = "\217\133\216\177\216\173\216\168\217\139\216\167\238\128\136\238\128\136 \216\168\217\131\217\133 \217\129\217\138 \216\185\216\167\217\132\217\133\238\128\135\238\128\135\238\128\135 \216\167\217\132\216\170\217\131\217\134\217\136\217\132\217\136\216\172\217\138\216\167\238\128\134\238\128\134!",
  Italian = "Benvenuto\238\128\136\238\128\136 nel mondo\238\128\135\238\128\135\238\128\135 della tecnologia\238\128\134\238\128\134!",
  PortuguesePortugal = "Bem-vindo\238\128\136\238\128\136 ao mundo\238\128\135\238\128\135\238\128\135 da tecnologia\238\128\134\238\128\134!",
  Korean = "\234\184\176\236\136\160\236\157\152\238\128\136\238\128\136 \236\132\184\234\179\132\236\151\144 \236\152\164\236\139\160\238\128\135\238\128\135\238\128\135 \234\178\131\236\157\132\238\128\134\238\128\134 \237\153\152\236\152\129\237\149\169\235\139\136\235\139\164!",
  Russian = "\208\148\208\190\208\177\209\128\208\190 \208\191\208\190\208\182\208\176\208\187\208\190\208\178\208\176\209\130\209\140\238\128\136\238\128\136 \208\178 \208\188\208\184\209\128\238\128\135\238\128\135\238\128\135 \209\130\208\181\209\133\208\189\208\190\208\187\208\190\208\179\208\184\208\185\238\128\134\238\128\134!",
  Turkish = "Teknoloji\238\128\136\238\128\136 d\195\188nyas\196\177na ho\197\159geldiniz\238\128\135\238\128\135\238\128\135\238\128\134\238\128\134!",
  Thai = "\224\184\162\224\184\180\224\184\153\224\184\148\224\184\181\224\184\149\224\185\137\224\184\173\224\184\153\224\184\163\224\184\177\224\184\154\238\128\136\238\128\136 \224\184\170\224\184\185\224\185\136\224\185\130\224\184\165\224\184\129\238\128\135\238\128\135\238\128\135\224\185\129\224\184\171\224\185\136\224\184\135\224\185\128\224\184\151\224\184\132\224\185\130\224\184\153\224\185\130\224\184\165\224\184\162\224\184\181\238\128\134\238\128\134!",
  Hindi = "\224\164\164\224\164\149\224\164\168\224\165\128\224\164\149\224\165\128\238\128\136\238\128\136 \224\164\149\224\165\128 \224\164\166\224\165\129\224\164\168\224\164\191\224\164\175\224\164\190 \224\164\174\224\165\135\224\164\130\238\128\135\238\128\135\238\128\135 \224\164\134\224\164\170\224\164\149\224\164\190 \224\164\184\224\165\141\224\164\181\224\164\190\224\164\151\224\164\164\238\128\134\238\128\134 \224\164\185\224\165\136!",
  Dutch = "Welkom\238\128\136\238\128\136 in de wereld\238\128\135\238\128\135\238\128\135 van technologie\238\128\134\238\128\134!",
  Indonesian = "Selamat datang\238\128\136\238\128\136 di dunia\238\128\135\238\128\135\238\128\135 teknologi\238\128\134\238\128\134!",
  Polish = "Witamy\238\128\136\238\128\136 w \197\155wiecie\238\128\135\238\128\135\238\128\135 technologii\238\128\134\238\128\134!",
  Swedish = "V\195\164lkommen\238\128\136\238\128\136 till teknologi\238\128\135\238\128\135\238\128\135 v\195\164rlden\238\128\134\238\128\134!",
  Farsi = "\216\168\217\135 \216\175\217\134\219\140\216\167\219\140\238\128\136\238\128\136 \217\129\217\134\216\167\217\136\216\177\219\140\238\128\135\238\128\135\238\128\135 \216\174\217\136\216\180 \216\162\217\133\216\175\219\140\216\175\238\128\134\238\128\134!",
  Danish = "Velkommen\238\128\136\238\128\136 til teknologi\238\128\135\238\128\135\238\128\135 verden\238\128\134\238\128\134!",
  Norwegian = "Velkommen\238\128\136\238\128\136 til teknologi\238\128\135\238\128\135\238\128\135 verden\238\128\134\238\128\134!",
  Finnish = "Tervetuloa\238\128\136\238\128\136 teknologian\238\128\135\238\128\135\238\128\135 maailmaan\238\128\134\238\128\134!",
  Greek = "\206\154\206\177\206\187\207\142\207\130 \206\174\207\129\206\184\206\177\207\132\206\181\238\128\136\238\128\136 \207\131\207\132\206\191\206\189 \206\186\207\140\207\131\206\188\206\191\238\128\135\238\128\135\238\128\135 \207\132\206\183\207\130 \207\132\206\181\207\135\206\189\206\191\206\187\206\191\206\179\206\175\206\177\207\130\238\128\134\238\128\134!",
  Czech = "V\195\173tejte\238\128\136\238\128\136 ve sv\196\155t\196\155\238\128\135\238\128\135\238\128\135 technologie\238\128\134\238\128\134!",
  Hungarian = "\195\156dv\195\182z\195\182lj\195\188k\238\128\136\238\128\136 a technol\195\179gia\238\128\135\238\128\135\238\128\135 vil\195\161g\195\161ban\238\128\134\238\128\134!",
  Lithuanian = "Sveiki\238\128\136\238\128\136 atvyk\196\153 \196\175\238\128\135\238\128\135\238\128\135 technologij\197\179 pasaul\196\175\238\128\134\238\128\134!",
  Romanian = "Bun venit\238\128\136\238\128\136 \195\174n lumea\238\128\135\238\128\135\238\128\135 tehnologiei\238\128\134\238\128\134!",
  Ukrainian = "\208\155\208\176\209\129\208\186\208\176\208\178\208\190\238\128\136\238\128\136 \208\191\209\128\208\190\209\129\208\184\208\188\208\190 \208\178\238\128\135\238\128\135\238\128\135 \209\129\208\178\209\150\209\130 \209\130\208\181\209\133\208\189\208\190\208\187\208\190\208\179\209\150\208\185\238\128\134\238\128\134!",
  Vietnamese = "Ch\195\160o m\225\187\171ng\238\128\136\238\128\136 \196\145\225\186\191n v\225\187\155i th\225\186\191 gi\225\187\155i\238\128\135\238\128\135\238\128\135 c\195\180ng ngh\225\187\135\238\128\134\238\128\134!",
  ChineseSimplified = "\230\172\162\232\191\142\238\128\136\238\128\136\230\157\165\229\136\176\231\167\145\230\138\128\231\154\132\238\128\135\238\128\135\238\128\135\228\184\150\231\149\140\238\128\134\238\128\134\239\188\129"
}
local testUid = {
  1001243524000100,
  1001256123000100,
  1001264263000100,
  1001272660000100,
  1001286534000100,
  1001295436000100,
  1001303687000100,
  1001318279000100,
  1001322780000100,
  1001336726000100,
  1001349979000100,
  1001358152000100,
  1001360147000100,
  1001379476000100,
  1001386859000100,
  1001398352000100,
  1001401542000100,
  1001416474000100,
  1001429821000100,
  1001435332000100,
  1001443522000100,
  1001454695000100,
  1001468635000100,
  1001475858000100,
  1001480585000100,
  1001495162000100,
  1001500860000100,
  1001517938000100,
  1001524169000100,
  1001533046000100,
  1001547278000100,
  1001557902000100,
  1001566560000100,
  1001572977000100,
  1001583581000100,
  1001596044000100,
  1001600251000100,
  1001617264000100,
  1001626019000100,
  1001634775000100,
  1001642665000100,
  1001657668000100,
  1001663015000100,
  1001678380000100,
  1001680702000100
}

local function SendRoomTest(uidList)
  local roomId
  local roomTable = {}
  ChatCmd.cmdSendMsg = true
  for i = 1, #uidList do
    if uidList[i] ~= LuaEntry.Player.uid then
      TimerManager:GetInstance():DelayInvoke(function()
        roomId = "chattemp_privateRoomId" .. uidList[i]
        roomTable = {}
        roomTable.isProxy = 0
        roomTable.msg = tostring(i)
        roomTable.roomId = roomId
        roomTable.toUid = tostring(uidList[i])
        EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SEND_ROOM_MSG_COMMAND, roomTable)
        if i == #uidList then
          ChatCmd.cmdSendMsg = false
        end
      end, i)
    end
  end
end

local function SendMessage(msg, isProxy, postType, extraData)
  if not msg or string.IsNullOrEmpty(string.trim(msg)) then
    return
  end
  local currRoom = ChatManager2:GetInstance().Room:GetRoomDataByGroup(ChatGroupType.GROUP_COUNTRY)
  if not currRoom then
    UIUtil.ShowTipsId("335392")
    return
  end
  local levelLimit = LuaEntry.DataConfig:TryGetNum("chat_level", "k1")
  local mainLv = DataCenter.BuildManager.MainLv
  if levelLimit > mainLv then
    UIUtil.ShowTipsId(457538)
    return
  end
  local groupTemp = DataCenter.GroupChatSetTemplateManager:GetTempByGroupType(currRoom.group)
  if groupTemp and groupTemp.limit_lv > 0 and mainLv < groupTemp.limit_lv then
    local msg = Localization:GetString("channel_chat_limit_tips", groupTemp.limit_lv)
    UIUtil.ShowTips(msg)
    return
  end
  local isSendEmoji = extraData and extraData.isSendEmoji or false
  msg = ChatInterface.CheckMessage(msg)
  local str = ChatInterface.GetOldEmojiStr(msg)
  if not string.IsNullOrEmpty(str) then
    isSendEmoji = true
  end
  local cmdTbl = {
    roomId = currRoom.roomId,
    msg = msg,
    isProxy = isProxy
  }
  if postType then
    cmdTbl.extra = cmdTbl.extra or {}
    cmdTbl.extra.post = postType
  end
  local replyMsg = currRoom:GetCacheData().replyMsg or nil
  if replyMsg then
    local replySender = ChatInterface.getUserData(replyMsg.senderUid)
    cmdTbl.reply = {
      seqId = replyMsg.seqId,
      uid = replyMsg.senderUid,
      userName = replySender and replySender.userName or "",
      abbr = replySender and replySender.abbr or "",
      msg = replyMsg.msg
    }
  end
  local userInfo = currRoom:getPrivateOtherMember()
  if currRoom.group == ChatGroupType.GROUP_TMPRoom then
    if not userInfo then
      return
    end
    cmdTbl.toUid = userInfo.uid
  end
  ChatManager2:GetInstance():SyncMessageToServer(cmdTbl, cmdTbl.roomId)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SEND_ROOM_MSG_COMMAND, cmdTbl)
  EventManager:GetInstance():Broadcast(EventId.SetReplyChatMsg, nil)
end

local function SendLanMsg()
  local time = 0
  local count = 0
  ChatCmd.cmdSendLan = true
  for language, text in pairs(languages) do
    time = time + 1
    TimerManager:GetInstance():DelayInvoke(function()
      count = count + 1
      if count == table.count(languages) then
        ChatCmd.cmdSendLan = false
      end
      SendMessage(language .. ": " .. text, 0, PostType.Text_Normal, {isSendEmoji = false})
    end, time)
  end
end

function cmd.Execute(arr)
  local tag = arr[2]
  if tag == "sendMsg" then
    if not ChatCmd.cmdSendMsg then
      SendRoomTest(testUid)
      return "succeed"
    end
    return "processing"
  elseif tag == "disconnect" then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_CROSS_SERVER)
    return "succeed"
  elseif tag == "translate" then
    if not ChatCmd.cmdSendLan then
      SendLanMsg()
      return "succeed"
    end
    return "processing"
  end
end

function cmd.Help()
  local content = ""
  content = content .. "sendMsg    -- \229\143\145\233\128\129\229\164\154\228\184\170\231\167\129\232\129\138\229\175\185\232\175\157"
  content = content .. "disconnect -- \232\129\138\229\164\169\230\156\141\230\150\173\231\186\191\233\135\141\232\191\158"
  content = content .. "translate  -- \229\164\154\229\155\189\232\175\173\232\168\128\229\143\145\233\128\129\229\136\176\228\184\150\231\149\140\232\129\138\229\164\169"
  return content
end

return cmd
