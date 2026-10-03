local EndDetectEventPveMessage = BaseClass("EndDetectEventPveMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid, isWin)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutBool("win", isWin)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

EndDetectEventPveMessage.OnCreate = OnCreate
EndDetectEventPveMessage.HandleMessage = HandleMessage
return EndDetectEventPveMessage
