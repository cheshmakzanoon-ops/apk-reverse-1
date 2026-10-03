local GroupChatFrame = BaseClass("GroupChatFrame", UIBaseContainer)
local base = UIBaseContainer
local GroupChatFrameConfig = {
  [GroupChatItemType.SelectMember] = {
    classPath = "UI.UIChatGroupSelectMember.Component.SelectMemberItemComponent",
    path = "Assets/Main/Prefabs/UI/ChatNew/GroupChat/SelectMemberItem.prefab"
  },
  [GroupChatItemType.Search] = {
    classPath = "UI.UIChatNewV2.Component.UIChatViewSearchObjItem_v2",
    path = "Assets/Main/Prefabs/UI/ChatNew/itemSearchObj.prefab"
  },
  [GroupChatItemType.MemberList] = {
    classPath = "UI.UIGroupChatSetting.Component.MemberListComponent",
    path = "Assets/Main/Prefabs/UI/ChatNew/GroupChat/MemberList.prefab"
  },
  [GroupChatItemType.GroupSettingItem] = {
    classPath = "UI.UIGroupChatSetting.Component.GroupSettingItem",
    path = "Assets/Main/Prefabs/UI/ChatNew/GroupChat/GroupSettingItem.prefab"
  }
}
local ResourceManager = CS.GameEntry.Resource

function GroupChatFrame:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function GroupChatFrame:OnDestroy()
  self:ReleaseAsset()
  base.OnDestroy(self)
end

function GroupChatFrame:ComponentDefine()
  self.post_anchor = self:AddComponent(UIBaseContainer, "Root")
  self.post_async_loading = self:AddComponent(UIImage, "PostAsyncLoading")
end

function GroupChatFrame:DataDefine()
end

function GroupChatFrame:DataDestroy()
end

function GroupChatFrame:OnRecycleItem()
  self.post_async_loading:SetEnable(false)
  if self.postItem ~= nil and self.postItem.OnRecycle then
    self.postItem:OnRecycle()
  end
  if self.postGO == nil and self.instanceRequest ~= nil then
    self.instanceRequest:Destroy()
    self.instanceRequest = nil
  end
  self.data = nil
end

function GroupChatFrame:UpdateItem(data, index)
  self.data = data
  self.index = index
  local newConfig
  newConfig = GroupChatFrameConfig[data.itemType]
  if self.postGO ~= nil and self.config == newConfig then
    self:OnLoaded()
    return
  else
    self:ReleaseAsset()
    self.config = newConfig
  end
  if self.instanceRequest ~= nil then
    return
  end
  self.instanceRequest = ResourceManager:InstantiateAsyncImmediately(self.config.path, function(request)
    local go = request.gameObject
    self.post_async_loading:SetEnable(false)
    if self.tween ~= nil then
      self.tween:Kill()
      self.tween = nil
    end
    self.postGO = go
    self.postGO:SetActive(true)
    local trans = go.transform
    trans:SetParent(self.post_anchor.transform, false)
    if not self.config.class then
      self.config.class = require(self.config.classPath)
    end
    self.postItem = self:AddComponent(self.config.class, self.postGO)
    if CommonUtil and CommonUtil.IsArabicAutoMirrorOpen() and not request.isUseCache then
      CommonUtil.CallAutoArabicMirrorManually(go)
    end
    self.postItem:SetLocalScaleXYZ(1, 1, 1)
    self.postItem:SetAnchoredPositionXY(0, 0)
    self:OnLoaded()
  end)
end

function GroupChatFrame:ReleaseAsset()
  if self.postItem ~= nil then
    if self.postItem.OnRecycle then
      self.postItem:OnRecycle()
    end
    self.postItem = nil
  end
  if self.config ~= nil and self.postGO ~= nil then
    self:RemoveComponentOnly(self.postGO.name, self.config.class)
  end
  if self.instanceRequest ~= nil then
    self.instanceRequest:Destroy()
    self.instanceRequest = nil
    self.postGO = nil
  end
end

function GroupChatFrame:SetContentViewScript(contentView)
  self.contentView = contentView
end

function GroupChatFrame:OnLoaded()
  self.postItem:SetContentViewScript(self.contentView)
  if self.postItem.SetFrame then
    self.postItem:SetFrame(self)
  end
  if self.data.itemType == GroupChatItemType.Search then
    self.postItem:UpdateItem(self.data.search, self.data.normalTypeShowFunc, self.data.searchTypeShowFunc, self.data.needFindNum)
  else
    self.postItem:UpdateItem(self.data, self.index)
  end
  self:RefreshItemSize()
end

function GroupChatFrame:RefreshItemSize()
  self.postItem.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, self.rectTransform.rect.width)
  local height = self.postItem.rectTransform.rect.height
  self.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, height)
  self.contentView._scrollView.unity_looplistview2:OnItemSizeChanged(self.index)
end

function GroupChatFrame:OnAddListener()
end

function GroupChatFrame:OnRemoveListener()
end

return GroupChatFrame
