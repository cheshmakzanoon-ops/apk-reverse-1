local LWActivityArenaViewOtherCtrl = BaseClass("LWActivityArenaViewOtherCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWActivityArenaViewOther)
end

LWActivityArenaViewOtherCtrl.CloseSelf = CloseSelf
return LWActivityArenaViewOtherCtrl
