local LandlordRankPersonalMessage = BaseClass("LandlordRankPersonalMessage", SFSBaseMessage)
local Localization = CS.GameEntry.Localization
local base = SFSBaseMessage

function LandlordRankPersonalMessage:OnCreate(week, scoreType, startIdx, endIdx)
  base.OnCreate(self)
  self.sfsObj:PutInt("week", week or 0)
  self.sfsObj:PutInt("scoreType", scoreType or 0)
  self.sfsObj:PutInt("start", startIdx or 1)
  self.sfsObj:PutInt("end", endIdx or 100)
end

function LandlordRankPersonalMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if t.errorPara2 then
      UIUtil.ShowTips(Localization:GetString(errCode, table.unpack(t.errorPara2)))
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
    DataCenter.LandlordMgr:HandleRankPersonal(t)
  end
end

return LandlordRankPersonalMessage
