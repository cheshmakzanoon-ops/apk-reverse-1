local base = UIBaseContainer
local UIActDesertTreasureView = BaseClass("UIActDesertTreasureView", base)
local DesertTreasureShopItem = require("UI.LWSeason3.Activity.DesertTreasure.DesertTreasureShopItem")
local Localization = CS.GameEntry.Localization
local talkDes_path = "talkTip/talkDes"
local scrollView_1_path = "ScrollView"
local scrollContent_path = "ScrollView/Viewport/Content"
local titleText_path = "title"
local timtText_path = "TimeContent/TimeText"
local refreshShopTime_path = "refreshShopTime"
local clickCharacter_path = "bg/Image (1)/clickCharacter"
local tipBtn_path = "IntroBtn"
local NameCount = 0

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearCells()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  if self.data then
    self:SetData(self.data.id, self.data)
  end
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.talkDes = self:AddComponent(UIText, talkDes_path)
  self.scrollView_1 = self:AddComponent(UILoopListView2, scrollView_1_path)
  self.scrollContent = self:AddComponent(UIBaseContainer, scrollContent_path)
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.timtText = self:AddComponent(UIText, timtText_path)
  self.refreshShopTime = self:AddComponent(UIText, refreshShopTime_path)
  self.clickCharacter = self:AddComponent(UIButton, clickCharacter_path)
  self.tipBtn = self:AddComponent(UIButton, tipBtn_path)
  self.scrollView_1:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
  self.clickCharacter:SetOnClick(function()
    self:ClickCharacter()
  end)
  self.tipBtn:SetOnClick(function()
    self:ClickTip()
  end)
  NameCount = 0
  self.cells = {}
end

local function ComponentDestroy(self)
  self.talkDes = nil
  self.scrollView_1 = nil
  self.scrollContent = nil
  self.titleText = nil
  self.timtText = nil
  self.refreshShopTime = nil
  self.clickCharacter = nil
  self.tipBtn = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function UIActDesertTreasureView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.InitDesertShopRecordData, self.OnInitShopRecordData)
  self:AddUIListener(EventId.BuyDesertShopItemSuccess, self.OnBuyShopItem)
end

function UIActDesertTreasureView:OnRemoveListener()
  self:RemoveUIListener(EventId.InitDesertShopRecordData, self.OnInitShopRecordData)
  self:RemoveUIListener(EventId.BuyDesertShopItemSuccess, self.OnBuyShopItem)
  base.OnRemoveListener(self)
end

function UIActDesertTreasureView:SetData(activityId, activityInfo, openState)
  self.data = activityInfo
  self.shopItemList = nil
  self.curData = nil
  self.activityEndTime = self.data.endTime
  self.shopEndTime = nil
  self.titleText:SetText(Localization:GetString(self.data.activityName))
  if openState == nil then
    local localKey = self.data:GetRandomGroup1()
    if localKey then
      Logger.Log("GetRandomGroup1: " .. localKey)
      self.talkDes:SetLocalText(localKey)
    else
      self.talkDes:SetText("")
    end
  elseif openState == 1 then
    local localKey = self.data:GetRandomGroup2()
    if localKey then
      Logger.Log("GetRandomGroup2: " .. localKey)
      self.talkDes:SetLocalText(localKey)
    else
      self.talkDes:SetText("")
    end
  end
  local dataValid = false
  if self.data:IsInitShopRecord() then
    self.curData = self.data:GetTodayShopData()
    if self.curData == nil then
    else
      local shopList = DataCenter.SeasonDesertShopTemplateManager:GetDataList(self.curData.shopId)
      self.shopItemList = {}
      for i, v in ipairs(shopList) do
        local canBuyCount = v.cycle_times - self.data:GetShopExchangeRecord(v.id)
        local buyTime = self.data:GetShopExchangeBuyTime(v.id)
        if 0 < canBuyCount or buyTime <= 0 or buyTime > self.curData.startTime then
          table.insert(self.shopItemList, v)
        end
      end
      table.sort(self.shopItemList, function(a, b)
        local countA = a.cycle_times - self.data:GetShopExchangeRecord(a.id)
        local countb = b.cycle_times - self.data:GetShopExchangeRecord(b.id)
        if 0 < countA and 0 < countb or countA == 0 and countb == 0 then
          return a.order < b.order
        end
        if countA == 0 then
          return false
        end
        return true
      end)
      self.shopEndTime = self.curData.endTime
      dataValid = true
      local dataCount = #self.shopItemList
      self.scrollView_1:SetListItemCount(dataCount, false, false)
      self.scrollView_1:RefreshAllShownItem()
    end
  else
    SFSNetwork.SendMessage(MsgDefines.SeasonDesertShopExchangeRecord, toInt(activityId))
  end
  self:Update1000MS()
  if not dataValid then
    self.scrollView_1:SetListItemCount(0, false, false)
    self.scrollView_1:RefreshAllShownItem()
    self.refreshShopTime:SetText("")
  end
end

function UIActDesertTreasureView:TryGetScrollItem(listview, index)
  local dataList = self.shopItemList
  index = index + 1
  if index < 1 or dataList == nil or index > #dataList then
    return nil
  end
  local csItem = listview:NewListViewItem("shopItem")
  local item = self.cells[csItem]
  if item == nil then
    NameCount = NameCount + 1
    local nameStr = "Cell" .. tostring(NameCount)
    csItem.gameObject.name = nameStr
    item = self.scrollContent:AddComponent(DesertTreasureShopItem, nameStr)
    self.cells[csItem] = item
  end
  if item ~= nil then
    item:ReInit(index, self.shopItemList[index], self.data)
  end
  return csItem
end

function UIActDesertTreasureView:ClearCells()
  self.scrollContent:RemoveComponents(DesertTreasureShopItem)
  self.scrollView_1:ClearAllItems()
  self.cells = {}
end

function UIActDesertTreasureView:OnInitShopRecordData()
  self:SetData(self.data.id, self.data)
end

function UIActDesertTreasureView:OnBuyShopItem()
  self:SetData(self.data.id, self.data, 1)
end

function UIActDesertTreasureView:Update1000MS()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local activityRemainTime = 0
  if self.activityEndTime then
    activityRemainTime = self.activityEndTime - curTime
    if 0 < activityRemainTime then
      self.timtText:SetText(UITimeManager:GetInstance():SecondToFmtString(activityRemainTime / 1000))
    else
      self.activityEndTime = nil
      self.timtText:SetText("")
    end
  end
  if self.shopEndTime then
    local remainTime = self.shopEndTime - curTime
    if 0 < remainTime and remainTime - activityRemainTime < 0 then
      self.refreshShopTime:SetLocalText("320318", UITimeManager:GetInstance():SecondToFmtString(remainTime / 1000))
    else
      self.shopEndTime = nil
      self.refreshShopTime:SetText("")
      if not self.lock then
        self.lock = true
        self:SetData(self.data.id, self.data)
        self.lock = false
      end
    end
  end
end

function UIActDesertTreasureView:ClickCharacter()
  local localKey = self.data:GetRandomGroup1()
  if localKey then
    Logger.Log("GetRandomGroup1: " .. localKey)
    self.talkDes:SetLocalText(localKey)
  end
end

function UIActDesertTreasureView:ClickTip()
  if self.data ~= nil and self.data.story ~= nil then
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.data.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

UIActDesertTreasureView.OnCreate = OnCreate
UIActDesertTreasureView.OnDestroy = OnDestroy
UIActDesertTreasureView.OnEnable = OnEnable
UIActDesertTreasureView.OnDisable = OnDisable
UIActDesertTreasureView.ComponentDefine = ComponentDefine
UIActDesertTreasureView.ComponentDestroy = ComponentDestroy
UIActDesertTreasureView.DataDefine = DataDefine
UIActDesertTreasureView.DataDestroy = DataDestroy
return UIActDesertTreasureView
