local ShareDecode = require("Chat.Other.ShareDecode")
local UILWAllianceInviteShareConfirmCtrl = BaseClass("UILWAllianceInviteShareConfirmCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAllianceInviteShareConfirm)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function Confirm(self, chat_data)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_COMMAND, chat_data)
  self:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAllianceInviteShare)
end

UILWAllianceInviteShareConfirmCtrl.CloseSelf = CloseSelf
UILWAllianceInviteShareConfirmCtrl.Close = Close
UILWAllianceInviteShareConfirmCtrl.Confirm = Confirm
return UILWAllianceInviteShareConfirmCtrl
