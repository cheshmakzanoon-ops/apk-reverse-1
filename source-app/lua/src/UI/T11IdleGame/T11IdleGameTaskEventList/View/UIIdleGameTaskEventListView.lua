local UIIdleGameTaskEventListView = BaseClass("UIIdleGameTaskEventListView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")
local UIIdleGameTaskEventItem = require("UI.T11IdleGame.T11IdleGameTaskEventList.Component.UIIdleGameTaskEventItem")

function UIIdleGameTaskEventListView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
  DataCenter.T11IdleGameDataManager:SendIdleGameEventAllMessage()
end

function UIIdleGameTaskEventListView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIIdleGameTaskEventListView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.loopListView2ScrollView = self.viewSkin:AddComponent(self, UILoopListView2, 2)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.scrollContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textEmpty = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnPanel:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
end

function UIIdleGameTaskEventListView:ComponentDestroy()
  self.viewSkin = nil
  self.textDes = nil
  self.loopListView2ScrollView = nil
  self.textTitle = nil
  self.scrollContent = nil
  self.btnClose = nil
  self.textEmpty = nil
  self.btnPanel = nil
end

function UIIdleGameTaskEventListView:DataDefine()
  self.textTitle:SetLocalText("t11_idle_game_title_37")
  self.itemIndex = 0
  self.loopListView2ScrollView:InitListView(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end)
end

function UIIdleGameTaskEventListView:DataDestroy()
  self.scrollContent:RemoveComponents(UIIdleGameTaskEventItem)
  self.loopListView2ScrollView:ClearAllItems()
end

function UIIdleGameTaskEventListView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.T11IdleGameTaskEventListRefresh, self.RefreshView)
  self:AddUIListener(EventId.PlotGroupDone, self.OnPlotGroupDone)
end

function UIIdleGameTaskEventListView:OnRemoveListener()
  self:RemoveUIListener(EventId.T11IdleGameTaskEventListRefresh, self.RefreshView)
  self:RemoveUIListener(EventId.PlotGroupDone, self.OnPlotGroupDone)
  base.OnRemoveListener(self)
end

function UIIdleGameTaskEventListView:RefreshView()
  self.gameEventList = DataCenter.T11IdleGameDataManager:GetGameEventList()
  self.textEmpty:SetActive(#self.gameEventList == 0)
  self.textDes:SetActive(#self.gameEventList ~= 0)
  local eventNum = #self.gameEventList
  self.textDes:SetText(Localization:GetString("t11_idle_game_desc_38", eventNum))
  self.textEmpty:SetLocalText("t11_idle_game_desc_71")
  self.loopListView2ScrollView:SetListItemCount(#self.gameEventList, false, false)
  self.loopListView2ScrollView:RefreshAllShownItem()
end

function UIIdleGameTaskEventListView:OnGetItemByIndex(listview, index)
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
    local objectName = item.gameObject.name .. tostring(NameCount)
    NameCount = NameCount + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.scrollContent:AddComponent(UIIdleGameTaskEventItem, objectName)
  end
  script:SetActive(true)
  script:RefreshView(self.gameEventList[index])
  script:SetBtnInteractable(true)
  script:SetIsShowRedPoint(true)
  return item
end

function UIIdleGameTaskEventListView:OnBtnCloseClick()
  self.view.ctrl:CloseSelf()
end

function UIIdleGameTaskEventListView:OnPlotGroupDone(plotGroupId)
  local curGameEventData, curEventCfgData = self.view.ctrl:GetCurSelectItemData()
  if curGameEventData == nil or curEventCfgData == nil then
    return
  end
  if plotGroupId == (curEventCfgData.start_plot or 0) then
    self:OpenUIIdleGameTaskEventDetailView(curGameEventData)
    self.view.ctrl:SetCurSelectItemData(nil, nil)
  end
end

function UIIdleGameTaskEventListView:OpenUIIdleGameTaskEventDetailView(curGameEventData)
  local questCfgData = DataCenter.QuestTemplateManager:GetQuestTemplate(curGameEventData.questId)
  if curGameEventData.status == Const.TaskState.NoComplete and questCfgData.type2 == Const.T11GameEventCompleteType.IDLE_GAME_PLOT then
    DataCenter.T11IdleGameDataManager:SendIdleGameEventPlotMessage(curGameEventData.uuid)
  end
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIIdleGameTaskEventDetail) then
    local param = {}
    param.gameEventData = curGameEventData
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIIdleGameTaskEventDetail, {anim = true}, param)
  end
end

return UIIdleGameTaskEventListView
