local UITacticalWeaponChipPlanView = BaseClass("UITacticalWeaponChipPlanView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local TacticalChipPlanTabItem = require("UI.UILWTacticalWeaponChip.Component.TacticalChipPlanTabItem")
local SkillChipManageSmallItem = require("UI.UILWTWSkillChip.UILWTWSkillChipManage.Component.SkillChipManageSmallItem")
local TacticalChipItem = require("UI.UILWTacticalWeaponChip.Component.TacticalChipItem")
local HeroSquadModelViewer = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.HeroSquadModelViewer")
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")
local hero_squad_bg_path = "Bottom/bottom/noramlNode/teamNode/HeroSquadBg"
local middle_sp_bg_path = "Top/chipPanel/chipItemNode/middle/middleSpBg"
local power_info_title_path = "Bottom/bottom/noramlNode/PowerInfo/PowerInfoTitle"
local SQUAD_BG_PATH_STR = "Assets/Main/TextureEx/UILWHeroSquad/biandui_cheku_%s.png"
local TAB_COUNT = 4
local APPEARANCE_ID = 40020
local AnimationNames = {
  Idle = "V_ui_TacticalChipPlanTabPlan_idle",
  Open = "V_ui_TacticalChipPlanTabPlan_in",
  Tab = "V_ui_UITacticalWeaponChipPlan_tabroot_in",
  Switch = "V_ui_UITacticalWeaponChipPlan_switch"
}
local TabAnimationName = "V_ui_skillchippage_tabroot_in"

function UITacticalWeaponChipPlanView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:VfxPreLoad()
  self:InitTabList()
  self:InitChipItem()
end

function UITacticalWeaponChipPlanView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITacticalWeaponChipPlanView:SetData(weaponInfo, defaultTabId)
  self.defaultTabId = defaultTabId or 1
  self:RefreshTabList()
  self:RefreshRedPoints()
  self:RefreshChipBoxProps()
  self.animator:Play(AnimationNames.Open)
  self.compVfxRing:PlayByOnce(VfxAssets.TacticalChipPlanKeJiRing)
  self.compVfxBg:PlayByStay(VfxAssets.TacticalChipPlanBG)
  self.compVfxBgRing:PlayByStay(VfxAssets.TacticalChipPlanRingBG)
end

function UITacticalWeaponChipPlanView:ComponentDefine()
  self.btnClose = self:AddComponent(UIButton, "closeBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnDetail = self:AddComponent(UIButton, "RightTopBtns/detailBtn")
  self.btnDetail:SetOnClick(function()
    self:OnBtnDetailClick()
  end)
  self.btnGuarantBox = self:AddComponent(UIButton, "RightTopBtns/GuarantBoxBtn")
  self.btnGuarantBox:SetOnClick(function()
    self:OnBtnGuarantBoxClick()
  end)
  self.guarantBoxRedPoint = self:AddComponent(UIBaseContainer, "RightTopBtns/GuarantBoxBtn/GuarantBoxRedPoint")
  self.compTabRoot = self:AddComponent(UIBaseContainer, "Bottom/tabRoot")
  self.tabRootAni = self:AddComponent(UIAnimator, "Bottom/tabRoot")
  self.compVfxSwitch = self:AddComponent(UIVfx, "Top/chipPanel/vfxSwitch")
  self.compVfxBg = self:AddComponent(UIVfx, "Top/vfxBg")
  self.compVfxRing = self:AddComponent(UIVfx, "Top/chipPanel/vfxRing")
  self.compVfxBgRing = self:AddComponent(UIVfx, "Top/chipPanel/vfxBgRing")
  self.compChipItems = self:AddComponent(UIBaseContainer, "Top/chipPanel/chipItems")
  self.compLockNode = self:AddComponent(UIBaseContainer, "Bottom/bottom/lockNode")
  self.compNormalNode = self:AddComponent(UIBaseContainer, "Bottom/bottom/noramlNode")
  self.textQualityUpTip = self:AddComponent(UIText, "Bottom/bottom/lockNode/qualityUpTip")
  self.heroSpineNode = self:AddComponent(UIBaseContainer, "Bottom/bottom/lockNode/heroSpineNode")
  self.compTeamNode = self:AddComponent(UIBaseContainer, "Bottom/bottom/noramlNode/teamNode")
  self.compNoneNode = self:AddComponent(UIBaseContainer, "Bottom/bottom/noramlNode/noneNode")
  self.hero_squad_bg = self:AddComponent(UIRawImage, hero_squad_bg_path)
  self.heroSquadRT = self:AddComponent(HeroSquadModelViewer, "Bottom/bottom/noramlNode/teamNode/HeroSquadRT")
  self.textNoneQuqueTip = self:AddComponent(UIText, "Bottom/bottom/noramlNode/noneNode/noneQuqueTip")
  self.textNoneQuqueTip:SetLocalText("battlesystem_chip_squad_desc1")
  self.textChipGroupName = self:AddComponent(UIText, "Bottom/bottom/noramlNode/chipGroupName")
  self.textPowerNumber = self:AddComponent(UIText, "Bottom/bottom/noramlNode/PowerInfo/PowerNumberText")
  self.powerInfoTitle = self:AddComponent(UITextMeshProUGUIEx, power_info_title_path)
  self.powerInfoTitle:SetLocalText("battlesystem_chip_squad_desc3")
  self.btnChangeQueue = self:AddComponent(UIButton, "Bottom/bottom/noramlNode/changeQueueBtn")
  self.btnChangeQueue:SetOnClick(function()
    self:OnBtnChangeQueueClick()
  end)
  self.textChangeQueueBtn = self:AddComponent(UIText, "Bottom/bottom/noramlNode/changeQueueBtn/Btn/changeQueueBtnText")
  self.textChangeQueueBtn:SetLocalText("battlesystem_chip_squad_button1")
  self.compUnlockTipPanel = self:AddComponent(UIBaseContainer, "Top/unlockTipPanel")
  self.compChipPanel = self:AddComponent(UIBaseContainer, "Top/chipPanel")
  self.btnGoto = self:AddComponent(UIButton, "Top/unlockTipPanel/gotoBtn")
  self.btnGoto:SetOnClick(function()
    self:OnBtnGotoClick()
  end)
  self.textUnlockTipDesc = self:AddComponent(UIText, "Top/unlockTipPanel/unlockTipDesc")
  self.textGotoBtn = self:AddComponent(UIText, "Top/unlockTipPanel/gotoBtn/Btn/gotoBtnText")
  self.textGotoBtn:SetLocalText("battlesystem_chip_button1")
  self.middle_sp_bg = self:AddComponent(UIImage, middle_sp_bg_path)
  self.middle_sp_bg:SetActive(false)
  self.compMiddleVfxNode = self:AddComponent(UIBaseContainer, "Top/chipPanel/chipItemNode/middle")
  self.compRightVfxNode = self:AddComponent(UIBaseContainer, "Top/chipPanel/chipItemNode/right")
  self.compLeftVfxNode = self:AddComponent(UIBaseContainer, "Top/chipPanel/chipItemNode/left")
  self.compUpVfxNode = self:AddComponent(UIBaseContainer, "Top/chipPanel/chipItemNode/up")
  local middleVfxNode = self:AddComponent(UIVfx, "Top/chipPanel/chipItemNode/middle/middleVfxNode", VfxAssets.TacticalChipPlanRadarFind)
  local rightVfxNode = self:AddComponent(UIVfx, "Top/chipPanel/chipItemNode/right/rightVfxNode", VfxAssets.TacticalChipPlanRadarFindSimple)
  local leftVfxNode = self:AddComponent(UIVfx, "Top/chipPanel/chipItemNode/left/leftVfxNode", VfxAssets.TacticalChipPlanRadarFindSimple)
  local upVfxNode = self:AddComponent(UIVfx, "Top/chipPanel/chipItemNode/up/upVfxNode", VfxAssets.TacticalChipPlanRadarFindSimple)
  local middleRedDot = self:AddComponent(UIBaseContainer, "Top/chipPanel/chipItemNode/middle/middleRedDot")
  local rightRedDot = self:AddComponent(UIBaseContainer, "Top/chipPanel/chipItemNode/right/rightRedDot")
  local leftRedDot = self:AddComponent(UIBaseContainer, "Top/chipPanel/chipItemNode/left/leftRedDot")
  local upRedDot = self:AddComponent(UIBaseContainer, "Top/chipPanel/chipItemNode/up/upRedDot")
  self.chipSetupNodeMap = {}
  self.chipSetupNodeMap[TacticalChipType.Opening] = {
    node = self.compMiddleVfxNode,
    vfx = middleVfxNode,
    redDot = middleRedDot
  }
  self.chipSetupNodeMap[TacticalChipType.Attack] = {
    node = self.compUpVfxNode,
    vfx = upVfxNode,
    redDot = upRedDot
  }
  self.chipSetupNodeMap[TacticalChipType.Disturb] = {
    node = self.compLeftVfxNode,
    vfx = leftVfxNode,
    redDot = leftRedDot
  }
  self.chipSetupNodeMap[TacticalChipType.Defend] = {
    node = self.compRightVfxNode,
    vfx = rightVfxNode,
    redDot = rightRedDot
  }
  self.btnLeftChipBg = self:AddComponent(UIButton, "Top/chipPanel/bgNode/leftChipBg/leftChipBgBtn")
  self.btnLeftChipBg:SetOnClick(function()
    self:OnChipBgBtnClick(TacticalChipType.Disturb)
  end)
  self.btnRightChipBg = self:AddComponent(UIButton, "Top/chipPanel/bgNode/rightChipBg/rightChipBgBtn")
  self.btnRightChipBg:SetOnClick(function()
    self:OnChipBgBtnClick(TacticalChipType.Defend)
  end)
  self.btnTopChipBg = self:AddComponent(UIButton, "Top/chipPanel/bgNode/topChipBg/topChipBgBtn")
  self.btnTopChipBg:SetOnClick(function()
    self:OnChipBgBtnClick(TacticalChipType.Attack)
  end)
  self.btnMiddleChipBg = self:AddComponent(UIButton, "Top/chipPanel/bgNode/middleChipBg/middleChipBgBtn")
  self.btnMiddleChipBg:SetOnClick(function()
    self:OnChipBgBtnClick(TacticalChipType.Opening)
  end)
  self.compRightLineVfx = self:AddComponent(UIVfx, "Top/chipPanel/bgNode/lineNode/rightLineVfx", VfxAssets.TacticalChipPlanDianLiu_Right, {
    lifeType = UIVfxLifeType.Stay
  })
  self.compLeftLineVfx = self:AddComponent(UIVfx, "Top/chipPanel/bgNode/lineNode/leftLineVfx", VfxAssets.TacticalChipPlanDianLiu_Left, {
    lifeType = UIVfxLifeType.Stay
  })
  self.compTopLineVfx = self:AddComponent(UIVfx, "Top/chipPanel/bgNode/lineNode/topLineVfx", VfxAssets.TacticalChipPlanDianLiu_Top, {
    lifeType = UIVfxLifeType.Stay
  })
  self.lineVfxMap = {}
  self.lineVfxMap[TacticalChipType.Attack] = self.compTopLineVfx
  self.lineVfxMap[TacticalChipType.Disturb] = self.compLeftLineVfx
  self.lineVfxMap[TacticalChipType.Defend] = self.compRightLineVfx
  self.animator = self:AddComponent(UIAnimator, "")
  self.btnReset = self:AddComponent(UIButton, "RightTopBtns/resetBtn")
  self.btnReset:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSkillChipReset, {anim = true})
  end)
  self.textResetBtn = self:AddComponent(UIText, "RightTopBtns/resetBtn/resetBtnText")
  self.textResetBtn:SetLocalText("drone_skillChip_title_5")
  self.factoryBtn = self:AddComponent(UIButton, "RightTopBtns/factoryBtn")
  self.factoryBtn:SetOnClick(function()
    self:OnFactoryBtnClick()
  end)
end

function UITacticalWeaponChipPlanView:ComponentDestroy()
  self.btnClose = nil
  self.btnDetail = nil
  self.btnGuarantBox = nil
  self.guarantBoxRedPoint = nil
  self.compTabRoot = nil
  self.tabRootAni = nil
  self.compVfxSwitch = nil
  self.compVfxRing = nil
  self.compVfxBgRing = nil
  self.compChipItems = nil
  self.compLockNode = nil
  self.compNormalNode = nil
  self.textQualityUpTip = nil
  self.heroSpineNode = nil
  self.compTeamNode = nil
  self.compNoneNode = nil
  self.rawImgRawImage = nil
  self.textNoneQuqueTip = nil
  self.textChipGroupName = nil
  self.textPowerNumber = nil
  self.btnChangeQueue = nil
  self.textChangeQueueBtn = nil
  self.compUnlockTipPanel = nil
  self.compChipPanel = nil
  self.btnGoto = nil
  self.textUnlockTipDesc = nil
  self.textGotoBtn = nil
  self.compMiddleVfxNode = nil
  self.compRightVfxNode = nil
  self.compLeftVfxNode = nil
  self.compUpVfxNode = nil
  self.btnLeftChipBg = nil
  self.btnRightChipBg = nil
  self.btnTopChipBg = nil
  self.btnMiddleChipBg = nil
  self.btnReset = nil
  self.textResetBtn = nil
end

function UITacticalWeaponChipPlanView:DataDefine()
  self.tabReqList = {}
  self.chipReqList = {}
  self.tabItemList = {}
  self.chipItemDic = {}
end

function UITacticalWeaponChipPlanView:DataDestroy()
  if self.chipSetupNodeMap then
    for i, v in pairs(self.chipSetupNodeMap) do
      if v and v.node then
        v.node:RemoveComponents(TacticalChipItem)
      end
    end
  end
  self.compTabRoot:RemoveComponents(TacticalChipPlanTabItem)
  self.tabReqList = nil
  self.chipReqList = nil
  self.chipSetupNodeMap = nil
  self.tabItemList = nil
  self.chipItemDic = nil
  self.curChipGroupData = nil
  self.lineVfxMap = nil
  if self.heroSpineLoadRequest ~= nil then
    self.heroSpineLoadRequest:Destroy()
    self.heroSpineLoadRequest = nil
  end
end

function UITacticalWeaponChipPlanView:VfxPreLoad()
  self.compVfxSwitch:PreLoad(VfxAssets.TacticalChipPlanKeJiSwitch)
end

function UITacticalWeaponChipPlanView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.TWSkillUpdate, self.OnChipSetupUpdate)
  self:AddUIListener(EventId.TWSkillChipStarUp, self.OnChipStarUpgrade)
  self:AddUIListener(EventId.ArmyFormatUpdate, self.OnSquadChange)
  self:AddUIListener(EventId.RefreshItems, self.RefreshChipBoxProps)
end

function UITacticalWeaponChipPlanView:OnRemoveListener()
  self:RemoveUIListener(EventId.TWSkillUpdate, self.OnChipSetupUpdate)
  self:RemoveUIListener(EventId.TWSkillChipStarUp, self.OnChipStarUpgrade)
  self:RemoveUIListener(EventId.ArmyFormatUpdate, self.OnSquadChange)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshChipBoxProps)
  base.OnRemoveListener(self)
end

function UITacticalWeaponChipPlanView:OnChipSetupUpdate()
  if self.curTab == nil then
    return
  end
  local newGroupData = DataCenter.TacticalChipManager:GetPlanChips(self.curTab.tabId)
  if self.curChipGroupData ~= nil then
    for pos, v in pairs(self.chipSetupNodeMap) do
      if newGroupData[pos] ~= nil and (self.curChipGroupData[pos] == nil or self.curChipGroupData[pos]:GetUUID() ~= newGroupData[pos]:GetUUID()) then
        v.vfx:Replay()
      end
    end
  end
  self.curChipGroupData = newGroupData
  self:RefreshChipItems()
  self:RefreshPlanDefaultName()
  self:RefreshRedPoints()
end

function UITacticalWeaponChipPlanView:OnChipStarUpgrade()
  if self.chipItemDic then
    for i, v in pairs(self.chipItemDic) do
      if v then
        v:Refresh()
        v:SetChipTypeVisible(true)
        v:SetPlanMasterVisible(false)
      end
    end
  end
  self:RefreshRedPoints()
end

function UITacticalWeaponChipPlanView:OnSquadChange()
  self:RefreshSquad()
end

function UITacticalWeaponChipPlanView:RefreshChipBoxProps()
  self.guarantBoxRedPoint:SetActive(TacticalWeaponUtils.GuarantBoxShowRedPoint())
end

function UITacticalWeaponChipPlanView:InitTabList()
  for i = 1, TAB_COUNT do
    self.tabReqList = self:CreateTabItem(i)
  end
end

function UITacticalWeaponChipPlanView:InitChipItem()
  for k, v in pairs(self.chipSetupNodeMap) do
    self.chipReqList = self:CreateChipItem(k)
  end
end

function UITacticalWeaponChipPlanView:CreateTabItem(index)
  return self:GameObjectInstantiateAsync(UIAssets.TacticalChipPlanTabItem, function(request)
    local go = request.gameObject
    if IsNull(go) then
      return
    end
    go.gameObject:SetActive(false)
    go.transform:SetParent(self.compTabRoot.transform)
    go.transform:Set_localScale(1, 1, 1)
    go.name = "TacticalChipPlanTabItem" .. index
    local cell = self.compTabRoot:AddComponent(TacticalChipPlanTabItem, go.name)
    local param = {}
    param.tabId = index
    param.title = index
    param.clickHandler = self.OnTabClick
    param.customHolder = self
    cell:ReInit(param)
    if self.defaultTabId == index then
      self:OnTabClick(cell)
    else
      cell:SetSelect(false)
    end
    table.insert(self.tabItemList, cell)
    if self.tabItemList and #self.tabItemList == TAB_COUNT then
      for i, v in ipairs(self.tabItemList) do
        if v then
          v:SetActive(true)
        end
      end
      self:RefreshRedPoints()
      self.tabRootAni:Rebind()
      self.tabRootAni:Play(TabAnimationName)
    end
  end)
end

function UITacticalWeaponChipPlanView:CreateChipItem(pos)
  return self:GameObjectInstantiateAsync(UIAssets.TacticalChipItem, function(request)
    local go = request.gameObject
    if IsNull(go) then
      return
    end
    local root = self.chipSetupNodeMap[pos].node
    go.gameObject:SetActive(false)
    go.transform:SetParent(root.transform)
    go.transform:Set_localScale(1, 1, 1)
    go.name = "ChipItem" .. pos
    local cell = root:AddComponent(TacticalChipItem, go.name)
    cell:SetPivotMiddle()
    cell:SetLocalPositionXYZ(0, 0, 0)
    if pos == TacticalChipType.Opening then
      cell:SetLocalScaleXYZ(1.1, 1.1, 1.1)
    else
      cell:SetLocalScaleXYZ(1, 1, 1)
    end
    self.chipItemDic[pos] = cell
    if self.curChipGroupData and self.curChipGroupData[pos] then
      cell:SetData(self.curChipGroupData[pos])
      cell:SetActive(true)
      local replaceRedDot = TacticalWeaponUtils.SkillChipCanReplace(self.curChipGroupData[pos])
      local starUpRedDot = TacticalWeaponUtils.SkillChipCanStarUp(self.curChipGroupData[pos])
      cell:SetRedDotVisible(starUpRedDot or replaceRedDot)
    else
      cell:SetActive(false)
    end
    cell:SetChipTypeVisible(true)
    cell:SetPlanMasterVisible(false)
    local loadNum = 0
    for i, v in pairs(self.chipItemDic) do
      loadNum = loadNum + 1
    end
    if loadNum == 4 then
      self:CheckFirstChipPlanShowGuide()
    end
  end)
end

function UITacticalWeaponChipPlanView:OnChipSetup(param)
  local type = param.type
  self.chipSetupNodeMap[type]:Replay()
end

function UITacticalWeaponChipPlanView:OnBtnGotoClick()
  if self.holder then
    self.holder:SelectPage(TacticalWeaponPageType.SkillChip)
  end
end

function UITacticalWeaponChipPlanView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UITacticalWeaponChipPlanView:OnBtnDetailClick()
end

function UITacticalWeaponChipPlanView:OnBtnGuarantBoxClick()
  local data = DataCenter.TWSkillChipManager:GetGuaranteedBoxData()
  if data then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWGuarantBox, {anim = true}, data.id)
  end
end

function UITacticalWeaponChipPlanView:OnBtnChangeQueueClick()
  if self.curTab then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalWeaponChipSquad, self.curTab.tabId)
  end
end

function UITacticalWeaponChipPlanView:OnTabClick(tabItem)
  if self.curTab ~= nil then
    if self.curTab.tabId == tabItem.tabId then
      return
    else
      self.curTab:SetSelect(false)
    end
  end
  if self.curTab ~= nil then
    self.animator:Play(AnimationNames.Switch)
    self.compVfxSwitch:Replay()
  end
  self.curTab = tabItem
  self.curTab:SetSelect(true)
  self:OnTabSwitch()
end

function UITacticalWeaponChipPlanView:OnTabSwitch()
  if self.curTab == nil or self.curTab.tabId == nil then
    return
  end
  self.curChipGroupData = DataCenter.TacticalChipManager:GetPlanChips(self.curTab.tabId)
  self:RefreshChipItems()
  self:RefreshSquad()
  self:RefreshRedPoints()
  self:PlaySwitchSound()
end

function UITacticalWeaponChipPlanView:RefreshChipItems()
  local hasOpeningData = self.curChipGroupData[TacticalChipType.Opening]
  for k, v in pairs(self.chipItemDic) do
    if v then
      local data = self.curChipGroupData[k]
      if data then
        local replaceRedDot = TacticalWeaponUtils.SkillChipCanReplace(data)
        local starUpRedDot = TacticalWeaponUtils.SkillChipCanStarUp(data)
        v:SetData(data)
        v:SetRedDotVisible(replaceRedDot or starUpRedDot)
        v:SetPlanMasterVisible(false)
        v:SetChipTypeVisible(true)
      end
      v:SetActive(data ~= nil)
      if k ~= TacticalChipType.Opening then
        if hasOpeningData and data ~= nil then
          self.lineVfxMap[k]:Replay()
        else
          self.lineVfxMap[k]:Stop()
        end
      end
    end
  end
  self.middle_sp_bg:SetActive(hasOpeningData)
end

function UITacticalWeaponChipPlanView:RefreshSquad()
  if self.curTab == nil then
    return
  end
  local planId = self.curTab.tabId
  local isUnlock = self.curTab:IsUnlock()
  if isUnlock then
    local squadIndex = TacticalWeaponUtils.GetUsingFormationByTypeAndSet(FormationDataType.ArmyFormation, planId)
    local hasHeroInfo = 0 < squadIndex
    if hasHeroInfo then
      local heroSquadInfo = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByIndex(squadIndex)
      local heroes = heroSquadInfo:GetLocalAllHeroes()
      local dominatorUuid = heroSquadInfo:GetLocalDominatorUuid()
      self.hero_squad_bg:LoadSprite(string.format(SQUAD_BG_PATH_STR, squadIndex))
      self.heroSquadRT:SetHeroesUuid(heroes, dominatorUuid)
      local totalCombatPower = heroSquadInfo:GetParkingTotalCapacity()
      self.textPowerNumber:SetText(string.GetFormattedStr2(totalCombatPower))
    else
      self.textPowerNumber:SetText("0")
    end
    self.compTeamNode:SetActive(hasHeroInfo)
    self.compNoneNode:SetActive(not hasHeroInfo)
  else
    local unlockLv = DataCenter.TacticalChipManager:GetPlanUnlockLevel(planId)
    local unlockTemplate = DataCenter.TacticalChipManager:GetLevelTemplate(unlockLv)
    local tierTemplate = DataCenter.TacticalChipManager:GetTierTemplate(unlockTemplate.system_tier)
    local colorStr = UIUtil.ConvertColorToString(tierTemplate.tier_color)
    local tierNameFormatStr = string.format("<color=%s>%s</color>", colorStr, Localization:GetString(tierTemplate.tier_name))
    self.textQualityUpTip:SetLocalText("battlesystem_chip_desc5", unlockLv, tierNameFormatStr)
    self.textUnlockTipDesc:SetLocalText("battlesystem_chip_desc4", tierNameFormatStr)
  end
  self:RefreshPlanDefaultName()
  self.compChipPanel:SetActive(isUnlock)
  self.compUnlockTipPanel:SetActive(not isUnlock)
  self.compLockNode:SetActive(not isUnlock)
  self.compNormalNode:SetActive(isUnlock)
  if not isUnlock then
    self:CreatHeroSpine()
  end
end

function UITacticalWeaponChipPlanView:RefreshPlanDefaultName()
  if self.curTab then
    local nameId, color = DataCenter.TacticalChipManager:GetPlanDefaultName(self.curTab.tabId)
    self.textChipGroupName:SetLocalText(nameId)
    self.textChipGroupName:SetColorRGBA255(color.r, color.g, color.b, color.a)
  end
end

function UITacticalWeaponChipPlanView:RefreshRedPoints()
  for planId = 1, 4 do
    local existPlanRedDot = false
    local planDataGroup = DataCenter.TacticalChipManager:GetPlanChips(planId)
    for pos = 1, 4 do
      local skillInfo = planDataGroup[pos]
      if skillInfo then
        local replaceRedDot = TacticalWeaponUtils.SkillChipCanReplace(skillInfo)
        local starUpRedDot = TacticalWeaponUtils.SkillChipCanStarUp(skillInfo)
        existPlanRedDot = existPlanRedDot or replaceRedDot or starUpRedDot
        if self.curTab and self.curTab.tabId == planId then
          if self.chipItemDic[pos] then
            self.chipItemDic[pos]:SetRedDotVisible(replaceRedDot or starUpRedDot)
          end
          self.chipSetupNodeMap[pos].redDot:SetActive(false)
        end
      else
        local list = TacticalWeaponUtils.GetFreeChipsByType(pos)
        existPlanRedDot = existPlanRedDot or 0 < #list
        if self.curTab and self.curTab.tabId == planId then
          self.chipSetupNodeMap[pos].redDot:SetActive(0 < #list)
        end
      end
    end
    if self.tabItemList then
      for _, tabItem in ipairs(self.tabItemList) do
        if tabItem and tabItem.tabId == planId then
          local isUnlock = DataCenter.TacticalChipManager:IsPlanUnlock(tabItem.tabId)
          tabItem:SetRedDotVisible(isUnlock and existPlanRedDot)
        end
      end
    end
  end
end

function UITacticalWeaponChipPlanView:RefreshTabList()
  if self.tabItemList then
    for _, tabItem in ipairs(self.tabItemList) do
      if tabItem then
        tabItem:RefreshStatus()
      end
    end
  end
end

function UITacticalWeaponChipPlanView:OnChipBgBtnClick(pos)
  if self.curChipGroupData[pos] == nil then
    local hasChips = DataCenter.TacticalChipManager:HasChipByPosType(pos)
    if not hasChips then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalChipManageEmpty, {anim = true}, pos)
    else
      local planId = self.curTab.tabId
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalChipManage, {anim = true}, pos, planId)
    end
  end
end

function UITacticalWeaponChipPlanView:OnChipItemClick(chipInfo, pos)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTWSkillChipDetail, {anim = true}, chipInfo, true, true)
end

function UITacticalWeaponChipPlanView:CreatHeroSpine()
  if self.heroSpineLoadRequest then
    return
  end
  local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(APPEARANCE_ID)
  local spinePath = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_path")
  self.heroSpineLoadRequest = self:GameObjectInstantiateAsync(spinePath, function(request)
    local go = request.gameObject
    if IsNull(go) then
      return
    end
    local obj = request.gameObject
    obj:SetActive(true)
    obj.transform:SetParent(self.heroSpineNode.transform)
    if CommonUtil.IsArabicAutoMirrorOpen() then
      obj.transform.localPosition = Vector3.New(0, 164, 0)
      obj.transform.localScale = Vector3.New(-0.75, 0.75, 0.75)
    else
      obj.transform.localPosition = Vector3.New(-56, 164, 0)
      obj.transform.localScale = Vector3.New(0.75, 0.75, 0.75)
    end
  end)
end

function UITacticalWeaponChipPlanView:CheckFirstChipPlanShowGuide()
  if DataCenter.LWGuideFlowManager.Runner:IsRun() then
    return
  end
  if not DataCenter.LWGuideFlowManager:ReadDone(4005) then
    DataCenter.LWGuideFlowManager.Runner:Run(4005)
  end
end

function UITacticalWeaponChipPlanView:OnFactoryBtnClick()
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILDING_TACTICAL_CHIP_FACTORY)
  if buildList == nil or table.count(buildList) == 0 or buildList[1] == nil then
    GoToUtil.GotoBuildListByBuildId(BuildingTypes.LW_BUILDING_TACTICAL_CHIP_FACTORY)
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalChipFactory, {anim = false}, buildList[1].uuid, TacticalChipFactoryPage.Create)
end

function UITacticalWeaponChipPlanView:PlaySwitchSound()
  if not table.IsNullOrEmpty(self.curChipGroupData) and not table.IsNullOrEmpty(self.chipItemDic) then
    self:StopSwitchSound()
    self.soundId = DataCenter.LWSoundManager:PlaySound(62278, false)
  end
end

function UITacticalWeaponChipPlanView:StopSwitchSound()
  if self.soundId then
    DataCenter.LWSoundManager:StopSound(self.soundId)
    self.soundId = nil
  end
end

return UITacticalWeaponChipPlanView
