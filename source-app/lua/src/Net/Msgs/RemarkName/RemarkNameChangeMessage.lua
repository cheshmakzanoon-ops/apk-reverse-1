local logger = require("Framework.Logger.Logger")
local RemarkNameChangeMessage = BaseClass("RemarkNameChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, targetUid, remarkName)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("targetUid", targetUid)
  self.sfsObj:PutUtfString("remark", remarkName)
end

local function HandleMessage(self, msg)
  base.HandleMessage(self, msg)
  local state = msg.exist
  if state == nil then
    logger.LogError("\229\164\135\230\179\168\229\144\141\239\188\140\230\156\141\229\138\161\229\153\168\232\129\138\229\164\169\230\149\176\230\141\174\233\148\153\232\175\175\239\188\129")
    return
  end
  if state == 0 then
    UIUtil.ShowTipsId("remark_success_toast")
    DataCenter.PlayerInfoDataManager:AddOrRefreshPlayerRemark(msg.targetUid, msg.remark, msg.lastUpdateTime)
    EventManager:GetInstance():Broadcast(EventId.RemarkNameChangedUpdate, CheckNameType.None)
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWRemarkNameList) then
      DataCenter.PlayerInfoDataManager:RequestRemarkNameList(1)
    end
  elseif state == -1 and msg.reason ~= nil then
    EventManager:GetInstance():Broadcast(EventId.RemarkNameChangedUpdate, msg.reason)
  end
end

RemarkNameChangeMessage.OnCreate = OnCreate
RemarkNameChangeMessage.HandleMessage = HandleMessage
return RemarkNameChangeMessage
