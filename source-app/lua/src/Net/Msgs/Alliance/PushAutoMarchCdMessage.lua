local PushAutoMarchCdMessage = BaseClass("PushAutoMarchCdMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SiegeDataManager:SetAllOutReadyTS(t)
    if t.hasTip then
      UIUtil.ShowTipsId("new_city_activity_battle_tips1034")
    end
  end
end

PushAutoMarchCdMessage.HandleMessage = HandleMessage
return PushAutoMarchCdMessage
