local PropItem = BaseClass("PropItem", UIAsyncDataContainer)
local base = UIAsyncDataContainer
local Localization = CS.GameEntry.Localization
PropItem.DataSchema = {"name", "value"}
PropItem.PrefabPath = "Assets/Main/Prefabs/UI/UIFirstPay/PropItem.prefab"

function PropItem:OnCreate()
  base.OnCreate(self)
  self.name_txt = self:AddComponent(UIText, "bg/name_txt")
  self.value_txt = self:AddComponent(UIText, "bg/value_txt")
end

function PropItem:OnDestroy()
  self.name_txt = nil
  self.value_txt = nil
  base.OnDestroy(self)
end

function PropItem:UpdateData()
  self.name_txt:SetLocalText(self.viewData.name)
  self.value_txt:SetText(string.GetFormattedStr(self.viewData.value))
end

return PropItem
