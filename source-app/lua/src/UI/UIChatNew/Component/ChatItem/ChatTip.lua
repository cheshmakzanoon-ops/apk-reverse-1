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
  local tip = ""
  if _chatdata.tipFlag then
    tip = tostring(_chatdata.tipFlag)
    self._text:SetText(Localization:GetString(tip))
    local maxWidth = 760
    local preferredValues = self._text.unity_tmpro:GetPreferredValues(maxWidth, 0)
    if maxWidth < preferredValues.x then
      self._text.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, maxWidth)
    else
      self._text.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, preferredValues.x)
    end
    self._text.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, preferredValues.y)
    self._text.unity_tmpro:ForceMeshUpdate()
    if self._text.unity_tmpro.textInfo.lineCount > 1 then
      self._text.unity_tmpro.alignment = CS.TMPro.TextAlignmentOptions.TopLeft
    else
      self._text.unity_tmpro.alignment = CS.TMPro.TextAlignmentOptions.Top
    end
    self.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, preferredValues.y)
    self.view.middle.scrollMsgs._scrollView.unity_looplistview2:OnItemSizeChanged(self._chatIndex)
  else
    self._text:SetText("")
  end
end

return ChatTime
