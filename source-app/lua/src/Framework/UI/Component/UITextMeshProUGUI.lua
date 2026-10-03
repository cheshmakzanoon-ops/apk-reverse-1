local UITextMeshProUGUI = BaseClass("UITextMeshProUGUI", UIBaseComponent)
local base = UIBaseComponent
local UnityTextMeshPro = typeof(CS.TMPro.TextMeshProUGUI)

local function OnCreate(self, cs_comp)
  base.OnCreate(self)
  if not cs_comp then
    self.unity_tmpro = self.gameObject:GetComponent(UnityTextMeshPro)
  else
    self.unity_tmpro = cs_comp
  end
end

local function GetText(self)
  return self.unity_tmpro.text
end

local function SetText(self, text)
  self.unity_tmpro:Native_SetText(text)
end

local function OnDestroy(self)
  self.unity_tmpro = nil
  base.OnDestroy(self)
end

local function SetColor(self, value)
  self.unity_tmpro.color = value
end

local function GetColor(self)
  return self.unity_tmpro.color
end

local function GetWidth(self)
  return self.unity_tmpro.preferredWidth
end

local function GetHeight(self)
  return self.unity_tmpro.preferredHeight
end

local function GetLinkInfo(self)
  return self.unity_tmpro.textInfo.linkInfo
end

UITextMeshProUGUI.OnCreate = OnCreate
UITextMeshProUGUI.GetText = GetText
UITextMeshProUGUI.SetText = SetText
UITextMeshProUGUI.OnDestroy = OnDestroy
UITextMeshProUGUI.SetColor = SetColor
UITextMeshProUGUI.GetWidth = GetWidth
UITextMeshProUGUI.GetHeight = GetHeight
UITextMeshProUGUI.GetColor = GetColor
UITextMeshProUGUI.GetLinkInfo = GetLinkInfo
return UITextMeshProUGUI
