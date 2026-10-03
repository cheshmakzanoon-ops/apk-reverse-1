local GetGoldBrickTokenMessage = BaseClass("GetGoldBrickTokenMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetGoldBrickTokenMessage:OnCreate(param)
  base.OnCreate(self)
  if param == nil then
    return
  end
  if not string.IsNullOrEmpty(param.selfOrderId) then
    self.sfsObj:PutUtfString("selfOrderId", param.selfOrderId)
  end
  if not string.IsNullOrEmpty(param.packageName) then
    self.sfsObj:PutUtfString("packageName", param.packageName)
  end
  if not string.IsNullOrEmpty(param.googleToken) then
    self.sfsObj:PutUtfString("googleToken", param.googleToken)
  end
end

function GetGoldBrickTokenMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    if DataCenter.PayManager:HandleGoldBrickTokenError(errCode) then
      return
    end
  else
    local token = t.goldBrickToken
    local url = t.goldBrickUrl
    local goldBrickUuid = t.goldBrickUuid
    local payload = {
      token = token,
      url = url,
      goldBrickUuid = goldBrickUuid
    }
    if not string.IsNullOrEmpty(goldBrickUuid) and DataCenter.PayManager:HandleGoldBrickTokenResponse(payload) then
      return
    end
    EventManager:GetInstance():Broadcast(EventId.GoldBrickShopGetToken, {
      token = token,
      url = url,
      goldBrickUuid = goldBrickUuid
    })
  end
end

return GetGoldBrickTokenMessage
