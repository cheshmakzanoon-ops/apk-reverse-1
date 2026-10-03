local base = UIBaseView
local UIActSnowStormRewardView = BaseClass("UIActSnowStormRewardView", base)
local UIActSnowStormRewardTask = require("UI.LWSeason.LWSeasonSnowStormReward.Component.UIActSnowStormRewardTask")
local panelBtn_path = "UICommonPopUpTitle/panel"
local title_path = "safeArea/titleText"
local closeBtn_path = "safeArea/CloseBtn"
local taskPage_path = "safeArea/TaskPage"
local tabList_path = {
  "safeArea/tabSv/Viewport/Content/Toggle1",
  "safeArea/tabSv/Viewport/Content/Toggle2"
}
local tabName_path = {
  "safeArea/tabSv/Viewport/Content/Toggle1/CheckText1",
  "safeArea/tabSv/Viewport/Content/Toggle2/CheckText2"
}
local tabRed_path = {
  "safeArea/tabSv/Viewport/Content/Toggle1/RedPoint1",
  "safeArea/tabSv/Viewport/Content/Toggle2/RedPoint2"
}
local PanelTypeData = {
  [UIActSnowStormRewardPanelType.SnowStormReward] = {
    tabs = {
      [UIActSnowStormRewardTabType.Tab1] = {nameKey = "2010310"},
      [UIActSnowStormRewardTabType.Tab2] = {nameKey = "2010311"}
    },
    titleKey = "2010321"
  },
  [UIActSnowStormRewardPanelType.NuclearBuilding] = {
    tabs = {
      [UIActSnowStormRewardTabType.Tab1] = {nameKey = "456004"},
      [UIActSnowStormRewardTabType.Tab2] = {
        nameKey = "season_s2_activity_1000047_description_39"
      }
    },
    titleKey = "2010321"
  }
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.panelBtn = self:AddComponent(UIButton, panelBtn_path)
  self.title = self:AddComponent(UIText, title_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.taskPage = self:AddComponent(UIActSnowStormRewardTask, taskPage_path)
  self.tabList = {
    self:AddComponent(UIToggle, tabList_path[1]),
    self:AddComponent(UIToggle, tabList_path[2])
  }
  self.tabName = {
    self:AddComponent(UIText, tabName_path[1]),
    self:AddComponent(UIText, tabName_path[2])
  }
  self.tabRed = {
    self:AddComponent(UIBaseContainer, tabRed_path[1]),
    self:AddComponent(UIBaseContainer, tabRed_path[2])
  }
  self.panelType = self:GetUserData()
  local panelData = PanelTypeData[self.panelType]
  self.refreshData = self.panelType ~= UIActSnowStormRewardPanelType.NuclearBuilding
  for index, value in ipairs(self.tabList) do
    value:SetOnValueChanged(function(t)
      if t then
        self:ShowPage(index)
      end
    end)
    self.tabName[index]:SetLocalText(panelData.tabs[index].nameKey)
  end
  self.title:SetLocalText(panelData.titleKey)
  self.tabList[UIActSnowStormRewardTabType.Tab1]:SetIsOnWithoutNotify(true)
  self:ShowPage(1)
  self.panelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.ctrl:OnOpenPanel(self.panelType, self.curTabType)
end

local function ComponentDestroy(self)
  self.panelBtn = nil
  self.title = nil
  self.closeBtn = nil
  self.taskPage = nil
  self.tabList = nil
  self.tabName = nil
  self.tabRed = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.curTabType = nil
  self.refreshData = nil
end

function UIActSnowStormRewardView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonSnowStormActivityTargetRewardGetSuccess, self.OnGetRewardCallback)
  self:AddUIListener(EventId.ActNuclearTaskDataInit, self.OnGetRewardCallback)
  self:AddUIListener(EventId.ActNuclearTaskReweardGetSuccess, self.OnGetRewardCallback)
  self:AddUIListener(EventId.ActNuclearTaskStateUpdate, self.OnGetRewardCallback)
end

function UIActSnowStormRewardView:OnRemoveListener()
  self:RemoveUIListener(EventId.ActNuclearTaskDataInit, self.OnGetRewardCallback)
  self:RemoveUIListener(EventId.ActNuclearTaskReweardGetSuccess, self.OnGetRewardCallback)
  self:RemoveUIListener(EventId.ActNuclearTaskStateUpdate, self.OnGetRewardCallback)
  self:RemoveUIListener(EventId.SeasonSnowStormActivityTargetRewardGetSuccess, self.OnGetRewardCallback)
  base.OnRemoveListener(self)
end

function UIActSnowStormRewardView:ShowPage(tabType)
  if self.curTabType ~= tabType then
    self.curTabType = tabType
    if self.refreshData then
      local list = self.ctrl:GetRewardData(self.panelType, self.curTabType)
      self.taskPage:RefreshView(list, self.panelType, self.curTabType)
    end
  end
  self:RefreshTabRed()
end

function UIActSnowStormRewardView:OnGetRewardCallback()
  self.refreshData = true
  local list = self.ctrl:GetRewardData(self.panelType, self.curTabType)
  self.taskPage:RefreshView(list, self.panelType, self.curTabType)
  self:RefreshTabRed()
end

function UIActSnowStormRewardView:RefreshTabRed()
  self.tabRed[1]:SetActive(self.ctrl:GetTabRed(self.panelType, 1))
  self.tabRed[2]:SetActive(self.ctrl:GetTabRed(self.panelType, 2))
end

UIActSnowStormRewardView.OnCreate = OnCreate
UIActSnowStormRewardView.OnDestroy = OnDestroy
UIActSnowStormRewardView.OnEnable = OnEnable
UIActSnowStormRewardView.OnDisable = OnDisable
UIActSnowStormRewardView.ComponentDefine = ComponentDefine
UIActSnowStormRewardView.ComponentDestroy = ComponentDestroy
UIActSnowStormRewardView.DataDefine = DataDefine
UIActSnowStormRewardView.DataDestroy = DataDestroy
return UIActSnowStormRewardView
