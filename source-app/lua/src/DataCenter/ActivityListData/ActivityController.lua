local ActivityController = BaseClass("ActivityController")

local function __init(self)
end

local function __delete(self)
end

local function SendScoreActivityData(self)
  local nowList = DataCenter.ActivityListDataManager:GetActivityList()
  if nowList ~= nil then
    table.walk(nowList, function(k, v)
      local aId
      if v.type == EnumActivity.PersonalArms.Type then
        aId = v.activityId
      elseif v.type == EnumActivity.AllianceCompete.Type then
        aId = v.activityId
      end
      if aId ~= "" and aId ~= nil then
        self:SendActivitySingleScoreGetCommand(aId)
      end
    end)
  end
end

local function SendActivitySingleScoreGetCommand(self, activityId)
  SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(activityId))
end

local function SendActivityGetRewardCommand(self, actId, stage, eventType)
  SFSNetwork.SendMessage(MsgDefines.AcceptPersonalReward, {
    actId = actId,
    stage = stage,
    eventType = eventType
  })
end

local function SendGetAllActivityInfo()
  SFSNetwork.SendMessage(MsgDefines.ActivityPanelInfo)
end

ActivityController.__init = __init
ActivityController.__delete = __delete
ActivityController.SendScoreActivityData = SendScoreActivityData
ActivityController.SendActivitySingleScoreGetCommand = SendActivitySingleScoreGetCommand
ActivityController.SendActivityGetRewardCommand = SendActivityGetRewardCommand
ActivityController.SendGetAllActivityInfo = SendGetAllActivityInfo
return ActivityController
