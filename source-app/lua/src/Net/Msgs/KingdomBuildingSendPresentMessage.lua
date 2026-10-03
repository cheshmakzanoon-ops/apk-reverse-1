local KingdomBuildingSendPresentMessage = BaseClass("KingdomBuildingSendPresentMessage", SFSBaseMessage)
local base = SFSBaseMessage

function KingdomBuildingSendPresentMessage:OnCreate(targetUidArr, groupId, buildingId, presentId, serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("groupId", groupId)
  self.sfsObj:PutInt("buildingId", buildingId)
  self.sfsObj:PutInt("presentId", presentId)
  self.sfsObj:PutInt("serverId", serverId)
  local oneArr = SFSArray.New()
  for _, v in ipairs(targetUidArr) do
    oneArr:AddUtfString(v)
  end
  self.sfsObj:PutSFSArray("targetUidArray", oneArr)
end

function KingdomBuildingSendPresentMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if errCode ~= SeverErrorCode then
      UIUtil.ShowTipsId(errCode)
    else
      UIUtil.ShowTipsId(457087)
    end
  else
    DataCenter.BuildingOfficialManager:HandleBuildingSendPresent(t)
  end
end

return KingdomBuildingSendPresentMessage
