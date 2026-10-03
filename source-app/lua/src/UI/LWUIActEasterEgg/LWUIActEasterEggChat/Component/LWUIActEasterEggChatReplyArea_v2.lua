local base = UIBaseContainer
local LWUIActEasterEggChatReplyArea_v2 = BaseClass("LWUIActEasterEggChatReplyArea_v2", base)
local M = LWUIActEasterEggChatReplyArea_v2
local compBook = {
  {
    path = "board/txtReplyH",
    name = "txtReplyH",
    type = UIText
  },
  {
    path = "board/btnClose",
    name = "btnClose",
    type = UIButton,
    onClick = function(self)
      self:OnClickClose()
    end
  }
}

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function M:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self:DefineCompsByBook(compBook)
  local dlgComponent = ChatInterface.isTestingServer() and UITextMeshProUGUIEx or UIText
  self.txtReply = self:AddComponent(dlgComponent, "board/txtReply")
  if ChatInterface.isTestingServer() then
    ChatInterface.SetEmojiTextProperty(self.txtReply)
  end
end

function M:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function M:SetReply(chatMsg)
  if not chatMsg then
    return
  end
  local userInfo = ChatInterface.getUserData(chatMsg.senderUid)
  local anonymousData = chatMsg.extra
  if anonymousData == nil then
    Logger.LogError("\229\164\141\230\180\187\232\138\130\226\128\148\226\128\148\226\128\148chatData\230\178\161\230\156\137extra")
    return
  end
  if anonymousData.anonymousHead == nil then
    Logger.LogError("\229\164\141\230\180\187\232\138\130\226\128\148\226\128\148\226\128\148chatData\231\154\132extra \228\184\173\230\178\161\230\156\137 anonymousHead")
    return
  end
  local curAnonymousInfo = string.split(anonymousData.anonymousHead, ";")
  local isAnonymous = tonumber(curAnonymousInfo[3]) == 0
  if isAnonymous then
    local name
    if self.uid == LuaEntry.Player.uid then
      local activityData = DataCenter.ActEasterEggManager:GetActivityData()
      name = activityData.anonymousName
    else
      local lastestAnonymousHead = userInfo.curAnonymousHead or anonymousData.anonymousHead
      curAnonymousInfo = string.split(lastestAnonymousHead, ";")
      name = curAnonymousInfo[1]
    end
    local showName = DataCenter.ActEasterEggManager:GetTranslateName(name)
    local text = showName .. ": " .. ChatManager2:GetReplyMsgByChatMsg(chatMsg)
    self.txtReply:SetText(text)
  else
    local text = userInfo.userName .. ": " .. ChatManager2:GetReplyMsgByChatMsg(chatMsg)
    self.txtReply:SetText(text)
  end
end

function M:GetReplyMsgHeight(chatMsg)
  if not chatMsg then
    return 100
  end
  local sender = ChatInterface.getUserData(chatMsg.senderUid)
  if not sender then
    return 100
  end
  local text = sender.userName .. ": " .. ChatManager2:GetReplyMsgByChatMsg(chatMsg)
  self.txtReplyH:SetText(text)
  self.txtReplyH:SetActive(false)
  self.txtReplyH:SetActive(true)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.txtReplyH.rectTransform)
  return self.txtReplyH.rectTransform.rect.height
end

function M:OnClickClose()
  EventManager:GetInstance():Broadcast(EventId.SetReplyChatMsg, nil)
end

return M
