local UIArena3V3BattleResultCtrl = BaseClass("UIArena3V3BattleResultCtrl", UIBaseCtrl)

function UIArena3V3BattleResultCtrl:CloseSelf()
  if not CS.SceneManager.IsInPVE() and UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILW3V3Campaign) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UILW3V3Campaign)
    DataCenter.LWPVPArenaManager.ShowPVPArenaMain(PVPArenaType.Arena3V3, nil)
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIArena3V3BattleResult, {anim = false})
end

function UIArena3V3BattleResultCtrl:OnCustomKeyCodeEscape()
  if not CS.SceneManager.IsInPVE() then
    self:CloseSelf()
  end
end

function UIArena3V3BattleResultCtrl:InitData()
end

return UIArena3V3BattleResultCtrl
