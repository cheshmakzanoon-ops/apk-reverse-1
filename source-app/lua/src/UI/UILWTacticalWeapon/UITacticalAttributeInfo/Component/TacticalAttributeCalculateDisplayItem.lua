local TacticalAttributeCalculateDisplayItem = BaseClass("TacticalAttributeCalculateDisplayItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local attribute_origin_name_path = "attributeOrigin/attributeOriginName"
local attribute_origin_value_path = "attributeOrigin/attributeOriginValue"
local attribute_rate_name_path = "attributeRate/attributeRateName"
local attribute_rate_value_path = "attributeRate/attributeRateValue"
local attribute_result_name_path = "attributeResult/attributeResultName"
local attribute_result_value_path = "attributeResult/attributeResultValue"

function TacticalAttributeCalculateDisplayItem:OnCreate()
  base.OnCreate(self)
  self.attribute_origin_name = self:AddComponent(UITextMeshProUGUIEx, attribute_origin_name_path)
  self.attribute_origin_value = self:AddComponent(UITextMeshProUGUIEx, attribute_origin_value_path)
  self.attribute_rate_name = self:AddComponent(UITextMeshProUGUIEx, attribute_rate_name_path)
  self.attribute_rate_value = self:AddComponent(UITextMeshProUGUIEx, attribute_rate_value_path)
  self.attribute_result_name = self:AddComponent(UITextMeshProUGUIEx, attribute_result_name_path)
  self.attribute_result_value = self:AddComponent(UITextMeshProUGUIEx, attribute_result_value_path)
end

function TacticalAttributeCalculateDisplayItem:OnDestroy()
  base.OnDestroy(self)
end

function TacticalAttributeCalculateDisplayItem:OnEnable()
  base.OnEnable(self)
end

function TacticalAttributeCalculateDisplayItem:OnDisable()
  base.OnDisable(self)
end

function TacticalAttributeCalculateDisplayItem:SetData(param)
  self.attribute_origin_name:SetText(param.originName)
  self.attribute_origin_value:SetText(param.originValue)
  self.attribute_rate_name:SetText(param.rateName)
  self.attribute_rate_value:SetText(param.rateValue)
  self.attribute_result_name:SetText(param.resultName)
  self.attribute_result_value:SetText(param.resultValue)
end

return TacticalAttributeCalculateDisplayItem
