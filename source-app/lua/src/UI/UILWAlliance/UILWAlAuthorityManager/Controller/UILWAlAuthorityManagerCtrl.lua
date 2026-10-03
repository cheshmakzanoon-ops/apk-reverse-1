local UILWAlAuthorityManagerCtrl = BaseClass("UILWAlAuthorityManagerCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function SetView(self, view)
  self.view = view
end

local function ClearView(self)
  self.view = nil
end

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAlAuthorityManager)
end

local function OnTransformLeader(self, uid)
  local memberData = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(uid)
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(memberData.uid, memberData.name)
  local message = Localization:GetString("390130", showName)
  UIUtil.ShowMessage(message, 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    if LuaEntry.Player:IsPresident() then
      local msg = Localization:GetString("457091")
      UIUtil.ShowMessage(msg, 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        SFSNetwork.SendMessage(MsgDefines.AllianceLeaderTrans, uid)
      end, function()
      end)
    else
      SFSNetwork.SendMessage(MsgDefines.AllianceLeaderTrans, uid)
    end
  end, function()
  end)
end

local function OnChangeRank(self, uid, type)
  local rankIndex, offcialIndex
  local rankGroup = {
    LWAlMemberAuthorityType.Rank_1,
    LWAlMemberAuthorityType.Rank_2,
    LWAlMemberAuthorityType.Rank_3,
    LWAlMemberAuthorityType.Rank_4
  }
  if table.hasvalue(rankGroup, type) then
    rankIndex = type - 4
    offcialIndex = 0
  else
    rankIndex = 4
    offcialIndex = type
  end
  if rankIndex and offcialIndex then
    DataCenter.AllianceMemberDataManager:SendAllianceSetRank(uid, rankIndex, offcialIndex)
  end
end

local function GetShowList(self, selfRank)
  return LWAlShowAuthorityList[selfRank] or {}
end

UILWAlAuthorityManagerCtrl.SetView = SetView
UILWAlAuthorityManagerCtrl.ClearView = ClearView
UILWAlAuthorityManagerCtrl.CloseSelf = CloseSelf
UILWAlAuthorityManagerCtrl.OnChangeRank = OnChangeRank
UILWAlAuthorityManagerCtrl.GetShowList = GetShowList
UILWAlAuthorityManagerCtrl.OnTransformLeader = OnTransformLeader
return UILWAlAuthorityManagerCtrl
