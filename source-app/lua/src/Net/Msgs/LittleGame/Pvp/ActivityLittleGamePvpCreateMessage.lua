local ActivityLittleGamePvpCreateMessage = BaseClass("ActivityLittleGamePvpCreateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, speak, cost, version, latencies, activityType)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("speak", speak)
  self.sfsObj:PutInt("cost", cost)
  self.sfsObj:PutUtfString("version", version)
  self.sfsObj:PutUtfString("latencies", latencies)
  if activityType == nil then
    activityType = DataCenter.LWGGGoDataManager:GetActivityType()
  end
  self.sfsObj:PutInt("activityType", activityType)
  if DataCenter.LWGGGoDataManager.GMParam ~= nil and not string.IsNullOrEmpty(DataCenter.LWGGGoDataManager.GMParam) then
    self.sfsObj:PutUtfString("preferstagecfgid", DataCenter.LWGGGoDataManager.GMParam)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    UIUtil.ShowTipsId("season_s5_activity_1200045_desc52")
  end
  local room = DataCenter.LWGGGoDataManager:GetRoom(t.activityType)
  room:RespCreate(t, errCode)
end

ActivityLittleGamePvpCreateMessage.OnCreate = OnCreate
ActivityLittleGamePvpCreateMessage.HandleMessage = HandleMessage
return ActivityLittleGamePvpCreateMessage
