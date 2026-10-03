local PushZoneMobilizationFindSurpriseMessage = BaseClass("PushZoneMobilizationFindSurpriseMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function PushZoneMobilizationFindSurpriseMessage:OnCreate()
  base.OnCreate(self)
end

function PushZoneMobilizationFindSurpriseMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif message.type then
    local isShowRemind = DataCenter.LWZoneMobilizationManager:GetIsNewFunc() and not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UICommonSpecRemind)
    local duration = LuaEntry.DataConfig:TryGetNum("lock_banner", "k2", 0)
    if message.type == ZoneMobilizationDonatePushType.ResourcePoint then
      UIUtil.ShowTips(Localization:GetString("zone_mobilization_donated_gather_tips"), duration)
    elseif message.type == ZoneMobilizationDonatePushType.SuppliesPoint then
      UIUtil.ShowTips(Localization:GetString("zone_mobilization_donated_supplies_tips"), duration)
    end
    if isShowRemind then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonSpecRemind, {anim = true}, message)
    end
  end
end

return PushZoneMobilizationFindSurpriseMessage
