local LWSeasonTrendDonateMessage = BaseClass("LWSeasonTrendDonateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, trendsId, type)
  base.OnCreate(self)
  self.sfsObj:PutInt("trend_id", tonumber(trendsId))
  self.sfsObj:PutInt("type", tonumber(type))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if errCode ~= SeverErrorCode then
      UIUtil.ShowTipsId(errCode)
    end
    return
  end
  local off_seaon = 0
  if t.off_seaon then
    off_seaon = t.off_seaon
  end
  if off_seaon <= 0 then
    DataCenter.LWSeasonTrendsManager:OnTrendDonateMessage(t)
  else
    DataCenter.ActTrendsDataManager:OnTrendDonateMessage(t)
  end
end

LWSeasonTrendDonateMessage.OnCreate = OnCreate
LWSeasonTrendDonateMessage.HandleMessage = HandleMessage
return LWSeasonTrendDonateMessage
