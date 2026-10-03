local LandlordActBattleInfoMessage = BaseClass("LandlordActBattleInfoMessage", SFSBaseMessage)
local Localization = CS.GameEntry.Localization
local base = SFSBaseMessage

function LandlordActBattleInfoMessage:OnCreate()
  base.OnCreate(self)
end

function LandlordActBattleInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if t.errorPara2 then
      UIUtil.ShowTips(Localization:GetString(errCode, table.unpack(t.errorPara2)))
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
    DataCenter.LandlordMgr:HandleActBattleInfo(t)
  end
end

return LandlordActBattleInfoMessage
