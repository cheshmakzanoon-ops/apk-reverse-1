local base = UIBaseContainer
local UIChatViewEmojiArea_v2 = BaseClass("UIChatViewEmojiArea_v2", base)
local ChatViewEmojiPartitionText = require("UI.UIChatNewV2.Component.Emoji.ChatViewEmojiPartitionText")
local UIChatViewEmojiList = require("UI.UIChatNewV2.Component.Emoji.UIChatViewEmojiList")
local UIChatViewStickerList = require("UI.UIChatNewV2.Component.Emoji.UIChatViewStickerList")
local UIChatViewEmojiTabItem = require("UI.UIChatNewV2.Component.Emoji.UIChatViewEmojiTabItem")
local UIGray = CS.UIGray
local EmojiTabTypeConfig = _ENV.EmojiTabTypeConfig
local ChatEmojiPanelTabItemName = "ChatEmojiPanelTabItem"
local compBook = {
  {
    path = "Main/Panel/ScrollEmoji",
    name = "emojiPanelLoopListView",
    type = UILoopListView2
  },
  {
    path = "Main/Panel/ScrollEmoji/MainViewport/ContentEmoji",
    name = "emojiPanelContent",
    type = UIBaseContainer
  },
  {
    path = "Main/Panel/ScrollEmoji/MainViewport/EmojiFunction",
    name = "emojiFunction",
    type = UIBaseContainer
  },
  {
    path = "Main/Panel/ScrollEmoji/MainViewport/EmojiFunction/deleteBtn",
    name = "deleteBtn",
    type = UIButton,
    onClick = function(self)
      self:OnDeleteBtnClick()
    end
  },
  {
    path = "Main/Panel/ScrollEmoji/MainViewport/EmojiFunction/sendBtn",
    name = "sendBtn",
    type = UIButton,
    onClick = function(self)
      self:OnSendBtnClick()
    end
  },
  {
    path = "Main/Panel/ScrollSticker",
    name = "stickerPanelLoopListView",
    type = UILoopListView2
  },
  {
    path = "Main/Panel/ScrollSticker/MainViewport/ContentSticker",
    name = "stickerPanelContent",
    type = UIBaseContainer
  },
  {
    path = "Main/Tab/TabScrollView",
    name = "emojiTabLoopListView",
    type = UILoopListView2
  },
  {
    path = "Main/Tab/TabScrollView/Viewport/Content",
    name = "emojiTabScrollContent",
    type = UIBaseContainer
  }
}

function UIChatViewEmojiArea_v2:OnCreate()
  base.OnCreate(self)
  self:DefineCompsByBook(compBook)
  self:InitData()
  self.emojiFunction:SetActive(not ChatInterface.IsUnlockEmojiInput() or CS.SDKManager.IS_UNITY_ANDROID() or CS.SDKManager.IS_UNITY_IOS())
end

function UIChatViewEmojiArea_v2:OnDestroy()
  self:ClearTab()
  self:ClearEmojiPanel()
  self:ClearStickerPanel()
  self:ClearCompsByBook(compBook)
  self.curActiveEmojiTabCfg = EmojiTabTypeConfig.EmojiPanel
  base.OnDestroy(self)
end

function UIChatViewEmojiArea_v2:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CHAT_REFRESH_EMOJI_TAB_BY_TYPE, self.SelectActiveEmojiTabCfg)
end

function UIChatViewEmojiArea_v2:OnRemoveListener()
  self:RemoveUIListener(EventId.CHAT_REFRESH_EMOJI_TAB_BY_TYPE, self.SelectActiveEmojiTabCfg)
  base.OnRemoveListener(self)
end

function UIChatViewEmojiArea_v2:InitData()
  self.contentCellList = {}
  self:SetEmojiUnlockTabData()
  self.curActiveEmojiTabCfg = self.showEmojiTabCfgList[1]
  self.itemIndex = 0
  self.emojiTabLoopListView:InitListView(0, function(listview, index)
    return self:OnGetItemByIndex_EmojiTab(listview, index)
  end)
  self.emojiPanelLoopListView:InitListView(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index, self.emojiPanelContent)
  end)
  self.stickerPanelLoopListView:InitListView(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index, self.stickerPanelContent)
  end)
end

function UIChatViewEmojiArea_v2:GetEmojiItemInfo(index)
  local emojiData = self.panelShowDataList[index]
  if emojiData.type == ChatEmojiType.Text then
    return {
      name = "ChatViewEmojiPartitionText",
      script = ChatViewEmojiPartitionText
    }
  elseif emojiData.type == ChatEmojiType.Emoji then
    return {
      name = "UIChatViewEmojiList",
      script = UIChatViewEmojiList
    }
  elseif emojiData.type == ChatEmojiType.Sticker then
    return {
      name = "UIChatViewStickerList",
      script = UIChatViewStickerList
    }
  end
end

function UIChatViewEmojiArea_v2:ClearTab()
  self.emojiTabScrollContent:RemoveComponents(ChatEmojiPanelTabItemName)
  self.emojiTabLoopListView:ClearAllItems()
end

function UIChatViewEmojiArea_v2:SetMobilInputId(mobilId)
  self.mobilInputId = mobilId
end

function UIChatViewEmojiArea_v2:ClearEmojiPanel()
  self.emojiTabScrollContent:RemoveComponents(ChatViewEmojiPartitionText)
  self.emojiTabScrollContent:RemoveComponents(UIChatViewEmojiList)
  self.emojiPanelLoopListView:ClearAllItems()
  self.panelShowDataList = nil
end

function UIChatViewEmojiArea_v2:ClearStickerPanel()
  self.stickerPanelContent:RemoveComponents(ChatViewEmojiPartitionText)
  self.stickerPanelContent:RemoveComponents(UIChatViewStickerList)
  self.stickerPanelLoopListView:ClearAllItems()
  self.panelShowDataList = nil
end

function UIChatViewEmojiArea_v2:SendDeleteBtnSetGray(isOn)
  UIGray.SetGray(self.deleteBtn.transform, isOn, not isOn)
  UIGray.SetGray(self.sendBtn.transform, isOn, not isOn)
end

function UIChatViewEmojiArea_v2:SetEmojiUnlockTabData()
  self.showEmojiTabCfgList = {
    EmojiTabTypeConfig.EmojiPanel,
    EmojiTabTypeConfig.StickerPanel
  }
  for i = 1, #self.showEmojiTabCfgList do
    if not self.showEmojiTabCfgList[i]:getIsUnlock() then
      table.remove(self.showEmojiTabCfgList, i)
    end
  end
  if EmojiTabTypeConfig.StickerPanel:getIsUnlock() and self.view.__name ~= UIWindowNames.UIChatNew_v2 then
    for i = 1, #self.showEmojiTabCfgList do
      if self.showEmojiTabCfgList[i] == EmojiTabTypeConfig.StickerPanel then
        table.remove(self.showEmojiTabCfgList, i)
      end
    end
  end
end

function UIChatViewEmojiArea_v2:UpdateItems()
  self:RefreshEmojiTabs()
  EventManager:GetInstance():Broadcast(EventId.CHAT_REFRESH_EMOJI_TAB_BY_TYPE, self.curActiveEmojiTabCfg)
end

function UIChatViewEmojiArea_v2:RefreshEmojiTabs()
  self.emojiTabLoopListView:SetListItemCount(#self.showEmojiTabCfgList, false, false)
  self.emojiTabLoopListView:RefreshAllShownItem()
end

function UIChatViewEmojiArea_v2:SelectActiveEmojiTabCfg(activeEmojiTabCfg)
  self.curActiveEmojiTabCfg = activeEmojiTabCfg
  self.nextRefreshTime = nil
  self.emojiPanelLoopListView:SetActive(self.curActiveEmojiTabCfg == EmojiTabTypeConfig.EmojiPanel)
  self.stickerPanelLoopListView:SetActive(self.curActiveEmojiTabCfg == EmojiTabTypeConfig.StickerPanel)
  if self.curActiveEmojiTabCfg == EmojiTabTypeConfig.EmojiPanel then
    self.panelShowDataList = DataCenter.ChatEmojiManager:GetEmojiPanelData()
    local count = #self.panelShowDataList
    self.emojiPanelLoopListView:SetListItemCount(count, false, false)
    self.emojiPanelLoopListView:RefreshAllShownItem()
  elseif self.curActiveEmojiTabCfg == EmojiTabTypeConfig.StickerPanel then
    self.panelShowDataList = DataCenter.ChatEmojiManager:GetStickerPanelData()
    self.nextRefreshTime = DataCenter.ChatEmojiTemplateManager.minExpiredTime
    local count = #self.panelShowDataList
    self.stickerPanelLoopListView:SetListItemCount(count, false, false)
    self.stickerPanelLoopListView:RefreshAllShownItem()
  end
end

function UIChatViewEmojiArea_v2:OnGetItemByIndex_EmojiTab(listview, index)
  if index < 0 or index >= #self.showEmojiTabCfgList then
    return nil
  end
  index = index + 1
  local ShowInfo = self.showEmojiTabCfgList[index]
  local item = listview:NewListViewItem(ChatEmojiPanelTabItemName)
  local script = self.emojiTabScrollContent:GetComponent(item.gameObject.name, UIChatViewEmojiTabItem)
  if script == nil then
    local objectName = item.gameObject.name .. tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.emojiTabScrollContent:AddComponent(UIChatViewEmojiTabItem, objectName)
  end
  script:SetActive(true)
  script:InitView(ShowInfo)
  return item
end

function UIChatViewEmojiArea_v2:OnGetItemByIndex(listview, index, scrollViewContent)
  if index < 0 or index >= #self.panelShowDataList then
    return nil
  end
  index = index + 1
  local info = self:GetEmojiItemInfo(index)
  local item = listview:NewListViewItem(info.name)
  if item == nil then
    Logger.LogError("\232\161\168\230\131\133\230\187\145\229\138\168\229\136\151\232\161\168\232\142\183\229\143\150Item\228\184\186\231\169\186\239\188\129 \233\161\181\231\173\190\231\177\187\229\158\139\228\184\186\239\188\154" .. self.curActiveEmojiTabCfg.type)
    return
  end
  local script = scrollViewContent:GetComponent(item.gameObject.name, info.script)
  if script == nil then
    local objectName = item.gameObject.name .. tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = scrollViewContent:AddComponent(info.script, objectName)
  end
  script:SetActive(true)
  script:ReInit(self.panelShowDataList[index], self)
  return item
end

function UIChatViewEmojiArea_v2:SetDeleteCallBack(deleteCallBack)
  self.deleteCallBack = deleteCallBack
end

function UIChatViewEmojiArea_v2:SetSendCallBack(sendCallBack)
  self.sendCallBack = sendCallBack
end

function UIChatViewEmojiArea_v2:OnDeleteBtnClick()
  if self.deleteCallBack then
    self.deleteCallBack()
  end
end

function UIChatViewEmojiArea_v2:OnSendBtnClick()
  if self.sendCallBack then
    self.sendCallBack()
  end
end

function UIChatViewEmojiArea_v2:Update1000MS()
  if self.nextRefreshTime == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if curTime > self.nextRefreshTime then
    self.nextRefreshTime = nil
    EventManager:GetInstance():Broadcast(EventId.CHAT_REFRESH_EMOJI_TAB_BY_TYPE, self.curActiveEmojiTabCfg)
  end
end

return UIChatViewEmojiArea_v2
