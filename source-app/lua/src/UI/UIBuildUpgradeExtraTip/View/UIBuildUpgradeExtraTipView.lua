local base = UIBaseView
local UIBuildUpgradeExtraTipView = BaseClass("UIBuildUpgradeExtraTipView", base)
local Localization = CS.GameEntry.Localization
local BuildUpgradeExtraTipItem = require("UI.UIBuildUpgradeExtraTip.Component.BuildUpgradeExtraTipItem")

function UIBuildUpgradeExtraTipView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh()
end

function UIBuildUpgradeExtraTipView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBuildUpgradeExtraTipView:OnAddListener()
  base.OnAddListener(self)
end

function UIBuildUpgradeExtraTipView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBuildUpgradeExtraTipView:ComponentDefine()
  self.bgMask = self:AddComponent(UIButton, "Mask")
  self.bgMask:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.itemScrollContent = self:AddComponent(UIBaseContainer, "Tip/TipBg/Content")
  self.bg = self:AddComponent(UIBaseComponent, "Tip/TipBg")
  self.itemTemp = self.transform:Find("Tip/TipBg/Content/Item").gameObject
  self.itemTemp:GameObjectCreatePool()
  self.itemTemp:SetActive(false)
  self.title = self:AddComponent(UITextMeshProUGUIEx, "Tip/TipBg/icon/title")
end

function UIBuildUpgradeExtraTipView:ComponentDestroy()
  self.bgMask = nil
  self.itemScrollContent:RemoveComponents(BuildUpgradeExtraTipItem)
  self.itemScrollContent = nil
  self.bg = nil
  self.itemTemp:GameObjectRecycleAll()
  self.itemTemp = nil
end

function UIBuildUpgradeExtraTipView:DataDefine()
  self.data, self.position = self:GetUserData()
end

function UIBuildUpgradeExtraTipView:DataDestroy()
end

function UIBuildUpgradeExtraTipView:Refresh()
  self.bg:SetPosition(self.position)
  self.itemScrollContent:RemoveComponents(BuildUpgradeExtraTipItem)
  self.itemTemp.gameObject:GameObjectRecycleAll()
  for i = 1, 2 do
    local item = self.itemTemp:GameObjectSpawn(self.itemScrollContent.transform)
    item.name = tostring(i)
    local cell = self.itemScrollContent:AddComponent(BuildUpgradeExtraTipItem, item.name)
    if i == 1 then
      cell:SetData(self.data.old, self.data.oldValue)
    else
      cell:SetData(self.data.new, self.data.newValue)
    end
  end
  self.title:SetText(self.data.title)
end

return UIBuildUpgradeExtraTipView
