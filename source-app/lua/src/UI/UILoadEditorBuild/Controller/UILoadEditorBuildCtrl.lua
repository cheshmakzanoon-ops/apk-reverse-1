local UILoadEditorBuildCtrl = BaseClass("UILoadEditorBuildCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILoadEditorBuild)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UILoadEditorBuildCtrl.CloseSelf = CloseSelf
return UILoadEditorBuildCtrl
