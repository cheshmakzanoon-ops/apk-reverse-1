local FrontBreakSundayThumbsUpMessage = BaseClass("FrontBreakSundayThumbsUpMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function FrontBreakSundayThumbsUpMessage:OnCreate(targetUid, extParam)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("targetUid", targetUid)
  self.sfsObj:PutUtfString("extParam", extParam)
end

function FrontBreakSundayThumbsUpMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  UIUtil.ShowTipsId("alliance_train_vip033")
end

return FrontBreakSundayThumbsUpMessage
