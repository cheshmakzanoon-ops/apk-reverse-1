local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_GhostReconSharePoint = BaseClass("ChatItemPost_GhostReconSharePoint", IChatItemPost)
local base = IChatItemPost
local _cp_chatShareNode = "ChatShareNode"
local _cp_chatShareTitle = "ChatShareNode/Image/ShareTitle"
local _cp_chatShareSubTitle = "ChatShareNode/Image/SubTitle"
local _cp_chatShareMsg = "ChatShareNode/ShareIconNode/ShareMsg/ShareMsg"
local _cp_chatShareMsgNode = "ChatShareNode/ShareIconNode/ShareMsg"
local _cp_chatShareIcon = "ChatShareNode/Image/Icon"

function ChatItemPost_GhostReconSharePoint:ComponentDefine()
  self._chatShareNode = self:AddComponent(UIButton, _cp_chatShareNode)
  self._chatShareTitle = self:AddComponent(UIText, _cp_chatShareTitle)
  self._chatShareSubTitle = self:AddComponent(UIText, _cp_chatShareSubTitle)
  self._chatShareMsg = self:AddComponent(UIText, _cp_chatShareMsg)
  self._chatShareMsgNode = self:AddComponent(UIBaseContainer, _cp_chatShareMsgNode)
  self._chatShareIcon = self:AddComponent(UIImage, _cp_chatShareIcon)
  self._chatShareNode:SetOnClick(BindCallback(self, self.ExecuteChatEvent))
end

function ChatItemPost_GhostReconSharePoint:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_GhostReconSharePoint:OnLoaded()
  local chatData = self:ChatData()
  if chatData == nil then
    return
  end
  if chatData.post ~= PostType.GHOST_RECON_SHARE_POINT then
    Logger.LogError("chatUpdateItem error ----------- > roomId : " .. self._chatData.roomId .. "seqId : " .. chatData.seqId)
    return
  end
  self._chatData = chatData
  self.seqId = chatData:getSeqId()
  self._userInfo = ChatManager2:GetInstance().User:getChatUserInfo(self._chatData.senderUid, true)
  if self._chatData:isMyChat() then
    self._chatShareNode:LoadSprite(ChatInterface.GetChatUIPath(UIAssets.ChatItemBg_right))
  else
    self._chatShareNode:LoadSprite(ChatInterface.GetChatUIPath(UIAssets.ChatItemBg_left))
  end
  self:RefreshView()
end

function ChatItemPost_GhostReconSharePoint:RefreshView()
  local message = self._chatData:getMessageWithExtra(true)
  message = string.gsub(message, "[(]", "<u>(")
  message = string.gsub(message, "[)]", ")</u>")
  self._chatShareMsg:SetText(message)
  self._chatShareTitle:SetLocalText(110073)
  self._chatShareSubTitle:SetLocalText("ghostrecon_034")
  if self._chatData.cfgId then
    local cfg = DataCenter.ActGhostreconManager:GetTaskTemplate(self._chatData.cfgId)
    self._chatShareIcon:LoadSprite(cfg.imgSet.QualityImg)
  end
end

function ChatItemPost_GhostReconSharePoint:ExecuteChatEvent()
  if not self.frame:CheckTopViewSlideStateWhenClick() then
    return
  end
  if self.isInDrag == true then
    return
  end
  if self._chatData.post == 43 or self._chatData.msg == "90800159" or self._chatData.msg == "90800185" then
    return
  end
  if self._chatData.post > 0 then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_EXECUTE_CMD, self._chatData)
  else
    self:ShowTips()
  end
end

return ChatItemPost_GhostReconSharePoint
