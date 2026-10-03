local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local GroupChatInvitation = BaseClass("GroupChatInvitation", IChatItemPost)
local GroupHead = require("UI/UIChatNewV2/Component/GroupHead")
local base = IChatItemPost
local Localization = CS.GameEntry.Localization
local path = "GroupChat/zyf_qunliaoyouhua_quanxiaoxi_di2.png"
local selfPath = "GroupChat/zyf_qunliaoyouhua_quanxiaoxi_di1.png"

function GroupChatInvitation:OnLoaded()
  self:UpdateItem(self:ChatData())
end

function GroupChatInvitation:ComponentDestroy()
  self.groupHead = nil
end

function GroupChatInvitation:ComponentDefine()
  self.msgText = self:AddComponent(UITextMeshProUGUIEx, "msg")
  self.titleText = self:AddComponent(UITextMeshProUGUIEx, "banner/title")
  self.bgImg = self:AddComponent(UIImage, "")
  self.btn = self:AddComponent(UIButton, "")
  self.dissolveText = self:AddComponent(UIText, "dissolveText")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.groupHead = self:AddComponent(GroupHead, "head/groupHeadCom")
end

function GroupChatInvitation:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function GroupChatInvitation:OnBtnClick()
  if not ChatInterface.GetGroupChatIsOpen() then
    UIUtil.ShowTipsId("feature_close_tips")
    return
  end
  if self.roomInfo and self.roomInfo.members and #self.roomInfo.members > 0 then
    local chatData = self:ChatData()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatGroupChatJoin, {anim = true}, {
      chatData = chatData,
      roomInfo = self.roomInfo
    })
  else
    UIUtil.ShowTipsId("group_room_dismiss")
  end
end

function GroupChatInvitation:OnLoaded()
  local chatData = self:ChatData()
  if not chatData then
    return
  end
  if chatData:isMyChat() then
    self.bgImg:LoadSprite(ChatInterface.GetChatUIPath(UIAssets.ChatItemBg_right))
    self.groupHead:SetBgImg(ChatInterface.GetChatUIPath(selfPath))
  else
    self.bgImg:LoadSprite(ChatInterface.GetChatUIPath(UIAssets.ChatItemBg_left))
    self.groupHead:SetBgImg(ChatInterface.GetChatUIPath(path))
  end
  local roomInfo = ChatInterface.getRoomMgr():GetRoomInfo(chatData.extra.inviteRoom, chatData.extra.group)
  if roomInfo then
    self:RefreshView(roomInfo)
  end
end

function GroupChatInvitation:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_ROOMINFO_UPDATA, self.RefreshView)
end

function GroupChatInvitation:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOMINFO_UPDATA, self.RefreshView)
  base.OnRemoveListener(self)
end

function GroupChatInvitation:RefreshView(roomInfo)
  if not roomInfo then
    return
  end
  local chatData = self:ChatData()
  if not chatData then
    return
  end
  if roomInfo.roomId ~= chatData.extra.inviteRoom then
    return
  end
  self.groupHead:SetActive(not roomInfo.isDissolve)
  self.msgText:SetActive(not roomInfo.isDissolve)
  self.dissolveText:SetActive(roomInfo.isDissolve)
  if roomInfo.isDissolve then
    self.roomInfo = roomInfo
    self.dissolveText:SetLocalText("group_room_dismiss")
    return
  end
  local userInfo = ChatManager2:GetInstance().User:getChatUserInfo(self:ChatData().senderUid)
  self.roomInfo = roomInfo
  self.groupHead:UpdateGroupHeadList(roomInfo.members, true)
  local name = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(userInfo.uid, userInfo.userName)
  self.msgText:SetLocalText("group_invite_des", name, roomInfo.name)
  if chatData:isMyChat() then
    self.groupHead:SetBgImg(ChatInterface.GetChatUIPath(selfPath))
  else
    self.groupHead:SetBgImg(ChatInterface.GetChatUIPath(path))
  end
end

return GroupChatInvitation
