local UINewText = BaseClass("UINewText", UIBaseComponent)
local base = UIBaseComponent
local UnityText = typeof(CS.NewText)
local UnityTextMeshProEx = typeof(CS.TextMeshProUGUIEx)

local function OnCreate(self)
  base.OnCreate(self)
  self.unity_text = self.gameObject:GetComponent(UnityText)
  self.unity_tmpro = self.gameObject:GetComponent(UnityTextMeshProEx)
end

local function GetText(self)
  if not IsNull(self.unity_text) then
    return self.unity_text.text
  elseif not IsNull(self.unity_tmpro) then
    return self.unity_tmpro.text
  end
end

local function SetText(self, text)
  if not IsNull(self.unity_text) then
    self.unity_text.text = text
  elseif not IsNull(self.unity_tmpro) then
    self.unity_tmpro.text = text
  end
end

local function OnDestroy(self)
  self.unity_text = nil
  self.unity_tmpro = nil
  base.OnDestroy(self)
end

local function SetColor(self, value)
  if not IsNull(self.unity_text) then
    self.unity_text:Set_color(value.r, value.g, value.b, value.a)
  elseif not IsNull(self.unity_tmpro) then
    self.unity_tmpro.color = value
  end
end

local function GetColor(self)
  if not IsNull(self.unity_text) then
    local r, g, b, a = self:GetColorRGBA()
    return Color.New(r, g, b, a)
  elseif not IsNull(self.unity_tmpro) then
    return self.unity_tmpro.color
  end
end

local function SetColorRGBA(self, r, g, b, a)
  if not IsNull(self.unity_text) then
    self.unity_text:Set_color(r, g, b, a)
  elseif not IsNull(self.unity_tmpro) then
    local color = Color.New(r, g, b, a)
    self.unity_tmpro.color = color
  end
end

local function GetColorRGBA(self)
  if not IsNull(self.unity_text) then
    return self.unity_text:Get_color()
  elseif not IsNull(self.unity_tmpro) then
    return self.unity_tmpro.color.r, self.unity_tmpro.color.g, self.unity_tmpro.color.b, self.unity_tmpro.color.a
  end
end

local function GetWidth(self)
  if not IsNull(self.unity_text) then
    return self.unity_text.preferredWidth
  elseif not IsNull(self.unity_tmpro) then
    return self.unity_tmpro.preferredWidth
  end
end

local function GetHeight(self)
  if not IsNull(self.unity_text) then
    return self.unity_text.preferredHeight
  elseif not IsNull(self.unity_tmpro) then
    return self.unity_tmpro.preferredHeight
  end
end

function UINewText:SetAlignment(_alignment)
  if not IsNull(self.unity_text) then
    self.unity_text.alignment = _alignment
  elseif not IsNull(self.unity_tmpro) then
    self.unity_tmpro.alignment = CS.TextMeshProUGUIEx.ConvertAlignFormat(_alignment, false)
  end
end

local function SetPreferSize(self, value)
  self.rectTransform.sizeDelta = value
end

UINewText.OnCreate = OnCreate
UINewText.GetText = GetText
UINewText.SetText = SetText
UINewText.OnDestroy = OnDestroy
UINewText.SetColor = SetColor
UINewText.GetWidth = GetWidth
UINewText.GetHeight = GetHeight
UINewText.SetPreferSize = SetPreferSize
UINewText.GetColor = GetColor
UINewText.SetColorRGBA = SetColorRGBA
UINewText.GetColorRGBA = GetColorRGBA
return UINewText
