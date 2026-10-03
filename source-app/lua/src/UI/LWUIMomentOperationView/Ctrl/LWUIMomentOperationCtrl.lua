local LWUIMomentOperationCtrl = BaseClass("LWUIMomentOperationCtrl", UIBaseCtrl)
local opList = {
  {
    key = "moment_range_set",
    OptionType = MomentOperationBtnType.RangeSet,
    line = 1
  },
  {
    key = "btn_delete",
    OptionType = MomentOperationBtnType.Delete,
    line = 2
  },
  {
    key = "btn_cancel",
    OptionType = MomentOperationBtnType.Close
  }
}

function LWUIMomentOperationCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMomentOperation)
end

function LWUIMomentOperationCtrl:GetOpList()
  return opList
end

return LWUIMomentOperationCtrl
