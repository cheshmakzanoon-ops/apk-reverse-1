local RedPacketUidsGetCommand = BaseClass("RedPacketUidsGetCommand", SFSBaseMessage)

local function OnCreate(self, param)
end

local function HandleMessage(self, msg)
  if msg.params then
    local uidArray = msg.params.records
    if uidArray and 0 < #uidArray then
      local uids = ""
      for i = 1, #uidArray do
        local redDic = uidArray[i]
        if redDic then
          local redPackageStr = ""
          if redDic.uid then
            redPackageStr = redDic.uid
          end
          redPackageStr = redPackageStr .. "_"
          if redDic.server then
            redPackageStr = redPackageStr .. redDic.server
          end
          redPackageStr = redPackageStr .. "|"
          if redDic.status then
            redPackageStr = redPackageStr .. redDic.status
          end
          if uids ~= "" then
            uids = uids .. ","
          end
          uids = uids .. redPackageStr
        end
      end
      if uids ~= "" then
        ChatManager2:GetInstance().Room:refreshRedPacketStatus(uids)
      end
    end
  end
end

RedPacketUidsGetCommand.OnCreate = OnCreate
RedPacketUidsGetCommand.HandleMessage = HandleMessage

local function OnSend(param)
  SFSNetwork.SendMessage(MsgDefines.GET_RED_PACKET_UIDS, param)
end

function RedPacketUidsGetCommand.create()
  local ret = {}
  ret.send = OnSend
  return ret
end

return RedPacketUidsGetCommand
