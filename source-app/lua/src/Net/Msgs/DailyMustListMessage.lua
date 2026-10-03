local DailyMustListMessage = BaseClass("DailyMustListMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.DailyMustBuyManager:UpdateData(t)
    if not table.IsNullOrEmpty(t.resource_items) then
      DataCenter.ResourceItemDataManager:RefreshItemList(t)
    else
      DataCenter.ResourceItemDataManager:RemoveItemByItemId(DataCenter.DailyMustBuyManager:GetItemId())
    end
  end
end

DailyMustListMessage.OnCreate = OnCreate
DailyMustListMessage.HandleMessage = HandleMessage
return DailyMustListMessage
