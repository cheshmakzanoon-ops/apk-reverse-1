local AllianceGiftRemoveMessage = BaseClass("AllianceGiftRemoveMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("uuid", uuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

AllianceGiftRemoveMessage.OnCreate = OnCreate
AllianceGiftRemoveMessage.HandleMessage = HandleMessage
return AllianceGiftRemoveMessage
