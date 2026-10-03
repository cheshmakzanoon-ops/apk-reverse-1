local base = UIAsyncContainer
local UIPositionAddToggleBase = BaseClass("UIPositionAddToggleBase", UIAsyncContainer)
local Localization = CS.GameEntry.Localization

function UIPositionAddToggleBase:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIPositionAddToggleBase:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIPositionAddToggleBase:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.toggle = self.viewSkin:AddComponent(self, UIToggle, 1)
  self.imgType = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textUsed = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
end

function UIPositionAddToggleBase:ComponentDestroy()
  self.viewSkin = nil
  self.toggle = nil
  self.imgType = nil
  self.textUsed = nil
end

function UIPositionAddToggleBase:DataDefine()
  self.textUsed:SetLocalText(312097)
  self.toggle:SetOnValueChanged(function(state)
    if state and self.cb then
      self.cb(self.index)
    end
  end)
end

function UIPositionAddToggleBase:DataDestroy()
  self.index = nil
  self.cb = nil
  self.selecting = nil
  self.tipActive = nil
  self.iconPath = nil
end

function UIPositionAddToggleBase:OnAddListener()
  base.OnAddListener(self)
end

function UIPositionAddToggleBase:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIPositionAddToggleBase:SetData(index, cb)
  self.index = index
  self.cb = cb
  self:RefreshView()
end

function UIPositionAddToggleBase:SetIsOn(tf)
  self.selecting = tf
  self:RefreshView()
end

function UIPositionAddToggleBase:SetTipActive(tipActive)
  self.tipActive = tipActive
  self:RefreshView()
end

function UIPositionAddToggleBase:SetIconSprite(iconPath)
  self.iconPath = iconPath
  self:RefreshView()
end

function UIPositionAddToggleBase:UpdateData()
  if self.selecting ~= nil then
    self.toggle:SetIsOn(self.selecting)
    self.selecting = nil
  end
  if self.tipActive ~= nil then
    self.textUsed:SetActive(self.tipActive)
    self.tipActive = nil
  end
  if self.iconPath ~= nil then
    self.imgType:LoadSpriteAuto(self.iconPath)
    self.iconPath = nil
  end
end

return UIPositionAddToggleBase
