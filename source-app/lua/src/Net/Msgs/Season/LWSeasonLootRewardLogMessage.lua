local LWSeasonLootRewardLogMessage = BaseClass("LWSeasonLootRewardLogMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, page_num, page_size)
  base.OnCreate(self)
  self.sfsObj:PutInt("page_num", page_num)
  self.sfsObj:PutInt("page_size", page_size)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.SeasonAllianceRankDataManager:SeasonLootRewardLogHandle(t)
end

LWSeasonLootRewardLogMessage.OnCreate = OnCreate
LWSeasonLootRewardLogMessage.HandleMessage = HandleMessage
return LWSeasonLootRewardLogMessage
