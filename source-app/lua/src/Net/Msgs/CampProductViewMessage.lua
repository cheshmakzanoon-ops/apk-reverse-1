local CampProductViewMessage = BaseClass("CampProductViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CampProductViewMessage:OnCreate()
  base.OnCreate(self)
end

function CampProductViewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.CampProduceDataManager:ReqCampProductView(t)
  end
end

return CampProductViewMessage
