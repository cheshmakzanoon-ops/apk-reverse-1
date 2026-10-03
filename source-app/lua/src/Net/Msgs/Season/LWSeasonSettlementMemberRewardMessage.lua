local LWSeasonSettlementMemberRewardMessage = BaseClass("LWSeasonSettlementMemberRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uid, type)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
  self.sfsObj:PutUtfString("uid", tostring(uid))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonRewardDataManager:UpdateAllianceSettlementMemberRewardInfo(t)
end

LWSeasonSettlementMemberRewardMessage.OnCreate = OnCreate
LWSeasonSettlementMemberRewardMessage.HandleMessage = HandleMessage
return LWSeasonSettlementMemberRewardMessage
