local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatItemMailScountResultShare = BaseClass("ChatItemMailScountResultShare", IChatItem)
local base = IChatItem
local Localization = CS.GameEntry.Localization
local ChatHead = require("UI.UIChatNew.Component.ChatHead")
local ChatUserName = require("UI.UIChatNew.Component.ChatItem.ChatUserName")
local rapidjson = require("rapidjson")
local _cp_chatHead = "ChatHead"
local _cp_ShareTitle = "ChatShareNode/Image/ShareTitle"
local _cp_shareMsg = "ChatShareNode/ShareIconNode/ShareMsg/ShareMsg"
local _cp_shareNode = "ChatShareNode"
local _cp_chatNameLayout = "ChatNameLayout"
local _cp_shareIcon = "ChatShareNode/ShareIconNode/Image"
local Const_Min_ShareNodeHeight = 120
local Const_OneLineHeight = 26
local UnityOutLine = typeof(CS.UnityEngine.UI.Outline)

function ChatItemMailScountResultShare:ComponentDefine()
  self._chatHead = self:AddComponent(ChatHead, _cp_chatHead)
  self._shareTitle = self:AddComponent(UIText, _cp_ShareTitle)
  self._shareTitleOutline = self._shareTitle.gameObject:GetComponent(UnityOutLine)
  self._shareMsg = self:AddComponent(UIText, _cp_shareMsg)
  self._shareNode = self:AddComponent(UIButton, _cp_shareNode)
  self._shareNode:SetOnClick(BindCallback(self, self.OnClickBg))
  self._chatNameLayout = self:AddComponent(ChatUserName, _cp_chatNameLayout)
  self._shareIcon = self:AddComponent(UIImage, _cp_shareIcon)
end

function ChatItemMailScountResultShare:OnClickBg()
  if not SceneUtils.CheckCanGotoWorld(120018, false) then
    return
  end
  if self.attachInfo ~= nil then
    local mailId = self.attachInfo.uid
    local mailType = tostring(self.attachInfo.mailType)
    local userId = self.attachInfo.toUser or ""
    SFSNetwork.SendMessage(MsgDefines.MailGet, mailId, mailType, userId)
  end
end

function ChatItemMailScountResultShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemMailScountResultShare:UpdateItem(chatdata, index)
  base.UpdateItem(self, chatdata, index)
  if chatdata == nil then
    return
  end
  local attachmentId = chatdata.attachmentId or ""
  local tabAttachment = rapidjson.decode(attachmentId) or {}
  self.attachInfo = tabAttachment
  self._shareIcon:LoadSprite("Assets/Main/Sprites/UI/UIMain/UIMainNew/jiantou_scout.png")
  self._shareTitle:SetLocalText(300617)
  self._shareTitle:SetColor(Const_Color_Green)
  self._shareTitleOutline.effectColor = Const_Green_Outline
  local str = chatdata:getMessageWithExtra(false)
  self._shareMsg:SetText(str)
  local senderUid = chatdata.senderUid
  local _userInfo = ChatManager2:GetInstance().User:getChatUserInfo(senderUid, true)
  if self._chatNameLayout then
    self._chatNameLayout:UpdateName(_userInfo, chatdata)
  end
  local height = self._shareMsg:GetHeight()
  local curHeight = Const_Min_ShareNodeHeight + height - Const_OneLineHeight
  height = Mathf.Max(Const_Min_ShareNodeHeight, curHeight)
  local size_x, size_y = self._shareNode.rectTransform:Get_sizeDelta()
  self._shareNode.rectTransform:Set_sizeDelta(size_x, height)
  local r_x, _ = self.rectTransform:Get_sizeDelta()
  self.rectTransform:Set_sizeDelta(r_x, height + 40)
  self:UpdateTopOffset()
end

function ChatItemMailScountResultShare:GetTopOffset()
  if self._chatNameLayout then
    return self._chatNameLayout:GetTopOffset()
  else
    return 0
  end
end

function ChatItemMailScountResultShare:UpdateTopOffset()
  local initOffset = 40
  local topOffset = self:GetTopOffset()
  local sizeX, sizeY = self.rectTransform:Get_sizeDelta()
  self.rectTransform:Set_sizeDelta(sizeX, sizeY + topOffset)
  self:SetTransPosY(self._shareNode.rectTransform, -(initOffset + topOffset))
end

return ChatItemMailScountResultShare
