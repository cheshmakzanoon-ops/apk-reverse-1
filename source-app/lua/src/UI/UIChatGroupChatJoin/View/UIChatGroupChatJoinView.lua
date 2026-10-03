local UIChatGroupChatJoinView = BaseClass("UIChatGroupChatJoinView", UIBaseView)
local GroupHead = require("UI/UIChatNewV2/Component/GroupHead")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local maxTime = 604800000

function UIChatGroupChatJoinView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIChatGroupChatJoinView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChatGroupChatJoinView:ComponentDefine()
  self.compGroupHeadCom = self:AddComponent(GroupHead, "Com/groupHeadCom")
  self.textInfo = self:AddComponent(UITextMeshProUGUIEx, "Com/infoText")
  self.textGroupChatName = self:AddComponent(UITextMeshProUGUIEx, "Com/groupChatName")
  self.goBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/getBtn")
  self.colseBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/btnClose")
  self.colseBtn:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.goBtn:SetOnClick(function()
    self:OnGoBtnClick()
  end)
  self.btnPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.notRoomText = self:AddComponent(UIText, "Com/notRoomText")
  self.tipText = self:AddComponent(UIText, "UICommonPopUpTitle/tipText")
end

function UIChatGroupChatJoinView:ComponentDestroy()
  self.compGroupHeadCom = nil
  self.textInfo = nil
  self.textGroupChatName = nil
  self.btnGet = nil
  self.btnPanel = nil
end

function UIChatGroupChatJoinView:ReInit()
  local param = self:GetUserData()
  self.chatData = param.chatData
  self.roomInfo = param.roomInfo
  self:UpdateView(true)
end

function UIChatGroupChatJoinView:OnUpdateRoomInfo(roomInfo)
  if roomInfo.roomId == self.roomInfo.roomId and roomInfo.group == self.roomInfo.group then
    self.roomInfo = roomInfo
    self:UpdateView()
  end
end

function UIChatGroupChatJoinView:UpdateView(isInit)
  self.compGroupHeadCom:UpdateGroupHeadList(self.roomInfo.members, true)
  local openRoom = self.roomInfo.members and true or false
  self.notRoomText:SetActive(not openRoom)
  self.compGroupHeadCom:SetActive(openRoom)
  self.goBtn:SetActive(openRoom)
  self.tipText:SetActive(openRoom)
  self.textGroupChatName:SetActive(openRoom)
  self.goBtn:SetActive(openRoom)
  self.textInfo:SetActive(openRoom)
  if openRoom then
    self.textGroupChatName:SetText(self.roomInfo.name .. string.format("(%s)", #self.roomInfo.members))
  else
    self.notRoomText:SetLocalText("group_room_dismiss")
    return
  end
  if self.chatData.extra.inviteCode == InviteState.InviteCanOp then
    self.goBtn:SetActive(true)
    self.tipText:SetActive(false)
    if self.roomInfo and isInit then
      ChatInterface.getRoomMgr():GetNewRoomInfo({
        self.roomInfo.roomId
      }, self.roomInfo.group)
    end
  elseif self.chatData.extra.inviteCode == InviteState.InviteAgree then
    self.goBtn:SetActive(false)
    self.tipText:SetActive(true)
    self.tipText:SetLocalText("group_join_tips2")
  end
  if self.chatData.senderUid == LuaEntry.Player.uid then
    self.goBtn:SetActive(false)
    self.tipText:SetLocalText("group_join_tips3")
    self.tipText:SetActive(true)
  end
end

function UIChatGroupChatJoinView:DataDefine()
  self.chatData = nil
  self.roomInfo = nil
end

function UIChatGroupChatJoinView:DataDestroy()
  self.chatData = nil
  self.roomInfo = nil
end

function UIChatGroupChatJoinView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_ROOMINFO_UPDATA, self.OnUpdateRoomInfo)
end

function UIChatGroupChatJoinView:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOMINFO_UPDATA, self.OnUpdateRoomInfo)
  base.OnRemoveListener(self)
end

function UIChatGroupChatJoinView:OnGoBtnClick()
  local now = UITimeManager:GetInstance():GetServerTime()
  local time = now - self.chatData.serverTime
  if time < maxTime then
    PostEventLog.Track(PostEventLog.Defines.CustomGroupAcceptInvitation, {eventdata = true})
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.ChatRoomAcceptinvite, self.roomInfo.roomId, self.roomInfo.group, self.chatData.roomId, self.chatData.seqId)
    self.ctrl:CloseSelf()
  else
    local lastPushDay = math.floor(UITimeManager:GetInstance().GetDateNum(now, self.chatData.serverTime))
    UIUtil.ShowTips(Localization:GetString("group_invite_tips3", lastPushDay))
  end
end

function UIChatGroupChatJoinView:OnBtnPanelClick()
  PostEventLog.Track(PostEventLog.Defines.CustomGroupAcceptInvitation, {eventdata = false})
  self.ctrl:CloseSelf()
end

return UIChatGroupChatJoinView
