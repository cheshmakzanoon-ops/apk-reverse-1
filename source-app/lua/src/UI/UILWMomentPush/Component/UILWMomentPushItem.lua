local base = UIBaseContainer
local UILWMomentPushItem = BaseClass("UILWMomentPushItem", base)
local FriendsCirlePhoto = require("UI.LWPlayerInfo.FriendCirclePost.post.FriendsCirlePhoto")
local Localization = CS.GameEntry.Localization
local playerHead_path = "UIPlayerHead"
local descTxt_path = "Txt_Des"
local timeTxt_path = "Txt_Time"
local titleTxt_path = "Txt_Title"
local line_path = "Line"
local commentDeleteTxt_path = "CommentDeleteMsg"
local momentDeleteTxt_path = "MomentDeleteMsg"
local momentContent_path = "MomentContent"
local momentMsgTxt_path = "MomentContent/MomentMsg"
local chatUpIcon_path = "Icon_Chatup"
local photoRoot_path = "MomentContent/MomentPhoto"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.playerHead = self:AddComponent(UIBaseContainer, playerHead_path)
  self.descTxt = self:AddComponent(UITextMeshProUGUIEx, descTxt_path)
  self.timeTxt = self:AddComponent(UIText, timeTxt_path)
  self.titleTxt = self:AddComponent(UIText, titleTxt_path)
  self.line = self:AddComponent(UIBaseContainer, line_path)
  self.commentDeleteTxt = self:AddComponent(UIBaseContainer, commentDeleteTxt_path)
  self.momentDeleteTxt = self:AddComponent(UIBaseContainer, momentDeleteTxt_path)
  self.momentContent = self:AddComponent(UIBaseContainer, momentContent_path)
  self.momentMsgTxt = self:AddComponent(UITextMeshProUGUIEx, momentMsgTxt_path)
  self.chatUpIcon = self:AddComponent(UIBaseContainer, chatUpIcon_path)
  self.photoRoot = self:AddComponent(UIBaseContainer, photoRoot_path)
  self.photoComponent = self:AddComponent(FriendsCirlePhoto, photoRoot_path .. "/FriendsCirlePhoto")
  self.playerHeadComponent = self:AddComponent(UICommonHead, playerHead_path)
  self.bgBtn = self:AddComponent(UIButton, "")
  self.bgBtn:SetOnClick(function()
    self:OnClick()
  end)
  self.playerHeadComponent:SetEnableClickShowInfo(true, true)
  ChatInterface.SetEmojiTextProperty(self.descTxt, true)
  ChatInterface.SetEmojiTextProperty(self.momentMsgTxt)
end

function UILWMomentPushItem:OnClick()
  if self.isMsgDelete then
    UIUtil.ShowTipsId("moment_noti_tips_moment")
  elseif self.senderMessage.msgId then
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.MomentTimelineAuthCheck, self.senderMessage.msgId, self.msgBody)
  end
end

local function ComponentDestroy(self)
  self.playerHead = nil
  self.descTxt = nil
  self.timeTxt = nil
  self.titleTxt = nil
  self.line = nil
  self.commentDeleteTxt = nil
  self.momentDeleteTxt = nil
  self.momentContent = nil
  self.momentMsgTxt = nil
  self.chatUpIcon = nil
  self.photoRoot = nil
  self.playerHeadComponent = nil
end

local function DataDefine(self)
  self.senderMessage = nil
  self.isMsgDelete = nil
end

local function DataDestroy(self)
  self.senderMessage = nil
  self.isMsgDelete = nil
end

function UILWMomentPushItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.PlayerMessageInfo, self.RefreshPlayerInfo)
end

function UILWMomentPushItem:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.PlayerMessageInfo, self.RefreshPlayerInfo)
  base.OnRemoveListener(self)
end

function UILWMomentPushItem:UpdateItem(data)
  self.data = data
  self:UpdateSenderInfo(data)
  self:UpdateCommenterInfo(data)
end

function UILWMomentPushItem:UpdateSenderInfo(data)
  self.isMsgDelete = data.msgDeleteFlag == 1
  self.momentDeleteTxt:SetActive(self.isMsgDelete)
  local msgBody = data.msgBody or {}
  local extra = msgBody.extra or {}
  local hasPhoto = extra.picVer ~= nil and extra.picVer ~= -1
  local RoomMgr = ChatManager2:GetInstance().Room
  self.senderMessage = RoomMgr:CreateChatMessage()
  self.senderMessage:onParseServerData(msgBody)
  self.msgBody = msgBody
  self.senderMessage.msgId = data.msgId
  if self.isMsgDelete then
    self.photoRoot:SetActive(false)
    self.momentMsgTxt:SetActive(false)
  elseif hasPhoto then
    self.photoRoot:SetActive(true)
    self.momentMsgTxt:SetActive(false)
    self.photoComponent:OnLoaded(self.senderMessage)
    self.photoComponent:UpdatePhoto()
  else
    self.photoRoot:SetActive(false)
    self.momentMsgTxt:SetActive(true)
    self.momentMsgTxt:SetText(msgBody.msg or "")
  end
end

function UILWMomentPushItem:UpdateCommenterInfo(data)
  self:RefreshPlayerInfo(data.sender)
  local isCommentDelete = data.relatedDeleteFlag == 1
  if isCommentDelete then
    self.commentDeleteTxt:SetActive(true)
    self.momentContent:SetActive(false)
    self.descTxt:SetActive(false)
    self.chatUpIcon:SetActive(false)
  else
    self.commentDeleteTxt:SetActive(false)
    self.momentContent:SetActive(true)
    local isComment = data.post == 1
    self.chatUpIcon:SetActive(not isComment)
    local relatedBody = data.relatedBody or {}
    self.descTxt:SetActive(isComment)
    if relatedBody.reply then
      local replyMsg = relatedBody.reply
      local sender = ChatInterface.getUserData(replyMsg.uid)
      local senderName = sender and sender.userName or replyMsg.userName
      self.descTxt:SetText(string.format("%s <color=#249bc5>%s:</color> %s", Localization:GetString("2900032"), senderName, relatedBody.msg or ""))
    else
      self.descTxt:SetText(relatedBody.msg or "")
    end
  end
  self.timeTxt:SetText(UITimeManager:GetInstance():GetFriendsCirleShowTime(data.timestamp))
end

function UILWMomentPushItem:RefreshPlayerInfo(uid)
  if self.data.sender ~= uid then
    return
  end
  local userInfo = ChatInterface.getUserData(uid)
  self.titleTxt:SetText(userInfo:GetFomatName())
  self.playerHeadComponent:ParseHeadInfo(userInfo)
end

UILWMomentPushItem.OnCreate = OnCreate
UILWMomentPushItem.OnDestroy = OnDestroy
UILWMomentPushItem.OnEnable = OnEnable
UILWMomentPushItem.OnDisable = OnDisable
UILWMomentPushItem.ComponentDefine = ComponentDefine
UILWMomentPushItem.ComponentDestroy = ComponentDestroy
UILWMomentPushItem.DataDefine = DataDefine
UILWMomentPushItem.DataDestroy = DataDestroy
return UILWMomentPushItem
