local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatHint = BaseClass("ChatHint", IChatItem)
local base = IChatItem
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")
local _cp_text = "Image/Label"
local _cp_rich_text = "Image/richtext"

function ChatHint:ComponentDefine()
  self._chatData = nil
  self._text = self:AddComponent(UIText, _cp_text)
  self._rich_text = self:AddComponent(UITextMeshProUGUIEx, _cp_rich_text)
  self._rich_text:SetActive(false)
  self._rich_text:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
  self._rich_text:SetText("")
  self._text:SetText("")
end

function ChatHint:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatHint:UpdateItem(_chat_data, _index)
  self._chatIndex = _index
  self._chatData = _chat_data
  if _chat_data == nil then
    return
  end
  local textHeight = 50
  local _message = _chat_data:getMessageWithExtra(false)
  local hasLinkData = _message:find("<link") ~= nil and _message:find("</link>") ~= nil
  if not hasLinkData and _message:find("X:") ~= nil and _message:find("Y:") ~= nil then
    _message = FindAndAppendLinkInfo(_message)
  end
  if hasLinkData or _message:find("<u>") ~= nil and _message:find("</u>") ~= nil then
    self._rich_text:SetText(_message)
    self._text:SetActive(false)
    self._rich_text:SetActive(true)
    textHeight = self._rich_text:GetHeight()
  else
    self._text:SetText(_message)
    self._text:SetActive(true)
    self._rich_text:SetActive(false)
    textHeight = self._text:GetHeight()
  end
  if 50 < textHeight then
    self.rectTransform:Set_sizeDelta(self.rectTransform.sizeDelta.x, textHeight + 5)
  end
end

function ChatHint:OnPointerClick(clickPos)
  if self._rich_text == nil then
    return
  end
  local linkId = self._rich_text:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  local linkMsg = base64.decode(linkId)
  linkMsg = rapidjson.decode(linkMsg)
  GoToUtil.TryJumpToWorld(linkMsg)
end

return ChatHint
