local UILWAlMemberManagerCtrl = BaseClass("UILWAlMemberManagerCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function SetView(self, view)
  self.view = view
end

local function ClearView(self)
  self.view = nil
end

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAlMemberManager)
end

local function OnDriveOut(self, uid)
  local memberData = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(uid)
  local message = Localization:GetString("390094", memberData.name)
  UIUtil.ShowMessage(message, 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    SFSNetwork.SendMessage(MsgDefines.AllianceKickMember, uid)
  end, function()
  end)
end

UILWAlMemberManagerCtrl.SetView = SetView
UILWAlMemberManagerCtrl.ClearView = ClearView
UILWAlMemberManagerCtrl.CloseSelf = CloseSelf
UILWAlMemberManagerCtrl.OnDriveOut = OnDriveOut
return UILWAlMemberManagerCtrl
