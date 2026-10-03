local WinterStormOrderAddMessage = BaseClass("WinterStormOrderAddMessage", SFSBaseMessage)
local base = SFSBaseMessage

function WinterStormOrderAddMessage:OnCreate(cfgId, pid)
  base.OnCreate(self)
  self.sfsObj:PutInt("cfgid", cfgId)
  self.sfsObj:PutInt("pid", pid)
end

function WinterStormOrderAddMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    local errorPara2 = t.errorPara2
    if errorPara2 then
      UIUtil.ShowTips(CS.GameEntry.Localization:GetString(errCode, table.unpack(errorPara2)))
    else
      UIUtil.ShowTipsId(errCode)
    end
    return
  end
  BattleFieldUtil.BFPingUtil().HandlePingOpt(BattleFieldType.WinterStorm, t, true)
end

return WinterStormOrderAddMessage
