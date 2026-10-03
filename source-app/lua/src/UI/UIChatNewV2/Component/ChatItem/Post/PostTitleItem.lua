local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_PostTitleItem = BaseClass("PostTitleItem", IChatItemPost)
local base = IChatItemPost
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local icon_path = "ChatShareNode/icon"
local name_path = "ChatShareNode/txtName"
local source_path = "ChatShareNode/txtSource"
local click_btn_path = "ChatShareNode/clickBtn"
local _cp_chatShareTitle = "ChatShareNode/Image/ShareTitle"
local title_path = "ChatShareNode/Image/Title"
local bg_path = "ChatShareNode"

function ChatItemPost_PostTitleItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_PostTitleItem:ComponentDefine()
  self.icon = self:AddComponent(UIImage, icon_path)
  self.txtName = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.txtSource = self:AddComponent(UITextMeshProUGUIEx, source_path)
  self.click_btn = self:AddComponent(UIButton, click_btn_path)
  self._chatShareTitle = self:AddComponent(UIText, _cp_chatShareTitle)
  self.title = self:AddComponent(UIText, title_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.click_btn:SetOnClick(function()
    self:OnShowClick()
  end)
  self.click_btn:SetSafeClickMode(true)
  self._chatShareTitle:SetLocalText(110073)
  self.title:SetLocalText("lw_title_ui_1")
end

function ChatItemPost_PostTitleItem:OnLoaded()
  local chatData = self:ChatData()
  if chatData == nil then
    return
  end
  self._chatData = chatData
  self.seqId = chatData:getSeqId()
  self._userInfo = ChatManager2:GetInstance().User:getChatUserInfo(self._chatData.senderUid, true)
  if chatData:isMyChat() then
    self.bg:LoadSprite(ChatInterface.GetChatUIPath(UIAssets.ChatItemBg_right))
  else
    self.bg:LoadSprite(ChatInterface.GetChatUIPath(UIAssets.ChatItemBg_left))
  end
  self:RefreshView(chatData)
end

function ChatItemPost_PostTitleItem:RefreshView(chatData)
  local attachJson = chatData.attachmentId and rapidjson.decode(chatData.attachmentId)
  if not attachJson then
    self.icon:SetActive(false)
    self.txtName:SetActive(false)
    self.txtSource:SetActive(false)
  end
  self.uid = attachJson.uid
  self.cfgId = attachJson.cfgId
  local info = DataCenter.PlayerTitleTemplateManager:GetTitleInfo(self.cfgId)
  self.icon:LoadSpriteAsyncEx(info.title_show_icon)
  self.txtName:SetLocalText(info.name)
  self.txtSource:SetLocalText(info.source)
end

function ChatItemPost_PostTitleItem:OnShowClick()
  DataCenter.PlayerInfoDataManager:ShowTitleDetail(self.cfgId, self.uid)
end

function ChatItemPost_PostTitleItem:OnRecycle()
end

return ChatItemPost_PostTitleItem
