local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local EasterEggChatWithoutHeadFrame = BaseClass("EasterEggChatWithoutHeadFrame", IChatItem)
local M = EasterEggChatWithoutHeadFrame
local base = IChatItem
local ResourceManager = CS.GameEntry.Resource
local post_async_loading_path = "PostAsyncLoading"

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.instanceRequest = nil
end

function M:OnDestroy()
  self:OnRecycleItem()
  self:ReleaseAsset()
end

function M:OnAddListener()
  base.OnAddListener(self)
  local ChatEventEnum = _ENV.ChatEventEnum
  self:AddUIListener(ChatEventEnum.CHAT_UPDATE_ROOM_MSG, self.UpdateItemWithNew)
end

function M:OnRemoveListener()
  local ChatEventEnum = _ENV.ChatEventEnum
  self:RemoveUIListener(ChatEventEnum.CHAT_UPDATE_ROOM_MSG, self.UpdateItemWithNew)
  base.OnRemoveListener(self)
end

function M:ComponentDefine()
  self.post_anchor = self:AddComponent(UIBaseContainer, "Root")
  self.post_async_loading = self:AddComponent(UIImage, post_async_loading_path)
end

function M:UpdateItem(chatdata, index)
  base.UpdateItem(self, chatdata, index)
  self.loadingFinish = false
  if index ~= nil then
    self._chatIndex = index
  end
  self.IsMyChat = self._chatData:isMyChat()
  self.seqId = self._chatData:getSeqId()
  self.postItemConfig = self.view.middle.scrollEggChatMessage:ChatItemPostsType2(self._chatData)
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
    self:OnLoaded()
  end)
end

function M:OnRecycleItem()
  self.post_async_loading:SetEnable(false)
  if self.tween ~= nil then
    self.tween:Kill()
    self.tween = nil
  end
  if self.postItem ~= nil then
  end
  if self.postGO == nil and self.instanceRequest ~= nil then
    self.instanceRequest:Destroy()
    self.instanceRequest = nil
  end
end

function M:ReleaseAsset()
  if self.postItem ~= nil then
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

function M:OnLoaded()
  self:UpdateChatData(self._chatData)
  self.loadingFinish = true
end

function M:UpdateChatData(chatdata)
  base.UpdateItem(self, chatdata)
  if self.postItem == nil then
    return
  end
  self.postItem:UpdateItem(chatdata, self.index)
  self:RefreshItemSize()
end

function M:RefreshItemSize()
  self.postItem.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, self.rectTransform.rect.width)
  self.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, self.postItem.rectTransform.rect.height)
  self._contentViewScript._scrollView.unity_looplistview2:OnItemSizeChanged(self._chatIndex)
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
  ChatManager2:GetInstance():SendEmojiComments(self._chatData:getSeqId(), index, self._chatData.roomId, self._chatData.senderUid)
end

function M:UpdateUserInfoWithNew()
  base.UpdateUserInfoWithNew(self)
  if self.postItem and type(self.postItem.UpdateUserInfoWithNew) == "function" then
    self.postItem:UpdateUserInfoWithNew()
  end
end

return EasterEggChatWithoutHeadFrame
