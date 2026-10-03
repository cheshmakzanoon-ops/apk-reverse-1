local UISkirmishMainCtrl = BaseClass("UISkirmishMainCtrl", UIBaseCtrl)

function UISkirmishMainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISkirmishMain, {anim = false})
end

function UISkirmishMainCtrl:InitData(self)
end

function UISkirmishMainCtrl:IsShowBackBtn()
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if logic ~= nil and logic.IsHideSkipBtn ~= nil then
    local isHide = logic:IsHideSkipBtn()
    return not isHide
  end
  return true
end

return UISkirmishMainCtrl
