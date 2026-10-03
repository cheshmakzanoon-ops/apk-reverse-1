local RedPacketsRvdIdMessage = BaseClass("RedPacketsRvdIdMessage", SFSBaseMessage)
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
  DataCenter.AllianceRedPacketManager:UpdateRecordHandle(t.records)
end

RedPacketsRvdIdMessage.OnCreate = OnCreate
RedPacketsRvdIdMessage.HandleMessage = HandleMessage
return RedPacketsRvdIdMessage
