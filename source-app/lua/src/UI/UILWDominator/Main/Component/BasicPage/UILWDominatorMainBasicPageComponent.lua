local base = require("UI/UILWDominator/Main/Component/UILWDominatorMainPageBaseComponent")
local UILWDominatorMainBasicPageComponent = BaseClass("UILWDominatorMainBasicPageComponent", base)
local Localization = CS.GameEntry.Localization
local UILWDominatorMainRankItemComponent = require("UI/UILWDominator/Main/Component/BasicPage/UILWDominatorMainRankItemComponent")
local UILWDominatorMainTrainInfoItemComponent = require("UI/UILWDominator/Main/Component/BasicPage/UILWDominatorMainTrainInfoItemComponent")
local UIHeroSkillItem = require("UI/UILWDominator/Main/Component/SkillPage/UILWDominatorSkillItemComponent")
local UILWDominatorMainSelectItemComponent = require("UI/UILWDominator/Main/Component/UILWDominatorMainSelectItemComponent")

function UILWDominatorMainBasicPageComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWDominatorMainBasicPageComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorMainBasicPageComponent:ComponentDefine()
  self.animator = self:AddComponent(UIAnimator, "")
  self.btnInfo = self:AddComponent(UIButton, "Top/InfoBtn")
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.btnPlay = self:AddComponent(UIButton, "Top/PlayBtn")
  self.btnPlay:SetOnClick(function()
    self:OnBtnPlayClick()
  end)
  self.textPlayBtn = self:AddComponent(UIText, "Top/PlayBtn/PlayBtnText")
  self.textPlayBtn:SetLocalText("dominator_overview_desc_1")
  self.btnShare = self:AddComponent(UIButton, "Top/ShareBtn")
  self.btnShare:SetOnClick(function()
    self:OnBtnShareClick()
  end)
  self.textShareBtn = self:AddComponent(UIText, "Top/ShareBtn/ShareBtnText")
  self.textShareBtn:SetLocalText("dominator_overview_desc_2")
  self.btnSkin = self:AddComponent(UIButton, "Top/SkinBtn")
  self.btnSkin:SetOnClick(function()
    self:OnBtnPropertyClick()
  end)
  self.textUserName = self:AddComponent(UIText, "NameContent/UserNameText")
  self.textSkinBtn = self:AddComponent(UIText, "Top/SkinBtn/SkinBtnText")
  self.textSkinBtn:SetLocalText("dominator_overview_desc_3")
  self.btnChangeName = self:AddComponent(UIButton, "NameContent/ChangeNameBtn")
  self.btnChangeName:SetOnClick(function()
    self:OnBtnChangeNameClick()
  end)
  self.btnBattle = self:AddComponent(UIButton, "Top/Left/BattleBtn")
  self.btnBattle:SetOnClick(function()
    self:OnBtnBattleClick()
  end)
  self.compBattleLock = self:AddComponent(UIBaseContainer, "Top/Left/BattleBtn/BattleLock")
  self.btnCityShow = self:AddComponent(UIButton, "Top/Left/CityShowBtn")
  self.btnCityShow:SetOnClick(function()
    self:OnBtnCityShowClick()
  end)
  self.btnCityShow:SetSafeClickMode(true)
  self.imgCityShow = self:AddComponent(UIImage, "Top/Left/CityShowBtn/Icon")
  self.textCityShow = self:AddComponent(UIText, "Top/Left/CityShowBtn/CityShowBtnText")
  self.btnAtkInfo = self:AddComponent(UIButton, "ContentLayout/EffectContent/AtkInfo")
  self.btnAtkInfo:SetOnClick(function()
    self:OnBtnAtkInfoClick()
  end)
  self.btnHpInfo = self:AddComponent(UIButton, "ContentLayout/EffectContent/HpInfo")
  self.btnHpInfo:SetOnClick(function()
    self:OnBtnHpInfoClick()
  end)
  self.btnDefInfo = self:AddComponent(UIButton, "ContentLayout/EffectContent/DefInfo")
  self.btnDefInfo:SetOnClick(function()
    self:OnBtnDefInfoClick()
  end)
  self.btnSdCapacityInfo = self:AddComponent(UIButton, "ContentLayout/EffectContent/SdCapacityInfo")
  self.btnSdCapacityInfo:SetOnClick(function()
    self:OnBtnSdCapacityInfoClick()
  end)
  self.textAtkInfoTitle = self:AddComponent(UIText, "ContentLayout/EffectContent/AtkInfo/AtkInfoTitleText")
  self.textCurAtk = self:AddComponent(UIText, "ContentLayout/EffectContent/AtkInfo/AtkInfoNumber/CurAtkText")
  self.textHpInfoTitle = self:AddComponent(UIText, "ContentLayout/EffectContent/HpInfo/HpInfoTitleText")
  self.textCurHp = self:AddComponent(UIText, "ContentLayout/EffectContent/HpInfo/HpInfoNumber/CurHpText")
  self.textDefInfoTitle = self:AddComponent(UIText, "ContentLayout/EffectContent/DefInfo/DefInfoTitleText")
  self.textCurDef = self:AddComponent(UIText, "ContentLayout/EffectContent/DefInfo/DefInfoNumber/CurDefText")
  self.textSCInfoTitle = self:AddComponent(UIText, "ContentLayout/EffectContent/SdCapacityInfo/SCInfoTitleText")
  self.textCurSC = self:AddComponent(UIText, "ContentLayout/EffectContent/SdCapacityInfo/SCInfoNumber/CurSCText")
  self.compContentLayout = self:AddComponent(UIBaseContainer, "ContentLayout")
  self.compUnlockInfoContent = self:AddComponent(UIBaseContainer, "ContentLayout/MainContent/UnlockInfoContent")
  self.compLockedCover = self:AddComponent(UIBaseContainer, "ContentLayout/MainContent/LockedCover")
  self.compNotMaxContent = self:AddComponent(UIBaseContainer, "ContentLayout/MainContent/UnlockInfoContent/NotMaxContent")
  self.compMaxContent = self:AddComponent(UIBaseContainer, "ContentLayout/MainContent/UnlockInfoContent/MaxContent")
  self.textMaxName = self:AddComponent(UIText, "ContentLayout/MainContent/UnlockInfoContent/MaxContent/MaxNameText")
  self.imgRankIcon = self:AddComponent(UIImage, "ContentLayout/MainContent/UnlockInfoContent/RankIcon")
  self.textRankProgressValue = self:AddComponent(UIText, "ContentLayout/MainContent/UnlockInfoContent/NotMaxContent/RankProgressValueText")
  self.textName = self:AddComponent(UIText, "ContentLayout/MainContent/UnlockInfoContent/NotMaxContent/NameText")
  self.compRankLayout = self:AddComponent(UIBaseContainer, "ContentLayout/MainContent/UnlockInfoContent/NotMaxContent/RankLayout")
  self.compUIHeroSkillItem01 = self:AddComponent(UIHeroSkillItem, "ContentLayout/MainContent/SkillContent/UIHeroSkillItem01")
  self.compUIHeroSkillItem02 = self:AddComponent(UIHeroSkillItem, "ContentLayout/MainContent/SkillContent/UIHeroSkillItem02")
  self.compUIHeroSkillItem03 = self:AddComponent(UIHeroSkillItem, "ContentLayout/MainContent/SkillContent/UIHeroSkillItem03")
  self.compUIHeroSkillItem04 = self:AddComponent(UIHeroSkillItem, "ContentLayout/MainContent/SkillContent/UIHeroSkillItem04")
  self.compUIHeroSkillItems = {
    self.compUIHeroSkillItem01,
    self.compUIHeroSkillItem02,
    self.compUIHeroSkillItem03,
    self.compUIHeroSkillItem04
  }
  self.compSkillItemCenter = self:AddComponent(UIHeroSkillItem, "ContentLayout/MainContent/SkillContent/SkillItemCenter")
  self.compLockedInfoContent = self:AddComponent(UIBaseContainer, "ContentLayout/MainContent/LockedInfoContent")
  self.textLockedName = self:AddComponent(UIText, "ContentLayout/MainContent/LockedInfoContent/LockedNameText")
  self.textLockedName:SetLocalText("dominator_lock_desc_1")
  self.textLockedDes = self:AddComponent(UIText, "ContentLayout/MainContent/LockedInfoContent/LockedDesText")
  self.compVFXSaomiao1 = self:AddComponent(UIBaseContainer, "ContentLayout/MainContent/LockedInfoContent/VFX_saomiao1")
  self.compPageSwitch = self:AddComponent(UIBaseContainer, "PageSwitch")
  self.btnLeftSwitch = self:AddComponent(UIButton, "PageSwitch/LeftSwitchBtn")
  self.btnLeftSwitch:SetOnClick(function()
    self:OnBtnLeftSwitchClick()
  end)
  self.btnRightSwitch = self:AddComponent(UIButton, "PageSwitch/RightSwitchBtn")
  self.btnRightSwitch:SetOnClick(function()
    self:OnBtnRightSwitchClick()
  end)
  self.textPowerNumber = self:AddComponent(UIText, "PageSwitch/MiddleLayout/PowerLayout/PowerNumberText")
  self.compDominatorSelectContent = self:AddComponent(UIBaseContainer, "PageSwitch/MiddleLayout/DominatorSelectContent")
  self.btnArchive = self:AddComponent(UIButton, "Top/ArchiveBtn")
  self.btnArchive:SetOnClick(function()
    self:OnBtnArchiveClick()
  end)
  self.textArchive = self:AddComponent(UIText, "Top/ArchiveBtn/ArchiveText")
  self.textArchive:SetText(Localization:GetString("dominator_story_enter_name"))
  self.compArchiveRed = self:AddComponent(UIBaseContainer, "Top/ArchiveBtn/ArchiveRed")
  self.btnRankPreview = self:AddComponent(UIButton, "Top/RankPreviewBtn")
  self.btnRankPreview:SetOnClick(function()
    self:OnBtnRankPreviewClick()
  end)
  self.textRankPreviewBtn = self:AddComponent(UIText, "Top/RankPreviewBtn/RankPreviewBtnText")
  self.textRankPreviewBtn:SetLocalText("dominator_star_button_1")
end

function UILWDominatorMainBasicPageComponent:ComponentDestroy()
  self.animator = nil
  self.btnInfo = nil
  self.btnPlay = nil
  self.textPlayBtn = nil
  self.btnShare = nil
  self.textShareBtn = nil
  self.btnSkin = nil
  self.textSkinBtn = nil
  self.btnChangeName = nil
  self.textUserName = nil
  self.btnBattle = nil
  self.compBattleLock = nil
  self.btnCityShow = nil
  self.textCityShow = nil
  self.imgCityShow = nil
  self.compNotMaxContent = nil
  self.compMaxContent = nil
  self.textMaxName = nil
  self.imgRankIcon = nil
  self.textRankProgressValue = nil
  self.compRankLayout = nil
  self.textName = nil
  self.compUIHeroSkillItem01 = nil
  self.compUIHeroSkillItem02 = nil
  self.compUIHeroSkillItem03 = nil
  self.compUIHeroSkillItem04 = nil
  self.compSkillItemCenter = nil
  self.btnAtkInfo = nil
  self.btnHpInfo = nil
  self.btnDefInfo = nil
  self.btnSdCapacityInfo = nil
  self.textAtkInfoTitle = nil
  self.textCurAtk = nil
  self.textHpInfoTitle = nil
  self.textCurHp = nil
  self.textDefInfoTitle = nil
  self.textCurDef = nil
  self.textSCInfoTitle = nil
  self.textCurSC = nil
  self.textLockedName = nil
  self.textLockedDes = nil
  self.compLockedCover = nil
  self.compLockedSkillContent = nil
  self.compContentLayout = nil
  self.compUnlockInfoContent = nil
  self.compLockedInfoContent = nil
  self.compPageSwitch = nil
  self.btnLeftSwitch = nil
  self.btnRightSwitch = nil
  self.textPowerNumber = nil
  self.compDominatorSelectContent = nil
  self.btnArchive = nil
  self.textArchive = nil
  self.compArchiveRed = nil
  self.btnRankPreview = nil
  self.textRankPreviewBtn = nil
end

function UILWDominatorMainBasicPageComponent:DataDefine()
  self.clickSkillCallBack = BindCallback(self, self.OnClickSkillItem)
  self.rankItems = {}
  self.rankItemReqs = {}
  self.selectItemReqs = {}
  self.selectItems = {}
end

function UILWDominatorMainBasicPageComponent:DataDestroy()
  self.clickSkillCallBack = nil
  self.rankItems = nil
  self.rankItemReqs = nil
  self.selectItemReqs = nil
  self.selectItems = nil
  self.compUIHeroSkillItems = nil
  if self.unlockAnimTimer ~= nil then
    self.unlockAnimTimer:Stop()
    self.unlockAnimTimer = nil
  end
end

function UILWDominatorMainBasicPageComponent:ReInit()
  if not self.view then
    return
  end
  self.info = self.view:GetCurShowInfo()
  if not self.info then
    return
  end
  self.mainTemplate = self.info:GetMainTemplate()
  if not self.mainTemplate then
    return
  end
  self:UpdateContent()
  self:UpdateUserName()
  self:UpdateBattleBtn()
  self:UpdateSwitchContent()
  self:UpdatePower()
  self:UpdateEffect()
  self:UpdateArchiveBtn()
  self:UpdateCityShowBtn()
end

function UILWDominatorMainBasicPageComponent:UpdateContent()
  local isUnlock = DataCenter.DominatorManager:IsUpgradeRankAndSkillUnlock()
  local hasShownUnlockAnim = DataCenter.DominatorGuideManager:IsHasShownUpgradeRankAndSkillUnlockAnim()
  if not isUnlock then
    self:UpdateBasicInfoLocked()
    self.animator:Play("V_ui_UILWDominatorMainBasicPage_in_lock")
    self:UpdateSkill(true)
  elseif hasShownUnlockAnim then
    self:UpdateBasicInfoUnlock()
    self:UpdateSkill(false)
    self.animator:Play("V_ui_UILWDominatorMainBasicPage_in_unlock")
  else
    self:UpdateBasicInfoUnlock()
    self:UpdateBasicInfoLocked()
    self:UpdateSkill(true)
    local ret, time = self.animator:PlayAnimationReturnTime("V_ui_UILWDominatorMainBasicPage_unlock")
    if ret then
      self.unlockAnimTimer = TimerManager:GetInstance():GetTimer(time, function()
        if self.unlockAnimTimer ~= nil then
          self.unlockAnimTimer:Stop()
          self.unlockAnimTimer = nil
        end
        if self.view then
          self.view:UpdateToggle()
        end
        self:UpdateSkill(false)
      end, self, true, false, false)
      self.unlockAnimTimer:Start()
    end
    DataCenter.DominatorGuideManager:SetHasShownUpgradeRankAndSkillUnlockAnim()
  end
end

function UILWDominatorMainBasicPageComponent:UpdateSkill(isForceLockSkill)
  if not self.info or not self.mainTemplate then
    return
  end
  if not self.compSkillItemCenter or not self.compUIHeroSkillItems then
    return
  end
  local count = self.info:GetTotalSkillCount()
  if count <= 0 then
    return
  end
  local normalSkillIndex = 1
  local centerSkillIndex = self.mainTemplate:GetCenterSkillIndex()
  for i = 1, count do
    local skillData = self.info:GetSkillInfoBySlotIndex(i)
    local unlockLevel = 0
    local isRealUnlock = true
    if skillData then
      if not self.mainTemplate:IsShowSkillBySkillGroup(skillData:GetGroupId()) then
        goto lbl_102
      end
      if not skillData:IsUnlock() then
        unlockLevel = self.info:GetSkillUnlockRankByIndex(i)
        isRealUnlock = false
      end
    end
    local skillShowParam = {
      showSkillName = false,
      showSkillLevel = true,
      showLock = true,
      showRedPoint = false,
      showStar = true,
      showSkillLevel = not isForceLockSkill and isRealUnlock,
      showLockForce = isForceLockSkill
    }
    local isCenter = i == centerSkillIndex
    if isCenter then
      self.compSkillItemCenter:SetData(skillData, skillShowParam, self.clickSkillCallBack)
      self.compSkillItemCenter:SetSelected(false)
    else
      if self.compUIHeroSkillItems[normalSkillIndex] then
        self.compUIHeroSkillItems[normalSkillIndex]:SetData(skillData, skillShowParam, self.clickSkillCallBack)
        self.compUIHeroSkillItems[normalSkillIndex]:SetSelected(false)
      end
      normalSkillIndex = normalSkillIndex + 1
    end
    ::lbl_102::
  end
end

function UILWDominatorMainBasicPageComponent:UpdateUserName()
  if not self.info then
    return
  end
  self.textUserName:SetText(self.info:GetUserName())
end

function UILWDominatorMainBasicPageComponent:UpdateBasicInfoLocked()
  local trainId = DataCenter.DominatorManager:GetUpgradeRankAndSkillUnlockTrainId()
  local trainTemplate = DataCenter.DominatorTemplateManager:GetTrainLevelTemplateById(trainId)
  if trainTemplate then
    self.textLockedDes:SetLocalText("dominator_lock_desc_2", trainTemplate:GetName())
  end
end

function UILWDominatorMainBasicPageComponent:UpdateBasicInfoUnlock()
  if not self.info or not self.mainTemplate then
    return
  end
  local rankTemplate = self.info:GetCurRankTemplate()
  if rankTemplate then
    local rankShowTemplate = rankTemplate:GetRankShowTemplate()
    if rankShowTemplate then
      local name = rankShowTemplate:GetName()
      self.textName:SetText(name)
      self.textMaxName:SetText(name)
      self.imgRankIcon:LoadSprite(rankShowTemplate:GetRankIconPathBig())
    end
    local isMax = rankTemplate:IsMaxRank()
    self.compMaxContent:SetActive(isMax)
    self.compNotMaxContent:SetActive(not isMax)
    if not isMax then
      local rankInBigRank = rankTemplate:GetLevelOrderInBigRank()
      local totalRankInBigRank = rankTemplate:GetLevelCountInBigRank()
      self:ReloadRankItem(totalRankInBigRank, function()
        self:UpdateRankItem(rankInBigRank)
      end)
      self.textRankProgressValue:SetText(rankTemplate:GetShowLevelText())
    end
  end
end

function UILWDominatorMainBasicPageComponent:UpdateBattleBtn()
  if not self.info or not self.mainTemplate then
    return
  end
  local showBattleBtn = not self.info:IsUnlockedBattle()
  self.btnBattle:SetActive(showBattleBtn)
end

function UILWDominatorMainBasicPageComponent:UpdateCityShowBtn()
  local allInfo = DataCenter.DominatorManager:GetAllInfo()
  local count = table.count(allInfo)
  if 1 < count then
    self.btnCityShow:SetActive(true)
    local curShowDominatorId = DataCenter.DominatorManager:GetCityBuildingShowDominatorId()
    local isSelected = self.info ~= nil and self.info.dominatorId == curShowDominatorId
    if isSelected then
      self.imgCityShow:LoadSprite("Assets/Main/Sprites/UI/LWUIDominator/LWUIDominatorMain/wxy_zhuzai_yixuanze.png")
      self.textCityShow:SetLocalText("dominator_change_desc_1")
    else
      self.imgCityShow:LoadSprite("Assets/Main/Sprites/UI/LWUIDominator/LWUIDominatorMain/wxy_zhuzai_weixuanze.png")
      self.textCityShow:SetLocalText("dominator_change_desc_2")
    end
  else
    self.btnCityShow:SetActive(false)
  end
end

function UILWDominatorMainBasicPageComponent:UpdateSwitchContent()
  local allMainIdList = self.view:GetAllMainIdList()
  if allMainIdList then
    for i, v in ipairs(allMainIdList) do
      if self.selectItems[v] == nil and self.selectItemReqs[v] == nil then
        local loadRequest = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWDominator/Main/UILWDominatorMainSelectItem.prefab")
        loadRequest:completed("+", function()
          if not IsNull(loadRequest.gameObject) and self.compDominatorSelectContent then
            local pageObj = loadRequest.gameObject
            pageObj.name = tostring(v)
            local transform = pageObj.transform
            transform:SetParent(self.compDominatorSelectContent.transform)
            local page = self:AddComponent(UILWDominatorMainSelectItemComponent, pageObj)
            page:ReInit(v, i)
            page:UpdateSelect()
            page:UpdateRed()
            page:SetActive(true)
            self.selectItems[v] = page
          end
        end)
        self.selectItemReqs[v] = loadRequest
      else
        self.selectItems[v]:ReInit(v, i)
        self.selectItems[v]:UpdateSelect()
        self.selectItems[v]:UpdateRed()
      end
    end
    local allCount = table.count(allMainIdList)
    local curIndex = self.view:GetCurShowMainIdIndex()
    self.btnLeftSwitch:SetActive(1 < curIndex)
    self.btnRightSwitch:SetActive(allCount > curIndex)
  end
end

function UILWDominatorMainBasicPageComponent:UpdatePower()
  if self.view and self.textPowerNumber then
    local info = self.view:GetCurShowInfo()
    if info then
      self.textPowerNumber:SetText(tostring(info:GetPower()))
    end
  end
end

function UILWDominatorMainBasicPageComponent:UpdateEffect()
  local info = self.view:GetCurShowInfo()
  if not info then
    return
  end
  local atk = math.max(math.floor(info:GetEffect(HeroEffectDefine.DominatorFinalAttack)), 0)
  local defence = math.max(math.floor(info:GetEffect(HeroEffectDefine.DominatorFinalDefence)), 0)
  local hp = math.max(math.floor(info:GetEffect(HeroEffectDefine.DominatorFinalHp)), 0)
  local sdCapacity = math.max(math.floor(info:GetSoldierCapacity()), 0)
  self.textCurAtk:SetText(string.GetFormattedStr(atk))
  self.textCurDef:SetText(string.GetFormattedStr(defence))
  self.textCurHp:SetText(string.GetFormattedStr(hp))
  self.textCurSC:SetText(string.GetFormattedStr(sdCapacity))
end

function UILWDominatorMainBasicPageComponent:UpdateArchiveBtn()
  self.compArchiveRed:SetActive(self.info ~= nil and self.info:HasAnyArchiveCanUnlock())
end

function UILWDominatorMainBasicPageComponent:OnEditName()
  self:UpdateUserName()
end

function UILWDominatorMainBasicPageComponent:OnPlotGroupDone(plotGroupId)
  if plotGroupId ~= DominatorGorillaTreatmentFinishPlotGroupId.Two then
    return
  end
  self.view:SetCurShowPageTag(UILWDominatorMainPageTag.Train)
end

function UILWDominatorMainBasicPageComponent:OnShowMainIdChanged()
  self:UpdateSwitchContent()
end

function UILWDominatorMainBasicPageComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DominatorMainShowMainIdChanged, self.OnShowMainIdChanged)
  self:AddUIListener(EventId.DominatorEditUserNameSuccess, self.OnEditName)
  self:AddUIListener(EventId.PlotGroupDone, self.OnPlotGroupDone)
  self:AddUIListener(EventId.DominatorArchiveUnlockSuccess, self.OnArchiveUnlock)
  self:AddUIListener(EventId.DominatorAppearanceUpdate, self.OnAppearanceUpdate)
end

function UILWDominatorMainBasicPageComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.DominatorMainShowMainIdChanged, self.OnShowMainIdChanged)
  self:RemoveUIListener(EventId.DominatorEditUserNameSuccess, self.OnEditName)
  self:RemoveUIListener(EventId.PlotGroupDone, self.OnPlotGroupDone)
  self:RemoveUIListener(EventId.DominatorArchiveUnlockSuccess, self.OnArchiveUnlock)
  self:RemoveUIListener(EventId.DominatorAppearanceUpdate, self.OnAppearanceUpdate)
  base.OnRemoveListener(self)
end

function UILWDominatorMainBasicPageComponent:OnBtnInfoClick()
  local param = {}
  param.activityRulesStr = Localization:GetString("dominator_overview_desc_5")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function UILWDominatorMainBasicPageComponent:OnBtnPlayClick()
end

function UILWDominatorMainBasicPageComponent:OnBtnShareClick()
end

function UILWDominatorMainBasicPageComponent:OnBtnPropertyClick()
  if self.info then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDominatorPropertyDetail, {anim = true}, self.info, UIHeroPropertyDetailType.Hero)
  end
end

function UILWDominatorMainBasicPageComponent:OnBtnChangeNameClick()
  if self.info then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDominatorEditUserName, {anim = true}, self.info.uuid)
  end
end

function UILWDominatorMainBasicPageComponent:UpdateRankItem(onCount)
  if self.rankItems then
    for i, v in pairs(self.rankItems) do
      if i <= onCount then
        v:SetOn()
      else
        v:SetOff()
      end
    end
  end
end

function UILWDominatorMainBasicPageComponent:ReloadRankItem(totalCount, finishCallback)
  local curCount = 0
  if self.rankItems then
    curCount = table.count(self.rankItems)
  end
  if totalCount > curCount then
    if self.rankItems then
      for _, v in pairs(self.rankItems) do
        v:SetActive(true)
      end
    end
    for i = curCount + 1, totalCount do
      local loadRequest = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWDominator/Main/UILWDominatorMainRankItem.prefab")
      loadRequest:completed("+", function()
        if not IsNull(loadRequest.gameObject) and not IsNull(self.compRankLayout) then
          local pageObj = loadRequest.gameObject
          local transform = pageObj.transform
          transform:SetParent(self.compRankLayout.transform)
          transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          pageObj.name = "rankItem" .. i
          local item = self:AddComponent(UILWDominatorMainRankItemComponent, pageObj)
          item:SetActive(true)
          self.rankItems[i] = item
          if i == totalCount and finishCallback then
            finishCallback()
          end
        end
      end)
      self.rankItemReqs[i] = loadRequest
    end
  else
    if self.rankItems then
      for i = 1, curCount do
        local item = self.rankItems[i]
        if item then
          item:SetActive(i <= totalCount)
        end
      end
    end
    if finishCallback then
      finishCallback()
    end
  end
end

function UILWDominatorMainBasicPageComponent:OnClickSkillItem(skillData, skillItem)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDominatorSkillDetail, {anim = true}, skillData, skillItem)
end

function UILWDominatorMainBasicPageComponent:OnBtnBattleClick()
  if self.mainTemplate then
    local lv_limit = self.mainTemplate.team_limit_level
    local lvTemplate = DataCenter.DominatorTemplateManager:GetTrainLevelTemplateById(lv_limit)
    if lvTemplate then
      local nameStr = lvTemplate:GetName()
      UIUtil.ShowTips(Localization:GetString("dominator_lock_desc_4", nameStr))
    end
  end
end

function UILWDominatorMainBasicPageComponent:OnBtnLeftSwitchClick()
  local curIndex = self.view:GetCurShowMainIdIndex()
  if 1 < curIndex then
    local newIndex = curIndex - 1
    local allMainIdList = self.view:GetAllMainIdList()
    self.view:SetCurShowMainId(allMainIdList[newIndex])
  end
end

function UILWDominatorMainBasicPageComponent:OnBtnRightSwitchClick()
  local curIndex = self.view:GetCurShowMainIdIndex()
  local allMainIdList = self.view:GetAllMainIdList()
  local allCount = 0
  if allMainIdList then
    allCount = table.count(allMainIdList)
  end
  if curIndex < allCount then
    local newIndex = curIndex + 1
    self.view:SetCurShowMainId(allMainIdList[newIndex])
  end
end

function UILWDominatorMainBasicPageComponent:OnBtnAtkInfoClick()
  local info = self.view:GetCurShowInfo()
  if info == nil then
    return
  end
  local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroPropertyDetailTip)
  param.alignObject = self.btnAtkInfo
  param.mainPropName = Localization:GetString(154284)
  param.mainPropValue = math.max(math.floor(info:GetEffect(HeroEffectDefine.DominatorFinalAttack)), 0)
  param.splitProp = {}
  local valDict = info:GetAtkSourceDict()
  table.insert(param.splitProp, {
    name = Localization:GetString("dominator_attr_desc_1"),
    value = valDict.rankVal
  })
  table.insert(param.splitProp, {
    name = Localization:GetString("dominator_attr_desc_3"),
    value = valDict.normalTrainVal
  })
  table.insert(param.splitProp, {
    name = Localization:GetString("dominator_attr_desc_4"),
    value = valDict.mainTrainVal
  })
  table.insert(param.splitProp, {
    name = Localization:GetString("dominator_attr_desc_2"),
    value = valDict.buildVal
  })
  if 0 < valDict.tacticalWeaponVal then
    table.insert(param.splitProp, {
      name = Localization:GetString(110310),
      value = valDict.tacticalWeaponVal
    })
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPropertyDetailTip, {anim = true}, param)
end

function UILWDominatorMainBasicPageComponent:OnBtnHpInfoClick()
  local info = self.view:GetCurShowInfo()
  if info == nil then
    return
  end
  local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroPropertyDetailTip)
  param.alignObject = self.btnHpInfo
  param.mainPropName = Localization:GetString(154286)
  param.mainPropValue = math.max(math.floor(info:GetEffect(HeroEffectDefine.DominatorFinalHp)), 0)
  param.splitProp = {}
  local valDict = info:GetHpSourceDict()
  table.insert(param.splitProp, {
    name = Localization:GetString("dominator_attr_desc_1"),
    value = valDict.rankVal
  })
  table.insert(param.splitProp, {
    name = Localization:GetString("dominator_attr_desc_3"),
    value = valDict.normalTrainVal
  })
  table.insert(param.splitProp, {
    name = Localization:GetString("dominator_attr_desc_4"),
    value = valDict.mainTrainVal
  })
  table.insert(param.splitProp, {
    name = Localization:GetString("dominator_attr_desc_2"),
    value = valDict.buildVal
  })
  if 0 < valDict.tacticalWeaponVal then
    table.insert(param.splitProp, {
      name = Localization:GetString(110310),
      value = valDict.tacticalWeaponVal
    })
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPropertyDetailTip, {anim = true}, param)
end

function UILWDominatorMainBasicPageComponent:OnBtnDefInfoClick()
  local info = self.view:GetCurShowInfo()
  if info == nil then
    return
  end
  local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroPropertyDetailTip)
  param.alignObject = self.btnDefInfo
  param.mainPropName = Localization:GetString(154285)
  param.mainPropValue = math.max(math.floor(info:GetEffect(HeroEffectDefine.DominatorFinalDefence)), 0)
  param.splitProp = {}
  local valDict = info:GetDefSourceDict()
  table.insert(param.splitProp, {
    name = Localization:GetString("dominator_attr_desc_1"),
    value = valDict.rankVal
  })
  table.insert(param.splitProp, {
    name = Localization:GetString("dominator_attr_desc_3"),
    value = valDict.normalTrainVal
  })
  table.insert(param.splitProp, {
    name = Localization:GetString("dominator_attr_desc_4"),
    value = valDict.mainTrainVal
  })
  table.insert(param.splitProp, {
    name = Localization:GetString("dominator_attr_desc_2"),
    value = valDict.buildVal
  })
  if 0 < valDict.tacticalWeaponVal then
    table.insert(param.splitProp, {
      name = Localization:GetString(110310),
      value = valDict.tacticalWeaponVal
    })
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPropertyDetailTip, {anim = true}, param)
end

function UILWDominatorMainBasicPageComponent:OnBtnSdCapacityInfoClick()
  local info = self.view:GetCurShowInfo()
  if info == nil then
    return
  end
  local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroPropertyDetailTip)
  param.alignObject = self.btnSdCapacityInfo
  param.arrowDelta = Vector2.New(CommonUtil.IsArabicAutoMirrorOpen() and -50 or 50, 0)
  param.mainPropName = Localization:GetString(211245)
  param.mainPropValue = math.max(math.floor(info:GetSoldierCapacity()), 0)
  param.splitProp = {}
  local valDict = info:GetSCSourceDict()
  table.insert(param.splitProp, {
    name = Localization:GetString("dominator_attr_desc_4"),
    value = valDict.trainVal
  })
  table.insert(param.splitProp, {
    name = Localization:GetString(110311),
    value = valDict.buildVal
  })
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPropertyDetailTip, {anim = true}, param)
end

function UILWDominatorMainBasicPageComponent:OnBtnArchiveClick()
  if self.info then
    DataCenter.DominatorManager:OpenArchive(self.info)
  end
end

function UILWDominatorMainBasicPageComponent:OnArchiveUnlock()
  self:UpdateArchiveBtn()
end

function UILWDominatorMainBasicPageComponent:OnAppearanceUpdate()
  self:UpdateCityShowBtn()
end

function UILWDominatorMainBasicPageComponent:OnBtnRankPreviewClick()
  self.view:SetCurShowPageTag(UILWDominatorMainPageTag.RankPreview, {
    source = UILWDominatorMainPageTag.Basic
  })
end

function UILWDominatorMainBasicPageComponent:OnBtnCityShowClick()
  if self.info then
    local curSelectCityShowDominatorId = DataCenter.DominatorManager:GetCityBuildingShowDominatorId()
    if self.info.dominatorId ~= curSelectCityShowDominatorId then
      UIUtil.ShowMessage(Localization:GetString("dominator_change_desc_4"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        if self.info then
          DataCenter.DominatorManager:SendChangeCityBuildingShowMessage(self.info.dominatorId)
        end
      end)
    else
      UIUtil.ShowTips(Localization:GetString("dominator_change_desc_3"))
      return
    end
  end
end

return UILWDominatorMainBasicPageComponent
