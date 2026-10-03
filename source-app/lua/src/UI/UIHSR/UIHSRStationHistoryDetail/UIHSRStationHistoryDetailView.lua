local UIHSRStationHistoryDetailView = BaseClass("UIHSRStationHistoryDetailView", UIBaseView)
local CylinderItemComponent = require("UI.UIHSR.UIHSRStationHistoryDetail.CylinderItemComponent")
local SaleItemComponent = require("UI.UIHSR.UIHSRStationHistoryDetail.SaleItemComponent")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIHSRStationHistoryDetailView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIHSRStationHistoryDetailView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIHSRStationHistoryDetailView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textDay = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.toggleDay = self.viewSkin:AddComponent(self, UIToggle, 4)
  self.textWeek = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textTodayPriceNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTodayPrice = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textServer = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.toggleWeek = self.viewSkin:AddComponent(self, UIToggle, 10)
  self.textMonth = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.textTodayCountNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.textTodayCount = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.toggleMonth = self.viewSkin:AddComponent(self, UIToggle, 15)
  self.compChart = self.viewSkin:AddComponent(self, UIBaseContainer, 16)
  self.textSaleTitle3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 17)
  self.textSaleTitle1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.textSaleTitle2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.compSaleTableHead = self.viewSkin:AddComponent(self, UIBaseComponent, 20)
  self.imgListToggleGroup = self.viewSkin:AddComponent(self, UIImage, 21)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 22)
  self.textEmpty = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 23)
  self.btnLeftArrow = self.viewSkin:AddComponent(self, UIButton, 24)
  self.btnLeftArrow:SetOnClick(function()
    self:OnBtnArrowClick(true)
  end)
  self.btnRightArrow = self.viewSkin:AddComponent(self, UIButton, 25)
  self.btnRightArrow:SetOnClick(function()
    self:OnBtnArrowClick(false)
  end)
  self.textEmpty2 = self:AddComponent(UITextMeshProUGUIEx, "PopUpContent/root/ScrollView/Viewport/Content/Static/Empty2")
  self.player_title = self:AddComponent(UITextMeshProUGUIEx, "PopUpContent/root/ScrollView/Viewport/Content/Static/PlayerTitle")
  self.player_title:SetLocalText("activity_1200044_title_fivetime")
  self.textTodayPrice:SetLocalText("activity_1200044_tips76")
  self.textTodayCount:SetLocalText("activity_1200044_tips77")
  self.textTitle:SetLocalText("activity_1200044_tips78")
  self.textDay:SetLocalText("activity_1200044_tips32")
  self.textWeek:SetLocalText("activity_1200044_tips33")
  self.textMonth:SetLocalText("activity_1200044_tips34")
  self.textEmpty:SetLocalText("372266")
  self.textEmpty2:SetLocalText("372266")
  self.textDesc:SetLocalText("activity_1200044_tips12", "")
  self.textSaleTitle1:SetLocalText("100184")
  self.textSaleTitle2:SetLocalText("activity_1200044_tips79")
  self.textSaleTitle3:SetLocalText("activity_1200044_tips80")
  self.static = self:AddComponent(UIBaseComponent, "PopUpContent/root/ScrollView/Viewport/Content/Static")
  self.toggleDay:SetIsOn(true)
  self.toggleDay:SetOnValueChanged(function(bool)
    if bool then
      self:OnTabClick(HSRChartType.Today)
    end
  end)
  self.toggleWeek:SetOnValueChanged(function(bool)
    if bool then
      self:OnTabClick(HSRChartType.Week)
    end
  end)
  self.toggleMonth:SetOnValueChanged(function(bool)
    if bool then
      self:OnTabClick(HSRChartType.Month)
    end
  end)
  self.toggles = {}
  self.toggleSelect = {}
  self.toggleText = {}
  self.toggleText2 = {}
  for i = 1, 5 do
    self.toggles[i] = self:AddComponent(UIButton, string.format("PopUpContent/root/ScrollView/Viewport/Content/Static/ListToggleGroup/Toggle%s", i))
    self.toggleSelect[i] = self:AddComponent(UIBaseComponent, string.format("PopUpContent/root/ScrollView/Viewport/Content/Static/ListToggleGroup/Toggle%s/select%s", i, i))
    self.toggleText[i] = self:AddComponent(UITextMeshProUGUIEx, string.format("PopUpContent/root/ScrollView/Viewport/Content/Static/ListToggleGroup/Toggle%s/unselectText%s", i, i))
    self.toggleText2[i] = self:AddComponent(UITextMeshProUGUIEx, string.format("PopUpContent/root/ScrollView/Viewport/Content/Static/ListToggleGroup/Toggle%s/select%s/selectText%s", i, i, i))
    self.toggles[i]:SetOnClick(function()
      self:OnBtnClick(i)
    end)
  end
  self.cylinderItems = {}
  self.saleItems = {}
end

function UIHSRStationHistoryDetailView:ComponentDestroy()
  self:RemoveCylinderItems()
  self:RemoveSaleItems()
  self.viewSkin = nil
  self.btnPanel = nil
  self.textDesc = nil
  self.textDay = nil
  self.toggleDay = nil
  self.textWeek = nil
  self.textTodayPriceNum = nil
  self.btnClose = nil
  self.textTodayPrice = nil
  self.textServer = nil
  self.toggleWeek = nil
  self.textMonth = nil
  self.textTodayCountNum = nil
  self.textTitle = nil
  self.textTodayCount = nil
  self.toggleMonth = nil
  self.compChart = nil
  self.textSaleTitle3 = nil
  self.textSaleTitle1 = nil
  self.textSaleTitle2 = nil
  self.compSaleTableHead = nil
  self.imgListToggleGroup = nil
  self.compContent = nil
  self.textEmpty = nil
  self.btnLeftArrow = nil
  self.btnRightArrow = nil
end

function UIHSRStationHistoryDetailView:DataDestroy()
  self.stationId = nil
  self.chartType = nil
  self.chartData = nil
  self.fiveData = nil
  self.selectTime = nil
end

function UIHSRStationHistoryDetailView:DataDefine()
  self.chartType = HSRChartType.Today
  self.index = self:GetUserData()
  local stationHistorySimple = DataCenter.HSRDataManager:GetAllStationHistory()
  if not stationHistorySimple[self.index] then
    self.index = 1
  end
  self.stationId = stationHistorySimple[self.index].stationId
  self.serverId = stationHistorySimple[self.index].server
  DataCenter.HSRDataManager:FetchOneStationHistory(self.stationId)
  self:RefreshData()
end

function UIHSRStationHistoryDetailView:OnBtnArrowClick(left)
  local stationHistorySimple = DataCenter.HSRDataManager:GetAllStationHistory()
  local dir = left and -1 or 1
  local targetStation = stationHistorySimple[self.index + dir]
  if targetStation then
    self.index = self.index + dir
    self.stationId = targetStation.stationId
    self.serverId = targetStation.server
    DataCenter.HSRDataManager:FetchOneStationHistory(self.stationId)
    self:RefreshData()
    self:RefreshView()
  end
end

function UIHSRStationHistoryDetailView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.HSRStationHistoryDetailRefresh, self.HandleServerData)
end

function UIHSRStationHistoryDetailView:OnRemoveListener()
  self:RemoveUIListener(EventId.HSRStationHistoryDetailRefresh, self.HandleServerData)
  base.OnRemoveListener(self)
end

function UIHSRStationHistoryDetailView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIHSRStationHistoryDetailView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIHSRStationHistoryDetailView:OnTabClick(chartType)
  if chartType == self.chartType then
    return
  end
  self.chartType = chartType
  self.chartData = DataCenter.HSRDataManager:GetOneStationChartData(self.stationId, self.chartType)
  self:RefreshChart()
end

function UIHSRStationHistoryDetailView:OnBtnClick(selectTime)
  if selectTime == self.selectTime then
    return
  end
  self.selectTime = selectTime
  self:RefreshSale()
end

function UIHSRStationHistoryDetailView:HandleServerData(stationId)
  if stationId ~= self.stationId then
    return
  end
  self:RefreshData()
  self:RefreshView()
end

function UIHSRStationHistoryDetailView:RefreshData()
  self.chartData = DataCenter.HSRDataManager:GetOneStationChartData(self.stationId, self.chartType)
  self.fiveData = DataCenter.HSRDataManager:GetOneStationHistoryFive(self.stationId)
  self.selectTime = #self.fiveData
end

function UIHSRStationHistoryDetailView:RefreshView()
  self:RefreshArrow()
  self:RefreshChart()
  self:RefreshSale()
end

function UIHSRStationHistoryDetailView:RefreshArrow()
  self.textServer:SetText(UIUtil.FormatServerName(self.serverId))
  local stationHistorySimple = DataCenter.HSRDataManager:GetAllStationHistory()
  self.btnLeftArrow:SetActive(stationHistorySimple[self.index - 1])
  self.btnRightArrow:SetActive(stationHistorySimple[self.index + 1])
end

function UIHSRStationHistoryDetailView:RefreshChart()
  self:RemoveCylinderItems()
  local max = 0
  local min = math.huge
  for _, v in pairs(self.chartData) do
    if max < v.price then
      max = v.price
    end
    if min > v.price then
      min = v.price
    end
  end
  local range = max - min
  if self.chartType == HSRChartType.Today then
    self.textTodayPriceNum:SetText(string.GetFormattedSeparatorNum(max))
  else
    self.textTodayPriceNum:SetText(string.GetFormattedSeparatorNum(DataCenter.HSRDataManager:GetOneStationTodayMaxPrice(self.stationId)))
  end
  self.textTodayCountNum:SetText(string.GetFormattedSeparatorNum(DataCenter.HSRDataManager:GetOneStationTodaySaleNum(self.stationId)))
  if 0 >= #self.chartData then
    self.textEmpty:SetActive(true)
    self.compChart:SetActive(false)
    self.static:SetSizeDeltaY(700)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compContent.transform)
    return
  end
  self.textEmpty:SetActive(false)
  self.compChart:SetActive(true)
  self.compChart:SetSizeDeltaY(110 + #self.chartData * 30)
  self.static:SetSizeDeltaY(600 + #self.chartData * 30)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compContent.transform)
  for _, v in ipairs(self.chartData) do
    local item = self.compChart:LoadComponentAsync(CylinderItemComponent, "Assets/Main/SeasonRes/S5/Prefabs/UI/HSR/CylinderItem.prefab")
    local length
    if min == 0 then
      length = range == 0 and 10 or 400 * (v.price - min) / range + 10
    else
      length = range == 0 and 200 or 300 * (v.price - min) / range + 110
    end
    local time
    if self.chartType == HSRChartType.Today then
      time = UITimeManager:GetInstance():TimeStampToTimeForServerMinute(v.time, true)
    elseif self.chartType == HSRChartType.Week then
      time = UITimeManager:GetInstance():TimeStampToTimeForServerMD(v.time)
    elseif self.chartType == HSRChartType.Month then
      local _, seasonWeek = SeasonUtil.GetSeasonWeek(v.time)
      time = Localization:GetString(459009, seasonWeek)
    end
    item:SetData(time, length, v.price)
    table.insert(self.cylinderItems, item)
  end
end

function UIHSRStationHistoryDetailView:RemoveCylinderItems()
  for _, v in pairs(self.cylinderItems) do
    self.compChart:RemoveAsyncComponent(v)
  end
  self.cylinderItems = {}
end

function UIHSRStationHistoryDetailView:RefreshSale()
  self:RemoveSaleItems()
  if #self.fiveData <= 0 or DataCenter.HSRDataManager:IsDumpLock() then
    self.compSaleTableHead:SetActive(false)
    self.imgListToggleGroup:SetActive(false)
    self.player_title:SetActive(false)
    self.textEmpty2:SetActive(false)
    return
  end
  self.compSaleTableHead:SetActive(true)
  self.imgListToggleGroup:SetActive(true)
  self.player_title:SetActive(true)
  for i = 1, 5 do
    self.toggles[i]:SetActive(false)
  end
  for i = 1, #self.fiveData do
    self.toggles[i]:SetActive(true)
    self.toggleSelect[i]:SetActive(false)
    local time = UITimeManager:GetInstance():TimeStampToTimeForServerMinute(self.fiveData[i].time, true)
    self.toggleText[i]:SetText(time)
    self.toggleText2[i]:SetText(time)
    if CS.CommonUtils.IsDebug() then
      local time2 = UITimeManager:GetInstance():TimeStampToTimeForServerMDHM(self.fiveData[i].time, true)
      Logger.Log(string.format("time:%s", time2))
    end
  end
  self.toggleSelect[self.selectTime]:SetActive(true)
  local dataList = self.fiveData[self.selectTime].trades
  for _, v in ipairs(dataList) do
    local item = self.compContent:LoadComponentAsync(SaleItemComponent, "Assets/Main/SeasonRes/S5/Prefabs/UI/HSR/SaleItem.prefab")
    item:SetData(v)
    table.insert(self.saleItems, item)
  end
  self.textEmpty2:SetActive(#dataList <= 0)
end

function UIHSRStationHistoryDetailView:RemoveSaleItems()
  for _, v in pairs(self.saleItems) do
    self.compContent:RemoveAsyncComponent(v)
  end
  self.saleItems = {}
end

return UIHSRStationHistoryDetailView
