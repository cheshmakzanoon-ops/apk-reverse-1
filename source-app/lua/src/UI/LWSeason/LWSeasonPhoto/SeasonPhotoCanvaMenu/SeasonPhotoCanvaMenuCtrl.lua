local SeasonPhotoCanvaMenuCtrl = BaseClass("SeasonPhotoCanvaMenuCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonPhotoCanvaMenuView)
end

SeasonPhotoCanvaMenuCtrl.CloseSelf = CloseSelf
return SeasonPhotoCanvaMenuCtrl
