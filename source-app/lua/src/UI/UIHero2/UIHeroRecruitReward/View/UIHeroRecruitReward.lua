local UIHeroRecruitReward = BaseClass("UIHeroRecruitReward", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIRecruitSceneHolder = require("UI.UIHero2.UIHeroRecruitReward.Component.UIRecruitSceneHolder")
local UIGray = CS.UIGray
local UITopItem = require("UI.UIHero2.UIHeroRecruit.Component.UITopItem")
local UIRewardItem = require("UI.UIHero2.UIHeroRecruitReward.Component.UIRewardItem")
local CellHalfWidth = 88.5
local CellHalfHeight = 129
local CellPrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroRecruitRewardCell.prefab"
local TypeOfParticleSystem = typeof(CS.UnityEngine.ParticleSystem)

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local lotteryId, message = self:GetUserData()
  local lotteryHeroData = message.lotteryHero
  self.lotteryData = DataCenter.LotteryDataManager:GetLotteryDataById(lotteryId)
  self.lotteryHeroData = lotteryHeroData
  self:OnOpen()
end

local function StopDelayTimer(self)
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

local function OnDestroy(self)
  StopDelayTimer(self)
  self:CleanCards()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function CleanCards(self)
  self.directEnd = false
  self.content:RemoveComponents(UIRewardItem)
  if self.cardRequestList ~= nil then
    for _, v in pairs(self.cardRequestList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
    self.cardRequestList = nil
  end
  self.nodeCards = nil
end

local function ComponentDefine(self)
  self.btnClose1 = self:AddComponent(UIButton, "Root/BtnClose")
  self.btnClose1:SetActive(false)
  self.btnClose = self:AddComponent(UIButton, "BtnClose1")
  self.btnClose:SetOnClick(BindCallback(self, self.OnBtnCloseClickDirect))
  self.nodeRoot = self:AddComponent(UIBaseContainer, "Root")
  self.content = self:AddComponent(UIBaseContainer, "Root/Panel/Content10")
  self.uiTopItem = self:AddComponent(UITopItem, "Root/ItemBar")
  self.nodeBottom = self:AddComponent(UIBaseContainer, "Root/NodeBottom")
  self.btnConfirm = self:AddComponent(UIButton, "Root/NodeBottom/BtnConfirm")
  self.btnConfirm1 = self:AddComponent(UIButton, "Root/NodeBottom/BtnConfirm_1")
  self.btnRecruit = self:AddComponent(UIButton, "Root/NodeBottom/BtnRecruit")
  self.btnRecruit2 = self:AddComponent(UIButton, "Root/NodeBottom/BtnRecruit2")
  self.textConfirm = self:AddComponent(UIText, "Root/NodeBottom/BtnConfirm/TextConfirm")
  self.textConfirm1 = self:AddComponent(UIText, "Root/NodeBottom/BtnConfirm_1/TextConfirm_1")
  self.textRecruit = self:AddComponent(UIText, "Root/NodeBottom/BtnRecruit/TextRecruit")
  self.TextBtn2 = self:AddComponent(UIText, "Root/NodeBottom/BtnRecruit2/TextBtn2")
  self.imgCost = self:AddComponent(UIImage, "Root/NodeBottom/BtnRecruit2/ImgCost")
  self.textCost = self:AddComponent(UIText, "Root/NodeBottom/BtnRecruit2/ImgCost/TextCost")
  self.textPosterTips = self:AddComponent(UIText, "Root/NodeBottom/TextPosterTips")
  self.effectHolder = self:AddComponent(UIBaseContainer, "ui_effect_chouka")
  self.effectAnim = self:AddComponent(UISimpleAnimation, "ui_effect_chouka/ani")
  self.bgs = self:AddComponent(UIBaseContainer, "Bgs")
  self.yanParticle = self:AddComponent(UIBaseContainer, "ui_effect_chouka/yan1")
  self.yanParticleSystem = self.yanParticle.transform:GetComponent(TypeOfParticleSystem)
  self.kaixiangParticle = self:AddComponent(UIBaseContainer, "ui_effect_chouka/effect_kaixiang")
  self.kaixiangParticleSystem = self.kaixiangParticle.transform:GetComponent(TypeOfParticleSystem)
  self.btnConfirm:SetOnClick(BindCallback(self, self.OnBtnCloseClick))
  self.btnConfirm1:SetOnClick(BindCallback(self, self.OnBtnClose1Click))
  self.btnRecruit:SetOnClick(BindCallback(self, self.OnBtnRecruitClick))
  self.btnRecruit2:SetOnClick(BindCallback(self, self.OnBtnRecruitClick))
  self.textConfirm:SetLocalText(GameDialogDefine.CONFIRM)
  self.textConfirm1:SetLocalText(GameDialogDefine.CONFIRM)
  self.textPosterTips:SetLocalText(129261)
  local isInGuide = DataCenter.GuideManager:InGuide()
  self.btnConfirm1:SetActive(isInGuide)
  self.btnConfirm:SetActive(not isInGuide)
  self.imgCost:SetActive(not isInGuide)
  self.btnRecruit:SetActive(not isInGuide)
end

local function DataDefine(self)
  self.lotteryHeroData = nil
  self.nodeCards = {}
  self.cardRequestList = {}
  self.eventHandler = {}
  self.canClick = true
  self.directEnd = false
  self.delayTimer = nil
  self.touchCardEnable = true
end

local function DataDestroy(self)
  self.lotteryHeroData = nil
  self.nodeCards = nil
  self.cardRequestList = nil
  self.eventHandler = nil
  self.directEnd = nil
  self.touchCardEnable = true
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  local bindFunc = BindCallback(self, self.OnToggleRecruitScene)
  self.eventHandler[EventId.ToggleRecruitScene] = bindFunc
  EventManager:GetInstance():AddListener(EventId.ToggleRecruitScene, bindFunc)
  self:AddUIListener(EventId.RefreshItems, self.OnRefreshItems)
  self:AddUIListener(EventId.HeroicRecruitmentData, self.OnHandleRecruitResponse)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.HeroicRecruitmentData, self.OnHandleRecruitResponse)
  self:RemoveUIListener(EventId.RefreshItems, self.OnRefreshItems)
  EventManager:GetInstance():RemoveListener(EventId.ToggleRecruitScene, self.eventHandler[EventId.ToggleRecruitScene])
  self.eventHandler[EventId.ToggleRecruitScene] = nil
  base.OnRemoveListener(self)
end

local function PlayEffect(self)
  StopDelayTimer(self)
  self.effectAnim:Stop()
  self.effectAnim:SampleAnimationAtTime("chouka", 0)
  local result, length = self.effectAnim:PlayAnimationReturnTime("chouka")
  if self.yanParticleSystem ~= nil then
    self.yanParticleSystem:Simulate(0)
    self.yanParticleSystem:Play()
  end
  if self.kaixiangParticleSystem ~= nil then
    self.kaixiangParticleSystem:Simulate(0)
    self.kaixiangParticleSystem:Play()
  end
  if result == true then
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self ~= nil and self.nodeRoot ~= nil then
        self.nodeRoot.transform:Set_localScale(1, 1, 1)
        self:PlaySpreadAnimation()
      end
    end, length * 0.7)
  end
end

local function EffectGotoEnd(self)
  self.effectAnim:Stop()
  self.effectAnim:SampleAnimationAtTime("chouka", 1)
  if self.yanParticleSystem ~= nil then
    self.yanParticleSystem:Stop()
  end
  if self.kaixiangParticleSystem ~= nil then
    self.kaixiangParticleSystem:Stop()
  end
  StopDelayTimer(self)
  self.nodeRoot.transform:Set_localScale(1, 1, 1)
end

local function OnOpen(self)
  local rarity = HeroUtils.RarityType.C
  table.walk(self.lotteryHeroData, function(_, v)
    if v.type == 0 then
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(v.uuid)
      if heroData ~= nil and rarity > heroData.rarity then
        rarity = heroData.rarity
      end
    end
  end)
  self.isMoreThanOne = table.count(self.lotteryHeroData) > 1
  PlayEffect(self)
  self.flipIdx = 1
  self.nodeRoot.transform:Set_localScale(0, 0, 0)
  self.nodeBottom:SetActive(false)
  self.btnClose:SetActive(true)
  self.btnClose1:SetActive(false)
  local costItems = self.lotteryData:GetCostItems()
  self.itemId = costItems[1].itemId
  self.recruitCost1 = tonumber(costItems[1].itemNum)
  if self.isMoreThanOne and costItems[2] ~= nil then
    self.recruitCost2 = tonumber(costItems[2].itemNum)
  end
  self.itemHave = CommonUtil.GetResOrItemCount(tonumber(self.itemId))
  self.uiTopItem:SetData(self.itemId)
  self.touchCardEnable = false
  self:RefreshNodeBottom()
  self:GenerateCards()
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_hero_box_open, false)
end

local function RefreshNodeBottom(self)
  local canFreeRecruit = false
  if not self.isMoreThanOne then
    canFreeRecruit = self.lotteryData:IsSupportFreeRecruit()
    canFreeRecruit = canFreeRecruit and self.lotteryData:CanFreeRecruit()
  end
  if canFreeRecruit then
    self.imgCost:SetActive(false)
    self.textCost:SetActive(false)
  else
    self.imgCost:SetActive(true)
    self.textCost:SetActive(true)
    self.imgCost:LoadSprite(string.format(LoadPath.ItemPath, DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId).icon))
    self.textCost:SetText(string.GetFormattedSeperatorNum(self.isMoreThanOne and self.recruitCost2 or self.recruitCost1))
  end
  self.textRecruit:SetLocalText(self.isMoreThanOne and 110116 or 110115)
  local gray = false
  if not canFreeRecruit then
    if self.isMoreThanOne then
      gray = canFreeRecruit or self.itemHave < self.recruitCost2 or self.canClick == false
    else
      gray = canFreeRecruit or self.itemHave < self.recruitCost1 or self.canClick == false
    end
  end
  UIGray.SetGray(self.btnRecruit.transform, gray, true)
  local shadow = self.textRecruit.transform:GetComponent(typeof(CS.UnityEngine.UI.Shadow))
  if shadow then
    shadow.enabled = not gray
  end
  local outlines = self.textRecruit.gameObject:GetComponents(typeof(CS.UnityEngine.UI.Outline))
  for i = 0, outlines.Length - 1 do
    outlines[i].effectColor = gray and Color.black or Color.New(0.5568627450980392, 0.24313725490196078, 0.09411764705882353)
    outlines[i].enabled = true
  end
end

local function GenerateCards(self)
  local lotteryId = self.lotteryData.id
  self.cardRequestList = {}
  self.nodeCards = {}
  for idx, data in pairs(self.lotteryHeroData) do
    local req = self:GameObjectInstantiateAsync(CellPrefabPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      local cell = self.content:AddComponent(UIRewardItem, nameStr, lotteryId, idx, data)
      table.insert(self.nodeCards, cell)
      if self.directEnd then
        cell:StopAllAnimation()
      end
      cell:SetTouchEnabled(self.touchCardEnable)
    end)
    table.insert(self.cardRequestList, req)
  end
end

local function PlaySpreadAnimation(self)
  Logger.Log("#RecruitScene# step in PlaySpreadAnimation!")
  if self.directEnd then
    for _, card in ipairs(self.nodeCards) do
      card:StopAllAnimation()
    end
    self:OnAllFlipComplete()
    return
  end
  for k, card in ipairs(self.nodeCards) do
    card:PlaySpreadAnimation(HeroUtils.AniConfig.appearDuration * (k - 1))
  end
  self:RemoveFlipTimer()
  local duration = HeroUtils.AniConfig.appearDuration + HeroUtils.AniConfig.firstFlipDelay
  self.flipTimer = TimerManager:GetInstance():DelayInvoke(BindCallback(self, self.FlipNextCell), duration)
end

local function RemoveFlipTimer(self)
  if self.flipTimer ~= nil then
    self.flipTimer:Stop()
    self.flipTimer = nil
  end
end

local function FlipNextCell(self)
  if self.directEnd then
    return
  end
  if self.flipIdx > #self.nodeCards then
    self:OnAllFlipComplete()
    return
  end
  local isLast = self.flipIdx == #self.nodeCards
  self.nodeCards[self.flipIdx]:DoFlip(isLast, function()
    self:FlipNextCell()
  end)
  self.flipIdx = self.flipIdx + 1
end

local function OnTimeLineEvent(self, playableName, event)
  Logger.Log("#RecruitScene# UIHeroRecruitReward OnTimeLineEvent TimeLine:[" .. playableName .. "] event:" .. event)
  if string.contains(playableName, "open") then
    if event == "stop" then
      self.nodeRoot.transform:Set_localScale(1, 1, 1)
      self:PlaySpreadAnimation()
      Logger.Log("#RecruitScene# UIHeroRecruitReward OnTimeLineEvent 1")
    end
  elseif event == "stop" then
    self.ctrl:CloseSelf()
    Logger.Log("#RecruitScene# UIHeroRecruitReward OnTimeLineEvent 2")
  end
end

local function OnToggleRecruitScene(self, visible)
  self.nodeRoot.transform.localScale = visible and Vector3.one or Vector3.zero
  if visible then
    self:FlipNextCell()
  end
end

local function OnAllFlipComplete(self)
  self:RemoveFlipTimer()
  self.nodeBottom:SetActive(true)
  self.btnClose:SetActive(false)
  self.btnClose1:SetActive(true)
  for _, card in pairs(self.nodeCards) do
    card:SetTouchEnabled(true)
  end
  self.touchCardEnable = true
end

local function OnBtnCloseClick(self)
  self.nodeRoot.transform:Set_localScale(0, 0, 0)
  self.ctrl:CloseSelf()
end

local function OnBtnRecruitClick(self)
  if self.canClick == false then
    return
  end
  local canFreeRecruit = false
  if not self.isMoreThanOne then
    canFreeRecruit = self.lotteryData:IsSupportFreeRecruit()
    canFreeRecruit = canFreeRecruit and self.lotteryData:CanFreeRecruit()
  end
  if not canFreeRecruit then
    if not self.isMoreThanOne and self.itemHave < self.recruitCost1 then
      LWResourceLackUtil:GotoGoodsItemLack(self.itemId, self.recruitCost1 - self.itemHave)
      return
    end
    if self.isMoreThanOne and self.itemHave < self.recruitCost2 then
      LWResourceLackUtil:GotoGoodsItemLack(self.itemId, self.recruitCost2 - self.itemHave)
      return
    end
  end
  if self.isMoreThanOne then
    if self.recruitCost2 and self.itemHave >= self.recruitCost2 then
      self.canClick = false
      SFSNetwork.SendMessage(MsgDefines.LotteryHeroCard, self.lotteryData.id, 1, 0, self.itemId)
      return
    end
  else
    self.canClick = false
    if canFreeRecruit then
      SFSNetwork.SendMessage(MsgDefines.LotteryHeroCard, self.lotteryData.id, 0, 1, self.itemId)
    else
      SFSNetwork.SendMessage(MsgDefines.LotteryHeroCard, self.lotteryData.id, 0, 0, self.itemId)
    end
  end
end

local function OnHandleRecruitResponse(self, message)
  self.canClick = true
  local lotteryHeroData = message.lotteryHero
  self.lotteryHeroData = lotteryHeroData
  self:CleanCards()
  self:OnOpen()
  PlayEffect(self)
end

local function OnRefreshItems(self)
  local costItems = self.lotteryData:GetCostItems()
  self.itemId = costItems[1].itemId
  self.recruitCost1 = tonumber(costItems[1].itemNum)
  if self.isMoreThanOne and costItems[2] ~= nil then
    self.recruitCost2 = tonumber(costItems[2].itemNum)
  end
  self.itemHave = CommonUtil.GetResOrItemCount(tonumber(self.itemId))
  self.uiTopItem:SetData(self.itemId)
  self:RefreshNodeBottom()
end

local function OnBtnClose1Click(self)
  GoToUtil.CloseAllWindows()
end

local function OnBtnCloseClickDirect(self)
  EffectGotoEnd(self)
  self.directEnd = true
  for _, card in ipairs(self.nodeCards) do
    card:StopAllAnimation()
  end
  self:OnAllFlipComplete()
end

UIHeroRecruitReward.OnCreate = OnCreate
UIHeroRecruitReward.OnDestroy = OnDestroy
UIHeroRecruitReward.OnEnable = OnEnable
UIHeroRecruitReward.OnDisable = OnDisable
UIHeroRecruitReward.OnAddListener = OnAddListener
UIHeroRecruitReward.OnRemoveListener = OnRemoveListener
UIHeroRecruitReward.ComponentDefine = ComponentDefine
UIHeroRecruitReward.DataDefine = DataDefine
UIHeroRecruitReward.DataDestroy = DataDestroy
UIHeroRecruitReward.OnOpen = OnOpen
UIHeroRecruitReward.RefreshNodeBottom = RefreshNodeBottom
UIHeroRecruitReward.GenerateCards = GenerateCards
UIHeroRecruitReward.PlaySpreadAnimation = PlaySpreadAnimation
UIHeroRecruitReward.OnTimeLineEvent = OnTimeLineEvent
UIHeroRecruitReward.OnToggleRecruitScene = OnToggleRecruitScene
UIHeroRecruitReward.OnBtnCloseClick = OnBtnCloseClick
UIHeroRecruitReward.OnBtnClose1Click = OnBtnClose1Click
UIHeroRecruitReward.OnBtnRecruitClick = OnBtnRecruitClick
UIHeroRecruitReward.OnBtnCloseClickDirect = OnBtnCloseClickDirect
UIHeroRecruitReward.CleanCards = CleanCards
UIHeroRecruitReward.FlipNextCell = FlipNextCell
UIHeroRecruitReward.OnAllFlipComplete = OnAllFlipComplete
UIHeroRecruitReward.OnHandleRecruitResponse = OnHandleRecruitResponse
UIHeroRecruitReward.RemoveFlipTimer = RemoveFlipTimer
UIHeroRecruitReward.OnRefreshItems = OnRefreshItems
return UIHeroRecruitReward
