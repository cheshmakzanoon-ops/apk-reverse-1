local rapidjson = require("rapidjson")
local AllianceStarCeremonySetPlanMessage = BaseClass("AllianceStarCeremonySetPlanMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function AllianceStarCeremonySetPlanMessage:OnCreate(planTimeStamp)
  base.OnCreate(self)
  self.sfsObj:PutLong("planTimeStamp", planTimeStamp)
end

function AllianceStarCeremonySetPlanMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if errCode == "alliance_weeklyStar_setTime_err4" then
      if t.errorMsg then
        local errorCodeParam = rapidjson.decode(t.errorMsg)
        UIUtil.ShowTips(Localization:GetString(errCode, UITimeManager:GetInstance():SecondToFmtString(tonumber(errorCodeParam[1]))))
      else
        UIUtil.ShowTipsId(errCode)
      end
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
    UIUtil.ShowTipsId("alliance_weeklyStar_tips_01")
  end
end

return AllianceStarCeremonySetPlanMessage
