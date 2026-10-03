local AllianceStarGainThumbsUpMessage = BaseClass("AllianceStarGainThumbsUpMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceStarGainThumbsUpMessage:OnCreate(edition, allianceId)
  base.OnCreate(self)
  self.sfsObj:PutInt("edition", edition)
  self.sfsObj:PutUtfString("extParams", allianceId)
end

function AllianceStarGainThumbsUpMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceStarManager:SetMailThumbsUpData(t)
  end
end

return AllianceStarGainThumbsUpMessage
