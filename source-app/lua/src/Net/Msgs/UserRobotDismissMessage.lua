local UserRobotDismissMessage = BaseClass("UserRobotDismissMessage", SFSBaseMessage)
local Localization = CS.GameEntry.Localization
local base = SFSBaseMessage

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("robotUuid", uuid)
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
      if dic.buildingId ~= nil then
        local buildId = dic.buildingId
        local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
        if buildTemplate ~= nil then
          local des = Localization:GetString("130085", Localization:GetString(buildTemplate.name))
          UIUtil.ShowTips(des)
        end
      end
    end
    if message.robot ~= nil then
      DataCenter.BuildQueueManager:UpdateQueueData(message.robot)
    end
  end
end

UserRobotDismissMessage.OnCreate = OnCreate
UserRobotDismissMessage.HandleMessage = HandleMessage
return UserRobotDismissMessage
