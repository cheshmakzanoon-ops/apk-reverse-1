local UIIdleGameTaskEventNewTipsView = BaseClass("UIIdleGameTaskEventNewTipsView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")
local UIIdleGameTaskEventItem = require("UI.T11IdleGame.T11IdleGameTaskEventList.Component.UIIdleGameTaskEventItem")

function UIIdleGameTaskEventNewTipsView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIIdleGameTaskEventNewTipsView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIIdleGameTaskEventNewTipsView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textClose = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.loopListView2ScrollView = self.viewSkin:AddComponent(self, UILoopListView2, 4)
  self.scrollContent = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
end

function UIIdleGameTaskEventNewTipsView:ComponentDestroy()
  self.viewSkin = nil
  self.btnPanel = nil
  self.textTitle = nil
  self.textClose = nil
  self.loopListView2ScrollView = nil
  self.scrollContent = nil
end

function UIIdleGameTaskEventNewTipsView:DataDefine()
  self.gameEventList = self:GetUserData()
  self.itemIndex = 0
  self.loopListView2ScrollView:InitListView(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end)
end

function UIIdleGameTaskEventNewTipsView:DataDestroy()
  self.scrollContent:RemoveComponents(UIIdleGameTaskEventItem)
  self.loopListView2ScrollView:ClearAllItems()
end

function UIIdleGameTaskEventNewTipsView:OnAddListener()
  base.OnAddListener(self)
end

function UIIdleGameTaskEventNewTipsView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIIdleGameTaskEventNewTipsView:RefreshView()
  self.textTitle:SetLocalText("t11_idle_game_desc_78")
  self.textClose:SetLocalText("radar_tips_10")
  DataCenter.T11IdleGameManager:PrintEditorCustomLog("UIIdleGameTaskEventNewTipsView:RefreshView " .. #self.gameEventList)
  self.loopListView2ScrollView:SetListItemCount(#self.gameEventList, false, false)
  self.loopListView2ScrollView:RefreshAllShownItem()
end

function UIIdleGameTaskEventNewTipsView:OnGetItemByIndex(listview, index)
  if index < 0 or index >= #self.gameEventList then
    return nil
  end
  index = index + 1
  local item = listview:NewListViewItem("UIIdleGameTaskEventItem")
  if item == nil then
    Logger.LogError("\230\187\145\229\138\168\229\136\151\232\161\168\232\142\183\229\143\150Item\228\184\186\231\169\186 \239\188\154UIIdleGameTaskEventItem")
    return
  end
  local script = self.scrollContent:GetComponent(item.gameObject.name, UIIdleGameTaskEventItem)
  if script == nil then
    local objectName = item.gameObject.name .. tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.scrollContent:AddComponent(UIIdleGameTaskEventItem, objectName)
  end
  script:SetActive(true)
  script:RefreshView(self.gameEventList[index])
  script:SetBtnInteractable(false)
  script:SetIsShowRedPoint(false)
  return item
end

function UIIdleGameTaskEventNewTipsView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

return UIIdleGameTaskEventNewTipsView
