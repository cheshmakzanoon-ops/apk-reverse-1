local base = UICanvasGroup
local ScoreDsbDuelItem = BaseClass("ScoreDsbDuelItem", base)
local Localization = CS.GameEntry.Localization

function ScoreDsbDuelItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ScoreDsbDuelItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ScoreDsbDuelItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTmpRank1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTmpAlliance1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.imgFlagIcon1 = self.viewSkin:AddComponent(self, UIImage, 3)
  self.textScore1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textTitle1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.compInfo1 = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.imgIcon1 = self.viewSkin:AddComponent(self, UIImage, 7)
  self.textTime1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.imgInfo1 = self.viewSkin:AddComponent(self, UIImage, 9)
end

function ScoreDsbDuelItem:ComponentDestroy()
  self.viewSkin = nil
  self.textTmpRank1 = nil
  self.textTmpAlliance1 = nil
  self.imgFlagIcon1 = nil
  self.textScore1 = nil
  self.textTitle1 = nil
  self.compInfo1 = nil
  self.imgIcon1 = nil
  self.textTime1 = nil
  self.imgInfo1 = nil
end

function ScoreDsbDuelItem:DataDefine()
end

function ScoreDsbDuelItem:DataDestroy()
end

function ScoreDsbDuelItem:OnAddListener()
  base.OnAddListener(self)
end

function ScoreDsbDuelItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ScoreDsbDuelItem:ReInit(configScore, config, serverBattleType, scoreData, leftInfo, rightInfo)
  if not scoreData then
    return
  end
  self.imgIcon1:LoadSprite(configScore.icon)
  self.imgIcon1:SetAspectSize(90)
  self.textTime1:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(scoreData.time, false))
  local extra = scoreData.extra
  local alliance = extra and extra.winAlliance
  self.textTitle1:SetLocalText("dsb_duel_tips_1025")
  self.textScore1:SetText("+" .. string.GetFormattedSeparatorNum(scoreData.score or configScore.score or 0) .. "pt")
  if alliance then
    self.imgFlagIcon1:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(alliance.icon)))
    self.imgFlagIcon1:SetAspectSize(95)
    self.textTmpAlliance1:SetText(BattleFieldUtil.ConvertAllianceName(alliance.server, alliance.abbr, alliance.alliancename))
  end
  local rank = extra.rank
  if rank then
    self.textTmpRank1:SetLocalText("801140", rank)
  end
  local isWinner = SeasonUtil.IsAlly(scoreData.serverId, leftInfo.serverId, scoreData.allianceId, leftInfo.allianceId)
  local xOffset, yOffset
  if isWinner then
    xOffset = -20
    yOffset = -18
    self.textTime1:SetAlignment(CS.TMPro.TextAlignmentOptions.MidlineLeft)
    self.textTime1:SetColorRGBA(0, 0.9647058823529412, 1, 1)
    self.textTitle1:SetColorRGBA(0, 0.9647058823529412, 1, 1)
    self.textScore1:SetColorRGBA(0, 0.9647058823529412, 1, 1)
    self.imgInfo1:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_wofangjilubg.png")
  else
    xOffset = 20
    yOffset = -18
    self.textTime1:SetAlignment(CS.TMPro.TextAlignmentOptions.MidlineRight)
    self.textTime1:SetColorRGBA(1, 0.5490196078431373, 0.4745098039215686, 1)
    self.textTitle1:SetColorRGBA(1, 0.5490196078431373, 0.4745098039215686, 1)
    self.textScore1:SetColorRGBA(1, 0.5490196078431373, 0.4745098039215686, 1)
    self.imgInfo1:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_difangjilubg.png")
  end
  self.compInfo1:SetAnchoredPositionXY(xOffset, yOffset)
end

return ScoreDsbDuelItem
