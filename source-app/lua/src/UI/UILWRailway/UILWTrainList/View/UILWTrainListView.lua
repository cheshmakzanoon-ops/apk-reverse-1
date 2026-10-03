local UILWTrainListView = BaseClass("UILWTrainListView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local TrainHolder = require("UI.UILWRailway.UILWTrainList.Component.TrainHolder")
local MyTrainHolder = require("UI.UILWRailway.UILWTrainList.Component.MyTrainHolder")
local TRAIN_TAB_NUM = 2
local Tab2Name = {
  [TrainTab.Mine] = "457516",
  [TrainTab.Enemy] = "457515",
  [TrainTab.Ally] = "457516"
}

function UILWTrainListView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  for k, v in pairs(self.taskListTabs) do
    v:SetActive(false)
  end
  local gotoPage, openParam = self:GetUserData()
  self.ctrl.openParam = openParam
  if gotoPage then
    self:OnTabClick(gotoPage)
  else
    self:OnTabClick(TrainTab.Enemy)
  end
  self:RefreshRedPoint()
end

function UILWTrainListView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTrainListView:ComponentDefine()
  self.closeBtn = self:AddComponent(UIButton, "Root/BottomBar/BtnBack")
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.refreshBtn = self:AddComponent(UIButton, "Root/BottomBar/BtnRefresh")
  self.refreshBtn:SetOnClick(function()
    DataCenter.LWTrainDataManager:TryGetTrainList(true)
  end)
  self.titleText = self:AddComponent(UIText, "Root/TopBar/TextTitle")
  self.titleText:SetLocalText("457509")
  self.tabSelectGo = {}
  self.tabTitleTxt = {}
  self.tabClickBtn = {}
  self.tabRedPointBg = {}
  self.tabRedPointNumText = {}
  for i = 1, TRAIN_TAB_NUM do
    local tab_path = "Root/BottomBar/Tab/TabItem" .. i
    self.tabSelectGo[i] = self:AddComponent(UIBaseContainer, tab_path .. "/Condition" .. i .. "Select")
    self.tabTitleTxt[i] = self:AddComponent(UIText, tab_path .. "/Condition" .. i .. "Txt")
    self.tabClickBtn[i] = self:AddComponent(UIButton, tab_path)
    self.tabClickBtn[i]:SetOnClick(function()
      self:OnTabClick(i)
    end)
    self.tabRedPointBg[i] = self:AddComponent(UIImage, string.format("%s/RedPointBg%d", tab_path, i))
    self.tabRedPointNumText[i] = self:AddComponent(UIText, string.format("%s/RedPointBg%d/RedPointText%d", tab_path, i, i))
  end
  for i = 1, TRAIN_TAB_NUM do
    self.tabTitleTxt[i]:SetLocalText(Tab2Name[i])
  end
  self.enemyTrainHolder = self:AddComponent(TrainHolder, "Root/Middle/EnemyTrainHolder")
  self.myTrainHolder = self:AddComponent(MyTrainHolder, "Root/Middle/MyTrainHolder")
  self.taskListTabs = {
    [TrainTab.Enemy] = self.enemyTrainHolder,
    [TrainTab.Mine] = self.myTrainHolder
  }
end

function UILWTrainListView:ComponentDestroy()
  self.closeBtn = nil
  self.titleText = nil
  for i = 1, TRAIN_TAB_NUM do
    self.tabSelectGo[i] = nil
    self.tabTitleTxt[i] = nil
    self.tabClickBtn[i] = nil
  end
  self.tabSelectGo = nil
  self.tabTitleTxt = nil
  self.tabClickBtn = nil
  self.tabRedPointBg = nil
  self.tabRedPointNumText = nil
  self.allyTrainHolder = nil
  self.enemyTrainHolder = nil
  self.taskListTabs = nil
end

function UILWTrainListView:DataDefine()
  self.ctrl:InitData()
end

function UILWTrainListView:DataDestroy()
  self.ctrl:ClearData()
end

function UILWTrainListView:OnEnable()
  base.OnEnable(self)
end

function UILWTrainListView:OnDisable()
  base.OnDisable(self)
end

function UILWTrainListView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshMyTruck, self.RefreshRedPoint)
end

function UILWTrainListView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshMyTruck, self.RefreshRedPoint)
end

function UILWTrainListView:OnTabClick(tab)
  self.ctrl:SetCurrentTab(tab)
  for i = 1, TRAIN_TAB_NUM do
    self.tabSelectGo[i]:SetActive(i == tab)
  end
  self:OpenQuestList()
end

function UILWTrainListView:OpenQuestList()
  local selectedTabIndex = self.ctrl:GetCurrentTab()
  for i = 1, TRAIN_TAB_NUM do
    self.taskListTabs[i]:SetActive(i == selectedTabIndex)
  end
  if selectedTabIndex and self.taskListTabs[selectedTabIndex] then
    self.taskListTabs[selectedTabIndex]:RefreshContent()
  end
end

function UILWTrainListView:GetTrainsByTab()
  if self.ctrl:GetCurrentTab() == TrainTab.Enemy then
    return DataCenter.LWTrainDataManager:GetEnemyTruckList()
  elseif self.ctrl:GetCurrentTab() == TrainTab.Ally then
    return DataCenter.LWTrainDataManager:GetAllyTrainList()
  elseif self.ctrl:GetCurrentTab() == TrainTab.Mine then
    return DataCenter.LWMyStationDataManager:GetMyTrainList()
  end
end

function UILWTrainListView:RefreshRedPoint()
  for i = 1, TRAIN_TAB_NUM do
    local count = 0
    if i == TrainTab.Enemy then
      local cur, max = DataCenter.LWMyStationDataManager:GetRobCount()
      count = max - cur
    elseif i == TrainTab.Mine then
      count = DataCenter.LWMyStationDataManager:GetRealReadyCountPlusRewardCount()
    end
    self.tabRedPointBg[i]:SetActive(0 < count)
    self.tabRedPointNumText[i]:SetText(count)
  end
end

return UILWTrainListView
