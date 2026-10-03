local UIAllianceRankSelectCtrl = BaseClass("UIAllianceRankSelectCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceRankSelect)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function OnSetRank(self, uid, index)
  local memberData = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(uid)
  if memberData ~= nil then
    local curRank = memberData.rank
    if index ~= curRank and 0 < index then
      SFSNetwork.SendMessage(MsgDefines.AllianceSetRank, uid, index, 0)
    end
  end
  self:CloseSelf()
end

UIAllianceRankSelectCtrl.CloseSelf = CloseSelf
UIAllianceRankSelectCtrl.Close = Close
UIAllianceRankSelectCtrl.OnSetRank = OnSetRank
return UIAllianceRankSelectCtrl
