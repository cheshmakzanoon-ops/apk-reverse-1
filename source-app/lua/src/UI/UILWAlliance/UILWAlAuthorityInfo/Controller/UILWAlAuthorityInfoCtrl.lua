local UILWAlAuthorityInfoCtrl = BaseClass("UILWAlAuthorityInfoCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function SetView(self, view)
  self.view = view
end

local function ClearView(self)
  self.view = nil
end

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAlAuthorityInfo)
end

UILWAlAuthorityInfoCtrl.SetView = SetView
UILWAlAuthorityInfoCtrl.ClearView = ClearView
UILWAlAuthorityInfoCtrl.CloseSelf = CloseSelf
return UILWAlAuthorityInfoCtrl
