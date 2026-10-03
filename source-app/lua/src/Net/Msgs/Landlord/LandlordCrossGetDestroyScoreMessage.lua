local LandlordCrossGetDestroyScoreMessage = BaseClass("LandlordCrossGetDestroyScoreMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function LandlordCrossGetDestroyScoreMessage:OnCreate(serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
end

function LandlordCrossGetDestroyScoreMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if t.errorPara2 then
      UIUtil.ShowTips(Localization:GetString(errCode, table.unpack(t.errorPara2)))
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
    DataCenter.LandlordMgr:HandleTargetServerDestroyScore(t)
  end
end

return LandlordCrossGetDestroyScoreMessage
