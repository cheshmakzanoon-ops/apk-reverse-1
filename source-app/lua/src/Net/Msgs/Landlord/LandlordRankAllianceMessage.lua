local LandlordRankAllianceMessage = BaseClass("LandlordRankAllianceMessage", SFSBaseMessage)
local Localization = CS.GameEntry.Localization
local base = SFSBaseMessage

function LandlordRankAllianceMessage:OnCreate(week, scoreType)
  base.OnCreate(self)
  self.sfsObj:PutInt("week", week)
  self.sfsObj:PutInt("scoreType", scoreType or 0)
end

function LandlordRankAllianceMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if t.errorPara2 then
      UIUtil.ShowTips(Localization:GetString(errCode, table.unpack(t.errorPara2)))
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
    DataCenter.LandlordMgr:HandleRankAlliance(t)
  end
end

return LandlordRankAllianceMessage
