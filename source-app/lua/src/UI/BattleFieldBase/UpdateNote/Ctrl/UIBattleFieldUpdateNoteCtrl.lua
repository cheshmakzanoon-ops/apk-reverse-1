local UIBattleFieldUpdateNoteCtrl = BaseClass("UIBattleFieldUpdateNoteCtrl", UIBaseCtrl)

function UIBattleFieldUpdateNoteCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBattleFieldUpDateNote, {anim = true})
end

return UIBattleFieldUpdateNoteCtrl
