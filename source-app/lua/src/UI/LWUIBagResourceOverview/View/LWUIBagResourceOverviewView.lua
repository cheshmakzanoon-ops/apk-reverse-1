local base = UIBaseView
local LWUIBagResourceOverviewView = BaseClass("LWUIBagResourceOverviewView", base)
local LWUIBagResourceOverviewTabItemRender = require("UI.LWUIBagResourceOverview.Component.LWUIBagResourceOverviewTabItemRender")
local LWUIBagResourceOverviewItemRender = require("UI.LWUIBagResourceOverview.Component.LWUIBagResourceOverviewItemRender")
local Localization = CS.GameEntry.Localization
local BagResourceOverviewViewData = {
  tabType = 0,
  itemId = 0,
  ownValue = 0,
  bagValue = 0
}
local OneViewData = DataClass("OneViewData", BagResourceOverviewViewData)
local ResourceType2FuncUnlockID = {
  [ResourceType.Petroleum] = LWFunctionUnlockType.MainUI_PetroleumBar
}
local panelBtn_path = "panel"
local titleText_path = "PopUpContent/TitleText"
local closeBtn_path = "PopUpContent/CloseBtn"
local tabScrollView_path = "PopUpContent/TopContent/TabScrollView"
local resourceScrollView_path = "PopUpContent/ResourceScrollView"
local tipsText_path = "PopUpContent/TipsText"
local timeSelectContent_path = "PopUpContent/TimeSelectContent"
local dailyToggle_path = "PopUpContent/TimeSelectContent/DayToggle"
local dailyToggleText_path = "PopUpContent/TimeSelectContent/DayToggle/DayToggleText"
local hourToggle_path = "PopUpContent/TimeSelectContent/HourToggle"
local hourToggleText_path = "PopUpContent/TimeSelectContent/HourToggle/HourToggleText"
local minuteToggle_path = "PopUpContent/TimeSelectContent/MinuteToggle"
local minuteToggleText_path = "PopUpContent/TimeSelectContent/MinuteToggle/MinuteToggleText"
local resourceDesContent_path = "PopUpContent/ResourceDesContent"
local speedUpDesContent_path = "PopUpContent/SpeedUpDesContent"
local heroExpDesContent_path = "PopUpContent/OtherDesContent"
local infoBtn_path = "PopUpContent/InfoBtn"
local resourceDesTexts_path = {
  "PopUpContent/ResourceDesContent/ResourceDesText1",
  "PopUpContent/ResourceDesContent/ResourceDesText2",
  "PopUpContent/ResourceDesContent/ResourceDesText3",
  "PopUpContent/ResourceDesContent/ResourceDesText4"
}
local speedUpDesTexts_path = {
  "PopUpContent/SpeedUpDesContent/SpeedUpDesText1",
  "PopUpContent/SpeedUpDesContent/SpeedUpDesText2"
}
local otherDesTexts_path = {
  "PopUpContent/OtherDesContent/OtherDesText1",
  "PopUpContent/OtherDesContent/OtherDesText2",
  "PopUpContent/OtherDesContent/OtherDesText3",
  "PopUpContent/OtherDesContent/OtherDesText4"
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitData()
end

local function OnDestroy(self)
  self:RemoveTabScroll()
  self:RemoveResourceScroll()
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
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.tabScrollView = self:AddComponent(UIScrollView, tabScrollView_path)
  self.resourceScrollView = self:AddComponent(UIScrollView, resourceScrollView_path)
  self.tipsText = self:AddComponent(UIText, tipsText_path)
  self.timeSelectContent = self:AddComponent(UIBaseContainer, timeSelectContent_path)
  self.dailyToggle = self:AddComponent(UIToggle, dailyToggle_path)
  self.dailyToggleText = self:AddComponent(UIText, dailyToggleText_path)
  self.hourToggle = self:AddComponent(UIToggle, hourToggle_path)
  self.hourToggleText = self:AddComponent(UIText, hourToggleText_path)
  self.minuteToggle = self:AddComponent(UIToggle, minuteToggle_path)
  self.minuteToggleText = self:AddComponent(UIText, minuteToggleText_path)
  self.resourceDesContent = self:AddComponent(UIBaseContainer, resourceDesContent_path)
  self.speedUpDesContent = self:AddComponent(UIBaseContainer, speedUpDesContent_path)
  self.heroExpDesContent = self:AddComponent(UIBaseContainer, heroExpDesContent_path)
  self.infoBtn = self:AddComponent(UIButton, infoBtn_path)
  self.resourceDesTexts = {
    self:AddComponent(UIText, resourceDesTexts_path[1]),
    self:AddComponent(UIText, resourceDesTexts_path[2]),
    self:AddComponent(UIText, resourceDesTexts_path[3]),
    self:AddComponent(UIText, resourceDesTexts_path[4])
  }
  self.speedUpDesTexts = {
    self:AddComponent(UIText, speedUpDesTexts_path[1]),
    self:AddComponent(UIText, speedUpDesTexts_path[2])
  }
  self.otherDesTexts = {
    self:AddComponent(UIText, otherDesTexts_path[1]),
    self:AddComponent(UIText, otherDesTexts_path[2]),
    self:AddComponent(UIText, otherDesTexts_path[3]),
    self:AddComponent(UIText, otherDesTexts_path[4])
  }
  self.titleText:SetLocalText("resource_speed_statistics_title")
  self.dailyToggleText:SetLocalText("according_day_statistics")
  self.hourToggleText:SetLocalText("according_hour_statistics")
  self.minuteToggleText:SetLocalText("according_minute_statistics")
  self.tipsText:SetLocalText("resource_speed_statistics_rule")
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.panelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.dailyToggle:SetOnValueChanged(function(value)
    if value then
      self:OnSelectToggle(BagResourceOverviewShowTimeType.Day)
    end
  end)
  self.hourToggle:SetOnValueChanged(function(value)
    if value then
      self:OnSelectToggle(BagResourceOverviewShowTimeType.Hour)
    end
  end)
  self.minuteToggle:SetOnValueChanged(function(value)
    if value then
      self:OnSelectToggle(BagResourceOverviewShowTimeType.Minute)
    end
  end)
  self.tabScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnTabItemMoveIn(itemObj, index)
  end)
  self.tabScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnTabItemMoveOut(itemObj, index)
  end)
  self.resourceScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnResourceItemMoveIn(itemObj, index)
  end)
  self.resourceScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnResourceItemMoveOut(itemObj, index)
  end)
  self.infoBtn:SetOnClick(function()
    self:InfoBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.panelBtn = nil
  self.titleText = nil
  self.closeBtn = nil
  self.tabScrollView = nil
  self.resourceScrollView = nil
  self.tipsText = nil
  self.timeSelectContent = nil
  self.dailyToggle = nil
  self.dailyToggleText = nil
  self.hourToggle = nil
  self.hourToggleText = nil
  self.minuteToggle = nil
  self.minuteToggleText = nil
  self.resourceDesContent = nil
  self.speedUpDesContent = nil
  self.heroExpDesContent = nil
  self.infoBtn = nil
  self.resourceDesTexts = nil
  self.speedUpDesTexts = nil
  self.otherDesTexts = nil
end

local function DataDefine(self)
  self.curTabIndex = 1
  self.tabViewDataList = {}
  self.resourceViewDataList = {}
  self.resourceTypeShowConfig = {}
  self.test = {}
  local goodsStr = LuaEntry.DataConfig:TryGetStr("goods_total", "k1")
  local goodArr = string.split(goodsStr, "|")
  for i = 1, table.count(goodArr) do
    local goodData = string.split(goodArr[i], ";")
    if table.count(goodData) == 2 then
      table.insert(self.resourceTypeShowConfig, {
        resourceType = tonumber(goodData[1]),
        id = tonumber(goodData[2])
      })
    end
  end
  self.needCheckShowConditionType = {}
  local str = LuaEntry.DataConfig:TryGetStr("goods_total", "k3")
  local strArr = string.split(str, "|")
  for j = 1, table.count(strArr) do
    table.insert(self.needCheckShowConditionType, tonumber(strArr[j]))
  end
  self.speedUpTypeShowConfig = {}
  local speedUpStr = LuaEntry.DataConfig:TryGetStr("goods_total", "k2")
  local speedUpArr = string.split(speedUpStr, ";")
  for m = 1, table.count(speedUpArr) do
    local speedUpData = string.split(speedUpArr[m], "|")
    if table.count(speedUpData) == 2 then
      table.insert(self.speedUpTypeShowConfig, {
        speedUpType = tonumber(speedUpData[1]),
        param = tonumber(speedUpData[2])
      })
    end
  end
  self.otherTypeShowConfig = {}
  local otherStr = LuaEntry.DataConfig:TryGetStr("goods_total", "k4", "8001")
  local otherArr = string.split(otherStr, "|")
  for j = 1, table.count(otherArr) do
    table.insert(self.otherTypeShowConfig, tonumber(otherArr[j]))
  end
  self.tabType2DesData = {}
  self.tabType2DesData[BagResourceOverviewTabType.Resource] = {
    "resource_type_statistics",
    "item_resource_statistics",
    "own_resource_statistics",
    "total_resource_statistics"
  }
  self.tabType2DesData[BagResourceOverviewTabType.SpeedUp] = {
    "speed_type_statistics",
    "total_speed_statistics"
  }
  self.tabType2DesData[BagResourceOverviewTabType.Other] = {
    "item_type_statistics",
    "item_resource_statistics",
    "own_resource_statistics",
    "total_resource_statistics"
  }
end

local function DataDestroy(self)
  self.curTabIndex = nil
  self.tabViewDataList = nil
  self.resourceViewDataList = nil
  self.resourceTypeShowConfig = nil
  self.needCheckShowConditionType = nil
  self.speedUpTypeShowConfig = nil
  self.otherTypeShowConfig = nil
  self.tabType2DesData = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ResourceUpdated, self.OnUpdateResourceView)
  self:AddUIListener(EventId.UseItemSuccess, self.OnUpdateResourceView)
  self:AddUIListener(EventId.UpdateGiftPackData, self.OnUpdateResourceView)
  self:AddUIListener(EventId.PlayerStaminaUpdate, self.OnUpdateResourceView)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.ResourceUpdated, self.OnUpdateResourceView)
  self:RemoveUIListener(EventId.UseItemSuccess, self.OnUpdateResourceView)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.OnUpdateResourceView)
  self:RemoveUIListener(EventId.PlayerStaminaUpdate, self.OnUpdateResourceView)
  base.OnRemoveListener(self)
end

local function OnUpdateResourceView(self)
  local curTabType = self.tabViewDataList[self.curTabIndex].tabType
  if curTabType == BagResourceOverviewTabType.Resource or curTabType == BagResourceOverviewTabType.Other then
    self:ShowCurTabView()
  end
end

local function InitData(self)
  self.curTabIndex = 1
  self.ctrl:SetSpeedUpTimeShowType(BagResourceOverviewShowTimeType.Day)
  self:ShowTabView()
end

local function InfoBtnClick(self)
  local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.Default)
  param.content = Localization:GetString("total_resource_statistics_rule")
  param.alignObject = self.infoBtn
  param.yPosFix = -30
  param.showArrow = true
  param.preferTop = false
  param.width = 525
  param.addPosX = -70 * CommonUtil.ArabicAutoMirrorFactor()
  param.unEnableTouchThrough = true
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
end

local function ShowTabView(self)
  if table.count(self.tabViewDataList) == 0 then
    table.insert(self.tabViewDataList, {
      tabType = BagResourceOverviewTabType.Resource
    })
    table.insert(self.tabViewDataList, {
      tabType = BagResourceOverviewTabType.SpeedUp
    })
    table.insert(self.tabViewDataList, {
      tabType = BagResourceOverviewTabType.Other
    })
  end
  local tabCount = table.count(self.tabViewDataList)
  if 0 < tabCount then
    self.tabScrollView:SetTotalCount(tabCount)
    self.tabScrollView:RefillCells()
    self:OnTabItemClick(self.curTabIndex)
  end
end

local function OnTabItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.tabScrollView:AddComponent(LWUIBagResourceOverviewTabItemRender, itemObj)
  if itemRender ~= nil then
    itemRender:InitData(index, self.tabViewDataList[index], self.curTabIndex)
  end
end

local function OnTabItemMoveOut(self, itemObj, index)
  self.tabScrollView:RemoveComponent(itemObj.name, LWUIBagResourceOverviewTabItemRender)
end

local function RemoveTabScroll(self)
  self.tabScrollView:ClearCells()
  self.tabScrollView:RemoveComponents(LWUIBagResourceOverviewTabItemRender)
end

local function OnTabItemClick(self, index)
  self.curTabIndex = index
  local curTabType = self.tabViewDataList[self.curTabIndex].tabType
  self:SetDesView(curTabType)
  self.tipsText:SetActive(curTabType == BagResourceOverviewTabType.Resource)
  self.timeSelectContent:SetActive(curTabType == BagResourceOverviewTabType.SpeedUp)
  self:ShowCurTabView()
end

local function ShowCurTabView(self)
  local curTabType = self.tabViewDataList[self.curTabIndex].tabType
  if curTabType == BagResourceOverviewTabType.Resource then
    self:GetResourceViewData()
  elseif curTabType == BagResourceOverviewTabType.SpeedUp then
    self:GetSpeedUpViewData()
    self:SetToggleState()
  elseif curTabType == BagResourceOverviewTabType.Other then
    self:GetOtherViewData()
  end
  local resourceCount = table.count(self.resourceViewDataList)
  if 0 < resourceCount then
    self:RemoveResourceScroll()
    self.resourceScrollView:SetTotalCount(resourceCount)
    self.resourceScrollView:RefillCells()
  end
end

local function SetDesView(self, tabType)
  self.resourceDesContent:SetActive(tabType == BagResourceOverviewTabType.Resource)
  self.speedUpDesContent:SetActive(tabType == BagResourceOverviewTabType.SpeedUp)
  self.heroExpDesContent:SetActive(tabType == BagResourceOverviewTabType.Other)
  local dataList = self.tabType2DesData[tabType]
  local showTexts
  if tabType == BagResourceOverviewTabType.Resource then
    showTexts = self.resourceDesTexts
  elseif tabType == BagResourceOverviewTabType.SpeedUp then
    showTexts = self.speedUpDesTexts
  else
    showTexts = self.otherDesTexts
  end
  for i = 1, table.count(showTexts) do
    if dataList[i] then
      showTexts[i]:SetActive(true)
      showTexts[i]:SetLocalText(dataList[i])
    else
      showTexts[i]:SetActive(false)
    end
  end
end

local function OnResourceItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.resourceScrollView:AddComponent(LWUIBagResourceOverviewItemRender, itemObj)
  if itemRender ~= nil then
    itemRender:InitData(index, self.resourceViewDataList[index])
  end
end

local function OnResourceItemMoveOut(self, itemObj, index)
  self.resourceScrollView:RemoveComponent(itemObj.name, LWUIBagResourceOverviewItemRender)
end

local function RemoveResourceScroll(self)
  self.resourceScrollView:ClearCells()
  self.resourceScrollView:RemoveComponents(LWUIBagResourceOverviewItemRender)
end

local function GetResourceViewData(self)
  self.resourceViewDataList = {}
  local itemType109CountDict = {}
  local itemType109List = DataCenter.ItemData:GetItemsByType(GOODS_TYPE.GOODS_TYPE_109)
  for i = 1, table.count(itemType109List) do
    local itemInfo = itemType109List[i]
    local itemTemplate = itemInfo.goods
    local returnItem = DataCenter.AdaptiveBoxTemplateManager:GetReturnItem(tonumber(itemTemplate.para1), DataCenter.BuildManager.MainLv, tonumber(itemTemplate.para2))
    if returnItem ~= nil then
      local giveCount = returnItem.count * tonumber(itemTemplate.para3) * itemInfo.count or 0
      if itemType109CountDict[returnItem.id] == nil then
        itemType109CountDict[returnItem.id] = {count = 0}
      end
      itemType109CountDict[returnItem.id].count = itemType109CountDict[returnItem.id].count + giveCount
    end
  end
  local itemType3CountDict = {}
  local itemType3List = DataCenter.ItemData:GetItemsByType(GOODS_TYPE.GOODS_TYPE_3)
  for j = 1, table.count(itemType3List) do
    local itemInfo = itemType3List[j]
    local itemTemplate = itemInfo.goods
    local id = tonumber(itemTemplate.para1)
    local giveCount = tonumber(itemTemplate.para2) * itemInfo.count or 0
    if itemType3CountDict[id] == nil then
      itemType3CountDict[id] = {count = 0}
    end
    itemType3CountDict[id].count = itemType3CountDict[id].count + giveCount
  end
  for m = 1, table.count(self.resourceTypeShowConfig) do
    local configData = self.resourceTypeShowConfig[m]
    local resourceType = configData.resourceType
    local resourceId = configData.id
    local isShow = self:JudgeResourceIsShow(resourceType)
    if isShow then
      local oneData = OneViewData.New()
      oneData.tabType = BagResourceOverviewTabType.Resource
      oneData.itemId = resourceType
      local ownCount = LuaEntry.Resource:GetCntByResType(resourceType)
      oneData.ownValue = oneData.ownValue + ownCount
      if itemType109CountDict[resourceType] then
        oneData.bagValue = oneData.bagValue + itemType109CountDict[resourceType].count
      end
      if itemType3CountDict[resourceId] then
        oneData.bagValue = oneData.bagValue + itemType3CountDict[resourceId].count
      end
      table.insert(self.resourceViewDataList, oneData)
    end
  end
end

local function JudgeResourceIsShow(self, resourceType)
  local isShow = true
  for i = 1, table.count(self.needCheckShowConditionType) do
    if self.needCheckShowConditionType[i] == resourceType then
      if resourceType == ResourceType.FLINT or resourceType == ResourceType.OBSIDIAN then
        local inSeason = SeasonUtil.IsInSeason()
        if not inSeason then
          isShow = false
          break
        end
      elseif ResourceType2FuncUnlockID[resourceType] then
        isShow = DataCenter.LWFunctionUnlockManager:CheckCanShow(ResourceType2FuncUnlockID[resourceType])
        if ResourceType.Petroleum == resourceType and LuaEntry.Resource:GetCntByResType(resourceType) > 0 then
          isShow = true
        end
        break
      end
    end
  end
  return isShow
end

local function GetSpeedUpViewData(self)
  self.resourceViewDataList = {}
  local itemCountDict = {}
  local itemList = DataCenter.ItemData:GetItemsByType(GOODS_TYPE.GOODS_TYPE_2)
  for j = 1, table.count(itemList) do
    local itemInfo = itemList[j]
    local itemTemplate = itemInfo.goods
    local giveCount = tonumber(itemTemplate.para3) * itemInfo.count or 0
    if itemCountDict[itemTemplate.type2] == nil then
      itemCountDict[itemTemplate.type2] = {
        para1 = tonumber(itemTemplate.serverPara1),
        count = 0
      }
    end
    itemCountDict[itemTemplate.type2].count = itemCountDict[itemTemplate.type2].count + giveCount
  end
  for i = 1, table.count(self.speedUpTypeShowConfig) do
    local configData = self.speedUpTypeShowConfig[i]
    local oneData = OneViewData.New()
    oneData.tabType = BagResourceOverviewTabType.SpeedUp
    oneData.itemId = configData.speedUpType
    if itemCountDict[configData.speedUpType] and itemCountDict[configData.speedUpType].para1 == configData.param then
      oneData.ownValue = itemCountDict[configData.speedUpType].count
    end
    table.insert(self.resourceViewDataList, oneData)
  end
end

local function GetOtherViewData(self)
  self.resourceViewDataList = {}
  local itemType3CountDict = {}
  local itemType3List = DataCenter.ItemData:GetItemsByType(GOODS_TYPE.GOODS_TYPE_3)
  for j = 1, table.count(itemType3List) do
    local itemInfo = itemType3List[j]
    local itemTemplate = itemInfo.goods
    local id = tonumber(itemTemplate.para1)
    local giveCount = tonumber(itemTemplate.para2) * itemInfo.count or 0
    if itemType3CountDict[id] == nil then
      itemType3CountDict[id] = {count = 0}
    end
    itemType3CountDict[id].count = itemType3CountDict[id].count + giveCount
  end
  for m = 1, table.count(self.otherTypeShowConfig) do
    local itemId = self.otherTypeShowConfig[m]
    local oneData = OneViewData.New()
    oneData.tabType = BagResourceOverviewTabType.Other
    oneData.itemId = itemId
    if itemId == BagResOverViewOtherType.HeroExp then
      oneData.ownValue = DataCenter.ResourceItemDataManager:GetHeroExpCount()
      local itemList = DataCenter.ItemData:GetItemsByType(GOODS_TYPE.GOODS_TYPE_109)
      local itemCount = table.count(itemList)
      for i = 1, itemCount do
        local itemInfo = itemList[i]
        local itemTemplate = itemInfo.goods
        local returnItem = DataCenter.AdaptiveBoxTemplateManager:GetReturnItem(tonumber(itemTemplate.para1), DataCenter.BuildManager.MainLv, tonumber(itemTemplate.para2))
        if returnItem ~= nil and returnItem.id == ResourceItemId.HeroExp then
          local giveCount = returnItem.count * tonumber(itemTemplate.para3) * itemInfo.count or 0
          oneData.bagValue = oneData.bagValue + giveCount
        end
      end
      table.insert(self.resourceViewDataList, oneData)
    elseif itemId == BagResOverViewOtherType.Gold then
      oneData.ownValue = LuaEntry.Player.gold
      if itemType3CountDict[itemId] then
        oneData.bagValue = oneData.bagValue + itemType3CountDict[itemId].count
      end
      table.insert(self.resourceViewDataList, oneData)
    elseif itemId == BagResOverViewOtherType.Stamina then
      oneData.ownValue = LuaEntry.Player:GetCurStamina()
      if itemType3CountDict[itemId] then
        oneData.bagValue = oneData.bagValue + itemType3CountDict[itemId].count
      end
      table.insert(self.resourceViewDataList, oneData)
    end
  end
end

local function SetToggleState(self)
  local showType = self.ctrl:GetSpeedUpTimeShowType()
  self.dailyToggle:SetIsOn(showType == BagResourceOverviewShowTimeType.Day)
  self.hourToggle:SetIsOn(showType == BagResourceOverviewShowTimeType.Hour)
  self.minuteToggle:SetIsOn(showType == BagResourceOverviewShowTimeType.Minute)
end

local function OnSelectToggle(self, selectToggleType)
  self.ctrl:SetSpeedUpTimeShowType(selectToggleType)
  EventManager:GetInstance():Broadcast(EventId.SelectBagResourceOverviewTimeToggle)
end

LWUIBagResourceOverviewView.OnCreate = OnCreate
LWUIBagResourceOverviewView.OnDestroy = OnDestroy
LWUIBagResourceOverviewView.OnEnable = OnEnable
LWUIBagResourceOverviewView.OnDisable = OnDisable
LWUIBagResourceOverviewView.ComponentDefine = ComponentDefine
LWUIBagResourceOverviewView.ComponentDestroy = ComponentDestroy
LWUIBagResourceOverviewView.DataDefine = DataDefine
LWUIBagResourceOverviewView.DataDestroy = DataDestroy
LWUIBagResourceOverviewView.OnAddListener = OnAddListener
LWUIBagResourceOverviewView.OnRemoveListener = OnRemoveListener
LWUIBagResourceOverviewView.OnUpdateResourceView = OnUpdateResourceView
LWUIBagResourceOverviewView.InitData = InitData
LWUIBagResourceOverviewView.ShowTabView = ShowTabView
LWUIBagResourceOverviewView.OnTabItemMoveIn = OnTabItemMoveIn
LWUIBagResourceOverviewView.OnTabItemMoveOut = OnTabItemMoveOut
LWUIBagResourceOverviewView.RemoveTabScroll = RemoveTabScroll
LWUIBagResourceOverviewView.OnTabItemClick = OnTabItemClick
LWUIBagResourceOverviewView.ShowCurTabView = ShowCurTabView
LWUIBagResourceOverviewView.SetDesView = SetDesView
LWUIBagResourceOverviewView.OnResourceItemMoveIn = OnResourceItemMoveIn
LWUIBagResourceOverviewView.OnResourceItemMoveOut = OnResourceItemMoveOut
LWUIBagResourceOverviewView.RemoveResourceScroll = RemoveResourceScroll
LWUIBagResourceOverviewView.GetResourceViewData = GetResourceViewData
LWUIBagResourceOverviewView.JudgeResourceIsShow = JudgeResourceIsShow
LWUIBagResourceOverviewView.GetSpeedUpViewData = GetSpeedUpViewData
LWUIBagResourceOverviewView.GetOtherViewData = GetOtherViewData
LWUIBagResourceOverviewView.SetToggleState = SetToggleState
LWUIBagResourceOverviewView.OnSelectToggle = OnSelectToggle
LWUIBagResourceOverviewView.InfoBtnClick = InfoBtnClick
return LWUIBagResourceOverviewView
