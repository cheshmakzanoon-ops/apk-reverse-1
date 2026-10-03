local LWBuyDiamondView = BaseClass("LWBuyDiamondView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ShopPageToggle = require("UI.LWGift.BuyDiamond.Component.ShopPageToggle")
local LWBuyDiamondResDownloadComponent = require("UI/LWGift/BuyDiamond/Component/LWBuyDiamondResDownloadComponent")
local BuyDiamondTemplate = require("DataCenter.BuyDiamond.BuyDiamondTemplate")

function LWBuyDiamondView:DataDefine()
  self.packPrefabList = {}
  self.packCompList = {}
  self.loadedTabsCount = 0
  self.downloadResRequest = nil
  self.downloadResComp = nil
  self.showTipsCfgData = {}
end

function LWBuyDiamondView:DataDestroy()
  self.packPrefabList = nil
  self.packCompList = nil
  self.loadedTabsCount = nil
  self.downloadResRequest = nil
  self.downloadResComp = nil
  self.showTipsCfgData = nil
end

function LWBuyDiamondView:CenterOn(id)
  if not id then
    return
  end
  if not table.IsNullOrEmpty(self.tabs) then
    local index = -1
    for i, v in pairs(self.tabs) do
      if v:getID() == id then
        index = i
        break
      end
    end
    if index ~= -1 then
      local posX = (index - 1) / (table.count(self.tabs) - 1)
      self.tabScroll:SetHorizontalNormalizedPosition(posX)
      self:RefreshPointer()
    end
  end
end

function LWBuyDiamondView:CenterOnType(type)
  if not type then
    return
  end
  if not table.IsNullOrEmpty(self.tabs) then
    local index = -1
    for i, v in pairs(self.tabs) do
      if v:getType() == type then
        index = i
        break
      end
    end
    if index ~= -1 then
      local posX = (index - 1) / (table.count(self.tabs) - 1)
      self.tabScroll:SetHorizontalNormalizedPosition(posX)
      self:RefreshPointer()
    end
  end
end

local TabWidth = 235

function LWBuyDiamondView:RefreshPointer()
  if not table.IsNullOrEmpty(self.tabItems) then
    local leftRedNum = 0
    local rightRedNum = 0
    local scrollPos = -self.tabContainer:GetAnchoredPositionX()
    local scrollSize = self.tabScroll.rectTransform.rect.width
    local scrollLeftPos = scrollPos
    local scrollRightPos = scrollPos + scrollSize
    for index, v in pairs(self.tabItems) do
      local leftBoundPos = (index - 1) * TabWidth
      local rightBoundPos = index * TabWidth
      if scrollLeftPos > rightBoundPos then
        local rechargeData = self.tabs[index]
        leftRedNum = leftRedNum + rechargeData:getRedDotNum()
      elseif scrollRightPos < leftBoundPos then
        local rechargeData = self.tabs[index]
        rightRedNum = rightRedNum + rechargeData:getRedDotNum()
      end
    end
    self.leftPointer:SetActive(0 < leftRedNum)
    self.rightPointer:SetActive(0 < rightRedNum)
  else
    self.leftPointer:SetActive(false)
    self.rightPointer:SetActive(false)
  end
end

function LWBuyDiamondView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:OnOpenFunc()
  SFSNetwork.SendMessage(MsgDefines.GetSeasonInfos)
end

function LWBuyDiamondView:OnDestroy()
  self:DestroyAllDynamicComponents()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWBuyDiamondView:ReopenWithoutCreate()
  base.ReopenWithoutCreate(self)
  self:OnOpenFunc()
end

function LWBuyDiamondView:OnOpenFunc()
  local entryType_old = self.entryType
  self.gotoPackType, self.gotoPackId, self.entryType, self.extraParam, self.gotoActivityId = self:GetUserData()
  if self.gotoPackType then
    local showTag = WelfareController.getShowTagInfoByType(self.gotoPackType)
    if showTag == nil then
      self.entryType = RechargeEntryType.Store
      self.gotoPackId = nil
    else
      self.entryType = showTag:getEntryType()
      self.gotoPackId = showTag:getID()
    end
    if self.gotoPackType == WelfareTagType.GoldBrickStore then
      PostEventLog.Track(PostEventLog.Defines.c_enter_gold_store, {
        openType = tostring(0)
      })
    end
  elseif self.gotoPackId then
    local showTag = WelfareController.getShowTagInfoById(self.gotoPackId)
    if showTag == nil then
      self.entryType = RechargeEntryType.Store
      self.gotoPackId = nil
    else
      self.entryType = showTag:getEntryType()
      self.gotoPackId = showTag:getID()
    end
  elseif not self.entryType then
    self.entryType = RechargeEntryType.Store
  end
  
  local function jumpFunc()
    if self.gotoActivityId then
      for k, v in pairs(self.tabs) do
        if self.gotoActivityId == v:GetActivityId() then
          self:SwitchPage(k)
          return
        end
      end
    end
    if self.gotoPackId then
      self:SwitchPageByRechargeId(self.gotoPackId)
    elseif not table.IsNullOrEmpty(self.tabs) then
      local defaultIndex = 1
      local tagInfo = self.tabs[defaultIndex]
      if tagInfo and tagInfo.GetActivityType then
        local activityType = tagInfo:GetActivityType()
        if activityType == EnumActivity.ActCalendar.Type and #self.tabs > 1 then
          defaultIndex = defaultIndex + 1
        end
      end
      defaultIndex = self:CheckIsNeedSwitchSpecialTab(defaultIndex)
      self:SwitchPage(defaultIndex)
    end
  end
  
  if entryType_old == self.entryType then
    jumpFunc()
    return
  end
  self.ctrl:SetPage(nil)
  self:DestroyAllDynamicComponents()
  local PosY = self.tabContainer:GetAnchoredPositionY()
  self.tabContainer:SetAnchoredPositionXY(0, PosY)
  self:DataDefine()
  self:RefreshTabsData()
  self.storeTopImage:SetActive(self.entryType == RechargeEntryType.Store)
  self.otherTopImage:SetActive(self.entryType == RechargeEntryType.DailySale)
  if self.entryType == RechargeEntryType.Store then
    self.middleContentContainer:SetOffsetMinXY(0, 0)
    self.middleContentContainer:SetOffsetMaxXY(0, -98)
    self.contentContainer:SetOffsetMinXY(0, -3)
    self.contentContainer:SetOffsetMaxXY(0, 13)
    self.downloadResContentContainer:SetOffsetMinXY(0, -3)
    self.downloadResContentContainer:SetOffsetMaxXY(0, 13)
  else
    self.middleContentContainer:SetOffsetMinXY(0, 131)
    self.middleContentContainer:SetOffsetMaxXY(0, -98)
    self.contentContainer:SetOffsetMinXY(12.42, 1.144)
    self.contentContainer:SetOffsetMaxXY(-11.34, -91.5)
    self.downloadResContentContainer:SetOffsetMinXY(12.42, 1.144)
    self.downloadResContentContainer:SetOffsetMaxXY(-11.34, -91.5)
  end
  if self.entryType == RechargeEntryType.Store then
    self.title:SetLocalText(129015)
    EventManager:GetInstance():Broadcast(EventId.EnterDiamondStore)
  elseif self.entryType == RechargeEntryType.DailySale then
    self.title:SetLocalText(2000088)
    EventManager:GetInstance():Broadcast(EventId.EnterDailyPack)
  end
  self:RefreshPaymentMethodSettingAvailability()
  self:CheckShowGoldDetail()
  jumpFunc()
end

function LWBuyDiamondView:CheckIsNeedSwitchSpecialTab(defaultIndex)
  if not defaultIndex or not self.tabs then
    return defaultIndex
  end
  for index, v in ipairs(self.tabs) do
    if v:getType() == WelfareTagType.DailyPackage and v:CanBuy() then
      return index
    end
  end
  return defaultIndex
end

function LWBuyDiamondView:OnEnable()
  base.OnEnable(self)
  self:RefreshPaymentMethodSettingAvailability()
  self:CheckShowGoldDetail()
end

function LWBuyDiamondView:OnDisable()
  base.OnDisable(self)
end

function LWBuyDiamondView:DestroyAllDynamicComponents()
  self:DestroyAllTabs()
  self:DestroyAllPages()
  self:DataDestroy()
end

function LWBuyDiamondView:GotoPage(tagId)
  if not tagId then
    return
  end
  local showTag = WelfareController.getShowTagInfoById(tagId)
  local prevEntryType = self.entryType
  if showTag then
    local entryType = showTag:getEntryType()
    local gotoPackId = showTag:getID()
    local curPageId = self.ctrl:GetPage()
    local curPageTagId = self:GetTagIdById(curPageId)
    if curPageTagId == gotoPackId then
      return
    end
    self.entryType = entryType
    self.gotoPackId = gotoPackId
    if prevEntryType ~= self.entryType then
      self:DestroyAllTabs()
      self:DestroyAllPages()
      self:RefreshTabsData()
      self:RefreshPaymentMethodSettingAvailability()
      self:CheckShowGoldDetail()
    end
    self:SwitchPageByRechargeId(self.gotoPackId)
    self:CenterOn(self.gotoPackId)
  end
end

function LWBuyDiamondView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlayerInfoUpdated, self.CheckShowGoldDetail)
  self:AddUIListener(EventId.ExternalCheckoutAvailabilityChanged, self.CheckShowGoldDetail)
  self:AddUIListener(EventId.RefreshWelfareRedDot, self.RefreshPointer)
  self:AddUIListener(EventId.ShopGotoPage, self.GotoPage)
  self:AddUIListener(EventId.EnableOneUITopItem, self.OnOneUITopItemEnabled)
  self:AddUIListener(EventId.ActivityTimeEnd, self.OnActivityTimeEndMsg)
  self:AddUIListener(EventId.GetSeasonStartTime, self.RefreshBtnPackTipsState)
end

function LWBuyDiamondView:OnRemoveListener()
  self:RemoveUIListener(EventId.PlayerInfoUpdated, self.CheckShowGoldDetail)
  self:RemoveUIListener(EventId.ExternalCheckoutAvailabilityChanged, self.CheckShowGoldDetail)
  self:RemoveUIListener(EventId.RefreshWelfareRedDot, self.RefreshPointer)
  self:RemoveUIListener(EventId.ShopGotoPage, self.GotoPage)
  self:RemoveUIListener(EventId.EnableOneUITopItem, self.OnOneUITopItemEnabled)
  self:RemoveUIListener(EventId.ActivityTimeEnd, self.OnActivityTimeEndMsg)
  self:RemoveUIListener(EventId.GetSeasonStartTime, self.RefreshBtnPackTipsState)
  base.OnRemoveListener(self)
end

function LWBuyDiamondView:ComponentDefine()
  self.title = self:AddComponent(UIText, "Root/TopBar/TextTitle")
  self.storeTopImage = self.transform:Find("Root/TopBar/StoreTopImage").gameObject
  self.otherTopImage = self.transform:Find("Root/TopBar/OtherTopImage").gameObject
  self.titleOriginalSizeDeltaX = self.title.rectTransform.sizeDelta.x
  self.closeBtn = self:AddComponent(UIButton, "Root/BottomBar/BtnBack")
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.tabScroll = self:AddComponent(UIScrollRect, "Root/MiddleContentContainer/ConditionBtnScroll")
  self.tabScroll:AddValueChangeListener(function()
    self:RefreshPointer()
  end)
  self.tabContainer = self:AddComponent(UIBaseContainer, "Root/MiddleContentContainer/ConditionBtnScroll/ConditionBtns")
  self.middleContentContainer = self:AddComponent(UIBaseContainer, "Root/MiddleContentContainer")
  self.contentContainer = self:AddComponent(UIBaseContainer, "Root/MiddleContentContainer/ContentContainer")
  self.downloadResContentContainer = self:AddComponent(UIBaseContainer, "Root/MiddleContentContainer/DownloadResContentContainer")
  self.leftPointer = self:AddComponent(UIBaseContainer, "Root/MiddleContentContainer/LeftPointer")
  self.leftPointer:SetActive(false)
  self.rightPointer = self:AddComponent(UIBaseContainer, "Root/MiddleContentContainer/RightPointer")
  self.rightPointer:SetActive(false)
  self.goldDetail_btn = self:AddComponent(UIButton, "Root/TopBar/layout/goldDetail_btn")
  self.goldDetail_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWGoldDetail, {anim = true})
  end)
  self.paymentMethodSetting_btn = self:AddComponent(UIButton, "Root/TopBar/layout/paymentMethodSetting_btn")
  self.paymentMethodSetting_btn:SetOnClick(function()
    self:OnPaymentSettingClick()
  end)
  self.paymentMethodSettingIcon = self:AddComponent(UIImage, "Root/TopBar/layout/paymentMethodSetting_btn/bg/icon")
  self.btnPackTips = self:AddComponent(UIButton, "Root/TopBar/layout/PackTipsBtn")
  self.btnPackTips:SetOnClick(function()
    self:OnBtnPackTipsClick()
  end)
end

function LWBuyDiamondView:ComponentDestroy()
  self.title = nil
  self.closeBtn = nil
  if self.tabScroll then
    self.tabScroll:RemoveAllListeners()
  end
  self.tabScroll = nil
  self.tabContainer = nil
  self.contentContainer = nil
  self.downloadResContentContainer = nil
  self.leftPointer = nil
  self.rightPointer = nil
  self.middleContentContainer = nil
  self.storeTopImage = nil
  self.otherTopImage = nil
  self.paymentMethodSetting_btn = nil
  self.paymentMethodSettingIcon = nil
end

function LWBuyDiamondView:RefreshTabsData()
  self.modelTabs = {}
  self.tabItems = {}
  self.tabs = WelfareController.getShowTagInfosWithType(self.entryType)
  for i, v in ipairs(self.tabs) do
    local id = v:getID()
    self.modelTabs[id] = self:GameObjectInstantiateAsync(UIAssets.UIShopPageToggle, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.tabContainer.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = i
      local cell = self.tabContainer:AddComponent(ShopPageToggle, go.name, i, id)
      cell:SetData()
      self.tabItems[i] = cell
      local curPageId = self.ctrl:GetPage()
      if curPageId then
        if i == curPageId then
          cell:SetSelect()
        else
          cell:SetUnSelect()
        end
      else
        cell:SetUnSelect()
      end
      self.loadedTabsCount = self.loadedTabsCount + 1
      if self.loadedTabsCount == table.count(self.tabs) and self.gotoPackId then
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.tabContainer.rectTransform)
        self:CenterOn(self.gotoPackId)
      end
      self:RefreshPointer()
    end)
  end
end

function LWBuyDiamondView:DestroyAllTabs()
  if self.tabContainer then
    self.tabContainer:RemoveAllComponentes()
  end
  if self.modelTabs ~= nil then
    for k, v in pairs(self.modelTabs) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.modelTabs = {}
  self.tabItems = {}
end

function LWBuyDiamondView:DestroyAllPages()
  if self.contentContainer then
    CS.DynamicFPSConfig.FreeHighFPSLockerForChildrenScrollComponents(self.contentContainer.gameObject)
    self.contentContainer:RemoveAllComponentes()
  end
  if self.packPrefabList ~= nil then
    for k, v in pairs(self.packPrefabList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.packPrefabList = {}
  self.packCompList = {}
end

function LWBuyDiamondView:DestroyDownloadResPage()
  if self.downloadResContentContainer then
    self.downloadResContentContainer:RemoveAllComponentes()
  end
  if self.downloadResRequest ~= nil then
    self:GameObjectDestroy(self.downloadResRequest)
  end
  self.downloadResComp = nil
end

function LWBuyDiamondView:RefreshView()
end

function LWBuyDiamondView:OnBackBtnClick()
  self.ctrl:CloseSelf()
end

function LWBuyDiamondView:SwitchPage(id)
  local hasData = false
  local index = id
  hasData = self.tabs[index] ~= nil
  if not hasData then
    return
  end
  self:OnToggleItemClick(index)
end

function LWBuyDiamondView:SwitchPageByRechargeId(id)
  local index = 1
  if not table.IsNullOrEmpty(self.tabs) then
    for k, v in pairs(self.tabs) do
      if v:getID() == id then
        index = k
        break
      end
    end
  end
  self:OnToggleItemClick(index)
end

function LWBuyDiamondView:GetTagTypeById(id)
  local tagType
  if not self.tabs[id] then
    return tagType
  end
  tagType = self.tabs[id]:getType()
  return tagType
end

function LWBuyDiamondView:GetTagIdById(id)
  local tagType
  if not self.tabs[id] then
    return tagType
  end
  tagType = self.tabs[id]:getID()
  return tagType
end

function LWBuyDiamondView:OnSwitchTab(newPageId, isReloadCurPage)
  local curPageId = self.ctrl:GetPage()
  if curPageId == newPageId and not isReloadCurPage then
    return
  end
  self.ctrl:SetPage(newPageId)
  if self.packCompList[curPageId] then
    self.packCompList[curPageId]:SetActive(false)
  end
  local rechargeId = self:GetTagIdById(newPageId)
  local showDownloadPage = self.ctrl:IsNeedCheckDownloadRes(rechargeId) and not self.ctrl:IsDownloadResComplete(rechargeId)
  self.contentContainer:SetActive(not showDownloadPage)
  self.downloadResContentContainer:SetActive(showDownloadPage)
  local showTagInfo = self.tabs[newPageId]
  if showTagInfo then
    local showTagType = showTagInfo:getType()
    if showTagType == WelfareTagType.GoldBrickStore then
      PostEventLog.Track(PostEventLog.Defines.c_enter_gold_store, {
        openType = tostring(1)
      })
    end
    if self.entryType == RechargeEntryType.Store then
      PostEventLog.Track(PostEventLog.Defines.c_enter_store, {
        actid = showTagInfo:getID()
      })
    end
  end
  if showDownloadPage then
    if self.downloadResRequest == nil then
      self.downloadResRequest = self:GameObjectInstantiateAsync(UIAssets.LWBuyDiamondDownloadRes, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.downloadResContentContainer.transform)
        go.transform:Set_localScale(1, 1, 1)
        self.downloadResComp = self.downloadResContentContainer:AddComponent(LWBuyDiamondResDownloadComponent, go.name)
        self.downloadResComp:SetOffsetMinXY(0, 0)
        self.downloadResComp:SetOffsetMaxXY(0, 0)
        if self.ctrl:GetPage() ~= newPageId then
          self.downloadResComp:SetActive(false)
        else
          self.downloadResComp:SetActive(true)
        end
        self.downloadResComp:SetData(rechargeId, function()
          if self.ctrl then
            local currPageId = self.ctrl:GetPage()
            if currPageId == newPageId then
              self:OnSwitchTab(newPageId, true)
            end
          end
        end)
      end)
    elseif self.downloadResComp ~= nil then
      self.downloadResComp:SetActive(true)
      self.downloadResComp:SetData(rechargeId)
    end
  else
    self:__ShowRealPageContent(newPageId)
  end
end

function LWBuyDiamondView:__ShowRealPageContent(newPageId)
  local newPageType = self:GetTagTypeById(newPageId)
  local newPageTagId = self:GetTagIdById(newPageId)
  local handlerData
  if newPageType == WelfareTagType.SingleActivity then
    local rechargeData = self.tabs[newPageId]
    if rechargeData and rechargeData:getInfo() then
      local actData = rechargeData:getInfo()
      local actId = actData.id
      handlerData = DataCenter.ActivityListDataManager:GetActivityShowData(actId)
    end
  else
    handlerData = WelfareTagShowInfo[newPageType]
  end
  if not self.packPrefabList[newPageId] and handlerData and handlerData.assetPath and handlerData.cls then
    self.packPrefabList[newPageId] = self:GameObjectInstantiateAsync(handlerData.assetPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.contentContainer.transform)
      go.transform:Set_localScale(1, 1, 1)
      go.name = tostring(newPageId)
      local cls = handlerData.cls
      if newPageType ~= WelfareTagType.SingleActivity then
        cls = require(cls)
      end
      local pageComp = self.contentContainer:AddComponent(cls, go.name)
      pageComp:SetOffsetMinXY(0, 0)
      pageComp:SetOffsetMaxXY(0, 0)
      self.packCompList[newPageId] = pageComp
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(pageComp.rectTransform)
      if self.ctrl:GetPage() ~= newPageId then
        pageComp:SetActive(false)
      else
        pageComp:SetActive(true)
      end
      if newPageType == WelfareTagType.DiamondShop then
        pageComp:RefreshView()
      elseif newPageType == WelfareTagType.GoldBrickStore or newPageType == WelfareTagType.BrickGiftPack then
        pageComp:RefreshView()
      elseif newPageType == WelfareTagType.PackStore then
        local param = {}
        param.welfareTagType = newPageType
        pageComp:ReInit(param)
      elseif newPageType == WelfareTagType.MonthCard then
        local param = {}
        param.welfareTagType = newPageType
        local golloesMonthCard = DataCenter.MonthCardNewManager:GetGolloesMonthCard()
        param.monthCardInfo = golloesMonthCard
        pageComp:ReInit(param, self)
      elseif newPageType == WelfareTagType.SingleActivity then
        local rechargeData = self.tabs[newPageId]
        if rechargeData and rechargeData:getInfo() then
          local actData = rechargeData:getInfo()
          pageComp:SetData(actData.activityId, actData.id)
        end
      elseif newPageType == WelfareTagType.WeeklyPackageNew then
        pageComp:ReInit(newPageTagId, self.extraParam)
      elseif newPageType == WelfareTagType.DailyPackage or newPageType == WelfareTagType.WeekCard or newPageType == WelfareTagType.SpecialPackStoreStyle or newPageType == WelfareTagType.PiggyBank or newPageType == WelfareTagType.DailyMustBuy then
        pageComp:ReInit(newPageTagId)
      elseif newPageType == WelfareTagType.HeroMonthCardNew then
        local rechargeData = self.tabs[newPageId]
        if rechargeData then
          pageComp:ReInit(rechargeData:getID())
          pageComp:SetBuyDiamondViewType(BuyDiamondViewType.Normal)
        end
      elseif newPageType == WelfareTagType.PopRechargeCollect then
        DataCenter.RechargeManager:SaveLocalRedDotInfo("PopRechargeCollect", UITimeManager:GetInstance():GetTomorrowZero() / 1000)
        local rechargeId = -1
        local showPackages = WelfareController.GetPopupPackages(RechargeEntryType.PopRechargeInStore)
        pageComp:ReInit4StorePage(rechargeId, showPackages)
        EventManager:GetInstance():Broadcast(EventId.RefreshWelfareRedDot)
      end
      if comp and newPageType == WelfareTagType.HeroMonthCardNew then
        PostEventLog.Track(PostEventLog.Defines.HeroMonthCardViewOpen, {})
      end
      CS.DynamicFPSConfig.AcquireHighFPSLockerForChildrenScrollComponents(go)
    end)
  elseif self.packCompList[newPageId] then
    self.packCompList[newPageId]:SetActive(true)
    local comp = self.packCompList[newPageId]
    if comp then
      if newPageType == WelfareTagType.DiamondShop then
        comp:RefreshView()
      elseif newPageType == WelfareTagType.GoldBrickStore or newPageType == WelfareTagType.BrickGiftPack then
        comp:RefreshView()
      elseif newPageType == WelfareTagType.PackStore then
        local param = {}
        param.welfareTagType = newPageType
        comp:ReInit(param)
      elseif newPageType == WelfareTagType.MonthCard then
        local param = {}
        param.welfareTagType = newPageType
        local golloesMonthCard = DataCenter.MonthCardNewManager:GetGolloesMonthCard()
        param.monthCardInfo = golloesMonthCard
        comp:ReInit(param, self)
      elseif newPageType == WelfareTagType.SingleActivity then
        local rechargeData = self.tabs[newPageId]
        if rechargeData and rechargeData:getInfo() then
          local actData = rechargeData:getInfo()
          comp:SetData(actData.activityId, actData.id)
        end
      elseif newPageType == WelfareTagType.DailyPackage or newPageType == WelfareTagType.WeekCard or newPageType == WelfareTagType.SpecialPackStoreStyle or newPageType == WelfareTagType.WeeklyPackageNew or newPageType == WelfareTagType.DailyMustBuy then
        comp:ReInit(newPageTagId)
      elseif newPageType == WelfareTagType.HeroMonthCardNew then
        local rechargeData = self.tabs[newPageId]
        if rechargeData then
          comp:ReInit(rechargeData:getID())
          comp:SetBuyDiamondViewType(BuyDiamondViewType.Normal)
        end
      elseif newPageType == WelfareTagType.PopRechargeCollect then
        local showPackages = WelfareController.GetPopupPackages(RechargeEntryType.PopRechargeInStore)
        comp:ReInit4StorePage(-1, showPackages)
      end
    end
    if comp and newPageType == WelfareTagType.HeroMonthCardNew then
      PostEventLog.Track(PostEventLog.Defines.HeroMonthCardViewOpen, {})
    end
  end
end

function LWBuyDiamondView:OnToggleItemClick(id)
  if not id then
    return
  end
  local oldId = self.ctrl:GetPage()
  if oldId ~= id then
    if oldId and self.tabItems[oldId] then
      self.tabItems[oldId]:SetUnSelect()
    end
    if self.tabItems[id] then
      self.tabItems[id]:SetSelect()
    end
    if CommonUtil.IsArabic() then
      self.title.rectTransform.sizeDelta = Vector2.New(self.titleOriginalSizeDeltaX, self.title.rectTransform.sizeDelta.y)
    end
  end
  self:OnSwitchTab(id)
end

function LWBuyDiamondView:OnOneUITopItemEnabled()
  if CommonUtil.IsArabic() then
    local oldSizeDeltaX = self.title.rectTransform.sizeDelta.x
    local oldSizeDeltaY = self.title.rectTransform.sizeDelta.y
    self.title.rectTransform.sizeDelta = Vector2.New(oldSizeDeltaX - 200, oldSizeDeltaY)
  end
end

function LWBuyDiamondView:OnActivityTimeEndMsg()
  local tabs = WelfareController.getShowTagInfosWithType(self.entryType)
  local isHaveChange = false
  if #tabs ~= #self.tabs then
    isHaveChange = true
  end
  for i, v in ipairs(tabs) do
    local id = v:getID()
    local oldId = self.tabs[i]:getID()
    if id ~= oldId then
      isHaveChange = true
      break
    end
  end
  if not isHaveChange then
    return
  end
  local curPageId = self.ctrl:GetPage()
  local curPageTagId = self:GetTagIdById(curPageId)
  self:DestroyAllTabs()
  self:DestroyAllPages()
  self:RefreshTabsData()
  if self.tabs[curPageId] == nil then
    curPageId = 1
    curPageTagId = self:GetTagIdById(curPageId)
  end
  self:SwitchPageByRechargeId(curPageTagId)
  self:CenterOn(curPageTagId)
end

function LWBuyDiamondView:CheckShowGoldDetail()
  self.goldDetail_btn:SetActive(self.entryType == RechargeEntryType.Store and DataCenter.PlayerInfoDataManager:ShowGoldDetail())
  local canShowPaymentSetting = self.entryType == RechargeEntryType.Store and DataCenter.PaymentMethodManager:CanShowPreferenceSettingForUI()
  self.paymentMethodSetting_btn:SetActive(canShowPaymentSetting)
end

function LWBuyDiamondView:RefreshPaymentMethodSettingAvailability()
  if self.entryType ~= RechargeEntryType.Store then
    return
  end
  DataCenter.PaymentMethodManager:TryRefreshRuntimeExternalCheckoutAvailabilityForUI()
end

function LWBuyDiamondView:OnPaymentSettingClick()
  if not DataCenter.PaymentMethodManager:CanShowPreferenceSettingForUI() then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPaymentPreferenceSetting, {anim = true, playEffect = false})
end

function LWBuyDiamondView:OnBtnPackTipsClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.BuyDiamondPackTips, {anim = true}, self.showTipsCfgData)
end

function LWBuyDiamondView:RefreshBtnPackTipsState(seasonStartMsg)
  local ok, errorMsg = pcall(function()
    self:SetBtnPackTipsState(seasonStartMsg)
  end)
  if not ok and errorMsg then
    Logger.LogError("\231\164\188\229\140\133\231\149\140\233\157\162\230\182\136\230\129\175\229\188\185\230\157\191\230\140\137\233\146\174\232\174\161\231\174\151\230\182\136\230\129\175\229\164\177\232\180\165\239\188\154" .. errorMsg)
  end
end

function LWBuyDiamondView:SetBtnPackTipsState(seasonStartMsg)
  seasonStartMsg = seasonStartMsg or {}
  local seasonDataList = {}
  for i = 1, #seasonStartMsg do
    local data = {}
    data.seasonId = seasonStartMsg[i].seasonId
    data.startTime = seasonStartMsg[i].startTime
    table.insert(seasonDataList, data)
  end
  self.showTipsCfgData = self:GetShowBuyDiamondTemplate(seasonDataList)
  local isEmpty = self.showTipsCfgData == nil
  self.btnPackTips:SetActive(self.entryType == RechargeEntryType.Store and not isEmpty)
end

function LWBuyDiamondView:GetShowBuyDiamondTemplate(seasonDataList)
  local timeOrderCfgList = {}
  LocalController:instance():visitTable(TableName.ACTIVITY_UPDATE_LIST, function(id, lineData)
    if lineData then
      local item = BuyDiamondTemplate.New()
      item:InitData(lineData)
      table.insert(timeOrderCfgList, item)
    end
  end)
  for i = #timeOrderCfgList, 1, -1 do
    if timeOrderCfgList[i]:GetRealStartTime(seasonDataList) <= 0 then
      table.remove(timeOrderCfgList, i)
    end
  end
  table.sort(timeOrderCfgList, function(a, b)
    return a:GetRealStartTime(seasonDataList) > b:GetRealStartTime(seasonDataList)
  end)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for i = 1, #timeOrderCfgList do
    local startShowTime = timeOrderCfgList[i]:GetRealStartTime(seasonDataList)
    if 0 < startShowTime and curTime > startShowTime and curTime <= startShowTime + timeOrderCfgList[i]:GetDurationTimeStamp(startShowTime) and timeOrderCfgList[i]:IsMeetShowCondition() then
      return timeOrderCfgList[i]
    end
  end
  return nil
end

return LWBuyDiamondView
