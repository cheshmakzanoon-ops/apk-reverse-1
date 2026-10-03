local ActivityDetectListMessage = BaseClass("ActivityDetectListMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, red_point)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  if red_point then
    self.sfsObj:PutInt("red_point", red_point)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActDetectTreasureDataManager:OnGetArrDataMsg(t)
  EventManager:GetInstance():Broadcast(EventId.ActDetectTreasureInfoGet)
end

ActivityDetectListMessage.OnCreate = OnCreate
ActivityDetectListMessage.HandleMessage = HandleMessage
return ActivityDetectListMessage
