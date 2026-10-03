local UIHeroAttrItem = BaseClass("UIHeroAttrItem", UIBaseContainer)
local base = UIBaseContainer
local value_des_path = "valueDes"
local old_value_path = "oldValue"
local image_path = "Image"
local new_value_path = "newValue"

function UIHeroAttrItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIHeroAttrItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIHeroAttrItem:ComponentDefine()
  self.value_des = self:AddComponent(UIText, value_des_path)
  self.old_value = self:AddComponent(UIText, old_value_path)
  self.image = self:AddComponent(UIImage, image_path)
  self.new_value = self:AddComponent(UIText, new_value_path)
end

function UIHeroAttrItem:ComponentDestroy()
  self.value_des = nil
  self.old_value = nil
  self.image = nil
  self.new_value = nil
end

function UIHeroAttrItem:OnAddListener()
  base.OnAddListener(self)
end

function UIHeroAttrItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIHeroAttrItem:SetHeroAttrData(data)
  self.value_des:SetText(data.des)
  self.old_value:SetText(data.oldValue)
  if data.isUpFlag then
    self.image:SetColor(Color.New(0.17254901960784313, 0.9450980392156862, 0.42745098039215684, 1))
    self.new_value:SetText(string.format("<color=#2cf16d>%s</color>", data.newValue))
  else
    self.new_value:SetText(data.newValue)
    self.image:SetColor(Color.white)
  end
end

return UIHeroAttrItem
