local ActivityRebateNewShopComponent = BaseClass("ActivityRebateNewShopComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIItem = require("UI.UIActivityCenterTable.Component.ActivityRebateNew.ActivityRebateNewShopItemComponent")

function ActivityRebateNewShopComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ActivityRebateNewShopComponent:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function ActivityRebateNewShopComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateOneCommonShopGoods, self.RefreshView)
end

function ActivityRebateNewShopComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateOneCommonShopGoods, self.RefreshView)
  base.OnRemoveListener(self)
end

function ActivityRebateNewShopComponent:ComponentDefine()
  self.textHaveCardTxt = self:AddComponent(UIText, "haveCardContent/haveCardTxt")
  self.textHaveCardTxt:SetLocalText("total_mobilization_desc5")
  self.imgCostImage = self:AddComponent(UIImage, "haveCardContent/costImage")
  self.textHaveCardNum = self:AddComponent(UIText, "haveCardContent/haveCardNum")
  self.toggle = self:AddComponent(UIToggle, "haveCardContent/Toggle")
  self.toggle:SetIsOn(DataCenter.ActivityRebateNewManager:IsShopRedOn())
  self.toggle:SetOnValueChanged(function(tf)
    DataCenter.ActivityRebateNewManager:SetShopRedOn(tf)
  end)
  self.compRebateExchangeItem = self:AddComponent(UIBaseContainer, "RebateExchangeItem")
  self.compRebateExchangeItem:SetActive(false)
  self.compContent = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content")
  self.compScrollView = self:AddComponent(UIScrollView, "ScrollView")
  self.compScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnCellMoveIn(itemObj, index)
  end)
  self.compScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnCellMoveOut(itemObj, index)
  end)
  self.shopItems = {}
  self.textHaveCardTxt:SetActive(false)
  self.toggle:SetActive(false)
end

function ActivityRebateNewShopComponent:ComponentDestroy()
  self.textHaveCardTxt = nil
  self.imgCostImage = nil
  self.textHaveCardNum = nil
  self.toggle = nil
  self.compRebateExchangeItem = nil
  self.compContent = nil
  self.compScrollView = nil
  self.shopItems = nil
end

function ActivityRebateNewShopComponent:DataDefine()
end

function ActivityRebateNewShopComponent:DataDestroy()
end

function ActivityRebateNewShopComponent:SetData(activityId)
  self.activityId = activityId
  if self.activityId == nil then
    return
  end
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityData == nil then
    return
  end
  self:RefreshView()
end

function ActivityRebateNewShopComponent:RefreshView()
  if self.activityId == nil then
    return
  end
  if self.activityData == nil then
    return
  end
  local shopData = DataCenter.ActivityRebateNewManager:GetShopData(self.activityId)
  local showShop = not table.IsNullOrEmpty(shopData)
  if not showShop then
    return
  end
  self.shopData = shopData
  local goodsId = DataCenter.ActivityRebateNewManager:GetShopGoodsId(self.activityId)
  local curNum = DataCenter.ItemData:GetItemCount(goodsId)
  self.textHaveCardNum:SetText(curNum)
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(goodsId)
  if goods ~= nil then
    self.imgCostImage:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
  end
  if table.IsNullOrEmpty(self.shopItems) then
    self:ClearScroll()
    self.compScrollView:SetTotalCount(#self.shopData)
    self.compScrollView:RefillCells()
  else
    for i, v in pairs(self.shopData) do
      if self.shopItems[i] ~= nil then
        self.shopItems[i]:SetData(self.shopData[i], self.activityId)
      end
    end
  end
end

function ActivityRebateNewShopComponent:ClearScroll()
  self.compScrollView:ClearCells()
  self.compScrollView:RemoveComponents(UIItem)
  self.shopItems = nil
end

function ActivityRebateNewShopComponent:OnCellMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.compScrollView:AddComponent(UIItem, itemObj)
  if self.shopData ~= nil and self.shopData[index] ~= nil then
    cellItem:SetData(self.shopData[index], self.activityId)
    if self.shopItems == nil then
      self.shopItems = {}
    end
    self.shopItems[index] = cellItem
  end
end

function ActivityRebateNewShopComponent:OnCellMoveOut(itemObj, index)
  self.compScrollView:RemoveComponent(itemObj.name, UIItem)
  if self.shopItems ~= nil then
    self.shopItems[index] = nil
  end
end

return ActivityRebateNewShopComponent
