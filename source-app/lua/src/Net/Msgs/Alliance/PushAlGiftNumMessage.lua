local PushAlGiftNumMessage = BaseClass("PushAlGiftNumMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.allianceNewMail ~= nil then
    DataCenter.AllianceGiftDataManager:UpdateGiftNum(t.allianceNewMail)
    DataCenter.AllianceGiftDataManager:UpdateOneGiftInfo(t.giftInfo)
    if t.groupId and t.redPoint then
      local groupID = t.groupId
      local redPointNum = t.redPoint
      local type = GetTableData(TableName.AllianceGiftGroup, groupID, "type")
      DataCenter.AllianceGiftDataManager:SetRedPointNum(tonumber(type), redPointNum)
    end
    EventManager:GetInstance():Broadcast(EventId.UpdateAllianceGiftNum)
    if t.groupId then
      local giftName = ""
      local groupID = t.groupId
      local nameDialog = GetTableData(TableName.AllianceGiftGroup, groupID, "name")
      giftName = Localization:GetString(nameDialog)
      if t.fromMsg and t.fromMsg.fromType == "monster" then
        giftName = Localization:GetString(nameDialog, t.fromMsg.level)
      end
      UIUtil.ShowTips(Localization:GetString("390881", giftName), nil, nil, nil, true)
    end
  end
end

PushAlGiftNumMessage.OnCreate = OnCreate
PushAlGiftNumMessage.HandleMessage = HandleMessage
return PushAlGiftNumMessage
