local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local GoldRelicShare = BaseClass("GoldRelicShare", IChatItemPost)
local base = IChatItemPost
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization
local title_path = "ShareIconNode/Title"
local _cp_shareMsg = "ShareIconNode/ShareMsg"

function GoldRelicShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function GoldRelicShare:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function GoldRelicShare:ComponentDefine()
  self._shareMsg = self:AddComponent(UITextMeshProUGUIEx, _cp_shareMsg)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
end

function GoldRelicShare:ComponentDestroy()
  self.title = nil
  self._shareMsg = nil
end

function GoldRelicShare:OnLoaded()
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
  local goldCount = tabAttachment.goldCount
  self._shareMsg:SetLocalText("season_s3_coinlevel_share_text_1", string.GetFormattedSeparatorNum(goldCount))
  self.title:SetText("\195\151" .. string.GetFormattedStr2(goldCount))
end

function GoldRelicShare:GetPlayerName()
end

function GoldRelicShare:OnRecycle()
end

return GoldRelicShare
