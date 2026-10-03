local AllianceOrderFill = BaseClass("AllianceOrderFill", SFSBaseMessage)
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
  if message.errorCode ~= nil then
    if message.errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(message.errorCode))
    end
    return
  end
  DataCenter.ActAllianceOrderManager:HandleMessageFill(message)
end

AllianceOrderFill.OnCreate = OnCreate
AllianceOrderFill.HandleMessage = HandleMessage
return AllianceOrderFill
