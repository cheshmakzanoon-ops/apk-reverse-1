local DiamondShopPage = BaseClass("DiamondShopPage", UIBaseContainer)
local base = UIBaseContainer
local DiamondItemCell = require("UI.LWGift.BuyDiamond.Component.DiamondItemCell")

function DiamondShopPage:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function DiamondShopPage:ClearScroll()
  if self.scroll then
    self.scroll:RemoveComponents(DiamondItemCell)
    self.grid:DestroyChildNode()
  end
end

function DiamondShopPage:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function DiamondShopPage:OnEnable()
  base.OnEnable(self)
  self.active = true
end

function DiamondShopPage:OnDisable()
  base.OnDisable(self)
  self.active = false
end

function DiamondShopPage:OnInitScroll(go, index)
  local item = self.scroll:AddComponent(DiamondItemCell, go)
  self.listGO[go] = item
end

function DiamondShopPage:OnUpdateScroll(go, index)
  local item = self.listGO[go]
  local package = self.packageList[index + 1]
  item:SetActive(package ~= nil)
  if package then
    item:Refresh(package)
  end
end

function DiamondShopPage:OnDestroyScrollItem(go, index)
end

function DiamondShopPage:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGiftPackData, self.RefreshView)
end

function DiamondShopPage:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.RefreshView)
  base.OnRemoveListener(self)
end

function DiamondShopPage:RefreshView()
  if not self.active then
    return
  end
  local plist1 = GiftPackageData:getPacksByType(GiftPackType.PromotionDiamond)
  local plist2 = GiftPackageData:getPacksByType(GiftPackType.BuyDiamond)
  if plist2 == nil then
    plist2 = {}
  end
  if plist1 then
    for k, v in pairs(plist1) do
      table.insert(plist2, v)
    end
  end
  self.packageList = plist2
  table.sort(self.packageList, function(a, b)
    return tonumber(a:getPrice()) > tonumber(b:getPrice())
  end)
  local dataCount = table.count(self.packageList)
  if 0 < dataCount then
    if not self.hasInitGrid then
      local bindFunc1 = BindCallback(self, self.OnInitScroll)
      local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
      local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
      self.grid:Init(bindFunc1, bindFunc2, bindFunc3)
      self.hasInitGrid = true
    end
    self.grid:SetItemCount(dataCount)
    self.grid:ForceUpdate()
  end
end

function DiamondShopPage:ComponentDefine()
  self.grid = self:AddComponent(GridInfinityScrollView, "CellGrid/Content")
  self.scroll = self:AddComponent(UIBaseContainer, "CellGrid")
end

function DiamondShopPage:ComponentDestroy()
  self.grid = nil
  self.scroll = nil
end

function DiamondShopPage:DataDefine()
  self.listGO = {}
  self.hasInitGrid = false
  self.active = false
end

function DiamondShopPage:DataDestroy()
  self.hasInitGrid = false
end

return DiamondShopPage
