local base = UIBaseContainer
local UIGMSwitchViewItem = BaseClass("UIGMSwitchViewItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIGMSwitchViewItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIGMSwitchViewItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGMSwitchViewItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textTmpName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compImgFalse = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.compImgTrue = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.btnSwitch = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnSwitch:SetOnClick(function()
    self:OnBtnSwitchClick()
  end)
end

function UIGMSwitchViewItem:ComponentDestroy()
  self.viewSkin = nil
  self.imgBg = nil
  self.textTmpName = nil
  self.compImgFalse = nil
  self.compImgTrue = nil
  self.btnSwitch = nil
end

function UIGMSwitchViewItem:DataDefine()
end

function UIGMSwitchViewItem:DataDestroy()
end

function UIGMSwitchViewItem:OnAddListener()
  base.OnAddListener(self)
end

function UIGMSwitchViewItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIGMSwitchViewItem:ReInit(index, data)
  self.switchData = data
  self.textTmpName:SetText(self.switchData.key)
  self.imgBg:SetActive(index % 2 == 0)
  local switchOn = self.switchData.val == 1
  self.compImgTrue:SetActive(switchOn)
  self.compImgFalse:SetActive(not switchOn)
end

function UIGMSwitchViewItem:OnBtnSwitchClick()
  if not self.switchData then
    return
  end
  local switchOn = self.switchData.val == 1
  switchOn = not switchOn
  LuaEntry.DataConfig:GMManualSetSwitch(self.switchData.key, switchOn)
  switchOn = LuaEntry.DataConfig:CheckSwitch(self.switchData.key)
  self.switchData.val = switchOn and 1 or 0
  self.compImgTrue:SetActive(switchOn)
  self.compImgFalse:SetActive(not switchOn)
end

return UIGMSwitchViewItem
