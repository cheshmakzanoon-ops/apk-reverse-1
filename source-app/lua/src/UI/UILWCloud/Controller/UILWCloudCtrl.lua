local UILWCloudCtrl = BaseClass("UILWCloudCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWCloud, {anim = true})
end

local function OnCustomKeyCodeEscape(self)
end

UILWCloudCtrl.CloseSelf = CloseSelf
UILWCloudCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
return UILWCloudCtrl
