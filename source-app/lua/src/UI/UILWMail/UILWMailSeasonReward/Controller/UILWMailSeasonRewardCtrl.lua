local UILWMailSeasonRewardCtrl = BaseClass("UILWMailSeasonRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UILWMailSeasonRewardView, {anim = true})
end

UILWMailSeasonRewardCtrl.CloseSelf = CloseSelf
return UILWMailSeasonRewardCtrl
