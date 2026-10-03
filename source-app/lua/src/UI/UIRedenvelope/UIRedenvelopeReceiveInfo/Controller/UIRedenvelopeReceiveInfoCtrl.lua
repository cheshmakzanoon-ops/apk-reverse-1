local UIRedenvelopeReceiveInfoCtrl = BaseClass("UIRedenvelopeReceiveInfoCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIRedenvelopeReceiveInfo)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function GetRecord(self, data)
  local myRecord
  for i = 1, #data do
    if data[i].uid == LuaEntry.Player.uid then
      myRecord = data[i]
      table.remove(data, i)
      break
    end
  end
  if myRecord ~= nil then
    table.insert(data, 1, myRecord)
  end
  return data
end

local function GetLucky(self, data)
  local maxNum = 0
  local index = 0
  for i = 1, #data do
    if maxNum < data[i].gold then
      maxNum = data[i].gold
      index = i
    end
  end
  return index
end

local function SendChatRed(self, data)
  local param = {}
  param.serverId = data.serverId
  param.redPacketId = data.uuid
  if data.status == RedPacketState.ALREADY_GET or data.status == RedPacketState.COST_ALL then
    param.isViewOnly = true
  end
  SFSNetwork.SendMessage(MsgDefines.GetRedPack, param)
end

UIRedenvelopeReceiveInfoCtrl.CloseSelf = CloseSelf
UIRedenvelopeReceiveInfoCtrl.Close = Close
UIRedenvelopeReceiveInfoCtrl.GetRecord = GetRecord
UIRedenvelopeReceiveInfoCtrl.GetLucky = GetLucky
UIRedenvelopeReceiveInfoCtrl.SendChatRed = SendChatRed
return UIRedenvelopeReceiveInfoCtrl
