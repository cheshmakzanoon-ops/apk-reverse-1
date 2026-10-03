local UIActCrazyRockTaskView = BaseClass("UIActCrazyRockTaskView", UIBaseView)
local UIActCrazyRockTaskItem = require("UI.UIActCrazyRock.TaskView.Component.UIActCrazyRockTaskItem")
local CommonActivityPopUpBgPart = require("UI.LWActivityCommonSecondPopUp.UIActivityDetailCommon.Component.CommonActivityPopUpBgPart")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local M = UIActCrazyRockTaskView

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.activityId = self:GetUserData()
  self:RefreshView()
end

function M:OnDestroy()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.compContent = self:AddComponent(UIBaseContainer, "Root/ScrollRect/Viewport/Content")
  self.scrollRect = self:AddComponent(UILoopListView2, "Root/ScrollRect")
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btnGetAllReward = self:AddComponent(UIButton, "Root/GetAllRewardBtn")
  self.btnGetAllReward:SetOnClick(function()
    self:OnBtnGetAllRewardClick()
  end)
  self.textGetAllRewardBtn = self:AddComponent(UITextMeshProUGUIEx, "Root/GetAllRewardBtn/LW_Btn_Common_New_Base/GetAllRewardBtnText")
  self.getAllRewardRedDot = self:AddComponent(UIBaseContainer, "Root/GetAllRewardBtn/GetAllRewardRedDot")
  self.scrollRect:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.textGetAllRewardBtn:SetLocalText("activity_5401_tips4")
  self.commonActivityPopUpBgPart = self:AddComponent(CommonActivityPopUpBgPart, "CommonActivityPopUpBgPart")
  self.commonActivityPopUpBgPart:SetTitle("activity_concert_34")
  self.commonActivityPopUpBgPart:SetCloseCallback(BindCallback(self.ctrl, self.ctrl.CloseSelf))
end

function M:ComponentDestroy()
  self.compContent = nil
  self.scrollRect = nil
  self.btnPanel = nil
  self.btnGetAllReward = nil
  self.textGetAllRewardBtn = nil
  self.getAllRewardRedDot = nil
end

function M:DataDefine()
  self.taskList = {}
  self.itemIndex = 0
  self.activityId = 0
  self.showConfig = {}
end

function M:DataDestroy()
  self.taskList = nil
  self.itemIndex = nil
  self.activityId = nil
  self.showConfig = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CrazyRockTaskRewardGet, self.OnGetTaskReward)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.CrazyRockTaskRewardGet, self.OnGetTaskReward)
end

function M:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.taskList then
    return nil
  end
  local taskData = self.taskList[index]
  local item = loopScroll:NewListViewItem("ItemContent")
  local script = self.compContent:GetComponent(item.gameObject.name, UIActCrazyRockTaskItem)
  if script == nil then
    NameCount = NameCount + 1
    local nameStr = tostring(NameCount)
    item.gameObject.name = nameStr
    script = self.compContent:AddComponent(UIActCrazyRockTaskItem, nameStr)
  end
  script:SetActive(true)
  script:SetData(taskData, self.activityId, self.showConfig)
  return item
end

function M:RefreshView()
  local taskList = DataCenter.ActCrazyRockTaskManager:GetAllTaskList()
  if not taskList or #taskList == 0 then
    Logger.LogError("taskList is nil or empty")
    return
  end
  self:ModifyPanelPacking()
  self.taskList = taskList
  local canGet = 0 < DataCenter.ActCrazyRockTaskManager:GetRedDotNum(self.activityId)
  self.getAllRewardRedDot:SetActive(canGet)
  self:RefreshScroll()
end

function M:RefreshScroll()
  if self.scrollRect == nil or #self.taskList == 0 then
    self.scrollRect:SetActive(false)
  else
    self.scrollRect:SetActive(true)
    self.scrollRect:SetListItemCount(#self.taskList, false, false)
    self.scrollRect:RefreshAllShownItem()
  end
end

function M:ClearScroll()
  self.compContent:RemoveComponents(UIActCrazyRockTaskItem)
  self.scrollRect:ClearAllItems()
end

function M:OnGetTaskReward()
  self:RefreshView()
end

function M:OnBtnGetAllRewardClick()
  if not self.activityId or self.activityId == 0 then
    Logger.LogError("activityId is wrong")
    return
  end
  local canGet = 0 < DataCenter.ActCrazyRockTaskManager:GetRedDotNum(self.activityId)
  if not canGet then
    UIUtil.ShowTipsId(320446)
    return
  end
  DataCenter.ActCrazyRockTaskManager:RequestReceiveTaskReward(self.activityId, 0)
end

function M:ModifyPanelPacking()
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if activityInfo == nil then
    return
  end
  if activityInfo:GetFestivalInterfaceCfgId() then
    local festivalInterfaceCfgId = activityInfo:GetFestivalInterfaceCfgId()
    local lineData = LocalController:instance():getLine(TableName.Festival_Interface_Config, festivalInterfaceCfgId)
    if lineData == nil then
      Logger.LogError("Festival_Interface_Config GetTemplate lineData is nil id:" .. festivalInterfaceCfgId)
      return
    end
    self.showConfig = lineData
    self.commonActivityPopUpBgPart:ModifyPanelPacking(lineData)
  end
end

return UIActCrazyRockTaskView
