local NuclearRankRewardViewMessage = BaseClass("NuclearRankRewardViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, rankType)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", toInt(activityId))
  self.sfsObj:PutInt("rankType", toInt(rankType))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    local msg = ""
    if t.errorMsg then
      msg = t.errorMsg
    end
    return
  end
  DataCenter.SeasonNuclearPowerPlantDataManager:HandleRankRewardInfo(t)
end

NuclearRankRewardViewMessage.OnCreate = OnCreate
NuclearRankRewardViewMessage.HandleMessage = HandleMessage
return NuclearRankRewardViewMessage
