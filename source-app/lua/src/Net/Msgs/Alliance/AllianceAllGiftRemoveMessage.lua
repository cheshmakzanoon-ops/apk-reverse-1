local AllianceAllGiftRemoveMessage = BaseClass("AllianceAllGiftRemoveMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, type)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

AllianceAllGiftRemoveMessage.OnCreate = OnCreate
AllianceAllGiftRemoveMessage.HandleMessage = HandleMessage
return AllianceAllGiftRemoveMessage
