local base = UIBaseContainer
local UIGhostRankItemComponent = BaseClass("UIGhostRankItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UICommonHead = require("Framework.UI.Component.UICommonHead")

function UIGhostRankItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIGhostRankItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGhostRankItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgFirst = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgRank = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textNumTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.uIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 6)
  self.textNormalNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnPlay = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnPlay:SetOnClick(function()
    self:OnBtnPlayClick()
  end)
  self.btnThumpsUp = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnThumpsUp:SetOnClick(function()
    self:OnBtnThumpsUpClick()
  end)
  self.textServer = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textCount = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.btnChallenge = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnChallenge:SetOnClick(function()
    self:OnBtnChallengeClick()
  end)
  self.btnNotPlay = self.viewSkin:AddComponent(self, UIButton, 13)
  self.btnNotPlay:SetOnClick(function()
    self:OnBtnNotPlayClick()
  end)
  self.compLikeCommonRedPoint = self.viewSkin:AddComponent(self, UICommonRedPoint, 14)
  self.compChallengeCommonRedPoint = self.viewSkin:AddComponent(self, UICommonRedPoint, 15)
  self.effect = self.viewSkin:AddComponent(self, UIBaseContainer, 16)
  self.playerBtn = self:AddComponent(UIButton, "UIPlayerHead")
  self.playerBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, self.uid)
  end)
  self.compLikeCommonRedPoint:SetType(CommonRedPointPriority.Level1)
  self.compLikeCommonRedPoint:SetActive(false)
  self.compChallengeCommonRedPoint:SetType(CommonRedPointPriority.Level1)
  self.compChallengeCommonRedPoint:SetActive(false)
  self.effect.gameObject:SetActive(false)
end

function UIGhostRankItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.imgFirst = nil
  self.imgRank = nil
  self.textNumTxt = nil
  self.textName = nil
  self.textTime = nil
  self.uIPlayerHead = nil
  self.textNormalNum = nil
  self.btnPlay = nil
  self.btnThumpsUp = nil
  self.textServer = nil
  self.textCount = nil
  self.btnChallenge = nil
  self.btnNotPlay = nil
  self.compLikeCommonRedPoint = nil
  self.compChallengeCommonRedPoint = nil
  self.effect = nil
end

function UIGhostRankItemComponent:DataDefine()
  self:AddUIListener(EventId.GhostParkourTypeRankPraiseRefresh, self.UpdatePraiseNum)
  self:AddUIListener(EventId.GhostParkourChallengeBtnRed, self.UpdateChallengeRedPoint)
end

function UIGhostRankItemComponent:DataDestroy()
  self:RemoveUIListener(EventId.GhostParkourTypeRankPraiseRefresh, self.UpdatePraiseNum)
  self:RemoveUIListener(EventId.GhostParkourChallengeBtnRed, self.UpdateChallengeRedPoint)
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
  self.emojiBtns = nil
  self.type = nil
  self.uid = nil
  self.showInfo = nil
  self.stageId = nil
  self.isFirst = nil
end

function UIGhostRankItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIGhostRankItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIGhostRankItemComponent:OnBtnPlayClick()
  if self.showInfo and self.stageId then
    local param = {}
    param.type = PVEType.GhostParkour
    param.enterType = PVEEnterType.GhostPlayback
    param.levelId = self.stageId
    local uid = self.showInfo.uid
    if uid == nil or uid == 0 or uid == "" then
      Logger.LogError("GhostParkour -- UIGhostRankItemComponent showInfo.uid error")
    end
    local uuid = self.showInfo.uuid
    if uuid == nil or uuid == 0 then
      Logger.LogError("GhostParkour -- UIGhostRankItemComponent showInfo.uuid error")
    end
    local firstInfo = {}
    table.copy(self.showInfo, firstInfo)
    param.message = {firstInfo = firstInfo}
    DataCenter.LWBattleManager:Enter(param)
  end
end

function UIGhostRankItemComponent:OnBtnNotPlayClick()
  UIUtil.ShowTipsId("ghost_parkour_no_replay")
end

function UIGhostRankItemComponent:OnBtnThumpsUpClick()
  local round = DataCenter.LWGhostParkourDataManager:GetGhostParkourRound()
  local rankData = DataCenter.LWGhostParkourDataManager:GetTypeRankInfo(round, self.type)
  self.effect.gameObject:SetActive(false)
  if rankData then
    local count = rankData.remainPraise
    if 0 < count then
      DataCenter.LWGhostParkourDataManager:SendGhostParkourRankPraiseMessage(self.type, self.uid)
    end
  end
end

function UIGhostRankItemComponent:OnBtnChallengeClick()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  CommonUtil.PlayerPrefsSetLong(SettingKeys.GHOST_PARKOUR_ON_FIRST_CHALLENGE_BTN, curTime)
  EventManager:GetInstance():Broadcast(EventId.GhostParkourChallengeBtnRed)
  local now = DataCenter.LWGhostParkourDataManager:GetRemainChallengeTimes()
  if now <= 0 then
    UIUtil.ShowTipsId("ghost_parkour_challenge_finish")
    return
  end
  local curTs = UITimeManager:GetInstance():GetServerTime()
  if self.clickTs == nil then
    self.clickTs = curTs
  elseif curTs - self.clickTs <= 500 then
    return
  end
  self.clickTs = curTs
  local curTs2 = UITimeManager:GetInstance():GetServerTime()
  local battleEndTime = DataCenter.LWGhostParkourDataManager:GetRoundEndTime()
  local leftTime = battleEndTime - curTs2
  local fixTime = DataCenter.LWGhostParkourDataManager:GetDelayTime()
  if leftTime < fixTime and 0 < leftTime then
    local param = {
      contentText = Localization:GetString("ghost_parkour_count_down_minute"),
      btnNum = 2,
      confirmBtnParam = {
        action = function()
          if self.uid then
            DataCenter.LWGhostParkourDataManager:ReqFightChallenge(self.uid)
          end
        end
      }
    }
    UIUtil.TryShowConfirmNew(TodayNoSecondConfirmType.Ghost_Parkour_Enter_Button, param)
  else
    local param = {
      contentText = Localization:GetString("ghost_parkour_challenge_check"),
      btnNum = 2,
      confirmBtnParam = {
        action = function()
          DataCenter.LWGhostParkourDataManager:CheckDeviceLevel(function()
            if self.uid then
              DataCenter.LWGhostParkourDataManager:ReqFightChallenge(self.uid)
            end
          end)
        end
      }
    }
    UIUtil.TryShowConfirmNew(TodayNoSecondConfirmType.Ghost_Parkour_Challenge_Other, param)
  end
end

function UIGhostRankItemComponent:SetItemShow(rankType, showInfo, stageId)
  self.type = rankType
  self.showInfo = showInfo
  self.stageId = stageId
  if showInfo then
    self.uid = showInfo.uid
    self.btnChallenge.gameObject:SetActive(self.uid ~= LuaEntry.Player.uid)
    local bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_4.png"
    self.isFirst = true
    if showInfo.name then
      self.textName:SetText(showInfo.name)
    else
      self.textName:SetText("")
    end
    local serverName = showInfo.srcServer
    if showInfo.abbr then
      serverName = UIUtil.FormatServerAllianceName(serverName, showInfo.abbr)
    else
      serverName = string.format("#%s", serverName)
    end
    self.textServer:SetText(serverName)
    if showInfo.rank == 1 then
      bgPath = "Assets/Main/Sprites/UI/UIGhostParkour/UIGhostParkourMainUI/mjc_paoku_paihang_list_1.png"
    elseif showInfo.rank == 2 then
      bgPath = "Assets/Main/Sprites/UI/UIGhostParkour/UIGhostParkourMainUI/mjc_paoku_paihang_list_2.png"
    elseif showInfo.rank == 3 then
      bgPath = "Assets/Main/Sprites/UI/UIGhostParkour/UIGhostParkourMainUI/mjc_paoku_paihang_list_3.png"
    else
      self.isFirst = false
    end
    self.btnThumpsUp.gameObject:SetActive(self.isFirst)
    self.uIPlayerHead:SetHeadAndFrame(showInfo.uid, showInfo.pic, showInfo.picver, nil, showInfo.headSkinId, showInfo.headSkinET)
    if self.isFirst then
      self.imgFirst.gameObject:SetActive(true)
      self.textNormalNum.gameObject:SetActive(false)
      self.imgFirst:LoadSpriteAsync(bgPath)
      self.textNumTxt:SetText(showInfo.rank)
      self.imgRank:LoadSpriteAsync(NewRankIconPath[showInfo.rank])
    else
      self.imgFirst.gameObject:SetActive(false)
      self.textNormalNum.gameObject:SetActive(true)
      if showInfo.rank < 1 then
        self.textNormalNum:SetLocalText("challenge_zombie_no_rank")
      else
        self.textNormalNum:SetText(showInfo.rank)
      end
    end
    if showInfo.score and showInfo.score > 0 then
      local time = UITimeManager:GetInstance():GetCompetitionTimeFormat(showInfo.score)
      self.textTime:SetLocalText("ghost_parkour_rank_best_record", time)
    else
      self.textTime:SetText("")
    end
    if showInfo.allowSameServerWatch then
      self.btnPlay.gameObject:SetActive(true)
      self.btnNotPlay.gameObject:SetActive(false)
    else
      self.btnPlay.gameObject:SetActive(false)
      self.btnNotPlay.gameObject:SetActive(true)
    end
    if showInfo.praiseNum then
      self.textCount:SetText(showInfo.praiseNum)
    else
      self.textCount:SetText("")
    end
  end
  self:UpdateThumbsUpRedPoint()
  self:UpdateChallengeRedPoint()
end

function UIGhostRankItemComponent:UpdatePraiseNum(param)
  if param and self.uid and self.uid == param.targetUid then
    self.textCount:SetText(param.praiseNum)
    self.effect.gameObject:SetActive(true)
    if self.delay then
      self.delay:Stop()
      self.delay = nil
    end
    self.delay = TimerManager:GetInstance():DelayInvoke(function()
      if self and self.effect then
        self.effect.gameObject:SetActive(false)
      end
    end, 1.5)
  end
  self:UpdateThumbsUpRedPoint()
end

function UIGhostRankItemComponent:UpdateThumbsUpRedPoint()
  local redRankThumbsUp = DataCenter.LWGhostParkourDataManager:GetTypeRankItemThumbsUpRedPoint(self.type)
  self.compLikeCommonRedPoint:SetDefaultVisible(redRankThumbsUp)
end

function UIGhostRankItemComponent:UpdateChallengeRedPoint()
  if self.isFirst then
    local redRankChallenge = DataCenter.LWGhostParkourDataManager:GetRankChallengeRedPoint(self.type)
    self.compChallengeCommonRedPoint:SetDefaultVisible(redRankChallenge)
  else
    self.compChallengeCommonRedPoint:SetDefaultVisible(false)
  end
end

return UIGhostRankItemComponent
