local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_PostSeasonBankReport = BaseClass("PostSeasonBankReport", IChatItemPost)
local base = IChatItemPost
local rapidjson = require("rapidjson")
local iconDeco_path = "ChatShareNode/Image/iconDeco"
local icon_path = "ChatShareNode/icon"
local desc_path = "ChatShareNode/txtDesc"
local click_btn_path = "ChatShareNode/clickBtn"
local title_path = "ChatShareNode/Image/title"
local bg_path = "ChatShareNode"

function ChatItemPost_PostSeasonBankReport:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_PostSeasonBankReport:ComponentDefine()
  self.icon = self:AddComponent(UIRawImage, icon_path)
  self.iconDeco = self:AddComponent(UIImage, iconDeco_path)
  self.txtDesc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.click_btn = self:AddComponent(UIButton, click_btn_path)
  self.title = self:AddComponent(UIText, title_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.click_btn:SetOnClick(function()
    self:OnShowClick()
  end)
  self.click_btn:SetSafeClickMode(true)
  self.iconDeco:LoadSpriteAsync("Assets/Main/SeasonRes/S5/Sprites/Bank/zxl_cundan_tubiao_fenxiang.png")
end

function ChatItemPost_PostSeasonBankReport:OnLoaded()
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

function ChatItemPost_PostSeasonBankReport:RefreshView(chatData)
  local attachJson = chatData.attachmentId and rapidjson.decode(chatData.attachmentId)
  if not attachJson then
    self.icon:SetActive(false)
    self.txtDesc:SetActive(false)
    return
  end
  self.param = attachJson.param
  local iconPath = DataCenter.SeasonBankTemplateManager.bankStamp
  iconPath = iconPath and iconPath[self.param.logTypeCode or 1]
  if iconPath then
    self.icon:LoadSpriteAsync(iconPath)
  end
  local mailName = DataCenter.SeasonBankTemplateManager.mailName
  mailName = mailName[self.param.logTypeCode or 1]
  if mailName then
    self.title:SetLocalText(mailName)
  end
  self.txtDesc:SetLocalText("s5_bank_ui63", self.param.depositAmount, self.param.depositDays)
end

function ChatItemPost_PostSeasonBankReport:OnShowClick()
  if not self.param then
    Logger.LogError("ChatItemPost_PostSeasonBankReport:OnShowClick data is nil")
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.BankReport, {anim = true}, {
    self.param
  })
end

function ChatItemPost_PostSeasonBankReport:OnRecycle()
end

return ChatItemPost_PostSeasonBankReport
