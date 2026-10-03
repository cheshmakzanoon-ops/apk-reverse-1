local LWUICivilizationSparkInfoView = BaseClass("LWUICivilizationSparkInfoView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWUICivilizationSparkInfoItem = require("UI.LWUICivilizationSparkInfo.Component.LWUICivilizationSparkInfoItem")

function LWUICivilizationSparkInfoView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUICivilizationSparkInfoView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUICivilizationSparkInfoView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnMask = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnMask:SetOnClick(function()
    self:OnBtnMaskClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.itemPool = self.transform:Find("Content/MainRoot/BuffList/Viewport/Content/InfoItem").gameObject
  self.itemPool:GameObjectCreatePool()
end

function LWUICivilizationSparkInfoView:ComponentDestroy()
  self:ClearBuffList()
  self.itemPool = nil
  self.viewSkin = nil
  self.btnMask = nil
  self.textTitle = nil
  self.btnClose = nil
  self.textTip = nil
  self.compContent = nil
end

function LWUICivilizationSparkInfoView:DataDefine()
  self:Refresh()
end

function LWUICivilizationSparkInfoView:DataDestroy()
end

function LWUICivilizationSparkInfoView:OnAddListener()
  base.OnAddListener(self)
end

function LWUICivilizationSparkInfoView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUICivilizationSparkInfoView:OnBtnMaskClick()
  self.ctrl:CloseSelf()
end

function LWUICivilizationSparkInfoView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function LWUICivilizationSparkInfoView:ClearBuffList()
  self.compContent:RemoveAllComponentes()
  self.itemPool:GameObjectRecycleAll()
end

function LWUICivilizationSparkInfoView:Refresh()
  local template = DataCenter.LWCivilizationSparkManager:GetTemplate(1)
  local curLevel = DataCenter.LWCivilizationSparkManager:GetLevel()
  while template ~= nil do
    local item = self.itemPool:GameObjectSpawn()
    item:SetActive(true)
    item.name = "item_" .. template.level
    item.transform:SetParent(self.compContent.transform)
    item.transform:Set_localScale(1, 1, 1)
    local comp = self.compContent:AddComponent(LWUICivilizationSparkInfoItem, item)
    comp:Refresh(template, curLevel < template.level)
    template = DataCenter.LWCivilizationSparkManager:GetTemplate(template.level + 1)
  end
end

return LWUICivilizationSparkInfoView
