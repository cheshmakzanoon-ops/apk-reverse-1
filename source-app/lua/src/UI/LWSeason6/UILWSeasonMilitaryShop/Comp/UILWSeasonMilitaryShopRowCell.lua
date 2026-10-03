local base = UIBaseContainer
local item_prefab_path = "Assets/Main/SeasonRes/S6/Prefabs/UI/MilitaryShop/SeasonMilitaryShopItem.prefab"
local item_prefab_script = require("UI.LWSeason6.UILWSeasonMilitaryShop.Comp.UILWSeasonMilitaryShopItemCell")
local UILWSeasonMilitaryShopRowCell = BaseClass("UILWSeasonMilitaryShopRowCell", UIBaseContainer)

function UILWSeasonMilitaryShopRowCell:ComponentDefine()
  self.transRoot = self:AddComponent(UIBaseContainer, "p_trans_item_root")
end

function UILWSeasonMilitaryShopRowCell:ComponentDestroy()
  self:ClearReqs()
  self.transRoot = nil
end

function UILWSeasonMilitaryShopRowCell:DataDefine()
end

function UILWSeasonMilitaryShopRowCell:DataDestroy()
end

function UILWSeasonMilitaryShopRowCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonMilitaryShopRowCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMilitaryShopRowCell:OnAddListener()
  base.OnAddListener(self)
end

function UILWSeasonMilitaryShopRowCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWSeasonMilitaryShopRowCell:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function UILWSeasonMilitaryShopRowCell:InitData(data)
  if data ~= nil then
    self.ShopDataList = data.Data
    self.BaseTime = checknumber(data.BaseTime)
    return true
  end
  return false
end

function UILWSeasonMilitaryShopRowCell:ClearReqs()
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

function UILWSeasonMilitaryShopRowCell:InitUi()
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
      go.name = string.format("SeasonMilitaryShopItem_%s_%s", curShopData.ShopCell.id, NameCount)
      NameCount = NameCount + 1
      local comp = self.transRoot:AddComponent(item_prefab_script, go.name)
      local itemData = {}
      itemData.ShopData = curShopData
      itemData.BaseTime = self.BaseTime
      comp:ReInit(itemData)
      go:SetActive(true)
    end)
    table.insert(self.Reqs, req)
  end
end

return UILWSeasonMilitaryShopRowCell
