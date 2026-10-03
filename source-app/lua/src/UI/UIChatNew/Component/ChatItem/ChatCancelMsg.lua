local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatCancelMsg = BaseClass("ChatCancelMsg", IChatItem)
local base = IChatItem
local time = 300000
local Localization = CS.GameEntry.Localization
local strFormat = " <color=#249BC5><u><link=\"editor\">%s</link></u></color>"

function ChatCancelMsg:ComponentDefine()
  self._chatData = nil
  self._tmpText = self:AddComponent(UITextMeshProUGUIEx, "richtext")
  self._tmpText:SetText("")
  self._tmpText:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
  local rootNode = self:AddComponent(UIBaseComponent, "Root")
  self.longClickHandler = rootNode.gameObject:GetComponent(typeof(CS.ChatItemFrameClicker))
  self.longClickHandler:SetLongPressAction(function()
    self:HandleLongPress()
  end)
end

function ChatCancelMsg:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatCancelMsg:OnRecycle()
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
end

function ChatCancelMsg:CanShowEditor()
  if not self._chatData or not self._chatData.extra then
    return false
  end
  if not self._chatData.extra.oldPost then
    return false
  end
  if not self._chatData.extra.cancelTime then
    return false
  end
  if self._chatData:isMyChat() and self._chatData.extra.oldPost == PostType.Text_Normal then
    return true
  end
end

function ChatCancelMsg:UpdateItem(_chat_data, _index)
  self._chatIndex = _index
  self._chatData = _chat_data
  if _chat_data == nil then
    return
  end
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
  local textHeight = 50
  local _message = _chat_data:getMessageWithExtra(false)
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWUIActEasterEggChat) then
    local showName = self:GetShowName(_chat_data)
    self._tmpText:SetLocalText("activity_99144_ui_68", showName)
  elseif self:CanShowEditor() then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local netTime = (time - (curTime - self._chatData.extra.cancelTime)) / 1000
    if 1 < netTime then
      local str = string.format(strFormat, Localization:GetString("recall_msg_edit"))
      self._tmpText:SetText(_message .. str)
      self.delay = TimerManager:GetInstance():DelayInvoke(function()
        self._tmpText:SetText(_message)
      end, netTime)
    else
      self._tmpText:SetText(_message)
    end
  else
    self._tmpText:SetText(_message)
  end
  self._tmpText:SetActive(true)
  textHeight = self._tmpText:GetHeight()
  if 50 < textHeight then
    self.rectTransform:Set_sizeDelta(self.rectTransform.sizeDelta.x, textHeight + 5)
  end
end

function ChatCancelMsg:GetShowName(chatData)
  local anonymousData = chatData.extra
  if anonymousData == nil then
    Logger.LogError("\229\164\141\230\180\187\232\138\130\226\128\148\226\128\148\226\128\148chatData\230\178\161\230\156\137extra")
    return ""
  end
  local curAnonymousInfo = string.split(anonymousData.anonymousHead, ";")
  local isAnonymous = tonumber(curAnonymousInfo[3]) == 0
  if not isAnonymous then
    return chatData:getSenderName()
  end
  local name = ""
  if chatData.senderUid == LuaEntry.Player.uid then
    local activityData = DataCenter.ActEasterEggManager:GetActivityData()
    name = activityData.anonymousName
  else
    local lastestAnonymousHead = anonymousData.anonymousHead
    curAnonymousInfo = string.split(lastestAnonymousHead, ";")
    name = curAnonymousInfo[1]
  end
  local showName = DataCenter.ActEasterEggManager:GetTranslateName(name)
  return showName
end

function ChatCancelMsg:OnPointerClick(clickPos)
  if self._tmpText == nil then
    return
  end
  local linkId = self._tmpText:TryGetPointerClickLinkID(clickPos)
  if linkId == "editor" and self._chatData then
    EventManager:GetInstance():Broadcast(EventId.CHAT_CANCELMSG_EDITOR_CLICK, self._chatData.msg)
  end
end

function ChatCancelMsg:UpdateUserInfoWithNew()
  base.UpdateUserInfoWithNew(self)
  if self._chatData == nil or self._chatData.post ~= PostType.MessageRecall then
    return
  end
  self._chatData.attachmentMsg = nil
  self:UpdateItem(self._chatData, self._chatIndex)
end

function ChatCancelMsg:HandleLongPress()
  if self._chatData == nil or self._chatData:isMyChat() then
    return
  end
  local param = {}
  param.chatdata = DeepCopy(self._chatData)
  param.userinfo = nil
  param.targetPos = nil
  param.chatItem = self
  param.onlyEmoji = false
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIChatOperation, {anim = false}, param)
end

return ChatCancelMsg
