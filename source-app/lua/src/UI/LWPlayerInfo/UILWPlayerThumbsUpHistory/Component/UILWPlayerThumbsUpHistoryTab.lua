local UILWPlayerThumbsUpHistoryTab = BaseClass("UILWPlayerThumbsUpHistoryTab", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIAdaptReddot = require("UI.UICommon.Component.UIAdaptReddot")
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

function UILWPlayerThumbsUpHistoryTab:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:SetIsOn(false)
end

function UILWPlayerThumbsUpHistoryTab:OnDestroy()
  self.data = nil
  self.onClick = nil
  self.onValueChanged = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWPlayerThumbsUpHistoryTab:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function UILWPlayerThumbsUpHistoryTab:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UILWPlayerThumbsUpHistoryTab:SetData(data)
  self.data = data
end

function UILWPlayerThumbsUpHistoryTab:SetText(text, isKey)
  self.txtOff:SetText(isKey and Localization:GetString(text) or text)
  self.txtOn:SetText(isKey and Localization:GetString(text) or text)
end

function UILWPlayerThumbsUpHistoryTab:SetIsOn(isOn)
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

function UILWPlayerThumbsUpHistoryTab:SetOnClick(callback, caller)
  self.onClick = {callback, caller}
end

function UILWPlayerThumbsUpHistoryTab:SetOnValueChanged(callback, caller)
  self.onValueChanged = {callback, caller}
end

function UILWPlayerThumbsUpHistoryTab:SetReddotNumber(num)
  self.reddot:SetNumber(num)
end

function UILWPlayerThumbsUpHistoryTab:OnClick()
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

return UILWPlayerThumbsUpHistoryTab
