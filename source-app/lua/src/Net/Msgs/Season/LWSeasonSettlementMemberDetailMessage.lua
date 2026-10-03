local LWSeasonSettlementMemberDetailMessage = BaseClass("LWSeasonSettlementMemberDetailMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uid, eventids)
  base.OnCreate(self)
  self.sfsObj:PutIntArray("eventIds", eventids)
  self.sfsObj:PutUtfString("uid", tostring(uid))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonRewardDataManager:UpdateAllianceReweardMemberDetailInfo(t)
end

LWSeasonSettlementMemberDetailMessage.OnCreate = OnCreate
LWSeasonSettlementMemberDetailMessage.HandleMessage = HandleMessage
return LWSeasonSettlementMemberDetailMessage
