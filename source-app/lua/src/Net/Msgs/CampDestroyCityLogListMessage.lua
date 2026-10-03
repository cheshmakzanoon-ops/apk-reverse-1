local CampDestroyCityLogListMessage = BaseClass("CampDestroyCityLogListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CampDestroyCityLogListMessage:OnCreate(page, pageSize)
  base.OnCreate(self)
  self.sfsObj:PutInt("page", page or 1)
  self.sfsObj:PutInt("pageSize", pageSize or 20)
end

function CampDestroyCityLogListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.CampProduceDataManager:ReqCampDestroyList(t)
  end
end

return CampDestroyCityLogListMessage
