local UpgradeHeroRankMessage = BaseClass("UpgradeHeroRankMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uid, pointId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("uid", uid)
  self.sfsObj:PutInt("pointId", pointId)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  local pos = SceneUtils.TileIndexToWorld(message.pointId, ForceChangeScene.World)
  GoToUtil.GotoWorldPos(pos)
  if message.isChange then
    UIUtil.ShowTips(Localization:GetString("801042"))
  end
end

UpgradeHeroRankMessage.OnCreate = OnCreate
UpgradeHeroRankMessage.HandleMessage = HandleMessage
return UpgradeHeroRankMessage
