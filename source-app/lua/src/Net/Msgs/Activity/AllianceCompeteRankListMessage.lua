local AllianceCompeteRankListMessage = BaseClass("AllianceCompeteRankListMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, type, day)
  base.OnCreate(self)
  self.sfsObj:PutLong("type", type)
  if type == AllyDuelRankType.Day then
    local realDay = day or UITimeManager:GetInstance():GetNowWeekdayIndex()
    realDay = math.max(1, realDay)
    realDay = math.min(6, realDay)
    self.sfsObj:PutInt("day", realDay)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.AllianceCompeteDataManager:RefreshRankList(t)
end

AllianceCompeteRankListMessage.OnCreate = OnCreate
AllianceCompeteRankListMessage.HandleMessage = HandleMessage
return AllianceCompeteRankListMessage
