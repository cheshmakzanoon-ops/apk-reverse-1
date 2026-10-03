local UILWQuestListCtrl = BaseClass("UILWQuestListCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWQuestList)
end

local function InitData(self)
  self.currentTab = 0
end

local function ClearData(self)
  self.currentTab = nil
end

local function SetCurrentTab(self, tab)
  self.currentTab = tab
end

local function GetCurrentTab(self)
  return self.currentTab
end

local function GetTasksByTab(self)
  if self.currentTab == UIQuestTab.Chapter then
    return DataCenter.ChapterTaskManager:GetAllChapterTask() or {}
  elseif self.currentTab == UIQuestTab.Main then
    return DataCenter.TaskManager:GetAllMainTaskForView(false)
  elseif self.currentTab == UIQuestTab.Season then
    return DataCenter.TaskManager:GetAllMainTaskForView(true)
  end
  return {}
end

UILWQuestListCtrl.CloseSelf = CloseSelf
UILWQuestListCtrl.InitData = InitData
UILWQuestListCtrl.ClearData = ClearData
UILWQuestListCtrl.SetCurrentTab = SetCurrentTab
UILWQuestListCtrl.GetCurrentTab = GetCurrentTab
UILWQuestListCtrl.GetTasksByTab = GetTasksByTab
return UILWQuestListCtrl
