local NuclearRankViewMessage = BaseClass("NuclearRankViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, rankType)
  base.OnCreate(self)
  self.sfsObj:PutInt("rankType", rankType)
  self.sfsObj:PutInt("activityId", activityId)
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
  DataCenter.SeasonNuclearPowerPlantDataManager:UpdateRankData(t)
end

NuclearRankViewMessage.OnCreate = OnCreate
NuclearRankViewMessage.HandleMessage = HandleMessage
return NuclearRankViewMessage
