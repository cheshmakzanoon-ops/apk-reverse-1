local SeasonPhotoCanvaShareCtrl = BaseClass("SeasonPhotoCanvaShareCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonPhotoCanvaShare)
end

SeasonPhotoCanvaShareCtrl.CloseSelf = CloseSelf
return SeasonPhotoCanvaShareCtrl
