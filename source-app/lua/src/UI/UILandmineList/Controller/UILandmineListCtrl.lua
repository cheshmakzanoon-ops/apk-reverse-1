local UILandmineListCtrl = BaseClass("UILandmineListCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UILandmineList, {anim = true})
end

UILandmineListCtrl.CloseSelf = CloseSelf
return UILandmineListCtrl
