local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local DefaultMarchShare = BaseClass("DefaultMarchShare", IChatItemPost)
local base = IChatItemPost
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization

function DefaultMarchShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function DefaultMarchShare:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function DefaultMarchShare:ComponentDefine()
  self.msg = self:AddComponent(UITextMeshProUGUIEx, "msg")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(BindCallback(self, self.OnClickBg))
  self.title = self:AddComponent(UITextMeshProUGUIEx, "banner/title")
  self.title:SetLocalText(110073)
end

function DefaultMarchShare:ComponentDestroy()
  self.title = nil
  self.msg = nil
  self.btn = nil
end

function DefaultMarchShare:OnClickBg()
  GoToUtil.JumpToMarchByUuid(self.marchUuid, self.serverId, self.worldId, self.marchType)
end

function DefaultMarchShare:OnLoaded()
  local chatData = self:ChatData()
  if not chatData then
    return
  end
  local tabAttachment = rapidjson.decode(chatData.attachmentId) or {}
  self.marchUuid = tabAttachment.marchUuid
  self.serverId = tabAttachment.serverId
  self.worldId = tabAttachment.worldId
  self.marchType = tabAttachment.marchType
  local msg = chatData:getMessageWithExtra(true)
  self.msg:SetText(msg)
end

function DefaultMarchShare:GetPlayerName()
end

function DefaultMarchShare:OnRecycle()
end

return DefaultMarchShare
