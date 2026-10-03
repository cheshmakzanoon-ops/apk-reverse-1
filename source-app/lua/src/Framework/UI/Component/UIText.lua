local UIText = BaseClass("UIText", UIBaseComponent)
local base = UIBaseComponent
local Localization = CS.GameEntry.Localization
local UnityText = typeof(CS.UnityEngine.UI.Text)
local UnityTextMeshProEx = typeof(CS.TextMeshProUGUIEx)
local UnityTextMeshPro = typeof(CS.TMPro.TextMeshProUGUI)

local function OnCreate(self)
  base.OnCreate(self)
  self.unity_text = self.gameObject:GetComponent(UnityText)
  if IsNull(self.unity_text) then
    self.unity_text = nil
    self.unity_tmpro = self.gameObject:GetComponent(UnityTextMeshProEx)
    if IsNull(self.unity_tmpro) then
      self.unity_tmpro = self.gameObject:GetComponent(UnityTextMeshPro)
      if IsNull(self.unity_tmpro) then
      end
      self.unity_tmpro = self.unity_tmpro
    end
  end
end

local function GetText(self)
  if self.unity_text then
    return self.unity_text.text
  elseif self.unity_tmpro then
    return self.unity_tmpro.text
  end
end

local function SetText(self, text)
  if self.unity_text then
    self.unity_text.text = text
  elseif self.unity_tmpro then
    self.unity_tmpro.text = text
  end
end

local function SetTextFormat(self, fmt, ...)
  local txt = string.format(fmt, ...)
  self:SetText(txt)
end

local function SetLocalText(self, dialogId, ...)
  if self.unity_text then
    if dialogId == nil or dialogId == "" then
      self.unity_text.text = ""
    else
      self.unity_text:SetLocalText(dialogId, ...)
    end
  elseif self.unity_tmpro then
    if dialogId == nil or dialogId == "" then
      self.unity_tmpro.text = ""
    else
      self.unity_tmpro:SetLocalText(dialogId, ...)
    end
  end
end

local function OnDestroy(self)
  self.unity_text = nil
  self.unity_tmpro = nil
  base.OnDestroy(self)
end

function UIText:SetColorHex(hexValue)
  self:SetColor(UIUtil.HexToColor(hexValue))
end

local function SetColorRGBA(self, r, g, b, a)
  if self.unity_text then
    self.unity_text:Set_color(r, g, b, a)
  elseif self.unity_tmpro then
    local color = Color.New(r, g, b, a)
    self.unity_tmpro.color = color
  end
end

local function SetColorRGBA255(self, r, g, b, a)
  if self.unity_text then
    self.unity_text:Set_color(r / 255, g / 255, b / 255, a / 255)
  elseif self.unity_tmpro then
    local color = Color.New(r / 255, g / 255, b / 255, a / 255)
    self.unity_tmpro.color = color
  end
end

local function SetColor(self, value)
  if self.unity_text then
    self.unity_text:Set_color(value.r, value.g, value.b, value.a)
  elseif self.unity_tmpro then
    self.unity_tmpro.color = value
  end
end

local function SetAlpha(self, alpha)
  if self.unity_text then
    local r, g, b = self.unity_text:Get_color()
    self.unity_text:Set_color(r, g, b, alpha)
  elseif self.unity_tmpro then
    local value = self.unity_tmpro.color
    value.a = alpha
    self.unity_tmpro.color = value
  end
end

local function GetColor(self)
  if self.unity_text then
    local r, g, b, a = self:GetColorRGBA()
    return Color.New(r, g, b, a)
  elseif self.unity_tmpro then
    return self.unity_tmpro.color
  end
end

local function GetColorRGBA(self)
  if self.unity_text then
    return self.unity_text:Get_color()
  elseif self.unity_tmpro then
    return self.unity_tmpro.color.r, self.unity_tmpro.color.g, self.unity_tmpro.color.b, self.unity_tmpro.color.a
  end
end

local function GetWidth(self)
  if self.unity_text then
    return self.unity_text.preferredWidth
  elseif self.unity_tmpro then
    return self.unity_tmpro.preferredWidth
  end
end

local function GetHeight(self)
  if self.unity_text then
    return self.unity_text.preferredHeight
  elseif self.unity_tmpro then
    return self.unity_tmpro.preferredHeight
  end
end

function UIText:SetAlignment(_alignment)
  if self.unity_text then
    self.unity_text.alignment = _alignment
  elseif self.unity_tmpro then
    self.unity_tmpro.alignment = CS.TextMeshProUGUIEx.ConvertAlignFormat(_alignment, false)
  end
end

local function SetPreferSize(self, value)
  self.rectTransform:Set_sizeDelta(value.x, value.y)
end

local function DOText(self, value, duration)
  if self.unity_text then
    return self.unity_text:DOText(value, duration)
  elseif self.unity_tmpro then
    if self.unity_tmpro.DOText then
      return self.unity_tmpro:DOText(value, duration)
    else
      local tempText = ""
      local tween = DOTween.To(function()
        return tempText
      end, function(str)
        tempText = str
      end, value, duration):OnUpdate(function()
        self:SetText(tempText)
      end)
      return tween
    end
  end
end

function UIText:SetFontSize(fontSize)
  if self.unity_text then
    self.unity_text.fontSize = fontSize
  elseif self.unity_tmpro then
    self.unity_tmpro.fontSize = fontSize
  end
end

function UIText:GetFontSize()
  if self.unity_text then
    return self.unity_text.fontSize
  elseif self.unity_tmpro then
    return self.unity_tmpro.fontSize
  end
  return 24
end

local function SetBestFitEnable(self, enable)
  if self.unity_text then
    self.unity_text.resizeTextForBestFit = enable
  elseif self.unity_tmpro then
    self.unity_tmpro.enableAutoSizing = enable
  end
end

local function DOFade(self, value, duration)
  if self.unity_text then
    return self.unity_text:DOFade(value, duration)
  elseif self.unity_tmpro then
    return self.unity_tmpro:DOFade(value, duration)
  end
end

local function ForceUpdate(self)
  if self.unity_text then
  elseif self.unity_tmpro then
    self.unity_tmpro:ForceMeshUpdate()
  end
end

local function SetBestFitMinSize(self, minSize)
  if self.unity_text then
    self.unity_text.resizeTextMinSize = minSize
  elseif self.unity_tmpro then
    self.unity_tmpro.fontSizeMin = minSize
  end
end

local function SetBestFitMaxSize(self, maxSize)
  if self.unity_text then
    self.unity_text.resizeTextMaxSize = maxSize
  elseif self.unity_tmpro then
    self.unity_tmpro.fontSizeMax = maxSize
  end
end

local function SetEnable(self, enable)
  if self.unity_text then
    self.unity_text.enabled = enable
  elseif self.unity_tmpro then
    self.unity_tmpro.enabled = enable
  end
end

local function HasTextComponent(self)
  return self.unity_text ~= nil or self.unity_tmpro ~= nil
end

local function SetSupportSpriteTagOnly(self, isOn)
  if not IsNull(self.unity_tmpro) then
    self.unity_tmpro.supportSpriteTagOnly = isOn
  end
end

local function SetSupportSpriteEmoji(self, isOn)
  if not IsNull(self.unity_tmpro) then
    self.unity_tmpro.supportSpriteEmoji = isOn
  end
end

UIText.OnCreate = OnCreate
UIText.GetText = GetText
UIText.SetText = SetText
UIText.SetTextFormat = SetTextFormat
UIText.OnDestroy = OnDestroy
UIText.SetColor = SetColor
UIText.SetAlpha = SetAlpha
UIText.GetWidth = GetWidth
UIText.GetHeight = GetHeight
UIText.SetPreferSize = SetPreferSize
UIText.GetColor = GetColor
UIText.SetLocalText = SetLocalText
UIText.SetColorRGBA = SetColorRGBA
UIText.SetColorRGBA255 = SetColorRGBA255
UIText.GetColorRGBA = GetColorRGBA
UIText.DOText = DOText
UIText.SetBestFitEnable = SetBestFitEnable
UIText.DOFade = DOFade
UIText.SetBestFitMinSize = SetBestFitMinSize
UIText.SetBestFitMaxSize = SetBestFitMaxSize
UIText.SetEnable = SetEnable
UIText.HasTextComponent = HasTextComponent
UIText.ForceUpdate = ForceUpdate
UIText.SetSupportSpriteTagOnly = SetSupportSpriteTagOnly
UIText.SetSupportSpriteEmoji = SetSupportSpriteEmoji
return UIText
