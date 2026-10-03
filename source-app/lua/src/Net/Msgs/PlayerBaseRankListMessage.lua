local PlayerBaseRankListMessage = BaseClass("PlayerBaseRankListMessage", SFSBaseMessage)
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
    DataCenter.RankDataManager:ParsePlayerRankData(0, RankType.CommanderBase, t)
    EventManager:GetInstance():Broadcast(EventId.PlayerRank)
  end
end

PlayerBaseRankListMessage.OnCreate = OnCreate
PlayerBaseRankListMessage.HandleMessage = HandleMessage
return PlayerBaseRankListMessage
