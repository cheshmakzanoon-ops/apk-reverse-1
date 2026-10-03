local LWActSignInManager = BaseClass("LWActSignInManager")
local LWActSignInInfo = require("DataCenter.LWActSignInManager.LWActSignInInfo")

function LWActSignInManager:__init()
  self.infos = {}
end

function LWActSignInManager:__delete()
  self.infos = nil
end

function LWActSignInManager:OnGetEventInfo(msg)
  if not msg then
    return
  end
  local actId = tonumber(msg.id)
  if not self.infos[actId] then
    self.infos[actId] = LWActSignInInfo.New()
  end
  self.infos[actId]:UpdateData(msg)
end

function LWActSignInManager:GetRedDotCount(actId)
  local _actId = tonumber(actId)
  if not self.infos[_actId] then
    return 0
  end
  local info = self.infos[_actId]
  return info:GetCanClaimRewardDay()
end

function LWActSignInManager:GetActSignInInfo(actId)
  local _actId = tonumber(actId)
  return self.infos[_actId]
end

function LWActSignInManager:ClaimActReward(actId, dayId)
  local _actId = tonumber(actId)
  local actInfo = self:GetActSignInInfo(_actId)
  if not actInfo then
    return
  end
  if actInfo:IsEnd() then
    return
  end
  if dayId == 0 and 0 >= actInfo:GetCanClaimRewardDay() then
    return
  elseif 0 < dayId and not actInfo:CanClaimAtDay(dayId) then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ClaimActSignInReward, _actId, dayId)
end

return LWActSignInManager
