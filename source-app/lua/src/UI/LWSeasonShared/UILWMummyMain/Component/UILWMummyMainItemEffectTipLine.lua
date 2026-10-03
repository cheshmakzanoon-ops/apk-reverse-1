local UILWMummyMainItemEffectTipLine = BaseClass("UILWMummyMainItemEffectTipLine", UIBaseContainer)
local base = UIBaseContainer

function UILWMummyMainItemEffectTipLine:OnCreate()
  base.OnCreate(self)
  self.key = self:AddComponent(UITextMeshProUGUIEx, "Key")
  self.value = self:AddComponent(UITextMeshProUGUIEx, "Value")
end

function UILWMummyMainItemEffectTipLine:OnDestroy()
  self.key = nil
  self.value = nil
  base.OnDestroy(self)
end

function UILWMummyMainItemEffectTipLine:ReInit(effectLine, effectValue)
  if effectLine then
    local type = toInt(effectLine.type)
    local buffAddNum = UIUtil.GetEffectStr(type, effectValue)
    if buffAddNum ~= nil then
      self.value:SetText(string.removeExtraDecimals(buffAddNum))
    else
      self.value:SetText("")
    end
    self.key:SetLocalText(effectLine.name)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
end

return UILWMummyMainItemEffectTipLine
