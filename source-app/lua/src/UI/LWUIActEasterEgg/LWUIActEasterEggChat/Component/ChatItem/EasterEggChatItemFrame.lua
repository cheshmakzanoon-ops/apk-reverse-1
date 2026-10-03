local base = UIBaseContainer
local EasterEggChatItemFrame = BaseClass("EasterEggChatItemFrame", base)
local M = EasterEggChatItemFrame
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local ChatHead = require("UI.UIChatNew.Component.ChatHead")
local ChatUserName = require("UI.LWUIActEasterEgg.LWUIActEasterEggChat.Component.ChatItem.EasterEggChatUserName")
local ChatDataEmojiItem = require("UI.LWUIActEasterEgg.LWUIActEasterEggChat.Component.ChatItem.EastereggChaEmojiItem")
local _cp_chatUserName = "Root/ChatNameLayout"
local _cp_anchorTransform = "Root/ChatAnchor"
local _cp_anchorTransform_bubbleDefault = "Root/ChatAnchor/bubbleDefault"
local _cp_dividingLine = "Root/ChatAnchor/CommonItems/dividingLine"
local _cp_traText = "Root/ChatAnchor/CommonItems/TranslateText"
local translate_trans = "Root/ChatAnchor/NormalBg"
local translate_btn_path = "Root/ChatAnchor/NormalBg/TranslateBtn"
local translate_refresh_btn_path = "Root/ChatAnchor/NormalBg/TranslateRefreshBtn"
local translate_finish_path = "Root/ChatAnchor/NormalBg/TranslateFinishImg"
local translating_content_path = "Root/ChatAnchor/NormalBg/Translating"
local translating_text_path = "Root/ChatAnchor/NormalBg/Translating/TranslatingText"
local emoji_like_layout = "Root/ChatAnchor/CommonItems/EmojiLikeLayout"
local emoji_like_item = "Root/ChatAnchor/CommonItems/EmojiLikeLayout/EmojiLikeItem"
local bg_path = "Root/Bg"
local black_path = "Root/Black"
local remark_time_path = "Root/RemarkTimeText"
local long_click_handler_path = "Root/ChatAnchor/LongClickHandler"
local post_async_loading_path = "Root/PostAsyncLoading"

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.instanceRequest = nil
  self.uid = nil
  self.scaleValue = 0.8
end

function M:ComponentDefine()
  self._chatHead = self:AddComponent(ChatHead, "Root/ChatHead")
  self._chatHeadBg = self:AddComponent(UIImage, "Root/ChatHead/HeadBtn")
  self._chatHeadFg = self:AddComponent(UIImage, "Root/ChatHead/Foreground")
  self._chatHeadCanvasGroup = self:AddComponent(UICanvasGroup, "Root/ChatHead")
  self._chatAnchorCanvasGroup = self:AddComponent(UICanvasGroup, "Root/ChatAnchor/PostAnchor")
  self._chatUserName = self:AddComponent(ChatUserName, _cp_chatUserName)
  self.chat_anchor = self:AddComponent(UIButton, _cp_anchorTransform)
  self.chat_anchor:SetOnClick(BindCallback(self, self.TryShowChatOperator))
  self._chat_bubble = self:AddComponent(UIImage, _cp_anchorTransform_bubbleDefault)
  self.post_anchor = self:AddComponent(UIBaseContainer, "Root/ChatAnchor/PostAnchor")
  self.chatItemFrameCS = self.gameObject:GetComponent(typeof(CS.ChatItemFrame))
  self.common_items = self:AddComponent(UIBaseContainer, "Root/ChatAnchor/CommonItems")
  self.commonItemLayoutCS = self.common_items.gameObject:GetComponent(typeof(CS.ChatItemPostLayout))
  self._dividingLine = self:AddComponent(UIImage, _cp_dividingLine)
  self._traText = self:AddComponent(UITextMeshProUGUIEx, _cp_traText)
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
  ChatInterface.SetEmojiTextProperty(self._traText)
  self.compChatHeadAnonymous = self:AddComponent(UIBaseContainer, "Root/ChatHeadAnonymous")
  self.circleImgAnonymous = self:AddComponent(CircleImage, "Root/ChatHeadAnonymous/Image")
  self.compPosterFlag1 = self:AddComponent(UIBaseContainer, "Root/ChatHead/PosterFlag1")
  self.compPosterFlag2 = self:AddComponent(UIBaseContainer, "Root/ChatHeadAnonymous/PosterFlag2")
  self.compRoot = self:AddComponent(UIBaseContainer, "Root")
  self.gridLayoutGroupEmoji = self:AddComponent(UIGridLayoutGroup, emoji_like_layout)
end

function M:OnDestroy()
  self.uid = nil
  self:OnRecycleItem()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDestroy()
  if self.emoji_like_item then
    self.emoji_like_item.gameObject:GameObjectRecycleAll()
  end
  self.gridLayoutGroupEmoji = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
  local ChatEventEnum = _ENV.ChatEventEnum
  self:AddUIListener(ChatEventEnum.CHAT_UPDATE_ROOM_MSG, self.UpdateItemWithNew)
  self:AddUIListener(ChatEventEnum.CHAT_TRANSLATE_ITEM, self.OnTranslateItem)
  self:AddUIListener(ChatEventEnum.UPDATE_USER_MSG, self.UpdateItemByMsg)
  self:AddUIListener(EventId.PlayerMessageInfo, self.UpdateAnonymousHead)
end

function M:OnRemoveListener()
  local ChatEventEnum = _ENV.ChatEventEnum
  self:RemoveUIListener(ChatEventEnum.CHAT_UPDATE_ROOM_MSG, self.UpdateItemWithNew)
  self:RemoveUIListener(ChatEventEnum.CHAT_TRANSLATE_ITEM, self.OnTranslateItem)
  self:RemoveUIListener(ChatEventEnum.UPDATE_USER_MSG, self.UpdateItemByMsg)
  self:RemoveUIListener(EventId.PlayerMessageInfo, self.UpdateAnonymousHead)
  base.OnRemoveListener(self)
end

function M:OnRecycleItem()
  self.post_async_loading:SetEnable(false)
  if self.tween ~= nil then
    self.tween:Kill()
    self.tween = nil
  end
  if self.postItem ~= nil then
    self.postItem:OnRecycle()
    self.postItem:Recycle()
    self.postItem = nil
  end
  if self.postItemConfig ~= nil and self.postGO ~= nil then
    self:RemoveComponent(self.postGO.name, self.postItemConfig.postClass)
  end
  if self.instanceRequest ~= nil then
    self.instanceRequest:Destroy()
    self.instanceRequest = nil
    self.postGO = nil
  end
  self.circleImgAnonymous.spritePath = nil
end

function M:UpdateItemByMsg(chatData)
  if self._chatData == nil or chatData == nil or self._contentViewScript == nil then
    return
  end
  local oldResId = self._chatData:getSeqId()
  local newResId = chatData:getSeqId()
  if oldResId == newResId and self._chatData.roomId == chatData.roomId and self._chatData.post == chatData.post then
    self:UpdateItem(chatData, self.index)
  end
end

function M:UpdateItem(chatdata, index)
  local tmpChatData = self:GetEasterEggRoomChatData(chatdata:getSeqId())
  if tmpChatData == nil then
    local topLikeChatData = DataCenter.ActEasterEggManager:GetTopLikeChatData()
    if topLikeChatData and chatdata:getSeqId() == topLikeChatData:getSeqId() then
      self._chatData = topLikeChatData
    end
  end
  self._chatData = tmpChatData
  self.index = index
  self.loadingFinish = false
  if index ~= nil then
    self._chatIndex = index
  end
  self.IsMyChat = self._chatData:isMyChat()
  self.seqId = self._chatData:getSeqId()
  self.postItemConfig = EasterEggChatPosts[chatdata.chatScrollItemType]
  if self.postItemConfig == nil then
    Logger.LogError("EasterEggChatPosts \230\137\190\228\184\141\229\136\176")
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
    self:OnLoaded()
  end)
end

function M:OnLoaded()
  self:UpdateChatData(self._chatData)
  self.loadingFinish = true
end

function M:UpdateChatData(chatdata)
  self._chatData = chatdata
  if self.postItem == nil then
    return
  end
  self.postItem:OnLoaded()
  self:RefreshAnonymousShow()
  self:UpdateTranslateContent()
  self:UpdateEmojiLike()
  self:UpdateRemarkTime()
  self:RefreshItemSize()
  self.bgGo:SetActive(self.postItemConfig.hasBg == true)
end

function M:UpdateTranslateContent()
  local chatData = self:GetEasterEggRoomChatData(self._chatData:getSeqId())
  if chatData == nil then
    local topLikeChatData = DataCenter.ActEasterEggManager:GetTopLikeChatData()
    if topLikeChatData and self._chatData:getSeqId() == topLikeChatData:getSeqId() then
      chatData = topLikeChatData
    end
  end
  local hasTranslated = false
  if not self.IsMyChat then
    if chatData and not chatData:IsLWEmoji() and self._traText ~= nil and self._dividingLine ~= nil and self.postItemConfig ~= nil and self.postItemConfig.hasTranslateBtn then
      self._traText:SetActive(false)
      self._dividingLine:SetActive(false)
      local translationMsg = chatData.translateMsg
      if not string.IsNullOrEmpty(translationMsg) and chatData.translatedLang == ChatInterface.GetChatTranslateLanguageAbbr() then
        hasTranslated = chatData:GetTranslateState() == 2
        if self.postItem and not self.postItem.hideTranslation then
          self._traText:SetActive(true)
          self._traText:SetAlignment(CommonUtil.IsArabicAutoMirrorOpen() and CS.TMPro.TextAlignmentOptions.TopRight or CS.TMPro.TextAlignmentOptions.TopLeft)
          self._traText:SetFontSize(32)
          self._traText:SetText_NotNative(translationMsg)
          self._dividingLine:SetActive(true)
        end
      end
      self:UpdateTranslateBtnState(chatData)
      local isOpenAutoTranslate = DataCenter.ActEasterEggManager:GetIsOpenAutoTranslate()
      if isOpenAutoTranslate and (chatData:GetTranslateState() == 0 or chatData:GetTranslateState() == -1) then
        self:TranslateMsg()
      end
    else
      self:ResetTranslatePart()
    end
  end
end

local noPosterLikeWidth = 90
local posterLikeWidth = 118

function M:LoadEmojis(chatData)
  local emojis = chatData.emojis
  self.items = {}
  for i = 1, #emojis do
    local item = self.emoji_like_item.gameObject:GameObjectSpawn(self.emoji_like_layout.transform)
    table.insert(self.items, item)
    item.name = "emoji_like_item" .. i
    item:SetActive(true)
    local obj = self.emoji_like_layout:AddComponent(ChatDataEmojiItem, item.name)
    emojis[i].isMe = chatData:isMyChat()
    local isPosterLike = self:IsPosterLikeThisComment(chatData, emojis[i])
    local finalWidth = noPosterLikeWidth
    if isPosterLike then
      finalWidth = posterLikeWidth
    end
    self.gridLayoutGroupEmoji:SetCellSize(finalWidth, self.gridLayoutGroupEmoji:GetCellSize().y)
    obj:UpdateData(emojis[i], self, isPosterLike, finalWidth)
  end
end

function M:IsPosterLikeThisComment(chatData, emojiData)
  local eggInfo = self.view:GetEggInfo()
  if eggInfo == nil then
    Logger.LogError("\229\164\141\230\180\187\232\138\130\226\128\148\226\128\148\226\128\148\226\128\148\231\130\185\229\135\187\229\143\145\233\128\129\232\175\132\232\174\186\230\151\182\239\188\140\228\184\187\231\149\140\233\157\162eggInfo\228\184\186\231\169\186\239\188\129")
    return false
  end
  local posterLikeSeqIdList = eggInfo:GetPraiseCommentArr()
  for i = 1, #posterLikeSeqIdList do
    if tonumber(posterLikeSeqIdList[i]) == chatData:getSeqId() then
      return true
    end
  end
  local posterInfo = eggInfo:GetPosterInfo()
  if posterInfo.uid == LuaEntry.Player.uid and emojiData.self == 1 then
    return true
  end
  return false
end

function M:UpdateEmojiLike()
  local hasEmojiLike = false
  if #self._chatData:getEmojiList() > 0 then
    hasEmojiLike = true
  end
  if self.emoji_like_layout and self.emoji_like_item then
    if hasEmojiLike then
      self.emoji_like_layout:RemoveComponents(ChatDataEmojiItem)
      self.emoji_like_item.gameObject:GameObjectRecycleAll()
      self:LoadEmojis(self._chatData)
    end
    self.emoji_like_layout:SetActive(hasEmojiLike)
  end
end

function M:UpdateRemarkTime()
  self.remarkTime:SetActive(true)
  self.remarkTime:SetText(UITimeManager:GetInstance():GetChatShowTime(math.floor(self._chatData.serverTime / 1000)))
end

function M:TryShowChatOperator()
  if self.postItem == nil then
    return
  end
  if self.postItem:HandleClick() then
    return
  end
  self:ShowChatOperator()
end

function M:HandleLongPress()
  if self.postItem:HandleLongPress() then
    return
  end
  self:ShowChatOperator()
end

function M:ShowChatOperator()
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

function M:RefreshItemSize()
  if self.postItem == nil or self.postItem.chatItemPostLayoutCS == nil then
    return
  end
  local postItemLayoutCS = self.postItem.chatItemPostLayoutCS
  postItemLayoutCS:CalculateSize()
  local preferredWidth = postItemLayoutCS.preferredWidth
  local preferredHeight = postItemLayoutCS.preferredHeight
  local paddingY = postItemLayoutCS.padding.y
  local hasCommonItems = self.emoji_like_layout:GetActive() or self._chatData:GetTranslateState() == 2
  self.common_items:SetActive(hasCommonItems)
  local emojiAreaWidth, emojiAreaHeight = self:ResizeEmojiArea()
  if hasCommonItems and self.commonItemLayoutCS ~= nil then
    self.common_items:SetAnchoredPositionXY(30, -preferredHeight)
    local translateAreaWidth, translateAreaHeight = self:ResizeTranslationArea()
    self.common_items.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, translateAreaWidth)
    preferredWidth = math.max(preferredWidth, translateAreaWidth)
    preferredHeight = preferredHeight + translateAreaHeight
  end
  postItemLayoutCS:SetPreferredSize(preferredWidth, preferredHeight)
  local padding = postItemLayoutCS.padding
  preferredWidth = preferredWidth + padding.x
  preferredHeight = preferredHeight + padding.y
  local timeAndEmojiHeight = 35 * self.scaleValue
  self.remarkTime.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, self.remarkTime:GetWidth())
  self.remarkTime:SetAnchoredPositionXY(self.remarkTime:GetAnchoredPositionX(), -(preferredHeight + timeAndEmojiHeight))
  local transBtnDis = 57
  self.translateTrans:SetOffsetMinXY(0, transBtnDis)
  self.chat_anchor.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, preferredWidth)
  if hasCommonItems and self.commonItemLayoutCS ~= nil then
    local translateAreaWidth, translateAreaHeight = self:ResizeTranslationArea()
    local x = -self.common_items:GetAnchoredPositionX()
    if self._chatData and 0 < #self._chatData:getEmojiList() then
      local normalTextOffset = 191
      if self._chatData:isMyChat() then
        x = -self.common_items:GetAnchoredPositionX() - emojiAreaWidth + Mathf.Abs(self.chat_anchor:GetSizeDelta().x) - normalTextOffset
      else
        x = x + normalTextOffset
      end
    end
    self.emoji_like_layout:SetAnchoredPositionXY(x, -translateAreaHeight - paddingY)
    self.emoji_like_layout.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, emojiAreaWidth)
  end
  local finalHeight = preferredHeight + emojiAreaHeight + timeAndEmojiHeight
  self.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, finalHeight * self.scaleValue + 30)
  self.compRoot:SetSizeDeltaY(finalHeight)
  self._contentViewScript._scrollView:OnItemSizeChanged(self._chatIndex)
end

function M:ResizeTranslationArea()
  if not self._traText:GetActive() then
    return 0, 0
  end
  local maxWidth = self:GetChatItemMaxWidth() - 250
  local preferredValues = self._traText.unity_tmpro:GetPreferredValues(maxWidth, 0)
  if maxWidth < preferredValues.x then
    self._traText.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, maxWidth)
  else
    self._traText.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, preferredValues.x)
  end
  self._traText.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, preferredValues.y)
  return math.min(preferredValues.x + 20, maxWidth), preferredValues.y + 10
end

function M:ResizeEmojiArea()
  if not self._chatData then
    return 0, 50
  end
  if self._chatData and #self._chatData:getEmojiList() == 0 then
    return 0, 50
  end
  local emojiNum = #self._chatData:getEmojiList()
  local width = emojiNum * ChatLayoutEmojiLength + math.max(0, emojiNum - 1) * ChatLayoutEmojiSpace
  return width, 50
end

function M:TranslateMsg()
  local chatData = self:GetEasterEggRoomChatData(self._chatData:getSeqId())
  if chatData:IsTranslating() then
    return
  end
  local _translationMsg = chatData:getTranslationMsg()
  if not string.IsNullOrEmpty(_translationMsg) and chatData:GetCanRefreshTranslate() == 1 then
    return
  end
  chatData:setTranslateState(1)
  ChatManager2:GetInstance().Translate:UpdateTranslateInfo(self)
  if string.IsNullOrEmpty(_translationMsg) or chatData.translatedLang ~= ChatInterface.GetChatTranslateLanguageAbbr() then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_TRANSLATE, chatData)
  elseif chatData:GetCanRefreshTranslate() ~= 1 then
    self:TranslateMsgThenChangeType()
  else
    chatData:setTranslateState(0)
  end
  self:UpdateTranslateBtnState(chatData)
end

function M:TranslateMsgThenChangeType()
  local chatData = self:GetEasterEggRoomChatData(self._chatData:getSeqId())
  chatData:setTranslateState(1)
  local transType = chatData:GetTranslateType()
  if transType == nil then
    transType = 1
  elseif transType == 0 then
    transType = 1
  elseif transType == 1 then
    transType = 0
  end
  chatData:SetTranslateType(transType)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_TRANSLATE, chatData)
end

function M:UpdateTranslateBtnState(chatData)
  local isTranslating = chatData:IsTranslating()
  local hasTranslated = chatData:GetTranslateState() == 2
  if self.translateBtn == nil then
    return
  end
  self.translating:SetActive(isTranslating and not hasTranslated)
  self.translateBtn:SetActive(not isTranslating and not hasTranslated)
  self.translateFinishImg:SetActive(hasTranslated and self._chatData:GetCanRefreshTranslate() == 1)
  self.translateRefreshBtn:SetActive(hasTranslated and self._chatData:GetCanRefreshTranslate() ~= 1)
end

function M:ResetTranslatePart()
  if self.translateBtn == nil then
    return
  end
  self.translateBtn:SetActive(false)
  self.translateRefreshBtn:SetActive(false)
  self.translateFinishImg:SetActive(false)
  self.translating:SetActive(false)
  self._traText:SetActive(false)
end

function M:OnTranslateItem(chatInfo)
  if not chatInfo then
    return
  end
  if self._chatData.roomId == chatInfo.roomId and self._chatData.seqId == chatInfo.seqId then
    self:TranslateMsg()
  end
end

function M:UpdateItemWithNew(chatData)
  if chatData == nil then
    return
  end
  if chatData.roomId == self._chatData.roomId and chatData.seqId == self._chatData.seqId then
    self:UpdateChatData(chatData)
  end
end

function M:OnClickEmoji(index)
  if self._chatData == nil then
    return
  end
  ChatManager2:GetInstance():SendEmojiComments_EasterEgg(self._chatData:getSeqId(), index, self._chatData.roomId, self._chatData.senderUid)
end

function M:UpdateUserInfoWithNew()
  if self.postItem and type(self.postItem.UpdateUserInfoWithNew) == "function" then
    self.postItem:UpdateUserInfoWithNew()
  end
  if self._chatData.post ~= PostType.Text_Normal then
    self._traText:SetColor(DefaultChatMsgColor)
    self._dividingLine:SetColor(Color.New(DefaultChatMsgColor.r, DefaultChatMsgColor.g, DefaultChatMsgColor.b, 0.5))
  end
end

function M:SetContentViewScript(chatMainView)
  self._contentViewScript = chatMainView
end

function M:GetChatItemMaxWidth()
  local _screenWidth = 750 / Screen.height * Screen.width
  local finalWidth = _screenWidth * 0.645 + 250
  if self._contentViewScript and self._contentViewScript.transform then
    finalWidth = self._contentViewScript.transform.rect.width
  end
  return finalWidth
end

function M:RefreshAnonymousShow()
  local senderUid = self._chatData.senderUid
  self._userInfo = ChatInterface.getUserData(senderUid)
  self._chatUserName:UpdateName(self._userInfo, self._chatData)
  self.uid = self._userInfo.uid
  local anonymousData = self._chatData.extra
  if anonymousData == nil then
    Logger.LogError("\229\140\191\229\144\141\231\138\182\230\128\129\230\149\176\230\141\174\228\184\141\229\173\152\229\156\168")
    return
  end
  local curAnonymousInfo = string.split(anonymousData.anonymousHead, ";")
  local isAnonymous = tonumber(curAnonymousInfo[3]) == 0
  self._chatHead:SetActive(not isAnonymous)
  self.compChatHeadAnonymous:SetActive(isAnonymous)
  if isAnonymous then
    self:UpdateAnonymousHead(self.uid)
  else
    self._chatHead:UpdateHead(self._userInfo, self._chatData)
  end
  local eggInfo = self.view:GetEggInfo()
  if eggInfo == nil then
    self.compPosterFlag1:SetActive(false)
    self.compPosterFlag2:SetActive(false)
    Logger.LogError("\229\164\141\230\180\187\232\138\130\226\128\148\226\128\148\226\128\148\226\128\148\231\130\185\229\135\187\229\143\145\233\128\129\232\175\132\232\174\186\230\151\182\239\188\140\228\184\187\231\149\140\233\157\162eggInfo\228\184\186\231\169\186\239\188\129")
    return
  end
  local posterInfo = eggInfo:GetPosterInfo()
  self.compPosterFlag1:SetActive(posterInfo.uid == self._chatData.senderUid)
  self.compPosterFlag2:SetActive(posterInfo.uid == self._chatData.senderUid)
  self.compRoot:SetLocalScaleXYZ(self.scaleValue, self.scaleValue, self.scaleValue)
end

function M:UpdateAnonymousHead(uid)
  if self.uid and self.uid == uid and self._chatData then
    local userInfo = ChatInterface.getUserData(uid)
    if userInfo then
      local anonymousData = self._chatData.extra
      if anonymousData == nil then
        Logger.LogError("\229\140\191\229\144\141\231\138\182\230\128\129\230\149\176\230\141\174\228\184\141\229\173\152\229\156\168")
        return
      end
      local curAnonymousInfo = string.split(anonymousData.anonymousHead, ";")
      local isAnonymous = tonumber(curAnonymousInfo[3]) == 0
      if isAnonymous then
        local headId
        if uid == LuaEntry.Player.uid then
          local activityData = DataCenter.ActEasterEggManager:GetActivityData()
          headId = activityData.anonymousHeadId
        else
          local lastestAnonymousHead = userInfo.curAnonymousHead or anonymousData.anonymousHead
          curAnonymousInfo = string.split(lastestAnonymousHead, ";")
          headId = tonumber(curAnonymousInfo[2])
        end
        local iconPath = HeroUtils.GetHeroIconPath(headId)
        self.circleImgAnonymous:LoadSprite(iconPath)
      end
    end
  end
end

function M:GetEasterEggRoomChatData(seqId)
  local easterEggRoomId = ChatManager2:GetInstance().Room:GetEasterEggRoomId()
  local chatData = ChatManager2:GetInstance().Room:GetChat(easterEggRoomId, seqId)
  return chatData
end

return M
