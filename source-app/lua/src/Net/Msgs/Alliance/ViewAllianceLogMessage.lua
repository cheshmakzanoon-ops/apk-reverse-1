local ViewAllianceLogMessage = BaseClass("ViewAllianceLogMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, time, isAllianceCity, pageId)
  base.OnCreate(self)
  self.sfsObj:PutLong("time", time)
  self.sfsObj:PutBool("isAllianceCity", isAllianceCity)
  self.sfsObj:PutInt("pageId", pageId or 1)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.AllianceLogManager:UpdateAllianceLogData(message.logs, message.pageId)
end

ViewAllianceLogMessage.OnCreate = OnCreate
ViewAllianceLogMessage.HandleMessage = HandleMessage
return ViewAllianceLogMessage
