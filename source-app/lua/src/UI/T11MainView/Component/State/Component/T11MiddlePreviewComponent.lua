local base = UIBaseContainer
local T11MiddlePreviewComponent = BaseClass("T11MiddlePreviewComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function T11MiddlePreviewComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function T11MiddlePreviewComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11MiddlePreviewComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPreView = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPreView:SetOnClick(function()
    self:OnBtnPreViewClick()
  end)
end

function T11MiddlePreviewComponent:ComponentDestroy()
  self.viewSkin = nil
  self.btnPreView = nil
end

function T11MiddlePreviewComponent:DataDefine()
end

function T11MiddlePreviewComponent:DataDestroy()
end

function T11MiddlePreviewComponent:OnAddListener()
  base.OnAddListener(self)
end

function T11MiddlePreviewComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function T11MiddlePreviewComponent:RefreshView()
end

function T11MiddlePreviewComponent:OnBtnPreViewClick()
  UIManager.Instance:OpenWindow(UIWindowNames.T11SoldierPreviewView)
end

return T11MiddlePreviewComponent
