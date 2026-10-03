local UIChatRoomOperatorCtrl = BaseClass("UIChatRoomOperatorCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChatRoomOperator)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

function UIChatRoomOperatorCtrl:__init()
  self.chatRoomdId = nil
end

function UIChatRoomOperatorCtrl:GetChatRoomData()
  if self.chatRoomdId == nil then
    return nil
  end
  local roomdata = ChatInterface.getRoomData(self.chatRoomdId)
  return roomdata
end

UIChatRoomOperatorCtrl.CloseSelf = CloseSelf
UIChatRoomOperatorCtrl.Close = Close
return UIChatRoomOperatorCtrl
