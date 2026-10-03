local item_prefab_script = require("UI.LWSeason6.UILWSeasonMilitaryShop.NewPopup.Comp.SeasonMilitaryShopNewPopupItemCell")
local base = UIBaseContainer
local SeasonMilitaryShopNewPopupRowCell = BaseClass("SeasonMilitaryShopNewPopupRowCell", UIBaseContainer)

function SeasonMilitaryShopNewPopupRowCell:ComponentDefine()
  self.transRoot = self:AddComponent(UIBaseContainer, "p_trans_item_root")
end

function SeasonMilitaryShopNewPopupRowCell:ComponentDestroy()
  self:ClearReqs()
  self.transRoot = nil
end

function SeasonMilitaryShopNewPopupRowCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function SeasonMilitaryShopNewPopupRowCell:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonMilitaryShopNewPopupRowCell:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function SeasonMilitaryShopNewPopupRowCell:InitData(data)
  if data ~= nil then
    self.ShopDataList = data
    return true
  end
  return false
end

function SeasonMilitaryShopNewPopupRowCell:ClearReqs()
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

function SeasonMilitaryShopNewPopupRowCell:InitUi()
  local item_prefab_path = "Assets/Main/SeasonRes/S6/Prefabs/UI/MilitaryShop/SeasonMilitaryShopNewItem.prefab"
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
      comp:ReInit(curShopData)
      go:SetActive(true)
    end)
    table.insert(self.Reqs, req)
  end
end

return SeasonMilitaryShopNewPopupRowCell
