local RemarkNameListMessage = BaseClass("RemarkNameListMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, page, pageSize)
  base.OnCreate(self)
  self.sfsObj:PutInt("page", page)
  self.sfsObj:PutInt("pageSize", pageSize)
end

local function HandleMessage(self, msg)
  base.HandleMessage(self, msg)
  if msg.errorCode ~= nil then
    UIUtil.ShowTips(msg.errorCode)
    return
  end
  if msg == nil or msg.list == nil then
    Logger.LogError("\229\164\135\230\179\168\229\144\141\228\184\139\229\143\145\231\154\132\229\164\135\230\179\168\229\144\141\229\136\151\232\161\168\228\184\186\231\169\186\239\188\129")
    return
  end
  DataCenter.PlayerInfoDataManager:ParseRemarkNameMessage(msg.page, msg.list)
end

RemarkNameListMessage.OnCreate = OnCreate
RemarkNameListMessage.HandleMessage = HandleMessage
return RemarkNameListMessage
