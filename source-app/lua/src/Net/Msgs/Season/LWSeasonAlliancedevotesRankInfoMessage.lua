local LWSeasonAlliancedevotesRankInfoMessage = BaseClass("LWSeasonAlliancedevotesRankInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, eventId, subType, startIndex, endIndex)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("event_id", tostring(eventId))
  self.sfsObj:PutInt("day", tonumber(subType))
  self.sfsObj:PutInt("start", tonumber(startIndex))
  self.sfsObj:PutInt("end", tonumber(endIndex))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.SeasonAllianceRankDataManager:UpdataRankData(t)
end

LWSeasonAlliancedevotesRankInfoMessage.OnCreate = OnCreate
LWSeasonAlliancedevotesRankInfoMessage.HandleMessage = HandleMessage
return LWSeasonAlliancedevotesRankInfoMessage
