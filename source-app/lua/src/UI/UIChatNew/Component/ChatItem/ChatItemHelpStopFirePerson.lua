local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatItemHelpStopFirePerson = BaseClass("ChatItemHelpStopFirePerson", IChatItem)
local ChatHead = require("UI.UIChatNew.Component.ChatHead")
local ChatUserName = require("UI.UIChatNew.Component.ChatItem.ChatUserName")
local base = IChatItem
local rapidjson = require("rapidjson")
local _cp_anchorTransform = "ChatAnchor"
local _cp_chatUserName = "ChatNameLayout"
local btn_path = "ChatAnchor/Bg/ZanBtn"
local liked_img_path = "ChatAnchor/Bg/LikedImg"
local desc_text_path = "ChatAnchor/Bg/DesText"
local active_anim_path = "ChatAnchor/Bg/LikedImg/ActiveAnim"
local Localization = CS.GameEntry.Localization

function ChatItemHelpStopFirePerson:ComponentDefine()
  self._rectTransform = self.rectTransform
  self._anchorTransform = self.transform:Find(_cp_anchorTransform):GetComponent(typeof(CS.UnityEngine.RectTransform))
  self._chatHead = self:AddComponent(ChatHead, "ChatHead")
  self._chatUserName = self:AddComponent(ChatUserName, _cp_chatUserName)
  self.likedImg = self:AddComponent(UIButton, liked_img_path)
  self.desc = self:AddComponent(UIText, desc_text_path)
  self.heart_effect = self:AddComponent(UIBaseContainer, active_anim_path)
  self.heart_effect:SetActive(false)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:Interactive()
  end)
  self.likedImg:SetOnClick(function()
    self:OnClickLikeImg()
  end)
end

function ChatItemHelpStopFirePerson:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
end

function ChatItemHelpStopFirePerson:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
  base.OnRemoveListener(self)
end

function ChatItemHelpStopFirePerson:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemHelpStopFirePerson:UpdateItem(chatData, index)
  base.UpdateItem(self, chatData, index)
  self.seqId = chatData:getSeqId()
  self:Refresh(chatData)
end

function ChatItemHelpStopFirePerson:OnUpdateMsg(chatData)
  if chatData and chatData.seqId == self.seqId and chatData.roomid == self.roomId then
    self:Refresh(chatData)
  end
end

function ChatItemHelpStopFirePerson:Refresh(chatData)
  self._chatData = chatData
  local isMyChat = self._chatData:isMyChat()
  self.btn:SetActive(false)
  if chatData and chatData.clientUpdateExtra and chatData.clientUpdateExtra == "liked" then
    self.likedImg:SetActive(true)
  else
    self.likedImg:SetActive(false)
    if not isMyChat then
      self.btn:SetActive(true)
    end
  end
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
    if jsonObj then
      self.desc:SetLocalText(jsonObj.dialogId)
    end
  end
end

function ChatItemHelpStopFirePerson:Interactive()
  if self._chatData then
    local seqId = self.seqId
    local senderUid = self._chatData.senderUid
    local roomId = self._chatData.roomId
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self._chatData.senderUid, self._chatData.senderName)
    DataCenter.BuildHelpStopFireManager:HelpStopFireChatInteractive(seqId, senderUid, roomId, senderUid, InteractiveUtil.ThumbsUpType.HelpStopFirePerson, showName, function()
      self.likedImg:SetActive(true)
      self.heart_effect:SetActive(true)
      TimerManager:GetInstance():DelayInvoke(function()
        if self and self.heart_effect then
          self.heart_effect:SetActive(false)
        end
      end)
    end)
  end
end

function ChatItemHelpStopFirePerson:OnClickLikeImg()
  if self._chatData then
    local isMyChat = self._chatData:isMyChat()
    if isMyChat then
      local roomData = ChatInterface.getRoomData(self._chatData.roomId)
      local targetMemberId = roomData:GetPrivateUser()
      local userInfo = ChatManager2:GetInstance().User:getChatUserInfo(targetMemberId, true)
      if userInfo then
        local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(userInfo.uid, userInfo.userName)
        UIUtil.ShowTips(Localization:GetString("outfire_tips_like_3", showName))
      end
    else
      local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self._chatData.senderUid, self._chatData.senderName)
      UIUtil.ShowTips(Localization:GetString("outfire_tips_like_2", showName))
    end
  end
end

return ChatItemHelpStopFirePerson
