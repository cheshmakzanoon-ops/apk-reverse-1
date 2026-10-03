local LWUIChatOperationView = BaseClass("LWUIChatOperationView", UIBaseView)
local LWUIChatOperationItem = require("UI.LWUIChatOperation.Component.LWUIChatOperationItem")
local LWUIChatOperationLoopView = require("UI.LWUIChatOperation.Component.LWUIChatOperationLoopView")
local LWUIChatEmojiLoopView = require("UI.LWUIChatOperation.Component.LWUIChatEmojiLoopView")
local base = UIBaseView
local operationBottomBlankHeight = 40
local operatHigth = 110
local animSpeed = 0.3
local topLikeHeight = 230
local topNoLikeHeight = 110

function LWUIChatOperationView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function LWUIChatOperationView:DataDefine()
  self.chatUserData = nil
  self.chatData = nil
  self.emojiPlayerDic = nil
  self.emojis = nil
  self.operations = nil
end

local Y_COLLAPSED = -350
local Y_EXPANDED = 0
local Y_CLOSE = -500

function LWUIChatOperationView:ComponentDefine()
  self.operationScrollView = self:AddComponent(LWUIChatOperationLoopView, "BG/operationScrollView")
  self.closeBtn = self:AddComponent(UIButton, "btnClose")
  self.emojiScrollView = self:AddComponent(LWUIChatEmojiLoopView, "BG/emojiScrollView")
  self.bg = self:AddComponent(UIImage, "BG")
  self.topIcon = self:AddComponent(UIImage, "BG/topIcon")
  self.topIcon:LoadSprite(ChatInterface.GetChatUIPath("ChatWindow/zyf_reaction_tiao1.png"))
  self.closeBtn:SetOnClick(function()
    self:CloseView()
  end)
  self.state = 1
  self.eventTrigger = self:AddComponent(UIEventTrigger, "BG/eventTrigger")
  self.touchTrough = self.eventTrigger.rectTransform:GetComponent(typeof(CS.LFTouchThrough))
  self.playerLoading = self:AddComponent(UIImage, "BG/operationScrollView/playerLoading")
  self.eventTrigger:OnBeginDrag(function(eventData)
    self.touchTrough:SetPassPointer(false)
    self._lastPointerY = eventData.position.y
    self._dragStartY = self.bg.rectTransform.anchoredPosition.y
    self.operationScrollView._scrollView:OnBeginDrag(eventData)
    self._pointerStartY = eventData.position.y
  end)
  self.eventTrigger:OnDrag(function(eventData)
    local container = self.operationScrollView._scrollView.unity_looplistview2.ContainerTrans
    local isAtTop = container.localPosition.y <= 0.5
    local dys = eventData.position.y - self._lastPointerY
    self._lastPointerY = eventData.position.y
    if 0 < dys then
      local dy = eventData.position.y - self._pointerStartY
      local targetY = self._dragStartY + dy
      targetY = math.min(targetY, Y_EXPANDED)
      targetY = math.max(targetY, Y_CLOSE)
      self.bg:SetAnchoredPositionXY(self.bg.rectTransform.anchoredPosition.x, targetY)
      self.operationScrollView._scrollView:OnDrag(eventData)
    elseif dys < 0 then
      if not isAtTop then
        self.operationScrollView._scrollView:OnDrag(eventData)
      else
        local dy = eventData.position.y - self._pointerStartY
        local targetY = self._dragStartY + dy
        targetY = math.min(targetY, Y_EXPANDED)
        targetY = math.max(targetY, Y_CLOSE)
        self.bg:SetAnchoredPositionXY(self.bg.rectTransform.anchoredPosition.x, targetY)
      end
    end
  end)
  self.eventTrigger:OnEndDrag(function(eventData)
    self.posY = 0
    self.operationScrollView._scrollView:OnEndDrag(eventData)
    self.touchTrough:SetPassPointer(true)
    local y = self.bg.rectTransform.anchoredPosition.y
    local distToExpanded = math.abs(y - Y_EXPANDED)
    local distToCollapsed = math.abs(y - Y_COLLAPSED)
    if y < self._dragStartY - 80 then
      self:CloseView()
    elseif distToExpanded < distToCollapsed then
      if self._dragStartY ~= Y_EXPANDED then
        self.bg.rectTransform:DOAnchorPosY(Y_EXPANDED, animSpeed)
      end
    elseif y < self._dragStartY then
      self:CloseView()
    else
      self.bg.rectTransform:DOAnchorPosY(Y_EXPANDED, animSpeed)
    end
  end)
end

function LWUIChatOperationView:OnTopPull()
end

function LWUIChatOperationView:OnBottomPull()
end

function LWUIChatOperationView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.APP_APPLICATION_PAUSE, self.OnApplicationPause)
  self:AddUIListener(EventId.CHAT_CHATDATA_REACTION_UPDATE, self.OnReactionUpdate)
end

function LWUIChatOperationView:OnRemoveListener()
  self:RemoveUIListener(EventId.APP_APPLICATION_PAUSE, self.OnApplicationPause)
  self:RemoveUIListener(EventId.CHAT_CHATDATA_REACTION_UPDATE, self.OnReactionUpdate)
  base.OnRemoveListener(self)
end

function LWUIChatOperationView:OnEmojiItemClick(index)
  if not self.reactionEmojis[index] then
    return
  end
  self.selectEmojiId = self.reactionEmojis[index].emoji
  self.emojiScrollView:UpdateClickBg(index)
  if not self.emojiPlayerDic or not self.emojiPlayerDic[self.selectEmojiId] then
    self.operationScrollView:RefreshList({})
    self.playerLoading:SetActive(true)
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.GetChatReaction, self.chatData.roomId, self.chatData:getSeqId(), self.reactionEmojis[index].emoji)
  else
    self.playerLoading:SetActive(false)
    self.operationScrollView:RefreshList(self.emojiPlayerDic[self.selectEmojiId])
  end
end

function LWUIChatOperationView:OnReactionUpdate(reactionData)
  if not self.emojiPlayerDic then
    self.emojiPlayerDic = {}
  end
  if not (reactionData and self.chatData) or reactionData.roomId ~= self.chatData.roomId or reactionData.seqId ~= self.chatData.seqId then
    return
  end
  if reactionData.emojiId ~= self.selectEmojiId then
    return
  end
  self.playerLoading:SetActive(false)
  if not reactionData.uidList or #reactionData.uidList == 0 then
    self.emojiPlayerDic[reactionData.emojiId] = {}
    return
  end
  table.sort(reactionData.uidList, function(a, b)
    return a.opTime > b.opTime
  end)
  self.emojiPlayerDic[reactionData.emojiId] = reactionData.uidList
  self.operationScrollView:RefreshList(reactionData.uidList)
end

function LWUIChatOperationView:OnApplicationPause(isPaused)
  if not isPaused then
    self.touchTrough:SetPassPointer(true)
  end
end

function LWUIChatOperationView:CloseView()
  self.moveAniSeq = DOTween.Sequence()
  self.moveAniSeq:Append(self.bg.transform:DOMoveY(-self.bgHeight, animSpeed))
  self.moveAniSeq:OnComplete(function()
    self.ctrl:CloseSelf()
  end)
end

function LWUIChatOperationView:ShowScrollView(scrollView, datas)
  local count = #datas
  self.operationScrollView:SetActive(0 < count)
  self:ClearScrollView(scrollView)
  scrollView:SetTotalCount(count)
  if 0 < count then
    scrollView:RefillCells()
  end
end

function LWUIChatOperationView:ClearScrollView(scrollView)
  if not scrollView then
    return
  end
  scrollView:ClearCells()
  scrollView:RemoveComponents(LWUIChatOperationItem)
end

function LWUIChatOperationView:ReInit()
  self.chatUserData = self:GetUserData()
  if self.chatUserData == nil then
    Logger.LogError("\231\130\185\229\135\187\232\129\138\229\164\169\230\182\136\230\129\175\231\154\132\230\147\141\228\189\156\233\157\162\230\157\191\228\188\160\229\133\165\231\154\132\229\143\130\230\149\176 chatUserData \228\184\186nil")
    return
  end
  self.chatData = self.chatUserData.chatdata
  self.emojis = self.ctrl:GetEmojis()
  self:HideEmojis()
  local finalTopBlankHeight = 0
  if self.chatUserData.chatdata:getPost() == PostType.MessageRecall or ChatInterface.getMoment():GetIsMomentData(self.chatUserData.chatdata:getPost()) then
    finalTopBlankHeight = topNoLikeHeight
    self.emojiScrollView:SetActive(false)
  else
    finalTopBlankHeight = topLikeHeight
    self.emojiScrollView:RefreshList(self.emojis)
    self.emojiScrollView:SetActive(true)
  end
  self.playerLoading:SetActive(false)
  self.operations = self.ctrl.GetOperations(self.chatUserData.chatdata, self.chatUserData.onlyEmoji, self.chatUserData.detailsData)
  local bgx, bgy = self.bg:GetSizeDelta()
  local operationsHeight = #self.operations * operatHigth
  self.bgHeight = finalTopBlankHeight + operationsHeight
  if self.operations and 0 < #self.operations then
    self.operationScrollView:SetActive(true)
    self.operationScrollView:SetSizeDeltaXY(self.operationScrollView:GetSizeDelta().x, operationsHeight + operationBottomBlankHeight)
    self.operationScrollView:RefreshList(self.operations)
  else
    self.operationScrollView:SetActive(false)
  end
  self.bg:SetSizeDeltaXY(bgx, self.bgHeight)
  self.state = 2
  self.bg:SetAnchoredPositionXY(bgx, -self.bgHeight)
  self.bg.rectTransform:DOMoveY(0, animSpeed)
end

function LWUIChatOperationView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIChatOperationView:ComponentDestroy()
  self.emojiScrollView = nil
  self.operationScrollView = nil
  self.closeBtn = nil
  self.bg = nil
  self.emojiPlayerDic = nil
end

function LWUIChatOperationView:UpdateViewTyep()
  local finalTopBlankHeight = 0
  finalTopBlankHeight = 200
  self.emojiScrollView:SetActive(true)
  self.operationScrollView:SetActive(true)
  local bgx, bgy = self.bg:GetSizeDelta()
  local operationsHeight = 7 * operatHigth
  self.bgHeight = finalTopBlankHeight + operationsHeight
  self.operationScrollView:SetSizeDeltaXY(self.operationScrollView:GetSizeDelta().x, operationsHeight + operationBottomBlankHeight)
  self.bg:SetSizeDeltaXY(bgx, self.bgHeight)
  self.bg:SetAnchoredPositionXY(bgx, -self.bgHeight)
  self.bg.rectTransform:DOMoveY(-350, animSpeed)
  self.emojiScrollView:RefreshList(self.reactionEmojis)
  self.emojiScrollView:SetActive(true)
end

function LWUIChatOperationView:SetReactionPanel()
  self.reactionEmojis = self.ctrl.GetReactionEmojis(self.chatData)
  if not self.reactionEmojis or #self.reactionEmojis == 0 then
    return
  end
  self:UpdateViewTyep()
  self:OnEmojiItemClick(1)
end

function LWUIChatOperationView:HideEmojis()
  local showEmojisList = {}
  for i = 1, #self.emojis do
    local singleBtnGroup = {}
    for j = 1, #self.emojis[i] do
      local emojiCfg = self.emojis[i][j]
      if emojiCfg.IsHideEmoji == nil or not emojiCfg.IsHideEmoji(self.chatUserData.chatdata) then
        table.insert(singleBtnGroup, emojiCfg)
      end
    end
    if 0 < #singleBtnGroup then
      table.insert(showEmojisList, singleBtnGroup)
    end
  end
  self.emojis = showEmojisList
end

return LWUIChatOperationView
