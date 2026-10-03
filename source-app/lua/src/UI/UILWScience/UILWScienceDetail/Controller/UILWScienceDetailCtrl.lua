local UILWScienceDetailCtrl = BaseClass("UILWScienceDetailCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function SetView(self, view)
  self.view = view
end

local function ClearView(self)
  self.view = nil
end

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWScienceDetail)
end

UILWScienceDetailCtrl.SetView = SetView
UILWScienceDetailCtrl.ClearView = ClearView
UILWScienceDetailCtrl.CloseSelf = CloseSelf
return UILWScienceDetailCtrl
