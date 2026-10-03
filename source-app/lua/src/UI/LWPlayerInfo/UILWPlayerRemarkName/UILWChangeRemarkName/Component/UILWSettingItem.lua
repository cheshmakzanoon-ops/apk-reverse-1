local UILWSettingItem = BaseClass("UILWSettingItem", UIBaseContainer)
local UIPushSettingsSlider = require("UI.UIChatNew.UIPushSettings.Component.UIPushSettingsSlider")
local ChatMessage = require("Chat.Model.ChatMessage")
local base = UIBaseContainer

function UILWSettingItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:ReInit()
end

function UILWSettingItem:OnAddListener()
  base.OnAddListener(self)
end

function UILWSettingItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWSettingItem:ComponentDefine()
  if self.transform:Find("Text") then
    self.text = self:AddComponent(UIText, "Text")
  end
  if self.transform:Find("Btn") then
    self.btn = self:AddComponent(UIButton, "Btn")
  end
  if self.transform:Find("slider") then
    self.slider = self:AddComponent(UIPushSettingsSlider, "slider")
  end
  if self.transform:Find("txtDesc") then
    self.desText = self:AddComponent(UIText, "txtDesc")
  end
  self.slider:Switch(false)
  
  function self.slider.onSwitch(isOn)
    self:OnSliderSwitched(isOn)
  end
  
  if self.btn then
    self.btn:SetOnClick(function()
      self:OnClick()
    end)
  end
end

function UILWSettingItem:OnSliderSwitched(isOn)
  self.data.newIsOn = isOn
end

function UILWSettingItem:OnClick()
  if self.data.type == PlayerDetailBottomBtnType.Report then
    local chatData = ChatMessage.New()
    chatData.senderUid = self.view.playerUid
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatReport, {anim = true}, {
      type = ReportType.player,
      chatData = chatData
    })
  end
end

function UILWSettingItem:ReInit(data, type)
  self.data = data
  if not self.data then
    return
  end
  if self.text and self.data.text then
    self.text:SetLocalText(self.data.text)
  end
  if self.desText and self.data.des then
    self.desText:SetLocalText(self.data.des)
  end
  local isOn = self.data.type == PlayerDetailBottomBtnType.Report
  self.slider:SetActive(not isOn)
  if self.btn then
    self.btn:SetActive(isOn)
  end
  self.slider:Switch(self.data.isOn)
  self.data.newIsOn = self.data.isOn
end

function UILWSettingItem:ComponentDestroy()
  self.notCom = nil
  self.icon = nil
  self.text = nil
  self.btn = nil
  self.tip = nil
end

function UILWSettingItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSettingItem:DataDestroy()
  self.data = nil
  self.config = nil
end

function UILWSettingItem:GetIsOn()
end

return UILWSettingItem
