local GoldTreePowerRankViewMessage = BaseClass("GoldTreePowerRankViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GoldTreePowerRankViewMessage:OnCreate(treeId, serverId)
  base.OnCreate(self)
  treeId = treeId or DataCenter.SeasonGoldTreeManager.goldTreeInfo and DataCenter.SeasonGoldTreeManager.goldTreeInfo.treeId or 60
  self.sfsObj:PutInt("treeId", treeId)
  self.sfsObj:PutInt("serverId", serverId or LuaEntry.Player:GetSourceServerId())
end

function GoldTreePowerRankViewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonGoldTreeManager:GoldTreePowerRankViewMessage(t)
end

return GoldTreePowerRankViewMessage
