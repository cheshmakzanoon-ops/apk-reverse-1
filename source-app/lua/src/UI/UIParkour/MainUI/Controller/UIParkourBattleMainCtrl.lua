local UIParkourBattleMainCtrl = BaseClass("UIZombieBattleMainCtrl", UIBaseCtrl)

function UIParkourBattleMainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIParkourBattleMain, {anim = false})
end

function UIParkourBattleMainCtrl:InitData(self)
end

function UIParkourBattleMainCtrl:UseNewLogin()
  return LuaEntry.DataConfig:CheckSwitch("login_ui_new")
end

return UIParkourBattleMainCtrl
