local AllianceGiftInfoMessage = BaseClass("AllianceGiftInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local _type

local function OnCreate(self, uuid, type)
  base.OnCreate(self)
  _type = type
  self.sfsObj:PutUtfString("uuid", uuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.allianceNewMail ~= nil then
      DataCenter.AllianceGiftDataManager:UpdateGiftNum(t.allianceNewMail)
      EventManager:GetInstance():Broadcast(EventId.UpdateAllianceGiftNum)
    end
    DataCenter.AllianceGiftDataManager:RetGiftInfo(t, _type)
    EventManager:GetInstance():Broadcast(EventId.RetGiftInfoEvent)
  end
end

AllianceGiftInfoMessage.OnCreate = OnCreate
AllianceGiftInfoMessage.HandleMessage = HandleMessage
return AllianceGiftInfoMessage
