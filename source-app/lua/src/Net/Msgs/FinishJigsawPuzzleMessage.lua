local FinishJigsawPuzzleMessage = BaseClass("FinishJigsawPuzzleMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, jigsawId, costTime)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tonumber(activityId))
  self.sfsObj:PutInt("id", jigsawId)
  self.sfsObj:PutInt("useTime", costTime)
  local strContent = LuaEntry.Player.uid .. activityId .. jigsawId .. costTime
  local md5 = CS.StringUtils.GetMD5(strContent)
  self.sfsObj:PutUtfString("m", md5)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.RewardManager:AddRewardsAndRes(t)
    DataCenter.JigsawPuzzleManager:OnrecvPuzzleFinish(t)
  end
  EventManager:GetInstance():Broadcast(EventId.OnJigsawPuzzleEnd)
end

FinishJigsawPuzzleMessage.OnCreate = OnCreate
FinishJigsawPuzzleMessage.HandleMessage = HandleMessage
return FinishJigsawPuzzleMessage
