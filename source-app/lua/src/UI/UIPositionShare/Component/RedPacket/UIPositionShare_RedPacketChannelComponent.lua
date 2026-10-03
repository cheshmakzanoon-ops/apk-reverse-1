local base = UIBaseContainer
local UIPositionShare_RedPacketChannelComponent = BaseClass("UIPositionShare_RedPacketChannelComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIPositionShare_RedPacketChannelComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIPositionShare_RedPacketChannelComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIPositionShare_RedPacketChannelComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.text = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.toggleLW = self.viewSkin:AddComponent(self, UIToggle, 3)
  self.imgCheck = self.viewSkin:AddComponent(self, UIImage, 4)
  self.toggleLW:SetOnValueChanged(function(tf)
    if self.onChangeCallback then
      self.onChangeCallback(tf)
    end
  end)
end

function UIPositionShare_RedPacketChannelComponent:ComponentDestroy()
  self.viewSkin = nil
  self.imgBg = nil
  self.text = nil
  self.toggleLW = nil
  self.imgCheck = nil
end

function UIPositionShare_RedPacketChannelComponent:DataDefine()
end

function UIPositionShare_RedPacketChannelComponent:DataDestroy()
  self.onChangeCallback = nil
end

function UIPositionShare_RedPacketChannelComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIPositionShare_RedPacketChannelComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIPositionShare_RedPacketChannelComponent:ReInit(text, isOn, changeCallback)
  self.text:SetText(text)
  self.toggleLW:SetIsOnWithoutNotify(isOn)
  self.toggleLW:SetInteractable(isOn == false)
  self.onChangeCallback = changeCallback
end

return UIPositionShare_RedPacketChannelComponent
