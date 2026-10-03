local base = UIBaseView
local UIAllianceTaskViewView = BaseClass("UIAllianceTaskViewView", base)
local AllianceTaskItem = require("UI.UIAlliance.UIAllianceTask.Component.UIAllianceTaskItem")
local closeBtn_path = "safeArea/BottomBar/BtnBack"
local title_path = "safeArea/TopBar/TextTitle"
local svTask_path = "safeArea/MiddleContentContainer/ScrollView"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshAll()
  self:UpdateData()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  if self.isSeason then
    DataCenter.AllianceSeasonTaskManager:ResetOldTaskNum()
  else
    DataCenter.AllianceTaskManager:ResetOldTaskNum()
  end
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.titleN = self:AddComponent(UIText, title_path)
  self.titleN:SetLocalText(390973)
  self.svTaskN = self:AddComponent(UIScrollView, svTask_path)
  self.svTaskN:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.svTaskN:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  local targetIndex, isSeason = self:GetUserData()
  self.isSeason = isSeason == true
  self.targetIndex = targetIndex
end

local function ComponentDestroy(self)
  self.closeBtnN = nil
  self.titleN = nil
  self.svTaskN = nil
end

local function DataDefine(self)
  self.taskList = {}
end

local function DataDestroy(self)
  self.taskList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function UpdateData(self)
  SFSNetwork.SendMessage(MsgDefines.GetAllianceTaskInfo, self.isSeason)
end

local function RefreshAll(self)
  local tempList, targetIndex
  if self.isSeason then
    tempList, targetIndex = DataCenter.AllianceSeasonTaskManager:GetTaskList()
  else
    tempList, targetIndex = DataCenter.AllianceTaskManager:GetTaskList()
  end
  targetIndex = self.targetIndex and self.targetIndex or targetIndex
  self.taskList = tempList
  if #self.taskList > 0 then
    self.svTaskN:SetActive(true)
    self.svTaskN:SetTotalCount(#self.taskList)
    self.svTaskN:RefillCells(targetIndex)
  else
    self.svTaskN:SetActive(false)
  end
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.svTaskN:AddComponent(AllianceTaskItem, itemObj)
  local taskConf = self.taskList[index]
  cellItem:SetItem(taskConf, self.isSeason)
end

local function OnDeleteCell(self, itemObj, index)
  self.svTaskN:RemoveComponent(itemObj.name, AllianceTaskItem)
end

local function ClearScroll(self)
  self.svTaskN:ClearCells()
  self.svTaskN:RemoveComponents(AllianceTaskItem)
end

UIAllianceTaskViewView.OnCreate = OnCreate
UIAllianceTaskViewView.OnDestroy = OnDestroy
UIAllianceTaskViewView.OnAddListener = OnAddListener
UIAllianceTaskViewView.OnRemoveListener = OnRemoveListener
UIAllianceTaskViewView.ComponentDefine = ComponentDefine
UIAllianceTaskViewView.ComponentDestroy = ComponentDestroy
UIAllianceTaskViewView.DataDefine = DataDefine
UIAllianceTaskViewView.DataDestroy = DataDestroy
UIAllianceTaskViewView.OnCreateCell = OnCreateCell
UIAllianceTaskViewView.OnDeleteCell = OnDeleteCell
UIAllianceTaskViewView.ClearScroll = ClearScroll
UIAllianceTaskViewView.RefreshAll = RefreshAll
UIAllianceTaskViewView.UpdateData = UpdateData
return UIAllianceTaskViewView
