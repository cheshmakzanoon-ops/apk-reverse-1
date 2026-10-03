local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatItemWithoutHeadFrame = BaseClass("ChatItemWithoutHeadFrame", IChatItem)
local base = IChatItem
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local ChatDataEmojiItem = require("UI.UIChatNew.Component.ChatItem.ChatDataEmojiItem")
local post_async_loading_path = "PostAsyncLoading"

function ChatItemWithoutHeadFrame:__init()
end

function ChatItemWithoutHeadFrame:__delete()
end

function ChatItemWithoutHeadFrame:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.instanceRequest = nil
  self.firstFlag = true
end

function ChatItemWithoutHeadFrame:OnDestroy()
  self:DelTimer()
  self:OnRecycleItem()
  self:ReleaseAsset()
  base.OnDestroy(self)
end

function ChatItemWithoutHeadFrame:OnAddListener()
  base.OnAddListener(self)
  local ChatEventEnum = _ENV.ChatEventEnum
  self:AddUIListener(ChatEventEnum.CHAT_UPDATE_ROOM_MSG, self.UpdateItemWithNew)
  self:AddUIListener(ChatEventEnum.CHAT_TRANSLATE_SETTING, self.UpdateTransLateMsg)
end

function ChatItemWithoutHeadFrame:OnRemoveListener()
  local ChatEventEnum = _ENV.ChatEventEnum
  self:RemoveUIListener(ChatEventEnum.CHAT_UPDATE_ROOM_MSG, self.UpdateItemWithNew)
  self:RemoveUIListener(ChatEventEnum.CHAT_TRANSLATE_SETTING, self.UpdateTransLateMsg)
  base.OnRemoveListener(self)
end

function ChatItemWithoutHeadFrame:ComponentDefine()
  self.post_anchor = self:AddComponent(UIBaseContainer, "Root")
  self.post_async_loading = self:AddComponent(UIImage, post_async_loading_path)
  self.deleteTimeGo = self:AddComponent(UIBaseContainer, "DeleteTimeGo")
  self.deleteTimeTxt = self:AddComponent(UITextMeshProUGUIEx, "DeleteTimeGo/DeleteTimeTxt")
end

function ChatItemWithoutHeadFrame:UpdateItem(chatdata, index, extraInfo)
  base.UpdateItem(self, chatdata, index)
  self.loadingFinish = false
  if index ~= nil then
    self._chatIndex = index
  end
  if extraInfo ~= nil then
    self._extraInfo = extraInfo
  end
  self.IsMyChat = self._chatData:isMyChat()
  self.seqId = self._chatData:getSeqId()
  if self.view and self.view.middle and self.view.middle.scrollMsgs and self.view.middle.scrollMsgs.GetPostConfig_System then
    self.postItemConfig = self.view.middle.scrollMsgs:GetPostConfig_System(self._chatData, index)
  end
  if self.postItemConfig == nil then
    return
  end
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
    self.postGO:SetActive(true)
    local trans = go.transform
    trans:SetParent(self.post_anchor.transform, false)
    self.postItem = self:AddComponent(self.postItemConfig.postClass, self.postGO)
    self.postItem:SetPivotXY(0.5, 0.5)
    self.postItem:SetAnchoredPositionXY(0, 0)
    self.postItem:SetLocalScaleXYZ(1, 1, 1)
    self.firstFlag = true
    self:OnLoaded()
  end)
end

function ChatItemWithoutHeadFrame:OnRecycleItem()
  self.post_async_loading:SetEnable(false)
  if self.tween ~= nil then
    self.tween:Kill()
    self.tween = nil
  end
  if self.postItem ~= nil and self.postItem.OnRecycle then
    self.postItem:OnRecycle()
  end
  if self.postGO == nil and self.instanceRequest ~= nil then
    self.instanceRequest:Destroy()
    self.instanceRequest = nil
  end
  self:DelTimer()
end

function ChatItemWithoutHeadFrame:ReleaseAsset()
  if self.postItem ~= nil then
    if self.postItem.OnRecycle then
      self.postItem:OnRecycle()
    end
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

function ChatItemWithoutHeadFrame:OnLoaded()
  self:UpdateChatData(self._chatData)
  self.loadingFinish = true
end

function ChatItemWithoutHeadFrame:UpdateChatData(chatdata)
  base.UpdateItem(self, chatdata)
  if self.postItem == nil then
    return
  end
  self.postItem:UpdateItem(chatdata, self.index)
  self:CheckShowDeleteInfo(chatdata)
  self:RefreshDeleteTime(chatdata)
  self:RefreshItemSize(chatdata)
end

function ChatItemWithoutHeadFrame:RefreshItemSize(chatdata)
  self.postItem.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, self.rectTransform.rect.width)
  local height = self.postItem.rectTransform.rect.height
  if not self.postItem.UseCustomDeleteTime and self.showDeleteInfo then
    height = height + 40
    self.post_anchor:SetAnchoredPositionXY(0, 20)
  else
    self.post_anchor:SetAnchoredPositionXY(0, 0)
  end
  self.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, height)
  local index = self._chatIndex - 1
  self._contentViewScript._scrollView.unity_looplistview2:OnItemSizeChanged(index)
end

function ChatItemWithoutHeadFrame:CheckShowDeleteInfo(chatdata)
  if self._extraInfo and self._extraInfo.chatItemUIType ~= ChatItemUIType.Normal then
    self.showDeleteInfo = false
    return
  end
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

function ChatItemWithoutHeadFrame:RefreshDeleteTime(chatdata)
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

function ChatItemWithoutHeadFrame:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.SetRemainTime, self, false, false, false)
  end
  self.timer:Start()
end

function ChatItemWithoutHeadFrame:DelTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function ChatItemWithoutHeadFrame:SetRemainTime()
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

function ChatItemWithoutHeadFrame:UpdateItemWithNew(chatData)
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

function ChatItemWithoutHeadFrame:UpdateTransLateMsg()
  self._chatData:setTranslateState(0)
  self:UpdateItem(self._chatData)
  self._contentViewScript:ReloadAfterTranslateRecv(self._chatIndex)
end

function ChatItemWithoutHeadFrame:OnClickEmoji(index)
  if self._chatData == nil then
    return
  end
  ChatManager2:GetInstance():SendEmojiComments(self._chatData:getSeqId(), index, self._chatData.roomId, self._chatData.senderUid)
end

function ChatItemWithoutHeadFrame:UpdateUserInfoWithNew()
  base.UpdateUserInfoWithNew(self)
  if self.postItem and type(self.postItem.UpdateUserInfoWithNew) == "function" then
    self.postItem:UpdateUserInfoWithNew()
  end
end

return ChatItemWithoutHeadFrame
