local GMAddElectricityS4Message = BaseClass("GMAddElectricityS4Message", SFSBaseMessage)
local base = SFSBaseMessage

function GMAddElectricityS4Message:OnCreate()
  base.OnCreate(self)
  self.sfsObj:PutInt("power", 10000)
end

function GMAddElectricityS4Message:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
end

return GMAddElectricityS4Message
