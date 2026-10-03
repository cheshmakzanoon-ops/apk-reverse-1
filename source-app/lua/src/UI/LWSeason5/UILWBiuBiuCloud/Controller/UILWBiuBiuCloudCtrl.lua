local UILWBiuBiuCloudCtrl = BaseClass("UILWBiuBiuCloudCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWBiuBiuCloud, {anim = true})
end

local function OnCustomKeyCodeEscape(self)
end

UILWBiuBiuCloudCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
UILWBiuBiuCloudCtrl.CloseSelf = CloseSelf
return UILWBiuBiuCloudCtrl
