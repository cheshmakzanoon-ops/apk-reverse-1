local CommonDecorationShopPanel = BaseClass("CommonDecorationShopPanel", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local CommonDecorationShopTitleItem = require("UI.UICommonShop.Component.CommonShopDecoration.CommonDecorationShopTitleItem")
local CommonDecorationRowShopItem = require("UI.UICommonShop.Component.CommonShopDecoration.CommonDecorationRowShopItem")
local ItemType = {Title = 1, GoodsItem = 2}

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ClearItemCell()
  self:ClearScroll()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  DataCenter.CommonShopManager:UpdateDecorationShopItemNew(self.curShopType)
  DataCenter.CommonShopManager:UpdateRed(CommonShopType.DecorationShop)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.scroll = self:AddComponent(UILoopListView2, "ScrollView")
  self.scroll:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, "ScrollView/Content")
end

local function ComponentDestroy(self)
  self.scroll = nil
  self.content = nil
end

local function DataDefine(self)
  self.curShopType = nil
  self.goodsInfo = {}
  self.listGO = {}
  self.shopInfo = {}
  self.itemIndex = 0
  self.viewScrollData = {}
  self.itemShowStatus = {}
end

local function DataDestroy(self)
  self.curShopType = nil
  self.goodsInfo = nil
  self.listGO = nil
  self.shopInfo = nil
  self.itemIndex = nil
  self.viewScrollData = nil
  self.itemShowStatus = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateOneCommonShop, self.RefreshAll)
  self:AddUIListener(EventId.RefreshItems, self.RefreshAll)
  self:AddUIListener(EventId.OnDecorationShopClickRowItem, self.OnItemBtnClick)
  self:AddUIListener(EventId.UpdateOneCommonShopGoods, self.RefreshAll)
  self:AddUIListener(EventId.OnDecorationShopInfoChange, self.RefreshAll)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateOneCommonShop, self.RefreshAll)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshAll)
  self:RemoveUIListener(EventId.OnDecorationShopClickRowItem, self.OnItemBtnClick)
  self:RemoveUIListener(EventId.UpdateOneCommonShopGoods, self.RefreshAll)
  self:RemoveUIListener(EventId.OnDecorationShopInfoChange, self.RefreshAll)
  base.OnRemoveListener(self)
end

local function ClearScroll(self)
  self.content:RemoveComponents(CommonDecorationShopTitleItem)
  self.content:RemoveComponents(CommonDecorationRowShopItem)
  self.scroll:ClearAllItems()
end

local function ShowPanel(self, shopType)
  self.curShopType = shopType
  self:RefreshAll()
end

local function RefreshAll(self)
  self:SetGoodsInfo()
  self.shopInfo = DataCenter.CommonShopManager:GetDecorationShopInfo(self.curShopType)
  if not self.shopInfo then
    return
  end
  local itemId = self.shopInfo.cost_item
  self.spe_res_num:SetText(DataCenter.ItemData:GetItemCount(itemId))
  self:RefreshScroll()
end

local function OnItemBtnClick(self, subType)
  self.itemShowStatus[subType] = not self.itemShowStatus[subType]
  self:RefreshScroll()
end

local function RefreshViewScrollData(self)
  local subTypeNum = 0
  for k, v in pairs(self.goodsInfo) do
    if v and v.rowShowType == ItemType.Title then
      subTypeNum = subTypeNum + 1
    end
  end
  self.viewScrollData = {}
  for k, v in pairs(self.goodsInfo) do
    if v and v.rowShowType == ItemType.Title and 1 < subTypeNum then
      table.insert(self.viewScrollData, v)
    end
    if v and v.rowShowType == ItemType.GoodsItem and self.itemShowStatus[v.subType] then
      table.insert(self.viewScrollData, v)
    end
  end
end

local function RefreshScroll(self)
  self:RefreshViewScrollData()
  if #self.viewScrollData == 0 then
    self.scroll:SetActive(false)
  else
    self.scroll:SetActive(true)
    self.scroll:SetListItemCount(#self.viewScrollData, false, false)
    self.scroll:RefreshAllShownItem()
  end
end

local function IsGoodsItemUnlock(self, goodsConf)
  local itemId = goodsConf.itemId
  local items = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  local skinId = tonumber(items.para1)
  local skinData = DataCenter.DecorationDataManager:GetSkinDataById(skinId)
  return skinData and skinData.expireTime == 0
end

local function IsGoodsItemHaveItem(self, goodsConf)
  local itemId = goodsConf.itemId
  local items = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  local skinId = tonumber(items.para1)
  local template = DataCenter.DecorationTemplateManager:GetTemplate(skinId)
  local gain = template.gainMethod
  local isHave = false
  for k, v in pairs(gain) do
    local itemData = DataCenter.ItemTemplateManager:GetItemTemplate(v.id)
    if itemData and tonumber(itemData.para2) == 0 and 0 < DataCenter.ItemData:GetItemCount(v.id) then
      isHave = true
      break
    end
  end
end

local function IsGoodsItemSoldOut(self, goodsConf)
  local goodsInfo = DataCenter.CommonShopManager:GetGoodsInfoById(CommonShopType.DecorationShop, goodsConf.id)
  local boughtTimes = goodsInfo and goodsInfo.boughtTimes or 0
  return boughtTimes >= goodsConf.maxTimes
end

local function GetGoodsState(self, goodsConf)
  local state = DecorationShoGoodsState.None
  if self:IsGoodsItemSoldOut(goodsConf) then
    state = DecorationShoGoodsState.SoldOut
  elseif self:IsGoodsItemUnlock(goodsConf) then
    state = DecorationShoGoodsState.isUnlock
  elseif self:IsGoodsItemHaveItem(goodsConf) then
    state = DecorationShoGoodsState.isHave
  else
    state = DecorationShoGoodsState.Sale
  end
  return state
end

local function SetGoodsInfo(self)
  local shopInfo = DataCenter.CommonShopManager:GetGoodsListByShopType(self.curShopType)
  local grouped = {}
  for _, item in ipairs(shopInfo) do
    if not grouped[item.subType] then
      grouped[item.subType] = {}
    end
    item.rowShowType = ItemType.GoodsItem
    item.state = self:GetGoodsState(item)
    table.insert(grouped[item.subType], item)
  end
  local subTypeList = {}
  for subType, itemInfoList in pairs(grouped) do
    table.sort(itemInfoList, function(a, b)
      if a.state == b.state then
        return a.order > b.order
      end
      return a.state < b.state
    end)
    table.insert(subTypeList, subType)
    self.itemShowStatus[subType] = true
  end
  table.sort(subTypeList, function(a, b)
    return b < a
  end)
  local result = {}
  
  local function splitTable(tbl, size)
    local splitResult, subGroup = {}, {}
    for i, item in ipairs(tbl) do
      table.insert(subGroup, item)
      if size <= #subGroup or i == #tbl then
        table.insert(splitResult, subGroup)
        subGroup = {}
      end
    end
    return splitResult
  end
  
  for _, subType in ipairs(subTypeList) do
    table.insert(result, {
      rowShowType = ItemType.Title,
      subType = subType
    })
    local infoList = splitTable(grouped[subType], 3)
    for k, v in pairs(infoList) do
      table.insert(result, {
        subType = subType,
        rowShowType = ItemType.GoodsItem,
        goodsInfo = v
      })
    end
  end
  self.goodsInfo = result
end

local function ClearItemCell(self)
end

local function SetNodeList(self, refresh_time_root, refresh_time_title, refresh_time_txt, spe_res_num)
  self.spe_res_num = spe_res_num
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.viewScrollData then
    return nil
  end
  local rowInfo = self.viewScrollData[index]
  local item, script
  if not rowInfo then
    return nil
  end
  if rowInfo.rowShowType == ItemType.Title then
    item = loopScroll:NewListViewItem("CommonDecorationShopTitleItem")
    script = self.content:GetComponent(item.gameObject.name, CommonDecorationShopTitleItem)
    if script == nil then
      local objectName = tostring(self.itemIndex)
      self.itemIndex = self.itemIndex + 1
      item.gameObject.name = objectName
      script = self.content:AddComponent(CommonDecorationShopTitleItem, objectName)
    end
    script:SetActive(true)
    local subType = rowInfo and rowInfo.subType
    local showDetail = self.itemShowStatus[subType]
    script:SetData(rowInfo, showDetail, self.curShopType)
  elseif rowInfo.rowShowType == ItemType.GoodsItem then
    item = loopScroll:NewListViewItem("CommonDecorationRowShopItem")
    script = self.content:GetComponent(item.gameObject.name, CommonDecorationRowShopItem)
    if script == nil then
      local objectName = tostring(self.itemIndex)
      self.itemIndex = self.itemIndex + 1
      item.gameObject.name = objectName
      script = self.content:AddComponent(CommonDecorationRowShopItem, objectName)
    end
    script:SetActive(true)
    script:SetData(rowInfo.goodsInfo, self.curShopType)
  end
  return item
end

CommonDecorationShopPanel.OnCreate = OnCreate
CommonDecorationShopPanel.OnDestroy = OnDestroy
CommonDecorationShopPanel.OnEnable = OnEnable
CommonDecorationShopPanel.OnDisable = OnDisable
CommonDecorationShopPanel.ComponentDefine = ComponentDefine
CommonDecorationShopPanel.ComponentDestroy = ComponentDestroy
CommonDecorationShopPanel.DataDefine = DataDefine
CommonDecorationShopPanel.DataDestroy = DataDestroy
CommonDecorationShopPanel.OnAddListener = OnAddListener
CommonDecorationShopPanel.OnRemoveListener = OnRemoveListener
CommonDecorationShopPanel.ShowPanel = ShowPanel
CommonDecorationShopPanel.RefreshAll = RefreshAll
CommonDecorationShopPanel.ClearItemCell = ClearItemCell
CommonDecorationShopPanel.SetNodeList = SetNodeList
CommonDecorationShopPanel.SetGoodsInfo = SetGoodsInfo
CommonDecorationShopPanel.OnGetItemByIndex = OnGetItemByIndex
CommonDecorationShopPanel.RefreshScroll = RefreshScroll
CommonDecorationShopPanel.RefreshViewScrollData = RefreshViewScrollData
CommonDecorationShopPanel.OnItemBtnClick = OnItemBtnClick
CommonDecorationShopPanel.ClearScroll = ClearScroll
CommonDecorationShopPanel.IsGoodsItemUnlock = IsGoodsItemUnlock
CommonDecorationShopPanel.IsGoodsItemHaveItem = IsGoodsItemHaveItem
CommonDecorationShopPanel.IsGoodsItemSoldOut = IsGoodsItemSoldOut
CommonDecorationShopPanel.GetGoodsState = GetGoodsState
return CommonDecorationShopPanel
