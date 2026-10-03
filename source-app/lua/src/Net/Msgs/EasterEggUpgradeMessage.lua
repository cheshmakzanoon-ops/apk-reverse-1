local EasterEggUpgradeMessage = BaseClass("EasterEggUpgradeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EasterEggUpgradeMessage:OnCreate(activityId, uuid)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutUtfString("uuid", uuid)
end

function EasterEggUpgradeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWUIActEasterAmazingEgg) then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIActEasterAmazingEgg)
    end
  else
    DataCenter.ActEasterEggManager:OnRecUpgradeEgg(t)
  end
end

return EasterEggUpgradeMessage
