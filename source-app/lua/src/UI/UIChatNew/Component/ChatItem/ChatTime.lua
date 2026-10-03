local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatTime = BaseClass("ChatTime", IChatItem)
local base = IChatItem
local Localization = CS.GameEntry.Localization
local _cp_text = "Image/Text"

function ChatTime:ComponentDefine()
  self._text = self:AddComponent(UIText, _cp_text)
end

function ChatTime:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatTime:UpdateItem(_chatdata)
  if _chatdata == nil then
    return
  end
  local createTime = _chatdata:getCreateTime()
  if _chatdata.timeFlag then
    createTime = _chatdata.timeFlag
  end
  self._text:SetText(UITimeManager:GetInstance():GetChatShowTime(createTime))
end

return ChatTime
