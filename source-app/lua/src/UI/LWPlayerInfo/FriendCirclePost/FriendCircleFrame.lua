require("UI.UIChatNewV2.Component.ChatItem.ChatItemPostConfig")
local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local FriendCircleFrame = BaseClass("FriendCircleFrame", IChatItem)
local base = IChatItem
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local ChatHead = require("UI.UIChatNew.Component.ChatHead")
local ChatUserName = require("UI.LWPlayerInfo.FriendCirclePost.FriendCircleUserName")
local ChatDataEmojiItem = require("UI.UIChatNew.Component.ChatItem.ChatDataEmojiItem")
local FriendCirleTimeLike = require("UI.LWPlayerInfo.FriendCirclePost.FriendCirleTimeLike")
local _cp_chatUserName = "ChatNameLayout"
local _cp_anchorTransform = "ChatAnchor"
local _cp_anchorTransform_bubbleDefault = "ChatAnchor/bubbleDefault"
local _cp_dividingLine = "ChatAnchor/CommonItems/dividingLine"
local _cp_traText = "ChatAnchor/CommonItems/TranslateText"
local translate_trans = "ChatNameLayout/NormalBg"
local translate_btn_path = "ChatNameLayout/NormalBg/TranslateBtn"
local translate_refresh_btn_path = "ChatNameLayout/NormalBg/TranslateRefreshBtn"
local translate_finish_path = "ChatNameLayout/NormalBg/TranslateFinishImg"
local translating_content_path = "ChatNameLayout/NormalBg/Translating"
local translating_text_path = "ChatNameLayout/NormalBg/Translating/TranslatingText"
local emoji_like_layout = "ChatAnchor/CommonItems/timelikeLayout/EmojiLikeLayout"
local emoji_like_item = "ChatAnchor/CommonItems/timelikeLayout/com/EmojiLikeLayout/likeBtnItem"
local bg_path = "Bg"
local black_path = "Black"
local remark_time_path = "RemarkTimeText"
local long_click_handler_path = "ChatAnchor/LongClickHandler"
local linImgPath = "Moment/cfm_tongyon_tip_xian2"
local post_async_loading_path = "PostAsyncLoading"
local emojiOffset = 0

function FriendCircleFrame:__init()
end

function FriendCircleFrame:__delete()
  if self.emoji_like_layout then
    self.emoji_like_layout:RemoveComponents(ChatDataEmojiItem)
  end
  if self.emoji_like_item then
    self.emoji_like_item.gameObject:GameObjectRecycleAll()
  end
  self:OnRecycleItem()
end

function FriendCircleFrame:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.instanceRequest = nil
  self.firstFlag = true
end

function FriendCircleFrame:OnAddListener()
  base.OnAddListener(self)
  local ChatEventEnum = _ENV.ChatEventEnum
  self:AddUIListener(ChatEventEnum.CHAT_UPDATE_ROOM_MSG, self.UpdateItemWithNew)
  self:AddUIListener(ChatEventEnum.CHAT_TRANSLATE_SETTING, self.UpdateTransLateMsg)
  self:AddUIListener(ChatEventEnum.CHAT_TRANSLATE_ITEM, self.OnTranslateItem)
end

function FriendCircleFrame:OnRemoveListener()
  local ChatEventEnum = _ENV.ChatEventEnum
  self:RemoveUIListener(ChatEventEnum.CHAT_UPDATE_ROOM_MSG, self.UpdateItemWithNew)
  self:RemoveUIListener(ChatEventEnum.CHAT_TRANSLATE_SETTING, self.UpdateTransLateMsg)
  self:RemoveUIListener(ChatEventEnum.CHAT_TRANSLATE_ITEM, self.OnTranslateItem)
  base.OnRemoveListener(self)
end

function FriendCircleFrame:ComponentDefine()
  self._chatHead = self:AddComponent(ChatHead, "ChatHead")
  self._chatHeadBg = self:AddComponent(UIImage, "ChatHead/HeadBtn")
  self._chatHeadFg = self:AddComponent(UIImage, "ChatHead/Foreground")
  self.lineImg = self:AddComponent(UIImage, "LineImg")
  self._chatHeadCanvasGroup = self:AddComponent(UICanvasGroup, "ChatHead")
  self._chatUserName = self:AddComponent(ChatUserName, _cp_chatUserName)
  self.chat_anchor = self:AddComponent(UIButton, _cp_anchorTransform)
  self.chat_anchor:SetOnClick(BindCallback(self, self.TryShowChatOperator))
  self._chat_bubble = self:AddComponent(UIImage, _cp_anchorTransform_bubbleDefault)
  self.post_anchor = self:AddComponent(UIBaseContainer, "ChatAnchor/PostAnchor")
  self.chatItemFrameCS = self.gameObject:GetComponent(typeof(CS.ChatItemFrame))
  self.common_items = self:AddComponent(UIBaseContainer, "ChatAnchor/CommonItems")
  self.commonItemLayoutCS = self.common_items.gameObject:GetComponent(typeof(CS.ChatItemPostLayout))
  self._dividingLine = self:AddComponent(UIImage, _cp_dividingLine)
  self._traText = self:AddComponent(UITextMeshProUGUIEx, _cp_traText)
  self.translateTrans = self:AddComponent(UIBaseContainer, translate_trans)
  self.translateBtn = self:AddComponent(UIButton, translate_btn_path)
  self.translateBtnImg = self:AddComponent(UIImage, "ChatNameLayout/NormalBg/TranslateBtn/Image")
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
  self.timelikeLayout = self:AddComponent(FriendCirleTimeLike, "ChatAnchor/CommonItems/timelikeLayout")
  self.timelikeLayout:SetActive(true)
  ChatInterface.SetEmojiTextProperty(self._traText)
end

function FriendCircleFrame:UpdateItem(chatdata, index, isLast, chatPhotoSource)
  base.UpdateItem(self, chatdata, index)
  self._chatUserName:SetChangeColor(self._contentViewScript.darkModeSupport)
  self.loadingFinish = false
  if index ~= nil then
    self._chatIndex = index
  end
  self.isLast = isLast
  self.IsMyChat = self._chatData:isMyChat()
  self.seqId = self._chatData:getSeqId()
  self.IsMyChat = false
  self.chatPhotoSource = chatPhotoSource
  self.postItemConfig = self:GetPostConfig()
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
  self.chat_anchor:SetActive(false)
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
    if self.postItem.SetChatPhotoSource then
      self.postItem:SetChatPhotoSource(self.chatPhotoSource)
    end
    self.postItem:Loaded(self)
    self.firstFlag = true
    self:OnLoaded()
  end)
  if self._contentViewScript and self._contentViewScript.darkModeSupport then
    self.translateBtnImg:LoadSprite(ChatUIThemeConfig.MomentImage[ChatInterface.GetChatTheme()].transPath)
  else
    self.translateBtnImg:LoadSprite(ChatUIThemeConfig.MomentImage[ChatUIThemeConfig.ChatMode.Normal].transPath)
  end
end

function FriendCircleFrame:GetPostKey()
  if self._chatData.group == ChatGroupType.GROUP_ALLIANCE_NOTICE then
    return self._chatData.group .. self._chatData.post
  end
  if ChatInterface.IsSharePoint(self._chatData.post) then
    return PostType.Text_PointShare
  end
  return self._chatData.post
end

function FriendCircleFrame:GetPostConfig()
  local postConfig = FriendsCirlePosts[self:GetPostKey()]
  if postConfig == nil then
    postConfig = FriendsCirlePosts[PostType.FriendsCirleBody]
  end
  return postConfig
end

function FriendCircleFrame:OnRecycleItem()
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
  if self.postItemConfig ~= nil then
    self:RemoveComponents(self.postItemConfig.postClass)
  end
  if self.instanceRequest ~= nil then
    self.instanceRequest:Destroy()
    self.instanceRequest = nil
    self.postGO = nil
  end
  self.onLoadCallback = nil
end

function FriendCircleFrame:OnLoaded()
  self.chat_anchor:SetActive(true)
  self:UpdateChatData(self._chatData)
  self._chatHeadCanvasGroup:SetAlpha(ChatUIThemeConfig.HeadAlpha[self:GetModelIndex()])
  self.loadingFinish = true
end

function FriendCircleFrame:GetModelIndex()
  if self and self._contentViewScript.darkModeSupport then
    return ChatInterface.GetChatTheme()
  else
    return ChatUIThemeConfig.ChatMode.Normal
  end
end

function FriendCircleFrame:GetModelImgPath(path)
  local index = self:GetModelIndex()
  return ChatUIThemeConfig.UIPrefix[index] .. path
end

function FriendCircleFrame:UpdateChatData(chatdata)
  base.UpdateItem(self, chatdata)
  if self.postItem == nil then
    return
  end
  self.postItem:OnLoaded()
  self:UpdateTranslateContent()
  self.timelikeLayout:UpdateChatData(chatdata, self)
  if self._chatData.post ~= PostType.Chat_Moment then
    self.translating:SetLocalPositionXYZ(-78, -7, 0)
  else
    self.translating:SetLocalPositionXYZ(10, -7, 0)
  end
  self.timelikeLayout:InitItemByModel()
  self:UpdateRemarkTime()
  self:RefreshItemSize()
  self:UpdateTimeLike()
  self.bgGo:SetActive(self.postItemConfig.hasBg == true)
end

function FriendCircleFrame:UpdateTimeLike()
end

function FriendCircleFrame:UpdateTranslateContent()
  local hasTranslated = false
  if not self.IsMyChat then
    if self._chatData and not self._chatData:IsLWEmoji() and self._traText ~= nil and self._dividingLine ~= nil and self.postItemConfig ~= nil and self.postItemConfig.hasTranslateBtn and not string.IsNullOrEmpty(self._chatData.msg) then
      self._traText:SetActive(false)
      self._dividingLine:SetActive(false)
      local isTranslating = self._chatData:IsTranslating()
      local translationMsg = self._chatData.translateMsg
      if not string.IsNullOrEmpty(translationMsg) and self._chatData.translatedLang == ChatInterface.GetChatTranslateLanguageAbbr() then
        hasTranslated = self._chatData:GetTranslateState() == 2
        if self.postItem and not self.postItem.hideTranslation then
          self._traText:SetActive(true)
          self._traText:SetAlignment(CommonUtil.IsArabicAutoMirrorOpen() and CS.TMPro.TextAlignmentOptions.TopRight or CS.TMPro.TextAlignmentOptions.TopLeft)
          self._traText:SetFontSize(32)
          self._traText:SetText_NotNative(translationMsg)
          self._dividingLine:SetActive(true)
        end
      end
      self:UpdateTranslateBtnState(isTranslating, hasTranslated)
    else
      self:ResetTranslatePart()
    end
  end
end

function FriendCircleFrame:LoadEmojis(chatData)
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

function FriendCircleFrame:UpdateEmojiLike()
  local hasEmojiLike = false
  if #self._chatData:getEmojiList() > 0 then
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

function FriendCircleFrame:UpdateRemarkTime()
  if self._chatData and self._chatData.group == ChatGroupType.GROUP_ALLIANCE_NOTICE then
    self.remarkTime:SetActive(true)
    self.remarkTime:SetText(UITimeManager:GetInstance():GetChatShowTime(math.floor(self._chatData.serverTime / 1000)))
  else
    self.remarkTime:SetActive(false)
  end
end

function FriendCircleFrame:SetOnAnchorClick(callBack)
  self.anchorCallBack = callBack
end

function FriendCircleFrame:TryShowChatOperator()
  if self.postItem == nil then
    return
  end
  if self.anchorCallBack then
    self.anchorCallBack()
  end
  if self.postItem and self.postItem:HandleClick() then
    return
  end
  self:ShowChatOperator()
end

function FriendCircleFrame:HandleLongPress()
  if self.postItem:HandleLongPress() then
    return
  end
  self:ShowChatOperator()
end

function FriendCircleFrame:ShowChatOperator()
  if self._chatData and self._chatData:IsLWEmoji() then
    return
  end
  local param = {}
  param.chatdata = DeepCopy(self._chatData)
  param.userinfo = self._userInfo
  param.targetPos = nil
  param.chatItem = self
  param.onlyEmoji = false
  if self.view and self.view.GetDetailsData then
    param.detailsData = self.view:GetDetailsData()
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIChatOperation, {anim = false}, param)
end

function FriendCircleFrame:SetMaxWidth(maxWidth)
  self.maxWidth = maxWidth
end

function FriendCircleFrame:GetTextMaxWidth()
  if self.maxWidth and self.maxWidth > 1 then
    return self.maxWidth - 100
  end
  return self:GetSizeDelta().x - 100
end

function FriendCircleFrame:RefreshItemSize()
  if self.postItem == nil or self.postItem.chatItemPostLayoutCS == nil then
    return
  end
  local postItemLayoutCS = self.postItem.chatItemPostLayoutCS
  postItemLayoutCS:CalculateSize()
  local preferredWidth = postItemLayoutCS.preferredWidth
  local preferredHeight = postItemLayoutCS.preferredHeight
  local paddingY = postItemLayoutCS.padding.y
  local hasCommonItems = self.timelikeLayout:GetActive() or self._chatData:GetTranslateState() == 2
  self.common_items:SetActive(hasCommonItems)
  if hasCommonItems and self.commonItemLayoutCS ~= nil then
    local posy = postItemLayoutCS.preferredHeight
    posy = self.postItem:GetContentBottomY() - 20
    self.common_items:SetAnchoredPositionXY(10, posy)
    local translateAreaWidth, translateAreaHeight = self:ResizeTranslationArea()
    self.postItem:SetTransHight(translateAreaHeight)
    self.common_items.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, translateAreaWidth)
    preferredWidth = math.max(preferredWidth, translateAreaWidth)
    preferredHeight = preferredHeight + translateAreaHeight
  end
  postItemLayoutCS:SetPreferredSize(preferredWidth, preferredHeight)
  local padding = postItemLayoutCS.padding
  preferredWidth = preferredWidth + padding.x
  preferredHeight = preferredHeight + padding.y
  self.chat_anchor.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, self:GetTextMaxWidth() - 20)
  if hasCommonItems and self.commonItemLayoutCS ~= nil then
    local translateAreaWidth, translateAreaHeight = self:ResizeTranslationArea()
    local posY = 0
    if self.postItem.isShowReadMore then
      posY = 40
    end
    preferredHeight = preferredHeight + 50
    self.timelikeLayout:SetAnchoredPositionXY(0, -translateAreaHeight - posY - self.postItem:GetImageHight() - 10)
    if self._contentViewScript and self._contentViewScript.showLine and not self.isLast then
      self.lineImg:SetActive(true)
      self.lineImg:LoadSprite(self:GetModelImgPath(linImgPath))
      self.lineImg:SetAnchoredPositionXY(0, self.chat_anchor:GetAnchoredPositionY() - preferredHeight - 30)
      self.lineImg.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, self:GetSizeDelta().x - 20)
    else
      self.lineImg:SetActive(false)
    end
  end
  if self.onLoadCallback then
    self.onLoadCallback(preferredHeight + 25)
  end
  self.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, preferredHeight + 25)
  self.timelikeLayout.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, self:GetTextMaxWidth())
  if self._chatData.post ~= PostType.Chat_Moment then
    self.translateTrans:SetAnchoredPositionXY(self:GetTextMaxWidth() - 50, 0)
  else
    local worldPos = self.timelikeLayout:GetOffsetWorldPos()
    local localPos = self.translateTrans.transform.parent:InverseTransformPoint(worldPos)
    self.translateTrans:SetAnchoredPosition(localPos)
  end
  self._contentViewScript._scrollView.unity_looplistview2:OnItemSizeChanged(self._chatIndex)
end

function FriendCircleFrame:ResizeTranslationArea()
  if not self._traText:GetActive() then
    return 0, 0
  end
  local maxWidth = self:GetTextMaxWidth()
  local preferredValues = self._traText.unity_tmpro:GetPreferredValues(maxWidth, 0)
  if maxWidth < preferredValues.x then
    self._traText.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, maxWidth)
  else
    self._traText.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, preferredValues.x)
  end
  self._traText.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, preferredValues.y)
  return math.min(preferredValues.x + 20, maxWidth), preferredValues.y + 10
end

function FriendCircleFrame:ResizeEmojiArea()
  if not self._chatData then
    return 0, 0
  end
  if self._chatData and #self._chatData:getEmojiList() == 0 then
    return 0, 0
  end
  local emojiNum = #self._chatData:getEmojiList()
  local width = emojiNum * ChatLayoutEmojiLength + math.max(0, emojiNum - 1) * ChatLayoutEmojiSpace
  return width, 50
end

function FriendCircleFrame:TranslateMsg()
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
  self:UpdateTranslateBtnState(self._chatData:IsTranslating(), self._chatData:GetTranslateState() == 2)
end

function FriendCircleFrame:TranslateMsgThenChangeType()
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

function FriendCircleFrame:UpdateTranslateBtnState(isTranslating, hasTranslated)
  if self.translateBtn == nil then
    return
  end
  self.translating:SetActive(isTranslating and not hasTranslated)
  self.translateBtn:SetActive(not isTranslating and not hasTranslated)
  self.translateFinishImg:SetActive(hasTranslated and self._chatData:GetCanRefreshTranslate() == 1)
  self.translateRefreshBtn:SetActive(hasTranslated and self._chatData:GetCanRefreshTranslate() ~= 1)
end

function FriendCircleFrame:ResetTranslatePart()
  if self.translateBtn == nil then
    return
  end
  self.translateBtn:SetActive(false)
  self.translateRefreshBtn:SetActive(false)
  self.translateFinishImg:SetActive(false)
  self.translating:SetActive(false)
  self._traText:SetActive(false)
end

function FriendCircleFrame:OnTranslateItem(chatInfo)
  if not chatInfo then
    return
  end
  if self._chatData.roomId == chatInfo.roomId and self._chatData.seqId == chatInfo.seqId then
    self:TranslateMsg()
  end
end

function FriendCircleFrame:UpdateTransLateMsg()
  self:UpdateItem(self._chatData, self._chatIndex, self.isLast, self.chatPhotoSource)
  if self._contentViewScript.ReloadAfterTranslateRecv then
    self._contentViewScript:ReloadAfterTranslateRecv(self._chatIndex)
  end
end

function FriendCircleFrame:UpdateItemWithNew(chatData)
  if chatData == nil then
    return
  end
  if chatData.roomId == self._chatData.roomId and chatData.seqId == self._chatData.seqId then
    self:UpdateChatData(chatData)
  end
end

function FriendCircleFrame:OnClickEmoji(index)
  if self._chatData == nil then
    return
  end
  ChatManager2:GetInstance():SendEmojiComments(self._chatData:getSeqId(), index, self._chatData.roomId, self._chatData.senderUid)
end

function FriendCircleFrame:UpdateUserInfoWithNew()
  base.UpdateUserInfoWithNew(self)
  if self.postItem and type(self.postItem.UpdateUserInfoWithNew) == "function" then
    self.postItem:UpdateUserInfoWithNew()
  end
  if self._chatData.post ~= PostType.Text_Normal then
    self._dividingLine:SetColor(Color.New(DefaultChatMsgColor.r, DefaultChatMsgColor.g, DefaultChatMsgColor.b, 0.5))
  end
end

function FriendCircleFrame:ShowBlackFlash()
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

function FriendCircleFrame:GetSource()
  if self._contentViewScript then
    return self._contentViewScript.chatGroup
  end
end

return FriendCircleFrame
