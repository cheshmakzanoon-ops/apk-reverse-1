local SeasonPhotoCanvaCtrl = BaseClass("SeasonPhotoCanvaCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIUtil.ShowConfirmNew({
    contentText = CS.GameEntry.Localization:GetString("season_alliance_photo_tips_36"),
    btnNum = 2,
    showToggle = false,
    confirmBtnParam = {
      action = function()
        UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonPhotoCanva)
      end
    }
  })
end

local function OnCustomKeyCodeEscape(self)
  self:CloseSelf()
end

SeasonPhotoCanvaCtrl.CloseSelf = CloseSelf
SeasonPhotoCanvaCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
return SeasonPhotoCanvaCtrl
