local base = UIAsyncContainer
local AllyDuelTodayGachaTipBubble = BaseClass("AllyDuelTodayGachaTipBubble", UIAsyncContainer)
local Localization = CS.GameEntry.Localization

function AllyDuelTodayGachaTipBubble:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllyDuelTodayGachaTipBubble:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllyDuelTodayGachaTipBubble:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnAllyDuelTodayGachaTipBubble = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnAllyDuelTodayGachaTipBubble:SetOnClick(function()
    self:OnBtnAllyDuelTodayGachaTipBubbleClick()
  end)
  self.compRedDot = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.textRedDotTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
end

function AllyDuelTodayGachaTipBubble:ComponentDestroy()
  self.viewSkin = nil
  self.btnAllyDuelTodayGachaTipBubble = nil
  self.compRedDot = nil
  self.textRedDotTxt = nil
end

function AllyDuelTodayGachaTipBubble:DataDefine()
end

function AllyDuelTodayGachaTipBubble:DataDestroy()
end

function AllyDuelTodayGachaTipBubble:OnEnable()
  base.OnEnable(self)
  self:RefreshRedDot()
end

function AllyDuelTodayGachaTipBubble:OnDisable()
  base.OnDisable(self)
end

function AllyDuelTodayGachaTipBubble:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllyDuelScoreGachaWishClaim, self.RefreshRedDot)
  self:AddUIListener(EventId.AllyDuelScoreGachaUpdateScore, self.RefreshRedDot)
  self:AddUIListener(EventId.AllyDuelScoreGachaGotData, self.RefreshRedDot)
  self:AddUIListener(EventId.OnPassDay, self.OnPassDay)
end

function AllyDuelTodayGachaTipBubble:OnRemoveListener()
  self:RemoveUIListener(EventId.AllyDuelScoreGachaWishClaim, self.RefreshRedDot)
  self:RemoveUIListener(EventId.AllyDuelScoreGachaUpdateScore, self.RefreshRedDot)
  self:RemoveUIListener(EventId.AllyDuelScoreGachaGotData, self.RefreshRedDot)
  self:RemoveUIListener(EventId.OnPassDay, self.OnPassDay)
  base.OnRemoveListener(self)
end

function AllyDuelTodayGachaTipBubble:ReInit()
  CommonUtil.PlayerPrefsSetBool(SettingKeys.AD_GACHA_TIP_BUBBLE_SHOWN, true)
end

function AllyDuelTodayGachaTipBubble:RefreshRedDot()
  local redNum = DataCenter.AllyDuelScoreGachaManager:GetTotalRedDotNum()
  self.compRedDot:SetActive(0 < redNum)
  self.textRedDotTxt:SetText(99 < redNum and "99+" or redNum)
end

function AllyDuelTodayGachaTipBubble:OnPassDay()
  DataCenter.AllyDuelScoreGachaManager:SendGetGachaInfoMessage()
end

function AllyDuelTodayGachaTipBubble:OnBtnAllyDuelTodayGachaTipBubbleClick()
  if self.holder.curPage == self.holder.pageNum - 1 and self.holder.isShowGacha then
    self.holder:OnClickRightBtn()
  end
end

return AllyDuelTodayGachaTipBubble
