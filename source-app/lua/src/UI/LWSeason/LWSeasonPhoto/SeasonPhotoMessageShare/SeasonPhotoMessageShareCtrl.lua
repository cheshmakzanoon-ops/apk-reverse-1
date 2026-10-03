local SeasonPhotoMessageShareCtrl = BaseClass("SeasonPhotoMessageShareCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonPhotoMessageShare)
end

SeasonPhotoMessageShareCtrl.CloseSelf = CloseSelf
return SeasonPhotoMessageShareCtrl
