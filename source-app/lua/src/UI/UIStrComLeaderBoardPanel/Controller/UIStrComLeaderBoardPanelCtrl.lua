local UIStrComLeaderBoardPanel = BaseClass("UIStrComLeaderBoardPanel", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIStrComLeaderBoardPanel, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllShow
  })
end

UIStrComLeaderBoardPanel.CloseSelf = CloseSelf
return UIStrComLeaderBoardPanel
