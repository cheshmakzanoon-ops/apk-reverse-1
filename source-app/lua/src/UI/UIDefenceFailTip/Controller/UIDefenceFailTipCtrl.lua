local UIDefenceFailTipCtrl = BaseClass("UIDefenceFailTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIDefenceFailTip)
  DataCenter.AllianceHelpVirtualMarchManager:ShowVirtualMarches()
  GoToUtil.GotoPos(SceneUtils.TileToWorld(DataCenter.BuildManager.main_city_pos), 61)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIDefenceFailTipCtrl.CloseSelf = CloseSelf
UIDefenceFailTipCtrl.Close = Close
return UIDefenceFailTipCtrl
