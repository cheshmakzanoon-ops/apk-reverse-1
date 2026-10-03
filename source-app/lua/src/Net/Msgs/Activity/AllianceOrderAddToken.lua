local AllianceOrderAddToken = BaseClass("AllianceOrderAddToken", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, itemId, num)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("itemId", tostring(itemId))
  self.sfsObj:PutInt("num", num)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    if message.errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(message.errorCode))
    end
    return
  end
  DataCenter.ActAllianceOrderManager:HandleMessageAddToken(message)
end

AllianceOrderAddToken.OnCreate = OnCreate
AllianceOrderAddToken.HandleMessage = HandleMessage
return AllianceOrderAddToken
