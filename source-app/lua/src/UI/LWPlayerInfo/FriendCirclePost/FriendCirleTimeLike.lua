local Canvas = CS.UnityEngine.Canvas
local FriendCirleTimeLike = BaseClass("FriendCirleTimeLike", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local upImg = "Moment/zyf_pyq_dianzai_icon"
local upFinImg = "Moment/zyf_pyq_yidianzai_icon"
local comImg = "Moment/zyf_pyq_pinglun_icon"
local comFinImg = "Moment/zyf_pyq_yipinglun_icon"
local maxWidth = 460

function FriendCirleTimeLike:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.frame = nil
end

function FriendCirleTimeLike:OnAddListener()
  base.OnAddListener(self)
end

function FriendCirleTimeLike:OnRemoveListener()
  base.OnRemoveListener(self)
end

function FriendCirleTimeLike:ComponentDefine()
  self.likeText = self:AddComponent(UIText, "com/likeBtnItem/likeCountText")
  self.timeText = self:AddComponent(UIText, "timeLayout/timeText")
  self.commentText = self:AddComponent(UIText, "com/comment/count")
  self.likeBtn = self:AddComponent(UIButton, "com/likeBtnItem")
  self.likeBgImg = self:AddComponent(UIImage, "com/likeBtnItem")
  self.commentCom = self:AddComponent(UIImage, "com/comment")
  self.likeIcon = self:AddComponent(UIImage, "com/likeBtnItem/likeIcon")
  self.commentIcon = self:AddComponent(UIImage, "com/comment/icon")
  self.likeLayout = self:AddComponent(UIBaseContainer, "com")
  self.likeBtn:SetOnClick(function()
    local likeType = InteractiveUtil.ThumbsUpType.FriendsCirleUp
    if self._chatData.post == PostType.Chat_Moment then
      likeType = InteractiveUtil.ThumbsUpType.FriendsCirleComment
    end
    ChatManager2:GetInstance():SendEmojiComments(self._chatData:getSeqId(), EmojiCommentsType.Up, self._chatData.roomId, self._chatData.senderUid, false, likeType)
  end)
end

function FriendCirleTimeLike:UpdateChatData(chatData, frame)
  if self._chatData and self._chatData.notLikeLayOut ~= chatData.notLikeLayOut then
    return
  end
  self.frame = frame
  self._chatData = chatData
  local emojis = chatData.emojis
  local count = 0
  for i = 1, #emojis do
    if emojis[i].emoji == EmojiCommentsType.Up then
      count = emojis[i].count
    end
  end
  self.likeText:SetText(count)
  self.commentText:SetText(chatData.commentNum)
  local timeText = UITimeManager:GetInstance():GetFriendsCirleShowTime(chatData.serverTime)
  self.timeText:SetText(timeText)
  local preferredValues = self.timeText.unity_tmpro:GetPreferredValues(maxWidth, 0)
  local width = preferredValues.x > maxWidth and maxWidth or preferredValues.x
  self.timeText.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, width)
  local isOn = self._chatData.notLikeLayOut or false
  if self._chatData.post == PostType.Chat_Moment then
    self.commentCom:SetActive(false)
    self.likeLayout:SetActive(true)
  else
    self.commentCom:SetActive(true)
    self.likeLayout:SetActive(ChatInterface.getMoment():GetIsMomentBody(self._chatData.post) and not isOn)
  end
  if ChatInterface.getMoment():GetIsMomentBody(self._chatData.post) then
    Canvas.ForceUpdateCanvases()
  end
end

function FriendCirleTimeLike:InitItemByModel()
  if not self.frame then
    return
  end
  local modelIndex = self.frame:GetModelIndex()
  local color = ChatUIThemeConfig.MomentOrdinaryColor[modelIndex]
  local upColor, comColor
  if self._chatData:isPlayerFollowEmoji(EmojiCommentsType.Up) then
    upColor = ChatUIThemeConfig.MomentClickColor[modelIndex]
    self.likeIcon:LoadSprite(self.frame:GetModelImgPath(upFinImg))
  else
    upColor = color
    self.likeIcon:LoadSprite(self.frame:GetModelImgPath(upImg))
  end
  if self._chatData:IsSelfComment() then
    comColor = ChatUIThemeConfig.MomentClickColor[modelIndex]
    self.commentIcon:LoadSprite(self.frame:GetModelImgPath(comFinImg))
  else
    comColor = color
    self.commentIcon:LoadSprite(self.frame:GetModelImgPath(comImg))
  end
  self.likeText:SetColor(upColor)
  self.commentText:SetColor(comColor)
  self.commentCom:SetColorRGBA(0, 0, 0, 0)
  self.likeBgImg:SetColorRGBA(0, 0, 0, 0)
end

function FriendCirleTimeLike:ComponentDestroy()
  self.likeText = nil
  self.timeText = nil
  self.commentText = nil
  self.likeBtn = nil
  self.frame = nil
end

function FriendCirleTimeLike:GetOffsetWorldPos()
  local preferredValues = self.timeText.unity_tmpro:GetPreferredValues(maxWidth, 0)
  local scaleX = self.timeText.transform.lossyScale.x
  local worldOffset = preferredValues.x * scaleX
  local worldPos = self.timeText.transform.position
  worldPos.x = worldPos.x + worldOffset
  return worldPos
end

function FriendCirleTimeLike:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function FriendCirleTimeLike:DataDestroy()
end

return FriendCirleTimeLike
