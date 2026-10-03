local UILWTruckSuperDeparturePanelView = BaseClass("UILWTruckSuperDeparturePanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWTruckSuperDepartureTabItemRender = require("UI.UILWRailway.UILWTruckSuperDeparture.Component.UILWTruckSuperDepartureTabItemRender")
local UILWTruckSuperDepartureItemRender = require("UI.UILWRailway.UILWTruckSuperDeparture.Component.UILWTruckSuperDepartureItemRender")
local UILWTruckSuperDepartureRewardBubbleContentComponent = require("UI.UILWRailway.UILWTruckSuperDeparture.Component.UILWTruckSuperDepartureRewardBubbleContentComponent")
local REFRESH_REINDEER_CART = 130006300
local TRUCK_DEPARTURE_ANI_INTERVAL = 0.1

function UILWTruckSuperDeparturePanelView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UILWTruckSuperDeparturePanelView:OnDestroy()
  self:SaveLocalData()
  self:ClearTabListScroll()
  self:ClearTruckListScroll()
  self:ClearDelay()
  self:ClearWaitRefreshTrain()
  self:ClearWaitDepartureTrain()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTruckSuperDeparturePanelView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.scrollViewTabList = self.viewSkin:AddComponent(self, UIScrollView, 2)
  self.compDepartureTipsContent = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.textDepartureTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textDepartureCount = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.compRefreshReindeerCartContent = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self.btnSelectRefreshReindeerCart = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnSelectRefreshReindeerCart:SetOnClick(function()
    self:OnBtnSelectRefreshReindeerCartClick()
  end)
  self.imgRefreshReindeerCartSelectState = self.viewSkin:AddComponent(self, UIImage, 8)
  self.textRefreshReindeerCartTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.compEmptyContent = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.textEmptyTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textSelectAllBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.btnSelectAll = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnSelectAll:SetOnClick(function()
    self:OnBtnSelectAllClick()
  end)
  self.scrollViewTruckList = self.viewSkin:AddComponent(self, UIScrollView, 15)
  self.btnRefreshOrDeparture = self.viewSkin:AddComponent(self, UIButton, 16)
  self.btnRefreshOrDeparture:SetOnClick(function()
    self:OnBtnRefreshOrDepartureClick()
  end)
  self.textRefreshBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 17)
  self.compRefreshTruckCostContent = self.viewSkin:AddComponent(self, UIBaseContainer, 18)
  self.textRefreshTruckCost = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.compUILWTruckSuperDepartureRewardBubbleContent = self.viewSkin:AddComponent(self, UILWTruckSuperDepartureRewardBubbleContentComponent, 20)
  self.textDepartureBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 21)
  self.compRefreshBtnTextContent = self.viewSkin:AddComponent(self, UIBaseContainer, 22)
  self.btnUICommonBlackMask = self.viewSkin:AddComponent(self, UIButton, 23)
  self.btnUICommonBlackMask:SetOnClick(function()
    self:OnBtnUICommonBlackMaskClick()
  end)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 24)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.compHighQualityBubbleContent = self.viewSkin:AddComponent(self, UIBaseContainer, 25)
  self.btnCloseHighQualityBubble = self.viewSkin:AddComponent(self, UIButton, 26)
  self.btnCloseHighQualityBubble:SetOnClick(function()
    self:OnBtnCloseHighQualityBubbleClick()
  end)
  self.compHighQualityBubble = self.viewSkin:AddComponent(self, UIBaseContainer, 27)
  self.textHighQualityBubbleTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 28)
  self.textTitle:SetLocalText("super_trucklaunch_name")
  self.textRefreshReindeerCartTips:SetLocalText("super_trucklaunch_limit_10")
  self.textDepartureTips:SetLocalText("super_trucklaunch_limit_08")
  self.textHighQualityBubbleTip:SetLocalText("super_trucklaunch_14")
  self.scrollViewTabList:SetOnItemMoveIn(function(itemObj, index)
    self:OnTabItemMoveIn(itemObj, index)
  end)
  self.scrollViewTabList:SetOnItemMoveOut(function(itemObj, index)
    self:OnTabItemMoveOut(itemObj, index)
  end)
  self.scrollViewTruckList:SetOnItemMoveIn(function(itemObj, index)
    self:OnTruckItemMoveIn(itemObj, index)
  end)
  self.scrollViewTruckList:SetOnItemMoveOut(function(itemObj, index)
    self:OnTruckItemMoveOut(itemObj, index)
  end)
  self.compUILWTruckSuperDepartureRewardBubbleContent:SetActive(false)
  self.compHighQualityBubbleContent:SetActive(false)
end

function UILWTruckSuperDeparturePanelView:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.scrollViewTabList = nil
  self.compDepartureTipsContent = nil
  self.textDepartureTips = nil
  self.textDepartureCount = nil
  self.compRefreshReindeerCartContent = nil
  self.btnSelectRefreshReindeerCart = nil
  self.imgRefreshReindeerCartSelectState = nil
  self.textRefreshReindeerCartTips = nil
  self.compEmptyContent = nil
  self.textEmptyTips = nil
  self.btnClose = nil
  self.textSelectAllBtn = nil
  self.btnSelectAll = nil
  self.scrollViewTruckList = nil
  self.btnRefreshOrDeparture = nil
  self.textRefreshBtn = nil
  self.compRefreshTruckCostContent = nil
  self.textRefreshTruckCost = nil
  self.compUILWTruckSuperDepartureRewardBubbleContent = nil
  self.textDepartureBtn = nil
  self.compRefreshBtnTextContent = nil
  self.btnUICommonBlackMask = nil
  self.btnInfo = nil
  self.compHighQualityBubbleContent = nil
  self.btnCloseHighQualityBubble = nil
  self.compHighQualityBubble = nil
  self.textHighQualityBubbleTip = nil
end

function UILWTruckSuperDeparturePanelView:DataDefine()
  self.curTabType = TruckSuperDepartureTabType.None
  self.tabViewDataList = {
    {
      tabType = TruckSuperDepartureTabType.Refresh,
      tabName = "super_trucklaunch_title01"
    },
    {
      tabType = TruckSuperDepartureTabType.Departure,
      tabName = "super_trucklaunch_title02"
    }
  }
  self.tabViewItemRenderDict = {}
  self.truckViewItemRenderDict = {}
  self.truckShowDataList = {}
  self.truckDataMap = nil
  self.truckIndex2Formation = {}
  self.canSelectRefreshTruckIndexMap = {}
  self.canSelectDepartureTruckIndexMap = {}
  self.recordSelectRefreshTruckIndexMap = {}
  self.recordSelectDepartureTruckIndexMap = {}
  self.isUnlockReindeerCart = false
  self.selectRefreshReindeerCart = false
  self.refreshSelectTruckNeedTicketCount = 0
  self.ownTicketCount = 0
  self.hasTruckCanDeparture = false
  self.showReindeerCartSelect = false
  self.isInitRecordSelectTruck = true
end

function UILWTruckSuperDeparturePanelView:DataDestroy()
  self.curTabType = nil
  self.tabViewDataList = nil
  self.tabViewItemRenderDict = nil
  self.truckViewItemRenderDict = nil
  self.truckShowDataList = nil
  self.truckDataMap = nil
  self.truckIndex2Formation = nil
  self:ClearAllOption()
  self.isUnlockReindeerCart = nil
  self.selectRefreshReindeerCart = nil
  self.refreshSelectTruckNeedTicketCount = nil
  self.ownTicketCount = nil
  self.hasTruckCanDeparture = nil
  self.showReindeerCartSelect = nil
  self.oneTicket2DiamondNum = nil
  self.isInitRecordSelectTruck = false
end

function UILWTruckSuperDeparturePanelView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshMyTruck, self.OnRefreshMyTruck)
  self:AddUIListener(EventId.RefreshTruckHeroByIndex, self.OnRefreshTruckHeroByIndex)
  self:AddUIListener(EventId.BatchChangeTrainSuccess, self.OnBatchChangeTrainSuccess)
  self:AddUIListener(EventId.BatchDepartureTrainSuccess, self.OnBatchDepartureTrainSuccess)
  self:AddUIListener(EventId.CollectTrainRewardSuccess, self.OnCollectTrainRewardSuccess)
  self:AddUIListener(EventId.BatchChangeTrainCallback, self.OnBatchChangeTrainCallback)
  self:AddUIListener(EventId.BatchDepartureTrainCallback, self.OnBatchDepartureTrainCallback)
end

function UILWTruckSuperDeparturePanelView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshMyTruck, self.OnRefreshMyTruck)
  self:RemoveUIListener(EventId.RefreshTruckHeroByIndex, self.OnRefreshTruckHeroByIndex)
  self:RemoveUIListener(EventId.BatchChangeTrainSuccess, self.OnBatchChangeTrainSuccess)
  self:RemoveUIListener(EventId.BatchDepartureTrainSuccess, self.OnBatchDepartureTrainSuccess)
  self:RemoveUIListener(EventId.CollectTrainRewardSuccess, self.OnCollectTrainRewardSuccess)
  self:RemoveUIListener(EventId.BatchChangeTrainCallback, self.OnBatchChangeTrainCallback)
  self:RemoveUIListener(EventId.BatchDepartureTrainCallback, self.OnBatchDepartureTrainCallback)
  base.OnRemoveListener(self)
end

function UILWTruckSuperDeparturePanelView:OnEnable()
  base.OnEnable(self)
  self.truckDataMap = DataCenter.LWMyStationDataManager:GetMyTrains()
  self:RefreshCanSelectRefreshTruckList()
  self:RefreshRecordSelectTruckIndexMap()
  self:TryFindFormationToTruck()
  self:RefreshUnlockReindeerCart()
  self:RefreshCurTabTypeShowView()
end

function UILWTruckSuperDeparturePanelView:ReInit()
  self.curTabType = TruckSuperDepartureTabType.Refresh
  self.selectRefreshReindeerCart = CommonUtil.PlayerPrefsGetBool(SettingKeys.TRUCK_SUPER_DEPARTURE_SELECT_REINDEER_CART, false)
  local configValue = DataCenter.LWMyStationDataManager:GetMeta(54)
  self.oneTicket2DiamondNum = configValue and tonumber(configValue) or 0
  self:RefreshUnlockReindeerCartShowState()
  self.ownTicketCount = DataCenter.ItemData:GetItemCount(DataCenter.LWMyStationDataManager:GET_CHANGE_TRAIN_ITEM_ID())
  local tabCount = table.count(self.tabViewDataList)
  if 0 < tabCount then
    self.scrollViewTabList:SetTotalCount(tabCount)
    self.scrollViewTabList:RefillCells()
  end
end

function UILWTruckSuperDeparturePanelView:SaveLocalData()
  CommonUtil.PlayerPrefsSetBool(SettingKeys.TRUCK_SUPER_DEPARTURE_SELECT_REINDEER_CART, self.selectRefreshReindeerCart)
  local saveStr = ""
  for i, v in pairs(self.recordSelectRefreshTruckIndexMap) do
    saveStr = saveStr .. i .. ","
  end
  if string.IsNullOrEmpty(saveStr) then
    saveStr = "-1"
  end
  CommonUtil.PlayerPrefsSetString(SettingKeys.TRUCK_SUPER_DEPARTURE_SELECT_REFRESH_TRUCK_DATA, saveStr)
end

function UILWTruckSuperDeparturePanelView:OnRefreshMyTruck()
  if self.curTabType == TruckSuperDepartureTabType.Departure then
    self:RefreshShowDepartureCount()
  end
end

function UILWTruckSuperDeparturePanelView:OnCollectTrainRewardSuccess()
  self.truckDataMap = DataCenter.LWMyStationDataManager:GetMyTrains()
  self:RefreshCanSelectRefreshTruckList()
  self:TryFindFormationToTruck()
  self:RefreshCurTabTypeShowView()
end

function UILWTruckSuperDeparturePanelView:OnBatchChangeTrainSuccess(refreshTruckList)
  self.truckDataMap = DataCenter.LWMyStationDataManager:GetMyTrains()
  self.ownTicketCount = DataCenter.ItemData:GetItemCount(DataCenter.LWMyStationDataManager:GET_CHANGE_TRAIN_ITEM_ID())
  self:RefreshCanSelectRefreshTruckList()
  self:RefreshRecordSelectTruckIndexMap()
  self:RefreshCurTabTypeShowView(refreshTruckList)
end

function UILWTruckSuperDeparturePanelView:OnBatchDepartureTrainSuccess(departureTruckList)
  self.truckDataMap = DataCenter.LWMyStationDataManager:GetMyTrains()
  local count = table.count(departureTruckList)
  local cur, max = DataCenter.LWMyStationDataManager:GetDepartureCount()
  if max <= cur then
    for i = 1, count do
      local truckIndex = departureTruckList[i]
      self.recordSelectRefreshTruckIndexMap[truckIndex] = nil
    end
    self.ctrl:CloseSelf()
    return
  end
  if 0 < count then
    table.sort(departureTruckList, function(a, b)
      return a < b
    end)
  end
  local singleDepartureTruckAniLength
  for i = 1, count do
    local truckIndex = departureTruckList[i]
    self.canSelectRefreshTruckIndexMap[truckIndex] = nil
    self.canSelectDepartureTruckIndexMap[truckIndex] = nil
    self.recordSelectDepartureTruckIndexMap[truckIndex] = nil
    self.recordSelectRefreshTruckIndexMap[truckIndex] = nil
    local delayTime = (i - 1) * TRUCK_DEPARTURE_ANI_INTERVAL
    local itemRender = self.truckViewItemRenderDict[truckIndex]
    if itemRender ~= nil then
      if singleDepartureTruckAniLength == nil then
        singleDepartureTruckAniLength = itemRender:GetDepartureAniTime()
      end
      itemRender:PlayDepartureAnimation(delayTime)
    end
  end
  local renderCount = table.count(self.truckViewItemRenderDict)
  if 0 < count and renderCount then
    if singleDepartureTruckAniLength == nil then
      singleDepartureTruckAniLength = 0
    end
    local delayTime = (count - 1) * TRUCK_DEPARTURE_ANI_INTERVAL + singleDepartureTruckAniLength + 0.1
    self:ClearDelay()
    self.delay = TimerManager:GetInstance():DelayInvoke(function()
      self.delay = nil
      self:RefreshCurTabTypeShowView()
    end, delayTime)
  else
    self:RefreshCurTabTypeShowView()
  end
end

function UILWTruckSuperDeparturePanelView:OnRefreshTruckHeroByIndex(formationIndex)
  local formation = DataCenter.LWMyStationDataManager:GetDefenceFormationByIndex(formationIndex)
  if formation and formation.index then
    local truckIndex = self:RefreshTruckFormation(formation)
    if 0 < truckIndex then
      local truckData = self.truckDataMap[truckIndex]
      if truckData then
        local truckState = truckData:GetTrainState()
        if truckState == TrainState.BeforeDeparture then
          local heroCount = table.count(formation.localHeroes)
          if 0 < heroCount then
            self.canSelectDepartureTruckIndexMap[truckIndex] = true
          else
            self.recordSelectDepartureTruckIndexMap[truckIndex] = nil
            self.canSelectDepartureTruckIndexMap[truckIndex] = nil
          end
          local param = {fromTruckIndex = truckIndex}
          self:RefreshSelectAllBtnGrayState()
          EventManager:GetInstance():Broadcast(EventId.TruckSuperDepartureChangeFormation, param)
        end
      end
    end
  end
end

function UILWTruckSuperDeparturePanelView:OnBatchChangeTrainCallback()
  self:ClearWaitRefreshTrain()
end

function UILWTruckSuperDeparturePanelView:OnBatchDepartureTrainCallback()
  self:ClearWaitDepartureTrain()
end

function UILWTruckSuperDeparturePanelView:OnTabItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.scrollViewTabList:AddComponent(UILWTruckSuperDepartureTabItemRender, itemObj)
  if itemRender ~= nil then
    local tableData = self.tabViewDataList[index]
    itemRender:InitData(tableData, self.curTabType)
    if self.tabViewItemRenderDict == nil then
      self.tabViewItemRenderDict = {}
    end
    self.tabViewItemRenderDict[tableData.tabType] = itemRender
  end
end

function UILWTruckSuperDeparturePanelView:OnTabItemMoveOut(itemObj, index)
  self.scrollViewTabList:RemoveComponent(itemObj.name, UILWTruckSuperDepartureTabItemRender)
end

function UILWTruckSuperDeparturePanelView:ClearTabListScroll()
  self.scrollViewTabList:ClearCells()
  self.scrollViewTabList:RemoveComponents(UILWTruckSuperDepartureTabItemRender)
  self.tabViewItemRenderDict = nil
end

function UILWTruckSuperDeparturePanelView:OnTabItemClick(newTabType)
  if self.curTabType == newTabType then
    return
  end
  if self.tabViewItemRenderDict[self.curTabType] ~= nil then
    self.tabViewItemRenderDict[self.curTabType]:SetSelectState(false)
  end
  self.curTabType = newTabType
  if self.tabViewItemRenderDict[newTabType] ~= nil then
    self.tabViewItemRenderDict[newTabType]:SetSelectState(true)
  end
  self:RefreshCurTabTypeShowView()
end

function UILWTruckSuperDeparturePanelView:RefreshCurTabTypeShowView(changeTruckList)
  self:ClearTruckListScroll()
  self.truckShowDataList = {}
  if self.curTabType == TruckSuperDepartureTabType.Refresh then
    self:ClearDelay()
    self:ShowReindeerCartTips()
    for i = 1, 4 do
      local truckData = self.truckDataMap[i]
      local param = UILWTruckSuperDepartureItemRender.Param.New()
      param.truckIndex = i
      param.unlock = truckData ~= nil
      param.truckData = truckData
      if truckData ~= nil and changeTruckList then
        local hasChange = table.hasvalue(changeTruckList, truckData.index)
        if hasChange then
          local highQualityTruck = truckData:GetIsContainHighGoods()
          param.showEffect = highQualityTruck or truckData.quality >= 5
        end
      end
      table.insert(self.truckShowDataList, param)
    end
  else
    self:ShowDepartureTips()
    for i = 1, 4 do
      local truckData = self.truckDataMap[i]
      if truckData == nil then
        local param = UILWTruckSuperDepartureItemRender.Param.New()
        param.truckIndex = i
        param.unlock = false
        param.truckData = nil
        table.insert(self.truckShowDataList, param)
      else
        local truckState = truckData:GetTrainState()
        if truckState == TrainState.BeforeDeparture then
          local param = UILWTruckSuperDepartureItemRender.Param.New()
          param.truckIndex = i
          param.unlock = true
          param.truckData = truckData
          table.insert(self.truckShowDataList, param)
        end
      end
    end
  end
  local count = table.count(self.truckShowDataList)
  self.compEmptyContent:SetActive(count == 0)
  if 0 < count then
    self.scrollViewTruckList:SetTotalCount(count)
    self.scrollViewTruckList:RefillCells()
  else
    self.textEmptyTips:SetLocalText("super_trucklaunch_04")
  end
  self:RefreshShowBottomBtnShow()
end

function UILWTruckSuperDeparturePanelView:OnTruckItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.scrollViewTruckList:AddComponent(UILWTruckSuperDepartureItemRender, itemObj)
  if itemRender ~= nil then
    local truckShowInfo = self.truckShowDataList[index]
    itemRender:InitData(index, truckShowInfo)
    if self.truckViewItemRenderDict == nil then
      self.truckViewItemRenderDict = {}
    end
    self.truckViewItemRenderDict[truckShowInfo.truckIndex] = itemRender
  end
end

function UILWTruckSuperDeparturePanelView:OnTruckItemMoveOut(itemObj, index)
  self.scrollViewTruckList:RemoveComponent(itemObj.name, UILWTruckSuperDepartureItemRender)
end

function UILWTruckSuperDeparturePanelView:ClearTruckListScroll()
  self.scrollViewTruckList:ClearCells()
  self.scrollViewTruckList:RemoveComponents(UILWTruckSuperDepartureItemRender)
  self.truckViewItemRenderDict = nil
end

function UILWTruckSuperDeparturePanelView:RefreshUnlockReindeerCartShowState()
  local trainDepartureScienceId = 13
  local tabState = DataCenter.ScienceTemplateManager:GetTabState(trainDepartureScienceId)
  self.showReindeerCartSelect = tabState == ScienceTabState.UnLock
end

function UILWTruckSuperDeparturePanelView:RefreshUnlockReindeerCart()
  local scienceLevel = DataCenter.ScienceManager:GetScienceLevel(REFRESH_REINDEER_CART)
  local scienceMaxLevel = DataCenter.ScienceManager:GetScienceMaxLevel(REFRESH_REINDEER_CART)
  self.isUnlockReindeerCart = scienceLevel == scienceMaxLevel
end

function UILWTruckSuperDeparturePanelView:ShowReindeerCartTips()
  self.compDepartureTipsContent:SetActive(false)
  if self.showReindeerCartSelect then
    self.compRefreshReindeerCartContent:SetActive(true)
    self.imgRefreshReindeerCartSelectState:SetActive(self.selectRefreshReindeerCart)
  else
    self.compRefreshReindeerCartContent:SetActive(false)
  end
end

function UILWTruckSuperDeparturePanelView:ShowDepartureTips()
  self.compRefreshReindeerCartContent:SetActive(false)
  self.compDepartureTipsContent:SetActive(true)
  self:RefreshShowDepartureCount()
end

function UILWTruckSuperDeparturePanelView:RefreshShowDepartureCount()
  local cur, max = DataCenter.LWMyStationDataManager:GetDepartureCount()
  self.textDepartureCount:SetText(cur .. "/" .. max)
end

function UILWTruckSuperDeparturePanelView:RefreshShowBottomBtnShow()
  self.compRefreshBtnTextContent:SetActive(self.curTabType == TruckSuperDepartureTabType.Refresh)
  self.textDepartureBtn:SetActive(self.curTabType == TruckSuperDepartureTabType.Departure)
  if self.curTabType == TruckSuperDepartureTabType.Refresh then
    self.textSelectAllBtn:SetLocalText("super_trucklaunch_btn04")
    self.textRefreshBtn:SetLocalText("super_trucklaunch_btn05")
    self.compRefreshTruckCostContent:SetActive(true)
    self:CalcRefreshTruckCost()
    self:RefreshShowRefreshTruckCost()
  else
    self.textSelectAllBtn:SetLocalText("super_trucklaunch_btn02")
    self.textDepartureBtn:SetLocalText("super_trucklaunch_btn03")
    self.compRefreshTruckCostContent:SetActive(false)
  end
  self:RefreshSelectAllBtnGrayState()
  self:RefreshOrDepartureBtnGrayState()
end

function UILWTruckSuperDeparturePanelView:GetTruckShowDataByIndex(itemRenderIndex)
  return self.truckShowDataList[itemRenderIndex] or nil
end

function UILWTruckSuperDeparturePanelView:JudgeIsSelectAllTruck()
  local canSelectCount = 0
  local alreadySelectCount = 0
  if self.curTabType == TruckSuperDepartureTabType.Refresh then
    canSelectCount = table.count(self.canSelectRefreshTruckIndexMap)
    alreadySelectCount = table.count(self.recordSelectRefreshTruckIndexMap)
  else
    canSelectCount = table.count(self.canSelectDepartureTruckIndexMap)
    alreadySelectCount = table.count(self.recordSelectDepartureTruckIndexMap)
  end
  return canSelectCount == alreadySelectCount
end

function UILWTruckSuperDeparturePanelView:RefreshSelectAllBtnGrayState()
  local isSelectAllTruck = self:JudgeIsSelectAllTruck()
  CS.UIGray.SetGray(self.btnSelectAll.transform, isSelectAllTruck, true)
end

function UILWTruckSuperDeparturePanelView:RefreshOrDepartureBtnGrayState()
  self.hasTruckCanDeparture = false
  for i, v in pairs(self.truckDataMap) do
    local truckState = v:GetTrainState()
    if truckState == TrainState.BeforeDeparture then
      self.hasTruckCanDeparture = true
      break
    end
  end
  CS.UIGray.SetGray(self.btnRefreshOrDeparture.transform, not self.hasTruckCanDeparture, true)
end

function UILWTruckSuperDeparturePanelView:CalcRefreshTruckCost()
  local configValue1 = DataCenter.LWMyStationDataManager:GetMeta(57)
  local configValue2 = DataCenter.LWMyStationDataManager:GetMeta(52)
  local configValue3 = DataCenter.LWMyStationDataManager:GetMeta(53)
  local noUrTruckNeedTicketNum = configValue1 and tonumber(configValue1) or 0
  local urTruckNeedTicketNum = configValue2 and tonumber(configValue2) or 0
  local reindeerCartNeedTickerNum = configValue3 and tonumber(configValue3) or 0
  self.refreshSelectTruckNeedTicketCount = 0
  if self.recordSelectRefreshTruckIndexMap then
    for truckIndex, selectState in pairs(self.recordSelectRefreshTruckIndexMap) do
      local truckData = self.truckDataMap[truckIndex]
      if truckData then
        if self.selectRefreshReindeerCart then
          self.refreshSelectTruckNeedTicketCount = self.refreshSelectTruckNeedTicketCount + reindeerCartNeedTickerNum
        elseif truckData.quality >= 5 then
          self.refreshSelectTruckNeedTicketCount = self.refreshSelectTruckNeedTicketCount + urTruckNeedTicketNum
        else
          self.refreshSelectTruckNeedTicketCount = self.refreshSelectTruckNeedTicketCount + noUrTruckNeedTicketNum
        end
      end
    end
  end
end

function UILWTruckSuperDeparturePanelView:RefreshShowRefreshTruckCost()
  local costStr = self.refreshSelectTruckNeedTicketCount .. "/" .. self.ownTicketCount
  if self.ownTicketCount >= self.refreshSelectTruckNeedTicketCount then
    costStr = "<color=#FFFFFF>" .. self.refreshSelectTruckNeedTicketCount .. "</color>" .. "/" .. "<color=#FFFFFF>" .. self.ownTicketCount .. "</color>"
  else
    costStr = "<color=#F97279>" .. self.refreshSelectTruckNeedTicketCount .. "</color>" .. "/" .. "<color=#FFFFFF>" .. self.ownTicketCount .. "</color>"
  end
  self.textRefreshTruckCost:SetText(costStr)
end

function UILWTruckSuperDeparturePanelView:ClearDelay()
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
end

function UILWTruckSuperDeparturePanelView:TryFindFormationToTruck()
  local formationList = DataCenter.LWMyStationDataManager:GetMaxBattlePowerFreeDefenceFormationList()
  local alreadyUseFormationIndex = {}
  for i, v in pairs(self.truckIndex2Formation) do
    alreadyUseFormationIndex[v.index] = true
  end
  for truckIndex, truckData in pairs(self.truckDataMap) do
    local truckState = truckData:GetTrainState()
    if truckState == TrainState.BeforeDeparture and self.truckIndex2Formation[truckData.index] == nil then
      for _, formation in pairs(formationList) do
        if not alreadyUseFormationIndex[formation.index] then
          alreadyUseFormationIndex[formation.index] = true
          self.truckIndex2Formation[truckData.index] = formation
          local heroCount = table.count(formation.localHeroes)
          if 0 < heroCount then
            self.canSelectDepartureTruckIndexMap[truckData.index] = true
          end
          break
        end
      end
    end
  end
end

function UILWTruckSuperDeparturePanelView:RefreshTruckFormation(newFormation)
  local targetTruckIndex = 0
  for truckIndex, formation in pairs(self.truckIndex2Formation) do
    if formation.index == newFormation.index then
      targetTruckIndex = truckIndex
      break
    end
  end
  self.truckIndex2Formation[targetTruckIndex] = newFormation
  return targetTruckIndex
end

function UILWTruckSuperDeparturePanelView:GetTruckFormation(truckIndex)
  return self.truckIndex2Formation[truckIndex] or nil
end

function UILWTruckSuperDeparturePanelView:ChangeTruckFormation(fromItemRenderIndex, toItemRenderIndex)
  local fromTruckShowData = self.truckShowDataList[fromItemRenderIndex]
  local toTruckShowData = self.truckShowDataList[toItemRenderIndex]
  if fromTruckShowData == nil or toTruckShowData == nil then
    return
  end
  local fromTruckIndex = fromTruckShowData.truckIndex
  local toTruckIndex = toTruckShowData.truckIndex
  local fromTruckFormation = self.truckIndex2Formation[fromTruckIndex]
  local toTruckFormation = self.truckIndex2Formation[toTruckIndex]
  self.truckIndex2Formation[fromTruckIndex] = toTruckFormation
  self.truckIndex2Formation[toTruckIndex] = fromTruckFormation
  local param = {fromTruckIndex = fromTruckIndex, toTruckIndex = toTruckIndex}
  local fromCanSelectTruckState = self.canSelectDepartureTruckIndexMap[fromTruckIndex] or nil
  local toCanSelectTruckState = self.canSelectDepartureTruckIndexMap[toTruckIndex] or nil
  self.canSelectDepartureTruckIndexMap[fromTruckIndex] = toCanSelectTruckState
  self.canSelectDepartureTruckIndexMap[toTruckIndex] = fromCanSelectTruckState
  self:RemoveOption(fromTruckIndex)
  self:RemoveOption(toTruckIndex)
  self:RefreshSelectAllBtnGrayState()
  EventManager:GetInstance():Broadcast(EventId.TruckSuperDepartureChangeFormation, param)
end

function UILWTruckSuperDeparturePanelView:JudgeIsEmptyFormation(truckIndex)
  local formation = self.truckIndex2Formation[truckIndex]
  if formation == nil then
    return true
  end
  local heroCount = table.count(formation.localHeroes)
  return heroCount == 0
end

function UILWTruckSuperDeparturePanelView:RefreshCanSelectRefreshTruckList()
  self.canSelectRefreshTruckIndexMap = {}
  for _, v in pairs(self.truckDataMap) do
    local truckState = v:GetTrainState()
    if truckState == TrainState.BeforeDeparture and not v.isSpecialURQuality then
      self.canSelectRefreshTruckIndexMap[v.index] = true
    end
  end
end

function UILWTruckSuperDeparturePanelView:GetCanSelectTruckByIndex(truckIndex)
  local targetTruckList
  if self.curTabType == TruckSuperDepartureTabType.Refresh then
    targetTruckList = self.canSelectRefreshTruckIndexMap
  else
    targetTruckList = self.canSelectDepartureTruckIndexMap
  end
  return targetTruckList[truckIndex] or false
end

function UILWTruckSuperDeparturePanelView:RefreshRecordSelectTruckIndexMap()
  if self.isInitRecordSelectTruck then
    self.isInitRecordSelectTruck = false
    local selectStr = CommonUtil.PlayerPrefsGetString(SettingKeys.TRUCK_SUPER_DEPARTURE_SELECT_REFRESH_TRUCK_DATA, "")
    if string.IsNullOrEmpty(selectStr) then
      for truckIndex, v in pairs(self.canSelectRefreshTruckIndexMap) do
        local truckData = self.truckDataMap[truckIndex]
        if truckData then
          local isHighQualityTruck = truckData:GetIsContainHighGoods()
          if not isHighQualityTruck and not truckData.isSpecialURQuality then
            self.recordSelectRefreshTruckIndexMap[truckIndex] = true
          end
        end
      end
    else
      local localRecordList = string.split(selectStr, ",")
      for i, v in pairs(localRecordList) do
        local truckIndex = tonumber(v)
        local truckData = self.truckDataMap[truckIndex]
        if truckData then
          local isHighQualityTruck = truckData:GetIsContainHighGoods()
          if not isHighQualityTruck and not truckData.isSpecialURQuality and self.canSelectRefreshTruckIndexMap[truckIndex] then
            self.recordSelectRefreshTruckIndexMap[truckIndex] = true
          end
        end
      end
    end
  else
    for truckIndex, truckData in pairs(self.truckDataMap) do
      local isHighQualityTruck = truckData:GetIsContainHighGoods()
      local canSelect = self.canSelectRefreshTruckIndexMap[truckIndex] or false
      if isHighQualityTruck or truckData.isSpecialURQuality or not canSelect then
        self.recordSelectRefreshTruckIndexMap[truckIndex] = nil
      end
    end
  end
end

function UILWTruckSuperDeparturePanelView:AddOption(truckIndex)
  if self.curTabType == TruckSuperDepartureTabType.Refresh then
    self.recordSelectRefreshTruckIndexMap[truckIndex] = true
  else
    self.recordSelectDepartureTruckIndexMap[truckIndex] = true
  end
end

function UILWTruckSuperDeparturePanelView:RemoveOption(truckIndex)
  if self.curTabType == TruckSuperDepartureTabType.Refresh then
    self.recordSelectRefreshTruckIndexMap[truckIndex] = nil
  else
    self.recordSelectDepartureTruckIndexMap[truckIndex] = nil
  end
end

function UILWTruckSuperDeparturePanelView:HasOption(truckIndex)
  local value = 0
  if self.curTabType == TruckSuperDepartureTabType.Refresh then
    value = self.recordSelectRefreshTruckIndexMap[truckIndex] or false
  else
    value = self.recordSelectDepartureTruckIndexMap[truckIndex] or false
  end
  return value
end

function UILWTruckSuperDeparturePanelView:ToggleOption(truckIndex)
  local select = self:HasOption(truckIndex)
  if select then
    self:RemoveOption(truckIndex)
  else
    self:AddOption(truckIndex)
  end
  self:RefreshSelectAllBtnGrayState()
  if self.curTabType == TruckSuperDepartureTabType.Refresh then
    self:CalcRefreshTruckCost()
    self:RefreshShowRefreshTruckCost()
  end
  return not select
end

function UILWTruckSuperDeparturePanelView:ClearAllOption()
  self.canSelectRefreshTruckIndexMap = nil
  self.canSelectDepartureTruckIndexMap = nil
  self.recordSelectRefreshTruckIndexMap = nil
  self.recordSelectDepartureTruckIndexMap = nil
end

function UILWTruckSuperDeparturePanelView:SetWaitRefreshTrain()
  if not self.waitRefreshTrain then
    self.waitRefreshTrain = true
    if self.delayWaitRefreshTrain then
      self.delayWaitRefreshTrain:Stop()
    end
    self.delayWaitRefreshTrain = TimerManager:GetInstance():DelayInvoke(function()
      self.waitRefreshTrain = false
      self.delayWaitRefreshTrain = nil
    end, 30)
  end
end

function UILWTruckSuperDeparturePanelView:ClearWaitRefreshTrain()
  self.waitRefreshTrain = false
  if self.delayWaitRefreshTrain then
    self.delayWaitRefreshTrain:Stop()
    self.delayWaitRefreshTrain = nil
  end
end

function UILWTruckSuperDeparturePanelView:SetWaitDepartureTrain()
  if not self.waitDepartureTrain then
    self.waitDepartureTrain = true
    if self.delayWaitDepartureTrain then
      self.delayWaitDepartureTrain:Stop()
    end
    self.delayWaitDepartureTrain = TimerManager:GetInstance():DelayInvoke(function()
      self.waitDepartureTrain = false
      self.delayWaitDepartureTrain = nil
    end, 30)
  end
end

function UILWTruckSuperDeparturePanelView:ClearWaitDepartureTrain()
  self.waitDepartureTrain = false
  if self.delayWaitDepartureTrain then
    self.delayWaitDepartureTrain:Stop()
    self.delayWaitDepartureTrain = nil
  end
end

function UILWTruckSuperDeparturePanelView:OnBtnSelectRefreshReindeerCartClick()
  if self.selectRefreshReindeerCart then
    self.selectRefreshReindeerCart = false
    self.imgRefreshReindeerCartSelectState:SetActive(self.selectRefreshReindeerCart)
    self:CalcRefreshTruckCost()
    self:RefreshShowRefreshTruckCost()
    return
  end
  if self.isUnlockReindeerCart then
    local configValue = DataCenter.LWMyStationDataManager:GetMeta(53)
    local reindeerCartNeedTickerNum = configValue and tonumber(configValue) or 0
    UIUtil.ShowMessage(Localization:GetString("super_trucklaunch_05", reindeerCartNeedTickerNum), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      self.selectRefreshReindeerCart = true
      self:CalcRefreshTruckCost()
      self:RefreshShowRefreshTruckCost()
      self.imgRefreshReindeerCartSelectState:SetActive(self.selectRefreshReindeerCart)
    end)
  else
    UIUtil.ShowMessage(Localization:GetString("super_trucklaunch_06"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      GoToUtil.GotoScience(REFRESH_REINDEER_CART, nil, nil, true)
    end)
  end
end

function UILWTruckSuperDeparturePanelView:OnBtnSelectAllClick()
  if not self.hasTruckCanDeparture then
    local tipsKey = ""
    if self.curTabType == TruckSuperDepartureTabType.Refresh then
      tipsKey = "super_trucklaunch_tips02"
    else
      tipsKey = "super_trucklaunch_tips03"
    end
    UIUtil.ShowTipsId(tipsKey)
    return
  end
  local isSelectAllTruck = self:JudgeIsSelectAllTruck()
  if isSelectAllTruck then
    return
  end
  local targetTruckList
  if self.curTabType == TruckSuperDepartureTabType.Refresh then
    targetTruckList = self.canSelectRefreshTruckIndexMap
  else
    targetTruckList = self.canSelectDepartureTruckIndexMap
  end
  for truckIndex, v in pairs(targetTruckList) do
    self:AddOption(truckIndex)
  end
  CS.UIGray.SetGray(self.btnSelectAll.transform, true, true)
  if self.curTabType == TruckSuperDepartureTabType.Refresh then
    self:CalcRefreshTruckCost()
    self:RefreshShowRefreshTruckCost()
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshTruckSelectShowState)
end

function UILWTruckSuperDeparturePanelView:OnBtnRefreshOrDepartureClick()
  if self.curTabType == TruckSuperDepartureTabType.Refresh and self.waitRefreshTrain then
    return
  end
  if self.curTabType == TruckSuperDepartureTabType.Departure and self.waitDepartureTrain then
    return
  end
  if not self.hasTruckCanDeparture then
    local tipsKey = ""
    if self.curTabType == TruckSuperDepartureTabType.Refresh then
      tipsKey = "super_trucklaunch_tips02"
    else
      tipsKey = "super_trucklaunch_tips03"
    end
    UIUtil.ShowTipsId(tipsKey)
    return
  end
  if self.curTabType == TruckSuperDepartureTabType.Refresh then
    local selectCount = table.count(self.recordSelectRefreshTruckIndexMap)
    if selectCount == 0 then
      UIUtil.ShowTipsId("super_trucklaunch_tips05")
      return
    end
    local allReindeerCart = true
    for truckIndex, v in pairs(self.recordSelectRefreshTruckIndexMap) do
      local truckInfo = self.truckDataMap[truckIndex]
      if truckInfo and not truckInfo.isSpecialURQuality then
        allReindeerCart = false
        break
      end
    end
    if allReindeerCart then
      UIUtil.ShowTipsId("super_trucklaunch_tips04")
      return
    end
    local isHighQualityRefresh, refreshTips = self:GetRefreshSecondConfirmTips()
    local secondConfirmPanelParam = {
      desContent = refreshTips,
      ownTicketCount = self.ownTicketCount,
      needTicketCount = self.refreshSelectTruckNeedTicketCount
    }
    if isHighQualityRefresh then
      secondConfirmPanelParam.showCheckBox = false
      
      function secondConfirmPanelParam.clickCallBack(isOn)
        self:TrySendRefreshMsg()
      end
      
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTruckSuperDepartureRefreshSecondConfirm, {anim = true}, secondConfirmPanelParam)
    else
      local confirmType = TodayNoSecondConfirmType.TruckSuperDepartureRefreshSecondConfirm
      if self.ownTicketCount < self.refreshSelectTruckNeedTicketCount then
        confirmType = TodayNoSecondConfirmType.TruckSuperDepartureRefreshLackingGoodsSecondConfirm
      end
      if DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(confirmType) then
        secondConfirmPanelParam.showCheckBox = true
        
        function secondConfirmPanelParam.clickCallBack(isOn)
          DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(confirmType, isOn)
          self:TrySendRefreshMsg()
        end
        
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTruckSuperDepartureRefreshSecondConfirm, {anim = true}, secondConfirmPanelParam)
      else
        self:TrySendRefreshMsg()
      end
    end
  else
    local selectCount = table.count(self.recordSelectDepartureTruckIndexMap)
    if selectCount == 0 then
      UIUtil.ShowTipsId("super_trucklaunch_tips06")
      return
    end
    local cur, max = DataCenter.LWMyStationDataManager:GetDepartureCount()
    local surplusTimes = max - cur
    if selectCount > surplusTimes then
      local tips = Localization:GetString("super_trucklaunch_13", selectCount, surplusTimes)
      UIUtil.ShowMessage(tips, 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL)
      return
    end
    local lowQualityCount = 0
    for truckIndex, selectStatus in pairs(self.recordSelectDepartureTruckIndexMap) do
      local truckInfo = self.truckDataMap[truckIndex]
      if truckInfo and truckInfo.quality < 4 then
        lowQualityCount = lowQualityCount + 1
      end
    end
    local tips = ""
    if 0 < lowQualityCount then
      tips = Localization:GetString("super_trucklaunch_10", selectCount, lowQualityCount)
    else
      tips = Localization:GetString("super_trucklaunch_11", selectCount)
    end
    UIUtil.ShowMessage(tips, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      self:TrySendDepartureMsg()
    end)
  end
end

function UILWTruckSuperDeparturePanelView:TrySendDepartureMsg()
  if self.recordSelectDepartureTruckIndexMap == nil then
    return
  end
  local truckUuid2FormationMap = {}
  for truckIndex, selectStatus in pairs(self.recordSelectDepartureTruckIndexMap) do
    local truckInfo = self.truckDataMap[truckIndex]
    if truckInfo then
      local formation = self:GetTruckFormation(truckIndex)
      if formation then
        truckUuid2FormationMap[truckInfo.uuid] = formation
      end
    end
  end
  local success = DataCenter.LWMyStationDataManager:TryDepartureTrainList(truckUuid2FormationMap)
  if success then
    self:SetWaitDepartureTrain()
  end
end

function UILWTruckSuperDeparturePanelView:TrySendRefreshMsg()
  if self.ownTicketCount and self.refreshSelectTruckNeedTicketCount and self.ownTicketCount < self.refreshSelectTruckNeedTicketCount then
    local lackCount = self.refreshSelectTruckNeedTicketCount - self.ownTicketCount
    local needDiamond = lackCount * self.oneTicket2DiamondNum
    if needDiamond > LuaEntry.Player.gold then
      UIUtil.ShowTipsId("super_trucklaunch_tips09")
      return
    end
  end
  if self.recordSelectRefreshTruckIndexMap == nil then
    return
  end
  local truckUuidList = {}
  for truckIndex, selectStatus in pairs(self.recordSelectRefreshTruckIndexMap) do
    local truckInfo = self.truckDataMap[truckIndex]
    if truckInfo then
      table.insert(truckUuidList, truckInfo.uuid)
    end
  end
  local refreshType = self.selectRefreshReindeerCart and 1 or 0
  SFSNetwork.SendMessage(MsgDefines.TrainBatchChange, truckUuidList, refreshType)
  self:SetWaitRefreshTrain()
end

function UILWTruckSuperDeparturePanelView:GetRefreshSecondConfirmTips()
  local recordHighQualityTruckList = {}
  for i, v in pairs(self.recordSelectRefreshTruckIndexMap) do
    local truckInfo = self.truckDataMap[i]
    if truckInfo and truckInfo:GetIsContainHighGoods() then
      local des = Localization:GetString("super_trucklaunch_02", i)
      table.insert(recordHighQualityTruckList, des)
    end
  end
  local tips = ""
  local count = table.count(recordHighQualityTruckList)
  if 0 < count then
    if count == 1 then
      tips = Localization:GetString("super_trucklaunch_07", table.unpack(recordHighQualityTruckList))
    elseif count == 2 then
      tips = Localization:GetString("super_trucklaunch_08", table.unpack(recordHighQualityTruckList))
    elseif count == 3 then
      tips = Localization:GetString("super_trucklaunch_09", table.unpack(recordHighQualityTruckList))
    else
      tips = Localization:GetString("super_trucklaunch_12")
    end
  else
    tips = Localization:GetString("super_trucklaunch_desc01")
  end
  return 0 < count, tips
end

function UILWTruckSuperDeparturePanelView:ShowTruckShowRewardBubble(position, truckInfo)
  if self.curTabType == TruckSuperDepartureTabType.Departure then
    if self.compHighQualityBubbleContent:GetActive() then
      self:OnBtnCloseHighQualityBubbleClick()
    end
    self.compUILWTruckSuperDepartureRewardBubbleContent:RefreshShow(position, truckInfo)
  end
end

function UILWTruckSuperDeparturePanelView:ShowHighQualityTruckBubble(position)
  if self.compUILWTruckSuperDepartureRewardBubbleContent:GetActive() then
    self.compUILWTruckSuperDepartureRewardBubbleContent:OnBtnCloseTuckRewardBubbleClick()
  end
  self.compHighQualityBubbleContent:SetActive(true)
  local posX = position.x
  local posY = position.y
  self.compHighQualityBubble:SetPositionXYZ(posX, posY, 0)
end

function UILWTruckSuperDeparturePanelView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UILWTruckSuperDeparturePanelView:OnBtnUICommonBlackMaskClick()
  self.ctrl:CloseSelf()
end

function UILWTruckSuperDeparturePanelView:OnBtnInfoClick()
  local param = {}
  param.activityRulesStr = Localization:GetString("super_trucklaunch_rules")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function UILWTruckSuperDeparturePanelView:OnBtnCloseHighQualityBubbleClick()
  self.compHighQualityBubbleContent:SetActive(false)
end

return UILWTruckSuperDeparturePanelView
