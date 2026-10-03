local CardAttrLineAsync = BaseClass("CardAttrLineAsync", UIAsyncContainer)
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
  self.arrow_icon = self:AddComponent(UIImage, "content/ValueContainer/ArrowIcon")
  self.nextValue_txt = self:AddComponent(UITextMeshProUGUIEx, "content/ValueContainer/NextValueText")
  self.vfx_saoguang = self:AddComponent(UIVfx, "vfx_saoguang", VfxAssets.TCCardAttributeRefreshVfx)
  self.bg = self:AddComponent(UIImage, "bg")
  self.content_layout = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, "content")
end

local function ComponentDestroy(self)
  self.attrId = nil
  self.value = nil
  self.nextValue = nil
  self.name_txt = nil
  self.value_txt = nil
  self.arrow_icon = nil
  self.nextValue_txt = nil
  self.bg = nil
  self.vfx_saoguang = nil
  self.bg = nil
  self.content_layout = nil
end

function CardAttrLineAsync:UpdateAttr(attrId, value, nextValue, name, quality)
  if self.attrId and self.attrId == attrId and self.value and self.value ~= value and self.vfx_saoguang then
    self.vfx_saoguang:Replay()
  end
  self.attrId = attrId
  self.value = value
  self.nextValue = nextValue
  self.name = name
  self.quality = quality
  self:RefreshView()
end

function CardAttrLineAsync:UpdateData()
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
  self.value_txt:SetText(HeroUtils.GetFormattedValue(formatType, self.value, false))
  if self.nextValue and self.nextValue ~= self.value then
    self.arrow_icon:SetActive(true)
    self.nextValue_txt:SetActive(true)
    self.nextValue_txt:SetText(HeroUtils.GetFormattedValue(formatType, self.nextValue, false))
  else
    self.arrow_icon:SetActive(false)
    self.nextValue_txt:SetActive(false)
  end
end

CardAttrLineAsync.OnCreate = OnCreate
CardAttrLineAsync.OnDestroy = OnDestroy
CardAttrLineAsync.ComponentDestroy = ComponentDestroy
CardAttrLineAsync.ComponentDefine = ComponentDefine
return CardAttrLineAsync
