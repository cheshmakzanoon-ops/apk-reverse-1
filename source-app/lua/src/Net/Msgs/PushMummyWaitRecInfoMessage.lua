local PushMummyWaitRecInfoMessage = BaseClass("PushMummyWaitRecInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  if t.list then
    DataCenter.SeasonMummyDataManager:UpdateRecArmy(t.list)
  end
  SFSNetwork.SendMessage(MsgDefines.GetLastWarActivityInfo)
end

local function GetTestData(self)
end

PushMummyWaitRecInfoMessage.GetTestData = GetTestData
PushMummyWaitRecInfoMessage.OnCreate = OnCreate
PushMummyWaitRecInfoMessage.HandleMessage = HandleMessage
return PushMummyWaitRecInfoMessage
