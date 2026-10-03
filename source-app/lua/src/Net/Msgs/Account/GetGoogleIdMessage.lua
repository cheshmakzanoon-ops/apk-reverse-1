local GetGoogleIdMessage = BaseClass("GetGoogleIdMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetGoogleIdMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("auth_code", param.auth_code)
  self.sfsObj:PutUtfString("pgs_id", param.pgs_id)
  self.sfsObj:PutUtfString("pgs_name", param.pgs_name)
end

function GetGoogleIdMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
  Logger.LogError("[GooglePlayManager] GetGoogleIdMessage \232\191\148\229\155\158\228\186\134")
end

return GetGoogleIdMessage
