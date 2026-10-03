local GoldTreeActViewMessage = BaseClass("GoldTreeActViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GoldTreeActViewMessage:OnCreate(param)
  base.OnCreate(self)
end

function GoldTreeActViewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonGoldTreeManager:GoldTreeActViewMessage(t.goldTreeInfo, t.userGoldTreeDataInfo)
end

return GoldTreeActViewMessage
