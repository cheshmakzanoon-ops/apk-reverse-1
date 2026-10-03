local LWSeasonAllianceDevotesAllocationMessage = BaseClass("LWSeasonAllianceDevotesAllocationMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, eventId, subType, uid, count)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("event_id", tostring(eventId))
  self.sfsObj:PutInt("day", tonumber(subType))
  self.sfsObj:PutUtfString("to_uid", tostring(uid))
  self.sfsObj:PutInt("count", tonumber(count))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  local str = Localization:GetString("season_tips141")
  UIUtil.ShowTips(str)
  DataCenter.SeasonAllianceRankDataManager:DevotesAllocationHandle(t)
end

LWSeasonAllianceDevotesAllocationMessage.OnCreate = OnCreate
LWSeasonAllianceDevotesAllocationMessage.HandleMessage = HandleMessage
return LWSeasonAllianceDevotesAllocationMessage
