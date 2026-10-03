local CoffeeLayOutItem = BaseClass("CoffeeLayOutItem", UIBaseContainer)
local base = UIBaseContainer
local detailsPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/MakingCoffee/CoffeeItem.prefab"
local CoffeeDetailsItem = require("UI/LWSeason5/LWMakingCoffee/Component/CoffeeDetailsItem")

function CoffeeLayOutItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function CoffeeLayOutItem:OnDestroy()
  self:ComponentDestroy()
  self.selectId = nil
  base.OnDestroy(self)
end

function CoffeeLayOutItem:ComponentDefine()
  self.item = self:AddComponent(UIBaseContainer, "CoffeeItem")
  self.item.gameObject:GameObjectCreatePool()
end

function CoffeeLayOutItem:ComponentDestroy()
  self:CLearItems()
  self.item = nil
end

function CoffeeLayOutItem:CLearItems()
  self:RemoveComponents(CoffeeDetailsItem)
  self.item.gameObject:GameObjectRecycleAll()
  self.detailsList = {}
end

function CoffeeLayOutItem:SetContentViewScript(chatMainView)
  self._contentViewScript = chatMainView
end

function CoffeeLayOutItem:SelectItem(coffeeId)
  self.selectId = coffeeId
  for i = 1, #self.detailsList do
    self.detailsList[i]:SelectItem(coffeeId)
  end
end

function CoffeeLayOutItem:UnlockCoffee(coffeeId)
  self.selectId = coffeeId
  for i = 1, #self.detailsList do
    self.detailsList[i]:UnlockCoffee(coffeeId)
  end
end

function CoffeeLayOutItem:UpdateItem(data)
  self:CLearItems()
  self.selectId = nil
  local dataList = data.list
  if dataList and 0 < #dataList then
    local cell, item
    for i = 1, #dataList do
      item = self.item.gameObject:GameObjectSpawn(self.transform)
      item.name = tostring(i)
      cell = self:AddComponent(CoffeeDetailsItem, item.name)
      cell:SetActive(true)
      cell:UpdateItem(dataList[i])
      table.insert(self.detailsList, cell)
    end
  end
end

return CoffeeLayOutItem
