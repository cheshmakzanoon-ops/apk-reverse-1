local AllianceBossDigGameRewardMessage = BaseClass("AllianceBossDigGameRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid, pos)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("pos", pos)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.DiggingDataManager:OnGetReward(t)
  DataCenter.AllyDrillDataManager:UpdateDigOnGetReward(t)
end

AllianceBossDigGameRewardMessage.OnCreate = OnCreate
AllianceBossDigGameRewardMessage.HandleMessage = HandleMessage
return AllianceBossDigGameRewardMessage
