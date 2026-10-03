local UILWRemarkNameListView = BaseClass("UILWRemarkNameListView", UIBaseView)
local base = UIBaseView
local UILWRemarkNameitem = require("UI.LWPlayerInfo.UILWPlayerRemarkName.UILWRemarkNameList.Component.UILWRemarkNameitem")
local compBook = {
  {
    path = "UICommonPopUpTitle/BtnClose",
    name = "BtnClose",
    type = UIButton,
    onClick = function(self)
      self:OnBtnClose()
    end
  },
  {
    path = "Bg/ScrollView",
    name = "ScrollLoopListView",
    type = UILoopListView2
  },
  {
    path = "Bg/ScrollView/Viewport/Content",
    name = "ScrollContent",
    type = UIBaseContainer
  },
  {
    path = "UICommonPopUpTitle/panel",
    name = "panelBtn",
    type = UIButton,
    onClick = function(self)
      self:OnBtnClose()
    end
  },
  {
    path = "Bg/noUserText",
    name = "noUserText",
    type = UITextMeshProUGUIEx
  }
}

function UILWRemarkNameListView:OnCreate()
  base.OnCreate(self)
  self:DefineCompsByBook(compBook)
  DataCenter.PlayerInfoDataManager:RequestRemarkNameList(1)
  self.itemIndex = 0
  self.ScrollLoopListView:InitListView(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end)
end

function UILWRemarkNameListView:OnDestroy()
  self.ScrollContent:RemoveComponents(UILWRemarkNameitem)
  self.ScrollLoopListView:ClearAllItems()
  self:ClearCompsByBook(compBook)
  base.OnDestroy(self)
end

function UILWRemarkNameListView:OnAddListener()
  self:AddUIListener(EventId.RefreshRemarkNameListView, self.RefreshView)
end

function UILWRemarkNameListView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshRemarkNameListView, self.RefreshView)
end

function UILWRemarkNameListView:OnGetItemByIndex(listview, index)
  if index < 0 or index >= #self.remarkNameList then
    return nil
  end
  index = index + 1
  local item = listview:NewListViewItem("UILWRemarkItem")
  if item == nil then
    Logger.LogError("\232\161\168\230\131\133\230\187\145\229\138\168\229\136\151\232\161\168\232\142\183\229\143\150Item\228\184\186\231\169\186 \239\188\154UILWRemarkItem")
    return
  end
  local script = self.ScrollContent:GetComponent(item.gameObject.name, UILWRemarkNameitem)
  if script == nil then
    local objectName = item.gameObject.name .. tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.ScrollContent:AddComponent(UILWRemarkNameitem, objectName)
  end
  script:SetActive(true)
  script:SetItemShow(self.remarkNameList[index]:GetPlayerUid(), self.remarkNameList[index]:GetRemarkName())
  return item
end

function UILWRemarkNameListView:InitData()
  self.remarkNameList = DataCenter.PlayerInfoDataManager:GetOtherPlayerRemarkList()
end

function UILWRemarkNameListView:RefreshView()
  self:InitData()
  local count = #self.remarkNameList
  self.ScrollLoopListView:SetListItemCount(count, false, false)
  self.ScrollLoopListView:RefreshAllShownItem()
  self.noUserText:SetActive(count == 0)
end

function UILWRemarkNameListView:OnBtnClose()
  self.view.ctrl:CloseSelf()
end

return UILWRemarkNameListView
