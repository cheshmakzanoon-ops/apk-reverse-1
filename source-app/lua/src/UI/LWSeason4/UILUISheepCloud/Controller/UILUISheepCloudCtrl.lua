local UILUISheepCloudCtrl = BaseClass("UILUISheepCloudCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILUISheepCloud, {anim = true})
end

local function OnCustomKeyCodeEscape(self)
end

UILUISheepCloudCtrl.CloseSelf = CloseSelf
UILUISheepCloudCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
return UILUISheepCloudCtrl
