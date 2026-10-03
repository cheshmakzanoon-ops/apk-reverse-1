local UIStrComScoreDescPanelCtrl = BaseClass("UIStrComScoreDescPanelCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIStrComScoreDescPanel, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllShow
  })
end

UIStrComScoreDescPanelCtrl.CloseSelf = CloseSelf
return UIStrComScoreDescPanelCtrl
