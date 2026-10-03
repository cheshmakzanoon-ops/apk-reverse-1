local LWUIAllianceNoticeDetailView = BaseClass("LWUIAllianceNoticeDetailView", UIBaseView)
local UIChatViewBottom = require("UI.UIChatNewV2.Component.UIChatViewBottom_v2")
local UIChatViewMiddle = require("UI.LWUIAllianceNoticeDetail.Component.UIChatViewNoticeMiddle")
local UIWebViewContent = require("UI.LWUIAllianceNoticeDetail.Component.UIWebViewContent")
local base = UIBaseView
local compBook = {
  {
    path = "root/middle",
    name = "middle",
    type = UIChatViewMiddle
  },
  {
    path = "root/bottom",
    name = "bottom",
    type = UIChatViewBottom
  },
  {
    path = "root",
    name = "root",
    type = UIBaseContainer
  },
  {
    path = "webViewContent",
    name = "webViewContent",
    type = UIWebViewContent
  }
}

function LWUIAllianceNoticeDetailView:OnCreate()
  base.OnCreate(self)
  self.ctrl.view = self
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

function LWUIAllianceNoticeDetailView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIAllianceNoticeDetailView:OnEnable()
  base.OnEnable(self)
end

function LWUIAllianceNoticeDetailView:OnDisable()
  base.OnDisable(self)
end

function LWUIAllianceNoticeDetailView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_LOGIN_SUCCESS, self.OnChatLoginJoinNoticeRoom)
  self:AddUIListener(EventId.CHAT_NEWSCENTER_NOTICE_DETAIL_VIEW_OPENURL, self.OnOpenURL)
  self:AddUIListener(EventId.CHAT_NEWSCENTER_NOTICE_DETAIL_OPENURL, self.OnOpenURL)
  self:AddUIListener(EventId.CHAT_NEWSCENTER_SHARE, self.OnCloseNewsCenterURL)
end

function LWUIAllianceNoticeDetailView:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_LOGIN_SUCCESS, self.OnChatLoginJoinNoticeRoom)
  self:RemoveUIListener(EventId.CHAT_NEWSCENTER_NOTICE_DETAIL_VIEW_OPENURL, self.OnOpenURL)
  self:RemoveUIListener(EventId.CHAT_NEWSCENTER_NOTICE_DETAIL_OPENURL, self.OnOpenURL)
  self:RemoveUIListener(EventId.CHAT_NEWSCENTER_SHARE, self.OnCloseNewsCenterURL)
  base.OnRemoveListener(self)
end

function LWUIAllianceNoticeDetailView:GetSelectedRoom()
  return self.room
end

function LWUIAllianceNoticeDetailView:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function LWUIAllianceNoticeDetailView:OnClickBack()
  local noticeRoomId = ChatInterface.getRoomMgr():GetNoticeId(self.noticeData.uid)
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.RoomLeave, noticeRoomId, self.room and self.room.group or nil)
  if self.isTemp then
    UIManager.Instance:DestroyWindow(UIWindowNames.LWUIAllianceNoticeDetail)
    return
  end
  self.ctrl:CloseSelf()
end

function LWUIAllianceNoticeDetailView:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function LWUIAllianceNoticeDetailView:ReInit()
  self.middle:UpdateNoticeData(self.noticeData, self.root)
  if self.noticeData and self.noticeData.voteData then
    SFSNetwork.SendMessage(MsgDefines.VoteList, self.noticeData.voteData.voteId, self.noticeData.uid)
  end
  self.bottom:ResetInputAndReply(self.room)
  self.bottom:SetInputMsgText(2900060)
  self.bottom:SetInputCompsActive(true)
  self.webViewContent:InitData(function()
    self.bottom:SetInputCompsActive(false)
  end, function()
    self.bottom:SetInputCompsActive(true)
  end, NewsCenterOpenType.NoticeDetail)
end

function LWUIAllianceNoticeDetailView:OnOpenURL(data)
  self.webViewContent:OnOpenURL(data)
end

function LWUIAllianceNoticeDetailView:OnCloseNewsCenterURL()
  self.webViewContent:CloseWeb()
end

function LWUIAllianceNoticeDetailView:DataDefine()
  self.noticeData = self:GetUserData()
  self.chatRoomMgr = ChatInterface.getRoomMgr()
  if self.noticeData.isTemp then
    self.isTemp = true
    self.noticeData = self.noticeData.data
  end
  if self.noticeData then
    self.room = self.chatRoomMgr:GetNoticeMsgs(self.noticeData.uid)
  end
end

function LWUIAllianceNoticeDetailView:DataDestroy()
  self.noticeId = nil
  self.chatRoomMgr = nil
  self.room = nil
end

function LWUIAllianceNoticeDetailView:OnChatLoginJoinNoticeRoom()
  if self.noticeData then
    self.room = ChatInterface.getRoomMgr():GetNoticeMsgs(self.noticeData.uid)
  end
end

function LWUIAllianceNoticeDetailView:BlackWebView()
  if self.webViewContent and self.webViewContent:GetActive() then
    self.webViewContent:OnClickBack()
  else
    self.bottom:OnClickBack()
  end
end

return LWUIAllianceNoticeDetailView
