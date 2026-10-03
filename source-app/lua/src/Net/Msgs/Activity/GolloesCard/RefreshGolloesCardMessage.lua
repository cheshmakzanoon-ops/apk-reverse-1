local RefreshGolloesCardMessage = BaseClass("RefreshGolloesCardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActGolloesCardData:RefreshCardHandle(t)
  end
end

RefreshGolloesCardMessage.OnCreate = OnCreate
RefreshGolloesCardMessage.HandleMessage = HandleMessage
return RefreshGolloesCardMessage
