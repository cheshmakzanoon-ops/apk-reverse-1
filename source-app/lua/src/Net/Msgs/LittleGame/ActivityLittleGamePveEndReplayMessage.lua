local ActivityLittleGamePveEndReplayMessage = BaseClass("ActivityLittleGamePveEndReplayMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, bid, replayData, battleTimeMills, version, stageCfgId, activityType)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("bid", bid)
  self.sfsObj:PutUtfString("data", replayData)
  self.sfsObj:PutLong("costTimeInMills", battleTimeMills)
  self.sfsObj:PutUtfString("version", version)
  self.sfsObj:PutUtfString("stageCfgId", stageCfgId)
  self.sfsObj:PutInt("activityType", activityType)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWGGGoDataManager:UpdateInfo(t)
  end
end

ActivityLittleGamePveEndReplayMessage.OnCreate = OnCreate
ActivityLittleGamePveEndReplayMessage.HandleMessage = HandleMessage
return ActivityLittleGamePveEndReplayMessage
