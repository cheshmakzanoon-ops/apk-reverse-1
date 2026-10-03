local BloodNightCloseScoreViewMessage = BaseClass("BloodNightCloseScoreViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BloodNightCloseScoreViewMessage:OnCreate(serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
end

function BloodNightCloseScoreViewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.BloodyNightDataManager:HandleSaintMountainProgress(t)
  end
end

return BloodNightCloseScoreViewMessage
