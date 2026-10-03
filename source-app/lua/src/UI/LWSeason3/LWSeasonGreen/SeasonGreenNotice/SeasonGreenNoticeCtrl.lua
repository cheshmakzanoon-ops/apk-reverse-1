local SeasonGreenNoticeCtrl = BaseClass("SeasonGreenNoticeCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonGreenNotice)
end

SeasonGreenNoticeCtrl.CloseSelf = CloseSelf
return SeasonGreenNoticeCtrl
