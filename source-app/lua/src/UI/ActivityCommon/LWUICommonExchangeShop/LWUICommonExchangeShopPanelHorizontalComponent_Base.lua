local base = UIBaseContainer
local LWUICommonExchangeShopPanelHorizontalComponent_Base = BaseClass("LWUICommonExchangeShopPanelHorizontalComponent_Base", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local LWUICommonExchangeShopItemHorizontalComponent_Base = require("UI.ActivityCommon.LWUICommonExchangeShop.LWUICommonExchangeShopItemHorizontalComponent_Base")

function LWUICommonExchangeShopPanelHorizontalComponent_Base:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUICommonExchangeShopPanelHorizontalComponent_Base:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUICommonExchangeShopPanelHorizontalComponent_Base:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgCostItem = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textCostItemCount = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textToggle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.toggle = self.viewSkin:AddComponent(self, UIToggle, 4)
  self.scrollViewUICommonScrollViewVertical = self.viewSkin:AddComponent(self, UIScrollView, 5)
  self.scrollViewUICommonScrollViewVertical:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollViewUICommonScrollViewVertical:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function LWUICommonExchangeShopPanelHorizontalComponent_Base:ComponentDestroy()
  self:ClearScroll()
  self.viewSkin = nil
  self.imgCostItem = nil
  self.textCostItemCount = nil
  self.textToggle = nil
  self.toggle = nil
  self.scrollViewUICommonScrollViewVertical = nil
end

function LWUICommonExchangeShopPanelHorizontalComponent_Base:DataDefine()
end

function LWUICommonExchangeShopPanelHorizontalComponent_Base:DataDestroy()
end

function LWUICommonExchangeShopPanelHorizontalComponent_Base:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshCommonExchangeShopPanel, self.OnRefreshPanel)
end

function LWUICommonExchangeShopPanelHorizontalComponent_Base:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshCommonExchangeShopPanel, self.OnRefreshPanel)
  base.OnRemoveListener(self)
end

function LWUICommonExchangeShopPanelHorizontalComponent_Base:ReInit(param)
  self.param = param
  if self.param == nil then
    return
  end
  if table.IsNullOrEmpty(self.param.dataList) then
    return
  end
  if self.param.customItemComponent == nil then
    self.param.customItemComponent = LWUICommonExchangeShopItemHorizontalComponent_Base
  end
  self:RefreshAll()
end

function LWUICommonExchangeShopPanelHorizontalComponent_Base:RefreshAll()
  if self.param == nil then
    return
  end
  self:RefreshToggle()
  self:RefreshItems()
  self:RefreshCostInfo()
end

function LWUICommonExchangeShopPanelHorizontalComponent_Base:RefreshToggle()
  if self.param == nil then
    return
  end
  self.toggle:SetActive(self.param.getIsShowToggle ~= nil)
  self.textToggle:SetActive(self.param.getIsShowToggle ~= nil)
  if self.param.getIsShowToggle ~= nil then
    self.toggle:SetIsOn(self.param.getIsShowToggle())
    self.toggle:SetOnValueChanged(function(tf)
      if self.param and self.param.onToggleValueChanged then
        self.param.onToggleValueChanged(tf)
      end
    end)
  end
end

function LWUICommonExchangeShopPanelHorizontalComponent_Base:RefreshItems()
  if self.param == nil or table.IsNullOrEmpty(self.param.dataList) then
    return
  end
  self:ClearScroll()
  self.scrollViewUICommonScrollViewVertical:SetTotalCount(#self.param.dataList)
  self.scrollViewUICommonScrollViewVertical:RefillCells()
end

function LWUICommonExchangeShopPanelHorizontalComponent_Base:RefreshCostInfo()
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

function LWUICommonExchangeShopPanelHorizontalComponent_Base:ClearScroll()
  self.scrollViewUICommonScrollViewVertical:ClearCells()
  if self.param and self.param.customItemComponent then
    self.scrollViewUICommonScrollViewVertical:RemoveComponents(self.param.customItemComponent)
  end
end

function LWUICommonExchangeShopPanelHorizontalComponent_Base:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollViewUICommonScrollViewVertical:AddComponent(self.param.customItemComponent, itemObj)
  cellItem:SetActive(true)
  cellItem:ReInit(self.param.dataList[index])
end

function LWUICommonExchangeShopPanelHorizontalComponent_Base:OnItemMoveOut(itemObj, index)
  self.scrollViewUICommonScrollViewVertical:RemoveComponent(itemObj.name, self.param.customItemComponent)
end

function LWUICommonExchangeShopPanelHorizontalComponent_Base:OnRefreshPanel()
  self.scrollViewUICommonScrollViewVertical:RefreshCells()
  self:RefreshToggle()
  self:RefreshCostInfo()
end

return LWUICommonExchangeShopPanelHorizontalComponent_Base
