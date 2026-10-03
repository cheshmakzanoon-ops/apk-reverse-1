local BaseLoopView = BaseClass("BaseLoopView", UIBaseContainer)
local base = UIBaseContainer

function BaseLoopView:OnCreate()
  base.OnCreate(self)
  self._chatItemObjList = {}
  self._chatItemObjList = {}
  self._chatDatas = {}
  self:ComponentDefine()
end

function BaseLoopView:ComponentDefine()
  self._scrollView = self:AddComponent(UILoopListView2, "")
  self._scrollView:InitListViewParam2(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end, nil, nil, function(loopListViewItem)
    self:OnRecycleItemFunc(loopListViewItem)
  end)
  
  function self._scrollView.unity_looplistview2.mOnEndDragAction()
    self:OnDragEnd()
  end
  
  self.itemContent = self:AddComponent(UIBaseContainer, "MainViewport/MainContent")
end

function BaseLoopView:SetChatItemSizeDelta(item)
  if item.CachedRectTransform.sizeDelta.x == self._scrollView:GetViewPortWidth() - 50 then
    return
  end
  self.chatItemSizeDelta = self.chatItemSizeDelta or Vector2.zero
  self.chatItemSizeDelta.x = self._scrollView:GetViewPortWidth() - 50
  self.chatItemSizeDelta.y = item.CachedRectTransform.sizeDelta.y
  item.CachedRectTransform.sizeDelta = self.chatItemSizeDelta
end

function BaseLoopView:SetOnDragEndCallBack(On)
end

function BaseLoopView:OnDragEnd()
  if ChatManager2:GetInstance().Room:GetIsNewPrivateList() then
    local containerTrans = self._scrollView.unity_looplistview2.ContainerTrans
    if containerTrans.localPosition.y <= 0 then
      self:OnTopPull()
    elseif containerTrans.localPosition.y > containerTrans.rect.size.y - self._scrollView.rectTransform.rect.size.y then
      self:OnBottomPull()
    end
  end
end

function BaseLoopView:OnTopPull()
end

function BaseLoopView:OnBottomPull()
end

function BaseLoopView:GetItemNameSequence()
  NameCount = NameCount + 1
  return tostring(NameCount)
end

function BaseLoopView:OnRecycleItemFunc(loopListViewItem)
  if loopListViewItem == nil then
    return
  end
  local script = self._chatItemObjList[loopListViewItem]
  if script ~= nil then
    if script.OnRecycleItem then
      script:OnRecycleItem()
    end
    script:SetActive(false)
  end
end

function BaseLoopView:GetItemCount()
  return table.length(self._chatDatas)
end

function BaseLoopView:GetItemPrefabName()
end

function BaseLoopView:GetChatItemScriptName()
end

function BaseLoopView:OnItemCreate(item, index)
end

function BaseLoopView:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self._chatDatas then
    return nil
  end
  local prefabName = self:GetItemPrefabName(index)
  local item = loopScroll:NewListViewItem(prefabName)
  if not item then
    return
  end
  local temp = self._chatItemObjList[item]
  if temp then
    temp:SetActive(true)
    temp:UpdateItem(self._chatDatas[index], index - 1, index == #self._chatDatas)
    self:SetChatItemSizeDelta(item)
    self:OnItemCreate(temp, index)
  else
    local script = self:GetChatItemScriptName(index)
    local objectName = self:GetItemNameSequence()
    item.gameObject.name = objectName
    temp = self.itemContent:AddComponent(script, item.gameObject)
    temp:SetActive(true)
    self:SetChatItemSizeDelta(item, index)
    if temp.SetContentViewScript then
      temp:SetContentViewScript(self)
    end
    temp:UpdateItem(self._chatDatas[index], index - 1, index == #self._chatDatas)
    self:OnItemCreate(temp, index)
    self._chatItemObjList[item] = temp
  end
  return item
end

function BaseLoopView:RefreshRoomData(roomId)
  self.roomId = roomId
  local room = ChatInterface.getRoomData(roomId)
  if room then
    self._chatDatas = DeepCopy(room.msgs)
    table.sort(self._chatDatas, function(a, b)
      return a.serverTime > b.serverTime
    end)
    self._scrollView:SetListItemCount(#self._chatDatas, false, false)
    self._scrollView.unity_looplistview2:RefreshAllShownItem()
  end
end

function BaseLoopView:ComponentDestroy()
  self._scrollView:RecycleAllItem()
  self._scrollView.unity_looplistview2.mOnEndDragAction = nil
  self.itemContent = nil
  self._scrollView = nil
end

function BaseLoopView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function BaseLoopView:DataDestroy()
  self.roomId = nil
  self._chatItemObjList = {}
  self._chatDatas = nil
end

return BaseLoopView
