local LWUIChatOperationItem = BaseClass("LWUIChatOperationItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function LWUIChatOperationItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWUIChatOperationItem:ComponentDefine()
  base.OnCreate(self)
  self.btnComponents = {}
  for i = 1, 2 do
    local pre = "Layout/Btn" .. i
    local go = self:AddComponent(UIBaseContainer, pre)
    local icon = self:AddComponent(UIImage, pre .. "/icon" .. i)
    local text = self:AddComponent(UITextMeshProUGUIEx, pre .. "/text" .. i)
    local btn = self:AddComponent(UIButton, pre .. "/btn" .. i)
    table.insert(self.btnComponents, {
      go = go,
      icon = icon,
      text = text,
      btn = btn
    })
    local index = i
    btn:SetOnClick(function()
      self:OnBtnClick(index)
    end)
  end
end

function LWUIChatOperationItem:Remove_translate_tags(text)
  text = text:gsub("<span translate=\"no\">(.-)</span>", "%1")
  return text
end

function LWUIChatOperationItem:OnBtnClick(index)
  self.data = self.list[index]
  if not self.data then
    return
  end
  if self.data.type == ChatOperationBtnType.Copy then
    local msg = self._chatData:getMessageWithExtra(false)
    CommonUtil.CopyTextToClipboard(msg)
    UIUtil.ShowTipsId(128031)
    self.viewCtrl:CloseSelf()
  elseif self.data.type == ChatOperationBtnType.Translate then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_TRANSLATE_ITEM, {
      roomId = self._chatData.roomId,
      seqId = self._chatData.seqId
    })
    self.viewCtrl:CloseSelf()
  elseif self.data.type == ChatOperationBtnType.Reply then
    EventManager:GetInstance():Broadcast(EventId.SetReplyChatMsg, self._chatData)
    self.viewCtrl:CloseSelf()
  elseif self.data.type == ChatOperationBtnType.Report then
    local isLvEnough = ChatManager2:GetInstance():CheckMainLvEnough()
    if not isLvEnough then
      UIUtil.ShowTipsId(208256)
      return
    end
    local reported = ChatManager2:GetInstance():CheckIfReported(self._chatData)
    if reported then
      UIUtil.ShowTipsId(280064)
      return
    end
    if ChatManager2:GetInstance():CheckReportTime() then
      local type = ReportType.chat
      if self._chatData.post == PostType.Chat_Moment then
        type = ReportType.FriendCircleMoment
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatReport, {anim = true}, {
        type = type,
        chatData = self._chatData
      })
      self.viewCtrl:CloseSelf()
    else
      UIUtil.ShowTipsId(208250)
    end
  elseif self.data.type == ChatOperationBtnType.Up then
    if self._chatData.group == ChatGroupType.GROUP_EASTER_EGG_ROOM then
      if self._chatData:isPlayerFollowEmoji(EmojiCommentsType.Up) then
        UIUtil.ShowTipsId("activity_99144_9")
        return
      end
      ChatManager2:GetInstance():SendEmojiComments_EasterEgg(self._chatData:getSeqId(), EmojiCommentsType.Up, self._chatData.roomId, self._chatData.senderUid)
    else
      ChatManager2:GetInstance():SendEmojiComments(self._chatData:getSeqId(), EmojiCommentsType.Up, self._chatData.roomId, self._chatData.senderUid)
    end
    self.viewCtrl:CloseSelf()
  elseif self.data.type == ChatOperationBtnType.Down then
    ChatManager2:GetInstance():SendEmojiComments(self._chatData:getSeqId(), EmojiCommentsType.Down, self._chatData.roomId, self._chatData.senderUid)
    self.viewCtrl:CloseSelf()
  elseif self.data.type == ChatOperationBtnType.Emoji then
    ChatManager2:GetInstance():SendEmojiComments(self._chatData:getSeqId(), EmojiCommentsType.ScatterFlowers, self._chatData.roomId, self._chatData.senderUid)
    self.viewCtrl:CloseSelf()
  elseif self.data.type == ChatOperationBtnType.Share then
    local shareParam = {
      chatData = self._chatData,
      isShare = true
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, shareParam)
    self.viewCtrl:CloseSelf()
  elseif self.data.type == ChatOperationBtnType.Recall then
    if self._chatData.group ~= ChatGroupType.GROUP_EASTER_EGG_ROOM then
      local now = UITimeManager:GetInstance():GetServerTime()
      if now - self._chatData.serverTime > 120000 then
        UIUtil.ShowTipsId("msg_recall_fail_notice")
        return
      end
    end
    local roomId = self._chatData.roomId
    local seqId = self._chatData:getSeqId()
    UIUtil.ShowMessage(Localization:GetString("msg_recall_notice"), 2, "btn_recall", GameDialogDefine.CANCEL, function()
      ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.ChatCancel, roomId, seqId)
    end)
    self.viewCtrl:CloseSelf()
  elseif self.data.type == ChatOperationBtnType.TranslateAll then
    local isOpen = ChatInterface.TranslateAllIsOpen()
    if not isOpen then
      UIUtil.ShowTipsId("full_page_translation_notice")
      return
    end
    PostEventLog.Track(PostEventLog.Defines.FULL_PAGE_TRANSLATION)
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_TRANSLATE_All)
    self.viewCtrl:CloseSelf()
  elseif self.data.type == ChatOperationBtnType.Delete then
    UIUtil.ShowSecondMessage("", Localization:GetString("comment_delete_des"), 2, "100190", "btn_cancel", function()
      ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.ChatDelete, self._chatData.roomId, self._chatData:getSeqId())
      self.viewCtrl:CloseSelf()
    end, nil, nil, nil, nil, nil, nil, nil, nil, false, nil, nil)
  elseif self.data.type == ChatOperationBtnType.Reaction then
    self.view:SetReactionPanel()
  end
end

function LWUIChatOperationItem:UpdateItem(list)
  self:UpdateItemData(list)
end

function LWUIChatOperationItem:UpdateItemData(list)
  self.list = list
  local userData = self.view.chatUserData
  self._chatData = userData.chatdata
  self._targetPos = userData.targetPos
  self._userInfo = userData.userinfo
  self._chatItem = userData.chatItem
  for i, v in ipairs(self.btnComponents) do
    local data = self.list[i]
    v.go:SetActive(data ~= nil)
    if data then
      if data.type == ChatOperationBtnType.TranslateAll and self._chatData.group == ChatGroupType.GROUP_ALLIANCE_NOTICE then
        v.go:SetActive(false)
      end
      v.icon:LoadSprite(ChatInterface.GetChatUIPath(data.iconPath))
      if data.text then
        v.text:SetLocalText(data.text)
      end
    end
  end
  self.viewCtrl = self.view.ctrl
end

function LWUIChatOperationItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIChatOperationItem:DataDestroy()
  self.list = nil
  self._chatData = nil
  self._targetPos = nil
  self._userInfo = nil
  self._chatItem = nil
  self.viewCtrl = nil
end

function LWUIChatOperationItem:ComponentDestroy()
  self.btnComponents = {}
end

return LWUIChatOperationItem
