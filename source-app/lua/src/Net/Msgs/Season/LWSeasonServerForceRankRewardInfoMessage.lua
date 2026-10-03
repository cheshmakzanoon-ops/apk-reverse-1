local LWSeasonServerForceRankRewardInfoMessage = BaseClass("LWSeasonServerForceRankRewardInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, nextSeason)
  base.OnCreate(self)
  self.sfsObj:PutBool("nextSeason", nextSeason == true)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.SeasonRewardDataManager:ServerCrossForceRankRewardInfoUpdate(t)
end

LWSeasonServerForceRankRewardInfoMessage.OnCreate = OnCreate
LWSeasonServerForceRankRewardInfoMessage.HandleMessage = HandleMessage
return LWSeasonServerForceRankRewardInfoMessage
