local base = UIBaseContainer
local LWUICommonExchangeShopPanelComponent_Base = BaseClass("LWUICommonExchangeShopPanelComponent_Base", UIBaseContainer)
local LWUICommonExchangeShopItemComponent_Base = require("UI/ActivityCommon/LWUICommonExchangeShop/LWUICommonExchangeShopItemComponent_Base")
local Localization = CS.GameEntry.Localization

function LWUICommonExchangeShopPanelComponent_Base:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUICommonExchangeShopPanelComponent_Base:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUICommonExchangeShopPanelComponent_Base:ComponentDefine()
  self.compInfoContent = self:AddComponent(UIBaseComponent, "InfoContent")
  self.imgCostItem = self:AddComponent(UIImage, "InfoContent/CostItemImage")
  self.textCostItemCount = self:AddComponent(UITextMeshProUGUIEx, "InfoContent/CostItemCountText")
  self.textToggle = self:AddComponent(UITextMeshProUGUIEx, "InfoContent/ToggleText")
  self.toggle = self:AddComponent(UIToggle, "InfoContent/Toggle")
  self.scrollViewScrollView = self:AddComponent(UIScrollView, "ScrollView")
  self.scrollViewScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollViewScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function LWUICommonExchangeShopPanelComponent_Base:ComponentDestroy()
  self:ClearScroll()
  self.compInfoContent = nil
  self.imgCostItem = nil
  self.textCostItemCount = nil
  self.textToggle = nil
  self.toggle = nil
  self.scrollViewScrollView = nil
end

function LWUICommonExchangeShopPanelComponent_Base:DataDefine()
end

function LWUICommonExchangeShopPanelComponent_Base:DataDestroy()
end

function LWUICommonExchangeShopPanelComponent_Base:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshCommonExchangeShopPanel, self.OnRefreshPanel)
end

function LWUICommonExchangeShopPanelComponent_Base:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshCommonExchangeShopPanel, self.OnRefreshPanel)
  base.OnRemoveListener(self)
end

function LWUICommonExchangeShopPanelComponent_Base:ReInit(param)
  self.param = param
  if self.param == nil then
    return
  end
  if table.IsNullOrEmpty(self.param.dataList) then
    return
  end
  if self.param.customItemComponent == nil then
    self.param.customItemComponent = LWUICommonExchangeShopItemComponent_Base
  end
  self:RefreshAll()
end

function LWUICommonExchangeShopPanelComponent_Base:RefreshAll()
  if self.param == nil then
    return
  end
  self:RefreshToggle()
  self:RefreshItems()
  self:RefreshCostInfo()
end

function LWUICommonExchangeShopPanelComponent_Base:RefreshToggle()
  if self.param == nil then
    return
  end
  self.toggle:SetActive(false)
  self.textToggle:SetActive(false)
end

function LWUICommonExchangeShopPanelComponent_Base:RefreshItems()
  if self.param == nil or table.IsNullOrEmpty(self.param.dataList) then
    return
  end
  self:ClearScroll()
  self.scrollViewScrollView:SetTotalCount(#self.param.dataList)
  self.scrollViewScrollView:RefillCells()
end

function LWUICommonExchangeShopPanelComponent_Base:RefreshCostInfo()
  if self.param == nil or table.IsNullOrEmpty(self.param.dataList) then
    return
  end
  for i, v in pairs(self.param.dataList) do
    local costData = v:GetCostData()
    if costData then
      local img = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, checknumber(costData.itemId))
      if not string.IsNullOrEmpty(img) then
        self.imgCostItem:LoadSprite(img)
      end
      local curNum = DataCenter.ItemData:GetItemCount(checknumber(costData.itemId))
      self.textCostItemCount:SetText(tostring(curNum))
      break
    end
  end
end

function LWUICommonExchangeShopPanelComponent_Base:ClearScroll()
  self.scrollViewScrollView:ClearCells()
  if self.param and self.param.customItemComponent then
    self.scrollViewScrollView:RemoveComponents(self.param.customItemComponent)
  end
end

function LWUICommonExchangeShopPanelComponent_Base:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollViewScrollView:AddComponent(self.param.customItemComponent, itemObj)
  cellItem:SetActive(true)
  cellItem:ReInit(self.param.dataList[index])
end

function LWUICommonExchangeShopPanelComponent_Base:OnItemMoveOut(itemObj, index)
  self.scrollViewScrollView:RemoveComponent(itemObj.name, self.param.customItemComponent)
end

function LWUICommonExchangeShopPanelComponent_Base:OnRefreshPanel()
  self.scrollViewScrollView:RefreshCells()
  self:RefreshToggle()
  self:RefreshCostInfo()
end

return LWUICommonExchangeShopPanelComponent_Base
