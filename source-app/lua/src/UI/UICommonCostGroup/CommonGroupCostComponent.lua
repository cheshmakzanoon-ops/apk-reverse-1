local base = UIBaseContainer
local CommonGroupCostComponent = BaseClass("CommonGroupCostComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local CommonGroupCostItemComponent = require("UI.UICommonCostGroup.CommonGroupCostItemComponent")
local common_group_cost_item_path = "ItemRoot/CommonGroupCostItem"

function CommonGroupCostComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function CommonGroupCostComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function CommonGroupCostComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compItemRoot = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.compItemRoot:SetActive(false)
  self.costItemObj = self:AddComponent(CommonGroupCostItemComponent, common_group_cost_item_path).gameObject
  self.costItemObj:GameObjectCreatePool()
  self.horLayout = self.gameObject:GetComponent(typeof(CS.BidirectionalHorizontalLayoutGroup))
end

function CommonGroupCostComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compItemRoot = nil
  self:ClearAll()
  self.allCostItemList = nil
end

function CommonGroupCostComponent:DataDefine()
  self.allItemList = {}
  self.dataList = nil
end

function CommonGroupCostComponent:DataDestroy()
  self.allItemList = nil
  self.dataList = nil
end

function CommonGroupCostComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.OnResOrItemUpdate)
  self:AddUIListener(EventId.ResourceUpdated, self.OnResOrItemUpdate)
  self:AddUIListener(EventId.RefreshResourceItem, self.OnResOrItemUpdate)
end

function CommonGroupCostComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshItems, self.OnResOrItemUpdate)
  self:RemoveUIListener(EventId.ResourceUpdated, self.OnResOrItemUpdate)
  self:RemoveUIListener(EventId.RefreshResourceItem, self.OnResOrItemUpdate)
  base.OnRemoveListener(self)
end

function CommonGroupCostComponent:ReInit4Res(resDataList)
  if not resDataList then
    return
  end
  local dataList = {}
  for itemId, costNum in pairs(resDataList) do
    table.insert(dataList, {
      itemId = itemId,
      costNum = costNum,
      type = CommonCostNeedType.Resource
    })
  end
  self:ReInit(dataList)
end

function CommonGroupCostComponent:ReInit4ResItem(resItemDataList)
  if not resItemDataList then
    return
  end
  local dataList = {}
  for itemId, costNum in pairs(resItemDataList) do
    table.insert(dataList, {
      itemId = itemId,
      costNum = costNum,
      type = CommonCostNeedType.ResourceItem
    })
  end
  self:ReInit(dataList)
end

function CommonGroupCostComponent:ReInit4Goods(goodsDataList)
  if not goodsDataList then
    return
  end
  local dataList = {}
  for itemId, costNum in pairs(goodsDataList) do
    table.insert(dataList, {
      itemId = itemId,
      costNum = costNum,
      type = CommonCostNeedType.Goods
    })
  end
  self:ReInit(dataList)
end

function CommonGroupCostComponent:ReInit(dataList, isAdaptiveScale)
  self:ClearAll()
  self.dataList = dataList
  if not dataList or table.count(dataList) <= 0 then
    return
  end
  for _, v in pairs(dataList) do
    local obj = self.costItemObj:GameObjectSpawn(self.transform)
    local name = tostring(NameCount)
    NameCount = NameCount + 1
    obj.transform.name = name
    local costItem = self:AddComponent(CommonGroupCostItemComponent, name)
    table.insert(self.allCostItemList, costItem)
    local itemId = v.itemId
    local costNum = v.costNum
    local type = v.type
    costItem:ReInit(itemId, costNum, type)
    table.insert(self.allItemList, costItem)
  end
  if isAdaptiveScale then
    local adaptiveScale = 2 < #dataList and 0.9 or 1
    self.transform:Set_localScale(adaptiveScale, adaptiveScale, adaptiveScale)
    self.horLayout.spacing = 2 < #dataList and 30 or 50
  else
    self.transform:Set_localScale(1, 1, 1)
    self.horLayout.spacing = 50
  end
end

function CommonGroupCostComponent:ClearAll()
  self.costItemObj:GameObjectRecycleAll()
  self:RemoveComponents(CommonGroupCostItemComponent)
  self.allCostItemList = {}
  self.allItemList = {}
end

function CommonGroupCostComponent:OnResOrItemUpdate()
  if not self.allItemList then
    return
  end
  for _, v in ipairs(self.allItemList) do
    v:RefreshCost()
  end
end

function CommonGroupCostComponent:CheckIsLackRes(isPopLackView)
  if not self.dataList then
    return false
  end
  for _, v in ipairs(self.dataList) do
    local type = v.type or 0
    local itemId = v.itemId or 0
    local costNum = v.costNum or 0
    local have = 0
    if type == CommonCostNeedType.ResourceItem then
      have = DataCenter.ResourceItemDataManager:GetCountByItemId(itemId)
    elseif type == CommonCostNeedType.Goods then
      have = DataCenter.ItemData:GetItemCount(itemId)
    elseif type == CommonCostNeedType.Resource then
      have = LuaEntry.Resource:GetCntByResType(itemId)
    end
    if costNum > have then
      if not isPopLackView then
        return true
      end
      local needCount = costNum
      if type == CommonCostNeedType.ResourceItem then
        LWResourceLackUtil:GotoResourceItemLack(itemId, needCount)
        return true
      elseif type == CommonCostNeedType.Goods then
        LWResourceLackUtil:GotoGoodsItemLack(itemId, needCount)
        return true
      elseif type == CommonCostNeedType.Resource then
        local data = {}
        table.insert(data, {resType = itemId, need = needCount})
        LWResourceLackUtil:GotoResLack(data)
        return true
      end
    end
  end
  return false
end

return CommonGroupCostComponent
