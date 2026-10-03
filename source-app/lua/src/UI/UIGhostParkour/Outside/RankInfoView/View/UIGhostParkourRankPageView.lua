local UIGhostParkourRankPageView = BaseClass("UIGhostParkourRankPageView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local PointComponent = require("UI.UIGhostParkour.Outside.RankInfoView.Component.PointComponent")
local RankPageRewardItem = require("UI.UIGhostParkour.Outside.RankInfoView.Component.RewardItemComponent")

function UIGhostParkourRankPageView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitUI()
end

function UIGhostParkourRankPageView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGhostParkourRankPageView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textSubTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.btnReward = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnReward:SetOnClick(function()
    self:OnBtnRewardClick()
  end)
  self.textBtnReward = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textRankName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.simpleAnimationImgLogo = self.viewSkin:AddComponent(self, UISimpleAnimation, 7)
  self.btnLeft = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnLeft:SetOnClick(function()
    self:OnBtnLeftClick()
  end)
  self.btnRight = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnRight:SetOnClick(function()
    self:OnBtnRightClick()
  end)
  self.compPoint = self.viewSkin:AddComponent(self, UIBaseComponent, 10)
  self.textRewardTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.slider = self.viewSkin:AddComponent(self, UISlider, 12)
  self.textScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.imgScoreIcon = self.viewSkin:AddComponent(self, UIImage, 14)
  self.btnRewardInfo = self.viewSkin:AddComponent(self, UIButton, 15)
  self.btnRewardInfo:SetOnClick(function()
    self:OnBtnRewardInfoClick()
  end)
  self.compPointList = self.viewSkin:AddComponent(self, UIBaseContainer, 16)
  self.compRewardList = self.viewSkin:AddComponent(self, UIBaseContainer, 17)
  self.compRewardItem1 = self.viewSkin:AddComponent(self, RankPageRewardItem, 18)
  self.btnBack = self.viewSkin:AddComponent(self, UIButton, 19)
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.btnGo = self.viewSkin:AddComponent(self, UIButton, 20)
  self.btnGo:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.compRewardItem2 = self.viewSkin:AddComponent(self, RankPageRewardItem, 21)
  self.compRewardItem3 = self.viewSkin:AddComponent(self, RankPageRewardItem, 22)
  self.imgScore = self.viewSkin:AddComponent(self, UIImage, 23)
  self.compLeftCommonRedPoint = self.viewSkin:AddComponent(self, UICommonRedPoint, 24)
  self.compRightCommonRedPoint = self.viewSkin:AddComponent(self, UICommonRedPoint, 25)
  self.rawImgImgLogoBg = self.viewSkin:AddComponent(self, UIRawImage, 26)
  self.compUISliderGroup = self.viewSkin:AddComponent(self, UIBaseContainer, 27)
  self.rawImgLogo = self.viewSkin:AddComponent(self, UIRawImage, 28)
  self.rawImgLogoNew = self.viewSkin:AddComponent(self, UIRawImage, 29)
  self.vfxNew = self.viewSkin:AddComponent(self, UIBaseContainer, 30)
  self.vfxOld = self.viewSkin:AddComponent(self, UIBaseContainer, 31)
  self.textGoBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 32)
  self.animator = self:AddComponent(UIAnimator, "")
  self.imgScoreIcon:LoadSpriteAsync("Assets/Main/Sprites/ItemIcons/zxl_paoku_jifen.png")
  self.compPoint.gameObject:SetActive(false)
  self.compPointPool = self.compPoint.gameObject
  self.compPointPool:GameObjectCreatePool()
  self.compPoints = nil
  self.rewardItemList = {}
  for i = 1, 3 do
    table.insert(self.rewardItemList, self["compRewardItem" .. i])
    self.rewardItemList[i].gameObject:SetActive(false)
  end
  self.compLeftCommonRedPoint:SetType(CommonRedPointPriority.Level1)
  self.compLeftCommonRedPoint:SetActive(false)
  self.compRightCommonRedPoint:SetType(CommonRedPointPriority.Level1)
  self.compRightCommonRedPoint:SetActive(false)
  self.vfxOld.gameObject.transform:Set_localScale(CommonUtil.ArabicAutoMirrorFactor(), 1, 1)
  self.vfxNew.gameObject.transform:Set_localScale(CommonUtil.ArabicAutoMirrorFactor(), 1, 1)
end

function UIGhostParkourRankPageView:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.textSubTitle = nil
  self.btnInfo = nil
  self.btnReward = nil
  self.textBtnReward = nil
  self.textRankName = nil
  self.simpleAnimationImgLogo = nil
  self.btnLeft = nil
  self.btnRight = nil
  self.compPoint = nil
  self.textRewardTitle = nil
  self.slider = nil
  self.textScore = nil
  self.imgScoreIcon = nil
  self.btnRewardInfo = nil
  self.compPointList = nil
  self.compRewardList = nil
  self.compRewardItem1 = nil
  self.btnBack = nil
  self.btnGo = nil
  self.compRewardItem2 = nil
  self.compRewardItem3 = nil
  self.imgScore = nil
  self.compLeftCommonRedPoint = nil
  self.compRightCommonRedPoint = nil
  self.rawImgImgLogoBg = nil
  self.compUISliderGroup = nil
  self.rawImgLogo = nil
  self.rawImgLogoNew = nil
  self.vfxNew = nil
  self.vfxOld = nil
  self.textGoBtn = nil
  self.animator = nil
end

function UIGhostParkourRankPageView:DataDefine()
end

function UIGhostParkourRankPageView:DataDestroy()
  self:ClearPointListContent()
  if self.effectReq then
    local oldReq = self.effectReq
    self.effectReq = nil
    if oldReq.gameObject and not IsNull(oldReq.gameObject) then
      CS.UnityEngine.GameObject.Destroy(oldReq.gameObject)
    end
  end
  if self.delayLeft then
    self.delayLeft:Stop()
    self.delayLeft = nil
  end
  self.selectPage = nil
  self.tierList = nil
  self.selfTierInfo = nil
  self.pageMax = nil
  self.rewardItemList = nil
  self.rewardInfos = nil
  self.nowScore = nil
  self.playAnimator = nil
end

function UIGhostParkourRankPageView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GhostParkourRankInfoRefresh, self.UpdateUI)
  self:AddUIListener(EventId.GhostParkourGuideRefresh, self.UpdateGuideState)
end

function UIGhostParkourRankPageView:OnRemoveListener()
  self:RemoveUIListener(EventId.GhostParkourRankInfoRefresh, self.UpdateUI)
  self:RemoveUIListener(EventId.GhostParkourGuideRefresh, self.UpdateGuideState)
  base.OnRemoveListener(self)
end

function UIGhostParkourRankPageView:OnBtnInfoClick()
  local param = {}
  param.activityRulesStr = Localization:GetString("ghost_parkour_tier_rule")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetail, {anim = true}, param)
end

function UIGhostParkourRankPageView:OnBtnRewardClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostParkourRankPageRewardPopView)
end

function UIGhostParkourRankPageView:UpdateEffect(effectPath, parent)
  if self.effectReq then
    local oldReq = self.effectReq
    self.effectReq = nil
    if oldReq.gameObject and not IsNull(oldReq.gameObject) then
      CS.UnityEngine.GameObject.Destroy(oldReq.gameObject)
    end
  end
  if parent and not IsNull(parent) and ComponentIsValid(parent) then
    local childCount = parent.transform.childCount
    for i = childCount - 1, 0, -1 do
      local child = parent.transform:GetChild(i)
      if not IsNull(child) then
        CS.UnityEngine.GameObject.Destroy(child.gameObject)
      end
    end
  end
  if string.IsNullOrEmpty(effectPath) then
    return
  end
  local req = Resource:InstantiateAsync(effectPath)
  self.effectReq = req
  req:completed("+", function(r)
    if self.effectReq ~= r then
      if r and not IsNull(r.gameObject) then
        CS.UnityEngine.GameObject.Destroy(r.gameObject)
      end
      return
    end
    if r.isError then
      Logger.Log(string.format("[UIGhostParkourRankPageView] \229\138\160\232\189\189\231\137\185\230\149\136\229\164\177\232\180\165: %s", effectPath))
      r:Destroy()
      self.effectReq = nil
      return
    end
    local go = r.gameObject
    if not IsNull(go) and parent and not IsNull(parent) then
      local tf = go.transform
      tf:SetParent(parent.transform, false)
      tf.localPosition = Vector3.zero
      tf.localRotation = CS.UnityEngine.Quaternion.identity
      tf.localScale = Vector3.one
      go:SetActive(true)
    end
  end)
end

function UIGhostParkourRankPageView:BtnState()
  if self.pageMax == nil then
    return
  end
  self.btnRight.gameObject:SetActive(self.selectPage ~= self.pageMax)
  self.btnLeft.gameObject:SetActive(self.selectPage ~= 1)
  self.playAnimator = true
  if self.delayLeft then
    self.delayLeft:Stop()
    self.delayLeft = nil
  end
  local config = DataCenter.ParkourScoreTierTemplateManager:GetTemplate(self.selectPage)
  local rankName = ""
  local bgPath = ""
  local effect = ""
  local soundId = ""
  if config then
    rankName = config.tier_name
    bgPath = config.big_icon_bg
    effect = config.icon_effect
    soundId = config.sound_id
  end
  self.rawImgLogoNew:LoadSpriteAsyncWithCallback(bgPath, function(sprite)
    if self.rawImgLogoNew then
      self.rawImgLogoNew:SetNativeSize()
    end
  end)
  self:UpdateEffect(effect, self.vfxNew)
  self.textRankName:SetLocalText(rankName)
  self.delayLeft = TimerManager:GetInstance():DelayInvoke(function()
    self:UpdatePointList()
    self:UpdateReward()
    self:UpdateProgress()
    self:UpdateRedPoint()
    self.playAnimator = false
    self.rawImgLogo:LoadSpriteAsyncWithCallback(bgPath, function(sprite)
      if not string.IsNullOrEmpty(soundId) then
        DataCenter.LWSoundManager:PlaySound(soundId, false)
      end
      if self.rawImgLogo then
        self.rawImgLogo:SetNativeSize()
      end
    end)
  end, 0.25)
end

function UIGhostParkourRankPageView:OnBtnLeftClick()
  if self.selectPage > 1 and not self.playAnimator then
    self.selectPage = self.selectPage - 1
    self.animator:Play("V_ui_UIGhostParkourRankPageView_right", 0, 0)
    self:BtnState()
  end
end

function UIGhostParkourRankPageView:OnBtnRightClick()
  if self.pageMax and self.selectPage < self.pageMax and not self.playAnimator then
    self.selectPage = self.selectPage + 1
    self.animator:Play("V_ui_UIGhostParkourRankPageView_left", 0, 0)
    self:BtnState()
  end
end

function UIGhostParkourRankPageView:OnBtnRewardInfoClick()
  local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.Default)
  param.content = Localization:GetString("ghost_parkour_tier_rule_desc")
  param.alignObject = self.btnRewardInfo
  param.yPosFix = 35
  param.showArrow = true
  param.preferTop = false
  param.width = 600
  param.addPosX = -15 * CommonUtil.ArabicAutoMirrorFactor()
  param.unEnableTouchThrough = true
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
end

function UIGhostParkourRankPageView:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

function UIGhostParkourRankPageView:OnBtnGoClick()
  local restDay = self:GetNowIsRestDay()
  if restDay then
    UIUtil.ShowTipsId("ghost_parkour_off_season_desc")
    return
  end
  EventManager:GetInstance():Broadcast(EventId.GhostParkourMainHandArrow)
  self.ctrl:CloseSelf()
end

function UIGhostParkourRankPageView:InitUI()
  DataCenter.LWGhostParkourDataManager:SendGetGhostParkourTierInfoMessage()
  self:UpdateUI(true)
end

function UIGhostParkourRankPageView:UpdateGuideState(guideOpen)
  self.compUISliderGroup.gameObject:SetActive(not guideOpen)
  if self.rewardInfos then
    for i = 1, #self.rewardInfos do
      if i <= 3 then
        self.rewardItemList[i]:UpdateGuideState(not guideOpen)
      end
    end
  end
  self.rawImgImgLogoBg.gameObject:SetActive(not guideOpen)
end

function UIGhostParkourRankPageView:UpdateUI(value)
  local restDay = self:GetNowIsRestDay()
  if not restDay then
    self.textGoBtn:SetLocalText("ghost_parkour_start_match_btn")
  else
    self.textGoBtn:SetLocalText("ghost_parkour_off_season_btn")
  end
  self:UpdateData()
  self:UpdatePage()
  if not value then
    local isFirst = CommonUtil.PlayerPrefsGetBool(SettingKeys.GHOST_PARKOUR_ON_FIRST_ENTER_RANK_PAGE, true)
    if isFirst then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostParkourRankGuideView, self.selectPage)
      self:UpdateGuideState(true)
    end
  end
  self.btnRight.gameObject:SetActive(self.selectPage ~= self.pageMax)
  self.btnLeft.gameObject:SetActive(self.selectPage ~= 1)
end

function UIGhostParkourRankPageView:UpdatePage()
  self:UpdatePointList()
  self:UpdateReward()
  self:UpdateLogo()
  self:UpdateProgress()
  self:UpdateRedPoint()
  self:UpdateChallengeTimes()
end

function UIGhostParkourRankPageView:UpdateRedPoint()
  if self.selectPage and self.pageMax then
    local left = 0
    if 0 < self.selectPage - 1 then
      for i = 1, self.selectPage - 1 do
        left = left + DataCenter.LWGhostParkourDataManager:OneTierRewardRedPoint(i)
      end
    end
    local right = 0
    if self.selectPage + 1 <= self.pageMax then
      for i = self.selectPage + 1, self.pageMax do
        right = right + DataCenter.LWGhostParkourDataManager:OneTierRewardRedPoint(i)
      end
    end
    self.compLeftCommonRedPoint:SetDefaultVisible(0 < left)
    self.compRightCommonRedPoint:SetDefaultVisible(0 < right)
  end
end

function UIGhostParkourRankPageView:UpdateData()
  self.selfTierInfo = DataCenter.LWGhostParkourDataManager:GetGhostParkourTierInfo()
  self.tierList = DataCenter.LWGhostParkourDataManager:GetGhostParkourTierList()
  if not self.selectPage then
    self.selectPage = 1
  end
  if self.selfTierInfo and self.selfTierInfo.tier then
    self.selectPage = self.selfTierInfo.tier
  end
  if self.tierList then
    self.pageMax = #self.tierList
  end
end

function UIGhostParkourRankPageView:UpdateProgress()
  self.nowScore = 0
  self.maxExp = DataCenter.LWGhostParkourDataManager:GetTierMaxExp(self.selectPage)
  if not self.maxExp then
    return
  end
  if self.selfTierInfo and self.selfTierInfo.tier then
    if self.selfTierInfo.tier > self.selectPage then
      self.nowScore = 9999
    elseif self.selfTierInfo.tier == self.selectPage then
      self.nowScore = self.selfTierInfo.tierExp
      self.textScore:SetText(self.nowScore)
    else
      self.nowScore = 0
    end
    self.imgScore.gameObject:SetActive(self.selfTierInfo.tier == self.selectPage)
  end
  local progress = 0
  local firstRewardStep = 0.15
  local secondRewardStep = 0.575 - firstRewardStep
  local lastRewardStep = 1 - secondRewardStep - firstRewardStep
  local lastNeedScore = 0
  if self.rewardInfos and self.rewardItemList then
    for i, v in pairs(self.rewardInfos) do
      local curStageStep = 0
      if i == 1 then
        curStageStep = firstRewardStep
      elseif i == 2 then
        curStageStep = secondRewardStep
      else
        curStageStep = lastRewardStep
      end
      local needScore = v.exp
      if needScore <= self.nowScore or v.state == GhostParkourTierRewardState.CanReward or v.state == GhostParkourTierRewardState.Rewarded then
        progress = progress + curStageStep
      else
        progress = progress + curStageStep * (self.nowScore - lastNeedScore) / (needScore - lastNeedScore)
        break
      end
      lastNeedScore = needScore
    end
    progress = 1 < progress and 1 or progress
  end
  self.slider:SetValue(progress)
end

function UIGhostParkourRankPageView:UpdateReward()
  if self.tierList then
    self.rewardInfos = self.tierList[self.selectPage].rewardInfo
  end
  if self.rewardInfos then
    for i = 1, #self.rewardInfos do
      if i <= 3 then
        self.rewardItemList[i]:ReInit(self.rewardInfos[i], self.tierList[self.selectPage].tier)
        self.rewardItemList[i].gameObject:SetActive(true)
      end
    end
  end
end

function UIGhostParkourRankPageView:UpdateLogo()
  local config = DataCenter.ParkourScoreTierTemplateManager:GetTemplate(self.selectPage)
  local path = ""
  local rankName = ""
  local bgPath = ""
  local soundId = ""
  if config then
    path = config.icon_effect
    rankName = config.tier_name
    bgPath = config.big_icon_bg
    soundId = config.sound_id
  end
  self.rawImgLogo:LoadSpriteAsyncWithCallback(bgPath, function(sprite)
    if not string.IsNullOrEmpty(soundId) then
      DataCenter.LWSoundManager:PlaySound(soundId, false)
    end
    if self.rawImgLogo then
      self.rawImgLogo:SetNativeSize()
    end
  end)
  self:UpdateEffect(path, self.vfxOld)
  self.textRankName:SetLocalText(rankName)
end

function UIGhostParkourRankPageView:UpdatePointList()
  if not self.pageMax then
    return
  end
  local times = self.pageMax
  local nowSelect = self.selectPage
  if self.compPoints == nil then
    self.compPoints = {}
    for i = 1, times do
      local go = self.compPointPool:GameObjectSpawn(self.compPointList.transform)
      go.name = "point" .. i
      local item = self.compPointList:AddComponent(PointComponent, go.name)
      self.compPoints[i] = item
      item:SetActive(true)
      item:ReInit(nowSelect == i)
    end
  else
    for i = 1, times do
      local item = self.compPoints[i]
      item:ReInit(nowSelect == i)
    end
  end
end

function UIGhostParkourRankPageView:ClearPointListContent()
  if not self.compPoints then
    return
  end
  local count = #self.compPoints
  for i = 1, count do
    local item = self.compPoints[i]
    item:ReInit(nil)
  end
  self.compPointList:RemoveComponents(PointComponent)
  self.compPointPool:GameObjectRecycleAll()
  self.compPoints = nil
end

function UIGhostParkourRankPageView:GetNowIsRestDay()
  local roundEndTime = DataCenter.LWGhostParkourDataManager:GetRoundEndTime()
  local round = DataCenter.LWGhostParkourDataManager:GetGhostParkourRound()
  if not roundEndTime and not round then
    return true
  end
  return false
end

function UIGhostParkourRankPageView:UpdateChallengeTimes()
  local remainTimes = DataCenter.LWGhostParkourDataManager:GetRemainTimes()
  if remainTimes and 0 < remainTimes then
    self.btnGo.gameObject:SetActive(true)
  else
    self.btnGo.gameObject:SetActive(false)
  end
end

return UIGhostParkourRankPageView
