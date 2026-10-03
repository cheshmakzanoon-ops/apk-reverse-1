local base = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatItemPushRedPacketlMsg = BaseClass("ChatItemPushRedPacketlMsg", base)
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")

function ChatItemPushRedPacketlMsg:OnCreate()
  base.OnCreate(self)
  self.message = self:AddComponent(UITextMeshProUGUIEx, "Assistant/RichTextRoot/RichText")
end

function ChatItemPushRedPacketlMsg:OnDestroy()
  self.message = nil
  base.OnDestroy(self)
end

function ChatItemPushRedPacketlMsg:OnAddListener()
  base.OnAddListener(self)
end

function ChatItemPushRedPacketlMsg:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ChatItemPushRedPacketlMsg:UpdateItem(_chat_data, _index)
  local theRoomData
  self._chatIndex = _index
  self._chatData = _chat_data
  self._roomId = _chat_data.roomId
  if self._chatData.extra ~= nil and self._chatData.extra.customJsonParam ~= nil then
    self.extraJson = rapidjson.decode(self._chatData.extra.customJsonParam)
  end
  self:RefreshView()
end

function ChatItemPushRedPacketlMsg:RefreshView()
  self.message:SetActive(true)
  self.message:SetLocalText("red_pocket_desc19", self.extraJson.senderName, self.extraJson.bestName)
end

return ChatItemPushRedPacketlMsg
