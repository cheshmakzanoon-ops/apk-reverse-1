local base = UIBaseContainer
local LuckyPacketShareTipBtn = BaseClass("LuckyPacketShareTipBtn", UIBaseContainer)

function LuckyPacketShareTipBtn:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LuckyPacketShareTipBtn:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LuckyPacketShareTipBtn:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnShare = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnShare:SetOnClick(function()
    self:OnBtnShareClick()
  end)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
end

function LuckyPacketShareTipBtn:ComponentDestroy()
  self.viewSkin = nil
  self.btnShare = nil
  self.textTime = nil
end

function LuckyPacketShareTipBtn:OnEnable()
  base.OnEnable(self)
end

function LuckyPacketShareTipBtn:OnDisable()
  self.textTime:SetText("")
  base.OnDisable(self)
end

function LuckyPacketShareTipBtn:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LUCKY_PACKET_SHARE_SUCCESS, self.RefreshTime)
end

function LuckyPacketShareTipBtn:OnRemoveListener()
  self:RemoveUIListener(EventId.LUCKY_PACKET_SHARE_SUCCESS, self.RefreshTime)
  base.OnRemoveListener(self)
end

function LuckyPacketShareTipBtn:Update1000MS()
  self:RefreshTime()
end

function LuckyPacketShareTipBtn:OnBtnShareClick()
  DataCenter.LuckyBuffManager:OpenLuckyPacketSharePopup()
end

function LuckyPacketShareTipBtn:RefreshTime()
  local end_time = DataCenter.LuckyBuffManager:GetShortestExpireTime()
  if end_time <= 0 then
    self.textTime:SetText("")
    self:SetActive(false)
    return
  end
  local diff_time = end_time - UITimeManager:GetInstance():GetServerTime()
  if diff_time <= 0 then
    DataCenter.LuckyBuffManager:FilterExpiredLuckyPacket()
    self:RefreshTime()
    return
  end
  self.textTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtStringWithoutHour(diff_time))
end

return LuckyPacketShareTipBtn
