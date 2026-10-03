local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatTorchRelayCheer = BaseClass("ChatTorchRelayCheer", IChatItem)
local base = IChatItem
local Localization = CS.GameEntry.Localization
local ChatHead = require("UI.UIChatNew.Component.ChatHead")
local ChatUserName = require("UI.UIChatNew.Component.ChatItem.ChatUserName")
local _cp_headIcon = "ChatHead"
local _cp_chatName = "ChatNameLayout"
local reward_path = "TorchRelayShareCheer/reward"
local share_msg_path = "TorchRelayShareCheer/ShareMsg"
local btns_path = "TorchRelayShareCheer/Btns/btnCheer"
local btn_cheer_path = "TorchRelayShareCheer/Btns/btnCheer/btnCheerText"
local my_path = "TorchRelayShareCheer/alliance_icon_bg"

function ChatTorchRelayCheer:ComponentDefine()
  self._chatHead = self:AddComponent(ChatHead, _cp_headIcon)
  self._chatUserName = self:AddComponent(ChatUserName, _cp_chatName)
  self.reward = self:AddComponent(UICommonResItem, reward_path)
  self.share_msg = self:AddComponent(UITextMeshProUGUIEx, share_msg_path)
  self.btn = self:AddComponent(UIButton, btns_path)
  self.btn_cheer = self:AddComponent(UITextMeshProUGUIEx, btn_cheer_path)
  self.btn_cheer:SetLocalText("activity_torch_relay_button_11")
  self.my = self:AddComponent(UIBaseContainer, my_path)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function ChatTorchRelayCheer:OnClickBtnJump()
end

function ChatTorchRelayCheer:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatTorchRelayCheer:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
end

function ChatTorchRelayCheer:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
  base.OnRemoveListener(self)
end

function ChatTorchRelayCheer:UpdateItem(chatData, index)
  if chatData == nil then
    return
  end
  self._chatData = chatData
  local senderUid = self._chatData.senderUid
  self._userInfo = ChatManager2:GetInstance().User:getChatUserInfo(senderUid, true)
  self.share_msg:SetLocalText("activity_torch_relay_desc_13")
  if self._chatHead ~= nil then
    self._chatHead:UpdateHead(self._userInfo, self._chatData)
  end
  if self._chatUserName then
    self._chatUserName:UpdateName(self._userInfo, self._chatData)
  end
  local activityId = self._chatData.attachmentIdJsonObj.activityId
  local activityData = DataCenter.ActivityTorchRelayManager:GetActivityData(tostring(activityId))
  if activityData == nil then
    self.reward.gameObject:SetActive(false)
    self.btn.gameObject:SetActive(false)
    return
  end
  local seqId = self._chatData.seqId
  local roomId = self._chatData.roomId
  self.primId = activityId .. "_" .. roomId .. "_" .. seqId
  local isMe = self._chatData:isMyChat()
  if not isMe then
    local rewardPara = DataCenter.RewardManager:ParseOneRewardStr(activityData.config.cheer_other_reward_show)
    self.reward:ReInit(rewardPara)
    self:RefreshStatus()
  end
  self.reward:SetActive(not isMe)
  self.my:SetActive(isMe)
end

function ChatTorchRelayCheer:OnBtnClick()
  local isMe = self._chatData:isMyChat()
  if isMe then
    return
  end
  local tarUid = self._chatData.senderUid
  local activityId = self._chatData.attachmentIdJsonObj.activityId
  local seqId = self._chatData.seqId
  local roomId = self._chatData.roomId
  SFSNetwork.SendMessage(MsgDefines.ActivityTorchRelayCheerOtherInChat, activityId, roomId, self.primId, seqId, tarUid)
  DataCenter.ActivityTorchRelayManager:SetCheerOtherInChat(self.primId)
  self:RefreshStatus()
end

function ChatTorchRelayCheer:OnUpdateMsg(chatData)
  if not chatData then
    return
  end
  if chatData.seqId ~= self._chatData.seqId or chatData.roomId ~= self._chatData.roomId or chatData.post ~= PostType.TorchRelayCheer then
    return
  end
  self:RefreshStatus()
end

function ChatTorchRelayCheer:RefreshStatus()
  local isCheer = DataCenter.ActivityTorchRelayManager:IsCheerOtherInChat(self.primId)
  CS.UIGray.SetGray(self.btn.transform, isCheer, not isCheer)
  if isCheer then
    self.btn_cheer:SetLocalText("activity_torch_relay_button_12")
  else
    self.btn_cheer:SetLocalText("activity_torch_relay_button_11")
  end
end

return ChatTorchRelayCheer
