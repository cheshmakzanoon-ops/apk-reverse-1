local base = UIBaseContainer
local LLDetailSmallGrid = BaseClass("LLDetailSmallGrid", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local LLDetailSmallCity = require("UI.LandlordBattle.BattleDetail.Component.LLDetailSmallCity")

function LLDetailSmallGrid:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLDetailSmallGrid:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLDetailSmallGrid:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compItem = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
end

function LLDetailSmallGrid:ComponentDestroy()
  self.viewSkin = nil
  self.compItem = nil
end

function LLDetailSmallGrid:DataDefine()
  self.items = {}
  self.compItem:SetActive(false)
  self.theItem = self.compItem.gameObject
  self.theItem:GameObjectCreatePool()
end

function LLDetailSmallGrid:DataDestroy()
  if self.items ~= nil then
    for _, v in ipairs(self.items) do
      self:RemoveComponent(v:GetName(), LLDetailSmallCity)
    end
    self.items = nil
  end
  self.theItem:GameObjectRecycleAll()
  self.theItem = nil
  self.list = nil
end

function LLDetailSmallGrid:OnAddListener()
  base.OnAddListener(self)
end

function LLDetailSmallGrid:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLDetailSmallGrid:SetList(list)
  self.list = list
end

function LLDetailSmallGrid:SetShow(bShow)
  if bShow and table.IsNullOrEmpty(self.list) then
    bShow = false
  end
  self:SetActive(bShow)
  if not bShow then
    return
  end
  local max = math.max(#self.list, #self.items)
  for i = 1, max do
    local item = self.items[i]
    local data = self.list[i]
    if data ~= nil then
      if item == nil then
        local obj = self.theItem:GameObjectSpawn(self.transform)
        obj.name = "Item_" .. i
        item = self:AddComponent(LLDetailSmallCity, obj.name)
        item:SetActive(true)
        self.items[i] = item
      end
      item:SetActive(true)
      item:SetData(data)
    elseif item ~= nil then
      item:SetActive(false)
    end
  end
end

return LLDetailSmallGrid
