local PlayerRankListMessage = BaseClass("PlayerRankListMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self.sfsObj:PutInt("ismerge", 0)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.RankDataManager:ParsePlayerRankData(0, RankType.CommanderPower, t)
    EventManager:GetInstance():Broadcast(EventId.PlayerRank)
  end
end

PlayerRankListMessage.OnCreate = OnCreate
PlayerRankListMessage.HandleMessage = HandleMessage
return PlayerRankListMessage
