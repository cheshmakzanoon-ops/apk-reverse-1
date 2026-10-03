local UIMasterySkillUseResultShowCtrl = BaseClass("UIMasterySkillUseResultShowCtrl", UIBaseCtrl)

function UIMasterySkillUseResultShowCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.UIMasterySkillUseResultShow)
end

return UIMasterySkillUseResultShowCtrl
