local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local item_prefab_path = "Assets/Main/SeasonRes/S5/Prefabs/UI/SeasonBountyShop/SeasonBountyShopItem.prefab"
local item_prefab_script = require("UI/LWSeason5/SeasonBountyShop/Comp/SeasonBountyShopItemCell")
local SeasonBountyShopRowCell = BaseClass("SeasonBountyShopRowCell", UIBaseContainer)

function SeasonBountyShopRowCell:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.transRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
end

function SeasonBountyShopRowCell:ComponentDestroy()
  self:ClearReqs()
  self.viewSkin = nil
  self.transRoot = nil
end

function SeasonBountyShopRowCell:DataDefine()
end

function SeasonBountyShopRowCell:DataDestroy()
end

function SeasonBountyShopRowCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonBountyShopRowCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonBountyShopRowCell:OnAddListener()
  base.OnAddListener(self)
end

function SeasonBountyShopRowCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SeasonBountyShopRowCell:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function SeasonBountyShopRowCell:InitData(data)
  if data ~= nil then
    self.ShopDataList = data
    return true
  end
  return false
end

function SeasonBountyShopRowCell:ClearReqs()
  if not table.IsNullOrEmpty(self.Reqs) then
    for _, req in pairs(self.Reqs) do
      if IsNotNull(req.gameObject) then
        self.transRoot:RemoveComponent(req.gameObject.name, item_prefab_script)
      end
      self:GameObjectDestroy(req)
    end
  end
  self.Reqs = nil
end

function SeasonBountyShopRowCell:InitUi()
  self:ClearReqs()
  self.Reqs = {}
  for _, shopData in pairs(self.ShopDataList) do
    local curShopData = shopData
    local req = self:GameObjectInstantiateAsync(item_prefab_path, function(req)
      local go = req.gameObject
      local transform = go.transform
      local transRoot = self.transRoot.transform
      transform:SetParent(transRoot)
      transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = string.format("SeasonBountyShopItem_%s", curShopData.ShopCell.id)
      local comp = self.transRoot:AddComponent(item_prefab_script, go.name)
      local itemData = {}
      itemData.ShopData = curShopData
      comp:ReInit(itemData)
      go:SetActive(true)
    end)
    table.insert(self.Reqs, req)
  end
end

function SeasonBountyShopRowCell:UpdateData()
  return true
end

function SeasonBountyShopRowCell:UpdateUi()
end

function SeasonBountyShopRowCell:Update1000MS()
end

return SeasonBountyShopRowCell
