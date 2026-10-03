local UserRobotOccupyMessage = BaseClass("UserRobotOccupyMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, robotUuid, bUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("robotUuid", robotUuid)
  self.sfsObj:PutLong("bUuid", bUuid)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(message.errorCode))
    end
  else
    local dic = message.build
    if dic ~= nil then
      DataCenter.BuildManager:AddBuilding(dic)
    end
    if message.robot ~= nil then
      DataCenter.BuildQueueManager:UpdateQueueData(message.robot)
    end
  end
end

UserRobotOccupyMessage.OnCreate = OnCreate
UserRobotOccupyMessage.HandleMessage = HandleMessage
return UserRobotOccupyMessage
