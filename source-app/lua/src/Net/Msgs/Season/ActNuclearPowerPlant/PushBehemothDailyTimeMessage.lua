local PushBehemothDailyTimeMessage = BaseClass("PushBehemothDailyTimeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
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
  if t and t.userBehemothDailyTimeInfo then
    local temp = {}
    temp.userBehemothDailyTimeArr = {}
    temp.userBehemothDailyTimeArr[1] = t.userBehemothDailyTimeInfo
    DataCenter.SeasonNuclearPowerPlantDataManager:UpdataDailyTime(temp)
  end
end

PushBehemothDailyTimeMessage.OnCreate = OnCreate
PushBehemothDailyTimeMessage.HandleMessage = HandleMessage
return PushBehemothDailyTimeMessage
