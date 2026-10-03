require("Chat.Constant.SendStateType")
require("Chat.Constant.ChatGroupType")
require("Chat.Constant.ChatMessageType")
require("Chat.Constant.PostType")
require("Chat.Constant.RestrictType")
require("Chat.Constant.ChatConstant")
require("Chat.WebMessage.Config.ChatMsgDefines")
require("Chat.Constant.ChatBIEnum")
require("UI.UIChatNewV2.Component.ChatItem.ChatItemPostConfig")
ChatInterface = require("Chat.ChatInterface")
ChatManager2 = require("Chat.ChatManager2")

function ChatPrint(fmt, ...)
end

function __ChatPostBI(evtName, evtParams)
  PostEventLog.Track(evtName, evtParams)
end
