local base = UIBaseContainer
local BattlePointGroup = BaseClass("BattlePointGroup", base)
local BattlePointItem = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleSkill.Component.BattlePointItem")
local tip_text_path = "Top/TipText"
local layout_path = "Layout"

function BattlePointGroup:OnCreate()
  base.OnCreate(self)
  self.items = {}
  self.tip_text = self:AddComponent(UITextMeshProUGUIEx, tip_text_path)
  self.layout = self:AddComponent(UIBaseContainer, layout_path)
end

function BattlePointGroup:OnDestroy()
  self:ClearCells()
  self.tip_text = nil
  self.layout = nil
  base.OnDestroy(self)
end

function BattlePointGroup:ClearCells()
  self.layout:RemoveComponents(BattlePointItem)
  self.items = {}
end

function BattlePointGroup:ReInit(template, itemBase, tipCb)
  self.tip_text:SetLocalText(template.name)
  local showIds = template.showIds
  local tL = #showIds
  local tI = #self.items
  local max = math.max(tI, tL)
  for i = 1, max do
    local item = self.items[i]
    if i <= tL then
      if item == nil then
        local obj = itemBase:GameObjectSpawn(self.layout.transform)
        obj.name = "item" .. i
        item = self.layout:AddComponent(BattlePointItem, obj.name)
        self.items[i] = item
      end
      item:SetActive(true)
      item:ReInit(showIds[i], template.icon, tipCb)
    elseif item then
      item:SetActive(false)
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layout.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

return BattlePointGroup
