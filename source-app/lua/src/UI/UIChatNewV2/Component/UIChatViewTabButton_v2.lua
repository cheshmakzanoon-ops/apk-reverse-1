local base = UIBaseContainer
local UIChatViewTabButton_v2 = BaseClass("UIChatViewTabButton_v2", base)
local UIAdaptReddot = require("UI.UICommon.Component.UIAdaptReddot")
local Localization = CS.GameEntry.Localization
local compBook = {
  {
    path = "",
    name = "btnTab",
    type = UIButton,
    onClick = function(self)
      self:OnClick()
    end
  },
  {
    path = "txtOff",
    name = "txtOff",
    type = UITextMeshProUGUIEx
  },
  {
    path = "imgOn",
    name = "imgOn",
    type = UIImage,
    active = false
  },
  {
    path = "imgOn/txtOn",
    name = "txtOn",
    type = UITextMeshProUGUIEx
  },
  {
    path = "reddot",
    name = "reddot",
    type = UIAdaptReddot,
    active = false
  }
}

function UIChatViewTabButton_v2:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:SetIsOn(false)
end

function UIChatViewTabButton_v2:OnDestroy()
  self.data = nil
  self.onClick = nil
  self.onValueChanged = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChatViewTabButton_v2:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.btnTab.Mute = true
  if self.transform:Find("lineIcon") then
    self.lineIcon = self:AddComponent(UIImage, "lineIcon")
    self.lineIcon:SetActive(false)
  end
end

function UIChatViewTabButton_v2:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIChatViewTabButton_v2:SetData(data)
  self.data = data
end

function UIChatViewTabButton_v2:SetText(text, isKey)
  self.txtOff:SetText(isKey and Localization:GetString(text) or text)
  self.txtOn:SetText(isKey and Localization:GetString(text) or text)
end

function UIChatViewTabButton_v2:SetIsOn(isOn)
  if self.isOn == isOn then
    return
  end
  self.isOn = isOn
  self.imgOn:SetActive(isOn)
  if self.onValueChanged then
    if self.onValueChanged[2] then
      self.onValueChanged[1](self.onValueChanged[2], self)
    else
      self.onValueChanged[1](self)
    end
  end
end

function UIChatViewTabButton_v2:SetOnClick(callback, caller)
  self.onClick = {callback, caller}
end

function UIChatViewTabButton_v2:SetOnValueChanged(callback, caller)
  self.onValueChanged = {callback, caller}
end

function UIChatViewTabButton_v2:SetRedDotType(redDotType)
  self.reddot:SetRedDotType(redDotType)
end

function UIChatViewTabButton_v2:SetReddotNumber(num)
  self.reddot:SetNumber(num)
end

function UIChatViewTabButton_v2:OnClick()
  if self.isOn == true then
    return
  end
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_SelectTab, false)
  if self.onClick then
    if self.onClick[2] then
      self.onClick[1](self.onClick[2], self)
    else
      self.onClick[1](self)
    end
  end
  self:SetIsOn(true)
end

function UIChatViewTabButton_v2:SetCountLine(active)
  if self.lineIcon then
    self.lineIcon:SetActive(active)
  end
end

return UIChatViewTabButton_v2
