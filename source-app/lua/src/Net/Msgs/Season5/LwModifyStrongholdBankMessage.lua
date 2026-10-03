local LwModifyStrongholdBankMessage = BaseClass("LwModifyStrongholdBankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function LwModifyStrongholdBankMessage:OnCreate(strongholdId, minDepositAmount, serviceScope, serverId_)
  base.OnCreate(self)
  self.sfsObj:PutInt("strongholdId", strongholdId)
  self.sfsObj:PutLong("minDepositAmount", minDepositAmount)
  self.sfsObj:PutInt("serviceScope", serviceScope)
  self.sfsObj:PutInt("serverId", serverId_ or LuaEntry.Player:GetCurServerId())
end

function LwModifyStrongholdBankMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if errCode == "s5_bank_tips06" and t.cdEndTime then
      local deltaTime = t.cdEndTime - UITimeManager:GetInstance():GetServerTime()
      if 0 < deltaTime then
        UIUtil.ShowTips(CS.GameEntry.Localization:GetString("s5_bank_tips06", UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)))
        return
      end
    end
    UIUtil.ShowTipsId(errCode)
    return
  end
  local detail = DataCenter.WorldPointDetailManager:GetAllianceCityData(t.strongholdId)
  if detail and detail.bankDetail then
    detail.bankDetail.setting = {
      lastSetTime = t.lastSetTime,
      lastSetUid = t.lastSetUid,
      lastSetUserName = t.lastSetUserName,
      serviceScope = t.serviceScope,
      minDepositAmount = t.minDepositAmount
    }
  end
  EventManager:GetInstance():Broadcast(EventId.ModifyStrongholdBank, t.strongholdId)
  UIUtil.ShowTipsId("s5_bank_tips05")
end

function LwModifyStrongholdBankMessage:GetTestData(strongholdId, minDepositAmount, serviceScope, serverId_)
  local t = {
    strongholdId = strongholdId or 1,
    serverId = serverId_ or LuaEntry.Player:GetCurServerId(),
    lastSetTime = UITimeManager:GetInstance():GetServerTime(),
    lastSetUid = LuaEntry.Player.uid,
    lastSetUserName = LuaEntry.Player.name,
    serviceScope = serviceScope or 0,
    minDepositAmount = minDepositAmount or 1000
  }
  return t
end

return LwModifyStrongholdBankMessage
