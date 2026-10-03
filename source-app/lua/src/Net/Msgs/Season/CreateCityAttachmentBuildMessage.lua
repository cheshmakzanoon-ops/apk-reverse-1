local CreateCityAttachmentBuildMessage = BaseClass("CreateCityAttachmentBuildMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function CreateCityAttachmentBuildMessage:OnCreate(cityId, slotIndex)
  base.OnCreate(self)
  self.sfsObj:PutInt("cityId", cityId)
  self.sfsObj:PutInt("slotIndex", slotIndex)
end

function CreateCityAttachmentBuildMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if t.needNum then
      UIUtil.ShowTips(Localization:GetString(errCode, t.needNum))
    else
      UIUtil.ShowTipsId(errCode)
    end
    return
  end
  if t.cityId and t.buildId then
    UIUtil.ShowTipsId("335487")
  end
end

return CreateCityAttachmentBuildMessage
