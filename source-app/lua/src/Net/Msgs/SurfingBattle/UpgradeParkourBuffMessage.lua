local UpgradeParkourBuffMessage = BaseClass("UpgradeParkourBuffMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UpgradeParkourBuffMessage:OnCreate(id)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", id)
end

function UpgradeParkourBuffMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWSurfingDataManager:UpdateBuffSkill(t)
  end
end

return UpgradeParkourBuffMessage
