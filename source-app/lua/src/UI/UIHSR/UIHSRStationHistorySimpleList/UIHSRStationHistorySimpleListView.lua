local UIHSRStationHistorySimpleListView = BaseClass("UIHSRStationHistorySimpleListView", UIBaseView)
local StationItemComponent = require("UI.UIHSR.UIHSRStationHistorySimpleList.StationItemComponent")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local OptionData = CS.TMPro.TMP_Dropdown.OptionData
local LangKey = {
  [HSRStationSortType.Station] = "activity_1200044_tips22_name",
  [HSRStationSortType.Price] = "activity_1200044_tips74",
  [HSRStationSortType.Count] = "activity_1200044_tips85"
}

function UIHSRStationHistorySimpleListView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitDropdown()
  self:RefreshView()
end

function UIHSRStationHistorySimpleListView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIHSRStationHistorySimpleListView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textSort = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textHead2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgSlider = self.viewSkin:AddComponent(self, UIImage, 4)
  self.btnSort = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnSort:SetOnClick(function()
    self:OnBtnSortClick()
  end)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textHead3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textHead1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, "root/timeDrop/timeText")
  self.time_text:SetLocalText("server_train_title_history")
  self.empty = self:AddComponent(UITextMeshProUGUIEx, "root/ScrollView/Empty")
  self.empty:SetLocalText("server_train_error_code")
  self.btnSort:SetSafeClickMode(true)
  self.textTitle:SetLocalText("activity_1200044_tips8")
  self.textDesc:SetLocalText("activity_1200044_tips27")
  self.textHead1:SetLocalText(LangKey[HSRStationSortType.Station])
  self.textHead2:SetLocalText(LangKey[HSRStationSortType.Price])
  self.textHead3:SetLocalText(LangKey[HSRStationSortType.Count])
  self.items = {}
  self.timeDrop = self:AddComponent(UIDropdown, "root/timeDrop")
  self.timeDrop:SetOnValueChanged(function()
    self:OnTimeChange()
  end)
  self.timeDrop:Clear()
end

function UIHSRStationHistorySimpleListView:InitDropdown()
  self.selectIndex = 1
  self.selectTime = self.timeList[1]
  if not self.timeList or #self.timeList == 0 then
    Logger.LogError("UIHSRStationHistorySimpleListView:InitDropdown() self.timeList is nil")
    return
  end
  for i, v in ipairs(self.timeList) do
    local temp = OptionData()
    temp.text = UITimeManager:GetInstance():TimeStampToTimeForServerMDHM(v)
    self.timeDrop:Add(temp)
  end
  self.timeDrop:SetValue(0)
  self.timeDrop:SetText(UITimeManager:GetInstance():TimeStampToTimeForServerMDHM(self.timeList[1]))
end

function UIHSRStationHistorySimpleListView:ComponentDestroy()
  self:ClearAllItems()
  self.viewSkin = nil
  self.textSort = nil
  self.textDesc = nil
  self.textHead2 = nil
  self.imgSlider = nil
  self.btnSort = nil
  self.btnPanel = nil
  self.btnClose = nil
  self.textHead3 = nil
  self.compContent = nil
  self.textTitle = nil
  self.textHead1 = nil
end

function UIHSRStationHistorySimpleListView:DataDefine()
  DataCenter.HSRDataManager:InitSortType()
  DataCenter.HSRDataManager:FetchAllStationCurHistory()
  self.timeList = DataCenter.HSRDataManager:GetLastCreateTimes(6)
end

function UIHSRStationHistorySimpleListView:DataDestroy()
end

function UIHSRStationHistorySimpleListView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.HSRStationHistorySimpleListRefresh, self.RefreshView)
end

function UIHSRStationHistorySimpleListView:OnRemoveListener()
  self:RemoveUIListener(EventId.HSRStationHistorySimpleListRefresh, self.RefreshView)
  base.OnRemoveListener(self)
end

function UIHSRStationHistorySimpleListView:OnBtnSortClick()
  DataCenter.HSRDataManager:ChangeSortType(self.selectTime)
  self:RefreshView()
end

function UIHSRStationHistorySimpleListView:OnTimeChange()
  self.selectIndex = self.timeDrop:GetValue() + 1
  self.selectTime = self.timeList[self.selectIndex]
  DataCenter.HSRDataManager:ChangeTime(self.selectTime)
  self:RefreshView()
end

function UIHSRStationHistorySimpleListView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIHSRStationHistorySimpleListView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIHSRStationHistorySimpleListView:RefreshView()
  self:ClearAllItems()
  local isLatest = self.selectIndex == 1
  local time, progress
  if isLatest then
    time, progress = DataCenter.HSRDataManager:GetDrivingProgress()
    local totalStationCount = DataCenter.HSRDataManager:GetStationCount()
    self.imgSlider:SetFillAmount(progress / totalStationCount)
  else
    self.imgSlider:SetFillAmount(1)
  end
  self.textSort:SetLocalText(LangKey[DataCenter.HSRDataManager:GetSortType()])
  local allStations = DataCenter.HSRDataManager:GetAllStationHistory(self.selectTime)
  if not allStations or #allStations == 0 then
    self.empty:SetActive(true)
    return
  end
  self.empty:SetActive(false)
  for index, v in ipairs(allStations) do
    local item = self.compContent:LoadComponentAsync(StationItemComponent, "Assets/Main/SeasonRes/S5/Prefabs/UI/HSR/StationItem.prefab")
    item:SetData(index, v, isLatest, progress)
    table.insert(self.items, item)
  end
end

function UIHSRStationHistorySimpleListView:ClearAllItems()
  for _, v in pairs(self.items) do
    self.compContent:RemoveAsyncComponent(v)
  end
  self.items = {}
end

function UIHSRStationHistorySimpleListView:Update1000MS()
  if self.selectIndex == 1 then
    local _, progress = DataCenter.HSRDataManager:GetDrivingProgress()
    local totalStationCount = DataCenter.HSRDataManager:GetStationCount()
    self.imgSlider:SetFillAmount(progress / totalStationCount)
  end
end

return UIHSRStationHistorySimpleListView
