local UIHeroExhibitPanelView = BaseClass("UIHeroExhibitPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UIHeroSkillItem = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillItem")
local ResourceManager = CS.GameEntry.Resource
local UIHeroSimpleTipView = require("UI.UILWHero.UIHeroSimpleTip.View.UIHeroSimpleTipView")
local UIHeroPowerDetailTipView = require("UI.UILWHero.UIHeroPowerDetailTip.View.UIHeroPowerDetailTipView")
local UIHeroSkillPreviewPage = require("UI/UILWHero/UIHeroExhibitPanel/Component/UIHeroSkillPreviewPage")
local UIHeroExhibitPreviewPage = require("UI/UILWHero/UIHeroExhibitPanel/Component/UIHeroExhibitPreviewPage")
local UIHeroDetailPageToggle = require("UI/UILWHero/UIHeroExhibitPanel/Component/UIHeroDetailPageToggle")
local heroSpineContainerPath = "Root/CenterHeroInfo/HeroSpineContainerMask/HeroSpineContainer"
local heroQualityIconPath = "Root/RightTopInfo/HeroQualityIcon"
local heroNameTextPath = "Root/RightTopInfo/HeroNameText"
local nickNameTextPath = "Root/RightTopInfo/HeroNameText/nickNameText"
local heroTypeIconPath = "Root/RightTopInfo/HeroTypeIcon"
local heroSkillListPath = "Root/CenterHeroInfo/HeroSkillInfo/SkillList"
local heroSkill1Path = "Root/CenterHeroInfo/HeroSkillInfo/SkillList/HeroSkill1"
local heroSkill2Path = "Root/CenterHeroInfo/HeroSkillInfo/SkillList/HeroSkill2"
local heroSkill3Path = "Root/CenterHeroInfo/HeroSkillInfo/SkillList/HeroSkill3"
local heroSkill4Path = "Root/CenterHeroInfo/HeroSkillInfo/SkillList/HeroSkill4"
local skillTxtPath = "Root/CenterHeroInfo/HeroSkillInfo/skillTxt"
local centerQualityImgPath = "Root/CenterHeroInfo/CenterInfoQualityBg"
local heroExhibitPreviewPagePath = "Root/CenterHeroInfo/Pages/Content/PreviewHeroExhibitPage"
local skillPreviewPagePath = "Root/CenterHeroInfo/Pages/Content/PreviewSkillPage"
local heroExhibitPreviewPageTogglePath = "Root/CenterHeroInfo/PageToggles/HeroExhibitPreviewPageToggle"
local skillPreviewPageTogglePath = "Root/CenterHeroInfo/PageToggles/SkillPreviewPageToggle"
local equipAddHpTextPath = "Root/CenterBottomInfo/HeroPropertyInfo/HeroHpInfo/HpInfoNumber/EquipAddHpText"
local equipAddAtkTextPath = "Root/CenterBottomInfo/HeroPropertyInfo/HeroAttackInfo/AttckInfoNumber/EquipAddAttackText"
local equipAddDefTextPath = "Root/CenterBottomInfo/HeroPropertyInfo/HeroDefInfo/DefInfoNumber/EquipAddDefText"
local hpTitleTextPath = "Root/CenterBottomInfo/HeroPropertyInfo/HeroHpInfo/HpInfoTitleText"
local atkTitleTextPath = "Root/CenterBottomInfo/HeroPropertyInfo/HeroAttackInfo/AttackInfoTitleText"
local defTitleTextPath = "Root/CenterBottomInfo/HeroPropertyInfo/HeroDefInfo/HeroDefInfoTitleText"
local bgImgPath = "Bg"
local bgIconImgPath = "Bg/Icon"
local contentBgImgPath = "Root/ContentBg"
local contentBgIconImgPath = "Root/ContentBg/ContentBgIcon"
local HeroDetailPageType = {HeroExhibit = 1, SkillPreview = 2}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.curHeroUuid, self.heroUuidList, self.callBack, self.isPreview, self.guideArrowData, self.showFunctionBtn = self:GetUserData()
  self:OnOpen()
end

local function OnDestroy(self)
  self.CloseSkillSimpleTipWindow()
  DataCenter.ArrowManager:RemoveArrow()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ShowEquipAddProperty(self)
  if self.heroData == nil then
    return
  end
  self.equipAddHpText:SetActive(true)
  local equipAddHp = self.heroData:GetEquipAddHp()
end

local function HideEquipAddProperty(self)
end

local function GotoEquipPage(self)
  self.scrollRectCenter:CenterOnAnim(1, 0.5)
  self:GoToPage(HeroDetailPageType.EquipDetail)
end

local function GoToSkillDetialPage(self, isAnim)
  if self.curHeroUuid == nil then
    return
  end
  if self.enableEquipFunction then
    if not isAnim then
      self.scrollRectCenter:CenterOn(3)
    else
      self.scrollRectCenter:CenterOnAnim(3, 0.5)
    end
  elseif not isAnim then
    self.scrollRectCenter:CenterOn(2)
  else
    self.scrollRectCenter:CenterOnAnim(2, 0.5)
  end
end

local function GoToSkillDetailPageAndUnlock(self)
  if self.curHeroUuid == nil or self.curSelectedSkillIndex == nil then
    return
  end
  local heroData = self.heroData
  local skillData = self.heroData:GetHeroSkillBySlotIndex(self.curSelectedSkillIndex)
  
  local function UnlockSkill()
    if heroData == nil or skillData == nil then
      return
    end
    if not skillData.isUnlocked then
      local unlockSkillCost = DataCenter.HeroUnlockSkillCostDataManager:GetCostByQualityAndSlot(heroData.quality, skillData.slotIndex)
      local costId, costCount
      for id, count in pairs(unlockSkillCost) do
        costId = id
        costCount = count
        break
      end
      local have = DataCenter.ItemData:GetItemCount(costId)
      if costCount > have then
        return
      end
      local hasUnlockPrevSkill = heroData:CanUnlockSkillByPrevSkillLimit(skillData.slotIndex)
      if not hasUnlockPrevSkill then
        return
      end
      SFSNetwork.SendMessage(MsgDefines.HeroSkillUnlock, heroData.uuid, skillData.slotIndex)
    end
  end
  
  if self.enableEquipFunction then
    self.scrollRectCenter:CenterOnAnim(3, 0.5, UnlockSkill)
  else
    self.scrollRectCenter:CenterOnAnim(2, 0.5, UnlockSkill)
  end
end

local function ScrollGoToPage(self, pageType)
  self:GoToPage(pageType)
end

local function GoToPage(self, pageType)
  if self.curPageType == pageType then
    return
  end
  for i = 1, #self.pageToggles do
    if i == pageType then
      self.pageToggles[i]:SetActiveState(true)
    else
      self.pageToggles[i]:SetActiveState(false)
    end
  end
  self.heroSkillList:SetActive(true)
  self.curPageType = pageType
  if pageType == HeroDetailPageType.SkillPreview then
    self:RefreshSkillFrame(true)
  else
    self:RefreshSkillFrame(false)
  end
  self:RefreshHeroBaseInfo()
  self.CloseSkillSimpleTipWindow()
end

local function OnBeginDrag(self, eventData)
  self.lastDragPosX = eventData.position.x
end

local function OnEndDrag(self, eventData)
  if self.curPageType == nil then
    return
  end
  local curDragPosX = eventData.position.x
  local offset = curDragPosX - self.lastDragPosX
  if offset < -15 then
    if self.curPageType + 1 <= HeroDetailPageType.SkillDetail then
      GoToPage(self, self.curPageType + 1)
    end
  elseif 15 < offset and self.curPageType - 1 >= HeroDetailPageType.EquipDetail then
    GoToPage(self, self.curPageType - 1)
  end
end

local function OnClickExpBtn(self)
  if self.hasExpCount < self.costExpCount then
    LWResourceLackUtil:GotoGoodsItemLack(200390, 1)
  end
end

local function ComponentDefine(self)
  self.btnClose = self:AddComponent(UIButton, "Root/BtnBack")
  self.btnClose:SetOnClick(BindCallback(self, self.OnBtnCloseClick))
  self.btnClose:SetActive(true)
  self.gotoFirstViewBg = self:AddComponent(UIButton, "Root/gotoFirstViewBg")
  self.gotoFirstViewBg:SetOnClick(BindCallback(self, self.OnGotoFirstViewBgClick))
  self.btnPreViewClose = self:AddComponent(UIButton, "Root/CenterBottomInfo/BtnPreBack")
  self.btnPreViewClose:SetOnClick(BindCallback(self, self.OnBtnCloseClick))
  self.btnPreCloseText = self:AddComponent(UIText, "Root/CenterBottomInfo/BtnPreBack/PreBackBtnText")
  self.qualityIcon = self:AddComponent(UIImage, heroQualityIconPath)
  self.nameText = self:AddComponent(UIText, heroNameTextPath)
  self.nickNameText = self:AddComponent(UIText, nickNameTextPath)
  self.heroSpineContainer = self:AddComponent(UIBaseContainer, heroSpineContainerPath)
  self.heroSkillList = self:AddComponent(UIBaseContainer, heroSkillListPath)
  self.heroSkill1 = self:AddComponent(UIHeroSkillItem, heroSkill1Path)
  self.heroSkill2 = self:AddComponent(UIHeroSkillItem, heroSkill2Path)
  self.heroSkill3 = self:AddComponent(UIHeroSkillItem, heroSkill3Path)
  self.heroSkill4 = self:AddComponent(UIHeroSkillItem, heroSkill4Path)
  self.heroSkills = {
    self.heroSkill1,
    self.heroSkill2,
    self.heroSkill3,
    self.heroSkill4
  }
  self.skillTxt = self:AddComponent(UIText, skillTxtPath)
  self.heroLevelText = self:AddComponent(UIText, "Root/RightTopInfo/HeroLevelInfo/HeroLevelText")
  self.atkNumberText = self:AddComponent(UIText, "Root/CenterBottomInfo/HeroPropertyInfo/HeroAttackInfo/AttckInfoNumber/CurAttackText")
  self.hpNumberText = self:AddComponent(UIText, "Root/CenterBottomInfo/HeroPropertyInfo/HeroHpInfo/HpInfoNumber/CurHpText")
  self.defNumberText = self:AddComponent(UIText, "Root/CenterBottomInfo/HeroPropertyInfo/HeroDefInfo/DefInfoNumber/CurDefText")
  self.equipAddHpText = self:AddComponent(UIText, equipAddHpTextPath)
  self.equipAddAtkText = self:AddComponent(UIText, equipAddAtkTextPath)
  self.equipAddDefText = self:AddComponent(UIText, equipAddDefTextPath)
  self.atkInfoBtn = self:AddComponent(UIButton, "Root/CenterBottomInfo/HeroPropertyInfo/HeroAttackInfo")
  self.atkInfoBtn:SetOnClick(function()
    if self.heroData == nil then
      return
    end
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.atkInfoBtn.transform.position + Vector3.New(0, 5, 0) * scaleFactor
    local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
    param.title = nil
    param.content = Localization:GetString(HeroUtils.GetHeroPropertyNameId(HeroEffectDefine.PhysicalAttack_Result))
    param.position = position
    param.width = 200
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
  end)
  self.hpInfoBtn = self:AddComponent(UIButton, "Root/CenterBottomInfo/HeroPropertyInfo/HeroHpInfo")
  self.hpInfoBtn:SetOnClick(function()
    if self.heroData == nil then
      return
    end
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.hpInfoBtn.transform.position + Vector3.New(0, 5, 0) * scaleFactor
    local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
    param.title = nil
    param.content = Localization:GetString(HeroUtils.GetHeroPropertyNameId(HeroEffectDefine.HealPoint_Result))
    param.position = position
    param.width = 200
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
  end)
  self.defInfoBtn = self:AddComponent(UIButton, "Root/CenterBottomInfo/HeroPropertyInfo/HeroDefInfo")
  self.defInfoBtn:SetOnClick(function()
    if self.heroData == nil then
      return
    end
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.defInfoBtn.transform.position + Vector3.New(0, 5, 0) * scaleFactor
    local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
    param.title = nil
    param.content = Localization:GetString(HeroUtils.GetHeroPropertyNameId(HeroEffectDefine.PhysicalDefense_Result))
    param.position = position
    param.width = 200
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
  end)
  self.prevHeroBtn = self:AddComponent(UIButton, "Root/CenterBottomInfo/ChangeHeroArrow/ToPrevHeroArrow")
  self.prevHeroBtn:SetOnClick(function()
    self:OnArrowBtnClick(true)
  end)
  self.nextHeroBtn = self:AddComponent(UIButton, "Root/CenterBottomInfo/ChangeHeroArrow/ToNextHeroArrow")
  self.nextHeroBtn:SetOnClick(function()
    self:OnArrowBtnClick(false)
  end)
  self.centerBottomInfo = self:AddComponent(UIBaseContainer, "Root/CenterBottomInfo")
  self.templateHeroContainer = self:AddComponent(UIBaseContainer, "Root/CenterBottomInfo/HeroPropertyInfo/TemplateHeroContainer")
  self.templateHeroGotoBtn = self:AddComponent(UIButton, "Root/CenterBottomInfo/HeroPropertyInfo/TemplateHeroContainer/TemplateHeroGotoBtn")
  self.templateHeroGotoBtnText = self:AddComponent(UIText, "Root/CenterBottomInfo/HeroPropertyInfo/TemplateHeroContainer/TemplateHeroGotoBtn/TemplateHeroGotoBtnText")
  self.templateHeroText = self:AddComponent(UIText, "Root/CenterBottomInfo/HeroPropertyInfo/TemplateHeroContainer/TemplateHeroText")
  self.templateHeroGotoBtn:SetOnClick(function()
    if self.heroData ~= nil then
      local need = HeroUtils.GetJigsawCost(self.heroData.fragId)
      LWResourceLackUtil:GotoGoodsItemLack(self.heroData.fragId, need)
    end
  end)
  self.templateHeroGotoBtnText:SetLocalText(151112)
  self.templateHeroText:SetLocalText(151111)
  self.heroDragArea = self:AddComponent(UIEventTrigger, "Root/DragHeroArea")
  self.heroDragArea:OnBeginDrag(function(eventData)
    OnBeginDrag(self, eventData)
  end)
  self.heroDragArea:OnEndDrag(function(eventData)
    OnEndDrag(self, eventData)
  end)
  self.bgImg = self:AddComponent(UIImage, bgImgPath)
  self.bgIconImg = self:AddComponent(UIImage, bgIconImgPath)
  self.contentBgImg = self:AddComponent(UIImage, contentBgImgPath)
  self.contentBgIconImg = self:AddComponent(UIImage, contentBgIconImgPath)
  self.centerQualityImg = self:AddComponent(UIImage, centerQualityImgPath)
  self.heroTypeIcon = self:AddComponent(UIImage, heroTypeIconPath)
  self.heroExhibitPreviewPage = self:AddComponent(UIHeroExhibitPreviewPage, heroExhibitPreviewPagePath)
  self.skillPreviewPage = self:AddComponent(UIHeroSkillPreviewPage, skillPreviewPagePath)
  self.pages = {
    self.heroExhibitPreviewPage,
    self.skillPreviewPage
  }
  self.heroExhibitPreviewPageToggle = self:AddComponent(UIHeroDetailPageToggle, heroExhibitPreviewPageTogglePath)
  self.skillPreviewPageToggle = self:AddComponent(UIHeroDetailPageToggle, skillPreviewPageTogglePath)
  self.pageToggles = {
    self.heroExhibitPreviewPageToggle,
    self.skillPreviewPageToggle
  }
  self.hpTitleText = self:AddComponent(UIText, hpTitleTextPath)
  self.atkTitleText = self:AddComponent(UIText, atkTitleTextPath)
  self.defTitleText = self:AddComponent(UIText, defTitleTextPath)
  self.scrollUIEventListener = self:AddComponent(UIEventTrigger, "Root/CenterHeroInfo/Pages")
  self.scrollRectCenter = self:AddComponent(UIScrollRectCenter, "Root/CenterHeroInfo/Pages")
  self.scrollRectCenter:OnCenterOnChild(BindCallback(self, ScrollGoToPage))
  self.hpTitleText:SetLocalText(154286)
  self.atkTitleText:SetLocalText(154284)
  self.defTitleText:SetLocalText(154285)
  self.skillTxt:SetLocalText(150001)
end

local function DataDefine(self)
  self.heroSpineLoadRequest = nil
  self.heroUpgradeState = -1
  self.curPageType = nil
  self.gotoEquipPageCallBack = BindCallback(self, GotoEquipPage)
  self.curSelectedSkillIndex = nil
  self.selectSkillCallBack = BindCallback(self, self.SelectSkillData)
  self.lastSpinePath = nil
  self.gotoSkillDetailPageCallBack = BindCallback(self, GoToSkillDetialPage)
  self.gotoSkillDetailPageAndUnlockCallBack = BindCallback(self, GoToSkillDetailPageAndUnlock)
  self.hasSetHeroData = false
end

local function ComponentDestroy(self)
  self.btnClose = nil
  self.gotoFirstViewBg = nil
  self.btnPreViewClose = nil
  self.btnPreCloseText = nil
  self.qualityIcon = nil
  self.nameText = nil
  self.nickNameText = nil
  self.heroSpineContainer = nil
  self.heroSkillList = nil
  self.heroSkill1 = nil
  self.heroSkill2 = nil
  self.heroSkill3 = nil
  self.heroSkill4 = nil
  self.heroSkills = nil
  self.heroLevelText = nil
  self.atkNumberText = nil
  self.hpNumberText = nil
  self.defNumberText = nil
  self.atkInfoBtn = nil
  self.hpInfoBtn = nil
  self.defInfoBtn = nil
  self.prevHeroBtn = nil
  self.nextHeroBtn = nil
  if self.heroSpineLoadRequest ~= nil then
    self.heroSpineLoadRequest:Destroy()
    self.heroSpineLoadRequest = nil
  end
  self.centerBottomInfo = nil
  self.templateHeroContainer = nil
  self.templateHeroGotoBtn = nil
  self.templateHeroGotoBtnText = nil
  self.templateHeroText = nil
  self.heroDragArea = nil
  self.bgImg = nil
  self.bgIconImg = nil
  self.contentBgImg = nil
  self.contentBgIconImg = nil
  self.centerQualityImg = nil
  self.heroTypeIcon = nil
  self.heroExhibitPreviewPage = nil
  self.skillPreviewPage = nil
  self.pages = nil
  self.heroExhibitPreviewPageToggle = nil
  self.skillPreviewPageToggle = nil
  self.pageToggles = nil
  self.hpTitleText = nil
  self.atkTitleText = nil
  self.defTitleText = nil
  self.scrollUIEventListener = nil
  self.scrollRectCenter = nil
end

local function DataDestroy(self)
  self.eventHandler = nil
  self.curTabIndex = 0
  self.curHeroUuid = nil
  self.callBack = nil
  self.heroTemplateData = nil
  self.expBookQualityList = nil
  self.heroUpgradeState = nil
  self.upgradeLevel = nil
  self.upgradePower = nil
  self.upgradeAtk = nil
  self.upgradeHp = nil
  self.upgradeDef = nil
  self.lastPower = nil
  self.lastAtk = nil
  self.lastHp = nil
  self.lastDef = nil
  self.gotoEquipPageCallBack = nil
  self.curPageType = nil
  self.curSelectedSkillIndex = nil
  self.lastSpinePath = nil
  self.selectSkillCallBack = nil
  self.gotoSkillDetailPageCallBack = nil
  self.cachedLayerTransform = nil
  self.gotoSkillDetailPageAndUnlockCallBack = nil
  self.hasSetHeroData = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
  if self.isPreview == true then
    EventManager:GetInstance():Broadcast(EventId.ToggleRecruitScene, false)
  end
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
  if self.isPreview == true then
    EventManager:GetInstance():Broadcast(EventId.ToggleRecruitScene, true)
  end
end

local function RefreshHeroSkills(self)
  for i = 1, 4 do
    local skillData = self.heroData:GetHeroSkillBySlotIndex(i)
    local skillShowRedPoint = false
    if skillData ~= nil and not self.isTemplateHero and not self.isPreview then
      skillShowRedPoint = self.heroData:IsSkillCanUpgrade(skillData)
    end
    self.heroSkills[i]:SetData(skillData, {showSkillName = false, showSkillLevel = true}, self.selectSkillCallBack, false, skillShowRedPoint)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.heroSkillList.transform)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.HeroLvUpSuccess, self.RefreshPage)
  self:AddUIListener(EventId.HeroBeyondSuccess, self.RefreshPage)
  self:AddUIListener(EventId.HeroSkillUnlockBack, self.RefreshPage)
  self:AddUIListener(EventId.SkillUpgradeEnd, self.RefreshPage)
  self:AddUIListener(EventId.HeroEquipInstall, self.RefreshPage)
  self:AddUIListener(EventId.HeroEquipUninstall, self.RefreshPage)
  self:AddUIListener(EventId.HeroEquipUpgrade, self.RefreshPage)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.HeroLvUpSuccess, self.RefreshPage)
  self:RemoveUIListener(EventId.HeroBeyondSuccess, self.RefreshPage)
  self:RemoveUIListener(EventId.HeroSkillUnlockBack, self.RefreshPage)
  self:RemoveUIListener(EventId.SkillUpgradeEnd, self.RefreshPage)
  self:RemoveUIListener(EventId.HeroEquipInstall, self.RefreshPage)
  self:RemoveUIListener(EventId.HeroEquipUninstall, self.RefreshPage)
  self:RemoveUIListener(EventId.HeroEquipUpgrade, self.RefreshPage)
end

local function OnOpen(self)
  self.curHeroIndex = table.indexof(self.heroUuidList, self.curHeroUuid)
  self.hasSetHeroData = false
  self:RefreshPage()
  self:CheckPageToggle()
  self:SelectSkill(1)
  self:RefreshSkillFrame(false)
  GoToPage(self, HeroDetailPageType.HeroExhibit)
end

local skillItemWidth = 85

local function SetHeroType(self, heroType)
  if heroType == nil then
    heroType = 1
  end
  heroType = math.min(heroType, 3)
  heroType = math.max(heroType, 1)
  self.heroTypeIcon:LoadSprite(string.format("Assets/Main/Sprites/UI/UILWHeroDetail/cfm_yingxiong_bingzhong_%d.png", heroType))
  self.heroTypeIcon:SetNativeSize()
end

local function SetHeroQuality(self, quality)
  if quality == nil then
    quality = 1
  end
  quality = math.min(quality, 5)
  quality = math.max(quality, 1)
  self.qualityIcon:LoadSprite(HeroUtils.GetHeroQualityTagImg(self.heroData.quality))
  self.qualityIcon:SetNativeSize()
  local qualityColor = UIUtil.GetColorByQuality(self.heroData.quality)
  self.bgImg:LoadSprite(HeroExhibitBgPath[quality])
  self.bgIconImg:LoadSprite(HeroExhibitBgIcPath[quality])
  local qualityColor = HeroExhibitBgColorQuality1
  if quality == 1 then
    qualityColor = HeroExhibitBgColorQuality1
  elseif quality == 2 then
    qualityColor = HeroExhibitBgColorQuality2
  elseif quality == 3 then
    qualityColor = HeroExhibitBgColorQuality3
  elseif quality == 4 then
    qualityColor = HeroExhibitBgColorQuality4
  elseif quality == 5 then
    qualityColor = HeroExhibitBgColorQuality5
  end
  self.contentBgImg:SetColor(qualityColor)
  self.contentBgIconImg:SetColor(qualityColor)
  if quality == 1 then
    self.centerQualityImg:SetActive(false)
  else
    self.centerQualityImg:SetActive(false)
    self.centerQualityImg:LoadSprite(string.format("Assets/Main/Sprites/UI/UILWHeroDetail/cfm_yingxiong_kuang_%d.png", quality))
  end
end

local function CheckPageToggle(self)
  if self.heroData == nil then
    return
  end
  if self.isTemplateHero == true or self.isPreview == true then
    self.enableEquipFunction = false
    self.scrollRectCenter:Init(0, 0)
    self.scrollRectCenter:CenterOn(1)
    return
  end
  self.scrollRectCenter:Init(0, 0)
  if self.enableEquipFunction == false then
    self.scrollRectCenter:CenterOn(1)
  else
    self.scrollRectCenter:CenterOn(2)
  end
end

local function RefreshHeroBaseInfo(self)
  if self.heroData == nil then
    return
  end
  if self.curPageType == HeroDetailPageType.SkillPreview or self.curPageType == HeroDetailPageType.SkillDetail then
    self.equipAddHpText:SetActive(false)
    self.equipAddAtkText:SetActive(false)
    self.equipAddDefText:SetActive(false)
    self.upgradeAtk = self.heroData:GetAtk()
    self.upgradeHp = self.heroData:GetMaxHp()
    self.upgradeDef = self.heroData:GetDef()
    self.lastAtk = self.upgradeAtk
    self.lastHp = self.upgradeHp
    self.lastDef = self.upgradeDef
    self.atkNumberText:SetText(string.GetFormattedStr(self.upgradeAtk))
    self.hpNumberText:SetText(string.GetFormattedStr(self.upgradeHp))
    self.defNumberText:SetText(string.GetFormattedStr(self.upgradeDef))
  else
    self.upgradeAtk = self.heroData:GetProperty(HeroEffectDefine.Hero_ATK_Result)
    self.upgradeHp = self.heroData:GetProperty(HeroEffectDefine.Hero_HP_Result)
    self.upgradeDef = self.heroData:GetProperty(HeroEffectDefine.Hero_DEF_Result)
    self.lastAtk = self.upgradeAtk
    self.lastHp = self.upgradeHp
    self.lastDef = self.upgradeDef
    self.atkNumberText:SetText(string.GetFormattedStr(self.upgradeAtk))
    self.hpNumberText:SetText(string.GetFormattedStr(self.upgradeHp))
    self.defNumberText:SetText(string.GetFormattedStr(self.upgradeDef))
    local equipAddHp = self.heroData:GetProperty(HeroEffectDefine.Equip_HP_Result)
    equipAddHp = math.floor(equipAddHp)
    local equipAddAtk = self.heroData:GetProperty(HeroEffectDefine.Equip_ATK_Result)
    equipAddAtk = math.floor(equipAddAtk)
    local equipAddDef = self.heroData:GetProperty(HeroEffectDefine.Equip_DEF_Result)
    equipAddDef = math.floor(equipAddDef)
    self.equipAddHpText:SetActive(true)
    self.equipAddAtkText:SetActive(true)
    self.equipAddDefText:SetActive(true)
    self.equipAddHpText:SetText("+" .. string.GetFormattedStr(equipAddHp))
    self.equipAddAtkText:SetText("+" .. string.GetFormattedStr(equipAddAtk))
    self.equipAddDefText:SetText("+" .. string.GetFormattedStr(equipAddDef))
  end
end

local function RefreshPage(self)
  self.heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.curHeroUuid)
  if self.heroData == nil then
    local itemTemplateData = DataCenter.HeroTemplateManager:GetTemplate(self.curHeroUuid)
    if itemTemplateData ~= nil then
      if self.heroTemplateData == nil then
        self.heroTemplateData = HeroInfo.New()
      end
      self.heroTemplateData:UpdateFromTemplate(toInt(itemTemplateData.id), 1)
      self.heroData = self.heroTemplateData
      self.isTemplateHero = true
    else
      self.ctrl.CloseSelf()
    end
  else
    self.isTemplateHero = false
  end
  self.nameText:SetText(self.heroData:GetName())
  self.nickNameText:SetText(self.heroData:GetNickName())
  RefreshHeroBaseInfo(self)
  SetHeroType(self, self.heroData.heroType)
  SetHeroQuality(self, self.heroData.quality)
  if not self.hasSetHeroData then
    self.skillPreviewPage:SetData(self.heroData, self.curSelectedSkillIndex, self.gotoEquipPageCallBack, self.isPreview ~= true and self.isTemplateHero ~= true, false)
    self.heroExhibitPreviewPage:SetData(self.heroData)
    self.hasSetHeroData = true
  end
  local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(self.heroData.modelId)
  local spinePath = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_path")
  if self.lastSpinePath ~= spinePath then
    if self.heroSpineLoadRequest ~= nil then
      self.heroSpineLoadRequest:Destroy()
      self.heroSpineLoadRequest = nil
    end
    local request = ResourceManager:InstantiateAsync(spinePath)
    self.heroSpineLoadRequest = request
    request:completed("+", function()
      if request.isError or request.gameObject == nil then
        self.heroSpineLoadRequest = nil
        return
      end
      request.gameObject:SetActive(true)
      local rectTransform = request.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
      if rectTransform ~= nil then
        local spineScale = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_scale")
        local spinePos = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_pos")
        rectTransform:SetParent(self.heroSpineContainer.transform)
        rectTransform:Set_localScale(spineScale, spineScale, 1)
        rectTransform:Set_anchoredPosition(spinePos[1], spinePos[2], 0)
      end
    end)
    self.lastSpinePath = spinePath
  end
  self.centerBottomInfo:SetActive(false)
  self.btnClose:SetActive(true)
  self.btnPreViewClose:SetActive(false)
  self.heroLevelText:SetText(self.heroData.level)
  RefreshHeroSkills(self)
  if self.isTemplateHero == true then
    if self.showFunctionBtn == true or self.showFunctionBtn == nil then
      self.templateHeroContainer:SetActive(true)
    else
      self.templateHeroContainer:SetActive(false)
    end
  elseif self.isPreview == true then
    self.btnPreViewClose:SetActive(true)
    self.btnPreCloseText:SetLocalText(800326)
  else
    self.templateHeroContainer:SetActive(false)
  end
  self:CheckArrowBtns()
end

local function CheckArrowBtns(self)
  local index = self.curHeroIndex
  local hasLeft = false
  local hasRight = false
  hasLeft = self.heroUuidList[index - 1] ~= nil
  hasRight = self.heroUuidList[index + 1] ~= nil
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
  local index = self.curHeroIndex + (isLeft and -1 or 1)
  local heroUuid = self.heroUuidList[index]
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
  if heroData ~= nil then
    DataCenter.HeroDataManager:RemoveNewHeroTag(heroUuid)
  end
  self.curHeroUuid = heroUuid
  self.curHeroIndex = index
  self.hasSetHeroData = false
  self.CloseSkillSimpleTipWindow()
  self:SelectSkill(1)
  self:RefreshPage()
  self:RefreshSkillFrame(false)
  CheckPageToggle(self)
end

local function CloseSkillSimpleTipWindow(self)
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIHeroSkillSimpleTip)
  if window ~= nil then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroSkillSimpleTip)
  end
end

local function OnBtnCloseClick(self)
  if self.callBack ~= nil then
    self.callBack()
  end
  self.ctrl.CloseSelf()
end

local function OnGotoFirstViewBgClick(self)
  if self.curPageType ~= HeroDetailPageType.HeroExhibit then
    self.scrollRectCenter:CenterOnAnim(1, 0.5)
    self:GoToPage(HeroDetailPageType.HeroExhibit)
  end
end

local function OnHeroUpgradeBtnClick(self)
  local heroLevelLimit = DataCenter.BuildManager.MainLv * DataCenter.HeroParamDataManager.heroLevelLimitByCityLevel
  if heroLevelLimit <= self.heroData.level then
    UIUtil.ShowTipsId(151105)
    return
  end
  local needExp = HeroUtils.GetLevelUpNeedExp(self.heroData.level)
  local hasEnoughExp, expCount = self.ctrl:CheckItemsCanToNextLv(self.heroData.exp, needExp)
  if not hasEnoughExp then
    LWResourceLackUtil:GotoGoodsItemLack(200390, 1)
    return
  end
  local needResources = {}
  local costResources = HeroUtils.GetLevelUpCostResources(self.heroData.level)
  for resourceId, resourceNum in pairs(costResources) do
    local have = LuaEntry.Resource:GetCntByResType(resourceId)
    local cost = resourceNum
    if have < cost then
      table.insert(needResources, {resType = resourceId, need = cost})
    end
  end
  if 0 < #needResources then
    LWResourceLackUtil:GotoResLack(needResources)
    return
  end
  self.expBookQualityList = self.ctrl:AutoUseExpItems(self.curHeroUuid)
end

local function SelectSkillData(self, skillData, skillItem)
  if skillData == nil then
    return
  end
  self:SelectSkill(skillData.slotIndex)
  self:RefreshSkillFrame(true)
  if self.curPageType ~= HeroDetailPageType.SkillPreview then
    self.scrollRectCenter:CenterOnAnim(2, 0.5)
    self:GoToPage(HeroDetailPageType.SkillPreview)
  end
end

local function SelectSkill(self, skillSlotIndex)
  if skillSlotIndex == nil then
    return
  end
  if skillSlotIndex == self.curSelectedSkillIndex then
    return
  end
  self.curSelectedSkillIndex = skillSlotIndex
  self.skillPreviewPage:SetData(self.heroData, self.curSelectedSkillIndex, self.gotoEquipPageCallBack, self.isPreview ~= true and self.isTemplateHero ~= true, true)
end

local function RefreshSkillFrame(self, isShow)
  for i = 1, 4 do
    self.heroSkills[i]:SetSelected(isShow and i == self.curSelectedSkillIndex)
  end
end

local function OnSkillItemClick(self, skillData)
  if skillData == nil then
    return
  end
  local slotIndex = skillData:GetSlotIndex()
end

UIHeroExhibitPanelView.OnCreate = OnCreate
UIHeroExhibitPanelView.OnDestroy = OnDestroy
UIHeroExhibitPanelView.OnEnable = OnEnable
UIHeroExhibitPanelView.OnDisable = OnDisable
UIHeroExhibitPanelView.OnAddListener = OnAddListener
UIHeroExhibitPanelView.OnRemoveListener = OnRemoveListener
UIHeroExhibitPanelView.ComponentDefine = ComponentDefine
UIHeroExhibitPanelView.DataDefine = DataDefine
UIHeroExhibitPanelView.ComponentDestroy = ComponentDestroy
UIHeroExhibitPanelView.DataDestroy = DataDestroy
UIHeroExhibitPanelView.OnOpen = OnOpen
UIHeroExhibitPanelView.OnBtnCloseClick = OnBtnCloseClick
UIHeroExhibitPanelView.OnGotoFirstViewBgClick = OnGotoFirstViewBgClick
UIHeroExhibitPanelView.CheckArrowBtns = CheckArrowBtns
UIHeroExhibitPanelView.OnArrowBtnClick = OnArrowBtnClick
UIHeroExhibitPanelView.RefreshPage = RefreshPage
UIHeroExhibitPanelView.OnHeroUpgradeBtnClick = OnHeroUpgradeBtnClick
UIHeroExhibitPanelView.OnSkillItemClick = OnSkillItemClick
UIHeroExhibitPanelView.GoToPage = GoToPage
UIHeroExhibitPanelView.ScrollGoToPage = ScrollGoToPage
UIHeroExhibitPanelView.SelectSkill = SelectSkill
UIHeroExhibitPanelView.SelectSkillData = SelectSkillData
UIHeroExhibitPanelView.RefreshHeroBaseInfo = RefreshHeroBaseInfo
UIHeroExhibitPanelView.CheckPageToggle = CheckPageToggle
UIHeroExhibitPanelView.CloseSkillSimpleTipWindow = CloseSkillSimpleTipWindow
UIHeroExhibitPanelView.RefreshSkillFrame = RefreshSkillFrame
return UIHeroExhibitPanelView
