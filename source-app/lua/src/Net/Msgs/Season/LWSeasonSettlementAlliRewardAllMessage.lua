local LWSeasonSettlementAlliRewardAllMessage = BaseClass("LWSeasonSettlementAlliRewardAllMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  UIUtil.ShowTipsId("season_extra_tips_12")
  DataCenter.SeasonRewardDataManager:UpdateAllianceSettlementAlliRewardAll(t)
end

LWSeasonSettlementAlliRewardAllMessage.OnCreate = OnCreate
LWSeasonSettlementAlliRewardAllMessage.HandleMessage = HandleMessage
return LWSeasonSettlementAlliRewardAllMessage
