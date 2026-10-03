local UICampScienceDestroyRecordCtrl = BaseClass("UICampScienceDestroyRecordCtrl", UIBaseCtrl)

function UICampScienceDestroyRecordCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.UICampScienceDestroyRecord)
end

function UICampScienceDestroyRecordCtrl:GetScienceRowList()
  return DataCenter.CampScienceDataManager:GetCampScienceRowList()
end

return UICampScienceDestroyRecordCtrl
