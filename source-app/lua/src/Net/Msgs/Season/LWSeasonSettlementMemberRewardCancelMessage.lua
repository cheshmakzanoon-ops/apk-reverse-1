local LWSeasonSettlementMemberRewardCancelMessage = BaseClass("LWSeasonSettlementMemberRewardCancelMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uid, type)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("uid", tostring(uid))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonRewardDataManager:UpdateAllianceSettlementMemberRewardCancel(t)
end

LWSeasonSettlementMemberRewardCancelMessage.OnCreate = OnCreate
LWSeasonSettlementMemberRewardCancelMessage.HandleMessage = HandleMessage
return LWSeasonSettlementMemberRewardCancelMessage
