local CheckActivityFeatureMonsterMessage = BaseClass("CheckActivityFeatureMonsterMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CheckActivityFeatureMonsterMessage:OnCreate(cfgId, num)
  base.OnCreate(self)
  self.sfsObj:PutInt("cfgId", cfgId)
  self.sfsObj:PutInt("num", num)
end

function CheckActivityFeatureMonsterMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return CheckActivityFeatureMonsterMessage
