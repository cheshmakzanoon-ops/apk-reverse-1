local GetSevenDayV2ActInfoMessage = BaseClass("GetSevenDayV2ActInfoMessage", SFSBaseMessage)
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
    DataCenter.ActSevenDayV2Data:ParseActivityData(t)
  end
end

GetSevenDayV2ActInfoMessage.OnCreate = OnCreate
GetSevenDayV2ActInfoMessage.HandleMessage = HandleMessage
return GetSevenDayV2ActInfoMessage
