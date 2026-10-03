local base = UIBaseContainer
local EasterEggChatItemPost = BaseClass("EasterEggChatItemVote", base)
local M = EasterEggChatItemPost
local Localization = CS.GameEntry.Localization
local EastereggChaEmojiItem = require("UI.LWUIActEasterEgg.LWUIActEasterEggChat.Component.ChatItem.EastereggChaEmojiItem")
local topBlankHeight = 63
local internalBtwText = 10
local minDisBtwBottomPartAndTop = 120
local disBtwTextAndLike = 10

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.totalHeight = 0
end

function M:ComponentDefine()
  self.circleImgAnonymous = self:AddComponent(CircleImage, "Root/ChatHeadAnonymous/Image")
  self.txtUserName = self:AddComponent(UITextMeshProUGUIEx, "Root/ChatNameLayout/Line/NameText")
  self.nodeAnswer = self:AddComponent(UIBaseContainer, "Root/ChatNameLayout/Line/Answer")
  self.iconAnswer_A = self:AddComponent(UIBaseContainer, "Root/ChatNameLayout/Line/Answer/Answer_A")
  self.iconAnswer_B = self:AddComponent(UIBaseContainer, "Root/ChatNameLayout/Line/Answer/Answer_B")
  self.nodeGender = self:AddComponent(UIBaseContainer, "Root/ChatNameLayout/Line/Gender")
  self.iconMale = self:AddComponent(UIBaseContainer, "Root/ChatNameLayout/Line/Gender/Man")
  self.iconFemale = self:AddComponent(UIBaseContainer, "Root/ChatNameLayout/Line/Gender/Woman")
  self.translating = self:AddComponent(UIBaseContainer, "Root/NormalBg/Translating")
  self.translateFinishImg = self:AddComponent(UIBaseContainer, "Root/NormalBg/TranslateFinishImg")
  self.translateBtn = self:AddComponent(UIButton, "Root/NormalBg/TranslateBtn")
  self.translateBtn:SetOnClick(function()
    self:OnTranslateMsg()
  end)
  self.translateRefreshBtn = self:AddComponent(UIButton, "Root/NormalBg/TranslateRefreshBtn")
  self.translateRefreshBtn:SetOnClick(function()
    self:OnTranslateMsgThenChangeType()
  end)
  self.translatingText = self:AddComponent(UIText, "Root/NormalBg/Translating/TranslatingText")
  self.translatingText:SetText(Localization:GetString("120039"))
  self.textContent = self:AddComponent(UITextMeshProUGUIEx, "Root/ContentPart/txtContent")
  self.compImgLine = self:AddComponent(UIBaseContainer, "Root/ContentPart/imgLine")
  self.textTransContent = self:AddComponent(UITextMeshProUGUIEx, "Root/ContentPart/txtTransContent")
  self.compBottomPart = self:AddComponent(UIBaseContainer, "Root/BottomPart")
  self.textTime = self:AddComponent(UITextMeshProUGUIEx, "Root/BottomPart/RemarkTimeText")
  self.emojiLikeItem = self:AddComponent(EastereggChaEmojiItem, "Root/BottomPart/EmojiLikeItem")
  ChatInterface.SetEmojiTextProperty(self.textContent)
  ChatInterface.SetEmojiTextProperty(self.textTransContent)
end

function M:OnDestroy()
  self:OnRecycleItem()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDestroy()
  self.circleImgAnonymous = nil
  self.txtUserName = nil
  self.nodeAnswer = nil
  self.iconAnswer_A = nil
  self.iconAnswer_B = nil
  self.nodeGender = nil
  self.iconMale = nil
  self.iconFemale = nil
  self.translating = nil
  self.translateFinishImg = nil
  self.translateBtn = nil
  self.translateRefreshBtn = nil
  self.translatingText = nil
  self.textContent = nil
  self.compImgLine = nil
  self.textTransContent = nil
  self.compBottomPart = nil
  self.textTime = nil
  self.emojiLikeItem = nil
end

function M:OnAddListener()
  self:AddUIListener(EventId.EasterEggChatTranslateFinished, self.UpdateItem)
  self:AddUIListener(EventId.EasterEggChatClientFakeLikeNum, self.UpdateTimeAndLike)
  self:AddUIListener(EventId.PlayerMessageInfo, self.UpdatePlayerInfo)
end

function M:OnRemoveListener()
  self:RemoveUIListener(EventId.EasterEggChatTranslateFinished, self.UpdateItem)
  self:RemoveUIListener(EventId.EasterEggChatClientFakeLikeNum, self.UpdateTimeAndLike)
  self:RemoveUIListener(EventId.PlayerMessageInfo, self.UpdatePlayerInfo)
end

function M:OnRecycleItem()
  self.totalHeight = 0
  self.eggInfo = nil
  self.userInfo = nil
  self.posterInfo = nil
end

function M:SetContentViewScript(chatMainView)
  self._contentViewScript = chatMainView
end

function M:UpdateItem(chatdata, index)
  self._chatData = chatdata
  self.index = index
  self.totalHeight = 0
  self.eggInfo = self.view:GetEggInfo()
  if self.eggInfo == nil then
    Logger.LogError("\229\164\141\230\180\187\232\138\130\226\128\148\226\128\148\226\128\148\226\128\148\231\130\185\229\135\187\229\143\145\233\128\129\232\175\132\232\174\186\230\151\182\239\188\140\228\184\187\231\149\140\233\157\162eggInfo\228\184\186\231\169\186\239\188\129")
    return false
  end
  self.posterInfo = self.eggInfo:GetPosterInfo()
  self.userInfo = ChatInterface.getUserData(self.posterInfo.uid)
  self:UpdateHeadAndName()
  self:UpdateGender()
  self:UpdateAnswer()
  self:UpdateTranslateContent()
  self:UpdateTimeAndLike()
  self:RefreshItemSize()
end

function M:UpdateHeadAndName()
  self.txtUserName.unity_tmpro.enableVertexGradient = false
  self.txtUserName.unity_tmpro.outlineWidth = 0
  self.userInfo = ChatInterface.getUserData(self.posterInfo.uid)
  if self.userInfo then
    local name, headId
    if self.posterInfo.uid == LuaEntry.Player.uid then
      local activityData = DataCenter.ActEasterEggManager:GetActivityData()
      name = activityData.anonymousName
      headId = activityData.anonymousHeadId
    else
      local lastestAnonymousHead = self.userInfo.curAnonymousHead or self.eggInfo:GetCurAnonymousStr()
      local curAnonymousInfo = string.split(lastestAnonymousHead, ";")
      name = curAnonymousInfo[1]
      headId = tonumber(curAnonymousInfo[2])
    end
    local showName = DataCenter.ActEasterEggManager:GetTranslateName(name)
    self.txtUserName:SetText(showName)
    local iconPath = HeroUtils.GetHeroIconPath(headId)
    self.circleImgAnonymous:LoadSprite(iconPath)
  end
end

function M:UpdateGender()
  if not self.nodeGender then
    self.isShowGender = false
    return
  end
  self.userInfo = ChatInterface.getUserData(self.posterInfo.uid)
  local finalGender = self.posterInfo.gender
  if self.userInfo.gender ~= 0 then
    finalGender = self.userInfo.gender
  end
  if not finalGender or finalGender == 0 or finalGender == 3 then
    self.nodeGender:SetActive(false)
    self.isShowGender = false
    return
  end
  self.nodeGender:SetActive(true)
  self.isShowGender = true
  local isMan = finalGender == 1
  self.iconMale:SetActive(isMan)
  self.iconFemale:SetActive(not isMan)
end

function M:UpdateAnswer()
  local answer = self.eggInfo:GetPoserVoteRes()
  self.nodeAnswer:SetActive(answer ~= 0)
  self.iconAnswer_A:SetActive(answer == 1)
  self.iconAnswer_B:SetActive(answer == 2)
end

function M:UpdateTranslateContent()
  self:ResetTranslatePart()
  local postContent = self.eggInfo:GetPostContent()
  self.textContent:SetText(postContent)
  local textContentPreferHeight = self.textContent.unity_tmpro:GetPreferredValues().y
  self.textContent:SetSizeDeltaY(textContentPreferHeight)
  local translateData = DataCenter.ActEasterEggManager:AddorGetEggTranslateDatas(self.eggInfo:GetId(), 1, postContent, self.eggInfo:GetPostLang())
  local translateMsg = translateData:GetTranslateMsg()
  local translatedLang = translateData:GetTranslatedLang()
  local translateState = translateData:GetTranslateState()
  local hasTranslated = false
  local lineAndSpaceHeight = 0
  local textTransPreferHeight = 0
  if not string.IsNullOrEmpty(translateMsg) and translatedLang == ChatInterface.GetChatTranslateLanguageAbbr() then
    hasTranslated = translateState == 2
    self.compImgLine:SetAnchoredPositionXY(self.compImgLine:GetAnchoredPositionX(), -(textContentPreferHeight + internalBtwText))
    self.compImgLine:SetActive(true)
    self.textTransContent:SetAlignment(CommonUtil.IsArabicAutoMirrorOpen() and CS.TMPro.TextAlignmentOptions.TopRight or CS.TMPro.TextAlignmentOptions.TopLeft)
    self.textTransContent:SetText_NotNative(translateMsg)
    textTransPreferHeight = self.textTransContent.unity_tmpro:GetPreferredValues().y
    self.textTransContent:SetSizeDeltaY(textTransPreferHeight)
    lineAndSpaceHeight = internalBtwText + self.compImgLine:GetSizeDelta().y + internalBtwText
    self.textTransContent:SetAnchoredPositionXY(self.textTransContent:GetAnchoredPositionX(), -(textContentPreferHeight + lineAndSpaceHeight))
    self.textTransContent:SetActive(true)
  end
  self:UpdateTranslateBtnState(translateData)
  local isOpenAutoTranslate = DataCenter.ActEasterEggManager:GetIsOpenAutoTranslate()
  if isOpenAutoTranslate and (translateState == 0 or translateState == -1) then
    self:OnTranslateMsg()
  end
  self.totalHeight = topBlankHeight + textContentPreferHeight + lineAndSpaceHeight + textTransPreferHeight
end

function M:UpdateTimeAndLike()
  local createTime = self.eggInfo:GetCreateTime()
  self.textTime:SetText(UITimeManager:GetInstance():GetChatShowTime(math.floor(createTime)))
  local emojiData = {}
  emojiData.emoji = EmojiCommentsType.Up
  emojiData.count = self.eggInfo:GetThumbsUp()
  emojiData.self = self.eggInfo:GetPraise()
  self.emojiLikeItem:UpdateData(emojiData, self, false, 90)
end

function M:RefreshItemSize()
  self.totalHeight = math.max(minDisBtwBottomPartAndTop, self.totalHeight)
  self.compBottomPart:SetAnchoredPositionXY(self.compBottomPart:GetAnchoredPositionX(), -self.totalHeight)
  self.totalHeight = self.totalHeight + self.compBottomPart:GetSizeDelta().y + disBtwTextAndLike
  self:SetSizeDeltaY(self.totalHeight)
  self._contentViewScript._scrollView:OnItemSizeChanged(self.index)
end

function M:ResetTranslatePart()
  self.translateBtn:SetActive(false)
  self.translateRefreshBtn:SetActive(false)
  self.translateFinishImg:SetActive(false)
  self.translating:SetActive(false)
  self.compImgLine:SetActive(false)
  self.textTransContent:SetActive(false)
end

function M:UpdateTranslateBtnState(translateData)
  local isTranslating = translateData:GetTranslateState() == 1
  local hasTranslated = translateData:GetTranslateState() == 2
  self.translating:SetActive(isTranslating and not hasTranslated)
  self.translateBtn:SetActive(not isTranslating and not hasTranslated)
  self.translateFinishImg:SetActive(hasTranslated and translateData:GetCanRefreshTranslate() == 1)
  self.translateRefreshBtn:SetActive(hasTranslated and translateData:GetCanRefreshTranslate() ~= 1)
end

function M:OnTranslateMsg()
  local transData = DataCenter.ActEasterEggManager:GetEggTranslateDatas(self.eggInfo:GetId(), 1)
  if transData == nil then
    return
  end
  if transData:GetTranslateState() == 1 then
    return
  end
  local transMsg = transData:GetTranslateMsg()
  if not string.IsNullOrEmpty(transMsg) and transData:GetCanRefreshTranslate() == 1 then
    return
  end
  transData:SetTranslateState(1)
  if string.IsNullOrEmpty(transMsg) or transData:GetTranslatedLang() ~= ChatInterface.GetChatTranslateLanguageAbbr() then
    ChatManager2:GetInstance().Translate:EasterEggDoTranslate(transData)
  elseif transData:GetCanRefreshTranslate() ~= 1 then
    self:OnTranslateMsgThenChangeType()
  else
    transData:SetTranslateState(0)
  end
  self:UpdateTranslateBtnState(transData)
end

function M:OnTranslateMsgThenChangeType()
  local transData = DataCenter.ActEasterEggManager:GetEggTranslateDatas(self.eggInfo:GetId(), 1)
  if transData == nil then
    return
  end
  transData:SetTranslateState(1)
  local transType = transData:GetTranslateType()
  if transType == nil then
    transType = 1
  elseif transType == 0 then
    transType = 1
  elseif transType == 1 then
    transType = 0
  end
  transData:SetTranslateType(transType)
  ChatManager2:GetInstance().Translate:EasterEggDoTranslate(transData)
end

function M:OnClickEmoji()
  DataCenter.ActEasterEggManager:SendEggChatThumbsUp_PostOrVote()
end

function M:UpdatePlayerInfo(uid)
  if self.posterInfo and self.posterInfo.uid and self.posterInfo.uid == uid then
    self:UpdateHeadAndName(uid)
    self:UpdateGender()
  end
end

return M
