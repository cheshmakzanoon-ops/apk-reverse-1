local BuildPropertyItem = BaseClass("BuildPropertyItem", UIBaseContainer)
local base = UIBaseContainer
local AdditionEffect = {
  ["50117"] = 50023,
  ["50111"] = 50024,
  ["50119"] = 50101,
  ["50122"] = 50102,
  ["50123"] = 50103,
  ["50124"] = 50104,
  ["50125"] = 50105
}

function BuildPropertyItem:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function BuildPropertyItem:DataDefine()
  self.param = nil
end

function BuildPropertyItem:ComponentDefine()
  self.currencyIcon = self:AddComponent(UIImage, "BG/Top/currencyIcon")
  self.propertyName = self:AddComponent(UIText, "BG/Top/Text")
  self.propertyValue = self:AddComponent(UIText, "BG/bom/Text1")
  self.propertyPercent = self:AddComponent(UIText, "BG/bom/Text2")
end

function BuildPropertyItem:ReInit(param)
  self.param = param
  self.propertyName:SetText(self.param.property.describe)
  self.currencyIcon:LoadSprite(self.param.property.iconPath)
  self.propertyValue:SetText(self.param.property.valueText)
  if not self.param.propertyPercent then
    self.propertyPercent:SetActive(false)
  else
    self.propertyPercent:SetActive(true)
    self.propertyPercent:SetText(self.param.propertyPercent)
  end
end

function BuildPropertyItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function BuildPropertyItem:DataDestroy()
  self.param = nil
end

function BuildPropertyItem:ComponentDestroy()
  self.currencyIcon = nil
  self.propertyName = nil
  self.propertyValue = nil
  self.propertyPercent = nil
end

return BuildPropertyItem
