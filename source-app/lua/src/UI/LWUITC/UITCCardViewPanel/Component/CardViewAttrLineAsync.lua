local CardViewAttrLineAsync = BaseClass("CardViewAttrLineAsync", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local UILWScienceDetailDesc = require("UI.UILWScience.UILWScienceDetail.Component.UILWScienceDetailDesc")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.name_txt = self:AddComponent(UILWScienceDetailDesc, "content/name_txt")
  self.value_txt = self:AddComponent(UITextMeshProUGUIEx, "content/ValueContainer/ValueText")
  self.bg = self:AddComponent(UIImage, "bg")
  self.content_layout = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, "content")
end

local function ComponentDestroy(self)
  self.name_txt = nil
  self.value_txt = nil
  self.bg = nil
  self.content_layout = nil
end

function CardViewAttrLineAsync:UpdateAttr(attrId, value, nextValue, name, quality)
  self.attrId = attrId
  self.value = value
  self.nextValue = nextValue
  self.name = name
  self.quality = quality
  self:RefreshView()
end

function CardViewAttrLineAsync:UpdateData()
  if self.name then
    if self.quality then
      local format = DataCenter.TacticalCardDataManager:GetAttributeQualityColor(self.quality)
      self.name_txt:SetText(string.format(format, Localization:GetString(self.name)))
    else
      self.name_txt:SetLocalText(self.name)
    end
  else
    local attrName = DataCenter.EffectNumberTemplateManager:GetEffectNumberName(self.attrId)
    if self.quality then
      local format = DataCenter.TacticalCardDataManager:GetAttributeQualityColor(self.quality)
      self.name_txt:SetText(string.format(format, Localization:GetString(attrName)))
    else
      self.name_txt:SetLocalText(attrName)
    end
  end
  local formatType = DataCenter.EffectNumberTemplateManager:GetEffectNumberType(self.attrId)
  local val_a = HeroUtils.GetFormattedValue(formatType, self.value, false)
  local val = val_a
  if self.nextValue and self.nextValue ~= self.value then
    local val_b = HeroUtils.GetFormattedValue(formatType, self.nextValue, false)
    val = string.format("%s-%s", val_a, val_b)
  end
  self.value_txt:SetText(val)
end

CardViewAttrLineAsync.OnCreate = OnCreate
CardViewAttrLineAsync.OnDestroy = OnDestroy
CardViewAttrLineAsync.ComponentDestroy = ComponentDestroy
CardViewAttrLineAsync.ComponentDefine = ComponentDefine
return CardViewAttrLineAsync
