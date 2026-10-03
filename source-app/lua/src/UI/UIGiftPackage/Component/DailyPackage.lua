local DailyPackage = BaseClass("DailyPackage", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UIDailyPackageGift = require("UI.UIGiftPackage.Component.UIDailyPackageGift")
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local ResourceManager = CS.GameEntry.Resource
local Tweening = CS.DG.Tweening
local poster_bg_path = "Mask/posterBg"
local unique_weapon_bg_path = "Rect_Package/ImageTop/Rect_Top/uniqueWeaponBg"
local unique_poster_ani_path = "Mask/uniquePosterAni"
local AnimationShowName = {
  [DailyPackageType.Hero * 10 + DailyPackageType.HeroUniqueWeapon] = "V_ui_DailyPackageUniquePoster_HeroToUW",
  [DailyPackageType.Hero * 10 + DailyPackageType.HeroAwaken] = "V_ui_DailyPackageUniquePoster_HeroToAwake",
  [DailyPackageType.HeroUniqueWeapon * 10 + DailyPackageType.Hero] = "V_ui_DailyPackageUniquePoster_UWToHero",
  [DailyPackageType.HeroUniqueWeapon * 10 + DailyPackageType.HeroAwaken] = "V_ui_DailyPackageUniquePoster_UWToAwake",
  [DailyPackageType.HeroAwaken * 10 + DailyPackageType.Hero] = "V_ui_DailyPackageUniquePoster_AwakeToHero",
  [DailyPackageType.HeroAwaken * 10 + DailyPackageType.HeroUniqueWeapon] = "V_ui_DailyPackageUniquePoster_AwakeToUW"
}
local AnimationIdleName = {
  [DailyPackageType.Hero] = "V_ui_DailyPackageUniquePoster_Hero_idle",
  [DailyPackageType.HeroUniqueWeapon] = "V_ui_DailyPackageUniquePoster_UW_idle",
  [DailyPackageType.HeroAwaken] = "V_ui_DailyPackageUniquePoster_Awake_idle"
}

function DailyPackage:GetIsAB()
  if DataCenter.DailyPackageManager:IsUsingNewDailyPackage() then
    return ABTestType.B
  else
    return ABTestType.A
  end
end

function DailyPackage:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function DailyPackage:OnDestroy()
  if self.heroSpineLoadRequest ~= nil then
    self.heroSpineLoadRequest:Destroy()
    self.heroSpineLoadRequest = nil
  end
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function DailyPackage:OnEnable()
  base.OnEnable(self)
  self.active = true
  if self.bgPosterAni and self.lastAniType then
    self.bgPosterAni.enabled = true
    local aniName = AnimationIdleName[self.lastAniType]
    self.bgPosterAni:Play(aniName, -1, 0)
    self.bgPosterAni:Update(0)
  end
end

function DailyPackage:OnDisable()
  base.OnDisable(self)
  if self.bgPosterAni then
    self.bgPosterAni.enabled = false
  end
  if self.moveTime ~= nil then
    self.moveTime:Stop()
    self.moveTime = nil
  end
  self.active = false
end

function DailyPackage:ComponentDefine()
  self.animator = self:AddComponent(UIAnimator, "")
  self.animator:Play(CommonUtil.IsArabicAutoMirrorOpen() and "Eff_ui_libao_chuxian_arabic" or "Eff_ui_libao_chuxian", 0, 0)
  self._giftTitle_txt = self:AddComponent(UIText, "Rect_Package/ImageTop/Rect_Top/Txt_GiftTitle")
  self._middleDesc_txt = self:AddComponent(UIText, "Rect_Package/ImageTop/Rect_Middle/Txt_MiddleDesc")
  self._buy_btn = self:AddComponent(UIButton, "Rect_Package/ImageTop/Rect_Middle/buy_btn")
  self._buy_btn:SetOnClick(function()
    self:OnClickBuyBtn()
  end)
  self._buy_btn:SetSafeClickMode(true)
  self._buy_txt = self:AddComponent(UIText, "Rect_Package/ImageTop/Rect_Middle/buy_btn/buy_btn_text")
  self._cost_txt = self:AddComponent(UIText, "Rect_Package/ImageTop/Rect_Middle/buy_btn/Txt_Cost")
  self._point_rect = self:AddComponent(UIGiftPackagePoint, "Rect_Package/ImageTop/Rect_Middle/buy_btn/UIGiftPackagePoint")
  self.originPrice = self:AddComponent(UIImage, "Rect_Package/ImageTop/Rect_Middle/buy_btn/OriginPrice")
  self.originPriceText = self:AddComponent(UIText, "Rect_Package/ImageTop/Rect_Middle/buy_btn/OriginPrice/OriginPriceText")
  self.boughtStateText = self:AddComponent(UIText, "Rect_Package/ImageTop/Rect_Middle/buy_btn/boughtStateText")
  self.boughtStateText:SetLocalText(2000092)
  self.giftList = {}
  for i = 1, 3 do
    self.giftList[i] = self:AddComponent(UIDailyPackageGift, "Rect_Package/ImageTop/Rect_Bottom/Rect_Gift/Rect_Gift" .. i)
  end
  self.giftList_B = {}
  for i = 1, 3 do
    self.giftList_B[i] = self:AddComponent(UIDailyPackageGift, string.format("Rect_Package/ImageTop/Rect_Bottom/Rect_Gift_B/Rect_Gift%d_B", i))
  end
  self.giftListContainer = self:AddComponent(UIBaseContainer, "Rect_Package/ImageTop/Rect_Bottom/Rect_Gift")
  self.giftListContainer_B = self:AddComponent(UIBaseContainer, "Rect_Package/ImageTop/Rect_Bottom/Rect_Gift_B")
  self.freePackageBtnAnimN = self:AddComponent(UIAnimator, "Rect_Package/ImageTop/Rect_Middle/freePackageBtn")
  self.freePackageBtnN = self:AddComponent(UIButton, "Rect_Package/ImageTop/Rect_Middle/freePackageBtn")
  self.freePackageBtnN:SetOnClick(function()
    self:OnClickClaimFreePackage()
  end)
  self.freePackageOpenN = self:AddComponent(UIImage, "Rect_Package/ImageTop/Rect_Middle/freePackageBtn/opened")
  self.freePackageOpenEffN = self:AddComponent(UIBaseContainer, "Rect_Package/ImageTop/Rect_Middle/freePackageBtn/VFX_ui_zhoukabaoxiang_xiaoOpen")
  self.freePackageUnopenN = self:AddComponent(UIImage, "Rect_Package/ImageTop/Rect_Middle/freePackageBtn/unopen")
  self.freePackageUnopenEffN = self:AddComponent(UIBaseContainer, "Rect_Package/ImageTop/Rect_Middle/freePackageBtn/VFX_ui_zhoukabaoxiang_xiao")
  self.freeTxtN = self:AddComponent(UIText, "Rect_Package/ImageTop/Rect_Middle/freePackageBtn/freeTxt")
  self.timerText = self:AddComponent(UIText, "Rect_Package/ImageTop/Rect_Top/remainTime")
  self._middleDesc_txt:SetLocalText(2000090)
  self.heroSpineContainer = self:AddComponent(UIBaseContainer, "Rect_Package/ImageTop/Rect_Top/HeroSpineContainer")
  self.heroNameText = self:AddComponent(UIText, "Rect_Package/ImageTop/Rect_Middle/HorLayout/HeroNameText")
  self.discount = self:AddComponent(UIBaseContainer, "Rect_Package/ImageTop/Rect_Middle/Discount")
  self.discountText = self:AddComponent(UIText, "Rect_Package/ImageTop/Rect_Middle/Discount/DiscountTxt")
  self.selectBtn = self:AddComponent(UIButton, "Rect_Package/ImageTop/Rect_Middle/SelectBtn")
  self.selectBtn:SetOnClick(function()
    if table.IsNullOrEmpty(self.visibleIds) then
      return
    end
    if not self.canSelect then
      UIUtil.ShowTipsId(320563)
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDailyPackageSelectWindow, {anim = false})
  end)
  self.selectBtnIcon = self:AddComponent(UIImage, "Rect_Package/ImageTop/Rect_Middle/SelectBtn/SelectBtnIcon")
  self.info_btn = self:AddComponent(UIButton, "Rect_Package/ImageTop/Rect_Top/InfoBtn")
  self.info_btn:SetOnClick(function()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local serverStartTime = LuaEntry.Player.openServerTime
    local day = UITimeManager:GetInstance().GetDateNum(curTime, serverStartTime)
    local openServer = LuaEntry.DataConfig:TryGetNum("dailypackagehero", "k1")
    local key = ""
    if day >= openServer then
      key = "dailypackage_rules01"
    else
      key = "dailypackage_rules"
    end
    local param = {}
    param.activityRulesStr = Localization:GetString(key)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end)
  self.rect_middle = self:AddComponent(UIBaseContainer, "Rect_Package/ImageTop/Rect_Middle")
  self.rect_bottom = self:AddComponent(UIBaseContainer, "Rect_Package/ImageTop/Rect_Bottom")
  self.selectBtnText = self:AddComponent(UIText, "Rect_Package/ImageTop/Rect_Middle/SelectBtn/SelectBtnText")
  self.poster_bg = self:AddComponent(UIRawImage, poster_bg_path)
  self.unique_weapon_bg = self:AddComponent(UIRawImage, unique_weapon_bg_path)
  self.selectBtnRedDot = self:AddComponent(UIImage, "Rect_Package/ImageTop/Rect_Middle/SelectBtn/select_red")
  self.selectBtnRedDot:SetActive(false)
  self.aniRoot = self:AddComponent(UIBaseContainer, "Mask/aniRoot")
end

function DailyPackage:GetPackList()
  if self:GetIsAB() == ABTestType.B then
    return self.giftList_B
  else
    return self.giftList
  end
end

function DailyPackage:GetPackListContainer()
  if self:GetIsAB() == ABTestType.B then
    return self.giftListContainer_B
  else
    return self.giftListContainer
  end
end

function DailyPackage:Update()
  if self.timerText then
    self.timerText:SetText(UITimeManager:GetInstance():SecondToFmtString(UITimeManager:GetInstance():GetResSecondsTo24()))
  end
end

function DailyPackage:ComponentDestroy()
  if self.bgAniReqs then
    self.bgAniReqs:Destroy()
    self.bgAniReqs = nil
  end
  self._score_txt = nil
  self._time_txt = nil
  self._getMore_btn = nil
  self.title_txt = nil
  self.desc_txt_path = nil
  self.intro_btn = nil
  self._buy_btn = nil
  self._buy_txt = nil
  self._cost_txt = nil
  self._point_rect = nil
  self.originPrice = nil
  self.originPriceText = nil
  self.giftList = nil
  self.giftList_B = nil
  self.freePackageBtnAnimN = nil
  self.freePackageBtnN = nil
  self.freePackageOpenN = nil
  self.freePackageOpenEffN = nil
  self.freePackageUnopenN = nil
  self.freePackageUnopenEffN = nil
  self.freeTxtN = nil
  self.timerText = nil
  self._middleDesc_txt = nil
  self.heroSpineContainer = nil
  self.heroNameText = nil
  self.discount = nil
  self.discountText = nil
  self:StopSelectBtnTween()
  self.selectBtnIcon = nil
  self.info_btn = nil
end

function DailyPackage:DataDefine()
  self.active = false
  self.groupIndex = 1
  self.selectBtnIconTweenSeq = nil
  self.lastAniType = nil
end

function DailyPackage:DataDestroy()
  self.bgPosterAni = nil
  self.lastAniType = nil
  self.waitingForPrice = nil
end

function DailyPackage:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGiftPackData, self.ReInit)
  self:AddUIListener(EventId.UpdateDailyPackage, self.ReInit)
  self:AddUIListener(EventId.OnGetFormattedPriceFromNative, self.OnGetFormattedPriceFromNative)
  self:AddUIListener(EventId.RefreshWelfareRedDot, self.RefreshRedDot)
  self:AddUIListener(EventId.FreeWeeklyPackage, self.RefreshTop)
end

function DailyPackage:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.ReInit)
  self:RemoveUIListener(EventId.UpdateDailyPackage, self.ReInit)
  self:RemoveUIListener(EventId.OnGetFormattedPriceFromNative, self.OnGetFormattedPriceFromNative)
  self:RemoveUIListener(EventId.RefreshWelfareRedDot, self.RefreshRedDot)
  self:RemoveUIListener(EventId.FreeWeeklyPackage, self.RefreshTop)
  base.OnRemoveListener(self)
end

function DailyPackage:RefreshPackData()
  self.totalPack, self.packs = DataCenter.DailyPackageManager:getDailyPackageGroup()
end

function DailyPackage:ReInit()
  if not self.active then
    return
  end
  DataCenter.DailyPackageManager:CheckNeedRequest()
  local curGiftList = self:GetPackList()
  if not curGiftList then
    return
  end
  self.visibleIds = DataCenter.DailyPackageManager:GetVisibleIds()
  if table.IsNullOrEmpty(self.visibleIds) then
    self.selectBtn:SetActive(false)
    self._buy_btn:SetActive(false)
    for i = 1, 3 do
      curGiftList[i]:SetActive(false)
    end
    return
  end
  self._buy_btn:SetActive(true)
  for i = 1, 3 do
    curGiftList[i]:SetActive(true)
  end
  self.dailyPackageTemplate = DataCenter.DailyPackageManager:GetSelectingTemplate()
  self:RefreshPackData()
  self:InitBgAnimation()
  self:RefreshBg()
  self:RefreshTop()
  self:RefreshMiddle()
  self:RefreshBottom()
  self:StopSelectBtnTween()
  local tabCount = DataCenter.DailyPackageManager:GetTabs()
  if table.IsNullOrEmpty(self.visibleIds) or table.count(self.visibleIds) == 1 and tabCount == 1 then
    self.selectBtn:SetActive(false)
  else
    self.selectBtn:SetActive(true)
    local canSelect = true
    if self.packageInfok2 == nil or self.packageInfok2:isBought() then
      canSelect = false
    end
    if canSelect and self.packs and #self.packs > 0 then
      for i = 1, #self.packs do
        if self.packs[i] ~= nil then
          local info = GiftPackageData.get(self.packs[i])
          if info == nil or info:isBought() then
            canSelect = false
            break
          end
        end
      end
    end
    self.canSelect = canSelect
    UIGray.SetGray(self.selectBtn.transform, not self.canSelect, true)
    self:RefreshRedDot()
    if self.canSelect then
      self.selectBtnIconTweenSeq = Tweening.DOTween.Sequence()
      self.selectBtnIconTweenSeq:Append(self.selectBtnIcon.transform:DORotate(Vector3.New(0, 0, -180), 0.8, Tweening.RotateMode.LocalAxisAdd):SetEase(Tweening.Ease.Linear))
      self.selectBtnIconTweenSeq:AppendInterval(2)
      self.selectBtnIconTweenSeq:Append(self.selectBtnIcon.transform:DORotate(Vector3.New(0, 0, -180), 0.8, Tweening.RotateMode.LocalAxisAdd):SetEase(Tweening.Ease.Linear))
      self.selectBtnIconTweenSeq:AppendInterval(2)
      self.selectBtnIconTweenSeq:SetLoops(-1)
    end
  end
end

function DailyPackage:InitBgAnimation()
  local path = self:GetDynamicAniPrefabPath()
  if not self.bgAniReqs and not string.IsNullOrEmpty(path) then
    local request = ResourceManager:InstantiateAsync(path)
    self.bgAniReqs = request
    self.bgAniReqs:completed("+", function(req)
      if req.isError then
        return
      end
      local go = req.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.aniRoot.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      self.bgPosterAni = go.gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
      if self.bgPosterAni then
        self.bgPosterAni.enabled = self.active
        if self.active then
          local aniName = AnimationIdleName[self.dailyPackageTemplate.content_type]
          self.bgPosterAni:Play(aniName, -1, 0)
          self.bgPosterAni:Update(0)
          self.lastAniType = self.dailyPackageTemplate.content_type
        end
      end
    end)
  end
end

function DailyPackage:StopSelectBtnTween()
  if self.selectBtnIconTweenSeq ~= nil then
    self.selectBtnIconTweenSeq:Kill()
    self.selectBtnIconTweenSeq = nil
    self.selectBtnIcon.transform.rotation = Quaternion.Euler(0, 0, 0)
  end
end

local heroQualityNameColor = {
  [1] = "#EAE6EC",
  [2] = "#80F5C5",
  [3] = "#70E6F1",
  [4] = "#EB86FF",
  [5] = "#FFB644",
  [6] = "#FB7156"
}

function DailyPackage:RefreshMiddle()
  if string.IsNullOrEmpty(self.totalPack) then
    return
  end
  self.packageInfok2 = GiftPackageData.get(self.totalPack)
  self.hasBoughtTotalPack = false
  if self.packageInfok2 then
    self.hasBoughtTotalPack = self.packageInfok2:isBought()
    local discount = self.packageInfok2:getPercent()
    if discount then
      self.discount:SetActive(true)
      self.discountText:SetText(string.format("%d%%", discount))
    else
      self.discount:SetActive(false)
    end
    self.heroId = nil
    if self.dailyPackageTemplate then
      self.heroId = self.dailyPackageTemplate:GetHeroId()
    end
    if self.heroSpineLoadRequest ~= nil then
      self.heroSpineLoadRequest:Destroy()
      self.heroSpineLoadRequest = nil
    end
    if self.heroId then
      local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(self.heroId)
      if heroTemplate then
        local quality = heroTemplate.quality
        local heroName = Localization:GetString(heroTemplate.name)
        local colorStr = heroQualityNameColor[quality]
        self.heroNameText:SetText(heroName)
        local appearanceId
        if self.dailyPackageTemplate.content_type == DailyPackageType.HeroUniqueWeapon or self.dailyPackageTemplate.content_type == DailyPackageType.Hero then
          appearanceId = heroTemplate.appearance
        elseif self.dailyPackageTemplate.content_type == DailyPackageType.HeroAwaken then
          appearanceId = self.dailyPackageTemplate.awaken_appearance
        end
        local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(appearanceId)
        local spinePath = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_path")
        local request = ResourceManager:InstantiateAsync(spinePath)
        self.heroSpineLoadRequest = request
        request:completed("+", function()
          if request.isError or IsNull(request.gameObject) then
            self.heroSpineLoadRequest = nil
            return
          end
          local spineMaskRect = self.dailyPackageTemplate.spinePageMaskRect
          local spinePos = self.dailyPackageTemplate.spinePagePos
          local obj = request.gameObject
          obj:SetActive(true)
          obj.transform:SetParent(self.heroSpineContainer.transform)
          obj.transform.localPosition = Vector3.New(0, 0, 0)
          obj.transform.localScale = Vector3.New(1, 1, 1)
          local dir = 1
          if CommonUtil.IsArabic() and CommonUtil.ArabicAutoMirrorFactor() == -1 then
            dir = -1
          end
          if spinePos then
            local rectTransform = obj:GetComponent(typeof(CS.UnityEngine.RectTransform))
            rectTransform:Set_anchoredPosition(spinePos.x * dir, spinePos.y, 0)
          end
          if spineMaskRect then
            self.heroSpineContainer.transform:Set_localScale(spineMaskRect.scale, spineMaskRect.scale, 1)
            self.heroSpineContainer.rectTransform:Set_anchoredPosition(spineMaskRect.x * dir, spineMaskRect.y, 0)
            self.heroSpineContainer.rectTransform.sizeDelta = Vector2.New(spineMaskRect.width, spineMaskRect.height)
          end
        end)
      end
    else
      local nameStr = ""
      if self.rewardInfo then
        nameStr = DataCenter.RewardManager:GetNameByType(self.rewardInfo.rewardType, self.rewardInfo.itemId)
      end
      self.heroNameText:SetText(nameStr)
    end
  else
    self.discount:SetActive(false)
  end
end

function DailyPackage:RefreshBottom()
  self.isGray = false
  local hasBuyAllPack = true
  if table.IsNullOrEmpty(self.packs) then
    return
  end
  local curGiftList = self:GetPackList()
  if not curGiftList then
    return
  end
  for i = 1, 3 do
    if self.packs[i] ~= nil then
      curGiftList[i]:ReInit(self.packs[i], self.packageInfok2 and self.packageInfok2:isBought(), self.dailyPackageTemplate)
      local info = GiftPackageData.get(self.packs[i])
      if info:isBought() then
        self.isGray = true
      else
        hasBuyAllPack = false
      end
    end
  end
  if self.hasBoughtTotalPack then
    UIGray.SetGray(self._buy_btn.transform, true, false)
  elseif self.isGray then
    UIGray.SetGray(self._buy_btn.transform, true, true)
  else
    UIGray.SetGray(self._buy_btn.transform, false, true)
  end
  if self.hasBoughtTotalPack or self.isGray and hasBuyAllPack then
    self._cost_txt:SetActive(false)
    self.originPrice:SetActive(false)
    self.boughtStateText:SetActive(true)
    self._point_rect:SetActive(false)
  else
    self._cost_txt:SetActive(true)
    self.originPrice:SetActive(true)
    self.boughtStateText:SetActive(false)
    if self.packageInfok2 then
      self._cost_txt:SetText(self.packageInfok2:getPriceText())
      local totalPriceNum
      if self.packs then
        totalPriceNum = 0
        for k, v in pairs(self.packs) do
          local info = GiftPackageData.get(v)
          if info then
            local num = DataCenter.PayManager:GetProductPriceNumber(info:getProductID())
            if num == nil then
              totalPriceNum = nil
              break
            else
              totalPriceNum = totalPriceNum + num
            end
          end
        end
      end
      if totalPriceNum == nil then
        self.originPriceText:SetText(self.packageInfok2:getOriginalPriceText())
      else
        self.originPriceText:SetText(self.packageInfok2:getOriginalPriceText())
        self.waitingForPrice = tostring(totalPriceNum)
        DataCenter.PayManager:GetPriceLocal(self.waitingForPrice)
      end
    end
    self._point_rect:SetActive(true)
    self._point_rect:RefreshPoint(self.packageInfok2)
  end
end

function DailyPackage:OnGetFormattedPriceFromNative(data)
  if string.IsNullOrEmpty(data) then
    return
  end
  self.originPriceText:SetText(data[2])
end

function DailyPackage:RefreshBg()
  if not self.dailyPackageTemplate then
    return
  end
  if self.bgAniReqs and self.bgAniReqs.isDone == true then
    local aniName
    if self.lastAniType == nil then
      aniName = AnimationIdleName[self.dailyPackageTemplate.content_type]
    else
      aniName = self:GetTransitionAniName(self.lastAniType, self.dailyPackageTemplate.content_type)
    end
    if self.bgPosterAni and aniName and self.active == true and self.lastAniType ~= self.dailyPackageTemplate.content_type then
      self.bgPosterAni:Play(aniName, -1, 0)
      self.bgPosterAni:Update(0)
      self.lastAniType = self.dailyPackageTemplate.content_type
    end
  end
  local isUniqueWeapon = self.dailyPackageTemplate.content_type == DailyPackageType.HeroUniqueWeapon
  if isUniqueWeapon then
    self.unique_weapon_bg:LoadSpriteAsync(string.format(LoadPath.DailyPackageUniqueWeapon, self.dailyPackageTemplate.pic_para1))
    local param = self.dailyPackageTemplate.posterPageRect
    if param then
      local posterRect = self.unique_weapon_bg.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
      posterRect.anchoredPosition = Vector2.New(param.x, param.y)
      posterRect.sizeDelta = Vector2.New(param.width, param.height)
    end
  end
  self.unique_weapon_bg.gameObject:SetActive(isUniqueWeapon)
end

function DailyPackage:GetDynamicAniPrefabPath()
  local ids = DataCenter.DailyPackageManager:GetVisibleIdsByType(DailyPackageType.HeroUniqueWeapon)
  local ids2Awaken = DataCenter.DailyPackageManager:GetVisibleIdsByType(DailyPackageType.HeroAwaken)
  local hasUniqueWeaponPackage = ids ~= nil and 0 < #ids
  local hasAwaken = ids2Awaken ~= nil and 0 < #ids2Awaken
  if hasUniqueWeaponPackage and not hasAwaken then
    return UIAssets.DailyPackageBgPosterUniqueWeapon
  elseif hasAwaken then
    return UIAssets.DailyPackageUniquePosterAni_Awake
  end
end

function DailyPackage:GetTransitionAniName(curState, targetState)
  if not curState or not targetState then
    Logger.LogError("state is error!  cur:" .. tostring(curState) .. "  tar:" .. tostring(targetState))
    return
  end
  local key = curState * 10 + targetState
  return AnimationShowName[key]
end

function DailyPackage:RefreshTop()
  if not GiftPackageData.CheckIfHasFreeWeeklyPackage() then
    self.freePackageBtnAnimN:Play("V_ui_zhoukabaoxiang_01_opened", 0, 0)
    self.freePackageOpenN:SetActive(true)
    self.freePackageUnopenN:SetActive(false)
    self.freeTxtN:SetLocalText(170003)
  else
    self.freePackageBtnAnimN:Play("V_ui_zhoukabaoxiang_01_idle", 0, 0)
    self.freePackageOpenN:SetActive(false)
    self.freePackageUnopenN:SetActive(true)
    self.freeTxtN:SetLocalText(320227)
  end
end

function DailyPackage:OnClickClaimFreePackage()
  local hasFree = GiftPackageData.CheckIfHasFreeWeeklyPackage()
  if hasFree then
    self.freePackageBtnAnimN:Play("V_ui_zhoukabaoxiang_01_open", 0, 0)
    self.claimFreeTimer = TimerManager:GetInstance():DelayInvoke(function()
      SFSNetwork.SendMessage(MsgDefines.BuyFreeWeeklyPackage, false)
      self.claimFreeTimer = nil
    end, 0.5)
  else
    UIUtil.ShowTipsId(170003)
  end
end

function DailyPackage:OnClickBuyBtn()
  if self.isGray then
    return UIUtil.ShowTipsId(2000091)
  end
  local dailyConfig = self.dailyPackageTemplate
  if not dailyConfig then
    Logger.LogError("dailyConfig is nil!  ")
    return
  end
  if dailyConfig.content_type == DailyPackageType.Hero then
    self.view.ctrl:BuyGift(self.packageInfok2)
    return
  end
  local result
  if dailyConfig.content_type == DailyPackageType.HeroUniqueWeapon then
    result = self:_onBuyUniqueWeapon()
  elseif dailyConfig.content_type == DailyPackageType.HeroAwaken then
    result = self:_onBuyAwaken()
  end
  if result then
    self.view.ctrl:BuyGift(self.packageInfok2)
  end
end

function DailyPackage:_onBuyUniqueWeapon()
  local dailyConfig = self.dailyPackageTemplate
  local targetHeroId = dailyConfig.selectConditionHeroId
  local targetStarId = dailyConfig.selectConditionStarId
  local heroRankConfig = DataCenter.HeroRankTemplateManager:GetTemplate(targetStarId)
  if heroRankConfig == nil then
    Logger.LogError("isValid targetStarId!  Daily ID:" .. dailyConfig.id)
    return
  end
  local heroConfig = DataCenter.HeroTemplateManager:GetTemplate(targetHeroId)
  if heroConfig == nil then
    Logger.LogError("isValid heroId!  Daily ID:" .. dailyConfig.id)
    return
  end
  local curStarId = 0
  local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(targetHeroId)
  if heroData ~= nil then
    curStarId = heroData.rankTemplate.id
  end
  if targetStarId > curStarId then
    UIUtil.ShowMessage(Localization:GetString("dailygift_buy_tips1", Localization:GetString(heroConfig.name)), 2, nil, nil, function()
      self.view.ctrl:BuyGift(self.packageInfok2)
      return
    end)
    return
  end
  local uniqueMaxLv = DataCenter.HeroUniqueWeaponTemplateManager:GetMaxLevel(targetHeroId)
  local curUniqueLv = 0
  if heroData then
    curUniqueLv = heroData.uniqueWeaponLv
  end
  if uniqueMaxLv ~= 0 and uniqueMaxLv <= curUniqueLv and heroData:IsAllUnitMaxLv() then
    UIUtil.ShowMessage(Localization:GetString("dailygift_buy_tips2", Localization:GetString(heroConfig.name), uniqueMaxLv), 2, nil, nil, function()
      self.view.ctrl:BuyGift(self.packageInfok2)
      return
    end)
    return
  end
  return true
end

function DailyPackage:_onBuyAwaken()
  local dailyConfig = self.dailyPackageTemplate
  local targetHeroId = dailyConfig:GetHeroId()
  local targetUniqueLv = dailyConfig.selectConditionStarId
  local heroConfig = DataCenter.HeroTemplateManager:GetTemplate(targetHeroId)
  if heroConfig == nil then
    Logger.LogError("isValid heroId!  Daily ID:" .. dailyConfig.id)
    return
  end
  local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(targetHeroId)
  local curUniqueLv = 0
  if heroData then
    curUniqueLv = heroData.uniqueWeaponLv
  end
  if targetUniqueLv > curUniqueLv then
    UIUtil.ShowMessage(Localization:GetString("dailygift3_buy_2", Localization:GetString(heroConfig.name), targetUniqueLv), 2, nil, nil, function()
      self.view.ctrl:BuyGift(self.packageInfok2)
      return
    end)
    return
  end
  local isMaxAwakenLv = heroData:IsHeroAwakenReachMaxLevel()
  local maxAwakenLv = heroData:GetHeroAwakenMaxLevel()
  if isMaxAwakenLv then
    UIUtil.ShowMessage(Localization:GetString("dailygift3_buy_4", Localization:GetString(heroConfig.name), maxAwakenLv), 2, nil, nil, function()
      self.view.ctrl:BuyGift(self.packageInfok2)
      return
    end)
    return
  else
    local targetStar = dailyConfig.awakenConditionStarId
    local curAwakenStar = heroData:GetHeroAwakenRankLevel()
    if targetStar and curAwakenStar < dailyConfig.awakenConditionStarId then
      UIUtil.ShowMessage(Localization:GetString("dailygift3_buy_7", Localization:GetString(heroConfig.name), targetStar), 2, nil, nil, function()
        self.view.ctrl:BuyGift(self.packageInfok2)
        return
      end)
      return
    end
  end
  return true
end

function DailyPackage:RefreshRedDot()
  if self.canSelect then
    self.selectBtnRedDot:SetActive(DataCenter.DailyPackageManager:HasTabRedDot())
  else
    self.selectBtnRedDot:SetActive(false)
  end
end

return DailyPackage
