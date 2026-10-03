local GetSeasonWeekCardInfoMessage = BaseClass("GetSeasonWeekCardInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActSeasonWeekCardData:ParseActivityData(t)
  end
end

GetSeasonWeekCardInfoMessage.OnCreate = OnCreate
GetSeasonWeekCardInfoMessage.HandleMessage = HandleMessage
return GetSeasonWeekCardInfoMessage
