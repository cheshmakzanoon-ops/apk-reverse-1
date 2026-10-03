local SeasonSandFishActivityRankMessage = BaseClass("SeasonSandFishActivityRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, type, weekDay)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
  self.sfsObj:PutInt("weekNum", weekDay)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
  else
    DataCenter.SandWormFishingDataManager:HandleSandWormFishingRankList(t)
  end
end

SeasonSandFishActivityRankMessage.OnCreate = OnCreate
SeasonSandFishActivityRankMessage.HandleMessage = HandleMessage
return SeasonSandFishActivityRankMessage
