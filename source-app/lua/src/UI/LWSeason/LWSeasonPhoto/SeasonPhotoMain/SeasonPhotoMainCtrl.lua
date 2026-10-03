local SeasonPhotoMainCtrl = BaseClass("SeasonPhotoMainCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonPhotoMain)
end

SeasonPhotoMainCtrl.CloseSelf = CloseSelf
return SeasonPhotoMainCtrl
