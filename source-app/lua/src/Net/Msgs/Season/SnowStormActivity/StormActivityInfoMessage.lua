local StormActivityInfoMessage = BaseClass("StormActivityInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.SeasonSnowStormDataManager:UpdateActivityData(t)
end

StormActivityInfoMessage.OnCreate = OnCreate
StormActivityInfoMessage.HandleMessage = HandleMessage
return StormActivityInfoMessage
