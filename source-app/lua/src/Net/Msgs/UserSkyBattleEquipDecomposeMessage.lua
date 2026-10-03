local UserSkyBattleEquipDecomposeMessage = BaseClass("UserSkyBattleEquipDecomposeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UserSkyBattleEquipDecomposeMessage:OnCreate(equipUuids)
  base.OnCreate(self)
  if not equipUuids or #equipUuids == 0 then
    return
  end
  local oneArr = SFSArray.New()
  for k, v in ipairs(equipUuids) do
    oneArr:AddLong(v)
  end
  self.sfsObj:PutSFSArray("ids", oneArr)
end

function UserSkyBattleEquipDecomposeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWSkyBattleGrowthChapterManager:EquipRecycled(t)
  end
end

return UserSkyBattleEquipDecomposeMessage
