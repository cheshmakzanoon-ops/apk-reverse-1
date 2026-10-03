local base = UIBaseView
local UIDailyPackageSelectWindowView = BaseClass("UIDailyPackageSelectWindowView", base)
local Localization = CS.GameEntry.Localization
local HeroItem = require("UI.UIDailyPackageSelectWindow.Component.HeroItem")
local UIGray = CS.UIGray
local ResourceManager = CS.GameEntry.Resource
local UICommonTab = require("UI.UICommonTab.UICommonTab")
local closePanel_btn_path = "Panel"
local back_btn_path = "Root/BackBtn"
local tip_text_path = "Root/TipText"
local heroName_text_path = "Root/HeroNameText"
local heroType_icon_path = "Root/HeroTypeIcon"
local heroJob_icon_path = "Root/HeroJobIcon"
local detail_btn_path = "Root/DetailBtn"
local choose_btn_path = "Root/ChooseBtn"
local choose_btn_text_path = "Root/ChooseBtn/ChooseBtnText"
local hero_scroll_path = "Root/HeroScroll"
local hero_scrollContent_path = "Root/HeroScroll/Viewport/mask/Content"
local hero_scroll_viewport_path = "Root/HeroScroll/Viewport"
local hero_scroll_leftPointer_path = "Root/LeftPointer"
local hero_scroll_rightPointer_path = "Root/RightPointer"
local hero_tab_path = "Root/Tab_content/heroTab"
local unique_weapon_tab_path = "Root/Tab_content/uniqueWeaponTab"
local main_tip_text_path = "Root/mainTipText"
local goto_btn_path = "Root/gotoBtn"
local hero_bg_path = "heroBgRoot"
local goto_btn_text_path = "Root/gotoBtn/gotoBtnText"
local hero_spine_container_path = "heroBgRoot/HeroSpineViewport/HeroSpineContainer"
local unique_weapon_spine_container_path = "Mask_Arrow/uniqueWeaponBg/Chr/HeroSpineViewport/UniqueWeaponSpineContainer"
local awaken_spine_node_path = "Mask_Arrow_juexing/uniqueWeaponBg/Chr/awakenSpineViewport/awakenSpineNode"
local unique_weapon_icon_path = "Mask_Arrow/uniqueWeaponBg/Chr/uniqueWeaponIcon"
local AnimationShowName = {
  [DailyPackageType.Hero * 10 + DailyPackageType.HeroUniqueWeapon] = "V_ui_DailyPackageSelectWindow_HeroToUW",
  [DailyPackageType.Hero * 10 + DailyPackageType.HeroAwaken] = "V_ui_DailyPackageSelectWindow_HeroToAwake",
  [DailyPackageType.HeroUniqueWeapon * 10 + DailyPackageType.Hero] = "V_ui_DailyPackageSelectWindow_UWToHero",
  [DailyPackageType.HeroUniqueWeapon * 10 + DailyPackageType.HeroAwaken] = "V_ui_DailyPackageSelectWindow_UWToAwake",
  [DailyPackageType.HeroAwaken * 10 + DailyPackageType.Hero] = "V_ui_DailyPackageSelectWindow_AwakeToHero",
  [DailyPackageType.HeroAwaken * 10 + DailyPackageType.HeroUniqueWeapon] = "V_ui_DailyPackageSelectWindow_AwakeToUW"
}
local AnimationIdleName = {
  [DailyPackageType.Hero] = "V_ui_DailyPackageSelectWindow_Hero_idle",
  [DailyPackageType.HeroUniqueWeapon] = "V_ui_DailyPackageSelectWindow_UW_idle",
  [DailyPackageType.HeroAwaken] = "V_ui_DailyPackageSelectWindow_Awake_idle"
}
local UNIQUE_DEFAULT_ANI = "Ani_UIDailyPackageSelectWindow_Yellow02"
local HERO_DEFAULT_ANI = "Ani_UIDailyPackageSelectWindow_Blue02"
local GotoType = {
  HeroStar = 1,
  HeroUniqueLv = 2,
  HeroAwakenStar = 3
}

local function ClearScroll(self)
  self.heroContainer:RemoveComponents(HeroItem)
  self.heroScroll:ClearAllItems()
  self.foucsItem = nil
  self.focusIndex = nil
  self.items = {}
  self.validItems = {}
end

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:Init()
end

local function OnDestroy(self)
  if self.heroSpineLoadRequest ~= nil then
    self.heroSpineLoadRequest:Destroy()
    self.heroSpineLoadRequest = nil
  end
  ClearScroll(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function GetItemNameSequence(self)
  NameCount = NameCount + 1
  return tostring(NameCount)
end

local function OnGetHeroItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.visibleIds then
    return nil
  end
  local data = self.visibleIds[index]
  local item = loopScroll:NewListViewItem("HeroItem")
  local script = self.items[item]
  if script == nil then
    local nameSequence = GetItemNameSequence(self)
    local objectName = tostring(nameSequence)
    item.gameObject.name = objectName
    script = self.heroContainer:AddComponent(HeroItem, objectName)
    self.items[item] = script
  end
  script:SetActive(true)
  script:ReInit(data, self.onClickHeroCallback, index)
  local isFocused = self.focusIndex == data
  script:SetFocus(isFocused)
  if isFocused then
    self.foucsItem = script
  end
  self.validItems[index] = script
  script:SetSelecting(self.selectedId == data)
  return item
end

local function OnRecycleItemFunc(self, item)
  if not item then
    return
  end
  local script = self.items[item]
  if script and script.index then
    self.validItems[script.index] = nil
  end
end

local function ComponentDefine(self)
  self.closePanelBtn = self:AddComponent(UIButton, closePanel_btn_path)
  self.closePanelBtn:SetOnClick(function()
    self.ctrl:Close()
  end)
  self.backBtn = self:AddComponent(UIButton, back_btn_path)
  self.backBtn:SetOnClick(function()
    self.ctrl:Close()
  end)
  self.tipText = self:AddComponent(UIText, tip_text_path)
  self.heroNameText = self:AddComponent(UIText, heroName_text_path)
  self.heroTypeIcon = self:AddComponent(UIImage, heroType_icon_path)
  self.heroJobIcon = self:AddComponent(UIImage, heroJob_icon_path)
  self.detailBtn = self:AddComponent(UIButton, detail_btn_path)
  self.detailBtn:SetOnClick(function()
    if not self.heroId then
      return
    end
    local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(self.heroId)
    if heroData then
      if self.focusIndex then
        local lineTemplate = DataCenter.DailyPackageTemplateManager:GetTemplate(self.focusIndex)
        if lineTemplate then
          if lineTemplate.content_type == DailyPackageType.HeroUniqueWeapon then
            local arrowData = {
              arrowType = HeroDetailGuideArrowType.UniqueWeapon,
              heroUid = heroData.uuid
            }
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, heroData.uuid, {
              heroData.uuid
            }, nil, arrowData)
            return
          elseif lineTemplate.content_type == DailyPackageType.HeroAwaken then
            local arrowData = {
              arrowType = HeroDetailGuideArrowType.HeroAwaken,
              heroUid = heroData.uuid
            }
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, heroData.uuid, {
              heroData.uuid
            }, nil, arrowData)
            return
          end
        end
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, heroData.uuid, {
        heroData.uuid
      })
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, self.heroId, {
        self.heroId
      })
    end
  end)
  self.chooseBtn = self:AddComponent(UIButton, choose_btn_path)
  self.chooseBtn:SetOnClick(function()
    self:OnClickSelect()
  end)
  self.chooseBtnText = self:AddComponent(UIText, choose_btn_text_path)
  self.heroScrollViewport = self:AddComponent(UIBaseContainer, hero_scroll_viewport_path)
  self.heroScroll = self:AddComponent(UILoopListView2, hero_scroll_path)
  self.heroScroll:InitListViewParam2(0, function(loopView, index)
    return OnGetHeroItemByIndex(self, loopView, index)
  end, nil, nil, function(item)
    OnRecycleItemFunc(self, item)
  end)
  self.heroScrollrect = self:AddComponent(UIScrollRect, hero_scroll_path)
  self.heroScrollrect:AddValueChangeListener(function()
    self:RefreshPointer()
  end)
  self.heroContainer = self:AddComponent(UIBaseContainer, hero_scrollContent_path)
  self.leftPointer = self:AddComponent(UIImage, hero_scroll_leftPointer_path)
  self.leftPointer:SetActive(false)
  self.rightPointer = self:AddComponent(UIImage, hero_scroll_rightPointer_path)
  self.rightPointer:SetActive(false)
  self.hero_tab = self:AddComponent(UICommonTab, hero_tab_path)
  self.unique_weapon_tab = self:AddComponent(UICommonTab, unique_weapon_tab_path)
  self.heroAwakenTab = self:AddComponent(UICommonTab, "Root/Tab_content/HeroAwakeningTab")
  self.main_tip_text = self:AddComponent(UITextMeshProUGUIEx, main_tip_text_path)
  self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
  self.goto_btn:SetOnClick(function()
    self:OnGoToBtnClick()
  end)
  self.hero_bg = self:AddComponent(UIBaseContainer, hero_bg_path)
  self.goto_btn_text = self:AddComponent(UITextMeshProUGUIEx, goto_btn_text_path)
  self.goto_btn_text:SetLocalText(500413)
  self.heroSpineRoot = self:AddComponent(UIBaseContainer, hero_spine_container_path)
  self.otherBgNode = self:AddComponent(UIBaseContainer, "otherBgNode")
end

local function ComponentDestroy(self)
  self.closePanelBtn = nil
  self.backBtn = nil
  self.tipText = nil
  self.heroNameText = nil
  self.heroTypeIcon = nil
  self.heroJobIcon = nil
  self.detailBtn = nil
  self.chooseBtn = nil
  self.chooseBtnText = nil
  self.heroContainer = nil
  self.heroScroll = nil
  self.hero_tab = nil
  self.unique_weapon_tab = nil
  self.main_tip_text = nil
  self.goto_btn = nil
  self.hero_bg = nil
  self.unique_weapon_icon = nil
  self.curTab = nil
  self.heroSpineRoot = nil
  self.uniqueWeaponSpineRoot = nil
  self.animator = nil
  self.lastAniType = nil
end

local function DataDefine(self)
  self.onClickHeroCallback = BindCallback(self, self.OnClickHero)
  self.items = {}
  self.validItems = {}
end

local function DataDestroy(self)
  self.onClickHeroCallbackf = nil
  if self.spineReq ~= nil then
    self.spineReq:Destroy()
    self.spineReq = nil
  end
  if self.heroSpineReq ~= nil then
    self.heroSpineReq:Destroy()
    self.heroSpineReq = nil
  end
  if self.otherPanelReq then
    self.otherPanelReq:Destroy()
    self.otherPanelReq = nil
  end
end

function UIDailyPackageSelectWindowView:Init()
  local ids = DataCenter.DailyPackageManager:GetVisibleIdsByType(DailyPackageType.HeroUniqueWeapon)
  local ids2Awaken = DataCenter.DailyPackageManager:GetVisibleIdsByType(DailyPackageType.HeroAwaken)
  local hasUniqueWeaponPackage = ids ~= nil and 0 < #ids
  local hasAwaken = ids2Awaken ~= nil and 0 < #ids2Awaken
  if hasUniqueWeaponPackage or hasAwaken then
    self:InitTab()
  else
    self:RefreshAll()
  end
  self.hero_tab:SetActive(hasUniqueWeaponPackage or hasAwaken)
  self.unique_weapon_tab:SetActive(hasUniqueWeaponPackage)
  self.heroAwakenTab:SetActive(hasAwaken)
  if hasUniqueWeaponPackage and not hasAwaken then
    self.otherPanelReq = self:LoadUniqueWeaponAniNode()
  elseif hasUniqueWeaponPackage and hasAwaken then
    self.otherPanelReq = self:LoadUWAndAwakenAniNoded()
  end
end

function UIDailyPackageSelectWindowView:InitTab()
  local ids = DataCenter.DailyPackageManager:GetVisibleIdsByType(DailyPackageType.HeroUniqueWeapon)
  local ids2Awaken = DataCenter.DailyPackageManager:GetVisibleIdsByType(DailyPackageType.HeroAwaken)
  local hasUniqueWeaponPackage = ids ~= nil and 0 < #ids
  local hasAwaken = ids2Awaken ~= nil and 0 < #ids2Awaken
  if not hasUniqueWeaponPackage and not hasAwaken then
    self:RefreshAll()
    self.hero_tab:SetActive(false)
    self.unique_weapon_tab:SetActive(false)
    self.heroAwakenTab:SetActive(false)
    return
  end
  if hasUniqueWeaponPackage or hasAwaken then
    local heroTabParam = {}
    heroTabParam.tabId = DailyPackageType.Hero
    heroTabParam.title = Localization:GetString("dailygift_selectlist_name1")
    heroTabParam.clickHandler = self.OnTabClick
    heroTabParam.containPanel = self.heroSpineRoot
    self.hero_tab:ReInit(heroTabParam)
    self.hero_tab:SetSelect(false)
  end
  if hasUniqueWeaponPackage then
    local uniqueTabParam = {}
    uniqueTabParam.tabId = DailyPackageType.HeroUniqueWeapon
    uniqueTabParam.title = Localization:GetString("dailygift_selectlist_name2")
    uniqueTabParam.clickHandler = self.OnTabClick
    self.unique_weapon_tab:ReInit(uniqueTabParam)
    self.unique_weapon_tab:SetSelect(false)
  end
  if hasAwaken then
    local awakenParam = {}
    awakenParam.tabId = DailyPackageType.HeroAwaken
    awakenParam.title = Localization:GetString("hero_try_out_tab_3")
    awakenParam.clickHandler = self.OnTabClick
    self.heroAwakenTab:ReInit(awakenParam)
    self.heroAwakenTab:SetSelect(false)
  end
  local TabTypeMap = {
    [DailyPackageType.Hero] = self.hero_tab,
    [DailyPackageType.HeroUniqueWeapon] = self.unique_weapon_tab,
    [DailyPackageType.HeroAwaken] = self.heroAwakenTab
  }
  local defaultTab = DataCenter.DailyPackageManager.selectTab
  if defaultTab then
    self:OnTabClick(TabTypeMap[defaultTab])
  else
    self:OnTabClick(self.hero_tab)
  end
  self.hero_tab:SetRedDotVisible(DataCenter.DailyPackageManager:HasRedDot(DailyPackageType.Hero))
  self.unique_weapon_tab:SetRedDotVisible(DataCenter.DailyPackageManager:HasRedDot(DailyPackageType.HeroUniqueWeapon))
  self.heroAwakenTab:SetRedDotVisible(hasAwaken and DataCenter.DailyPackageManager:HasRedDot(DailyPackageType.HeroAwaken))
end

local function RefreshAll(self)
  if self.curTab == nil then
    self.visibleIds = DataCenter.DailyPackageManager:GetVisibleIds(DailyPackageType.Hero)
    self:RefreshList()
  else
    self.visibleIds = DataCenter.DailyPackageManager:GetVisibleIds(self.curTab.tabId)
    self:RefreshList()
  end
end

function UIDailyPackageSelectWindowView:LoadUniqueWeaponAniNode()
  return self:LoadOtherPanel(UIAssets.DailyPackageSelectUWAni, function(go)
    self.unique_weapon_icon = self.dynamicRoot:AddComponent(UIRawImage, unique_weapon_icon_path)
    self.uniqueWeaponSpineRoot = self.dynamicRoot:AddComponent(UIBaseContainer, unique_weapon_spine_container_path)
  end)
end

function UIDailyPackageSelectWindowView:LoadUWAndAwakenAniNoded()
  return self:LoadOtherPanel(UIAssets.DailyPackageSelectAwakenAni, function(go)
    self.unique_weapon_icon = self.dynamicRoot:AddComponent(UIRawImage, unique_weapon_icon_path)
    self.uniqueWeaponSpineRoot = self.dynamicRoot:AddComponent(UIBaseContainer, unique_weapon_spine_container_path)
    self.awakenSpineRoot = self.dynamicRoot:AddComponent(UIBaseContainer, awaken_spine_node_path)
  end)
end

function UIDailyPackageSelectWindowView:LoadOtherPanel(path, callback)
  local request = ResourceManager:InstantiateAsync(path)
  request:completed("+", function(req)
    if req.isError then
      return
    end
    local go = req.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.otherBgNode.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.animator = go:GetComponent(typeof(CS.UnityEngine.Animator))
    local name = go.name
    self.dynamicRoot = self.otherBgNode:AddComponent(UIBaseContainer, name)
    self:PlayDefaultAnimation()
    if callback then
      callback(go)
    end
    local lineTemplate, heroTemplate
    if self.focusIndex then
      lineTemplate = DataCenter.DailyPackageTemplateManager:GetTemplate(self.focusIndex)
    end
    if self.heroId then
      heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(self.heroId)
    end
    self:LoadSpine(lineTemplate, heroTemplate)
  end)
  return request
end

local function RefreshList(self)
  if table.IsNullOrEmpty(self.visibleIds) then
    self.ctrl:Close()
    return
  end
  self.selectedId = DataCenter.DailyPackageManager:GetSelectId()
  self.heroScroll:SetListItemCount(#self.visibleIds, false, false)
  local jumpDataIndex
  if self.selectedId then
    for i, v in ipairs(self.visibleIds) do
      if v == self.selectedId then
        jumpDataIndex = i
        break
      end
    end
  end
  jumpDataIndex = jumpDataIndex or 1
  self.focusIndex = self.visibleIds[jumpDataIndex]
  self.heroScroll:MovePanelToItemIndex(jumpDataIndex - 1, 0)
  self:OnFocusHero(self.focusIndex)
end

local function OnClickHero(self, item, templateId)
  if templateId == self.focusIndex then
    return
  end
  if self.foucsItem then
    self.foucsItem:SetFocus(false)
    self.foucsItem = nil
  end
  item:SetFocus(true)
  self.foucsItem = item
  self:OnFocusHero(templateId)
end

local function OnFocusHero(self, templateId)
  self.focusIndex = templateId
  local lineTemplate = DataCenter.DailyPackageTemplateManager:GetTemplate(templateId)
  if not lineTemplate then
    return
  end
  self.goto_btn.gameObject:SetActive(false)
  self.main_tip_text.gameObject:SetActive(false)
  self.cacheGoToBtnType = nil
  if lineTemplate.content_type == DailyPackageType.HeroUniqueWeapon then
    self:_onFocusUniqueWeapon(lineTemplate)
  elseif lineTemplate.content_type == DailyPackageType.HeroAwaken then
    self:_onFocusAwaken(lineTemplate)
  end
  local heroId = lineTemplate:GetHeroId()
  self.heroId = heroId
  local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(heroId)
  if heroTemplate then
    local heroName = Localization:GetString(heroTemplate.name)
    self.heroNameText:SetText(heroName)
    self.heroTypeIcon:LoadSprite(HeroUtils.GetHeroTypeIcon(heroTemplate.type))
    self.heroJobIcon:LoadSprite(HeroUtils.GetHeroJobIcon(heroTemplate.job, 2))
    self:LoadSpine(lineTemplate, heroTemplate)
  else
    local nameStr = ""
    self.heroNameText:SetText(nameStr)
  end
  if templateId == self.selectedId then
    UIGray.SetGray(self.chooseBtn.transform, true, false)
    self.chooseBtnText:SetLocalText("120164")
  else
    UIGray.SetGray(self.chooseBtn.transform, false, true)
    self.chooseBtnText:SetLocalText("110108")
  end
end

function UIDailyPackageSelectWindowView:LoadSpine(lineTemplate, heroTemplate)
  if not lineTemplate or not heroTemplate then
    Logger.LogError("lineTemplate:  " .. tostring(lineTemplate))
    Logger.LogError("heroTemplate:  " .. tostring(heroTemplate))
    return
  end
  if lineTemplate.content_type ~= DailyPackageType.Hero and not self.animator then
    return
  end
  local spineRoot, appearanceId
  if lineTemplate.content_type == DailyPackageType.Hero then
    appearanceId = heroTemplate.appearance
    spineRoot = self.heroSpineRoot
  elseif lineTemplate.content_type == DailyPackageType.HeroUniqueWeapon then
    appearanceId = heroTemplate.appearance
    spineRoot = self.uniqueWeaponSpineRoot
    self:_loadUWSpineBg(lineTemplate)
  elseif lineTemplate.content_type == DailyPackageType.HeroAwaken then
    appearanceId = lineTemplate.awaken_appearance
    spineRoot = self.awakenSpineRoot
  end
  if self.spineReq ~= nil then
    self.spineReq:Destroy()
    self.spineReq = nil
  end
  if appearanceId and spineRoot then
    self.spineReq = self:_loadSpineRequest(appearanceId, lineTemplate, spineRoot)
  end
end

function UIDailyPackageSelectWindowView:_loadUWSpineBg(lineTemplate)
  local path = string.format(LoadPath.DailyPackageUniqueWeapon, lineTemplate.pic_para1)
  local hasAsset = UIUtil.CheckAssetDownloaded(path)
  if hasAsset then
    self.unique_weapon_icon:LoadSprite(path)
  else
    self.unique_weapon_icon:LoadSpriteAsync(path)
  end
  local param = lineTemplate.posterWindowRect
  if param then
    local posterRect = self.unique_weapon_icon.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
    posterRect.anchoredPosition = Vector2.New(param.x, param.y)
    posterRect.sizeDelta = Vector2.New(param.width, param.height)
  end
end

function UIDailyPackageSelectWindowView:_onFocusUniqueWeapon(lineTemplate)
  local targetHeroId = lineTemplate.selectConditionHeroId
  local targetStarId = lineTemplate.selectConditionStarId
  local heroRankConfig = DataCenter.HeroRankTemplateManager:GetTemplate(targetStarId)
  if heroRankConfig == nil then
    Logger.LogError("isValid targetStarId!  Daily ID:" .. lineTemplate.id)
    return
  end
  local heroConfig = DataCenter.HeroTemplateManager:GetTemplate(targetHeroId)
  if heroConfig == nil then
    Logger.LogError("isValid heroId!  Daily ID:" .. lineTemplate.id)
  end
  local curStarId = 0
  local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(targetHeroId)
  if heroData ~= nil then
    curStarId = heroData.rankTemplate.id
  end
  if targetStarId > curStarId then
    self.main_tip_text:SetLocalText("dailygift_selectlist_unlocktips1", Localization:GetString(heroConfig.name), Localization:GetString(heroRankConfig.name))
    self.main_tip_text.gameObject:SetActive(true)
    self.cacheGoToBtnType = GotoType.HeroStar
  else
    local uniqueMaxLv = DataCenter.HeroUniqueWeaponTemplateManager:GetMaxLevel(targetHeroId)
    local curUniqueLv = 0
    if heroData then
      curUniqueLv = heroData.uniqueWeaponLv
    end
    if uniqueMaxLv ~= 0 and curUniqueLv == uniqueMaxLv then
      local canEnhance = heroData:IsUnlockedEnhanceUW() or heroData:CanUnlockEnhanceUW()
      local tip_txt = ""
      if canEnhance then
        if heroData:IsAllUnitMaxLv() then
          tip_txt = Localization:GetString("dailygift_selectlist_unlocktips2", Localization:GetString(heroConfig.name))
        else
          tip_txt = Localization:GetString("hero_unique_unit_daily_off_desc1", Localization:GetString(heroConfig.name))
        end
      else
        tip_txt = Localization:GetString("dailygift_selectlist_unlocktips2", Localization:GetString(heroConfig.name))
      end
      self.main_tip_text:SetText(tip_txt)
      self.main_tip_text.gameObject:SetActive(true)
    end
  end
  self.goto_btn.gameObject:SetActive(self.cacheGoToBtnType ~= nil)
end

function UIDailyPackageSelectWindowView:_onFocusAwaken(lineTemplate)
  local targetHeroId = lineTemplate:GetHeroId()
  local targetUniqueLevel = lineTemplate.selectConditionStarId
  local heroConfig = DataCenter.HeroTemplateManager:GetTemplate(targetHeroId)
  if heroConfig == nil then
    Logger.LogError("isValid heroId!  Daily ID:" .. lineTemplate.id)
  end
  local curUniqueLv = 0
  local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(targetHeroId)
  if heroData ~= nil then
    curUniqueLv = heroData.uniqueWeaponLv
  end
  if targetUniqueLevel and targetUniqueLevel > curUniqueLv then
    self.main_tip_text:SetLocalText("dailygift3_buy_1", Localization:GetString(heroConfig.name), targetUniqueLevel)
    self.main_tip_text.gameObject:SetActive(true)
    self.cacheGoToBtnType = GotoType.HeroUniqueLv
  elseif not heroData:IsHeroAwakenReachMaxLevel() then
    if lineTemplate.awakenConditionStarId then
      local curAwakenStar = heroData:GetHeroAwakenRankLevel()
      if curAwakenStar < lineTemplate.awakenConditionStarId then
        self.main_tip_text:SetLocalText("dailygift3_buy_6", lineTemplate.awakenConditionStarId)
        self.main_tip_text.gameObject:SetActive(true)
        self.cacheGoToBtnType = GotoType.HeroAwakenStar
      end
    end
  else
    local tip_txt = Localization:GetString("dailygift_selectlist_unlocktips2", Localization:GetString(heroConfig.name))
    self.main_tip_text:SetText(tip_txt)
    self.main_tip_text.gameObject:SetActive(true)
  end
  self.goto_btn.gameObject:SetActive(self.cacheGoToBtnType ~= nil)
end

function UIDailyPackageSelectWindowView:_loadSpineRequest(appearanceId, config, root)
  local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(appearanceId)
  local spinePath = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_path")
  local request = ResourceManager:InstantiateAsync(spinePath)
  request:completed("+", function()
    if IsNull(request.gameObject) then
      return
    end
    local spineMaskRect = config.spineWindowMaskRect
    local spinePos = config.spineWindowPos
    local obj = request.gameObject
    obj:SetActive(true)
    obj.transform:SetParent(root.transform)
    obj.transform.localPosition = Vector3.New(0, 0, 0)
    obj.transform.localScale = Vector3.New(1, 1, 1)
    if config.content_type == DailyPackageType.HeroUniqueWeapon or config.content_type == DailyPackageType.HeroAwaken then
      if spinePos then
        local rectTransform = obj:GetComponent(typeof(CS.UnityEngine.RectTransform))
        rectTransform:Set_anchoredPosition(spinePos.x, spinePos.y, 0)
      end
      if spineMaskRect then
        root.transform:Set_localScale(spineMaskRect.scale, spineMaskRect.scale, 1)
        root.rectTransform:Set_anchoredPosition(spineMaskRect.x, spineMaskRect.y, 0)
        root.rectTransform.sizeDelta = Vector2.New(spineMaskRect.width, spineMaskRect.height)
      end
    end
  end)
  return request
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGiftPackData, RefreshAll)
  self:AddUIListener(EventId.RefreshWelfareRedDot, self.RefreshRedPoint)
  self.addListener = true
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  if self.addListener then
    self:RemoveUIListener(EventId.UpdateGiftPackData, RefreshAll)
    self:RemoveUIListener(EventId.RefreshWelfareRedDot, self.RefreshRedPoint)
    self.addListener = false
  end
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
  if self.focusIndex then
    self:OnFocusHero(self.focusIndex)
  end
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function OnClickSelect(self)
  if self.selectedId == nil or self.focusIndex ~= self.selectedId then
    DataCenter.DailyPackageManager:Select(self.focusIndex)
    self.ctrl:Close()
  end
end

local function OnGoToBtnClick(self)
  local heroUuid = DataCenter.HeroDataManager:GetHeroUuidByHeroId(self.heroId)
  if self.cacheGoToBtnType == nil then
    return
  end
  if not string.IsNullOrEmpty(heroUuid) then
    local tag = HeroDetailGuideArrowType.Rank
    if self.cacheGoToBtnType == GotoType.HeroUniqueLv then
      tag = HeroDetailGuideArrowType.UniqueWeapon
    elseif self.cacheGoToBtnType == GotoType.HeroAwakenStar then
      tag = HeroDetailGuideArrowType.HeroAwaken
    end
    local arrowData = {arrowType = tag, heroUid = heroUuid}
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, heroUuid, {heroUuid}, nil, arrowData)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, self.heroId, {
      self.heroId
    })
  end
end

local function OnTabClick(self, tabItem)
  if self.curTab ~= nil then
    if self.curTab.tabId == tabItem.tabId then
      return
    else
      self.curTab:SetSelect(false)
      if self.animator then
        self.cachePlayAniName = self:GetTransitionAniName(self.curTab.tabId, tabItem.tabId)
      end
    end
  end
  self:PlayTransitionAnimation()
  self.curTab = tabItem
  self.curTab:SetSelect(true)
  self.visibleIds = DataCenter.DailyPackageManager:GetVisibleIdsByType(self.curTab.tabId)
  self:RefreshList()
end

function UIDailyPackageSelectWindowView:PlayDefaultAnimation()
  if not self.curTab then
    return
  end
  local defaultAnimation = AnimationIdleName[self.curTab.tabId]
  if self.animator then
    self.animator:Play(defaultAnimation, -1, 0)
    self.animator:Update(0)
  end
end

function UIDailyPackageSelectWindowView:PlayTransitionAnimation()
  if self.cachePlayAniName and self.animator then
    self.animator:Play(self.cachePlayAniName, -1, 0)
    self.animator:Update(0)
    self.cachePlayAniName = nil
  end
end

function UIDailyPackageSelectWindowView:GetTransitionAniName(curState, targetState)
  if not (curState and targetState) or curState == targetState then
    Logger.LogError("state is error!  cur:" .. tostring(curState) .. "  tar:" .. tostring(targetState))
    return
  end
  local key = curState * 10 + targetState
  return AnimationShowName[key]
end

local TABLEWIDTH = 165
local PADDING = -10

function UIDailyPackageSelectWindowView:RefreshPointer()
  if table.IsNullOrEmpty(self.visibleIds) then
    return
  end
  local leftRedNum = 0
  local rightRedNum = 0
  local minValidIdx = IntMaxValue
  local maxValidIdx = -1
  if not self.scrollViewportLeftX then
    local minX, maxX = self.heroScrollViewport.rectTransform:Get_worldCorners_x()
    self.scrollViewportLeftX = minX
    self.scrollViewportRightX = maxX
  end
  
  local function IsInViewPort(item)
    local minX, maxX = item.rectTransform:Get_worldCorners_x()
    if maxX < self.scrollViewportLeftX then
      return false
    end
    if minX > self.scrollViewportRightX then
      return false
    end
    return true
  end
  
  for index, v in pairs(self.validItems) do
    if index < minValidIdx then
      minValidIdx = index
    end
    if index > maxValidIdx then
      maxValidIdx = index
    end
  end
  local minShowIdx = IntMaxValue
  local maxShowIdx = -1
  for i = minValidIdx, maxValidIdx do
    if IsInViewPort(self.validItems[i]) then
      minShowIdx = i
      break
    end
  end
  for i = maxValidIdx, minValidIdx, -1 do
    if IsInViewPort(self.validItems[i]) then
      maxShowIdx = i
      break
    end
  end
  for index, v in pairs(self.visibleIds) do
    if minShowIdx ~= IntMaxValue and index < minShowIdx then
      if not DataCenter.DailyPackageManager:IsReaded(self.visibleIds[index] or index) then
        leftRedNum = leftRedNum + 1
      end
    elseif maxShowIdx ~= -1 and index > maxShowIdx and not DataCenter.DailyPackageManager:IsReaded(self.visibleIds[index] or index) then
      rightRedNum = rightRedNum + 1
    end
  end
  self.leftPointer:SetActive(0 < leftRedNum)
  self.rightPointer:SetActive(0 < rightRedNum)
end

function UIDailyPackageSelectWindowView:RefreshRedPoint()
  self:RefreshPointer()
  if self.hero_tab:GetActiveInHierarchy() then
    self.hero_tab:SetRedDotVisible(DataCenter.DailyPackageManager:HasRedDot(DailyPackageType.Hero))
  end
  if self.unique_weapon_tab:GetActiveInHierarchy() then
    self.unique_weapon_tab:SetRedDotVisible(DataCenter.DailyPackageManager:HasRedDot(DailyPackageType.HeroUniqueWeapon))
  end
  if self.heroAwakenTab:GetActiveInHierarchy() then
    self.heroAwakenTab:SetRedDotVisible(DataCenter.DailyPackageManager:HasRedDot(DailyPackageType.HeroAwaken))
  end
end

UIDailyPackageSelectWindowView.OnCreate = OnCreate
UIDailyPackageSelectWindowView.OnDestroy = OnDestroy
UIDailyPackageSelectWindowView.OnAddListener = OnAddListener
UIDailyPackageSelectWindowView.OnRemoveListener = OnRemoveListener
UIDailyPackageSelectWindowView.ComponentDefine = ComponentDefine
UIDailyPackageSelectWindowView.ComponentDestroy = ComponentDestroy
UIDailyPackageSelectWindowView.DataDefine = DataDefine
UIDailyPackageSelectWindowView.DataDestroy = DataDestroy
UIDailyPackageSelectWindowView.RefreshAll = RefreshAll
UIDailyPackageSelectWindowView.OnEnable = OnEnable
UIDailyPackageSelectWindowView.OnDisable = OnDisable
UIDailyPackageSelectWindowView.OnClickHero = OnClickHero
UIDailyPackageSelectWindowView.OnFocusHero = OnFocusHero
UIDailyPackageSelectWindowView.OnClickSelect = OnClickSelect
UIDailyPackageSelectWindowView.OnGoToBtnClick = OnGoToBtnClick
UIDailyPackageSelectWindowView.OnTabClick = OnTabClick
UIDailyPackageSelectWindowView.RefreshList = RefreshList
return UIDailyPackageSelectWindowView
