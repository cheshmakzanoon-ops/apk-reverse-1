local SeasonBalancePackageViewOpenMessage = BaseClass("SeasonBalancePackageViewOpenMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.DesertDataManager:InitDesertRewardList(t)
    EventManager:GetInstance():Broadcast(EventId.GetSeasonRewardData)
  end
end

SeasonBalancePackageViewOpenMessage.OnCreate = OnCreate
SeasonBalancePackageViewOpenMessage.HandleMessage = HandleMessage
return SeasonBalancePackageViewOpenMessage
