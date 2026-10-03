local LineItem = BaseClass("LineItem", UIBaseContainer)
local AllianceFlagItem = require("UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local price_txt_path = "Desc/PriceText"
local creditValue_txt_path = "Desc/CreditValueText"

function LineItem:OnCreate()
  base.OnCreate(self)
  self.priceText = self:AddComponent(UIText, price_txt_path)
  self.creditValueText = self:AddComponent(UIText, creditValue_txt_path)
end

function LineItem:OnRefresh(itemData)
  self.itemData = itemData
  self.priceText:SetText(itemData.price)
  self.creditValueText:SetText(itemData.creditValue)
end

function LineItem:OnDestroy()
  base.OnDestroy(self)
end

return LineItem
