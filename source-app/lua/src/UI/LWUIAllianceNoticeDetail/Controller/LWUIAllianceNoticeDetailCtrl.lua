local LWUIAllianceNoticeDetailCtrl = BaseClass("LWUIAllianceNoticeDetailCtrl", UIBaseCtrl)
local AlPostEventLog = require("DataCenter.AllianceData.AlliancePostEventLog")

local function CloseSelf(self)
  if not ChatInterface.GetMobilSupportMultiple() then
    GoToUtil.OpenChatView(true, {anim = false}, {
      roomId = ChatManager2:GetInstance().Room:GenAllianceNoticeRoom()
    })
  end
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUIAllianceNoticeDetail)
end

function LWUIAllianceNoticeDetailCtrl:SendMessage(msg)
  if not msg or string.IsNullOrEmpty(string.trim(msg)) then
    return
  end
  local currRoom = self.view:GetSelectedRoom()
  msg = ChatInterface.CheckMessage(msg)
  local cmdTbl = {
    roomId = currRoom.roomId,
    msg = msg,
    extra = {
      noticeUid = self.view.noticeData.uid
    }
  }
  local replyMsg = currRoom and currRoom:GetCacheData().replyMsg or nil
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
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SEND_ROOM_MSG_COMMAND, cmdTbl)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_CLOSE_POP_UP_KEYBOARD)
  EventManager:GetInstance():Broadcast(EventId.SetReplyChatMsg, nil)
  AlPostEventLog.PostEventLog_Notice_Action(AlPostEventLog.NoticeAction.Reply)
end

function LWUIAllianceNoticeDetailCtrl:OnCustomKeyCodeEscape()
  if self.view then
    self.view:BlackWebView()
  else
    self:CloseSelf()
  end
end

LWUIAllianceNoticeDetailCtrl.CloseSelf = CloseSelf
return LWUIAllianceNoticeDetailCtrl
