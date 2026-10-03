local RebateShopContent = BaseClass("RebateShopContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIItem = require("UI.UIActivityCenterTable.Component.Rebate.RebateShopContentItem")

function RebateShopContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function RebateShopContent:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function RebateShopContent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateOneCommonShopGoods, self.RefreshView)
end

function RebateShopContent:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateOneCommonShopGoods, self.RefreshView)
  base.OnRemoveListener(self)
end

function RebateShopContent:ComponentDefine()
  self.haveCardTxt = self:AddComponent(UIText, "haveCardContent/haveCardTxt")
  self.haveCardTxt:SetLocalText(2000548)
  self.haveCardNum = self:AddComponent(UIText, "haveCardContent/haveCardNum")
  self.tipTxt = self:AddComponent(UIText, "tipTxt")
  self.tipTxt:SetText("")
  self.costImage = self:AddComponent(UIImage, "haveCardContent/costImage")
  self.ScrollView = self:AddComponent(UIScrollView, "ScrollView")
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnCellMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnCellMoveOut(itemObj, index)
  end)
end

function RebateShopContent:ComponentDestroy()
  self.haveCardTxt = nil
  self.haveCardNum = nil
  self.tipTxt = nil
  self.costImage = nil
  self.ScrollView = nil
end

function RebateShopContent:DataDefine()
end

function RebateShopContent:DataDestroy()
end

function RebateShopContent:SetData(activityId)
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

function RebateShopContent:RefreshView()
  if self.activityId == nil then
    return
  end
  if self.activityData == nil then
    return
  end
  local shopId = self.activityData.shopId
  local shopData = DataCenter.CommonShopManager:GetGoodsListByShopType(shopId)
  if #shopData == 0 then
    return
  end
  self.shopData = shopData
  local goodsId = self.activityData.costGoodsId
  local curNum = DataCenter.ItemData:GetItemCount(goodsId)
  self.haveCardNum:SetText(curNum)
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(goodsId)
  self.costImage:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
  self:ClearScroll()
  self.ScrollView:SetTotalCount(#self.shopData)
  self.ScrollView:RefillCells()
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function RebateShopContent:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(UIItem)
end

function RebateShopContent:OnCellMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(UIItem, itemObj)
  cellItem:SetData(self.shopData[index])
end

function RebateShopContent:OnCellMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, UIItem)
end

return RebateShopContent
