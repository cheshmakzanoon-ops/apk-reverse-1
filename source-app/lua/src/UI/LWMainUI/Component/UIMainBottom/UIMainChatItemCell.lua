local UIMainChatItemCellItem = BaseClass("UIMainChatItemCellItem", UIBaseContainer)
local base = UIBaseContainer
local py1 = -75
local py2 = -20
local py3 = 10
local py4 = 90
local px = -197
local chat_max_width = 402
local chat_text_gap_x = 0
local chat_text_height = 41
local ChatTextIndex = {
  ChatTextIndex_1 = 1,
  ChatTextIndex_2 = 2,
  ChatTextIndex_3 = 3
}
local chat_obj1_path = "ChatObj_1"
local chat_obj2_path = "ChatObj_2"
local chat_obj3_path = "ChatObj_3"
local name_text1_path = "ChatObj_1/ChatDialogName01"
local name_text2_path = "ChatObj_2/ChatDialogName02"
local name_text3_path = "ChatObj_3/ChatDialogName03"
local content_text1_path = "ChatObj_1/ChatDialogText01"
local content_text2_path = "ChatObj_2/ChatDialogText02"
local content_text3_path = "ChatObj_3/ChatDialogText03"
local mid_text1_path = "ChatObj_1/ChatDialogMid01"
local mid_text2_path = "ChatObj_2/ChatDialogMid02"
local mid_text3_path = "ChatObj_3/ChatDialogMid03"

function UIMainChatItemCellItem:OnCreate()
  base.OnCreate(self)
  self.infos = {}
  self.chat_obj1 = self:AddComponent(UIBaseContainer, chat_obj1_path)
  self.chat_obj2 = self:AddComponent(UIBaseContainer, chat_obj2_path)
  self.chat_obj3 = self:AddComponent(UIBaseContainer, chat_obj3_path)
  self.name_text1 = self:AddComponent(UITextMeshProUGUIEx, name_text1_path)
  self.name_text2 = self:AddComponent(UITextMeshProUGUIEx, name_text2_path)
  self.name_text3 = self:AddComponent(UITextMeshProUGUIEx, name_text3_path)
  self.content_text1 = self:AddComponent(UITextMeshProUGUIEx, content_text1_path)
  self.content_text2 = self:AddComponent(UITextMeshProUGUIEx, content_text2_path)
  self.content_text3 = self:AddComponent(UITextMeshProUGUIEx, content_text3_path)
  self.mid_text1 = self:AddComponent(UITextMeshProUGUIEx, mid_text1_path)
  self.mid_text2 = self:AddComponent(UITextMeshProUGUIEx, mid_text2_path)
  self.mid_text3 = self:AddComponent(UITextMeshProUGUIEx, mid_text3_path)
end

function UIMainChatItemCellItem:InitEmojiText()
  for i = 1, 3 do
    ChatInterface.SetEmojiTextProperty(self["name_text" .. i])
    ChatInterface.SetEmojiTextProperty(self["content_text" .. i])
    ChatInterface.SetEmojiTextProperty(self["mid_text" .. i])
    self["name_text" .. i]:SetRichText(true)
    self["content_text" .. i]:SetRichText(true)
    self["mid_text" .. i]:SetRichText(true)
  end
end

function UIMainChatItemCellItem:OnDestroy()
  self.infos = nil
  base.OnDestroy(self)
end

function UIMainChatItemCellItem:OnEnable()
  base.OnEnable(self)
end

function UIMainChatItemCellItem:OnDisable()
  base.OnDisable(self)
end

function UIMainChatItemCellItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlayerMessageInfo, self.UpdateDataUserInfo)
end

function UIMainChatItemCellItem:OnRemoveListener()
  self:RemoveUIListener(EventId.PlayerMessageInfo, self.UpdateDataUserInfo)
  base.OnRemoveListener(self)
end

function UIMainChatItemCellItem:UpdateDataUserInfo(uid)
  if not self.infos or table.count(self.infos) == 0 then
    return
  end
  for i, info in pairs(self.infos) do
    if info.uid == uid then
      local _userinfo = ChatInterface.getUserData(uid)
      local name = _userinfo:GetUserName()
      if not string.IsNullOrEmpty(name) then
        self:RefreshName(info.index, name)
      end
    end
  end
end

function UIMainChatItemCellItem:StopChatAnim()
end

function UIMainChatItemCellItem:SetTextAlpha(text, alpha)
  if text ~= nil then
    text:SetAlpha(alpha)
  end
end

function UIMainChatItemCellItem:ShowChatAnim()
end

local function deleteLinkTags(tagStart, content, tagEnd)
  return content or ""
end

function UIMainChatItemCellItem:SetChatTextAndColor(chatIndex, nameStr, contentStr, color, chat)
  local nameText = self["name_text" .. chatIndex]
  local contentText = self["content_text" .. chatIndex]
  local midText = self["mid_text" .. chatIndex]
  if contentText ~= nil and nameText ~= nil and midText ~= nil then
    nameText:SetText(nameStr)
    midText:SetActive(not string.IsNullOrEmpty(nameText) and not string.IsNullOrEmpty(contentStr))
    local preferredValues = nameText.unity_tmpro:GetPreferredValues()
    nameText.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, preferredValues.x)
    local textW = nameText:GetWidth()
    local contentW = chat_max_width - chat_text_gap_x - textW
    contentText.rectTransform:Set_sizeDelta(contentW, chat_text_height)
    if string.IsNullOrEmpty(contentStr) then
      contentText:SetText("")
    else
      local hasLinkData = contentStr:find("<link") ~= nil and contentStr:find("</link>") ~= nil
      contentStr = string.filterRichText(contentStr)
      if hasLinkData then
        local newText, count = string.gsub(contentStr, "(<link.*>)(.*)(</link>)", deleteLinkTags)
        contentText:SetText_NotNative(newText)
      else
        contentText:SetText_NotNative(contentStr)
      end
    end
    if color ~= nil then
      nameText:SetColor(color)
      contentText:SetColor(color)
      midText:SetColor(color)
    end
  end
  if chat and not chat.isEmpty then
    if not self.infos[chatIndex] then
      self.infos[chatIndex] = {}
    end
    self.infos[chatIndex] = {
      uid = chat.uid,
      index = chatIndex,
      seqId = chat.seqId,
      roomId = chat.roomId
    }
  end
end

function UIMainChatItemCellItem:GetDataById(roomId, seqId)
  if not self.infos then
    return
  end
  for i, info in pairs(self.infos) do
    if info.roomId == roomId and seqId == info.seqId then
      return true
    end
  end
end

function UIMainChatItemCellItem:GetDataByIdDict(roomId, seqIdDict)
  if not self.infos then
    return
  end
  for i, info in pairs(self.infos) do
    if info.roomId == roomId and seqIdDict[info.seqId] then
      return true
    end
  end
end

function UIMainChatItemCellItem:RefreshName(index, name)
  if self.infos[index] == nil then
    return
  end
  local nameText = self["name_text" .. index]
  local contentText = self["content_text" .. index]
  nameText:SetText(name)
  local preferredValues = nameText.unity_tmpro:GetPreferredValues()
  nameText.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, preferredValues.x)
  local textW = nameText.rectTransform.sizeDelta.x
  local contentW = chat_max_width - chat_text_gap_x - textW
  contentText.rectTransform:Set_sizeDelta(contentW, chat_text_height)
end

return UIMainChatItemCellItem
