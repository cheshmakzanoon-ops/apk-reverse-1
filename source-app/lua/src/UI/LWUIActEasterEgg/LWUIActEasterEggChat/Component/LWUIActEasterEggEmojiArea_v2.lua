local base = UIBaseContainer
local LWUIActEasterEggEmojiArea_v2 = BaseClass("LWUIActEasterEggEmojiArea_v2", base)
local M = LWUIActEasterEggEmojiArea_v2
local ChatViewEmojiPartitionText = require("UI.UIChatNewV2.Component.Emoji.ChatViewEmojiPartitionText")
local UIChatViewEmojiList = require("UI.UIChatNewV2.Component.Emoji.UIChatViewEmojiList")
local UIGray = CS.UIGray
local EmojiTabTypeConfig = _ENV.EmojiTabTypeConfig
local compBook = {
  {
    path = "Panel/ScrollEmoji",
    name = "emojiPanelLoopListView",
    type = UILoopListView2
  },
  {
    path = "Panel/ScrollEmoji/MainViewport/ContentEmoji",
    name = "emojiPanelContent",
    type = UIBaseContainer
  },
  {
    path = "Panel/ScrollEmoji/MainViewport/EmojiFunction",
    name = "emojiFunction",
    type = UIBaseContainer
  },
  {
    path = "Panel/ScrollEmoji/MainViewport/EmojiFunction/deleteBtn",
    name = "deleteBtn",
    type = UIButton,
    onClick = function(self)
      self:OnDeleteBtnClick()
    end
  },
  {
    path = "Panel/ScrollEmoji/MainViewport/EmojiFunction/sendBtn",
    name = "sendBtn",
    type = UIButton,
    onClick = function(self)
      self:OnSendBtnClick()
    end
  }
}

function M:OnCreate()
  base.OnCreate(self)
  self:DefineCompsByBook(compBook)
  self:InitData()
  self.emojiFunction:SetActive(not ChatInterface.IsUnlockEmojiInput() or CS.SDKManager.IS_UNITY_ANDROID() or CS.SDKManager.IS_UNITY_IOS())
end

function M:OnDestroy()
  self:ClearEmojiPanel()
  self:ClearCompsByBook(compBook)
  self.curActiveEmojiTabCfg = EmojiTabTypeConfig.EmojiPanel
  base.OnDestroy(self)
end

function M:OnAddListener()
  base.OnAddListener(self)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
end

function M:InitData()
  self.contentCellList = {}
  self.curActiveEmojiTabCfg = EmojiTabTypeConfig.EmojiPanel
  self.itemIndex = 0
  self.emojiPanelLoopListView:InitListView(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index, self.emojiPanelContent)
  end)
end

function M:GetEmojiItemInfo(index)
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
  end
end

function M:SetMobilInputId(mobilId)
  self.mobilInputId = mobilId
end

function M:ClearEmojiPanel()
  self.emojiPanelLoopListView:ClearAllItems()
  self.panelShowDataList = nil
end

function M:SendDeleteBtnSetGray(isOn)
  UIGray.SetGray(self.deleteBtn.transform, isOn, not isOn)
  UIGray.SetGray(self.sendBtn.transform, isOn, not isOn)
end

function M:UpdateItems()
  self:SelectActiveEmojiTabCfg()
end

function M:SelectActiveEmojiTabCfg()
  self.emojiPanelLoopListView:SetActive(true)
  if self.curActiveEmojiTabCfg == EmojiTabTypeConfig.EmojiPanel then
    self.panelShowDataList = DataCenter.ChatEmojiManager:GetEmojiPanelData()
    local count = #self.panelShowDataList
    self.emojiPanelLoopListView:SetListItemCount(count, false, false)
    self.emojiPanelLoopListView:RefreshAllShownItem()
  end
end

function M:OnGetItemByIndex(listview, index, scrollViewContent)
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

function M:SetDeleteCallBack(deleteCallBack)
  self.deleteCallBack = deleteCallBack
end

function M:SetSendCallBack(sendCallBack)
  self.sendCallBack = sendCallBack
end

function M:OnDeleteBtnClick()
  if self.deleteCallBack then
    self.deleteCallBack()
  end
end

function M:OnSendBtnClick()
  if self.sendCallBack then
    self.sendCallBack()
  end
end

return M
