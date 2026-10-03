local Localization = CS.GameEntry.Localization
local RequestMainBaseDisco = BaseClass("RequestMainBaseDisco", SFSBaseMessage)
local base = SFSBaseMessage

function RequestMainBaseDisco:OnCreate(param)
  base.OnCreate(self)
end

function RequestMainBaseDisco:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    local para2 = t.errorPara2
    if para2 == nil then
      UIUtil.ShowTipsId(errCode)
    elseif type(para2) == "table" and 1 <= #para2 then
      UIUtil.ShowTips(Localization:GetString(t.errorCode, table.unpack(para2)))
    else
      UIUtil.ShowTipsId(errCode)
    end
    return
  end
end

return RequestMainBaseDisco
