local UIBuildingPersonalFurnaceCtrl = BaseClass("UIBuildingPersonalFurnaceCtrl", UIBaseCtrl)

function UIBuildingPersonalFurnaceCtrl:CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBuildingPersonalFurnace)
end

return UIBuildingPersonalFurnaceCtrl
