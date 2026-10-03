local UITorchRelayTaskView = BaseClass("UITorchRelayTaskView", UIBaseView)
local TorchRelayMilestonesTaskPanel = require("UI/LWTorchRelay/Activity/Task/Component/TorchRelayMilestonesTaskPanel")
local TorchRelayDailyTaskPanel = require("UI/LWTorchRelay/Activity/Task/Component/TorchRelayDailyTaskPanel")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UICommonTab = require("UI.UICommonTab.UICommonTab")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ReInit(self)
  self.activityId, self.defaultTabTagId = self:GetUserData()
  self.ctrl:SetActivityId(self.activityId)
  self.milestonesPanel:SetActive(true)
  self.milestonesPanel:ReInit()
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.dailyTaskPanel = self:AddComponent(TorchRelayDailyTaskPanel, "PopUpTitle/dailyTaskPanel")
  self.dailyTab = self:AddComponent(UICommonTab, "PopUpTitle/dailyTab")
  self.milestonesTab = self:AddComponent(UICommonTab, "PopUpTitle/milestonesTab")
  self.mainTitle = self:AddComponent(UIText, "PopUpTitle/Common_img_title/titleText")
  self.mainTitle:SetText(Localization:GetString("activity_torch_relay_button_3"))
  self.btnClose = self:AddComponent(UIButton, "PopUpTitle/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.milestonesPanel = self:AddComponent(TorchRelayMilestonesTaskPanel, "PopUpTitle/runningMilestonesPanel")
end

local function ComponentDestroy(self)
  self.dailyTaskPanel = nil
  self.dailyTab = nil
  self.milestonesTab = nil
  self.mainTitle = nil
  self.btnClose = nil
  self.milestonesPanel = nil
  self.btnPanel = nil
end

local function DataDefine(self)
  self.tabMap = {}
  self.tabMap[DataCenter.ActivityTorchRelayManager.TaskViewTag.Daily] = self.dailyTab
  self.tabMap[DataCenter.ActivityTorchRelayManager.TaskViewTag.Total] = self.milestonesTab
end

local function DataDestroy(self)
  self.curTab = nil
  self.tabMap = nil
  self.defaultTabTagId = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActivityTorchRelayTaskRewardGet, self.RefreshRedDot)
  self:AddUIListener(EventId.ActivityTorchRelayTaskUpdate, self.RefreshRedDot)
  self:AddUIListener(EventId.ActivityTorchRelayMilesRewardGet, self.RefreshRedDot)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActivityTorchRelayTaskRewardGet, self.RefreshRedDot)
  self:RemoveUIListener(EventId.ActivityTorchRelayTaskUpdate, self.RefreshRedDot)
  self:RemoveUIListener(EventId.ActivityTorchRelayMilesRewardGet, self.RefreshRedDot)
  base.OnRemoveListener(self)
end

local function RefreshRedDot(self)
  for k, v in pairs(self.tabMap) do
    local num = DataCenter.ActivityTorchRelayTaskManager:GetRedDotNum(self.activityId, k)
    v:SetRedDotVisible(0 < num)
  end
end

local function OnTabClick(self, tabItem)
  if self.curTab ~= nil then
    if self.curTab.tabId == tabItem.tabId then
      return
    else
      self.curTab:SetSelect(false)
    end
  end
  self.curTab = tabItem
  self.curTab:SetSelect(true)
  self.curTab.containPanel:ReInit()
end

local function OnBtnCloseClick(self)
  self.ctrl:CloseSelf()
end

UITorchRelayTaskView.OnCreate = OnCreate
UITorchRelayTaskView.OnDestroy = OnDestroy
UITorchRelayTaskView.OnEnable = OnEnable
UITorchRelayTaskView.OnDisable = OnDisable
UITorchRelayTaskView.ComponentDefine = ComponentDefine
UITorchRelayTaskView.ComponentDestroy = ComponentDestroy
UITorchRelayTaskView.DataDefine = DataDefine
UITorchRelayTaskView.DataDestroy = DataDestroy
UITorchRelayTaskView.OnAddListener = OnAddListener
UITorchRelayTaskView.OnRemoveListener = OnRemoveListener
UITorchRelayTaskView.OnBtnCloseClick = OnBtnCloseClick
UITorchRelayTaskView.OnTabClick = OnTabClick
UITorchRelayTaskView.ReInit = ReInit
UITorchRelayTaskView.RefreshRedDot = RefreshRedDot
return UITorchRelayTaskView
