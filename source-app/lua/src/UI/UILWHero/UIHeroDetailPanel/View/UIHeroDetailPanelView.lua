local UIHeroDetailPanelView = BaseClass("UIHeroDetailPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local ResourceManager = CS.GameEntry.Resource
local UIHeroDetailPageToggleNew = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroDetailPageToggleNew")
local UIHeroGrowthPage = "UI.UILWHero.UIHeroDetailPanel.Component.UIHeroGrowthPage"
local UIHeroSkillPage = "UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillPage"
local UIHeroRankPage = "UI.UILWHero.UIHeroDetailPanel.Component.UIHeroRankPage"
local UIHeroUniqueWeaponPage = "UI.UILWHero.UIHeroDetailPanel.Component.HeroUniqueWeaponPage"
local UIHeroAwakenPage = "UI/UILWHero/UIHeroDetailPanel/Component/HeroAwaken/HeroAwakenRootPageComponent"
local heroGrowthPagePath = "Root/HeroGrowthPage"
local heroSkillPagePath = "Root/HeroSkillPage"
local heroRankPagePath = "Root/HeroRankPage"
local heroUniqueWeaponPagePath = "Root/HeroUniqueWeaponPage"
local heroAwakenPagePath = "Root/HeroAwakenPage"
local heroGrowthTogglePath = "Root/BottomToggles/Toggles/GrowthToggle"
local heroSkillTogglePath = "Root/BottomToggles/Toggles/SkillToggle"
local heroRankTogglePath = "Root/BottomToggles/Toggles/RankToggle"
local heroUniqueWeaponTogglePath = "Root/BottomToggles/Toggles/UniqueWeaponToggle"
local heroAwakenTogglePath = "Root/BottomToggles/Toggles/AwakenToggle"
local changeHeroArrowContainerPath = "Root/ChangeHeroArrow"
local prevHeroBtnPath = "Root/ChangeHeroArrow/ToPrevHeroArrow"
local nextHeroBtnPath = "Root/ChangeHeroArrow/ToNextHeroArrow"
local heroDragAreaPath = "Root/DragHeroArea"
local bgPath = "Bg"
local heroImgPath = "Root/HeroImg"
local rootPath = "Root"
local bottomTogglesPath = "Root/BottomToggles"
local btnBackPath = "Root/BtnBack"
local ResGroupManager = CS.DownloadResGroupCommonManager.Instance
local PAGES_CONFIG = {
  [HeroDetailPageType.HeroGrowth] = {path = heroGrowthPagePath, clsPath = UIHeroGrowthPage},
  [HeroDetailPageType.HeroSkill] = {path = heroSkillPagePath, clsPath = UIHeroSkillPage},
  [HeroDetailPageType.HeroRank] = {
    path = heroRankPagePath,
    clsPath = UIHeroRankPage,
    prefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/HeroDetailPages/HeroRankPage.prefab"
  },
  [HeroDetailPageType.HeroUniqueWeapon] = {
    path = heroUniqueWeaponPagePath,
    clsPath = UIHeroUniqueWeaponPage,
    prefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/HeroDetailPages/HeroUniqueWeaponPage.prefab"
  },
  [HeroDetailPageType.HeroAwaken] = {
    path = heroAwakenPagePath,
    clsPath = UIHeroAwakenPage,
    prefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/HeroAwaken/LWHeroAwakenMain/HeroAwakenRootPage.prefab"
  }
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.curHeroUuid, self.heroUuidList, self.callBack, self.guideArrowData = self:GetUserData()
  self.ctrl:SetClsoeCallBack(self.callBack)
  self:OnOpen()
end

local function OnDestroy(self)
  DataCenter.HeroDataManager:SetShowHeroUuidCache(nil)
  DataCenter.ArrowManager:RemoveArrow()
  if self.heroSpineLoadRequest ~= nil then
    self.heroSpineLoadRequest:Destroy()
    self.heroSpineLoadRequest = nil
  end
  self:ComponentDestroy()
  self:DataDestroy()
  self:ClearSound()
  base.OnDestroy(self)
end

local function RefreshHeroData(self)
  if not self.curHeroUuid then
    return false
  end
  DataCenter.HeroDataManager:SetShowHeroUuidCache(self.curHeroUuid)
  self.heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.curHeroUuid)
  if self.heroData == nil then
    local itemTemplateData = DataCenter.ItemTemplateManager:GetItemTemplate(self.curHeroUuid)
    if itemTemplateData ~= nil then
      if self.heroTemplateData == nil then
        self.heroTemplateData = HeroInfo.New()
      end
      local maxLvWithScienceLimit = HeroUtils.GetMaxLevelWithScienceLimit()
      self.heroTemplateData:UpdateFromTemplate(tonumber(itemTemplateData.para2), maxLvWithScienceLimit, IntMaxValue, IntMaxValue)
      self.heroData = self.heroTemplateData
      self.isTemplateHero = true
    else
      local heroTemp = DataCenter.HeroTemplateManager:GetTemplate(self.curHeroUuid)
      if heroTemp then
        if self.heroTemplateData == nil then
          self.heroTemplateData = HeroInfo.New()
        end
        local maxLvWithScienceLimit = HeroUtils.GetMaxLevelWithScienceLimit()
        self.heroTemplateData:UpdateFromTemplate(tonumber(self.curHeroUuid), maxLvWithScienceLimit, IntMaxValue, IntMaxValue)
        self.heroData = self.heroTemplateData
        self.isTemplateHero = true
      else
        self:OnBtnCloseClick()
        return false
      end
    end
  else
    self.isTemplateHero = false
  end
  if not self.heroUuidList then
    return
  end
  self.curHeroIndex = table.indexof(self.heroUuidList, self.curHeroUuid)
  local toggleHeroData = not self.isTemplateHero and self.heroData or nil
  for i = 1, #self.toggles do
    if self.toggles[i] then
      self.toggles[i]:SetData(toggleHeroData)
    end
  end
end

local function ResetSpineTransform(self, obj)
  if not obj then
    return
  end
  if not self.curPageType then
    return
  end
  local curPage = self:GetPageComponent(self.curPageType)
  if not curPage then
    return
  end
  local parent = curPage:GetHeroSpineContainer()
  if not parent then
    obj:SetActive(false)
    return
  end
  obj:SetActive(true)
  local rectTransform = obj:GetComponent(typeof(CS.UnityEngine.RectTransform))
  if rectTransform ~= nil then
    rectTransform:SetParent(parent.transform)
    rectTransform:Set_localScale(1, 1, 1)
    rectTransform:Set_anchoredPosition(0, 0, 0)
  end
end

function UIHeroDetailPanelView:ReloadHeroSpine()
  if not self.heroData then
    return
  end
  local spineType = HeroSpineType.Normal
  local curPage = self:GetPageComponent(self.curPageType)
  if curPage and curPage.GetSpineType then
    spineType = curPage:GetSpineType()
  end
  local spinePath = HeroUtils.GetHeroSpinePath(self.heroData.modelId, self.heroData:GetSkinId(), spineType)
  if self.lastSpinePath ~= spinePath then
    if self.heroSpineLoadRequest ~= nil then
      self.heroSpineLoadRequest:Destroy()
      self.heroSpineLoadRequest = nil
    end
    self.lastSpinePath = spinePath
    if string.IsNullOrEmpty(spinePath) then
      return
    end
    local request = ResourceManager:InstantiateAsync(spinePath)
    self.heroSpineLoadRequest = request
    request:completed("+", function()
      if request.isError or request.gameObject == nil then
        self.heroSpineLoadRequest = nil
        return
      end
      ResetSpineTransform(self, request.gameObject)
    end)
    local meta = self.heroData.meta
    if meta then
      local soundAsset = meta.sound_talk:GetRandom()
      if not string.IsNullOrEmpty(soundAsset) then
        if self.soundHandle then
          DataCenter.LWSoundManager:FadeOutAndPlayMusic(self.soundHandle, 0.1)
        end
        self.soundHandle = DataCenter.LWSoundManager:PlayHeroSound(soundAsset)
      end
    else
      self:ClearSound()
    end
  elseif self.heroSpineLoadRequest then
    ResetSpineTransform(self, self.heroSpineLoadRequest.gameObject)
  end
end

function UIHeroDetailPanelView:GetPageComponent(pageType)
  if not self.simplePages[pageType] then
    return
  end
  if self.pages[pageType] then
    return self.pages[pageType]
  end
  local pageConfig = PAGES_CONFIG[pageType]
  if not pageConfig then
    return nil
  end
  if pageConfig.prefabPath then
    return nil
  end
  local cls = require(pageConfig.clsPath)
  local page = self.simplePages[pageType]:AddComponent(cls, "")
  self.pages[pageType] = page
  return page
end

local function GoToPage(self, pageType, param, isFromCreate)
  if self.curPageType == pageType then
    return
  end
  if pageType == HeroDetailPageType.HeroUniqueWeapon and not self:CheckUniqueWeaponResDownload() then
    UIUtil.ShowTipsId("pack_downloading_tips")
    return
  end
  if param == nil then
    param = self.pageParam
  end
  local useAnim = false
  local delayChangeSpine = false
  if self.curPageType == HeroDetailPageType.HeroGrowth and pageType == HeroDetailPageType.HeroSkill then
    self.anim:Play(CommonUtil.IsArabicAutoMirrorOpen() and "Eff_ui_xiangqing_UIHeroDetailPanel_chuxian_arabic" or "Eff_ui_xiangqing_UIHeroDetailPanel_chuxian", 0, 0)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_Hero_Page_Skill, false)
    useAnim = true
    delayChangeSpine = true
  elseif self.curPageType == HeroDetailPageType.HeroSkill and pageType == HeroDetailPageType.HeroGrowth then
    self.anim:Play(CommonUtil.IsArabicAutoMirrorOpen() and "Eff_ui_xiangqing_UIHeroDetailPanel_xiaoshi_arabic" or "Eff_ui_xiangqing_UIHeroDetailPanel_xiaoshi", 0, 0)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_Hero_Page_Element, false)
    useAnim = true
  else
    self.anim:Play(CommonUtil.IsArabicAutoMirrorOpen() and "NoneStateArabic" or "NoneState", 0, 0)
  end
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_Hero_Page_Click, false)
  self.skillCanvasGroup:SetBlocksRaycasts(pageType == HeroDetailPageType.HeroSkill)
  self.growthCanvasGroup:SetBlocksRaycasts(pageType == HeroDetailPageType.HeroGrowth)
  for i = 1, #self.toggles do
    local t = self.toggles[i]
    if t then
      if t:GetType() == pageType then
        if self.simplePages and self.simplePages[pageType] then
          self.simplePages[pageType]:SetActive(true)
        end
        t:SetSelected(true)
      else
        local tp = t:GetType()
        if self.simplePages and self.simplePages[tp] and not useAnim then
          self.simplePages[tp]:SetActive(false)
        end
        t:SetSelected(false)
      end
    end
  end
  self.curPageType = pageType
  if self.curPageType == HeroDetailPageType.HeroRank then
    self:CheckArrowBtns()
    self.bg:LoadSprite("Assets/Main/TextureEx/UIHeroDetail/cfm_yingxiong_beijing.png")
  elseif self.curPageType == HeroDetailPageType.HeroSkill then
    self:CheckArrowBtns()
    self.heroData:MarkSkillPageRedPoint()
    self.bg:LoadSprite("Assets/Main/TextureEx/UIHeroDetail/cfm_yingxiong_beijing_2.png")
  elseif self.curPageType == HeroDetailPageType.HeroGrowth then
    self:CheckArrowBtns()
    self.bg:LoadSprite("Assets/Main/TextureEx/UIHeroDetail/cfm_yingxiong_beijing_1.png")
  elseif self.curPageType == HeroDetailPageType.HeroUniqueWeapon then
    self:CheckArrowBtns()
    self.bg:LoadSprite("Assets/Main/TextureEx/UIHeroDetail/cfm_yingxiong_beijing_2.png")
  elseif self.curPageType == HeroDetailPageType.HeroAwaken then
    self:CheckArrowBtns()
    self.bg:LoadSprite("Assets/Main/TextureEx/UIHeroDetail/cfm_yingxiong_beijing_2.png")
  end
  if not isFromCreate then
    self:RefreshPage()
  end
  self:RefreshHeroArrowPosition()
end

function UIHeroDetailPanelView:RefreshHeroArrowPosition()
  if self.curPageType == HeroDetailPageType.HeroRank then
    self.changeHeroArrowContainer:SetAnchoredPositionXY(0, -298)
  elseif self.curPageType == HeroDetailPageType.HeroSkill then
    self.changeHeroArrowContainer:SetAnchoredPositionXY(0, -190)
  elseif self.curPageType == HeroDetailPageType.HeroGrowth then
    self.changeHeroArrowContainer:SetAnchoredPositionXY(0, -254)
  elseif self.curPageType == HeroDetailPageType.HeroUniqueWeapon then
    self.changeHeroArrowContainer:SetAnchoredPositionXY(0, -85)
  elseif self.curPageType == HeroDetailPageType.HeroAwaken then
    local isAwakened = self.heroData ~= nil and self.heroData:IsHeroAwakened()
    if isAwakened then
      self.changeHeroArrowContainer:SetAnchoredPositionXY(0, -128)
    else
      self.changeHeroArrowContainer:SetAnchoredPositionXY(0, 12)
    end
  end
end

function UIHeroDetailPanelView:CheckUniqueWeaponResDownload()
  local heroId = self.heroData.heroId
  local packConfigId = LocalController:instance():getValue("lw_hero", heroId, "download_packs_id")
  if not packConfigId or packConfigId <= 0 then
    return true
  end
  local isDownloadPackage = ResGroupManager:IsDownload(packConfigId)
  if not isDownloadPackage then
    ResGroupManager:StartDownload(packConfigId)
    return false
  end
  return true
end

local function OnBeginDrag(self, eventData)
  self.lastDragPosX = eventData.position.x
end

local function OnEndDrag(self, eventData)
  if self.curPageType == nil then
    return
  end
  if not self.lastDragPosX then
    return
  end
  local curDragPosX = eventData.position.x
  local offset = curDragPosX - self.lastDragPosX
  if offset < -15 then
    self:OnArrowBtnClick(false)
  elseif 15 < offset then
    self:OnArrowBtnClick(true)
  end
end

local function ComponentDefine(self)
  self.btnClose = self:AddComponent(UIButton, "Root/BtnBack")
  self.btnClose:SetOnClick(BindCallback(self, self.OnBtnCloseClick))
  self.btnClose:SetActive(true)
  self.anim = self:AddComponent(UIAnimator, "")
  self.heroGrowthToggle = self:AddComponent(UIHeroDetailPageToggleNew, heroGrowthTogglePath)
  self.heroGrowthToggle:SetType(HeroDetailPageType.HeroGrowth)
  self.heroSkillToggle = self:AddComponent(UIHeroDetailPageToggleNew, heroSkillTogglePath)
  self.heroSkillToggle:SetType(HeroDetailPageType.HeroSkill)
  self.heroRankToggle = self:AddComponent(UIHeroDetailPageToggleNew, heroRankTogglePath)
  self.heroRankToggle:SetType(HeroDetailPageType.HeroRank)
  self.heroUniqueWeaponToggle = self:AddComponent(UIHeroDetailPageToggleNew, heroUniqueWeaponTogglePath)
  self.heroUniqueWeaponToggle:SetType(HeroDetailPageType.HeroUniqueWeapon)
  self.heroAwakenToggle = self:AddComponent(UIHeroDetailPageToggleNew, heroAwakenTogglePath)
  self.heroAwakenToggle:SetType(HeroDetailPageType.HeroAwaken)
  self.toggles = {
    self.heroGrowthToggle,
    self.heroSkillToggle,
    self.heroRankToggle,
    self.heroUniqueWeaponToggle,
    self.heroAwakenToggle
  }
  self.growthCanvasGroup = self:AddComponent(UICanvasGroup, heroGrowthPagePath)
  self.skillCanvasGroup = self:AddComponent(UICanvasGroup, heroSkillPagePath)
  self.simplePages = {
    [HeroDetailPageType.HeroGrowth] = self:AddComponent(UIBaseContainer, heroGrowthPagePath),
    [HeroDetailPageType.HeroSkill] = self:AddComponent(UIBaseContainer, heroSkillPagePath),
    [HeroDetailPageType.HeroRank] = self:AddComponent(UIBaseContainer, heroRankPagePath),
    [HeroDetailPageType.HeroUniqueWeapon] = self:AddComponent(UIBaseContainer, heroUniqueWeaponPagePath),
    [HeroDetailPageType.HeroAwaken] = self:AddComponent(UIBaseContainer, heroAwakenPagePath)
  }
  self.pages = {}
  self.changeHeroArrowContainer = self:AddComponent(UIBaseContainer, changeHeroArrowContainerPath)
  self.prevHeroBtn = self:AddComponent(UIButton, prevHeroBtnPath)
  self.prevHeroBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_Hero_SwitchHero_01, false)
    self:OnArrowBtnClick(true)
  end)
  self.nextHeroBtn = self:AddComponent(UIButton, nextHeroBtnPath)
  self.nextHeroBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_Hero_SwitchHero_02, false)
    self:OnArrowBtnClick(false)
  end)
  self.heroDragArea = self:AddComponent(UIEventTrigger, heroDragAreaPath)
  self.heroDragArea:OnBeginDrag(function(eventData)
    OnBeginDrag(self, eventData)
  end)
  self.heroDragArea:OnEndDrag(function(eventData)
    OnEndDrag(self, eventData)
  end)
  self.bg = self:AddComponent(UIRawImage, bgPath)
  self.root = self:AddComponent(UIBaseContainer, rootPath)
  self.bottomToggles = self:AddComponent(UIBaseContainer, bottomTogglesPath)
  self.btnBack = self:AddComponent(UIBaseContainer, btnBackPath)
end

local function DataDefine(self)
  self.pageReqs = {}
  self.heroTemplateData = nil
  self.heroData = nil
end

local function ComponentDestroy(self)
  self.btnClose = nil
  self.heroGrowthToggle = nil
  self.heroGrowthToggleSelectedBg = nil
  self.heroGrowthToggleRedPoint = nil
  self.heroSkillToggle = nil
  self.heroSkillToggleSelectedBg = nil
  self.heroSkillToggleRedPoint = nil
  self.heroRankToggle = nil
  self.heroRankToggleRedPoint = nil
  self.toggles = nil
  self.pages = nil
  self.simplePages = nil
  self.changeHeroArrowContainer = nil
  self.prevHeroBtn = nil
  self.nextHeroBtn = nil
  self.heroDragArea = nil
  self.bg = nil
  self.bottomToggles = nil
  self.btnBack = nil
  self.pageReqs = nil
end

local function DataDestroy(self)
  self.heroData = nil
  self.heroTemplateData = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.anim:Play(CommonUtil.IsArabicAutoMirrorOpen() and "NoneStateArabic" or "NoneState", 0, 0)
  self.active = true
  if self.heroData and self.curPageType then
    for i, v in pairs(self.simplePages) do
      if v then
        v:SetActive(self.curPageType == i)
      end
    end
    self:RefreshPage()
  end
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function OnFinishHandleInitMsg(self)
  if not self.isTemplateHero and self.heroData then
    self.heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroData.uuid)
    self:RefreshPage()
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.EquipDetailChangePage, self.OnEquipDetialChangePage)
  self:AddUIListener(EventId.OnFinishHandleInitMsg, OnFinishHandleInitMsg)
  self:AddUIListener(EventId.HeroDetailPanelReloadHeroSpine, self.ReloadHeroSpine)
  self:AddUIListener(EventId.HeroDetailPanelRefreshArrowPosition, self.RefreshHeroArrowPosition)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.EquipDetailChangePage, self.OnEquipDetialChangePage)
  self:RemoveUIListener(EventId.OnFinishHandleInitMsg, OnFinishHandleInitMsg)
  self:RemoveUIListener(EventId.HeroDetailPanelReloadHeroSpine, self.ReloadHeroSpine)
  self:RemoveUIListener(EventId.HeroDetailPanelRefreshArrowPosition, self.RefreshHeroArrowPosition)
end

local function GetCanShowPages(self)
  if not self.pageShwoMap then
    self.pageShwoMap = {}
    for i = 1, #self.toggles do
      self.pageShwoMap[self.toggles[i]:GetType()] = true
    end
  end
  if self.isTemplateHero then
    self.pageShwoMap[HeroDetailPageType.HeroRank] = false
    self.pageShwoMap[HeroDetailPageType.HeroUniqueWeapon] = false
    self.pageShwoMap[HeroDetailPageType.HeroAwaken] = false
  else
    local showHeroAwaken = self.heroData:IsHeroAwakenOpen()
    self.pageShwoMap[HeroDetailPageType.HeroRank] = not showHeroAwaken
    self.pageShwoMap[HeroDetailPageType.HeroAwaken] = showHeroAwaken
    local canShow = self.heroData:IsUniqueWeaponShow()
    self.pageShwoMap[HeroDetailPageType.HeroUniqueWeapon] = canShow
  end
end

local function CheckToggles(self)
  GetCanShowPages(self)
  for i = 1, #self.toggles do
    if self.toggles[i] then
      self.toggles[i]:SetActive(self.pageShwoMap[self.toggles[i]:GetType()])
    end
  end
end

local function CheckTogglesAndFallback(self)
  CheckToggles(self)
  if not self.pageShwoMap[self.curPageType] then
    GoToPage(self, HeroDetailPageType.HeroGrowth)
    return true
  end
  return false
end

local function LoadDynamicPage(self, pageType, onLoadComplete)
  local pageConfig = PAGES_CONFIG[pageType]
  if not pageConfig or not pageConfig.prefabPath then
    return
  end
  if self.pages[pageType] or self.pageReqs[pageType] then
    return
  end
  local prefabPath = pageConfig.prefabPath
  local cls = require(pageConfig.clsPath)
  local container = self.simplePages[pageType]
  self.pageReqs[pageType] = self:GameObjectInstantiateAsync(prefabPath, function(req)
    if self.pageReqs then
      self.pageReqs[pageType] = nil
    end
    if not req or req.isError or IsNull(req.gameObject) then
      return
    end
    local obj = req.gameObject
    local t = obj.transform
    local rectTransform = obj:GetComponent(typeof(CS.UnityEngine.RectTransform))
    t:SetParent(container.transform)
    obj:SetActive(true)
    rectTransform:Set_offsetMax(0, 0)
    rectTransform:Set_offsetMin(0, 0)
    rectTransform:Set_anchorMin(0, 0)
    rectTransform:Set_anchorMax(1, 1)
    rectTransform:Set_localScale(1, 1, 1)
    rectTransform:Set_localPosition(0, 0, 0)
    if pageType == HeroDetailPageType.HeroUniqueWeapon then
      CS.UnityEngine.Canvas.ForceUpdateCanvases()
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.root.transform)
    end
    local container = self.simplePages[pageType]
    if not container then
      return nil
    end
    local page = container:AddComponent(cls, obj)
    self.pages[pageType] = page
    if onLoadComplete then
      onLoadComplete(page)
    end
  end)
end

local function GetPageParams(self, pageType)
  if pageType == HeroDetailPageType.HeroUniqueWeapon then
    return {
      self.bottomToggles,
      self.btnBack,
      self.changeHeroArrowContainer
    }
  end
end

local function UpdatePageDisplay(self, pageType, page)
  if not page or pageType ~= self.curPageType then
    return
  end
  local pageParams = GetPageParams(self, pageType)
  page:SetData(self.heroData, pageParams)
  self:ReloadHeroSpine()
end

local function OnOpen(self)
  self.curHeroIndex = table.indexof(self.heroUuidList, self.curHeroUuid)
  if RefreshHeroData(self) == false then
    return
  end
  self:CheckArrowBtns()
  CheckToggles(self)
  if self.guideArrowData then
    self:ShowGuideArrow(self.guideArrowData)
  else
    GoToPage(self, HeroDetailPageType.HeroGrowth, nil, true)
  end
  LoadDynamicPage(self, HeroDetailPageType.HeroRank, function(page)
    UpdatePageDisplay(self, HeroDetailPageType.HeroRank, page)
  end)
  LoadDynamicPage(self, HeroDetailPageType.HeroUniqueWeapon, function(page)
    UpdatePageDisplay(self, HeroDetailPageType.HeroUniqueWeapon, page)
  end)
  local heroAwakenFunctionOn = DataCenter.HeroAwakenDataManager:IsHeroAwakenFunctionOn()
  if heroAwakenFunctionOn then
    LoadDynamicPage(self, HeroDetailPageType.HeroAwaken, function(page)
      UpdatePageDisplay(self, HeroDetailPageType.HeroAwaken, page)
    end)
  end
  DataCenter.HeroTryOutManager:TrySendGetHeroTryOutInfoMessage()
end

local function ShowGuideArrow(self, data)
  if data.arrowType == HeroDetailGuideArrowType.Upgrade then
    if self.curPageType ~= HeroDetailPageType.HeroGrowth then
      GoToPage(self, HeroDetailPageType.HeroGrowth)
    end
  elseif data.arrowType == HeroDetailGuideArrowType.Equip then
    if self.curPageType ~= HeroDetailPageType.HeroGrowth then
      GoToPage(self, HeroDetailPageType.HeroGrowth)
    end
  elseif data.arrowType == HeroDetailGuideArrowType.Skill then
    if self.curPageType ~= HeroDetailPageType.HeroSkill then
      GoToPage(self, HeroDetailPageType.HeroSkill)
    end
  elseif data.arrowType == HeroDetailGuideArrowType.Rank then
    if self.curPageType ~= HeroDetailPageType.HeroRank then
      GoToPage(self, HeroDetailPageType.HeroRank)
    end
  elseif data.arrowType == HeroDetailGuideArrowType.SkillPreview then
    if self.curPageType ~= HeroDetailPageType.HeroSkill then
      GoToPage(self, HeroDetailPageType.HeroSkill, 2)
    end
    local heroSkillPage = self:GetPageComponent(HeroDetailPageType.HeroSkill)
    heroSkillPage:ShowPreviewSkillWindow()
  elseif data.arrowType == HeroDetailGuideArrowType.UniqueWeapon then
    if self.pageShwoMap[HeroDetailPageType.HeroUniqueWeapon] and self.curPageType ~= HeroDetailPageType.HeroUniqueWeapon then
      GoToPage(self, HeroDetailPageType.HeroUniqueWeapon)
    else
      GoToPage(self, HeroDetailPageType.HeroGrowth)
    end
  elseif data.arrowType == HeroDetailGuideArrowType.HeroAwaken then
    if self.pageShwoMap[HeroDetailPageType.HeroAwaken] and self.curPageType ~= HeroDetailPageType.HeroAwaken then
      GoToPage(self, HeroDetailPageType.HeroAwaken)
    else
      GoToPage(self, HeroDetailPageType.HeroGrowth)
    end
  end
end

local function RefreshPage(self)
  if not self.curPageType then
    return
  end
  local pageType = self.curPageType
  local existPage = self.pages and self.pages[pageType] or nil
  if existPage then
    UpdatePageDisplay(self, pageType, existPage)
    return
  end
  local pageConfig = PAGES_CONFIG[pageType]
  if pageConfig and pageConfig.prefabPath then
    if self.pageReqs and self.pageReqs[pageType] then
      return
    end
    LoadDynamicPage(self, pageType, function(page)
      UpdatePageDisplay(self, pageType, page)
    end)
    return
  end
  local page = self:GetPageComponent(pageType)
  UpdatePageDisplay(self, pageType, page)
end

local function CanSwithToNotHaveHero(self, index)
  if self.curPageType == HeroDetailPageType.HeroRank or self.curPageType == HeroDetailPageType.HeroUniqueWeapon or self.curPageType == HeroDetailPageType.HeroAwaken then
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuidList[index])
    if heroData == nil then
      return false
    elseif self.curPageType == HeroDetailPageType.HeroUniqueWeapon then
      local canShow = heroData:IsUniqueWeaponShow()
      if not canShow then
        return false
      end
    elseif self.curPageType == HeroDetailPageType.HeroAwaken then
      local canShow = DataCenter.HeroAwakenDataManager:IsHeroAwakenOpenByHeroInfo(heroData)
      if not canShow then
        return false
      end
    end
  end
  return true
end

local function CheckArrowBtns(self)
  local index = self.curHeroIndex
  local hasLeft = false
  local hasRight = false
  hasLeft = self.heroUuidList[index - 1] ~= nil
  hasRight = self.heroUuidList[index + 1] ~= nil
  if hasLeft and not CanSwithToNotHaveHero(self, index - 1) then
    hasLeft = false
  end
  if hasRight and not CanSwithToNotHaveHero(self, index + 1) then
    hasRight = false
  end
  self.prevHeroBtn:SetActive(hasLeft)
  self.nextHeroBtn:SetActive(hasRight)
end

local function OnArrowBtnClick(self, isLeft)
  if self.curHeroIndex <= 1 and isLeft then
    return
  end
  if self.curHeroIndex >= #self.heroUuidList and not isLeft then
    return
  end
  if isLeft and not CanSwithToNotHaveHero(self, self.curHeroIndex - 1) then
    return
  end
  if not isLeft and not CanSwithToNotHaveHero(self, self.curHeroIndex + 1) then
    return
  end
  local index = self.curHeroIndex + (isLeft and -1 or 1)
  local heroUuid = self.heroUuidList[index]
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
  if heroData ~= nil then
    DataCenter.HeroDataManager:RemoveNewHeroTag(heroUuid)
  end
  self.curHeroUuid = heroUuid
  self.curHeroIndex = index
  if RefreshHeroData(self) == false then
    return
  end
  if not CheckTogglesAndFallback(self) then
    RefreshPage(self)
  end
  CheckArrowBtns(self)
end

local function OnBtnCloseClick(self)
  self.ctrl:CloseSelf()
end

local function IsTemplateHero(self)
  return self.isTemplateHero
end

local function GotoHeroGrowthPage(self)
  GoToPage(self, HeroDetailPageType.HeroGrowth)
end

local function GotoHeroRankPage(self)
  GoToPage(self, HeroDetailPageType.HeroRank)
end

function UIHeroDetailPanelView:GotoHeroAwakenPage()
  GoToPage(self, HeroDetailPageType.HeroAwaken)
end

local function GetSkillPageTogglePosition(self)
  if self.heroSkillToggle then
    return self.heroSkillToggle.transform.position
  end
end

local function ShowSkillToggleRedPoint(self)
  if self.toggles[HeroDetailPageType.HeroSkill] then
    self.toggles[HeroDetailPageType.HeroSkill]:SetShowRedPoint(true)
  end
end

local function HideSkillToggleRedPoint(self)
  if self.toggles[HeroDetailPageType.HeroSkill] then
    self.toggles[HeroDetailPageType.HeroSkill]:SetShowRedPoint(false)
  end
end

local function GetHeroUuidsList(self)
  return self.heroUuidList
end

local function OnEquipDetialChangePage(self, equipUuid)
  if not equipUuid then
    return
  end
  local euqipData = DataCenter.EquipDataManager:GetEquipByUuid(equipUuid)
  if not euqipData then
    return
  end
  local heroUuid = euqipData.heroUuid
  if not heroUuid then
    return
  end
  if heroUuid == self.curHeroUuid then
    return
  end
  local index
  for i = 1, #self.heroUuidList do
    if self.heroUuidList[i] == heroUuid then
      index = i
      break
    end
  end
  if index == nil then
    return
  end
  self.curHeroUuid = heroUuid
  self.curHeroIndex = index
  if RefreshHeroData(self) == false then
    return
  end
  if not CheckTogglesAndFallback(self) then
    RefreshPage(self)
  end
  CheckArrowBtns(self)
end

local function ClearSound(self)
  if self.soundHandle then
    DataCenter.LWSoundManager:StopSound(self.soundHandle)
    self.soundHandle = nil
  end
end

local function RefreshSkillToggleRedPoint(self)
  if self.toggles[HeroDetailPageType.HeroSkill] then
    self.toggles[HeroDetailPageType.HeroSkill]:RefershRedPoint()
  end
end

UIHeroDetailPanelView.OnCreate = OnCreate
UIHeroDetailPanelView.OnDestroy = OnDestroy
UIHeroDetailPanelView.OnEnable = OnEnable
UIHeroDetailPanelView.OnDisable = OnDisable
UIHeroDetailPanelView.OnAddListener = OnAddListener
UIHeroDetailPanelView.OnRemoveListener = OnRemoveListener
UIHeroDetailPanelView.ComponentDefine = ComponentDefine
UIHeroDetailPanelView.DataDefine = DataDefine
UIHeroDetailPanelView.ComponentDestroy = ComponentDestroy
UIHeroDetailPanelView.DataDestroy = DataDestroy
UIHeroDetailPanelView.OnOpen = OnOpen
UIHeroDetailPanelView.OnBtnCloseClick = OnBtnCloseClick
UIHeroDetailPanelView.CheckArrowBtns = CheckArrowBtns
UIHeroDetailPanelView.OnArrowBtnClick = OnArrowBtnClick
UIHeroDetailPanelView.RefreshPage = RefreshPage
UIHeroDetailPanelView.GoToPage = GoToPage
UIHeroDetailPanelView.IsTemplateHero = IsTemplateHero
UIHeroDetailPanelView.GotoHeroGrowthPage = GotoHeroGrowthPage
UIHeroDetailPanelView.GotoHeroRankPage = GotoHeroRankPage
UIHeroDetailPanelView.ShowGuideArrow = ShowGuideArrow
UIHeroDetailPanelView.GetSkillPageTogglePosition = GetSkillPageTogglePosition
UIHeroDetailPanelView.ShowSkillToggleRedPoint = ShowSkillToggleRedPoint
UIHeroDetailPanelView.HideSkillToggleRedPoint = HideSkillToggleRedPoint
UIHeroDetailPanelView.GetHeroUuidsList = GetHeroUuidsList
UIHeroDetailPanelView.OnEquipDetialChangePage = OnEquipDetialChangePage
UIHeroDetailPanelView.ClearSound = ClearSound
UIHeroDetailPanelView.RefreshSkillToggleRedPoint = RefreshSkillToggleRedPoint
return UIHeroDetailPanelView
