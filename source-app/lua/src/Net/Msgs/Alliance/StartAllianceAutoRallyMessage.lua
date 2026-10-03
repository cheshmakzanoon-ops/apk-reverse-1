local StartAllianceAutoRallyMessage = BaseClass("StartAllianceAutoRallyMessage", SFSBaseMessage)
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
  else
    DataCenter.AllianceBaseDataManager:UpdateAutoRallyInfo(t, false)
    SFSNetwork.SendMessage(MsgDefines.GetAllianceAutoJoinRallyInfo)
  end
end

StartAllianceAutoRallyMessage.OnCreate = OnCreate
StartAllianceAutoRallyMessage.HandleMessage = HandleMessage
return StartAllianceAutoRallyMessage
