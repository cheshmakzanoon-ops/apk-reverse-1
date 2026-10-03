local base = UIBaseView
local CommonAdventureShopPanel = BaseClass("CommonAdventureShopPanel", base)
local Localization = CS.GameEntry.Localization
local CommonGoodsShopItem = require("UI.UICommonShop.Component.CommonShopGoods.CommonGoodsShopItem")
local svGoods_path = "Anim/ScrollView"
local content_path = "Anim/ScrollView/Content"
local anim_path = "Anim"
local refreshTip_path = "Anim/Top/refreshTip"
local refreshCd_path = "Anim/Top/refreshTip/refreshCd"
local itemCount_path = "Anim/Top/itemCount"
local itemIcon_path = "Anim/Top/itemIcon"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DelRefreshCdTimer()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.svGoodsN = self:AddComponent(UIScrollRect, svGoods_path)
  self.contentN = self:AddComponent(GridInfinityScrollView, content_path)
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.contentN:Init(bindFunc1, bindFunc2, bindFunc3)
  self.animN = self:AddComponent(UIAnimator, anim_path)
  self.refreshTipN = self:AddComponent(UIText, refreshTip_path)
  self.refreshTipN:SetText("")
  self.refreshCdN = self:AddComponent(UIText, refreshCd_path)
  self.itemCountN = self:AddComponent(UIText, itemCount_path)
  self.itemIconN = self:AddComponent(UIImage, itemIcon_path)
end

local function ComponentDestroy(self)
  self:ClearItemCell()
  self.contentN = nil
  self.animN = nil
  self.refreshTipN = nil
  self.refreshCdN = nil
  self.itemCountN = nil
  self.itemIconN = nil
end

local function DataDefine(self)
  self.curShowType = nil
  self.goodsList = {}
  self.goodsItemsList = {}
  self.model = {}
  self.listGO = {}
end

local function DataDestroy(self)
  self.curShowType = nil
  self.goodsList = nil
  self.goodsItemsList = nil
  self.model = nil
  self.listGO = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateOneCommonShop, self.RefreshAll)
  self:AddUIListener(EventId.UpdateGold, self.RefreshAll)
  self:AddUIListener(EventId.RefreshItems, self.RefreshAll)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateOneCommonShop, self.RefreshAll)
  self:RemoveUIListener(EventId.UpdateGold, self.RefreshAll)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshAll)
  base.OnRemoveListener(self)
end

local function ShowPanel(self, shopType)
  self.curShowType = shopType
  self:RefreshAll()
end

local function RefreshAll(self, shopType)
  if shopType and shopType ~= self.curShowType then
    return
  end
  local nextWeek = UITimeManager:GetInstance():GetNextWeekDay(1)
  self.refreshCdEndT = nextWeek
  self:AddRefreshCdTimer()
  self:SetRefreshCd()
  self.goodsList = DataCenter.CommonShopManager:GetGoodsListByShopType(self.curShowType)
  self.contentN:SetItemCount(#self.goodsList)
  if not table.IsNullOrEmpty(self.goodsList) then
    local itemId = self.goodsList[1].currencyId
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
    local itemData = DataCenter.ItemData:GetItemById(itemId)
    local itemCount = itemData and itemData.count or 0
    self.itemCountN:SetText(Localization:GetString(itemTemplate.name) .. ": " .. itemCount)
    self.itemIconN:LoadSprite(string.format(LoadPath.ItemPath, itemTemplate.icon))
  end
end

local function OnInitScroll(self, go, index)
  local item = self.svGoodsN:AddComponent(CommonGoodsShopItem, go)
  self.listGO[go] = item
end

local function OnUpdateScroll(self, go, index)
  local conf = self.goodsList[index + 1]
  go.name = conf.id
  local cellItem = self.listGO[go]
  if not cellItem then
    return
  end
  cellItem:SetItem(self.goodsList[index + 1])
end

local function OnDestroyScrollItem(self, go, index)
end

local function ClearItemCell(self)
  self.svGoodsN:RemoveComponents(CommonGoodsShopItem)
  self.contentN:DestroyChildNode()
end

local function RefreshList(self)
  self:SetAllCellDestroy()
  local list = self.goodsList
  if list ~= nil then
    self.modelCount = 0
    for i = 1, table.length(list) do
      self.modelCount = self.modelCount + 1
      self.model[self.modelCount] = self:GameObjectInstantiateAsync(UIAssets.CommonGoodsShopItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.contentN.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = self.contentN:AddComponent(CommonGoodsShopItem, nameStr)
        cell:SetItem(list[i])
      end)
    end
  end
end

local function SetAllCellDestroy(self)
  self.contentN:RemoveComponents(CommonGoodsShopItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.svGoodsN:AddComponent(CommonGoodsShopItem, itemObj)
  cellItem:SetItem(self.goodsList[index])
end

local function OnItemMoveOut(self, itemObj, index)
  self.svGoodsN:RemoveComponent(itemObj.name, CommonGoodsShopItem)
end

local function AddRefreshCdTimer(self)
  function self.RefreshCdTimerAction()
    self:SetRefreshCd()
  end
  
  if self.refreshCdTimer == nil then
    self.refreshCdTimer = TimerManager:GetInstance():GetTimer(1, self.RefreshCdTimerAction, self, false, false, false)
  end
  self.refreshCdTimer:Start()
end

local function SetRefreshCd(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = math.ceil(self.refreshCdEndT - curTime)
  if 0 < remainTime then
    self.refreshCdN:SetText(Localization:GetString("104209", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)))
  else
    self.refreshCdN:SetText("")
    self:DelRefreshCdTimer()
    SFSNetwork.SendMessage(MsgDefines.GetCommonShopInfo, self.curShowType)
  end
end

local function DelRefreshCdTimer(self)
  if self.refreshCdTimer ~= nil then
    self.refreshCdTimer:Stop()
    self.refreshCdTimer = nil
  end
end

CommonAdventureShopPanel.OnCreate = OnCreate
CommonAdventureShopPanel.OnDestroy = OnDestroy
CommonAdventureShopPanel.OnAddListener = OnAddListener
CommonAdventureShopPanel.OnRemoveListener = OnRemoveListener
CommonAdventureShopPanel.ComponentDefine = ComponentDefine
CommonAdventureShopPanel.ComponentDestroy = ComponentDestroy
CommonAdventureShopPanel.DataDefine = DataDefine
CommonAdventureShopPanel.DataDestroy = DataDestroy
CommonAdventureShopPanel.ShowPanel = ShowPanel
CommonAdventureShopPanel.RefreshAll = RefreshAll
CommonAdventureShopPanel.OnInitScroll = OnInitScroll
CommonAdventureShopPanel.OnUpdateScroll = OnUpdateScroll
CommonAdventureShopPanel.OnDestroyScrollItem = OnDestroyScrollItem
CommonAdventureShopPanel.ClearItemCell = ClearItemCell
CommonAdventureShopPanel.OnItemMoveIn = OnItemMoveIn
CommonAdventureShopPanel.OnItemMoveOut = OnItemMoveOut
CommonAdventureShopPanel.AddRefreshCdTimer = AddRefreshCdTimer
CommonAdventureShopPanel.SetRefreshCd = SetRefreshCd
CommonAdventureShopPanel.DelRefreshCdTimer = DelRefreshCdTimer
CommonAdventureShopPanel.RefreshList = RefreshList
CommonAdventureShopPanel.SetAllCellDestroy = SetAllCellDestroy
return CommonAdventureShopPanel
