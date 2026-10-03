local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatItemFrame = BaseClass("ChatItemFrame", IChatItem)
local base = IChatItem
local ChatViewController = require("UI.UIChatNew.Controller.ChatViewUtils")
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local ChatHead = require("UI.UIChatNew.Component.ChatHead")
local ChatUserName = require("UI.UIChatNew.Component.ChatItem.ChatUserName")
local ChatDataEmojiItem = require("UI.UIChatNew.Component.ChatItem.ChatDataEmojiItem")
local _cp_chatUserName = "ChatNameLayout"
local _cp_anchorTransform = "ChatAnchor"
local _cp_anchorTransform_bubbleDefault = "ChatAnchor/bubbleDefault"
local _cp_dividingLine = "ChatAnchor/CommonItems/dividingLine"
local _cp_traText = "ChatAnchor/CommonItems/TranslateText"
local translate_trans = "ChatAnchor/NormalBg"
local translate_btn_path = "ChatAnchor/NormalBg/TranslateBtn"
local translate_refresh_btn_path = "ChatAnchor/NormalBg/TranslateRefreshBtn"
local translate_finish_path = "ChatAnchor/NormalBg/TranslateFinishImg"
local translating_content_path = "ChatAnchor/NormalBg/Translating"
local translating_text_path = "ChatAnchor/NormalBg/Translating/TranslatingText"
local emoji_like_layout = "ChatAnchor/CommonItems/EmojiLikeLayout"
local emoji_like_item = "ChatAnchor/CommonItems/EmojiLikeLayout/EmojiLikeItem"
local bg_path = "Bg"
local black_path = "Black"
local remark_time_path = "RemarkTimeText"
local long_click_handler_path = "ChatAnchor/LongClickHandler"
local chat_head_long_click_handler_path = "ChatHead/HeadLongClickHandler"
local send_gift_path = "ChatAnchor/NormalBg/sendGift"
local post_async_loading_path = "PostAsyncLoading"
local emojiOffset = 30
local deleteTextHeight = 40

function ChatItemFrame:__init()
end

function ChatItemFrame:__delete()
  if self.emoji_like_layout then
    self.emoji_like_layout:RemoveComponents(ChatDataEmojiItem)
  end
  if self.emoji_like_item then
    self.emoji_like_item.gameObject:GameObjectRecycleAll()
  end
end

function ChatItemFrame:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.instanceRequest = nil
  self.firstFlag = true
end

function ChatItemFrame:OnDestroy()
  self:UnloadLightsweepEffect()
  self:OnRecycleItem()
  self:ReleaseAsset()
  self:DelTimer()
  base.OnDestroy(self)
end

function ChatItemFrame:OnAddListener()
  base.OnAddListener(self)
  local ChatEventEnum = _ENV.ChatEventEnum
  self:AddUIListener(ChatEventEnum.CHAT_UPDATE_ROOM_MSG, self.UpdateItemWithNew)
  self:AddUIListener(ChatEventEnum.CHAT_TRANSLATE_SETTING, self.UpdateTransLateMsg)
  self:AddUIListener(ChatEventEnum.CHAT_TRANSLATE_ITEM, self.OnTranslateItem)
end

function ChatItemFrame:OnRemoveListener()
  local ChatEventEnum = _ENV.ChatEventEnum
  self:RemoveUIListener(ChatEventEnum.CHAT_UPDATE_ROOM_MSG, self.UpdateItemWithNew)
  self:RemoveUIListener(ChatEventEnum.CHAT_TRANSLATE_SETTING, self.UpdateTransLateMsg)
  self:RemoveUIListener(ChatEventEnum.CHAT_TRANSLATE_ITEM, self.OnTranslateItem)
  base.OnRemoveListener(self)
end

function ChatItemFrame:ComponentDefine()
  self._chatHead = self:AddComponent(ChatHead, "ChatHead")
  self._chatHeadBg = self:AddComponent(UIImage, "ChatHead/HeadBtn")
  self._chatHeadFg = self:AddComponent(UIImage, "ChatHead/Foreground")
  self._chatHeadCanvasGroup = self:AddComponent(UICanvasGroup, "ChatHead")
  self._chatAnchorCanvasGroup = self:AddComponent(UICanvasGroup, "ChatAnchor/PostAnchor")
  self._chatHeadCanvasGroup:SetAlpha(ChatUIThemeConfig.HeadAlpha[ChatInterface.GetChatTheme()])
  self._chatUserName = self:AddComponent(ChatUserName, _cp_chatUserName)
  self.birthdayIcon = self:AddComponent(UIImage, "ChatHeadContent/birthdayIcon")
  self.chat_anchor = self:AddComponent(UIButton, _cp_anchorTransform)
  self.chat_anchor:SetOnClick(BindCallback(self, self.TryShowChatOperator))
  self._chat_bubble = self:AddComponent(UIImage, _cp_anchorTransform_bubbleDefault)
  self.post_anchor = self:AddComponent(UIBaseContainer, "ChatAnchor/PostAnchor")
  self.chatItemFrameCS = self.gameObject:GetComponent(typeof(CS.ChatItemFrame))
  self.common_items = self:AddComponent(UIBaseContainer, "ChatAnchor/CommonItems")
  self.commonItemLayoutCS = self.common_items.gameObject:GetComponent(typeof(CS.ChatItemPostLayout))
  self._dividingLine = self:AddComponent(UIImage, _cp_dividingLine)
  self._traText = self:AddComponent(UITextMeshProUGUIEx, _cp_traText)
  self.deleteTimeGo = self:AddComponent(UIBaseContainer, "ChatAnchor/DeleteTimeGo")
  self.deleteTimeTxt = self:AddComponent(UITextMeshProUGUIEx, "ChatAnchor/DeleteTimeGo/DeleteTimeTxt")
  self.translateTrans = self:AddComponent(UIBaseContainer, translate_trans)
  self.translateBtn = self:AddComponent(UIButton, translate_btn_path)
  self.translateRefreshBtn = self:AddComponent(UIButton, translate_refresh_btn_path)
  self.translateFinishImg = self:AddComponent(UIBaseContainer, translate_finish_path)
  self.translating = self:AddComponent(UIBaseContainer, translating_content_path)
  self.translatingText = self:AddComponent(UIText, translating_text_path)
  self.translatingText:SetText(Localization:GetString("120039"))
  self.bgGo = self:AddComponent(UIBaseContainer, bg_path)
  self.blackImg = self:AddComponent(UICanvasGroup, black_path)
  self.remarkTime = self:AddComponent(UIText, remark_time_path)
  local headHandler = self:AddComponent(UIBaseContainer, chat_head_long_click_handler_path)
  self.headLongClickHandler = headHandler.gameObject:GetComponent(typeof(CS.ChatItemFrameClicker))
  self.headLongClickHandler.longPressThreshold = 0.3
  self.headLongClickHandler:SetLongPressAction(function()
    self:HandleChatHeadLongPress()
  end)
  local handler = self:AddComponent(UIBaseContainer, long_click_handler_path)
  self.longClickHandler = handler.gameObject:GetComponent(typeof(CS.ChatItemFrameClicker))
  self.longClickHandler:SetLongPressAction(function()
    self:HandleLongPress()
  end)
  self.translateBtn:SetOnClick(function()
    self:TranslateMsg()
  end)
  self.translateRefreshBtn:SetOnClick(function()
    self:TranslateMsgThenChangeType()
  end)
  self.post_async_loading = self:AddComponent(UIImage, post_async_loading_path)
  self.emoji_like_layout = self:AddComponent(UIBaseContainer, emoji_like_layout)
  self.emoji_like_item = self:AddComponent(UIBaseContainer, emoji_like_item)
  self.emoji_like_item.gameObject:GameObjectCreatePool()
  self.sendGiftIcon = self:AddComponent(UIImage, send_gift_path)
  self.sendGiftBtn = self:AddComponent(UIButton, send_gift_path)
  self.sendGiftBtn:SetOnClick(function()
    self:SendGift()
  end)
  ChatInterface.SetEmojiTextProperty(self._traText)
end

function ChatItemFrame:SendGift()
  if self._chatData == nil or not self._chatData.senderUid then
    return
  end
  DataCenter.GiftSystemManager:OpenOperationView({
    windowType = GiftSystemConst.WindowType.Send,
    targetUid = self._chatData.senderUid
  })
end

function ChatItemFrame:UpdateItem(chatdata, index)
  base.UpdateItem(self, chatdata, index)
  self.loadingFinish = false
  if index ~= nil then
    self._chatIndex = index
  end
  self.IsMyChat = self._chatData:isMyChat()
  self.seqId = self._chatData:getSeqId()
  self.postItemConfig = ChatInterface.GetPostConfig_Player(self._chatData)
  if self.postItemConfig == nil then
    return
  end
  self:ResetTranslatePart()
  self.chatItemFrameCS:ClearAdditionOffset()
  self.chatItemFrameCS:AddAdditionOffset(self.chat_anchor.rectTransform, self.postItemConfig.offset or 0)
  local isLeft = not self.IsMyChat
  if CommonUtil.IsArabicAutoMirrorOpen() then
    isLeft = self.IsMyChat
  end
  self.chatItemFrameCS:SwapAlign(isLeft)
  if self.postGO ~= nil then
    self:OnLoaded()
    return
  end
  if self.instanceRequest ~= nil then
    return
  end
  self.post_async_loading:SetEnable(true)
  self.tween = self.post_async_loading.transform:DOLocalRotate(Vector3(0, 0, -360), 1, CS.DG.Tweening.RotateMode.LocalAxisAdd):SetLoops(-1, CS.DG.Tweening.LoopType.Restart)
  self.instanceRequest = ResourceManager:InstantiateAsyncImmediately(self.postItemConfig.assetPath, function(request)
    local go = request.gameObject
    self.post_async_loading:SetEnable(false)
    if self.tween ~= nil then
      self.tween:Kill()
      self.tween = nil
    end
    self.postGO = go
    if not request.isUseCache then
      CommonUtil.CallAutoArabicMirrorManually(go)
    end
    local trans = go.transform
    trans:SetParent(self.post_anchor.transform, false)
    self.postGO:SetActive(true)
    self.postItem = self:AddComponent(self.postItemConfig.postClass, self.postGO)
    self.postItem:SetAnchoredPositionXY(0, 0)
    self.postItem:SetLocalScaleXYZ(1, 1, 1)
    self.postItem:Loaded(self)
    self.firstFlag = true
    self:OnLoaded()
  end)
end

function ChatItemFrame:OnRecycleItem()
  self.post_async_loading:SetEnable(false)
  if self.tween ~= nil then
    self.tween:Kill()
    self.tween = nil
  end
  if self.postItem ~= nil then
    self.postItem:OnRecycle()
  end
  if self.postGO == nil and self.instanceRequest ~= nil then
    self.instanceRequest:Destroy()
    self.instanceRequest = nil
  end
  self:DelTimer()
end

function ChatItemFrame:ReleaseAsset()
  if self.postItem ~= nil then
    self.postItem:OnRecycle()
    self.postItem:Recycle()
    self.postItem = nil
  end
  if self.postItemConfig ~= nil and self.postGO ~= nil then
    self:RemoveComponentOnly(self.postGO.name, self.postItemConfig.postClass)
  end
  if self.instanceRequest ~= nil then
    self.instanceRequest:Destroy()
    self.instanceRequest = nil
    self.postGO = nil
  end
end

function ChatItemFrame:OnLoaded()
  self:UpdateChatData(self._chatData)
  self.loadingFinish = true
end

function ChatItemFrame:UpdateChatData(chatdata)
  base.UpdateItem(self, chatdata)
  if self.postItem == nil then
    return
  end
  self.postItem:OnLoaded()
  self:UpdateTranslateContent()
  self:UpdateSendGiftBtn()
  self:UpdateEmojiLike()
  self:UpdateRemarkTime()
  self:CheckShowDeleteInfo(chatdata)
  self:RefreshDeleteTime(chatdata)
  self:RefreshItemSize()
  self.bgGo:SetActive(self.postItemConfig.hasBg == true)
end

function ChatItemFrame:UpdateSendGiftBtn()
  if not self.IsMyChat and self.postItemConfig ~= nil and self.postItemConfig.sendGiftBtn and IsGiftSystemOpen then
    self.sendGiftIcon:LoadSpriteAsync("Assets/Main/Sprites/UI/LWChat_v2/Common/zxl_qingrenjie_songli_anniu.png")
    ChatInterface.DarkMode(self.sendGiftIcon)
    self.sendGiftIcon:SetActive(true)
  else
    self.sendGiftIcon:SetActive(false)
  end
end

function ChatItemFrame:SetTransMsgActive(isOn)
  self._traText:SetActive(isOn)
  if self.postItem and self.postItem.FreedBack then
    self.postItem:FreedBack(isOn)
  end
end

function ChatItemFrame:UpdateTranslateContent()
  local hasTranslated = false
  if not self.IsMyChat then
    local needTranslateTxt = self._chatData:GetNeedTranslateText()
    if self._chatData and not self._chatData:IsLWEmoji() and self._traText ~= nil and self._dividingLine ~= nil and self.postItemConfig ~= nil and self.postItemConfig.hasTranslateBtn and not string.IsNullOrEmpty(needTranslateTxt) then
      self:SetTransMsgActive(false)
      self._dividingLine:SetActive(false)
      local isTranslating = self._chatData:IsTranslating()
      local translationMsg = self._chatData.translateMsg
      if not string.IsNullOrEmpty(translationMsg) and self._chatData.translatedLang == ChatInterface.GetChatTranslateLanguageAbbr() then
        hasTranslated = self._chatData:GetTranslateState() == 2
        if self.postItem and not self.postItem.hideTranslation then
          self:SetTransMsgActive(true)
          if not self.postItemConfig.translateTxtShowDiff then
            self._traText:SetAlignment(CommonUtil.IsArabicAutoMirrorOpen() and CS.TMPro.TextAlignmentOptions.TopRight or CS.TMPro.TextAlignmentOptions.TopLeft)
            self._traText:SetFontSize(32)
            self._traText:SetText_NotNative(translationMsg)
            self._traText:SetBestFitEnable(false)
            self._dividingLine:SetActive(true)
          else
            self._traText:SetActive(false)
          end
        end
      end
      self:UpdateTranslateBtnState(isTranslating, hasTranslated)
    else
      self:ResetTranslatePart()
    end
  else
    self:SetTransMsgActive(false)
  end
end

function ChatItemFrame:LoadEmojis(chatData)
  local emojis = chatData.emojis
  self.items = {}
  for i = 1, #emojis do
    if not HideInChatItemFrame[emojis[i].emoji] then
      local item = self.emoji_like_item.gameObject:GameObjectSpawn(self.emoji_like_layout.transform)
      table.insert(self.items, item)
      item.name = "emoji_like_item" .. i
      item:SetActive(true)
      local obj = self.emoji_like_layout:AddComponent(ChatDataEmojiItem, item.name)
      emojis[i].isMe = chatData:isMyChat()
      obj:UpdateData(emojis[i], self)
    end
  end
end

function ChatItemFrame:UpdateEmojiLike()
  local hasEmojiLike = false
  if self:GetShowEmojiCount() > 0 then
    hasEmojiLike = true
  end
  if self.emoji_like_layout and self.emoji_like_item then
    if hasEmojiLike then
      self.emoji_like_layout:RemoveComponents(ChatDataEmojiItem)
      self.emoji_like_item.gameObject:GameObjectRecycleAll()
      self:LoadEmojis(self._chatData)
      local offset = 0
      if self.remarkTimeText then
        offset = emojiOffset
      end
    end
    self.emoji_like_layout:SetActive(hasEmojiLike)
  end
end

function ChatItemFrame:UpdateRemarkTime()
  if self._chatData and self._chatData.group == ChatGroupType.GROUP_ALLIANCE_NOTICE then
    self.remarkTime:SetActive(true)
    self.remarkTime:SetText(UITimeManager:GetInstance():GetChatShowTime(math.floor(self._chatData.serverTime / 1000)))
  else
    self.remarkTime:SetActive(false)
  end
end

function ChatItemFrame:TryShowChatOperator()
  if self.postItem == nil then
    return
  end
  if self.postItem:HandleClick() then
    return
  end
  self:ShowChatOperator()
end

function ChatItemFrame:HandleChatHeadLongPress()
  local senderUid = self._chatData.senderUid
  local _userInfo = ChatInterface.getUserData(senderUid)
  if string.IsNullOrEmpty(_userInfo.userName) then
    return
  end
  EventManager:GetInstance():Broadcast(EventId.CHAT_ON_LONG_CLICK_ADD_AT_PLAYER, _userInfo)
  self.postItem:HandleChatHeadLongPress()
end

function ChatItemFrame:HandleLongPress()
  if self.postItem:HandleLongPress() then
    return
  end
  self:ShowChatOperator()
end

function ChatItemFrame:ShowChatOperator()
  if self._chatData and self._chatData:IsLWEmoji() then
    return
  end
  local param = {}
  param.chatdata = DeepCopy(self._chatData)
  param.userinfo = self._userInfo
  param.targetPos = nil
  param.chatItem = self
  param.onlyEmoji = self._chatData.post ~= PostType.Text_Normal
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIChatOperation, {anim = false}, param)
end

function ChatItemFrame:RefreshItemSize()
  if self.postItem == nil or self.postItem.chatItemPostLayoutCS == nil then
    return
  end
  local postItemLayoutCS = self.postItem.chatItemPostLayoutCS
  postItemLayoutCS:CalculateSize()
  local preferredWidth = postItemLayoutCS.preferredWidth
  local preferredHeight = postItemLayoutCS.preferredHeight
  local paddingY = postItemLayoutCS.padding.y
  local hasCommonItems = self.emoji_like_layout:GetActive() or self._chatData:GetTranslateState() == 2 and not self.postItemConfig.translateTxtShowDiff
  self.common_items:SetActive(hasCommonItems)
  local emojiAreaWidth, emojiAreaHeight = self:ResizeEmojiArea()
  if hasCommonItems and self.commonItemLayoutCS ~= nil then
    if not self.postItem.UseCustomDeleteTime and self.showDeleteInfo then
      self.common_items:SetAnchoredPositionXY(30, -preferredHeight - deleteTextHeight)
    else
      self.common_items:SetAnchoredPositionXY(30, -preferredHeight)
    end
    local translateAreaWidth, translateAreaHeight = self:ResizeTranslationArea()
    self.common_items.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, translateAreaWidth)
    preferredWidth = math.max(preferredWidth, translateAreaWidth)
    preferredHeight = preferredHeight + translateAreaHeight
  end
  postItemLayoutCS:SetPreferredSize(preferredWidth, preferredHeight)
  local padding = postItemLayoutCS.padding
  if not self.postItem.UseCustomDeleteTime and self.showDeleteInfo then
    self.deleteTimeGo:SetAnchoredPositionXY(0, -postItemLayoutCS.preferredHeight + 2)
    self.deleteTimeGo.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, preferredWidth + padding.x)
    preferredHeight = preferredHeight + deleteTextHeight
  end
  preferredWidth = preferredWidth + padding.x
  preferredHeight = preferredHeight + padding.y
  local remarkHeight = 0
  if self._chatData and self._chatData.group == ChatGroupType.GROUP_ALLIANCE_NOTICE then
    remarkHeight = 60
    self.remarkTime.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, self.remarkTime:GetWidth())
    self.remarkTime:SetAnchoredPositionXY(self.remarkTime:GetAnchoredPositionX(), -(preferredHeight + 25 + emojiAreaHeight))
  end
  if self.emoji_like_layout:GetActive() then
    self.translateTrans:SetOffsetMinXY(0, 57 + remarkHeight)
  else
    self.translateTrans:SetOffsetMinXY(0, 7 + remarkHeight)
  end
  self.chat_anchor.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, preferredWidth)
  if hasCommonItems and self.commonItemLayoutCS ~= nil then
    local translateAreaWidth, translateAreaHeight = self:ResizeTranslationArea()
    local x = -self.common_items:GetAnchoredPositionX()
    if self._chatData and 0 < #self._chatData:getEmojiList() then
      local normalTextOffset = 0
      if self._chatData:getPost() == PostType.Text_Normal then
        normalTextOffset = 13
      end
      if self._chatData:isMyChat() then
        x = -self.common_items:GetAnchoredPositionX() - emojiAreaWidth + Mathf.Abs(self.chat_anchor:GetSizeDelta().x) - normalTextOffset
      else
        x = x + normalTextOffset
      end
    end
    self.emoji_like_layout:SetAnchoredPositionXY(x, -translateAreaHeight - paddingY)
    self.emoji_like_layout.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, emojiAreaWidth)
  end
  self.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, preferredHeight + 25 + emojiAreaHeight + remarkHeight)
  local index = self._chatIndex - 1
  self._contentViewScript._scrollView.unity_looplistview2:OnItemSizeChanged(index)
end

function ChatItemFrame:ResizeTranslationArea()
  if not self._traText:GetActive() then
    return 0, 0
  end
  local maxWidth = self:GetChatItemMaxWidth() - 50
  local preferredValues = self._traText.unity_tmpro:GetPreferredValues(maxWidth, 0)
  if maxWidth < preferredValues.x then
    self._traText.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, maxWidth)
  else
    self._traText.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, preferredValues.x)
  end
  self._traText.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, preferredValues.y)
  return math.min(preferredValues.x + 20, maxWidth), preferredValues.y + 10
end

function ChatItemFrame:ResizeEmojiArea()
  if not self._chatData then
    return 0, 0
  end
  if self._chatData and self:GetShowEmojiCount() == 0 then
    return 0, 0
  end
  local emojiNum = self:GetShowEmojiCount()
  local width = emojiNum * ChatLayoutEmojiLength + math.max(0, emojiNum - 1) * ChatLayoutEmojiSpace
  return width, 50
end

function ChatItemFrame:GetShowEmojiCount()
  local count = 0
  for _, v in ipairs(self._chatData:getEmojiList()) do
    if not HideInChatItemFrame[v.emoji] then
      count = count + 1
    end
  end
  return count
end

function ChatItemFrame:TranslateMsg()
  if self._chatData:IsTranslating() then
    return
  end
  local _translationMsg = self._chatData:getTranslationMsg()
  if self._chatData.translatedLang == ChatInterface.GetChatTranslateLanguageAbbr() and not string.IsNullOrEmpty(_translationMsg) and self._chatData:GetCanRefreshTranslate() == 1 then
    return
  end
  self._chatData:setTranslateState(1)
  if string.IsNullOrEmpty(_translationMsg) or self._chatData.translatedLang ~= ChatInterface.GetChatTranslateLanguageAbbr() then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_TRANSLATE, self._chatData)
  elseif self._chatData:GetCanRefreshTranslate() ~= 1 then
    self:TranslateMsgThenChangeType()
  else
    self._chatData:setTranslateState(0)
  end
  self:UpdateTranslateBtnState(self._chatData:IsTranslating(), self._chatData:GetTranslateState() == 2)
end

function ChatItemFrame:TranslateMsgThenChangeType()
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
end

function ChatItemFrame:UpdateTranslateBtnState(isTranslating, hasTranslated)
  if self.translateBtn == nil then
    return
  end
  self.translating:SetActive(isTranslating and not hasTranslated)
  self.translateBtn:SetActive(not isTranslating and not hasTranslated)
  self.translateFinishImg:SetActive(hasTranslated and self._chatData:GetCanRefreshTranslate() == 1)
  self.translateRefreshBtn:SetActive(hasTranslated and self._chatData:GetCanRefreshTranslate() ~= 1)
end

function ChatItemFrame:ResetTranslatePart()
  if self.translateBtn == nil then
    return
  end
  self.translateBtn:SetActive(false)
  self.translateRefreshBtn:SetActive(false)
  self.translateFinishImg:SetActive(false)
  self.translating:SetActive(false)
  self:SetTransMsgActive(false)
end

function ChatItemFrame:OnTranslateItem(chatInfo)
  if not chatInfo then
    return
  end
  if self._chatData.roomId == chatInfo.roomId and self._chatData.seqId == chatInfo.seqId then
    self:TranslateMsg()
  end
end

function ChatItemFrame:UpdateTransLateMsg()
  self._chatData:setTranslateState(0)
  self:UpdateItem(self._chatData)
  self._contentViewScript:ReloadAfterTranslateRecv(self._chatIndex)
end

function ChatItemFrame:UpdateItemWithNew(chatData)
  if chatData == nil then
    return
  end
  if chatData.roomId == self._chatData.roomId and chatData.seqId == self._chatData.seqId then
    self:UpdateChatData(chatData)
    if self.view and self.view.middle and self.view.middle.scrollMsgs then
      self.view.middle.scrollMsgs:ReloadAfterTranslateRecv(self._chatIndex)
    end
  end
end

function ChatItemFrame:OnClickEmoji(index)
  if self._chatData == nil then
    return
  end
  ChatManager2:GetInstance():SendEmojiComments(self._chatData:getSeqId(), index, self._chatData.roomId, self._chatData.senderUid)
end

function ChatItemFrame:UpdateUserInfoWithNew()
  base.UpdateUserInfoWithNew(self)
  if self.postItem and type(self.postItem.UpdateUserInfoWithNew) == "function" then
    self.postItem:UpdateUserInfoWithNew()
  end
  if self._chatData.post ~= PostType.Text_Normal then
    self._traText:SetColor(DefaultChatMsgColor)
    self._dividingLine:SetColor(Color.New(DefaultChatMsgColor.r, DefaultChatMsgColor.g, DefaultChatMsgColor.b, 0.5))
  end
  if self._userInfo then
    local isHaveSet = false
    local isInBirthday = false
    local zodType = BirthdayZodType.Hide
    local birthdayStr
    if self._userInfo.uid == LuaEntry.Player.uid then
      if not string.IsNullOrEmpty(self._userInfo.birthday) then
        isHaveSet = true
        birthdayStr = self._userInfo.birthday
      end
      local setData = DataCenter.BirthdayDataManager:GetSetData()
      if setData and setData.zodType then
        zodType = setData.zodType
      end
    elseif not string.IsNullOrEmpty(self._userInfo.birthday) then
      if DataCenter.BirthdayDataManager:CheckIsPassSetShowArea(self._userInfo.uid, self._userInfo.allianceId, self._userInfo.birthdayDisplay) then
        isHaveSet = true
      end
      zodType = self._userInfo.zodDisplay
      birthdayStr = self._userInfo.birthday
    end
    if isHaveSet then
      isInBirthday = DataCenter.BirthdayDataManager:CheckIsSameTime(self._userInfo.birthday)
    end
    if isHaveSet then
      if isInBirthday then
        local InBirthdayImgPath = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/zyf_shengrixitong_huizhang.png"
        self.birthdayIcon:SetActive(true)
        self.birthdayIcon:LoadSprite(InBirthdayImgPath)
        self:LoadLightsweepEffect()
      else
        self.birthdayIcon:SetActive(false)
      end
    else
      self.birthdayIcon:SetActive(false)
    end
  else
    self.birthdayIcon:SetActive(false)
  end
end

function ChatItemFrame:ShowBlackFlash()
  if not IsNull(self.sequence) then
    self.sequence:Kill()
    self.sequence = nil
  end
  self.sequence = CS.DG.Tweening.DOTween.Sequence()
  self.sequence:Append(self.blackImg:FadeIn(0.5))
  self.sequence:Append(self.blackImg:FadeOut(0.2))
  self.sequence:OnComplete(function()
    self.sequence = nil
  end)
end

local lightsweepEffectPath = "Assets/Main/Prefabs/UI/LWMainUI/Birthday/Eff_ui_lightsweep.prefab"

function ChatItemFrame:LoadLightsweepEffect()
  if self.lightsweepEffectReq == nil then
    self.lightsweepEffectReq = self:GameObjectInstantiateAsync(lightsweepEffectPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.birthdayIcon.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:Set_localPosition(0, 0, 0)
    end)
  end
end

function ChatItemFrame:UnloadLightsweepEffect()
  if self.lightsweepEffectReq ~= nil then
    self:GameObjectDestroy(self.lightsweepEffectReq)
    self.lightsweepEffectReq = nil
  end
end

function ChatItemFrame:CheckShowDeleteInfo(chatdata)
  if chatdata:GetDeleteTimestamp() <= 0 then
    self.showDeleteInfo = false
    return
  end
  local isShow = false
  if LocalController:instance():hasTable(TableName.chat_sharetype_config) then
    local config = LocalController:instance():tryGetLine(TableName.chat_sharetype_config, chatdata.post)
    if config then
      self.shareTypeConfig = config
      isShow = true
    end
  end
  self.showDeleteInfo = isShow
end

function ChatItemFrame:RefreshDeleteTime(chatdata)
  local timeStamp = chatdata:GetDeleteTimestamp()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.showDeleteInfo then
    self.deleteTimeGo:SetActive(true)
    if timeStamp > curTime then
      self:AddTimer()
    end
    self:SetRemainTime()
  else
    self.deleteTimeGo:SetActive(false)
  end
end

function ChatItemFrame:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.SetRemainTime, self, false, false, false)
  end
  self.timer:Start()
end

function ChatItemFrame:DelTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function ChatItemFrame:SetRemainTime()
  if self._chatData == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deleteTime = self._chatData:GetDeleteTimestamp()
  local remainTime = deleteTime - curTime
  if 0 < remainTime then
    local str = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
    if self.shareTypeConfig then
      str = Localization:GetString(self.shareTypeConfig.tips, str)
    end
    self.deleteTimeTxt:SetText(str)
  else
    self:DelTimer()
    self.deleteTimeTxt:SetLocalText("chat_message_share_time_alert_limit7")
  end
end

return ChatItemFrame
