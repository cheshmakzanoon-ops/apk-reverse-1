local EpidemicZoneCommanderOrderAddMessage = BaseClass("EpidemicZoneCommanderOrderAddMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EpidemicZoneCommanderOrderAddMessage:OnCreate(group, cfgId, pid)
  base.OnCreate(self)
  self.sfsObj:PutInt("group", group)
  self.sfsObj:PutInt("cfgid", cfgId)
  self.sfsObj:PutInt("pid", pid)
end

function EpidemicZoneCommanderOrderAddMessage:HandleMessage(t)
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
  BattleFieldUtil.BFPingUtil().HandlePingOpt(BattleFieldType.EpidemicZone, t, true)
end

return EpidemicZoneCommanderOrderAddMessage
