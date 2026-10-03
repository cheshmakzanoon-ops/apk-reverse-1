local UILWHeroHonorLevelUpgradeView = BaseClass("UILWHeroHonorLevelUpgradeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UIHeroHonorCellBig = require("UI.UILWHeroHOF.Component.UIHeroHonorCellBig")
local UILWHeroHonorLevelEffectLine = require("UI.UILWHeroHonorLevelUpgrade.Component.UILWHeroHonorLevelEffectLine")
local UILWHeroHonorLevelTitleLine = require("UI.UILWHeroHonorLevelUpgrade.Component.UILWHeroHonorLevelTitleLine")
local UILWHeroHonorLevelInfoLine = require("UI.UILWHeroHonorLevelUpgrade.Component.UILWHeroHonorLevelInfoLine")
local UILWHeroHonorPropertyChangeItem = require("UI.UILWHeroHonorLevelUpgrade.Component.UILWHeroHonorPropertyChangeItem")
local closeBtn_path = "UICommonPopUpTitle/CloseBtn"
local closePanel_path = "UICommonPopUpTitle/panel"
local curHero_path = "Root/HeroInfo/CurHero"
local bonusEffectScroll_path = "Root/BonusArea/BonusEffectScroll"
local bonusEffectScrollContent_path = "Root/BonusArea/BonusEffectScroll/Viewport/Content"
local useComFragBtn_path = "Root/BtnArea/CostCommonFragmentBtn"
local userComFragBtnComFrag_path = "Root/BtnArea/CostCommonFragmentBtn/CostArea/CommonFragment"
local userComFragBtnComFragIcon_path = "Root/BtnArea/CostCommonFragmentBtn/CostArea/CommonFragment/CommonFragmentIcon"
local userComFragBtnComFragCountText_path = "Root/BtnArea/CostCommonFragmentBtn/CostArea/CommonFragment/CommonFragmentCountText"
local userComFragBtnFrag_path = "Root/BtnArea/CostCommonFragmentBtn/CostArea/HeroFragment"
local userComFragBtnFragIcon_path = "Root/BtnArea/CostCommonFragmentBtn/CostArea/HeroFragment/FragmentIcon"
local userComFragBtnFragCountText_path = "Root/BtnArea/CostCommonFragmentBtn/CostArea/HeroFragment/FragmentCountText"
local userHeroFragBtn_path = "Root/BtnArea/CostFragmentBtn"
local userHeroFragBtnFragIcon_path = "Root/BtnArea/CostFragmentBtn/CostArea/HeroFragment1/Fragment1Icon"
local userHeroFragBtnFragCountText_path = "Root/BtnArea/CostFragmentBtn/CostArea/HeroFragment1/Fragment1CountText"
local btnArea_path = "Root/BtnArea"
local maxHonorLevelTipText_path = "Root/MaxHonorLevelTipText"
local titleValueText_path = "Root/HeroInfo/TileLineItem/TitleValueText"
local nameValueText_path = "Root/HeroInfo/NameLineItem/NameValueText"
local powerValueText_path = "Root/HeroInfo/PowerLineItem/PowerValue/PowerValueText"
local powerUpgradeIcon_path = "Root/HeroInfo/PowerLineItem/PowerValue/PowerUpgradeIcon"
local powerUpgradeEffect_path = "Root/HeroInfo/PowerLineItem/PowerUpgradeEffect"
local lock_state_btn_area_path = "Root/LockStateBtnArea"
local goto_upgrade_when_lock_btn_path = "Root/LockStateBtnArea/GotoUpgradeWhenLockBtn"
local honor_wall_lock_tips_path = "Root/LockStateBtnArea/HonorWallLockTips"

local function GetItemNameSequence(self)
  NameCount = NameCount + 1
  return tostring(NameCount)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.showDataList then
    return nil
  end
  local showData = self.showDataList[index]
  local item
  if showData then
    if showData.type == "title" then
      item = loopScroll:NewListViewItem("SubTitleItem")
      local script = self.bonusEffectScrollContent:GetComponent(item.gameObject.name, UILWHeroHonorLevelTitleLine)
      if script == nil then
        local itemIndex = GetItemNameSequence(self)
        local objectName = tostring(itemIndex)
        item.gameObject.name = objectName
        script = self.bonusEffectScrollContent:AddComponent(UILWHeroHonorLevelTitleLine, objectName)
      end
      script:SetActive(true)
      script:ReInit(showData)
    elseif showData.type == "infoItem" then
      item = loopScroll:NewListViewItem("InfoLineItem")
      local script = self.bonusEffectScrollContent:GetComponent(item.gameObject.name, UILWHeroHonorLevelInfoLine)
      if script == nil then
        local itemIndex = GetItemNameSequence(self)
        local objectName = tostring(itemIndex)
        item.gameObject.name = objectName
        script = self.bonusEffectScrollContent:AddComponent(UILWHeroHonorLevelInfoLine, objectName)
      end
      script:SetActive(true)
      script:ReInit(showData)
    elseif showData.type == "effectItem" then
      item = loopScroll:NewListViewItem("BonusLineItem")
      local script = self.bonusEffectScrollContent:GetComponent(item.gameObject.name, UILWHeroHonorLevelEffectLine)
      if script == nil then
        local itemIndex = GetItemNameSequence(self)
        local objectName = tostring(itemIndex)
        item.gameObject.name = objectName
        script = self.bonusEffectScrollContent:AddComponent(UILWHeroHonorLevelEffectLine, objectName)
      end
      script:SetActive(true)
      script:ReInit(showData)
      script:SetState(self.heroData.honorLevel >= showData.unlockLevel)
    end
  end
  return item
end

local function ComponentDefine(self)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closePanel = self:AddComponent(UIButton, closePanel_path)
  self.closePanel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.curHero = self:AddComponent(UIHeroHonorCellBig, curHero_path)
  self.bonusEffectScroll = self:AddComponent(UILoopListView2, bonusEffectScroll_path)
  self.bonusEffectScroll:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.bonusEffectScrollContent = self:AddComponent(UIBaseContainer, bonusEffectScrollContent_path)
  self.useComFragBtn = self:AddComponent(UIButton, useComFragBtn_path)
  self.useComFragBtn:SetOnClick(function()
    self:OnCommonFragBtnClick()
  end)
  self.useComFragBtnComFrag = self:AddComponent(UIBaseContainer, userComFragBtnComFrag_path)
  self.useComFragBtnComFragIcon = self:AddComponent(UIImage, userComFragBtnComFragIcon_path)
  self.useComFragBtnComFragCountText = self:AddComponent(UIText, userComFragBtnComFragCountText_path)
  self.useComFragBtnHeroFrag = self:AddComponent(UIBaseContainer, userComFragBtnFrag_path)
  self.useComFragBtnHeroFragIcon = self:AddComponent(UIImage, userComFragBtnFragIcon_path)
  self.useComFragBtnHeroFragCountText = self:AddComponent(UIText, userComFragBtnFragCountText_path)
  self.userHeroFragBtn = self:AddComponent(UIButton, userHeroFragBtn_path)
  self.userHeroFragBtn:SetOnClick(function()
    self:OnUpgradeBtnClick()
  end)
  self.userHeroFragBtnIcon = self:AddComponent(UIImage, userHeroFragBtnFragIcon_path)
  self.userHeroFragBtnCountText = self:AddComponent(UIText, userHeroFragBtnFragCountText_path)
  self.btnArea = self:AddComponent(UIBaseContainer, btnArea_path)
  self.maxHonorLevelTipText = self:AddComponent(UIText, maxHonorLevelTipText_path)
  self.titleValueText = self:AddComponent(UIText, titleValueText_path)
  self.nameValueText = self:AddComponent(UIText, nameValueText_path)
  self.powerValueText = self:AddComponent(UIText, powerValueText_path)
  self.powerUpgradeIcon = self:AddComponent(UIImage, powerUpgradeIcon_path)
  self.powerUpgradeEffect = self:AddComponent(UIBaseContainer, powerUpgradeEffect_path)
  self.gotoUpgradeOnLockBtn = self:AddComponent(UIButton, goto_upgrade_when_lock_btn_path)
  self.gotoUpgradeOnLockBtn:SetOnClick(function()
    self:GotoUpgradeRankPage()
  end)
  self.honorWallLockTipText = self:AddComponent(UIText, honor_wall_lock_tips_path)
  self.lockStateBtnAreaObj = self:AddComponent(UIBaseContainer, lock_state_btn_area_path)
end

local function ComponentDestroy(self)
  self:ClearTemplatePool()
  self.closeBtn = nil
  self.curHero = nil
  self.bonusEffectScroll = nil
  self.bonusEffectScrollContent = nil
  self.useComFragBtn = nil
  self.useComFragBtnComFrag = nil
  self.useComFragBtnComFragIcon = nil
  self.useComFragBtnComFragCountText = nil
  self.useComFragBtnHeroFrag = nil
  self.useComFragBtnHeroFragIcon = nil
  self.useComFragBtnHeroFragCountText = nil
  self.userHeroFragBtn = nil
  self.userHeroFragBtnIcon = nil
  self.userHeroFragBtnCountText = nil
  self.btnArea = nil
  self.maxHonorLevelTipText = nil
  self.titleValueText = nil
  self.nameValueText = nil
  self.powerValueText = nil
  self.powerUpgradeIcon = nil
  self.powerUpgradeEffect = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function ClearScroll(self)
  self.bonusEffectScrollContent:RemoveComponents(UILWHeroHonorLevelEffectLine)
  self.bonusEffectScroll:ClearAllItems()
end

local function OnCreate(self)
  base.OnCreate(self)
  DataDefine(self)
  ComponentDefine(self)
  self.heroUuid = self:GetUserData()
  self.heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
  self:RefreshHeroBaseInfo()
  self:RefreshShowData(true)
end

local function OnDestroy(self)
  ClearScroll(self)
  DataDestroy(self)
  ComponentDestroy(self)
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.curHeroHpValue = nil
  if self.powerUpgradeEffect then
    self.powerUpgradeEffect:SetActive(false)
  end
end

local function OnDisable(self)
  self.curHeroHpValue = nil
  base.OnDisable(self)
end

local function RefreshHeroBaseInfo(self)
  if self.heroData == nil then
    return
  end
  self.titleValueText:SetText(self.heroData:GetNickName())
  self.nameValueText:SetLocalText(self.heroData.firstName)
end

local function RefreshShowData(self, moveScroll)
  if self.heroData == nil then
    return
  end
  self.curHero:SetData(self.heroData.uuid)
  local hpValue = math.floor(self.heroData:GetProperty(HeroEffectDefine.Honor_HP_Result))
  self.curHeroHpValue = hpValue
  self.powerValueText:SetText(self.heroData.power)
  if self.heroData:IsReachMaxHonorLevel() then
    self.btnArea:SetActive(false)
    self.lockStateBtnAreaObj:SetActive(false)
    self.maxHonorLevelTipText:SetActive(true)
    self.powerUpgradeIcon:SetActive(false)
  else
    self.maxHonorLevelTipText:SetActive(false)
    local isHonorWallLockState = self.heroData:IsHonorLockState()
    if isHonorWallLockState then
      self.lockStateBtnAreaObj:SetActive(true)
      self.btnArea:SetActive(false)
      local heroName = Localization:GetString(self.heroData.firstName)
      self.honorWallLockTipText:SetLocalText("activity_hero_change_honor_wall_lock_tips", heroName)
    else
      self.lockStateBtnAreaObj:SetActive(false)
      self.btnArea:SetActive(true)
      self.powerUpgradeIcon:SetActive(true)
      local fragId = self.heroData:GetHeroFragId()
      local fragIcon = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, fragId)
      self.userHeroFragBtnIcon:LoadSprite(fragIcon)
      self.useComFragBtnHeroFragIcon:LoadSprite(fragIcon)
      local haveFragCount = DataCenter.ItemData:GetItemCount(fragId)
      local costFragCount = self.heroData:GetHonorLevelUpgradeCost()
      if haveFragCount >= costFragCount then
        self.useComFragBtn:SetActive(false)
        self.userHeroFragBtnCountText:SetText(string.format("<color=#5FEF87>%d</color>/%d", haveFragCount, costFragCount))
      else
        self.useComFragBtn:SetActive(true)
        local commonFragId = DataCenter.HeroParamDataManager:GetQualityFragmentIdByQuality(self.heroData)
        local commonFragIcon = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, commonFragId)
        self.useComFragBtnComFragIcon:LoadSprite(commonFragIcon)
        local commonHeroFragCount = DataCenter.ItemData:GetItemCount(commonFragId)
        local count = costFragCount - haveFragCount
        local colour = commonHeroFragCount >= count and "<color=#5FEF87>%d</color>/%d" or "<color=#F97077>%d</color>/%d"
        self.useComFragBtnHeroFrag:SetActive(haveFragCount ~= 0)
        self.useComFragBtnComFragCountText:SetText(string.format(colour, commonHeroFragCount, count))
        self.useComFragBtnHeroFragCountText:SetText(string.format("<color=#5FEF87>%d</color>/%d", haveFragCount, haveFragCount))
        self.userHeroFragBtnCountText:SetText(string.format("<color=#F97077>%d</color>/%d", haveFragCount, costFragCount))
      end
    end
  end
  local levelEffectList = self.heroData.meta.honor_level_effects
  self.effectsList = {}
  for level, effectPair in pairs(levelEffectList) do
    local effectInfo = {}
    effectInfo.unlockLevel = level
    for key, value in pairs(effectPair) do
      effectInfo.name = HeroUtils.GetHeroPropertyNameId(key)
      effectInfo.value = HeroUtils.GetFormattedPropertyValue(key, value)
      break
    end
    table.insert(self.effectsList, effectInfo)
  end
  table.sort(self.effectsList, function(a, b)
    return a.unlockLevel < b.unlockLevel
  end)
  self.showDataList = {}
  local heroInfoTitleItemData = {
    type = "title",
    title = Localization:GetString("report_prop21")
  }
  table.insert(self.showDataList, heroInfoTitleItemData)
  local heroHpItemData = {
    type = "infoItem",
    title = Localization:GetString("hero_honorlevel_title_01"),
    value = string.GetFormattedStr(hpValue)
  }
  heroHpItemData.showUpgradeIcon = not self.heroData:IsReachMaxHonorLevel()
  table.insert(self.showDataList, heroHpItemData)
  local effectTitleItemData = {
    type = "title",
    title = Localization:GetString(310151)
  }
  table.insert(self.showDataList, effectTitleItemData)
  for i, v in ipairs(self.effectsList) do
    local effectInfo = v
    effectInfo.type = "effectItem"
    table.insert(self.showDataList, effectInfo)
  end
  if #self.showDataList == 0 then
    self.bonusEffectScroll:SetActive(false)
  else
    self.bonusEffectScroll:SetActive(true)
    self.bonusEffectScroll:SetListItemCount(#self.showDataList, false, false)
    self.bonusEffectScroll:RefreshAllShownItem()
    if moveScroll then
    end
  end
end

local function OnUpgradeBtnClick(self)
  if not self.heroData then
    return
  end
  local fragId = self.heroData:GetHeroFragId()
  local haveFragCount = DataCenter.ItemData:GetItemCount(fragId)
  local costFragCount = self.heroData:GetHonorLevelUpgradeCost()
  if haveFragCount >= costFragCount then
    SFSNetwork.SendMessage(MsgDefines.HeroHonorLevelUp, self.heroData.uuid, 0)
  else
    LWResourceLackUtil:GotoGoodsItemLack(fragId, costFragCount, nil, function()
      if self.closeBtn then
        self:RefreshShowData()
      end
    end)
  end
end

local function OnCommonFragBtnClick(self)
  if not self.heroData then
    return
  end
  local fragId = self.heroData:GetHeroFragId()
  local haveFragCount = DataCenter.ItemData:GetItemCount(fragId)
  local costFragCount = self.heroData:GetHonorLevelUpgradeCost()
  local commonFragId = DataCenter.HeroParamDataManager:GetQualityFragmentIdByQuality(self.heroData)
  local commonHeroFragCount = DataCenter.ItemData:GetItemCount(commonFragId)
  local count = costFragCount - haveFragCount
  if commonHeroFragCount >= count then
    SFSNetwork.SendMessage(MsgDefines.HeroHonorLevelUp, self.heroData.uuid, 1)
  else
    LWResourceLackUtil:GotoGoodsItemLack(commonFragId, count, nil, function()
      if self.closeBtn then
        self:RefreshShowData()
      end
    end)
  end
end

local function OnHeroHonorLevelUp(self, heroUuid)
  if not self.heroData then
    return
  end
  if self.heroData.uuid ~= heroUuid then
    return
  end
  if self.curHeroHpValue then
    local hpValue = math.floor(self.heroData:GetProperty(HeroEffectDefine.Honor_HP_Result))
    local hpChange = hpValue - self.curHeroHpValue
    if 0 <= hpChange then
    end
  end
  self.powerUpgradeEffect:SetActive(false)
  self.powerUpgradeEffect:SetActive(true)
  self:RefreshShowData()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.HeroHonorLevelUpgrade, self.OnHeroHonorLevelUp)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.HeroHonorLevelUpgrade, self.OnHeroHonorLevelUp)
end

local function RecyclePropertyTemplate(self, item)
  if item and not IsNull(item.gameObject) then
    local obj = item.gameObject
    self.hpPropChangeContainer:RemoveComponent(item:GetName(), UILWHeroHonorPropertyChangeItem)
    obj:GameObjectRecycle()
  end
end

local function ClearTemplatePool(self)
  self.showPropertyChangeCallBack = nil
end

function UILWHeroHonorLevelUpgradeView:GotoUpgradeRankPage()
  GoToUtil.GoHeroDetails(self.heroData.heroId, HeroDetailGuideArrowType.Rank)
end

UILWHeroHonorLevelUpgradeView.OnCreate = OnCreate
UILWHeroHonorLevelUpgradeView.OnDestroy = OnDestroy
UILWHeroHonorLevelUpgradeView.OnEnable = OnEnable
UILWHeroHonorLevelUpgradeView.OnDisable = OnDisable
UILWHeroHonorLevelUpgradeView.ComponentDefine = ComponentDefine
UILWHeroHonorLevelUpgradeView.ComponentDestroy = ComponentDestroy
UILWHeroHonorLevelUpgradeView.DataDefine = DataDefine
UILWHeroHonorLevelUpgradeView.DataDestroy = DataDestroy
UILWHeroHonorLevelUpgradeView.RefreshShowData = RefreshShowData
UILWHeroHonorLevelUpgradeView.OnUpgradeBtnClick = OnUpgradeBtnClick
UILWHeroHonorLevelUpgradeView.OnCommonFragBtnClick = OnCommonFragBtnClick
UILWHeroHonorLevelUpgradeView.OnAddListener = OnAddListener
UILWHeroHonorLevelUpgradeView.OnRemoveListener = OnRemoveListener
UILWHeroHonorLevelUpgradeView.OnHeroHonorLevelUp = OnHeroHonorLevelUp
UILWHeroHonorLevelUpgradeView.RefreshHeroBaseInfo = RefreshHeroBaseInfo
UILWHeroHonorLevelUpgradeView.RecyclePropertyTemplate = RecyclePropertyTemplate
UILWHeroHonorLevelUpgradeView.ClearTemplatePool = ClearTemplatePool
return UILWHeroHonorLevelUpgradeView
