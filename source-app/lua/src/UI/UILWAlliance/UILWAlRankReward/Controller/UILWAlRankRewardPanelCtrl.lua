local UILWAlRankRewardPanelCtrl = BaseClass("UILWAlRankRewardPanelCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UILWAlRankRewardPanel, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllShow
  })
end

UILWAlRankRewardPanelCtrl.CloseSelf = CloseSelf
return UILWAlRankRewardPanelCtrl
