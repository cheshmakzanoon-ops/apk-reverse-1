local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UISurfingBattleActMain = BaseClass("UISurfingBattleActMain", base)
local Localization = CS.GameEntry.Localization
local RewardItem = require("UI.UISurfing.UIAct.rewardBoxItem")
local PlayerInviteItem = require("UI.UISurfing.UIAct.PlayerInviteItem")

function UISurfingBattleActMain:OnCreate()
  base.OnCreate(self)
  DataCenter.LWBattleManager:SetBattleExitEndTime(BattleExitTimeLogType.Surfing)
  self:ComponentDefine()
  self:DataDefine()
  self:InitUI()
end

function UISurfingBattleActMain:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISurfingBattleActMain:ComponentDefine()
  self.compUISurfingBattleActMain = self:AddComponent(UIBaseComponent, "")
  self.imgBg = self:AddComponent(UIRawImage, "SafeArea/mask/imgbg")
  self.effectBg = self:AddComponent(UIRawImage, "SafeArea/mask/bgEffect")
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "SafeArea/Top/Root/title")
  self.textSubTitle = self:AddComponent(UITextMeshProUGUIEx, "SafeArea/Top/rootSub/textSubTitle")
  self.btnInfo = self:AddComponent(UIButton, "SafeArea/Top/InfoBtn")
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.textRemainTime = self:AddComponent(UITextMeshProUGUIEx, "SafeArea/Top/TimeRoot/Bg/remainTime")
  self.coinBtn = self:AddComponent(UIButton, "SafeArea/Top/resourceRect")
  self.coinBtn:SetOnClick(function()
    self:OnCoinBtnClick(self.coinBtn, -50, true, -15)
  end)
  self.textResourceNum = self:AddComponent(UITextMeshProUGUIEx, "SafeArea/Top/resourceRect/resourceNum")
  self.imgResourceIcon = self:AddComponent(UIImage, "SafeArea/Top/resourceRect/resourceIcon")
  self.imgScoreBg = self:AddComponent(UIImage, "SafeArea/Top/scoreBg")
  self.btnScoreRank = self:AddComponent(UIButton, "SafeArea/Top/scoreBg")
  self.btnScoreRank:SetOnClick(function()
    self:OnBtnScoreRankClick()
  end)
  self.textScoreTitle = self:AddComponent(UITextMeshProUGUIEx, "SafeArea/Top/scoreBg/scoreTitleText")
  self.textScoreNum = self:AddComponent(UITextMeshProUGUIEx, "SafeArea/Top/scoreBg/scoreNumText")
  self.imgMvp = self:AddComponent(UIImage, "SafeArea/Top/imgMvp")
  self.compPlayer = self:AddComponent(UICommonHead, "SafeArea/Top/imgMvp/player")
  self.btnBox = self:AddComponent(UIButton, "SafeArea/Top/boxBtn")
  self.btnBox:SetOnClick(function()
    self:OnBtnBoxClick()
  end)
  self.RedPoint = self:AddComponent(UICommonRedPoint, "SafeArea/Top/boxBtn/AllianceCommonRedPoint")
  self.RedPoint:SetType(CommonRedPointPriority.Level1)
  self.RedPoint:SetActive(false)
  self.RedPointDigTreasure = self:AddComponent(UICommonRedPoint, "SafeArea/Top/enterBtn/enterCommonRedPoint")
  self.RedPointDigTreasure:SetType(CommonRedPointPriority.Level1)
  self.RedPointDigTreasure:SetActive(false)
  self.textBox = self:AddComponent(UITextMeshProUGUIEx, "SafeArea/Top/boxBtn/boxText")
  self.btnEnter = self:AddComponent(UIButton, "SafeArea/Top/enterBtn")
  self.btnEnter:SetOnClick(function()
    self:OnBtnEnterClick()
  end)
  self.textEnter = self:AddComponent(UITextMeshProUGUIEx, "SafeArea/Top/enterBtn/enterText")
  self.imgBox = self:AddComponent(UIButton, "SafeArea/bottom/imgBox")
  self.BoxImage = self:AddComponent(UIImage, "SafeArea/bottom/imgBox")
  self.imgBox:SetOnClick(function()
    self:OnBtnImgBoxDailyClick()
  end)
  self.textImgBox = self:AddComponent(UITextMeshProUGUIEx, "SafeArea/bottom/imgBox/imgBoxText")
  self.btnInvite = self:AddComponent(UIButton, "SafeArea/bottom/inviteBtn")
  self.btnInvite:SetOnClick(function()
    self:OnBtnInviteClick()
  end)
  self.btnInviteInfo = self:AddComponent(UIButton, "SafeArea/bottom/inviteImg")
  self.btnInviteInfo:SetOnClick(function()
    self:OnBtnInviteInfoClick()
  end)
  self.textInvite = self:AddComponent(UITextMeshProUGUIEx, "SafeArea/bottom/inviteImg/inviteText")
  self.imgInviteInfoBubbleTips = self:AddComponent(UIImage, "SafeArea/bottom/inviteInfoBubbleTips")
  self.textInviteInfo = self:AddComponent(UITextMeshProUGUIEx, "SafeArea/bottom/inviteInfoBubbleTips/inviteInfoText")
  self.btnGo = self:AddComponent(UIButton, "SafeArea/bottom/goBtn")
  self.btnGo:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.RedPointInvite = self:AddComponent(UICommonRedPoint, "SafeArea/bottom/InviteCommonRedPoint")
  self.RedPointInvite:SetType(CommonRedPointPriority.Level1)
  self.RedPointInvite:SetActive(false)
  self.remainTimes = self:AddComponent(UITextMeshProUGUIEx, "SafeArea/bottom/remainTimes")
  self.emptyTips = self:AddComponent(UITextMeshProUGUIEx, "SafeArea/bottom/emptyTips")
  self.textGoBtn = self:AddComponent(UITextMeshProUGUIEx, "SafeArea/bottom/goBtn/LW_Btn_Common_New_Base/goBtnText")
  self.btnBuff = self:AddComponent(UIButton, "SafeArea/bottom/buffBtn")
  self.btnBuff:SetOnClick(function()
    self:OnBtnBuffClick()
  end)
  self.textBuff = self:AddComponent(UITextMeshProUGUIEx, "SafeArea/bottom/buffBtn/LW_Btn_Common_New_Base/buffText")
  self.buffRedPoint = self:AddComponent(UICommonRedPoint, "SafeArea/bottom/buffBtn/buffCommonRedPoint")
  self.buffRedPointImage = self:AddComponent(UIImage, "SafeArea/bottom/buffBtn/buffCommonRedPoint/bg")
  self.imgProgressArea = self:AddComponent(UIImage, "SafeArea/bottom/progressArea")
  self.scrollRect = self:AddComponent(UIScrollRect, "SafeArea/bottom/progressArea/progress/ScrollView")
  self.viewport = self:AddComponent(UIBaseContainer, "SafeArea/bottom/progressArea/progress/ScrollView/Viewport")
  self.rewardContent = self:AddComponent(UIBaseContainer, "SafeArea/bottom/progressArea/progress/ScrollView/Viewport/Content")
  self.img = self:AddComponent(UIImage, "SafeArea/bottom/progressArea/scoreImage")
  self.scoreBtn = self:AddComponent(UIButton, "SafeArea/bottom/progressArea/scoreImage")
  self.scoreBtn:SetOnClick(function()
    self:OnCoinBtnClick(self.scoreBtn, 65, false, 15)
  end)
  self.textPersonalScore = self:AddComponent(UITextMeshProUGUIEx, "SafeArea/bottom/progressArea/scoreImage/personalScoreText")
  self.rewardItem = self:AddComponent(UIBaseComponent, "SafeArea/bottom/progressArea/progress/ScrollView/Viewport/Content/rewardBox")
  self.rewardItem.gameObject:SetActive(false)
  self.rewardItemPool = self.rewardItem.gameObject
  self.rewardItemPool:GameObjectCreatePool()
  self.rewardItems = {}
  self.itemPlayer = self:AddComponent(UIBaseComponent, "SafeArea/bottom/inviteBtn/itemPlayer")
  self.itemPlayer.gameObject:SetActive(false)
  self.itemPlayerPool = self.itemPlayer.gameObject
  self.itemPlayerPool:GameObjectCreatePool()
  self.itemPlayers = nil
  self.guideBtn = self:AddComponent(UIButton, "SafeArea/Top/GuideBtn")
  self.guideBtn:SetOnClick(function()
    self:OnGuideBtnClick()
  end)
end

function UISurfingBattleActMain:ComponentDestroy()
  self.scrollRect:RemoveAllListeners()
  self.compUISurfingBattleActMain = nil
  self.textTitle = nil
  self.effectBg = nil
  self.btnInfo = nil
  self.textRemainTime = nil
  self.textResourceNum = nil
  self.imgScoreBg = nil
  self.textScoreTitle = nil
  self.textScoreNum = nil
  self.remainTimes = nil
  self.emptyTips = nil
  self.imgMvp = nil
  self.compPlayer = nil
  self.textSubTitle = nil
  self.RedPointInvite = nil
  self.btnBox = nil
  self.textBox = nil
  self.btnEnter = nil
  self.textEnter = nil
  self.imgBox = nil
  self.textImgBox = nil
  self.BoxImage = nil
  self.btnInvite = nil
  self.itemPlayer = nil
  self.btnInviteInfo = nil
  self.RedPoint = nil
  self.textInvite = nil
  self.imgInviteInfoBubbleTips = nil
  self.textInviteInfo = nil
  self.btnGo = nil
  self.textGoBtn = nil
  self.btnBuff = nil
  self.textBuff = nil
  self.imgProgressArea = nil
  self.scrollRect = nil
  self.viewport = nil
  self.rewardContent = nil
  self.img = nil
  self.textPersonalScore = nil
  self.btnScoreRank = nil
  self.imgResourceIcon = nil
end

function UISurfingBattleActMain:DataDefine()
  self.activityId = nil
  self.activityData = nil
  self.personalHightestScore = 0
  self.coinNum = 0
  self.mvpPlayer = nil
  self.boxId = DataCenter.LWSurfingDataManager:GetDailyBoxId()
  self.coinId = DataCenter.LWSurfingDataManager:GetCoinId()
  self.personalBattlePassList = {}
end

function UISurfingBattleActMain:DataDestroy()
  self:CloseTweenSeq()
  self:ClearPlayerInviteContent()
  self:ClearContent()
  self.activityId = nil
  self.personalBattlePassList = nil
  self.activityData = nil
  self.personalHightestScore = nil
  self.coinNum = nil
  self.mvpPlayer = nil
  self.boxId = nil
  self.coinId = nil
end

function UISurfingBattleActMain:OnEnable()
  base.OnEnable(self)
  DataCenter.LWSurfingDataManager:SendGetAllParkourInfosMessage(1)
end

function UISurfingBattleActMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SurfingUpdatePersonalBattlePass, self.UpdateScrollView)
  self:AddUIListener(EventId.SurfingCoinNumRefresh, self.UpdateCoinNum)
  self:AddUIListener(EventId.SurfingActMainUIRefresh, self.InitData)
  self:AddUIListener(EventId.SurfingShowArrowGuide, self.ShowArrowHand)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.UpdateRedPoint)
  self:AddUIListener(EventId.DiggingGameRedUpdate, self.UpdateDigTreasureRedPoint)
  self:AddUIListener(EventId.SurfingInviteRedPoint, self.UpdateInviteRedPoint)
end

function UISurfingBattleActMain:OnRemoveListener()
  self:RemoveUIListener(EventId.SurfingUpdatePersonalBattlePass, self.UpdateScrollView)
  self:RemoveUIListener(EventId.SurfingCoinNumRefresh, self.UpdateCoinNum)
  self:RemoveUIListener(EventId.SurfingActMainUIRefresh, self.InitData)
  self:RemoveUIListener(EventId.SurfingShowArrowGuide, self.ShowArrowHand)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.UpdateRedPoint)
  self:RemoveUIListener(EventId.DiggingGameRedUpdate, self.UpdateDigTreasureRedPoint)
  self:RemoveUIListener(EventId.SurfingInviteRedPoint, self.UpdateInviteRedPoint)
  base.OnRemoveListener(self)
end

function UISurfingBattleActMain:InitUI()
  self.imgResourceIcon:LoadSprite("Assets/Main/Sprites/ItemIcons/lrb_paoku_jifen_daojv.png")
  self.BoxImage:LoadSprite("Assets/Main/Sprites/ItemIcons/lrb_paoku_shenmihezi_daojv.png")
  self.img:LoadSprite("Assets/Main/Sprites/ItemIcons/lrb_paoku_jifen_daojv.png")
  DataCenter.LWSurfingDataManager:CheckTodayFirstEnterAct()
end

function UISurfingBattleActMain:SendAllianceRewardMsg()
  local round = DataCenter.LWSurfingDataManager:GetRound()
  DataCenter.LWSurfingDataManager:SendGetParkourAllianceBattlePassInfoMessage(round)
end

function UISurfingBattleActMain:UpdateScrollView()
  self.personalBattlePassList = DataCenter.LWSurfingDataManager:GetPersonalBattlePassList()
  if self.personalBattlePassList then
    local count = #self.personalBattlePassList
    for i = 1, count do
      local item = self.rewardItems[i]
      if item == nil then
        local go = self.rewardItemPool:GameObjectSpawn(self.rewardContent.transform)
        go.name = "item" .. i
        item = self.rewardContent:AddComponent(RewardItem, go.name)
        self.rewardItems[i] = item
      else
        item.gameObject.transform:SetParent(self.rewardContent.transform)
      end
      item:SetActive(true)
      item:ReInit(self.personalBattlePassList[i], i)
    end
    for i = count + 1, #self.rewardItems do
      local item = self.rewardItems[i]
      if item then
        item:SetActive(false)
      end
    end
  end
  local todayScore = DataCenter.LWSurfingDataManager:GetTodayPersonalProgressScore()
  self.textPersonalScore:SetText(string.GetFormattedStr(todayScore))
end

function UISurfingBattleActMain:ClearContent()
  self.rewardContent:RemoveComponents(RewardItem)
  self.rewardItemPool:GameObjectRecycleAll()
  self.rewardItems = nil
end

function UISurfingBattleActMain:ClearPlayerInviteContent()
  local count = #self.itemPlayers
  for i = 1, count do
    local item = self.itemPlayers[i]
    item:ReInit(nil)
  end
  self.btnInvite:RemoveComponents(PlayerInviteItem)
  self.itemPlayerPool:GameObjectRecycleAll()
  self.itemPlayers = nil
end

function UISurfingBattleActMain:SetData(actId)
  base.SetData(self, actId)
  self.activityId = actId
  if not self.activityId then
    return
  end
  DataCenter.LWSurfingDataManager:SetActId(self.activityId)
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(actId)
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.textTitle:SetLocalText(self.activityData.activityName)
  self:InitData()
  self:Update1000MS()
end

function UISurfingBattleActMain:InitData()
  self:UpdateMainUI()
  self:UpdateHightestScore()
  self:UpdateCoinNum()
  self:UpdateBoxNum()
  self:UpdateHelpBtnTimes()
  self:UpdateScrollView()
  self:UpdateBuffRedPoint()
  self:UpdateInviteRedPoint()
  self:UpdateDigTreasureRedPoint()
  self:SendAllianceRewardMsg()
end

function UISurfingBattleActMain:UpdateMainUI()
  local type = DataCenter.LWSurfingDataManager:GetSelectRoundRankType()
  self:ShowBgEffect(type == SurfingBattleRankRoundType.CoinNum)
  local round = DataCenter.LWSurfingDataManager:GetRound()
  local infos = DataCenter.LWSurfingDataManager:GetMainUIDisplayInfo(self.activityId, round)
  if infos then
    self.imgBg:LoadSpriteAuto(string.format("Assets/Main/TextureEx/UISurfingBattle/%s.png", infos.icon))
    self.textScoreTitle:SetLocalText(infos.rankTitle)
    self.textSubTitle:SetLocalText(infos.subTitle)
  end
  local remainTimes = DataCenter.LWSurfingDataManager:GetRemainTimes()
  if 0 < remainTimes then
    self.emptyTips.gameObject:SetActive(false)
    self.btnGo.gameObject:SetActive(true)
    self.remainTimes.gameObject:SetActive(true)
    self.remainTimes:SetLocalText("parkour_challenge_num", remainTimes)
  else
    self.emptyTips.gameObject:SetActive(true)
    self.btnGo.gameObject:SetActive(false)
    self.remainTimes.gameObject:SetActive(false)
    self.emptyTips:SetLocalText("parkour_challenge_finish")
  end
  local isShowDigEnter = DataCenter.LWSurfingDataManager:IsShowDigGameEntry()
  self.btnEnter:SetActive(isShowDigEnter)
end

function UISurfingBattleActMain:UpdateHightestScore()
  self.personalHightestScore = DataCenter.LWSurfingDataManager:GetPersonalHightestScoreData()
  self.textScoreNum:SetText(string.GetFormattedSeparatorNum(self.personalHightestScore))
end

function UISurfingBattleActMain:UpdateCoinNum()
  self.coinNum = DataCenter.LWSurfingDataManager:GetCoinNum()
  self.textResourceNum:SetText(string.GetFormattedStr(self.coinNum))
end

function UISurfingBattleActMain:UpdateMvpInfo()
  self.mvpPlayer = DataCenter.LWSurfingDataManager:GetMvpPlayer()
  if self.mvpPlayer then
    self.imgMvp.gameObject:SetActive(true)
    self.compPlayer:SetHeadAndFrame(self.mvpPlayer.uid, self.mvpPlayer.headPic, self.mvpPlayer.headPicVer, false, self.mvpPlayer.headSkinId, self.mvpPlayer.headSkinET)
  else
    self.imgMvp.gameObject:SetActive(false)
  end
end

function UISurfingBattleActMain:UpdateRedPoint()
  local red = DataCenter.LWSurfingDataManager:GetAllianceBattlePassRedPointInfo()
  self.RedPoint:SetDefaultVisible(red)
end

function UISurfingBattleActMain:UpdateInviteRedPoint()
  local lastTime = CommonUtil.PlayerPrefsGetLong(SettingKeys.SURFING_BATTLE_INVITE_TIPS, 0)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local isTheSameDay = UITimeManager:GetInstance():IsSameDayForServer(lastTime / 1000, curTime / 1000)
  local players = DataCenter.LWSurfingDataManager:GetInvitePlayers()
  local times = DataCenter.LWSurfingDataManager:GetHelpTimes()
  local playerCount = players and #players or 0
  self.RedPointInvite:SetDefaultVisible(not isTheSameDay and times > playerCount)
end

function UISurfingBattleActMain:UpdateBuffRedPoint()
  local red = DataCenter.LWSurfingDataManager:GetBuffRedPoint()
  self.buffRedPoint.gameObject:SetActive(red)
  local lastTime = CommonUtil.PlayerPrefsGetLong(SettingKeys.SURFING_BATTLE_BUFF_TIPS, 0)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local isTheSameDay = UITimeManager:GetInstance():IsSameDayForServer(lastTime / 1000, curTime / 1000)
  self:SetArrowState(not isTheSameDay)
end

function UISurfingBattleActMain:SetArrowState(show)
  if self.buffRedPointImage then
    self.buffRedPointImage:SetActive(show)
    self:CloseTweenSeq()
    if show then
      self.buffRedPointImage:SetLocalScaleXYZ(0.9, 0.9, 0.9)
      self.buffRedPointImage.transform.localPosition = Vector3.New(0, -10)
      self.tweenSeq = DOTween.Sequence()
      self.tweenSeq:AppendInterval(0.1)
      self.tweenSeq:Append(self.buffRedPointImage.transform:DOLocalMoveY(-20, 0.3)):SetLoops(-1, CS.DG.Tweening.LoopType.Yoyo)
    end
  end
end

function UISurfingBattleActMain:CloseTweenSeq()
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
end

function UISurfingBattleActMain:UpdateDigTreasureRedPoint()
  local isShowDigGameEnter = DataCenter.LWSurfingDataManager:IsShowDigGameEntry()
  local redCount = DataCenter.OffSeasonDiggingDataManager:GetRedCount()
  local isShowRed = isShowDigGameEnter and 0 < redCount
  self.RedPointDigTreasure:SetDefaultVisible(isShowRed)
end

function UISurfingBattleActMain:UpdateBoxNum()
  local now, max = DataCenter.LWSurfingDataManager:GetDailyBoxNum()
  if max == 0 then
    self.imgBox.gameObject:SetActive(false)
  else
    self.imgBox.gameObject:SetActive(true)
    self.textImgBox:SetLocalText("parkour_treasure_obtain_num", now, max)
  end
end

function UISurfingBattleActMain:UpdateHelpBtnTimes()
  local times = DataCenter.LWSurfingDataManager:GetHelpTimes()
  local players = DataCenter.LWSurfingDataManager:GetInvitePlayers()
  local dataCount = players and #players or 0
  if self.itemPlayers == nil then
    self.itemPlayers = {}
    for i = 1, times do
      local go = self.itemPlayerPool:GameObjectSpawn(self.btnInvite.transform)
      go.name = "player" .. i
      local item = self.btnInvite:AddComponent(PlayerInviteItem, go.name)
      self.itemPlayers[i] = item
      item:SetActive(true)
      if i <= dataCount then
        item:ReInit(players[i])
      end
    end
  elseif 0 < dataCount then
    local count = #self.itemPlayers
    for i = 1, count do
      local item = self.itemPlayers[i]
      if dataCount >= i then
        local player = players[i]
        item:ReInit(player)
      else
        item:ReInit(nil)
      end
    end
  else
    for i = 1, #self.itemPlayers do
      local item = self.itemPlayers[i]
      item:ReInit(nil)
    end
  end
end

function UISurfingBattleActMain:Update1000MS()
  if not self.activityId then
    return
  end
  if self.activityData == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.activityData.endTime - curTime
  if leftTime < 0 then
    leftTime = 0
  end
  local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.textRemainTime:SetText(countDownTimeStr)
end

function UISurfingBattleActMain:OnBtnInfoClick()
  if self.activityData == nil then
    return
  end
  local param = {}
  param.howToPlayList = self.activityData.howtoplay
  param.defaultTitle = self.activityData.name
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
end

function UISurfingBattleActMain:OnBtnImgBoxDailyClick()
  local selectedItemData = DataCenter.ItemData:GetItemById(self.boxId)
  local count = 0
  if selectedItemData then
    count = selectedItemData.count or 0
  end
  if 0 < count then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSurfingBattleBoxUsePopView)
  else
    local now, max = DataCenter.LWSurfingDataManager:GetDailyBoxNum()
    if max == now then
      UIUtil.ShowTipsId("parkour_open_box_tips_2")
    else
      UIUtil.ShowTipsId("parkour_open_box_tips_1")
      self:ShowArrowHand()
    end
  end
end

function UISurfingBattleActMain:OnBtnBoxClick()
  if not LuaEntry.Player:IsInAlliance() then
    if LuaEntry.Player:IsFirstJoinAlliance() == true then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {guide = false})
    end
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSurfingBattleAllianceRewardView)
end

function UISurfingBattleActMain:OnBtnEnterClick()
  DataCenter.OffSeasonDiggingDataManager:OpenMainUI()
end

function UISurfingBattleActMain:OnBtnInviteClick()
end

function UISurfingBattleActMain:OnBtnInviteInfoClick()
  local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.Default)
  param.content = Localization:GetString("parkour_alliance_assistance_rule")
  param.alignObject = self.btnInviteInfo
  param.yPosFix = 35
  param.showArrow = true
  param.preferTop = false
  param.width = 600
  param.addPosX = -15 * CommonUtil.ArabicAutoMirrorFactor()
  param.unEnableTouchThrough = true
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
end

function UISurfingBattleActMain:OnCoinBtnClick(btnInfo, yPox, preferTop, addX)
  local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.Default)
  param.content = Localization:GetString("parkour_gold_score_rule")
  param.alignObject = btnInfo
  param.yPosFix = yPox
  param.addPosX = addX * CommonUtil.ArabicAutoMirrorFactor()
  param.showArrow = true
  param.preferTop = preferTop
  param.width = 600
  param.unEnableTouchThrough = true
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
end

function UISurfingBattleActMain:OnBtnGoClick()
  local guideRewarded = DataCenter.LWSurfingDataManager:IsGuideReward()
  if not guideRewarded then
    self:OnGuideBtnClick()
    return
  end
  local curTs = UITimeManager:GetInstance():GetServerTime()
  if self.clickTs == nil then
    self.clickTs = curTs
  elseif curTs - self.clickTs <= 500 then
    return
  end
  self.clickTs = curTs
  local deviceLevel = GameQualitySettings.GetDeviceLevel()
  local qualityLevel = GameQualitySettings.GetQuality()
  if deviceLevel < self:GetDeviceLevel() and qualityLevel > EnumQualityLevel.Low then
    local param = {
      contentText = Localization:GetString("parkour_activity_graphics_quality_check"),
      btnNum = 2,
      confirmBtnParam = {
        action = function()
          GameQualitySettings.SetQuality(EnumQualityLevel.Low)
          self:HandleEnterGame()
        end
      },
      cancelBtnParam = {
        action = function()
          self:HandleEnterGame()
        end
      }
    }
    UIUtil.TryShowConfirmNew(TodayNoSecondConfirmType.SurfingDeviceLevelLowRemind, param)
  else
    self:HandleEnterGame(curTs)
  end
end

function UISurfingBattleActMain:GetDeviceLevel()
  if self.deviceLevelConfig == nil then
    self.deviceLevelConfig = LuaEntry.DataConfig:TryGetNum("surfing_config", "k16", 0)
  end
  return self.deviceLevelConfig
end

function UISurfingBattleActMain:HandleEnterGame(curTs)
  curTs = curTs or UITimeManager:GetInstance():GetServerTime()
  local battleEndTime = DataCenter.LWSurfingDataManager:GetTheBattleEndTime()
  local leftTime = battleEndTime - curTs
  local fixTime = DataCenter.LWSurfingDataManager:GetDelayTime()
  if leftTime < fixTime and 0 < leftTime then
    local param = {
      contentText = Localization:GetString("parkour_count_down_hour"),
      btnNum = 2,
      confirmBtnParam = {
        action = function()
          DataCenter.LWSurfingDataManager:ReqFightStartCheck()
        end
      }
    }
    UIUtil.TryShowConfirmNew(TodayNoSecondConfirmType.SurfingBattleEnterBtn, param)
  else
    DataCenter.LWSurfingDataManager:ReqFightStartCheck()
  end
end

function UISurfingBattleActMain:OnBtnScoreRankClick()
  if LuaEntry.Player:IsInAlliance() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSurfingBattleRankPanelView, SurfingBattleRankType.AllianceRank)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSurfingBattleRankPanelView, SurfingBattleRankType.TopServersRank)
  end
end

function UISurfingBattleActMain:OnBtnBuffClick()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  CommonUtil.PlayerPrefsSetLong(SettingKeys.SURFING_BATTLE_BUFF_TIPS, curTime)
  self:UpdateBuffRedPoint()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSurfingBattleBuffPopView)
end

function UISurfingBattleActMain:ShowArrowHand()
  local param = {}
  param.positionType = PositionType.Screen
  local targetRoot = self.btnGo
  param.position = targetRoot.transform.position + Vector3.New(50, -50, 0)
  param.isAutoClose = 2
  DataCenter.ArrowManager:ShowFingerArrow(param)
end

function UISurfingBattleActMain:ShowBgEffect(isShow)
  self.effectBg.gameObject:SetActive(isShow)
  if not self.m_Effect and isShow then
    if not self.m_effectRequest then
      self.m_effectRequest = self:GameObjectInstantiateAsync(UIAssets.UISurfingBattleActEffectPath, function(request)
        local go = request.gameObject
        if not IsNull(go) then
          self.m_Effect = go
          local transform = self.m_Effect.transform
          transform:SetParent(self.effectBg.transform)
          transform:Set_localScale(1, 1, 1)
          local rectTransform = transform:GetComponent(typeof(CS.UnityEngine.RectTransform))
          rectTransform:Set_anchoredPosition(0, 0)
          go:SetActive(isShow)
        end
      end)
    end
  elseif self.m_Effect then
    self.m_Effect:SetActive(isShow)
  end
end

function UISurfingBattleActMain:OnGuideBtnClick()
  local param = {}
  param.type = PVEType.Surfing
  param.levelId = 50000
  param.enterType = PVEEnterType.Guide
  DataCenter.LWBattleManager:Enter(param)
end

return UISurfingBattleActMain
