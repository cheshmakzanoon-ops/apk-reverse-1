local AllianceDeclareWarGetMessage = BaseClass("AllianceDeclareWarGetMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.infos then
    DataCenter.AllianceDeclareWarManager:Init(t.infos)
  end
end

AllianceDeclareWarGetMessage.OnCreate = OnCreate
AllianceDeclareWarGetMessage.HandleMessage = HandleMessage
return AllianceDeclareWarGetMessage
