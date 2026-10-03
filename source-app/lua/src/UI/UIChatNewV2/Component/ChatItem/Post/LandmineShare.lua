local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local LandmineShare = BaseClass("LandmineShare", IChatItemPost)
local base = IChatItemPost
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization
local title_path = "ShareIconNode/Title"
local _cp_shareMsg = "ShareIconNode/ShareMsg"
local _cp_shareNode = ""
local MailBattleParseHelper = require("DataCenter.MailData.MailBattleParseHelper")

function LandmineShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LandmineShare:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LandmineShare:ComponentDefine()
  self._shareMsg = self:AddComponent(UIText, _cp_shareMsg)
  self._shareNode = self:AddComponent(UIButton, _cp_shareNode)
  self._shareNode:SetOnClick(BindCallback(self, self.OnClickBg))
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.title:SetLocalText("season_mastery_s2_UI_2")
end

function LandmineShare:ComponentDestroy()
  self.title = nil
  self._shareMsg = nil
  self._shareNode = nil
end

function LandmineShare:OnClickBg()
  if self.mailId then
    DataCenter.MailDataManager:OpenShareMail(self.mailId, self.toUser)
  end
end

function LandmineShare:OnLoaded()
  local chatdata = self:ChatData()
  if not chatdata then
    return
  end
  local senderUid = chatdata.senderUid
  local _userInfo = ChatManager2:GetInstance().User:getChatUserInfo(senderUid, true)
  if self._chatNameLayout then
    self._chatNameLayout:UpdateName(_userInfo, chatdata)
  end
  local tabAttachment = rapidjson.decode(chatdata.attachmentId) or {}
  self.mailId = tabAttachment.reportUid
  self.toUser = tabAttachment.toUser or ""
  self._shareMsg:SetText(tabAttachment.customizeDesc)
end

function LandmineShare:GetPlayerName()
end

function LandmineShare:OnRecycle()
end

return LandmineShare
