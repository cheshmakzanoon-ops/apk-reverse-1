local S6SelectCampIntroCtrl = BaseClass(" S6SelectCampIntroCtrl", UIBaseCtrl)

function S6SelectCampIntroCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.S6SelectCampIntroView)
end

return S6SelectCampIntroCtrl
