local base = UIBaseContainer
local LWRefundRepayContentItem = BaseClass("LWRefundRepayContentItem", UIBaseContainer)
local M = LWRefundRepayContentItem
local Localization = CS.GameEntry.Localization
local LWRefundPunishRepayItem = require("UI.LWUIRefundPunish.Component.LWRefundPunishRepayItem")

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function M:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.loopGridViewScrollView = self:AddComponent(UILoopGridView, "ScrollView")
  self.compContent = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content")
  self.loopGridViewScrollView:InitGridView(0, function(loopScroll, index, item)
    return self:OnGetItemByRowColumn(loopScroll, index)
  end)
  self.emptyText = self:AddComponent(UITextMeshProUGUIEx, "EmptyText")
end

function M:ComponentDestroy()
  if self.loopGridViewScrollView then
    self.loopGridViewScrollView:ClearAllItems()
  end
  self.loopGridViewScrollView = nil
  self.compContent = nil
  self.emptyText = nil
end

function M:DataDefine()
  self.packageList = {}
end

function M:DataDestroy()
  self.packageList = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGiftPackData, self.RefreshPackageList)
end

function M:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.RefreshPackageList)
  base.OnRemoveListener(self)
end

function M:OnEnable()
  base.OnEnable(self)
  self:InitPackScroll()
end

function M:ReInit()
  self.emptyText:SetLocalText("refund_toast_pc_repay")
  self.emptyText:SetActive(false)
end

function M:RefreshPackageList()
  if Config.IsPC() then
    self:InitPcScroll()
  else
    self:InitPackScroll()
  end
end

function M:InitPackScroll()
  if Config.IsPC() then
    return
  end
  self.emptyText:SetActive(false)
  self.packageList = {}
  local package = DataCenter.LWRefundPunishManager:GetGoldBrickPackage()
  for k, v in pairs(package) do
    local id = v.id
    local packageData = GiftPackageData.get(tostring(id))
    table.insert(self.packageList, packageData)
  end
  table.sort(self.packageList, function(a, b)
    return tonumber(a:getPrice()) > tonumber(b:getPrice())
  end)
  local count = table.count(self.packageList)
  if not count or count == 0 then
    return
  end
  self.loopGridViewScrollView:SetListItemCount(count)
  self.loopGridViewScrollView:RefreshAllShownItem()
end

function M:OnGetItemByRowColumn(loopScroll, index)
  if self.packageList ~= nil then
    local count = #self.packageList
    index = index + 1
    if index < 1 or count < index then
      return nil
    end
    local item = loopScroll:NewListViewItem("LWRefundPunishRepayItem")
    local script = self.compContent:GetComponent(item.gameObject.name, LWRefundPunishRepayItem)
    if script == nil then
      NameCount = NameCount + 1
      local nameStr = "payItem" .. NameCount
      item.gameObject.name = nameStr
      script = self.compContent:AddComponent(LWRefundPunishRepayItem, nameStr)
    end
    script:SetActive(true)
    local packageData = self.packageList[index]
    local IsPC = Config.IsPC()
    script:ReInit(index, packageData, IsPC)
    return item
  end
end

function M:OnRecGoldBrickShopData()
  self:InitPcScroll()
end

function M:InitPcScroll()
  if not Config.IsPC() then
    return
  end
  self.packageList = {}
  local pcPackageList = WelfareController.GetGoldBrickList()
  self.emptyText:SetActive(not pcPackageList or #pcPackageList == 0)
  if not pcPackageList or #pcPackageList == 0 then
    return
  end
  for _, v in pairs(pcPackageList) do
    local goodsId = v.goods_id
    local goldBrickInfo = DataCenter.LWRefundPunishManager:GetGoldBrickDataByGoods(goodsId)
    if goldBrickInfo then
      local exchangeInfo = GiftPackageData.get(tostring(goldBrickInfo.id))
      if exchangeInfo then
        local package = {}
        package.amount = v.amount
        package.currency_symbol = v.currency_symbol
        package.goods_id = v.goods_id
        package.exchangeInfo = exchangeInfo
        package.brickNum = goldBrickInfo.brickNum
        table.insert(self.packageList, package)
      else
        Logger.LogError("exchangeInfo is nil for goodsId: " .. goodsId)
      end
    end
  end
  table.sort(self.packageList, function(a, b)
    return tonumber(a.amount) > tonumber(b.amount)
  end)
  local count = table.count(self.packageList)
  if not count or count == 0 then
    return
  end
  self.loopGridViewScrollView:SetListItemCount(count)
  self.loopGridViewScrollView:RefreshAllShownItem()
end

return LWRefundRepayContentItem
