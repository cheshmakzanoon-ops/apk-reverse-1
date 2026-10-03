local UIBattlefieldDsbDuelBattleResultView = BaseClass("UIBattlefieldDsbDuelBattleResultView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIBattlefieldDsbDuelBattleResultItem = require("UI.DsbDuelBattlefield.Result.UIBattlefieldDsbDuelBattleResultItem")

function UIBattlefieldDsbDuelBattleResultView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBattlefieldDsbDuelBattleResultView:OnDestroy()
  self:DeletePopupTimer()
  self.state = nil
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBattlefieldDsbDuelBattleResultView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTmpTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.compItem4 = self.viewSkin:AddComponent(self, UIBattlefieldDsbDuelBattleResultItem, 2)
  self.compItem3 = self.viewSkin:AddComponent(self, UIBattlefieldDsbDuelBattleResultItem, 3)
  self.compItem2 = self.viewSkin:AddComponent(self, UIBattlefieldDsbDuelBattleResultItem, 4)
  self.compItem1 = self.viewSkin:AddComponent(self, UIBattlefieldDsbDuelBattleResultItem, 5)
  self.btnQuit = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnQuit:SetOnClick(function()
    self:OnBtnQuitClick()
  end)
  self.compRanListNode = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.imgFlagIcon = self.viewSkin:AddComponent(self, UIImage, 8)
  self.textTmpWinScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textTmpRankPopupTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textTmpRankPopupAbbr = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.textTmpRankPopupScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.compRankPopupNode = self.viewSkin:AddComponent(self, UIBaseContainer, 13)
  self.btnBackground = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnBackground:SetOnClick(function()
    self:OnBtnBackgroundClick()
  end)
  self.compWinPopNode = self.viewSkin:AddComponent(self, UIBaseComponent, 15)
  self.imgWinIcon = self.viewSkin:AddComponent(self, UIImage, 16)
  self.btnNotice = self.viewSkin:AddComponent(self, UIButton, 17)
  self.btnNotice:SetOnClick(function()
    self:OnBtnNoticeClick()
  end)
  self.compEmptyNode = self.viewSkin:AddComponent(self, UIBaseContainer, 18)
  self.compItems = {
    self.compItem1,
    self.compItem2,
    self.compItem3,
    self.compItem4
  }
  self.state = 0
  self:RefreshMine()
  self:RefreshItems()
  self:ShowMyScore()
  self.btnQuit:SetActive(false)
end

function UIBattlefieldDsbDuelBattleResultView:ComponentDestroy()
  self.viewSkin = nil
  self.textTmpTitle = nil
  self.compItem4 = nil
  self.compItem3 = nil
  self.compItem2 = nil
  self.compItem1 = nil
  self.btnQuit = nil
  self.compRanListNode = nil
  self.imgFlagIcon = nil
  self.textTmpWinScore = nil
  self.textTmpRankPopupTitle = nil
  self.textTmpRankPopupAbbr = nil
  self.textTmpRankPopupScore = nil
  self.compRankPopupNode = nil
  self.btnBackground = nil
  self.compWinPopNode = nil
  self.imgWinIcon = nil
  self.btnNotice = nil
  self.compEmptyNode = nil
end

function UIBattlefieldDsbDuelBattleResultView:DataDefine()
end

function UIBattlefieldDsbDuelBattleResultView:DataDestroy()
end

function UIBattlefieldDsbDuelBattleResultView:OnAddListener()
  base.OnAddListener(self)
end

function UIBattlefieldDsbDuelBattleResultView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBattlefieldDsbDuelBattleResultView:OnBtnQuitClick()
  self.ctrl:CloseSelf()
  BattleFieldUtil.LeaveBattlefield()
end

function UIBattlefieldDsbDuelBattleResultView:RefreshItems()
  local battleInfo = BattlefieldDsbDuelUtils.BattleInfo
  if not battleInfo then
    for k, v in ipairs(self.compItems) do
      v:SetActive(false)
    end
    return
  end
  for k, v in ipairs(self.compItems) do
    local data = battleInfo:GetResultByRank(k)
    if data then
      v:Setup(k, data)
      v:SetActive(true)
    else
      v:SetActive(false)
    end
  end
end

function UIBattlefieldDsbDuelBattleResultView:RefreshMine()
  local battleInfo = BattlefieldDsbDuelUtils.BattleInfo
  if not battleInfo then
    return
  end
  local myResult = battleInfo:GetMyResult()
  if myResult then
    self.textTmpTitle:SetActive(true)
    self.textTmpRankPopupTitle:SetActive(true)
    self.textTmpTitle:SetLocalText("801140", myResult.rank)
    self.textTmpRankPopupTitle:SetLocalText("801140", myResult.rank)
    self.imgFlagIcon:LoadSpriteAsync(string.format(AL_FLAG_SPRITE_PATH, myResult.allianceIcon))
    self.textTmpRankPopupAbbr:SetText(BattlefieldDsbDuelUtils.GetAllianceAbbr(myResult.allianceAbbr))
    self.textTmpRankPopupScore:SetText(string.GetFormattedStr(myResult.battleResultScore or 0))
    self.textTmpWinScore:SetText(string.GetFormattedStr(myResult.score or 0))
    self.compEmptyNode:SetActive(true)
  else
    self.textTmpTitle:SetActive(false)
    self.textTmpRankPopupTitle:SetActive(false)
    self.compEmptyNode:SetActive(false)
  end
  self.myResult = myResult
end

function UIBattlefieldDsbDuelBattleResultView:ShowMyScore()
  self.state = 1
  self.compRanListNode:SetActive(false)
  self.compRankPopupNode:SetActive(true)
  local emptyRoles = BattlefieldDsbDuelUtils.GetEmptyRoles(BattlefieldDsbDuelUtils.GetCurrentTeam())
  if 0 < emptyRoles then
    self:ShowPopupTimer()
  end
end

function UIBattlefieldDsbDuelBattleResultView:ShowScore()
  self.state = 2
  self.compRanListNode:SetActive(true)
  self.compRankPopupNode:SetActive(false)
  self:DeletePopupTimer()
end

function UIBattlefieldDsbDuelBattleResultView:TryShowWinningTips()
  if self.myResult then
    BattlefieldDsbDuelUtils.ShowWinningTipsParams(self.compWinPopNode:GetPosition(), {
      name0 = Localization:GetString("dsb_duel_tips_1007"),
      name1 = Localization:GetString("801140", self.myResult.rank),
      point0 = self.myResult.winAddExtraScore,
      point1 = self.myResult.rankScore,
      vertical = BattlefieldTipsVertical.Down
    })
  end
end

function UIBattlefieldDsbDuelBattleResultView:OnBtnBackgroundClick()
  if self.state == 1 then
    self:ShowScore()
  elseif self.state > 1 then
    self.ctrl:CloseSelf()
    BattleFieldUtil.LeaveBattlefield()
  end
end

function UIBattlefieldDsbDuelBattleResultView:ShowPopupTimer()
  self:DeletePopupTimer()
  self.popupTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:OnBtnNoticeClick()
  end, 0.2)
end

function UIBattlefieldDsbDuelBattleResultView:DeletePopupTimer()
  if self.popupTimer then
    self.popupTimer:Stop()
    self.popupTimer = nil
  end
end

function UIBattlefieldDsbDuelBattleResultView:OnBtnNoticeClick()
  local emptyRoles = BattlefieldDsbDuelUtils.GetEmptyRoles(BattlefieldDsbDuelUtils.GetCurrentTeam())
  if self.myResult and 0 < emptyRoles then
    local notice = Localization:GetString("dsb_duel_tips_1019", string.GetFormattedSeparatorNum(self.myResult.score), emptyRoles, string.GetFormattedSeparatorNum(self.myResult.oriScore))
    UIUtil.ShowBubbleTipsAuto(notice, self.btnNotice.transform.position, 0, 0, 0)
  end
end

return UIBattlefieldDsbDuelBattleResultView
