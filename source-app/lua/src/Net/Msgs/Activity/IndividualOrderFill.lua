local IndividualOrderFill = BaseClass("IndividualOrderFill", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, resUuid, uuid, num)
  base.OnCreate(self)
  self.sfsObj:PutLong("resourceItemUuid", resUuid)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("num", num)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil and message.errorCode ~= SeverErrorCode then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.ActIndividualOrderManager:HandleMessageFill(message)
  EventManager:GetInstance():Broadcast(EventId.OnQuestRedCountChanged)
end

IndividualOrderFill.OnCreate = OnCreate
IndividualOrderFill.HandleMessage = HandleMessage
return IndividualOrderFill
