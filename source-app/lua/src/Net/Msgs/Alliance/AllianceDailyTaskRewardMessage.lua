local AllianceDailyTaskRewardMessage = BaseClass("AllianceDailyTaskRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, taskId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("taskId", taskId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.DailyTaskManager:DailyTaskRewardMessageHandle(t)
end

AllianceDailyTaskRewardMessage.OnCreate = OnCreate
AllianceDailyTaskRewardMessage.HandleMessage = HandleMessage
return AllianceDailyTaskRewardMessage
