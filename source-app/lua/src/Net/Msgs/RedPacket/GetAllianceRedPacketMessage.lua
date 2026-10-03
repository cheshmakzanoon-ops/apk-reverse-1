local GetAllianceRedPacketMessage = BaseClass("GetAllianceRedPacketMessage", SFSBaseMessage)
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
  if t.allianceRedPackets and next(t.allianceRedPackets) then
    for i = 1, #t.allianceRedPackets do
      DataCenter.AllianceRedPacketManager:UpdateRedPacketByUUid(t.allianceRedPackets[i])
    end
  end
  SFSNetwork.SendMessage(MsgDefines.RedPacketsRvdId)
end

GetAllianceRedPacketMessage.OnCreate = OnCreate
GetAllianceRedPacketMessage.HandleMessage = HandleMessage
return GetAllianceRedPacketMessage
