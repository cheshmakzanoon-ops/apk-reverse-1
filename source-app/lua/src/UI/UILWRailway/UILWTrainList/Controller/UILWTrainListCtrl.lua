local UILWTrainListCtrl = BaseClass("UILWTrainListCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTrainList)
end

local function InitData(self)
  self.currentTab = 0
  DataCenter.LWTrainDataManager:TryGetTrainList(false)
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

UILWTrainListCtrl.CloseSelf = CloseSelf
UILWTrainListCtrl.InitData = InitData
UILWTrainListCtrl.ClearData = ClearData
UILWTrainListCtrl.SetCurrentTab = SetCurrentTab
UILWTrainListCtrl.GetCurrentTab = GetCurrentTab
return UILWTrainListCtrl
