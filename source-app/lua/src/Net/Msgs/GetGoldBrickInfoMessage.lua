local GetGoldBrickInfoMessage = BaseClass("GetGoldBrickInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetGoldBrickInfoMessage:OnCreate(param)
  base.OnCreate(self)
  WelfareController.SetAfterInitSendGetGoldBrickInfo(true)
end

function GetGoldBrickInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local code = t.code
    WelfareController.GenerateGoldBrickList(code == 0 and t or nil)
    WelfareController.SetGetGoldBrickInfo(true)
    EventManager:GetInstance():Broadcast(EventId.GoldBrickShopGetData)
  end
end

return GetGoldBrickInfoMessage
