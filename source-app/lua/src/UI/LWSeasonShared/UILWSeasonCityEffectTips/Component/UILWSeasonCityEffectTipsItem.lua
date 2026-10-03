local UILWSeasonCityEffectTipsItem = BaseClass("UILWSeasonCityEffectTipsItem", UIBaseContainer)
local base = UIBaseContainer

function UILWSeasonCityEffectTipsItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, "")
  self.text_name = self:AddComponent(UITextMeshProUGUIEx, "TextName")
  self.text_value = self:AddComponent(UITextMeshProUGUIEx, "TextValue")
end

function UILWSeasonCityEffectTipsItem:OnDestroy()
  self.text_name = nil
  self.text_value = nil
  base.OnDestroy(self)
end

function UILWSeasonCityEffectTipsItem:ReInit(index, buffAddNum, effectName)
  self.text_name:SetLocalText(effectName)
  self.text_value:SetText(buffAddNum)
  if index % 2 == 1 then
    self.bg:SetColorRGBA(0.94, 0.93, 0.92, 1)
  else
    self.bg:SetColorRGBA(0.94, 0.93, 0.92, 0.5)
  end
end

return UILWSeasonCityEffectTipsItem
