local IChatItem = BaseClass("IChatItem", UIBaseContainer)
local base = UIBaseContainer
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")

function IChatItem:UpdateItem(_chatdata, index)
  self._chatData = _chatdata
  self.index = index
  self:UpdateUserInfoWithNew()
end

function IChatItem:OnAddListener()
  base.OnAddListener(self)
  local ChatEventEnum = _ENV.ChatEventEnum
  self:AddUIListener(EventId.UPDATE_MSG_USERINFO, self.UpdateUserInfoWithNew)
  self:AddUIListener(ChatEventEnum.UPDATE_USER_MSG, self.UpdateMsg)
end

function IChatItem:OnRemoveListener()
  local ChatEventEnum = _ENV.ChatEventEnum
  self:RemoveUIListener(EventId.UPDATE_MSG_USERINFO, self.UpdateUserInfoWithNew)
  self:RemoveUIListener(ChatEventEnum.UPDATE_USER_MSG, self.UpdateMsg)
  base.OnRemoveListener(self)
end

function IChatItem:OnRecycleItem()
end

function IChatItem:addEventTriggerListener(obj)
  if obj then
    obj:OnBeginDrag(function(eventData)
      self.isInDrag = true
      self._contentViewScript.view:OnMainViewBeginDrag(eventData)
      self._contentViewScript.view._chatSlidingNode_mainView:OnBeginDrag(eventData)
      self._contentViewScript.view:CheckHorizontal_BeginDrag(eventData)
    end)
    obj:OnDrag(function(eventData)
      self._contentViewScript.view:OnMainViewDrag(eventData)
      self._contentViewScript.view._chatSlidingNode_mainView:OnDrag(eventData)
      self._contentViewScript.view:CheckHorizontal_Drag(eventData)
    end)
    obj:OnDrag(function(eventData)
      self._contentViewScript.view:OnMainViewDrag(eventData)
      self._contentViewScript.view._chatSlidingNode_mainView:OnDrag(eventData)
      self._contentViewScript.view:CheckHorizontal_Drag(eventData)
    end)
    obj:OnEndDrag(function(eventData)
      self.isInDrag = false
      self._contentViewScript.view:OnMainViewEndDrag(eventData)
      self._contentViewScript.view._chatSlidingNode_mainView:OnEndDrag(eventData)
    end)
  end
end

function IChatItem:UpdateMsg(chatData)
  if self._chatData == nil or chatData == nil or self._contentViewScript == nil then
    return
  end
  local oldResId = self._chatData:getSeqId()
  local newResId = chatData:getSeqId()
  if oldResId == newResId and self._chatData.roomId == chatData.roomId and self._chatData.post == chatData.post then
    self._chatData = chatData
    self:UpdateItem(self._chatData, self.index)
    local roomMgr = ChatManager2:GetInstance().Room
    local roomData = roomMgr:GetRoomData(chatData.roomId)
    if roomData then
      local lastSeqId = roomData:GetLastMsgSeqId()
      if lastSeqId == newResId and self._contentViewScript.ScrollToTail then
        self._contentViewScript:ScrollToTail()
      end
    end
  end
end

function IChatItem:UpdateUserInfoWithNew()
  if self._chatData == nil then
    return
  end
  if self._chatData:isFromAI() then
    local theCharacterData = self._chatData:tryGetAICharacter()
    if theCharacterData ~= nil then
      if self._chatUserName then
        self._chatUserName:UpdateForAI(self._chatData, theCharacterData:GetName())
      end
      if self._chatHead then
        self._chatHead:UpdateForAI(self._chatData, theCharacterData)
      end
    end
    return
  end
  local senderUid = self._chatData.senderUid
  self._userInfo = ChatInterface.getUserData(senderUid)
  if self._chatHead ~= nil then
    local ok, errorMsg = xpcall(function()
      self._chatHead:UpdateHead(self._userInfo, self._chatData)
    end, debug.traceback)
    if not ok then
      local chatIsNull = self._chatHead.chatIsNull
      local chatGameObjectIsNull = self._chatHead.chatGameObjectIsNull
      local chatCreateTime = self._chatHead.chatCreateTime
      local chatDestroyTime = self._chatHead.chatDestroyTime
      local errorStr = "target is Destroyed"
      if chatIsNull ~= nil and chatGameObjectIsNull ~= nil and chatCreateTime ~= nil and chatDestroyTime ~= nil then
        errorStr = "chatIsNull:" .. chatIsNull .. "chatGameObjectIsNull:" .. chatGameObjectIsNull .. "chatCreateTime" .. chatCreateTime .. "chatDestroyTime" .. chatDestroyTime
      end
      local now = UITimeManager:GetInstance():GetServerSeconds()
      local errorMsgStr = "the chatHeadGameObject is Null:" .. errorStr .. errorMsg
      CommonUtil.SendErrorMessageToServer(now, now, errorMsgStr)
      Logger.LogError(errorMsgStr)
    end
  end
  if self._chatUserName then
    self._chatUserName:UpdateName(self._userInfo, self._chatData)
  end
end

function IChatItem:OnCreate()
  base.OnCreate(self)
  self._chatIndex = 0
end

function IChatItem:SetContentViewScript(chatMainView)
  self._contentViewScript = chatMainView
end

function IChatItem:OnDestroy()
  base.OnDestroy(self)
end

function IChatItem:GetTopOffset()
  return 0
end

function IChatItem:UpdateTopOffset()
end

function IChatItem:SetTransPosY(rectTrans, posY, bottomY)
  local posX, _ = rectTrans:Get_anchoredPosition()
  rectTrans:Set_anchoredPosition(posX, posY)
  local minX, _ = rectTrans:Get_offsetMin()
  bottomY = bottomY or 0
  rectTrans:Set_offsetMin(minX, bottomY)
end

local function addLinkByKeyword_EN(txt, theFAQs)
  local ret = txt
  local pat
  local cnt = 0
  local flag = {}
  local index = 1
  local linkId
  local link = {action = "OpenUI"}
  local format_template = "<color=\"blue\"><link=\"%s\"><u>%s</u></link></color>"
  for ui_key, FAQ in pairs(theFAQs) do
    local key = FAQ:GetKey()
    if not (#key > #txt) then
      link.faq = ui_key
      linkId = base64.encode(rapidjson.encode(link))
      if #key == #txt and string.upper(key) == string.upper(txt) then
        return string.format(format_template, linkId, txt)
      end
      key = case_insensitive_pattern(key)
      pat = "([%s%p%c])(" .. key .. ")([%s%p%c])"
      ret, cnt = string.gsub(ret, pat, function(prefix, k, suffix)
        local tmp = "@@#" .. index .. "#@@"
        flag[tmp] = string.format(format_template, linkId, k)
        index = index + 1
        return prefix .. tmp .. suffix
      end)
      while 0 < cnt do
        ret, cnt = string.gsub(ret, pat, function(prefix, k, suffix)
          local tmp = "@@#" .. index .. "#@@"
          flag[tmp] = string.format(format_template, linkId, k)
          index = index + 1
          return prefix .. tmp .. suffix
        end)
      end
      pat = "^(" .. key .. ")([^%w@])"
      ret = string.gsub(ret, pat, function(k, suffix)
        local tmp = "@@#" .. index .. "#@@"
        flag[tmp] = string.format(format_template, linkId, k)
        index = index + 1
        return tmp .. suffix
      end)
      pat = "([^%w@])(" .. key .. ")$"
      ret = string.gsub(ret, pat, function(prefix, k)
        local tmp = "@@#" .. index .. "#@@"
        flag[tmp] = string.format(format_template, linkId, k)
        index = index + 1
        return prefix .. tmp
      end)
    end
  end
  for k, v in pairs(flag) do
    ret = string.gsub(ret, k, v)
  end
  return ret
end

function IChatItem:TryParserFaqMessage(msg)
  if msg ~= nil and msg ~= "" then
    local lang = ChatInterface.getLanguageName()
    local theFAQs = DataCenter.LWChatAIManager:GetFaqList()
    if theFAQs ~= nil then
      local message = FindAndAppendLinkInfo(msg)
      local linkId
      local link = {action = "OpenUI"}
      if lang == "en" then
        message = addLinkByKeyword_EN(message, theFAQs)
      else
        for k, v in pairs(theFAQs) do
          if v:CanUse() then
            message = string.gsub(message, v:GetKey(), function(txt)
              link.faq = k
              linkId = base64.encode(rapidjson.encode(link))
              return string.format("<color=\"blue\"><link=\"%s\"><u>%s</u></link></color>", linkId, txt)
            end)
          end
        end
      end
      if message ~= msg then
        return string.cleanNestingTag(string.cleanNestingTag(message, "link"), "u")
      end
      return msg
    end
  end
  return msg
end

function IChatItem:HandleFaqMessage(linkMsg)
  if linkMsg == nil or linkMsg.action ~= "OpenUI" or linkMsg.faq == nil then
    return false
  end
  local theFAQ = DataCenter.LWChatAIManager:GetFaqByKey(linkMsg.faq)
  if theFAQ ~= nil then
    return theFAQ:OpenUI()
  end
  return false
end

function IChatItem:CheckTopViewSlideStateWhenClick()
  if not self.view then
    return false
  end
  if self.view._isAnim then
    return false
  end
  if self.view._isLeft then
    self.view:SlideRight()
    return false
  end
  return true
end

function IChatItem:GetChatItemMaxWidth()
  local _screenWidth = 750 / Screen.height * Screen.width
  return _screenWidth * 0.645 + 250
end

function IChatItem:OnRecycleItem()
end

return IChatItem
