local AllianceGiftListMessage = BaseClass("AllianceGiftListMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, index, len, type)
  base.OnCreate(self)
  self.sfsObj:PutInt("index", index)
  self.sfsObj:PutInt("len", len)
  if type ~= nil then
    self.sfsObj:PutInt("type", type)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceGiftDataManager:RetBaseData(t)
    if t.allianceNewMail ~= nil then
      DataCenter.AllianceGiftDataManager:UpdateGiftNum(t.allianceNewMail)
    end
    local type = t.type
    if type ~= nil then
      DataCenter.AllianceGiftDataManager:UpdateOneTypeGiftInfo(t.info, type)
    else
      DataCenter.AllianceGiftDataManager:UpdateGiftInfoList(t)
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshAllianceGift)
    EventManager:GetInstance():Broadcast(EventId.UpdateAllianceGiftNum)
  end
end

AllianceGiftListMessage.OnCreate = OnCreate
AllianceGiftListMessage.HandleMessage = HandleMessage
return AllianceGiftListMessage
