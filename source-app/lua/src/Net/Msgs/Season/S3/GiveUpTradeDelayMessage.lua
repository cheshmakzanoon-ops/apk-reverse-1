local GiveUpTradeDelayMessage = BaseClass("GiveUpTradeDelayMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GiveUpTradeDelayMessage:OnCreate(serverId, tradeId, isCancel)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutInt("tradeId", tradeId)
  self.sfsObj:PutBool("isCancel", isCancel or false)
end

function GiveUpTradeDelayMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.giveUpTime and toInt(t.giveUpTime) > 0 then
    local configTime = Mathf.Round(LuaEntry.DataConfig:TryGetNum("season_new_s5_station", "k5", 60))
    UIUtil.ShowTips(CS.GameEntry.Localization:GetString(393063, nil, configTime))
  else
    UIUtil.ShowTipsId(393061)
  end
  t.cityId = t.tradeId
  DataCenter.WorldAllianceCityDataManager:UpdateOneGivingUpCity(t, true)
end

return GiveUpTradeDelayMessage
