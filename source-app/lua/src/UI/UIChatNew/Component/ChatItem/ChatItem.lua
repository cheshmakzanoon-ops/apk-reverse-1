local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatViewController = require("UI.UIChatNew.Controller.ChatViewUtils")
local ChatItem = BaseClass("ChatItem", IChatItem)
local base = IChatItem
local Localization = CS.GameEntry.Localization
local ChatHead = require("UI.UIChatNew.Component.ChatHead")
local ChatDataEmojiItem = require("UI.UIChatNew.Component.ChatItem.ChatDataEmojiItem")
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")
local _cp_chatShareStarRoot = "ChatAnchor/ChatShareNode/Image/starList"
local color_bg_path = "ChatAnchor/ChatShareNode/Image/starList/colorBg"
local color_icon_path = "ChatAnchor/ChatShareNode/Image/starList/colorBg/colorIcon"
local my_color_bg_path = "ChatAnchor/ChatShareNode/Image/starList/myColorBg"
local my_color_icon_path = "ChatAnchor/ChatShareNode/Image/starList/myColorBg/myColorIcon"
local emojiHight = 55
local emojiOffset = 30
local minLikeWidht = 240
local replyGapHight = 22
local emojiLikeDefaultHeight = 79
local replyDefaulHight = 45
local replyBgMaxWidht = 50

function ChatItem:OnCreate()
  base.OnCreate(self)
end

function ChatItem:ComponentDefine()
  self._chatHead = self:AddComponent(ChatHead, "ChatHead")
  self._chatHeadBg = self:AddComponent(UIImage, "ChatHead/HeadBtn")
  self._chatHeadFg = self:AddComponent(UIImage, "ChatHead/Foreground")
  if self.transform:Find(_cp_chatShareStarRoot) ~= nil then
    self._chatShareStarRoot = self:AddComponent(UIBaseComponent, _cp_chatShareStarRoot)
    self._chatShareStarRoot:SetActive(false)
    local _chatShareStarList = {}
    local starNode
    for i = 1, 5 do
      starNode = self:AddComponent(UIImage, "ChatAnchor/ChatShareNode/Image/starList/star" .. i)
      table.insert(_chatShareStarList, starNode)
    end
    self._chatShareStarList = _chatShareStarList
    if self.transform:Find(color_bg_path) ~= nil then
      self.colorBg = self:AddComponent(UIBaseComponent, color_bg_path)
      self.colorIcon = self:AddComponent(UIImage, color_icon_path)
      self.colorBg:SetActive(false)
    end
    if self.transform:Find(my_color_bg_path) ~= nil then
      self.myColorBg = self:AddComponent(UIBaseComponent, my_color_bg_path)
      self.myColorIcon = self:AddComponent(UIImage, my_color_icon_path)
      self.myColorBg:SetActive(false)
    end
  end
end

function ChatItem:AddBtnClick()
  if self._bgBtn then
    self._bgBtn:SetOnClick(BindCallback(self, self.ExecuteChatEvent))
  end
  if self._chatShareNode then
    self._chatShareNode:SetOnClick(BindCallback(self, self.ExecuteChatEvent))
  end
  if self.btnNormalMsg then
    self.btnNormalMsg:SetOnClick(BindCallback(self, function(self)
      if not self:CheckTopViewSlideStateWhenClick() then
        return
      end
      if not self.isInDrag then
        self._contentViewScript._scrollView_ScrollRect:StopMovement()
        self:ShowChatOperator()
      end
    end))
  end
end

function ChatItem:ShowChatOperator()
  if self._chatData and self._chatData:IsLWEmoji() then
    return
  end
  local param = {}
  param.chatdata = DeepCopy(self._chatData)
  param.userinfo = self._userInfo
  param.targetPos = self._bgImg.transform
  param.chatItem = self
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIChatOperation, {anim = false}, param)
end

function ChatItem:OnAddListener()
  base.OnAddListener(self)
  local ChatEventEnum = _ENV.ChatEventEnum
  self:AddUIListener(ChatEventEnum.CHAT_UPDATE_ROOM_MSG, self.UpdateItemWithNew)
  self:AddUIListener(ChatEventEnum.CHAT_TRANSLATE_SETTING, self.UpdateTransLateMsg)
  self:AddUIListener(ChatEventEnum.CHAT_TRANSLATE_ITEM, self.OnTranslateItem)
end

function ChatItem:OnRemoveListener()
  local ChatEventEnum = _ENV.ChatEventEnum
  self:RemoveUIListener(ChatEventEnum.CHAT_UPDATE_ROOM_MSG, self.UpdateItemWithNew)
  self:RemoveUIListener(ChatEventEnum.CHAT_TRANSLATE_SETTING, self.UpdateTransLateMsg)
  self:RemoveUIListener(ChatEventEnum.CHAT_TRANSLATE_ITEM, self.OnTranslateItem)
  base.OnRemoveListener(self)
end

function ChatItem:OnTranslateItem(chatInfo)
  if not chatInfo then
    return
  end
  if self._chatData.roomId == chatInfo.roomId and self._chatData.seqId == chatInfo.seqId then
    self:OnTranslationBtn()
  end
end

function ChatItem:OnDisable()
  base.OnDisable(self)
end

function ChatItem:OnDestroy()
  if self.emoji_like_layout then
    self.emoji_like_layout:RemoveComponents(ChatDataEmojiItem)
  end
  if self.emoji_like_item then
    self.emoji_like_item.gameObject:GameObjectRecycleAll()
  end
  base.OnDestroy(self)
end

function ChatItem:OnTranslationBtn()
  self:TranslateMsg()
end

function ChatItem:DataDefine()
  self._originDlgFontSize = 20
  self._targetSize = Vector2.New(0, 0)
  self.IsMyChat = true
  self._chatData = nil
  self.isShareError = nil
end

function ChatItem:SetSize(_size)
  local _, anchor_sizeDelta_cy = self._anchorTransform:Get_sizeDelta()
  local rect_sizeDelta_cx, _ = self._rectTransform:Get_sizeDelta()
  local remarkTimeHight = 0
  if self.remarkTimeText then
    remarkTimeHight = 60
  end
  local temphight = 0
  if self.hasUp then
    temphight = emojiHight
  end
  self._rectTransform:Set_sizeDelta(rect_sizeDelta_cx, Mathf.Ceil(_size.y) + remarkTimeHight)
  self._chatShareNode.rectTransform:Set_sizeDelta(_size.x, _size.y - 20)
  self._anchorTransform:Set_sizeDelta(Mathf.Ceil(_size.x), _size.y)
  self:SetTransPosY(self._anchorTransform, 0)
  self:SetTransPosY(self._chatShareNode.rectTransform, -37, 2)
end

function ChatItem:GetTopOffset()
  return 0
end

function ChatItem:GetSize()
  local anchor_sizeDelta_cx, _ = self._anchorTransform:Get_sizeDelta()
  local _, rect_sizeDelta_cy = self._rectTransform:Get_sizeDelta()
  return Vector2.New(anchor_sizeDelta_cx, rect_sizeDelta_cy)
end

function ChatItem:SetChatShareNodeVisible(isVisible)
  if self._chatShareNode ~= nil and self._chatShareNode.gameObject.activeSelf ~= isVisible then
    self._chatShareNode:SetActive(isVisible)
  end
end

function ChatItem:SetBackGroundVisible(isVisible)
  if self._bgImg ~= nil and self._bgImg.gameObject.activeSelf ~= isVisible then
    self._bgImg.gameObject:SetActive(isVisible)
  end
end

function ChatItem:UpdateBgImgSize()
  if not self._chatData.isMyChat then
    if self._chatData.translateState or not string.IsNullOrEmpty(self._chatData.translateMsg) then
      local _size = self:GetSize()
      self._bgImg.transform:GetComponent(typeof(CS.UnityEngine.RectTransform)):SetInsetAndSizeFromParentEdge(CS.UnityEngine.RectTransform.Edge.Bottom, 32, _size.y - 52)
    else
      local _size = self:GetSize()
      self._bgImg.transform:GetComponent(typeof(CS.UnityEngine.RectTransform)):SetInsetAndSizeFromParentEdge(CS.UnityEngine.RectTransform.Edge.Bottom, 0, _size.y - 20)
    end
  end
end

function ChatItem:ExecuteChatEvent()
  if not self:CheckTopViewSlideStateWhenClick() then
    return
  end
  if self.isInDrag == true then
    return
  end
  if self._chatData.post == 43 or self._chatData.msg == "90800159" or self._chatData.msg == "90800185" then
    return
  end
  if self._chatData.post > 0 then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_EXECUTE_CMD, self._chatData)
  else
    self:ShowTips()
  end
end

function ChatItem:IsSharePoint()
  if self._chatData.post == PostType.Text_PointShare or self._chatData.post == PostType.Text_PointShare_Alliance or self._chatData.post == PostType.Text_Favour_Point_Share or self._chatData.post == PostType.March or self._chatData.post == PostType.SuppliesPositionShare then
    return true
  else
    return false
  end
end

function ChatItem:IsShareStorageShop()
  if self._chatData.post == PostType.Text_StorageShopShare then
    return true
  else
    return false
  end
end

function ChatItem:ShowTips()
  ChatPrint("\229\176\154\230\156\170\229\174\158\231\142\176\230\139\183\232\180\157\229\138\159\232\131\189")
end

function ChatItem:TryReportMsg()
end

function ChatItem:CopyMsg()
end

function ChatItem:TranslateMsg()
  if self._chatData:IsTranslating() then
    return
  end
  self._chatData:setTranslateState(1)
  local _translationMsg = self._chatData:getTranslationMsg()
  if string.IsNullOrEmpty(_translationMsg) or self._chatData.translatedLang ~= ChatInterface.GetChatTranslateLanguageAbbr() then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_TRANSLATE, self._chatData)
  else
    self._chatData:setTranslateState(0)
  end
  self:UpdateItem(self._chatData)
  self._contentViewScript:ReloadAfterTranslateRecv(self._chatIndex)
end

function ChatItem:TranslateMsgThenChangeType()
  self._chatData:setTranslateState(1)
  local transType = self._chatData:GetTranslateType()
  if transType == nil then
    transType = 1
  elseif transType == 0 then
    transType = 1
  elseif transType == 1 then
    transType = 0
  end
  self._chatData:SetTranslateType(transType)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_TRANSLATE, self._chatData)
  self:UpdateItem(self._chatData)
  self._contentViewScript:ReloadAfterTranslateRecv(self._chatIndex)
end

function ChatItem:UpdateTransLateMsg()
  self:UpdateItem(self._chatData)
  self._contentViewScript:ReloadAfterTranslateRecv(self._chatIndex)
end

function ChatItem:UpdateItemWithNew(t)
  if t == nil then
    return
  end
  if t.roomId == self._chatData.roomId and t.seqId == self._chatData.seqId then
    local room = ChatInterface.getRoomData(t.roomId)
    if room ~= nil then
      local chatData = room:getChatDataBySeqId(t.seqId)
      if chatData then
        self:UpdateItem(chatData)
      end
      self._contentViewScript:ReloadAfterTranslateRecv(self._chatIndex)
    end
  end
end

function ChatItem:ReSendMsg()
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_RESEND_ROOM_MSG_COMMAND, self._chatData)
end

function ChatItem:UpdateSharePoint()
  if self._chatShareNode == nil then
    return
  end
  self:SetChatShareNodeVisible(true)
  self:SetBackGroundVisible(false)
  self:SetEmojiVisible(false)
  self._chatShareIcon:SetActive(false)
  if self._chatShareSpecialIcon then
    self._chatShareSpecialIcon:SetActive(false)
  end
  local message = self._chatData:getMessageWithExtra(true)
  message = string.gsub(message, "[(]", "<u>(")
  message = string.gsub(message, "[)]", ")</u>")
  self._chatShareMsg:SetAlignment(CS.TMPro.TextAlignmentOptions.TopLeft)
  self._chatShareMsg:SetText(message)
  self._chatShareSubTitle:SetText("")
  if self._chatShareStarRoot and self._chatShareStarList and self._chatData.dispatchTaskStar ~= nil then
    self._chatShareTitle:SetLocalText(456288)
    self._chatShareStarRoot:SetActive(true)
    local taskStarLevel = self._chatData.dispatchTaskStar
    for i, v in ipairs(self._chatShareStarList) do
      if v then
        v:SetActive(i <= taskStarLevel)
      end
    end
    if self._chatData.dispatchTaskColor ~= nil then
      local iconPath = ""
      if self._chatData.dispatchTaskColor == 3 then
        iconPath = "Assets/Main/Sprites/UI/UIChatNew3/lrb_liaotian_yinmirenwu_title_lan.png"
      elseif self._chatData.dispatchTaskColor == 4 then
        iconPath = "Assets/Main/Sprites/UI/UIChatNew3/lrb_liaotian_yinmirenwu_title_zi.png"
      elseif self._chatData.dispatchTaskColor == 5 then
        iconPath = "Assets/Main/Sprites/UI/UIChatNew3/lrb_liaotian_yinmirenwu_title_cheng.png"
      end
      if string.IsNullOrEmpty(iconPath) then
        if self.colorBg then
          self.colorBg:SetActive(false)
        end
        if self.myColorBg then
          self.myColorBg:SetActive(false)
        end
      elseif self.IsMyChat then
        if self.colorBg then
          self.colorBg:SetActive(false)
        end
        if self.myColorBg then
          self.myColorBg:SetActive(true)
        end
        if self.myColorIcon then
          self.myColorIcon:LoadSprite(iconPath)
        end
      else
        if self.colorBg then
          self.colorBg:SetActive(true)
        end
        if self.myColorBg then
          self.myColorBg:SetActive(false)
        end
        if self.colorIcon then
          self.colorIcon:LoadSprite(iconPath)
        end
      end
    else
      if self.colorBg then
        self.colorBg:SetActive(false)
      end
      if self.myColorBg then
        self.myColorBg:SetActive(false)
      end
    end
  else
    if self._chatShareStarRoot then
      self._chatShareStarRoot:SetActive(false)
    end
    self._chatShareTitle:SetLocalText(110073)
  end
  if self._chatData.post == PostType.March then
    self._chatShareIcon:SetActive(true)
    local param = rapidjson.decode(self._chatData.attachmentId)
    self._chatShareIcon:LoadSprite(QualityImagePath[param.quality])
    self._chatShareSubTitle:SetLocalText(457601)
    if not string.IsNullOrEmpty(param.specialIconPath) and self._chatShareSpecialIcon then
      self._chatShareSpecialIcon:SetActive(true)
      self._chatShareSpecialIcon:LoadSprite(param.specialIconPath)
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self._chatShareMsgNode.rectTransform)
  if not self._chatShareMsg and not self.isShareError then
    self.isShareError = true
  end
  if self._chatShareMsg and self._chatShareMsg.rectTransform then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self._chatShareMsg.rectTransform)
    local height = self._chatShareMsg:GetHeight()
    height = height or 50
    self:SetSize(Vector2.New(500, height + 110))
  end
end

function ChatItem:UpdateRedPack()
  if self:IsRedPack() then
    local _gift = self._bgImg.transform:Find("GiftText")
    if _gift ~= nil then
      _gift:GetComponent(typeof(CS.UnityEngine.UI.Text)).text = Localization:GetString("79010922")
    end
    self:SetSize(Vector2.New(300, 166))
  end
end

function ChatItem:UpdateLike()
  self:SetChatShareNodeVisible(false)
  self:SetBackGroundVisible(false)
  self:SetSize(Vector2.New(300, self:GetChatMinHeight()))
end

function ChatItem:IsRedPack()
  return self._chatData:isRedPack()
end

function ChatItem:IsShowTranslationButton()
  if self.IsMyChat then
    return false
  end
  if self._chatData:isShowTranslateBtn() == false then
    return false
  end
  if not string.IsNullOrEmpty(self._chatData:getTranslationMsg()) then
    return false
  end
  return true
end

function ChatItem:IsLikeChat()
  if self._chatData.msg == "\\like" then
    return true
  end
  return false
end

function ChatItem:GetChatMinHeight()
  return 120
end

function ChatItem:IsVip()
  return false
end

function ChatItem:UpdateText()
  self:SetChatShareNodeVisible(false)
  self:SetEmojiVisible(false)
  self:SetBackGroundVisible(true)
  if self._dlgText ~= nil then
    self._dlgText.gameObject:SetActive(true)
  end
  local maxWidth = self:GetChatItemMaxWidth()
  if self.remarkTimeText then
    maxWidth = maxWidth + 50
  end
  local minHeight = self:GetChatMinHeight()
  self:SetSize(Vector2.New(maxWidth, minHeight))
  local message = self._chatData:getSuperParsedResult()
  if message == nil then
    message = self._chatData:getMessageWithExtra(false)
    self._chatData:setSuperParsedResult(message)
  end
  if not self._noticeTitle then
    if ChatInterface.isTestingServer() and self._chatData.post == PostType.Text_Normal then
      self._dlgText:SetAlignment(CS.TMPro.TextAlignmentOptions.TopLeft)
    else
      self._dlgText:SetAlignment(CS.UnityEngine.TextAnchor.UpperLeft)
    end
  end
  self._dlgText:SetText(message)
  local textWidth, textHeight
  if ChatInterface.isTestingServer() and self._chatData.post == PostType.Text_Normal then
    local v2 = self._dlgText:GetPreferredValues(maxWidth - 64, 0)
    if maxWidth < v2.x then
      textWidth = maxWidth
    else
      textWidth = v2.x
    end
    textHeight = v2.y
  else
    textWidth = self._dlgText:GetWidth()
    textHeight = self._dlgText:GetHeight()
  end
  local isLog = true
  if not textHeight then
    if self._chatData then
      isLog = false
      Logger.LogError("not textComponent post : " .. self._chatData.post .. "roomId : " .. self._chatData.roomId .. "seqId : " .. self._chatData.seqId)
    end
    textHeight = 0
  end
  if not textWidth then
    if isLog then
      Logger.LogError("not textComponent post : " .. self._chatData.post .. "roomId : " .. self._chatData.roomId .. "seqId : " .. self._chatData.seqId)
    end
    textWidth = 0
  end
  local topHeight = 50
  local hasTranslated = false
  if not self.IsMyChat and self._traText ~= nil and self._dividingLine ~= nil then
    self._traText:SetActive(false)
    self._dividingLine:SetActive(false)
    local isTranslating = self._chatData:IsTranslating()
    local translationMsg = self._chatData.translateMsg
    if not string.IsNullOrEmpty(translationMsg) and self._chatData.translatedLang == ChatInterface.GetChatTranslateLanguageAbbr() then
      hasTranslated = self._chatData:GetTranslateState() == 2
      self._traText:SetActive(true)
      if ChatInterface.isTestingServer() and self._chatData.post == PostType.Text_Normal then
        self._traText:SetAlignment(CS.TMPro.TextAlignmentOptions.TopLeft)
      else
        self._traText:SetAlignment(CS.UnityEngine.TextAnchor.UpperLeft)
      end
      self._traText:SetText(translationMsg)
      self._dividingLine:SetActive(true)
      textHeight = textHeight or 0
      local traTextWidth, traTextHight
      if ChatInterface.isTestingServer() and self._chatData.post == PostType.Text_Normal then
        local v2 = self._traText:GetPreferredValues(maxWidth - 64, 0)
        if maxWidth < v2.x then
          traTextWidth = maxWidth
        else
          traTextWidth = v2.x
        end
        traTextHight = v2.y
      else
        traTextWidth = self._traText:GetWidth()
        traTextHight = self._traText:GetHeight()
      end
      textWidth = Mathf.Max(textWidth, traTextWidth)
      self._dividingLine.transform.localPosition = Vector3.New(0, -textHeight - 10, 0)
      local transLocalPos = self._traText.transform.localPosition
      local replyHight = self._chatData.replyMsg and replyDefaulHight or 0
      self._traText.transform.localPosition = Vector3.New(transLocalPos.x, -textHeight - 40 - replyHight - (self._chat_item_height_add or 0), transLocalPos.z)
      textHeight = textHeight + traTextHight + 20
    end
    self:UpdateTranslateBtnState(isTranslating, hasTranslated)
  end
  textHeight = textHeight and textHeight + 10
  if self.remarkTimeText then
    self.remarkTimeText:SetText(UITimeManager:GetInstance():GetChatShowTime(math.floor(self._chatData.serverTime / 1000)))
  end
  local _width = Mathf.Min(textWidth + 19 + 41 + 4, maxWidth)
  _width = self._chat_item_width_fix or _width
  local _height = Mathf.Max(textHeight + 16 + topHeight, minHeight) + (self._chat_item_height_add or 0)
  local _anchorBottomOffset, width = self:UpdateReplyNode(_width)
  local emojiHeight = self.hasUp and emojiHight or 0
  local emojiMinWidht = self.hasUp and minLikeWidht or 0
  local bgWidth = math.max(width, _width, emojiMinWidht)
  self:UpdateSpecialLayout(bgWidth, _height + _anchorBottomOffset + emojiHeight, hasTranslated)
  self:UpdateBgImgSize()
  local offset = 0
  if self.remarkTimeText then
    offset = emojiOffset
  end
  if 0 < _anchorBottomOffset then
    local tempHight = 0
    if self.hasUp then
      tempHight = emojiHight
    end
    if self._chatData.post ~= PostType.Text_AllianceNotice then
      self._dlgText:SetAnchoredPositionXY(self._dlgText:GetAnchoredPositionX(), -(_anchorBottomOffset + replyGapHight))
    end
    self._replyNode:SetAnchoredPositionXY(self.btnNormalMsg.rectTransform.rect.width / 2, -replyGapHight)
    if self.emoji_like_layout then
      self.emoji_like_layout:SetAnchoredPositionXY(self.emoji_like_layout:GetAnchoredPositionX(), emojiLikeDefaultHeight + offset)
    end
  elseif self._chatData.post ~= PostType.Text_AllianceNotice then
    self._dlgText:SetAnchoredPositionXY(self._dlgText:GetAnchoredPositionX(), -replyGapHight)
    if self._chatData.post == PostType.Text_AllianceNotice then
      self._dlgText:SetAnchoredPositionXY(self.emoji_like_item.transform.position.posX, self._replyNode.transform.position.posY)
      self._tempHight = emojiHight
      for i = 1, #self.chatdata do
        if self._chatData[i].isInDrag then
          local size = self:GetSize()
          self._dlgText:SetSizeDeltaXY(size.x, size.y)
        end
      end
    end
  end
  self:UpdateEmojiLikeLayoutSize(bgWidth)
end

function ChatItem:UpdateEmojiLikeLayoutSize(bgWidth)
  if self.emoji_like_layout then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.emoji_like_layout.rectTransform)
    local hight = 50
    if self.emoji_like_layout.rectTransform.rect then
      hight = self.emoji_like_layout.rectTransform.rect.height
    end
    self.emoji_like_layout.rectTransform:Set_sizeDelta(math.max(bgWidth - 25, 200), hight)
  end
end

function ChatItem:UpdateSpecialLayout(sourceWidth, sourceHeight, hasTranslated)
  local size = Vector2.New(sourceWidth, sourceHeight)
  self:SetSize(size)
  if self.IsMyChat then
    return
  end
end

function ChatItem:LoadEmojis(chatData)
  local emojis = chatData.emojis
  self.items = {}
  for i = 1, #emojis do
    local item = self.emoji_like_item.gameObject:GameObjectSpawn(self.emoji_like_layout.transform)
    table.insert(self.items, item)
    item.name = "emoji_like_item" .. i
    item:SetActive(true)
    local obj = self.emoji_like_layout:AddComponent(ChatDataEmojiItem, item.name)
    emojis[i].isMe = chatData:isMyChat()
    obj:UpdateData(emojis[i], self)
  end
end

function ChatItem:UpdateChatDataEmoji(chatData)
  self.hasUp = false
  if #chatData:getEmojiList() > 0 then
    self.hasUp = true
  end
  if self.emoji_like_layout and self.emoji_like_item then
    self.emoji_like_layout:RemoveComponents(ChatDataEmojiItem)
    self.emoji_like_item.gameObject:GameObjectRecycleAll()
    self.emoji_like_layout:SetActive(self.hasUp)
    if self.hasUp then
      self:LoadEmojis(chatData)
      local offset = 0
      if self.remarkTimeText then
        offset = emojiOffset
      end
      self.emoji_like_layout:SetAnchoredPositionXY(self.emoji_like_layout:GetAnchoredPositionX(), emojiLikeDefaultHeight + offset)
    end
  end
end

function ChatItem:UpdateContent()
  if self:IsRedPack() then
    self:UpdateText()
  elseif self:IsSharePoint() then
    self:UpdateSharePoint()
  elseif self:IsShareStorageShop() then
    self:UpdateSharePoint()
  elseif self:IsLikeChat() then
    self:UpdateLike()
  elseif self:IsLWEmoji() then
    self:ResetTranslatePart()
    self:UpdateEmoji()
  else
    self:UpdateText()
  end
end

function ChatItem:UpdateTranslateBtnState()
end

function ChatItem:ResetTranslatePart()
end

function ChatItem:UpdateItem(chatdata, index)
  base.UpdateItem(self, chatdata, index)
  if index ~= nil then
    self._chatIndex = index
  end
  self.IsMyChat = self._chatData:isMyChat()
  self.seqId = chatdata:getSeqId()
  self:UpdateChatDataEmoji(chatdata)
  if self._replyNode then
    self._replyNode:SetActive(false)
  end
  self:UpdateContent()
  if self.upObj ~= nil then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.upObj.rectTransform)
  end
  self:RefreshButton()
end

function ChatItem:OnDown()
  local deltaTime = ChatManager2:GetInstance():GetGiveLikeMsgTime(self.seqId)
  local k1 = LuaEntry.DataConfig:TryGetNum("thumbs_up", "k1")
  local realLeftTime = deltaTime + k1
  if 0 < realLeftTime then
    local delta = UITimeManager:GetInstance():MilliSecondToFmtString(realLeftTime * 1000)
    UIUtil.ShowTips(Localization:GetString("121068", delta))
    return
  end
  local _roomId = self._chatData.roomId
  local msgTable = {
    roomId = _roomId,
    msgSeq = self.seqId,
    interactDislike = 1
  }
  if string.IsNullOrEmpty(_roomId) or ChatViewController:GetInstance():IsTmpPrivateChat(_roomId) or _roomId == ChatGMRoomId then
    local tui = ChatViewController:GetInstance():GetPrivateUserInfo()
    if tui == nil then
      return
    end
    msgTable.toUid = tui.uid
  end
  ChatManager2:GetInstance():SetGiveLikeMsgTime(self.seqId)
  ChatManager2:GetInstance():SetGiveLikeAnim(self.seqId, 2)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SEND_ROOM_MSG_UP_COMMAND, msgTable)
end

function ChatItem:OnClickEmoji(index)
  ChatManager2:GetInstance():SendEmojiComments(self._chatData:getSeqId(), index, self._chatData.roomId, self._chatData.senderUid)
end

function ChatItem:OnUp()
end

function ChatItem:RefreshButton()
  if self.hasUp == false or not self.upObj then
    return
  end
  local anim = ChatManager2:GetInstance():GetGiveLikeAnim(self.seqId)
  if 0 < anim then
    if anim == 1 then
      local ret, time = self.up_anim:PlayAnimationReturnTime("V_ui_dianzan_anim")
      ChatManager2:GetInstance():SetGiveLikeAnim(self.seqId, 0)
    elseif anim == 2 then
      local ret, time = self.down_anim:PlayAnimationReturnTime("V_ui_diancai_anim")
      ChatManager2:GetInstance():SetGiveLikeAnim(self.seqId, 0)
    end
  else
    self.up_anim:Play("V_ui_dianzan_finish", 0, 0)
    self.down_anim:Play("V_ui_diancai_finish", 0, 0)
  end
end

function ChatItem:IsLWEmoji()
  if string.startswith(self._chatData.msg, "<lwEmoji:") and string.endswith(self._chatData.msg, ":>") then
    return true
  else
    return false
  end
end

function ChatItem:SetEmojiVisible(isVisible)
  if self.emoji_img ~= nil and self.emoji_img.gameObject.activeSelf ~= isVisible then
    self.emoji_img:SetActive(isVisible)
  end
end

function ChatItem:UpdateEmoji()
  self:SetChatShareNodeVisible(false)
  self:SetBackGroundVisible(true)
  self:SetEmojiVisible(true)
  if self._dlgText ~= nil then
    self._dlgText.gameObject:SetActive(false)
  end
  if self.emoji_img then
    local rawStr = self._chatData.msg
    local spl = string.split(rawStr, ":")
    if #spl == 3 then
      local lineData = LocalController:instance():getLine(TableName.LW_EMOJI, spl[2])
      if lineData then
        local path = "Assets/Main/Sprites/UI/LWChatEmoji/Default/" .. lineData.path .. ".png"
        self.emoji_img:LoadSprite(path)
      end
    end
  end
  if self.remarkTimeText and self._chatData.serverTime then
    self.remarkTimeText:SetText(UITimeManager:GetInstance():GetChatShowTime(math.floor(self._chatData.serverTime / 1000)))
  end
  local _anchorBottomOffset, width = self:UpdateReplyNode(120)
  local bgWidth = math.max(width, 120)
  self:SetSize(Vector2.New(math.max(width, 120), 140 + _anchorBottomOffset))
  if 0 < _anchorBottomOffset then
    local offset = 0
    if self.remarkTimeText then
      offset = emojiOffset
    end
    self.emoji_img:SetAnchoredPositionXY(self.emoji_img:GetAnchoredPositionX(), 28.5 - _anchorBottomOffset / 2)
    self._replyNode:SetAnchoredPositionXY(self.btnNormalMsg.rectTransform.rect.width / 2, -22)
    if self.emoji_like_layout then
      self.emoji_like_layout:SetAnchoredPositionXY(self.emoji_like_layout:GetAnchoredPositionX(), 10 + offset)
    end
  else
    self.emoji_img:SetAnchoredPositionXY(self.emoji_img:GetAnchoredPositionX(), 28.5)
  end
  self:UpdateEmojiLikeLayoutSize(bgWidth)
end

function ChatItem:UpdateReplyNode(textwidth)
  local maxWidth = self:GetChatItemMaxWidth() - 6
  local _anchorBottomOffset = 0
  local width = 0
  if self._replyNode then
    if self._chatData.replyMsg then
      local replyTxtSize = self._replyNode:GetReplyTextSize(self._chatData, maxWidth, textwidth)
      self._replyNode:SetActive(true)
      width = math.max(self._replyNode:SetReply(self._chatData, maxWidth, textwidth, replyDefaulHight), textwidth)
      self._replyNode:SetSize(width, replyDefaulHight)
      _anchorBottomOffset = replyDefaulHight
    else
      self._replyNode:SetActive(false)
    end
  end
  return _anchorBottomOffset, width + replyBgMaxWidht
end

return ChatItem
