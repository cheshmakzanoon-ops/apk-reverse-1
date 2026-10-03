local base = UIBaseContainer
local UILWMailBattleSkinItemComponent = BaseClass("UILWMailBattleSkinItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIDecorationIconCell = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationIconCell")

function UILWMailBattleSkinItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailBattleSkinItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailBattleSkinItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compLeftIcon = self.viewSkin:AddComponent(self, UIDecorationIconCell, 1)
  self.textLeftTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textLeftDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textRightTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textRightDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.compRightIcon = self.viewSkin:AddComponent(self, UIDecorationIconCell, 6)
end

function UILWMailBattleSkinItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compLeftIcon = nil
  self.textLeftTitle = nil
  self.textLeftDes = nil
  self.textRightTitle = nil
  self.textRightDes = nil
  self.compRightIcon = nil
end

function UILWMailBattleSkinItemComponent:DataDefine()
end

function UILWMailBattleSkinItemComponent:DataDestroy()
end

function UILWMailBattleSkinItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWMailBattleSkinItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWMailBattleSkinItemComponent:ReInit(skinType, data)
  self.textLeftTitle:SetText(DataCenter.DecorationTemplateManager:GetDecorationTypeName(skinType))
  self.textRightTitle:SetText(DataCenter.DecorationTemplateManager:GetDecorationTypeName(skinType))
  local leftIconData = self:CreateIconCellData(data[1] and data[1].skinId or 0)
  self.compLeftIcon:SetActive(leftIconData ~= nil)
  if leftIconData ~= nil then
    self.compLeftIcon:ReInit(leftIconData, nil, UIDecorationIconCellParentType.UILWMailBattleSkinItemComponent)
  end
  local rightIconData = self:CreateIconCellData(data[2] and data[2].skinId or 0)
  self.compRightIcon:SetActive(rightIconData ~= nil)
  if rightIconData ~= nil then
    self.compRightIcon:ReInit(rightIconData, nil, UIDecorationIconCellParentType.UILWMailBattleSkinItemComponent)
  end
  self.textLeftDes:SetText(tostring(data[1] and data[1].num or 0))
  self.textRightDes:SetText(tostring(data[2] and data[2].num or 0))
end

function UILWMailBattleSkinItemComponent:CreateIconCellData(id)
  local template = DataCenter.DecorationTemplateManager:GetTemplate(id)
  if template == nil then
    return nil
  end
  local data = {}
  data.id = id
  data.isUnlock = true
  data.inUse = false
  data.colorBg = DataCenter.ItemTemplateManager:GetToolBgByColor(template.quality)
  data.icon = template.icon
  data.showRedPoint = false
  data.showNew = false
  data.showAddRedPoint = false
  return data
end

return UILWMailBattleSkinItemComponent
