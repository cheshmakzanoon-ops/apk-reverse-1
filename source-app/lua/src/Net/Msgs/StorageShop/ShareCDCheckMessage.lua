local ShareCDCheckMessage = BaseClass("ShareCDCheckMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, type)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.canSend then
    if t.type then
      if t.type == ShareCheckType.StorageShop then
        DataCenter.StorageShopManager:OnRecvShareCheckResult(t)
      elseif t.type == ShareCheckType.MailScoutResult or t.type == ShareCheckType.MailBattleReport then
        DataCenter.MailDataManager:OnRecvShareCheckResult(t)
      end
    end
  else
    local nextT = t.nextTime
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local strInterval = UITimeManager:GetInstance():MilliSecondToFmtString(nextT - curTime)
    UIUtil.ShowTips(Localization:GetString("121067", strInterval))
  end
end

ShareCDCheckMessage.OnCreate = OnCreate
ShareCDCheckMessage.HandleMessage = HandleMessage
return ShareCDCheckMessage
