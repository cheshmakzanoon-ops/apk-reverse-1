local UIVoiceRoomCtrl = BaseClass("UIVoiceRoomCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIVoiceRoom)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function InitData(self)
  self.chatRoomId = nil
  self.voiceRoomId = nil
end

local function SetRoomContext(self, chatRoomId, voiceRoomId)
  self.chatRoomId = chatRoomId
  self.voiceRoomId = voiceRoomId
end

local function GetRoomContext(self)
  return self.chatRoomId, self.voiceRoomId
end

UIVoiceRoomCtrl.CloseSelf = CloseSelf
UIVoiceRoomCtrl.Close = Close
UIVoiceRoomCtrl.InitData = InitData
UIVoiceRoomCtrl.SetRoomContext = SetRoomContext
UIVoiceRoomCtrl.GetRoomContext = GetRoomContext
return UIVoiceRoomCtrl
