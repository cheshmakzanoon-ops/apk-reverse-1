local ViewBehemothTaskListMessage = BaseClass("ViewBehemothTaskListMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId)
  base.OnCreate(self)
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
  DataCenter.SeasonNuclearPowerPlantDataManager:InitActivityTaskData(t)
end

ViewBehemothTaskListMessage.OnCreate = OnCreate
ViewBehemothTaskListMessage.HandleMessage = HandleMessage
return ViewBehemothTaskListMessage
