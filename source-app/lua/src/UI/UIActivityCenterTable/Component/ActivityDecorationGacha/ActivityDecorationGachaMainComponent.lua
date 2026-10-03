local base = UIBaseContainer
local ActivityDecorationGachaMainComponent = BaseClass("ActivityDecorationGachaMainComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local ActivityDecorationGachaWheelComponent = require("UI/UIActivityCenterTable/Component/ActivityDecorationGacha/ActivityDecorationGachaWheelComponent")
local ActivityDecorationGachaWishComponent = require("UI/UIActivityCenterTable/Component/ActivityDecorationGacha/ActivityDecorationGachaWishComponent")
local ActivityDecorationGachaGuideItemComponent = require("UI/UIActivityCenterTable/Component/ActivityDecorationGacha/ActivityDecorationGachaGuideItemComponent")
local ActivityDecorationGachaProgressItemComponent = require("UI/UIActivityCenterTable/Component/ActivityDecorationGacha/ActivityDecorationGachaProgressItemComponent")
ActivityDecorationGachaMainComponent.AnimName = {
  GuideStart = "Start",
  GuideIdle = "Idle",
  Enter = "Join",
  Normal = "changtai"
}

function ActivityDecorationGachaMainComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ActivityDecorationGachaMainComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActivityDecorationGachaMainComponent:OnEnable()
  base.OnEnable(self)
end

function ActivityDecorationGachaMainComponent:OnDisable()
  base.OnDisable(self)
  self:ClearDelayShowGachaResultTimer()
  self:StopMainTimer()
end

function ActivityDecorationGachaMainComponent:ComponentDefine()
  self.anim = self:AddComponent(UIAnimator, "")
  self.compGuideContent = self:AddComponent(UIBaseContainer, "GuideContent")
  self.textGuideTitle = self:AddComponent(UIText, "GuideContent/TopContent/GuideTitleText")
  self.textGuideTitle:SetText(Localization:GetString("decoration_recruit_desc34"))
  self.textGuideTime = self:AddComponent(UIText, "GuideContent/TopContent/GuideTimeText")
  self.compGuideSlot01 = self:AddComponent(ActivityDecorationGachaGuideItemComponent, "GuideContent/DecorationContent/GuideSlot01")
  self.compGuideSlot02 = self:AddComponent(ActivityDecorationGachaGuideItemComponent, "GuideContent/DecorationContent/GuideSlot02")
  self.compGuideSlot03 = self:AddComponent(ActivityDecorationGachaGuideItemComponent, "GuideContent/DecorationContent/GuideSlot03")
  self.textEnterDes = self:AddComponent(UIText, "GuideContent/BottomContent/EnterLayout/EnterDesText")
  self.textEnterDes:SetText(Localization:GetString("decoration_recruit_desc18"))
  self.compEnterLayout = self:AddComponent(UIBaseContainer, "GuideContent/BottomContent/EnterLayout")
  self.imgEnterItem = self:AddComponent(UIImage, "GuideContent/BottomContent/EnterLayout/EnterItemImage")
  self.textEnterItem = self:AddComponent(UIText, "GuideContent/BottomContent/EnterLayout/EnterItemText")
  self.btnEnter = self:AddComponent(UIButton, "GuideContent/BottomContent/EnterBtn")
  self.btnEnter:SetOnClick(function()
    self:OnBtnEnterClick()
  end)
  self.textEnter = self:AddComponent(UIText, "GuideContent/BottomContent/EnterBtn/Btn/EnterText")
  self.textEnter:SetText(Localization:GetString("decoration_recruit_desc19"))
  self.compMainContent = self:AddComponent(UIBaseContainer, "MainContent")
  self.compBlockBtn = self:AddComponent(UIBaseContainer, "MainContent/BlockBtn")
  self.compBlockBtn:SetActive(false)
  self.compWheelContent = self:AddComponent(ActivityDecorationGachaWheelComponent, "MainContent/WheelContent")
  self.compWishContent = self:AddComponent(ActivityDecorationGachaWishComponent, "MainContent/WishContent")
  self.btnOne = self:AddComponent(UIButton, "MainContent/BottomContent/BottomBtns/OneBtn")
  self.btnOne:SetOnClick(function()
    self:OnBtnOneClick()
  end)
  self.btnOne:SetSafeClickMode(true)
  self.imgIcon = self:AddComponent(UIImage, "MainContent/BottomContent/BottomBtns/OneBtn/Icon")
  self.textOne = self:AddComponent(UIText, "MainContent/BottomContent/BottomBtns/OneBtn/Layout/OneText")
  self.compOneBtnLayout = self:AddComponent(UIBaseContainer, "MainContent/BottomContent/BottomBtns/OneBtn/Layout/OneBtnLayout")
  self.imgOneBtnIcon = self:AddComponent(UIImage, "MainContent/BottomContent/BottomBtns/OneBtn/Layout/OneBtnLayout/OneBtnIcon")
  self.textOneNum = self:AddComponent(UIText, "MainContent/BottomContent/BottomBtns/OneBtn/Layout/OneBtnLayout/OneNumText")
  self.textOneFreeRefreshTime = self:AddComponent(UIText, "MainContent/BottomContent/BottomBtns/OneBtn/OneFreeRefreshTime")
  self.btnTen = self:AddComponent(UIButton, "MainContent/BottomContent/BottomBtns/TenBtn")
  self.btnTen:SetOnClick(function()
    self:OnBtnTenClick()
  end)
  self.btnTen:SetSafeClickMode(true)
  self.compTenBtnLayout = self:AddComponent(UIBaseContainer, "MainContent/BottomContent/BottomBtns/TenBtn/TenBtnLayout")
  self.textTen = self:AddComponent(UIText, "MainContent/BottomContent/BottomBtns/TenBtn/TenText")
  self.imgTenBtnIcon = self:AddComponent(UIImage, "MainContent/BottomContent/BottomBtns/TenBtn/TenBtnLayout/TenBtnIcon")
  self.textTenNum = self:AddComponent(UIText, "MainContent/BottomContent/BottomBtns/TenBtn/TenBtnLayout/TenNumText")
  self.textTodayLeftTime = self:AddComponent(UIText, "MainContent/BottomContent/TodayLeftTimeText")
  self.btnSkip = self:AddComponent(UIButton, "MainContent/BottomContent/SkipBtn")
  self.btnSkip:SetOnClick(function()
    self:OnBtnSkipClick()
  end)
  self.compSkipBtnBeSelect = self:AddComponent(UIBaseContainer, "MainContent/BottomContent/SkipBtn/skipBtnBeSelect")
  self.textSkipTip = self:AddComponent(UIText, "MainContent/BottomContent/SkipBtn/skipTip")
  self.textSkipTip:SetText(Localization:GetString("decoration_recruit_btn_name3"))
  self.textWheelDes = self:AddComponent(UIText, "MainContent/BottomContent/WheelDesText")
  self.textActName = self:AddComponent(UIText, "MainContent/TopContent/actName")
  self.textActName:SetText(Localization:GetString("activity_name_98630"))
  self.textTimes = self:AddComponent(UIText, "MainContent/TopContent/times")
  self.imgResourceIcon = self:AddComponent(UIImage, "MainContent/TopContent/ResBar/root/resourceIcon")
  self.textResourceNum = self:AddComponent(UIText, "MainContent/TopContent/ResBar/root/resourceNum")
  self.btnAdd = self:AddComponent(UIButton, "MainContent/TopContent/ResBar/addBtn")
  self.btnAdd:SetOnClick(function()
    self:OnBtnAddClick()
  end)
  self.compAddRedPoint = self:AddComponent(UIBaseContainer, "MainContent/TopContent/ResBar/addBtn/addRedPoint")
  self.btnCollection = self:AddComponent(UIButton, "MainContent/TopContent/BtnCollection")
  self.btnCollection:SetOnClick(function()
    self:OnBtnCollectionClick()
  end)
  self.compRedDotCollection = self:AddComponent(UIBaseContainer, "MainContent/TopContent/BtnCollection/RedDotCollection")
  self.textCollection = self:AddComponent(UIText, "MainContent/TopContent/BtnCollection/CollectionText")
  self.textCollection:SetText(Localization:GetString("decoration_recruit_btn_name2"))
  self.sliderProgress = self:AddComponent(UISlider, "MainContent/TopContent/progressDetailContent/maskContent/detaillContent/ProgressSlider")
  self.compActSlotMachineProgressItem = self:AddComponent(UIBaseContainer, "MainContent/TopContent/progressDetailContent/maskContent/detaillContent/actSlotMachineProgressItem")
  self.compActSlotMachineProgressItem:SetActive(false)
  self.compActSlotMachineProgressItem.gameObject:GameObjectCreatePool()
  self.compDetailItems = self:AddComponent(UIBaseContainer, "MainContent/TopContent/progressDetailContent/maskContent/detaillContent/detailItems")
  self.textProgressTxt = self:AddComponent(UIText, "MainContent/TopContent/progressDetailContent/maskContent/detaillContent/bg/progressTxt")
  self.textProgressTxt:SetLocalText(456533)
  self.textProgressNum = self:AddComponent(UIText, "MainContent/TopContent/progressDetailContent/maskContent/detaillContent/bg/progressNum")
  self.btnRules = self:AddComponent(UIButton, "MainContent/TopContent/BtnRules")
  self.btnRules:SetOnClick(function()
    self:OnBtnRulesClick()
  end)
  self.textRules = self:AddComponent(UIText, "MainContent/TopContent/BtnRules/RulesText")
  self.textRules:SetText(Localization:GetString("decoration_recruit_btn_name1"))
end

function ActivityDecorationGachaMainComponent:ComponentDestroy()
  self.compMainContent = nil
  self.compGuideContent = nil
  self.compWheelContent = nil
  self.compWishContent = nil
  self.btnOne = nil
  self.textOne = nil
  self.imgIcon = nil
  self.imgOneBtnIcon = nil
  self.textOneNum = nil
  self.btnTen = nil
  self.textTen = nil
  self.imgTenBtnIcon = nil
  self.textTenNum = nil
  self.textTodayLeftTime = nil
  self.btnSkip = nil
  self.compSkipBtnBeSelect = nil
  self.textSkipTip = nil
  self.textWheelDes = nil
  self.textActName = nil
  self.textTimes = nil
  self.imgResourceIcon = nil
  self.textResourceNum = nil
  self.btnAdd = nil
  self.btnCollection = nil
  self.textCollection = nil
  self.compActSlotMachineProgressItem = nil
  self.compDetailItems = nil
  self.textProgressTxt = nil
  self.textProgressNum = nil
  self.btnRules = nil
  self.textRules = nil
  self.textGuideTitle = nil
  self.textGuideTime = nil
  self.compGuideSlot01 = nil
  self.compGuideSlot02 = nil
  self.compGuideSlot03 = nil
  self.textEnterDes = nil
  self.imgEnterItem = nil
  self.textEnterItem = nil
  self.btnEnter = nil
  self.textEnter = nil
  self.anim = nil
  self.compAddRedPoint = nil
  self.compTenBtnLayout = nil
  self.textOneFreeRefreshTime = nil
  self.compBlockBtn = nil
  self.compRedDotCollection = nil
  self.sliderProgress = nil
end

function ActivityDecorationGachaMainComponent:DataDefine()
  self.mainAnimTimer = nil
  self.hasSentRemoveActivity = false
end

function ActivityDecorationGachaMainComponent:DataDestroy()
  self.hasSentRemoveActivity = nil
  self:ClearDelayShowGachaResultTimer()
  self:StopMainTimer()
end

function ActivityDecorationGachaMainComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActivityDecorationGachaStartGacha, self.OnGachaStart)
  self:AddUIListener(EventId.ActivityDecorationGachaEndGacha, self.OnGachaEnd)
  self:AddUIListener(EventId.ActivityDecorationGachaWishSelect, self.OnSelectWish)
  self:AddUIListener(EventId.ActivityDecorationGachaWishClaim, self.OnClaimWish)
  self:AddUIListener(EventId.ActivityDecorationGachaProgressClaim, self.OnClaimProgress)
  self:AddUIListener(EventId.ActivityDecorationGachaShowGachaAnim, self.OnShowGachaAnim)
  self:AddUIListener(EventId.CommonActivityGiftPackageViewRefresh, self.OnPackageInfoUpdated)
  self:AddUIListener(EventId.ActivityDecorationGachaOpenDecorationBook, self.UpdateDecorationBookRed)
  self:AddUIListener(EventId.DecorateRedPoint, self.OnRefreshDecorationBookCallback)
  self:AddUIListener(EventId.OnPackageInfoUpdated, self.OnPackageInfoUpdated)
  self:AddUIListener(EventId.BuildDecoNumChange, self.OnRefreshDecorationBookCallback)
end

function ActivityDecorationGachaMainComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.ActivityDecorationGachaStartGacha, self.OnGachaStart)
  self:RemoveUIListener(EventId.ActivityDecorationGachaEndGacha, self.OnGachaEnd)
  self:RemoveUIListener(EventId.ActivityDecorationGachaWishSelect, self.OnSelectWish)
  self:RemoveUIListener(EventId.ActivityDecorationGachaWishClaim, self.OnClaimWish)
  self:RemoveUIListener(EventId.ActivityDecorationGachaProgressClaim, self.OnClaimProgress)
  self:RemoveUIListener(EventId.ActivityDecorationGachaShowGachaAnim, self.OnShowGachaAnim)
  self:RemoveUIListener(EventId.CommonActivityGiftPackageViewRefresh, self.OnPackageInfoUpdated)
  self:RemoveUIListener(EventId.ActivityDecorationGachaOpenDecorationBook, self.UpdateDecorationBookRed)
  self:RemoveUIListener(EventId.DecorateRedPoint, self.OnRefreshDecorationBookCallback)
  self:RemoveUIListener(EventId.OnPackageInfoUpdated, self.OnPackageInfoUpdated)
  self:RemoveUIListener(EventId.BuildDecoNumChange, self.OnRefreshDecorationBookCallback)
  base.OnRemoveListener(self)
end

function ActivityDecorationGachaMainComponent:SetData(activityId)
  self.activityId = activityId
  if self.activityId == nil then
    return
  end
  local activityData = DataCenter.ActivityDecorationGachaManager:GetActivityData(self.activityId)
  if activityData == nil then
    self.compGuideContent:SetActive(false)
    self.compMainContent:SetActive(false)
    return
  end
  local hasShownGuide = activityData:HasShownGuide()
  self.compGuideContent:SetActive(not hasShownGuide)
  self.compMainContent:SetActive(hasShownGuide)
  if not hasShownGuide then
    self.anim:Enable(true)
    activityData:SetHasShownGuide()
    self:UpdateGuide()
    local ret, time = self.anim:PlayAnimationReturnTime(self.AnimName.GuideStart)
    if ret then
      self:StopMainTimer()
      self.mainAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
        if self.anim ~= nil then
          self.anim:Play(self.AnimName.GuideIdle, 0, 0)
        end
      end, time)
    end
  else
    self.anim:Enable(true)
    self:UpdateMain(true)
    self.anim:Play(self.AnimName.Normal, 0, 0)
  end
  PostEventLog.Track(PostEventLog.Defines.ActivityDecorationGachaOpen, {
    activityId = tostring(self.activityId)
  })
end

function ActivityDecorationGachaMainComponent:StopMainTimer()
  if self.mainAnimTimer ~= nil then
    self.mainAnimTimer:Stop()
    self.mainAnimTimer = nil
  end
end

function ActivityDecorationGachaMainComponent:Update1000MS()
  if self.activityId == nil then
    return
  end
  local activityData = DataCenter.ActivityDecorationGachaManager:GetActivityData(self.activityId)
  if activityData == nil then
    return
  end
  local leftTime = activityData:GetLeftTime()
  if self.textGuideTime ~= nil then
    self.textGuideTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(math.max(0, leftTime)))
  end
  if self.textTimes ~= nil then
    self.textTimes:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(math.max(0, leftTime)))
  end
  if leftTime < 0 and not self.hasSentRemoveActivity then
    EventManager:GetInstance():Broadcast(EventId.ActivityTimeEnd)
    self.hasSentRemoveActivity = true
  end
  local freeGachaRefreshLeftTime = activityData:GetCurFreeGachaRefreshLeftTime()
  if self.textOneFreeRefreshTime ~= nil then
    self.textOneFreeRefreshTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(freeGachaRefreshLeftTime))
  end
end

function ActivityDecorationGachaMainComponent:UpdateGuide()
  self:Update1000MS()
  local activityData = DataCenter.ActivityDecorationGachaManager:GetActivityData(self.activityId)
  if activityData == nil then
    return
  end
  local items = activityData:GetRecommendItems()
  for i, v in pairs(items) do
    local itemData = DataCenter.ActivityDecorationGachaManager:GetItemDataByItemId(self.activityId, v)
    if itemData ~= nil then
      if i == 1 then
        self.compGuideSlot01:ReInit(itemData)
      end
      if i == 2 then
        self.compGuideSlot02:ReInit(itemData)
      end
      if i == 3 then
        self.compGuideSlot03:ReInit(itemData)
      end
    end
  end
  local infoTemplate = DataCenter.ActivityDecorationGachaManager:GetActivityInfo(self.activityId)
  if infoTemplate ~= nil then
    self.textEnterItem:SetText("\195\151" .. tostring(infoTemplate.freeCoinNumber))
    self.imgEnterItem:LoadSprite(infoTemplate:GetCostItemImage())
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compEnterLayout.transform)
  end
end

function ActivityDecorationGachaMainComponent:UpdateMain(isEnter)
  if self.activityId == nil then
    return
  end
  self.textActName:SetLocalText("activity_name_98630")
  self:Update1000MS()
  local infoTemplate = DataCenter.ActivityDecorationGachaManager:GetActivityInfo(self.activityId)
  if infoTemplate == nil then
    return
  end
  self:UpdateResBar()
  self:UpdateDecorationBookRed()
  self:UpdateProgress()
  self:UpdateSkipBtn()
  self:UpdateGachaBtns()
  self.compWheelContent:ReInit(self.activityId, isEnter)
  self.compWishContent:ReInit(self.activityId)
  self.compBlockBtn:SetActive(false)
end

function ActivityDecorationGachaMainComponent:UpdateFreePackageRed()
  if self.activityId == nil then
    return
  end
  local activityData = DataCenter.ActivityDecorationGachaManager:GetActivityData(self.activityId)
  local showRed = false
  if activityData ~= nil and activityData:CanClaimFreePackage() then
    showRed = true
  end
  self.compAddRedPoint:SetActive(showRed)
end

function ActivityDecorationGachaMainComponent:UpdateResBar()
  if self.activityId == nil then
    return
  end
  local infoTemplate = DataCenter.ActivityDecorationGachaManager:GetActivityInfo(self.activityId)
  if infoTemplate == nil then
    return
  end
  local costId = infoTemplate.costId
  local iconPath = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, costId)
  self.imgResourceIcon:LoadSprite(iconPath)
  local curNum = DataCenter.ItemData:GetItemRealCount(costId)
  self.textResourceNum:SetText(curNum)
  self:UpdateFreePackageRed()
end

function ActivityDecorationGachaMainComponent:UpdateProgress()
  if self.activityId == nil then
    return
  end
  local activityData = DataCenter.ActivityDecorationGachaManager:GetActivityData(self.activityId)
  if activityData ~= nil then
    local progressData = activityData:GetProgressData()
    if progressData then
      local curScore = activityData:GetProgressCurScore()
      local maxScore = activityData:GetProgressMaxScore()
      self.textProgressNum:SetText(string.format("%s/%s", curScore, maxScore))
      local bgSize = self.compDetailItems:GetSizeDelta()
      local sizeRate = -1
      for i = 1, #progressData do
        local preNum = 0
        if 1 < i then
          preNum = progressData[i - 1].target
        end
        local curMaxNum = progressData[i].target
        if curScore >= preNum and curScore <= curMaxNum then
          sizeRate = (i - 1) / #progressData + (curScore - preNum) / (curMaxNum - preNum) / #progressData
          break
        end
      end
      if sizeRate < 0 then
        sizeRate = 1
      end
      self.sliderProgress:SetValue(sizeRate)
      if self.compProgressBoxes == nil then
        self:ClearProgress()
        self.compProgressBoxes = {}
        local showNum = #progressData
        for i, v in pairs(progressData) do
          local item = self.compActSlotMachineProgressItem.gameObject:GameObjectSpawn(self.compDetailItems.transform)
          item.name = "progress_item_" .. tostring(i)
          local obj = self.compDetailItems:AddComponent(ActivityDecorationGachaProgressItemComponent, item.name)
          obj:SetActive(true)
          self.compProgressBoxes[i] = obj
          obj:ReInit(v, self.activityId)
          obj:SetAnchoredPositionXY(bgSize.x * i / showNum - 10, 0)
        end
      else
        for i, v in pairs(progressData) do
          if self.compProgressBoxes[i] ~= nil then
            self.compProgressBoxes[i]:ReInit(v, self.activityId)
          end
        end
      end
    end
  end
end

function ActivityDecorationGachaMainComponent:UpdateSkipBtn()
  local isSkip = DataCenter.ActivityDecorationGachaManager:IsSkipGachaAnim()
  self.compSkipBtnBeSelect:SetActive(isSkip)
end

function ActivityDecorationGachaMainComponent:ClearProgress()
  self.compDetailItems:RemoveComponents(ActivityDecorationGachaProgressItemComponent)
  for _, v in ipairs(self.compDetailItems.transform) do
    if not IsNull(v) then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.compActSlotMachineProgressItem.gameObject:GameObjectRecycleAll()
  self.compProgressBoxes = nil
end

function ActivityDecorationGachaMainComponent:UpdateGachaBtns()
  local function GetColoredText(str, isEnough)
    if isEnough then
      return "<color=white>" .. str .. "</color>"
    else
      return "<color=red>" .. str .. "</color>"
    end
  end
  
  if self.activityId == nil then
    return
  end
  local activityData = DataCenter.ActivityDecorationGachaManager:GetActivityData(self.activityId)
  if activityData == nil then
    return
  end
  local activityInfo = DataCenter.ActivityDecorationGachaManager:GetActivityInfo(self.activityId)
  if activityInfo == nil then
    return
  end
  local totalFreeTime = activityInfo.freeTime
  if totalFreeTime <= 0 then
    self.textOneFreeRefreshTime:SetActive(false)
    self.compOneBtnLayout:SetActive(true)
    self.textOne:SetLocalText("decoration_recruit_btn_name4", "1")
    self.textOneNum:SetText(tostring(activityInfo.costNum))
    if DataCenter.ActivityDecorationGachaManager:IsGachaCostItemEnough(self.activityId, 1) then
      self.textOneNum:SetColor(WhiteColor)
    else
      self.textOneNum:SetColor(RedColor)
    end
    self.imgOneBtnIcon:LoadSprite(activityInfo:GetCostItemImage())
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compOneBtnLayout.transform)
    self.imgIcon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_4.png")
  else
    local freeLeftTime = activityData:GetCurFreeGachaLeftTime()
    if 0 < freeLeftTime then
      self.compOneBtnLayout:SetActive(false)
      self.textOne:SetLocalText("activity_blue_shop_desc2")
      self.textOneFreeRefreshTime:SetActive(false)
      self.imgIcon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_2.png")
    else
      self.textOneFreeRefreshTime:SetActive(true)
      self:Update1000MS()
      self.compOneBtnLayout:SetActive(true)
      self.textOne:SetLocalText("decoration_recruit_btn_name4", "1")
      self.textOneNum:SetText(tostring(activityInfo.costNum))
      self.imgIcon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_4.png")
      if DataCenter.ActivityDecorationGachaManager:IsGachaCostItemEnough(self.activityId, 1) then
        self.textOneNum:SetColor(WhiteColor)
      else
        self.textOneNum:SetColor(RedColor)
      end
      self.imgOneBtnIcon:LoadSprite(activityInfo:GetCostItemImage())
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compOneBtnLayout.transform)
    end
  end
  CS.UIGray.SetGray(self.btnOne.transform, 1 > activityData:GetTotalGachaLeftTimes(), true)
  self.textTen:SetLocalText("decoration_recruit_btn_name4", tostring(activityInfo.buttonPara))
  self.textTenNum:SetText(tostring(activityInfo.costNum * activityInfo.buttonPara))
  if DataCenter.ActivityDecorationGachaManager:IsGachaCostItemEnough(self.activityId, activityInfo.buttonPara) then
    self.textTenNum:SetColor(WhiteColor)
  else
    self.textTenNum:SetColor(RedColor)
  end
  self.imgTenBtnIcon:LoadSprite(activityInfo:GetCostItemImage())
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compTenBtnLayout.transform)
  CS.UIGray.SetGray(self.btnTen.transform, activityData:GetTotalGachaLeftTimes() < activityInfo.buttonPara, true)
  self.textTodayLeftTime:SetLocalText("decoration_recruit_desc40", tostring(activityData:GetTotalGachaLeftTimes()))
  local leftPityTimes = activityData:GetPityLeftTimes()
  local pityQuality = activityData:GetPityQuality()
  local pity = activityData:GetPity()
  local qualityName = DataCenter.ActivityDecorationGachaManager:GetQualityColoredText(pityQuality, DataCenter.ActivityDecorationGachaManager:GetDecorationQualityName(pityQuality))
  local leftPityTimesStr = string.format("<color=#00ff00>%s</color>", tostring(leftPityTimes))
  local pityStr = string.format("<color=#00ff00>%s</color>", tostring(pity))
  self.textWheelDes:SetLocalText("decoration_recruit_desc48", pityStr)
end

function ActivityDecorationGachaMainComponent:OnBtnOneClick()
  if self.activityId == nil then
    return
  end
  local activityData = DataCenter.ActivityDecorationGachaManager:GetActivityData(self.activityId)
  if activityData == nil then
    return
  end
  local activityInfo = DataCenter.ActivityDecorationGachaManager:GetActivityInfo(self.activityId)
  if activityInfo == nil then
    return
  end
  local useFree = false
  local totalFreeTime = activityInfo.freeTime
  if 0 < totalFreeTime then
    local freeLeftTime = activityData:GetCurFreeGachaLeftTime()
    if 0 < freeLeftTime then
      useFree = true
    end
  end
  if not useFree and not DataCenter.ActivityDecorationGachaManager:IsGachaCostItemEnough(self.activityId, 1) then
    DataCenter.ActivityDecorationGachaManager:OpenGiftPackage(self.activityId)
    return
  end
  if 1 > activityData:GetTotalGachaLeftTimes() then
    UIUtil.ShowTipsId("decoration_recruit_desc20")
    return
  end
  local curSelectWishData = activityData:GetCurSelectWishData()
  if curSelectWishData == nil then
    UIUtil.TryShowConfirm(TodayNoSecondConfirmType.ActivityDecorationGachaNotSelectWish, Localization:GetString("decoration_recruit_desc45"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      DataCenter.ActivityDecorationGachaManager:SendGachaMessage(self.activityId, 1)
    end, function()
    end, nil, nil, false, nil, nil)
    return
  end
  local wishItemDataTemplate = DataCenter.ActivityDecorationGachaManager:GetItemDataByItemId(self.activityId, curSelectWishData.itemId)
  if wishItemDataTemplate == nil then
    DataCenter.ActivityDecorationGachaManager:SendGachaMessage(self.activityId, 1)
    return
  end
  if wishItemDataTemplate:IsDecorationBuildMaxOrUpgradeItemMax() and not DataCenter.ActivityDecorationGachaManager:IsAllWishDecorationBuildMaxOrUpgradeItemMax(self.activityId) then
    UIUtil.ShowMessage(Localization:GetString("decoration_recruit_desc7"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      DataCenter.ActivityDecorationGachaManager:SendGachaMessage(self.activityId, 1)
    end)
    return
  end
  DataCenter.ActivityDecorationGachaManager:SendGachaMessage(self.activityId, 1)
end

function ActivityDecorationGachaMainComponent:OnBtnTenClick()
  if self.activityId == nil then
    return
  end
  local activityData = DataCenter.ActivityDecorationGachaManager:GetActivityData(self.activityId)
  if activityData == nil then
    return
  end
  local activityInfo = DataCenter.ActivityDecorationGachaManager:GetActivityInfo(self.activityId)
  if activityInfo == nil then
    return
  end
  local num = tonumber(activityInfo.buttonPara)
  if not DataCenter.ActivityDecorationGachaManager:IsGachaCostItemEnough(self.activityId, num) then
    DataCenter.ActivityDecorationGachaManager:OpenGiftPackage(self.activityId)
    return
  end
  if num > activityData:GetTotalGachaLeftTimes() then
    UIUtil.ShowTipsId("decoration_recruit_desc20")
    return
  end
  local curSelectWishData = activityData:GetCurSelectWishData()
  if curSelectWishData == nil then
    UIUtil.TryShowConfirm(TodayNoSecondConfirmType.ActivityDecorationGachaNotSelectWish, Localization:GetString("decoration_recruit_desc45"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      DataCenter.ActivityDecorationGachaManager:SendGachaMessage(self.activityId, num)
    end, function()
    end, nil, nil, false, nil, nil)
    return
  end
  local wishItemDataTemplate = DataCenter.ActivityDecorationGachaManager:GetItemDataByItemId(self.activityId, curSelectWishData.itemId)
  if wishItemDataTemplate == nil then
    DataCenter.ActivityDecorationGachaManager:SendGachaMessage(self.activityId, num)
    return
  end
  if wishItemDataTemplate:IsDecorationBuildMaxOrUpgradeItemMax() and not DataCenter.ActivityDecorationGachaManager:IsAllWishDecorationBuildMaxOrUpgradeItemMax(self.activityId) then
    UIUtil.ShowMessage(Localization:GetString("decoration_recruit_desc7"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      DataCenter.ActivityDecorationGachaManager:SendGachaMessage(self.activityId, num)
    end)
    return
  end
  DataCenter.ActivityDecorationGachaManager:SendGachaMessage(self.activityId, num)
end

function ActivityDecorationGachaMainComponent:OnBtnSkipClick()
  DataCenter.ActivityDecorationGachaManager:SetIsSkipGachaAnim(not DataCenter.ActivityDecorationGachaManager:IsSkipGachaAnim())
  self:UpdateSkipBtn()
end

function ActivityDecorationGachaMainComponent:OnBtnAddClick()
  if self.activityId ~= nil then
    DataCenter.ActivityDecorationGachaManager:OpenGiftPackage(self.activityId)
  end
end

function ActivityDecorationGachaMainComponent:OnBtnCollectionClick()
  if self.activityId ~= nil then
    DataCenter.ActivityDecorationGachaManager:OpenDecorationBook(self.activityId)
  end
end

function ActivityDecorationGachaMainComponent:OnBtnRulesClick()
  if self.activityId ~= nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDecorationGachaRules, {anim = true}, self.activityId)
  end
end

function ActivityDecorationGachaMainComponent:OnBtnEnterClick()
  self.compMainContent:SetActive(true)
  self:UpdateMain(true)
  local ret, time = self.anim:PlayAnimationReturnTime(self.AnimName.Enter)
  if ret then
    self:StopMainTimer()
    self.mainAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.compGuideContent ~= nil then
        self.compGuideContent:SetActive(false)
      end
      if self.compWheelContent ~= nil then
        self.compWheelContent:ReVisibleBigRewardEffect()
      end
    end, time)
  end
end

function ActivityDecorationGachaMainComponent:OnGachaStart()
  self.anim:Enable(false)
  self.compBlockBtn:SetActive(true)
end

function ActivityDecorationGachaMainComponent:OnGachaEnd()
  self.compBlockBtn:SetActive(false)
  self:UpdateMain(false)
end

function ActivityDecorationGachaMainComponent:OnSelectWish()
  self:UpdateMain(false)
end

function ActivityDecorationGachaMainComponent:OnClaimWish()
  self:UpdateMain(false)
end

function ActivityDecorationGachaMainComponent:OnPackageInfoUpdated()
  self:UpdateResBar()
  self:UpdateGachaBtns()
end

function ActivityDecorationGachaMainComponent:OnClaimProgress()
  self:UpdateProgress()
end

function ActivityDecorationGachaMainComponent:ClearDelayShowGachaResultTimer()
  if self.delayShowGachaResultTimer ~= nil then
    self.delayShowGachaResultTimer:Stop()
    self.delayShowGachaResultTimer = nil
  end
end

function ActivityDecorationGachaMainComponent:OnShowGachaAnim(evtData)
  local delayTime = DataCenter.ActivityDecorationGachaManager:GetShowResultDelayTime(evtData)
  if 0 < delayTime then
    self.compWheelContent:PlayGachaAnim(evtData, function()
      if self.activeSelf then
        self.delayShowGachaResultTimer = TimerManager:GetInstance():DelayInvoke(function()
          self:ClearDelayShowGachaResultTimer()
          DataCenter.ActivityDecorationGachaManager:ShowGachaResult()
        end, delayTime)
      end
    end)
  end
end

function ActivityDecorationGachaMainComponent:UpdateDecorationBookRed()
  if self.activityId ~= nil then
    self.compRedDotCollection:SetActive(DataCenter.ActivityDecorationGachaManager:GetDecorationBookRedPoint(self.activityId) > 0)
  end
end

function ActivityDecorationGachaMainComponent:OnRefreshDecorationBookCallback()
  self:UpdateDecorationBookRed()
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

return ActivityDecorationGachaMainComponent
