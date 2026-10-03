local base = UIBaseView
local UIAllyDrillMvpTipView = BaseClass("UIAllyDrillMvpTipView", base)
local Localization = CS.GameEntry.Localization
local AllyDrillMvpItem = require("UI.UIAllyDrill.UIAllyDrillMvpTip.Component.AllyDrillMvpItem")

function UIAllyDrillMvpTipView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh()
end

function UIAllyDrillMvpTipView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllyDrillMvpTipView:OnAddListener()
  base.OnAddListener(self)
end

function UIAllyDrillMvpTipView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIAllyDrillMvpTipView:ComponentDefine()
  self.bgMask = self:AddComponent(UIButton, "Mask")
  self.bgMask:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.itemScrollContent = self:AddComponent(UIBaseContainer, "Tip/TipBg/ScrollView/Viewport/Content")
  self.bg = self:AddComponent(UIBaseComponent, "Tip/TipBg")
  self.itemTemp = self.transform:Find("Tip/TipBg/ScrollView/Viewport/Content/Item").gameObject
  self.itemTemp:GameObjectCreatePool()
  self.itemTemp:SetActive(false)
end

function UIAllyDrillMvpTipView:ComponentDestroy()
  self.bgMask = nil
  self.itemScrollContent:RemoveComponents(AllyDrillMvpItem)
  self.itemScrollContent = nil
  self.arrow = nil
  self.bg = nil
  self.itemTemp:GameObjectRecycleAll()
  self.itemTemp = nil
end

function UIAllyDrillMvpTipView:DataDefine()
  self.position, self.meta, self.stage = self:GetUserData()
end

function UIAllyDrillMvpTipView:DataDestroy()
end

function UIAllyDrillMvpTipView:Refresh()
  self.bg:SetPosition(self.position)
  self.itemScrollContent:RemoveComponents(AllyDrillMvpItem)
  self.itemTemp.gameObject:GameObjectRecycleAll()
  local list = self.meta.alliance_bonus
  if list ~= nil then
    for i = 1, table.length(list) do
      local item = self.itemTemp:GameObjectSpawn(self.itemScrollContent.transform)
      item.name = tostring(i)
      local cell = self.itemScrollContent:AddComponent(AllyDrillMvpItem, item.name, list[i])
      cell:SetData(list[i], self.stage == i)
    end
  end
end

return UIAllyDrillMvpTipView
