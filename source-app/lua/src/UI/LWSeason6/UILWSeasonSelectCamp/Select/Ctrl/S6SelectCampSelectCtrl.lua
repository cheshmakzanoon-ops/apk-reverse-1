local S6SelectCampSelectCtrl = BaseClass("S6SelectCampSelectCtrl", UIBaseCtrl)

function S6SelectCampSelectCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.S6SelectCampSelectView)
end

function S6SelectCampSelectCtrl:SendSelectCamp(selectId)
  local odlSelectId = DataCenter.SeasonSelectCampManager:GetCurSelectId()
  if odlSelectId == selectId then
    UIUtil.ShowTipsId("season_s6_activity_1200080_desc15")
    return
  end
  if DataCenter.SeasonSelectCampManager:SendSelect(selectId, true) then
    self:CloseSelf()
  end
end

return S6SelectCampSelectCtrl
