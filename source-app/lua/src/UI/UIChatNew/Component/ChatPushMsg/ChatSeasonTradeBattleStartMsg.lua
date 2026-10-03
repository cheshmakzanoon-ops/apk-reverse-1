local base = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatSeasonTradeBattleStartMsg = BaseClass("ChatSeasonTradeBattleStartMsg", base)
local rapidjson = require("rapidjson")
local rich_text_path = "Assistant/RichTextRoot/RichText"

function ChatSeasonTradeBattleStartMsg:OnCreate()
  base.OnCreate(self)
  self.message = self:AddComponent(UITextMeshProUGUIEx, rich_text_path)
end

function ChatSeasonTradeBattleStartMsg:OnDestroy()
  self.message = nil
  base.OnDestroy(self)
end

function ChatSeasonTradeBattleStartMsg:GetJsonObj()
  if self._chatData and self._chatData.extra and self._chatData.extra.customJsonParam then
    return rapidjson.decode(self._chatData.extra.customJsonParam)
  end
  return nil
end

function ChatSeasonTradeBattleStartMsg:UpdateItem(_chat_data, _index)
  self._chatIndex = _index
  self._chatData = _chat_data
  self._roomId = _chat_data.roomId
  self._msgSeq = tostring(self._chatData.seqId)
  local _message = _chat_data:getSuperParsedResult()
  if _message == nil then
    _message = _chat_data:getMessageWithExtra(false)
  end
  self.message:SetActive(false)
  self.message:SetText(_message)
  self.message:SetActive(true)
end

return ChatSeasonTradeBattleStartMsg
