local UILWGGGoCloudCtrl = BaseClass("UILWGGGoCloudCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWGGGoCloud, {anim = true})
end

local function OnCustomKeyCodeEscape(self)
end

UILWGGGoCloudCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
UILWGGGoCloudCtrl.CloseSelf = CloseSelf
return UILWGGGoCloudCtrl
