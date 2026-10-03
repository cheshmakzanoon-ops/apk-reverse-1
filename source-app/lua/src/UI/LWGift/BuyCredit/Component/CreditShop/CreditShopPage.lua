local CreditShopPage = BaseClass("CreditShopPage", UIBaseContainer)
local base = UIBaseContainer
local CreditItemCell = require("UI.LWGift.BuyCredit.Component.CreditShop.CreditItemCell")

function CreditShopPage:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function CreditShopPage:ClearScroll()
  if self.scroll then
    self.scroll:RemoveComponents(CreditItemCell)
    self.grid:DestroyChildNode()
  end
end

function CreditShopPage:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function CreditShopPage:OnEnable()
  base.OnEnable(self)
  self.active = true
end

function CreditShopPage:OnDisable()
  base.OnDisable(self)
  self.active = false
end

function CreditShopPage:OnInitScroll(go, index)
  local item = self.scroll:AddComponent(CreditItemCell, go)
  self.listGO[go] = item
end

function CreditShopPage:OnUpdateScroll(go, index)
  local item = self.listGO[go]
  local package = self.packageList[index + 1]
  item:SetActive(package ~= nil)
  if package then
    item:Refresh(package)
  end
end

function CreditShopPage:OnDestroyScrollItem(go, index)
end

function CreditShopPage:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGiftPackData, self.RefreshView)
end

function CreditShopPage:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.RefreshView)
  base.OnRemoveListener(self)
end

function CreditShopPage:RefreshView()
  if not self.active then
    return
  end
  local plist1 = GiftPackageData:getPacksByType(GiftPackType.CreditPackage)
  self.packageList = plist1
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

function CreditShopPage:ComponentDefine()
  self.grid = self:AddComponent(GridInfinityScrollView, "CellGrid/Content")
  self.scroll = self:AddComponent(UIBaseContainer, "CellGrid")
end

function CreditShopPage:ComponentDestroy()
  self.grid = nil
  self.scroll = nil
end

function CreditShopPage:DataDefine()
  self.listGO = {}
  self.hasInitGrid = false
  self.active = false
end

function CreditShopPage:DataDestroy()
  self.hasInitGrid = false
end

return CreditShopPage
