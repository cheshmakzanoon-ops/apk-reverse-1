local CityaltarSkillRankMessage = BaseClass("CityaltarSkillRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CityaltarSkillRankMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("skill", param.skill)
  self.sfsObj:PutInt("timeType", param.timeType)
end

function CityaltarSkillRankMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonCityAltarManager:OnGetRankCallback(t)
  end
end

return CityaltarSkillRankMessage
