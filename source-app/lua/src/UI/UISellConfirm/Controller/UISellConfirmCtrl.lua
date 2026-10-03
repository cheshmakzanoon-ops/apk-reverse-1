local UISellConfirmCtrl = BaseClass("UISellConfirmCtrl", UIBaseCtrl)
local Setting = CS.GameEntry.Setting

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISellConfirm)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function OnCheckBoxClick(self, isSelected)
  local needSellConfirm = not isSelected
  DataCenter.ResourceItemDataManager:SetSellConfirmFlag(needSellConfirm)
end

local function OnConfirmClick(self, uuid, num)
  SFSNetwork.SendMessage(MsgDefines.SoldResourceItem, uuid, num)
  self.CloseSelf()
end

local function OnCancelClick(self)
  self.CloseSelf()
end

UISellConfirmCtrl.CloseSelf = CloseSelf
UISellConfirmCtrl.Close = Close
UISellConfirmCtrl.OnCheckBoxClick = OnCheckBoxClick
UISellConfirmCtrl.OnConfirmClick = OnConfirmClick
UISellConfirmCtrl.OnCancelClick = OnCancelClick
return UISellConfirmCtrl
