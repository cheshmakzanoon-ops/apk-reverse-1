local UIGarageRefit = BaseClass("UIGarageRefit", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local UIGarageRefitItem = require("UI.UIGarageRefit.Component.UIGarageRefitItem")
local UIGarageRefitItemTip = require("UI.UIGarageRefit.Component.UIGarageRefitItemTip")
local UIGarageRefitUpgradeTip = require("UI.UIGarageRefit.Component.UIGarageRefitUpgradeTip")
local UIGarageRefitTroopUpgrade = require("UI.UIGarageRefit.Component.UIGarageRefitTroopUpgrade")
local bg_path = "Bg"
local back_path = "safeArea/Back"
local title_path = "Title"
local hero_path = "HeroList/HeroSlot_%s/UIHeroCellSmall_%s"
local hero_lock_path = "HeroList/HeroSlot_%s/HeroLock_%s"
local hero_lock_text_path = "HeroList/HeroSlot_%s/HeroLock_%s/HeroLockText_%s"
local hero_add_path = "HeroList/HeroSlot_%s/HeroEmpty_%s"
local car_path = "middle/CarImage"
local car_glow1_path = "middle/CarGlow1"
local car_glow2_path = "middle/CarGlow2"
local name_path = "Name"
local info_path = "safeArea/Info"
local level_path = "bottom/Level"
local slider_path = "bottom/Slider"
local progress_path = "bottom/Progress"
local crit_path = "bottom/Crit"
local upgrade_btn_path = "bottom/UpgradeBtn"
local upgrade_text_path = "bottom/UpgradeBtn/UpgradeText"
local upgrade_desc_path = "bottom/UpgradeBtn/UpgradeDesc"
local upgrade_cost_path = "bottom/UpgradeBtn/UpgradeDesc/UpgradeCost"
local upgrade_res_path = "bottom/UpgradeBtn/UpgradeDesc/UpgradeRes"
local part_path = "middle/UIGarageRefitItem_%s"
local part_tip_path = "UIGarageRefitItemTip"
local upgrade_tip_path = "UIGarageRefitUpgradeTip"
local troop_upgrade_panel_path = "UIGarageRefitTroopUpgrade"
local troop_btn_path = "Troop"
local troop_count_path = "Troop/TroopCount"
local HERO_COUNT = 5
local PART_COUNT = 4
local PROGRESS_DURATION = 1

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:ReInit()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.bg_btn = self:AddComponent(UIButton, bg_path)
  self.bg_btn:SetOnClick(BindCallback(self, self.CloseTip))
  self.back_btn = self:AddComponent(UIButton, back_path)
  self.title_text = self:AddComponent(UIText, title_path)
  self.title_text:SetLocalText(140323)
  self.back_btn:SetOnClick(BindCallback(self, self.Close))
  self.heroes = {}
  self.hero_lock_gos = {}
  self.hero_lock_texts = {}
  self.hero_add_btns = {}
  for i = 1, HERO_COUNT do
    self.heroes[i] = self:AddComponent(UIHeroCellSmall, string.format(hero_path, i, i))
    self.hero_lock_gos[i] = self:AddComponent(UIBaseContainer, string.format(hero_lock_path, i, i))
    self.hero_lock_texts[i] = self:AddComponent(UIText, string.format(hero_lock_text_path, i, i, i))
    self.hero_add_btns[i] = self:AddComponent(UIButton, string.format(hero_add_path, i, i))
    self.hero_add_btns[i]:SetOnClick(BindCallback(self, self.OnAddClick))
  end
  self.car_image = self:AddComponent(UIImage, car_path)
  self.car_glow1_particle = self.transform:Find(car_glow1_path):GetComponent(typeof(CS.UnityEngine.ParticleSystem))
  self.car_glow2_particle = self.transform:Find(car_glow2_path):GetComponent(typeof(CS.UnityEngine.ParticleSystem))
  self.name_text = self:AddComponent(UIText, name_path)
  self.info_btn = self:AddComponent(UIButton, info_path)
  self.info_btn:SetOnClick(BindCallback(self, self.OnInfoClick))
  self.level_text = self:AddComponent(UIText, level_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.progress_text = self:AddComponent(UITweenNumberText, progress_path)
  self.crit_text = self:AddComponent(UIText, crit_path)
  self.upgrade_btn = self:AddComponent(UIButton, upgrade_btn_path)
  self.upgrade_btn:SetOnClick(BindCallback(self, self.OnUpgradeClick))
  self.upgrade_text = self:AddComponent(UIText, upgrade_text_path)
  self.upgrade_desc_go = self:AddComponent(UIBaseContainer, upgrade_desc_path)
  self.upgrade_cost_text = self:AddComponent(UIText, upgrade_cost_path)
  self.upgrade_res_image = self:AddComponent(UIImage, upgrade_res_path)
  self.parts = {}
  for type = 1, PART_COUNT do
    self.parts[type] = self:AddComponent(UIGarageRefitItem, string.format(part_path, type))
    self.parts[type]:SetOnClick(function()
      self:OnPartClick(type)
    end)
  end
  self.part_tip = self:AddComponent(UIGarageRefitItemTip, part_tip_path)
  self.upgrade_tip = self:AddComponent(UIGarageRefitUpgradeTip, upgrade_tip_path)
  self.troop_upgrade_panel = self:AddComponent(UIGarageRefitTroopUpgrade, troop_upgrade_panel_path)
  self.troop_btn = self:AddComponent(UIButton, troop_btn_path)
  self.troop_btn:SetOnClick(BindCallback(self, self.OnTroopClick))
  self.troop_count_text = self:AddComponent(UIText, troop_count_path)
  self:ShowExtraRes(true)
end

local function ComponentDestroy(self)
  self.bg_btn = nil
  self.back_btn = nil
  self.title_text = nil
  self.heroes = nil
  self.hero_lock_gos = nil
  self.hero_lock_texts = nil
  self.hero_add_btns = nil
  self.car_image = nil
  self.car_glow1_particle = nil
  self.car_glow2_particle = nil
  self.name_text = nil
  self.info_btn = nil
  self.level_text = nil
  self.slider = nil
  self.progress_text = nil
  self.crit_text = nil
  self.upgrade_btn = nil
  self.upgrade_text = nil
  self.upgrade_desc_go = nil
  self.upgrade_cost_text = nil
  self.upgrade_res_image = nil
  self.part_tip = nil
  self.upgrade_tip = nil
  self.troop_upgrade_panel = nil
  self.troop_btn = nil
  self.troop_count_text = nil
  self:ShowExtraRes(false)
end

local function DataDefine(self)
  self.garage = 0
  self.formation = nil
  self.refitData = nil
  self.restFreeCount = 0
  self.oldRefitData = nil
  self.refitCount = 0
  self.modifyTemplate = nil
  self.seq = nil
  self.maxLevel = 0
  self.critSeq = nil
  self.targetLv = false
  self.openTime = 0
  self.timer = nil
end

local function DataDestroy(self)
  self.garage = nil
  self.formation = nil
  self.refitData = nil
  self.restFreeCount = nil
  self.oldRefitData = nil
  self.refitCount = nil
  self.modifyTemplate = nil
  if self.seq ~= nil then
    self.seq:Kill()
  end
  self.seq = nil
  self.maxLevel = nil
  if self.critSeq then
    self.critSeq:Kill()
  end
  self.critSeq = nil
  self.targetLv = nil
  if self.timer then
    self.timer:Stop()
  end
  self.openTime = nil
  self.timer = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GarageRefitUpdate, self.Refresh)
  self:AddUIListener(EventId.ResourceUpdated, self.RefreshCost)
  self:AddUIListener(EventId.RefreshItems, self.RefreshCost)
  self:AddUIListener(EventId.ArmyFormationSave, self.RefreshHeroList)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.GarageRefitUpdate, self.Refresh)
  self:RemoveUIListener(EventId.ResourceUpdated, self.RefreshCost)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshCost)
  self:RemoveUIListener(EventId.ArmyFormationSave, self.RefreshHeroList)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  self.garage, self.targetLv = self:GetUserData()
  self.maxLevel = DataCenter.GarageRefitManager:GetMaxLevel()
  self:Refresh(nil, true)
  self:RefreshTimer()
end

local function ShowExtraRes(self, show)
  if show then
    local param = {}
    param.list = {}
    param.uiName = UIWindowNames.UIGarageRefit
    param.itemList = DataCenter.GarageRefitManager.showItemList
    EventManager:GetInstance():Broadcast(EventId.ShowMainUIExtraResource, param)
  else
    EventManager:GetInstance():Broadcast(EventId.HideMainUIExtraResource, UIWindowNames.UIGarageRefit)
  end
end

local function TimerAction(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local sameDay = UITimeManager:GetInstance():IsSameDayForServer(curTime // 1000, self.openTime // 1000)
  if not sameDay then
    self:Refresh(nil, true)
    self:RefreshTimer()
  end
end

local function RefreshTimer(self)
  self.openTime = UITimeManager:GetInstance():GetServerTime()
  if self.timer then
    self.timer:Stop()
  end
  self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
  self.timer:Start()
end

local function Refresh(self, message, isInit)
  local garageIndex = DataCenter.BuildManager:GetGarageIndex(self.garage)
  self.refitData = DataCenter.GarageRefitManager:GetGarageRefitDataCopy(self.garage)
  if self.refitData == nil then
    Logger.LogError("UIGarageRefitView, Refresh, refitData = null")
    return
  end
  self.modifyTemplate = DataCenter.GarageRefitManager:GetModifyTemplate(self.garage, self.refitData.level)
  if self.modifyTemplate == nil then
    Logger.LogError("UIGarageRefitView, Refresh, modifyTemplate = null")
    return
  end
  self.refitCount = 0
  self.restFreeCount = DataCenter.GarageRefitManager:GetGarageFreeCount(self.garage)
  for type = 1, PART_COUNT do
    local part = self.refitData.parts[type]
    self.parts[type]:SetData(part)
  end
  self.name_text:SetLocalText(140328, garageIndex)
  self.upgrade_btn:SetActive(self.refitData.level < self.maxLevel)
  self.upgrade_tip:SetActive(false)
  local effect, troopVal = self.modifyTemplate:GetAdditionalEffect()
  if effect ~= nil then
    self.troop_btn:SetActive(true)
    self.troop_count_text:SetText("+" .. troopVal)
  else
    self.troop_btn:SetActive(false)
  end
  self:RefreshHeroList()
  self:RefreshExp(isInit)
  self:RefreshCost()
  if isInit then
    self.upgrade_btn:SetInteractable(true)
  end
  if message and message.power then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ue_CombatPowerUp, false)
    local pic = "Assets/Main/Sprites/UI/UIMain/UIMainNew/UIMain_btn_Power.png"
    local pos = UIUtil.GetUIMainSavePos(UIMainSavePosType.Power)
    UIUtil.DoFly(tonumber(RewardType.POWER), 3, pic, self.car_image.transform.position + Vector3.New(-350, 0, 0), pos)
    EventManager:GetInstance():Broadcast(EventId.ShowPower, RewardType.POWER)
  end
  if message and not table.IsNullOrEmpty(message.upgrade) and self.oldRefitData then
    self.car_glow1_particle:Play()
    self.car_glow2_particle:Play()
    TimerManager:GetInstance():DelayInvoke(function()
      self:ShowUpgradePanel(self.oldRefitData, message.upgrade)
      self.upgrade_btn:SetInteractable(true)
    end, 0.01)
  end
  self.oldRefitData = self.refitData
  local uid = math.tointeger(LuaEntry.Player.uid)
  local seed = uid % 122420729 + self.refitData.level * 61 + self.refitData.exp * 83 + self.garage * 151 & 2147483647
  DataCenter.GarageRefitManager.apsRandom:SetSeed(seed)
  if self.targetLv then
    local param = {}
    param.arrowType = ArrowType.Capacity
    param.positionType = PositionType.Screen
    param.position = self.upgrade_btn.transform.position
    DataCenter.ArrowManager:ShowArrow(param)
    self.targetLv = nil
  end
end

local function RefreshHeroList(self)
  self.formation = self.ctrl:GetFormation(self.garage)
  if self.formation == nil then
    Logger.LogError("UIGarageRefitView, Refresh, formation = null")
    return
  end
  if self.formation.state == ArmyFormationState.Free then
    DataCenter.ArmyFormationDataManager:AutoInitFormationData(self.formation.uuid)
  end
  local heroUuidList = {}
  local showHeroes = false
  local armyInfo = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(self.formation.uuid)
  if armyInfo ~= nil then
    showHeroes = self.ctrl:ShowFormationHeroes(self.formation)
  end
  if showHeroes then
    for heroUuid, i in pairs(armyInfo.heroes) do
      heroUuidList[i] = heroUuid
    end
  else
    for i = 1, HERO_COUNT do
      heroUuidList[i] = nil
    end
  end
  for i = 1, HERO_COUNT do
    local heroUuid = heroUuidList[i]
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    if heroUuid and heroData then
      self.heroes[i]:SetActive(true)
      self.heroes[i]:SetData(heroUuid)
      self.hero_lock_gos[i]:SetActive(false)
      self.hero_add_btns[i]:SetActive(false)
    else
      self.heroes[i]:SetActive(false)
      local scienceId = DataCenter.GarageRefitManager:GetSlotScienceId(self.garage, i)
      if DataCenter.ScienceManager:GetScienceLevel(scienceId) > 0 then
        self.hero_lock_gos[i]:SetActive(false)
        self.hero_add_btns[i]:SetActive(self.formation.state == ArmyFormationState.Free)
      else
        self.hero_lock_gos[i]:SetActive(true)
        self.hero_lock_texts[i]:SetText("")
        self.hero_add_btns[i]:SetActive(false)
      end
    end
  end
end

local function RefreshExp(self, isInit)
  if isInit then
    if self.refitData.level < self.maxLevel then
      self.progress_text:SetSuffix("/" .. self.modifyTemplate.exp)
      self.progress_text:SetNum(self.refitData.exp)
      self.slider:SetValue(self.refitData.exp / self.modifyTemplate.exp)
      self.level_text:SetText("Lv." .. self.refitData.level)
    else
      self.progress_text:SetLocalText(150072)
      self.slider:SetValue(1)
      self.level_text:SetText("Lv." .. self.refitData.level)
    end
  else
    self:TweenToProgress()
  end
end

local function RefreshCost(self)
  if self.refitData.level < self.maxLevel then
    local isFree = true
    local isEnough = true
    if self.restFreeCount <= 0 then
      if 0 < self.modifyTemplate.money then
        self.upgrade_cost_text:SetText(self.modifyTemplate.money)
        self.upgrade_res_image:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Food))
        isFree = false
        isEnough = LuaEntry.Resource:GetCntByResType(ResourceType.Food) >= self.modifyTemplate.money
      else
        local itemId, count = self.modifyTemplate:GetCostItem()
        if itemId ~= nil and 0 < count then
          local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
          local itemData = DataCenter.ItemData:GetItemById(itemId)
          local itemCount = itemData and itemData.count or 0
          self.upgrade_cost_text:SetText(count)
          self.upgrade_res_image:LoadSprite(string.format(LoadPath.ItemPath, itemTemplate.icon))
          isFree = false
          isEnough = count <= itemCount
        end
      end
    end
    if isFree then
      self.upgrade_text:SetLocalText(130126)
      self.upgrade_cost_text:SetText(self.restFreeCount .. "/" .. DataCenter.GarageRefitManager:GetFreeCount())
      self.upgrade_res_image:SetActive(false)
    else
      self.upgrade_text:SetLocalText(100091)
      self.upgrade_res_image:SetActive(true)
    end
    self.upgrade_cost_text:SetColor(isEnough and WhiteColor or RedColor)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.upgrade_btn.rectTransform)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.upgrade_desc_go.rectTransform)
  end
end

local function TweenToProgress(self)
  local curLevel = tonumber(string.sub(self.level_text:GetText(), 4)) or self.refitData.level
  local curExp = self.progress_text:GetCurNum() or self.refitData.exp
  local template = DataCenter.GarageRefitManager:GetModifyTemplate(self.garage, curLevel)
  if template == nil then
    return
  end
  self.progress_text:SetSuffix("/" .. template.exp)
  if self.seq ~= nil then
    self.seq:Kill()
  end
  if curLevel < self.refitData.level then
    local duration = PROGRESS_DURATION / (self.refitData.level - curLevel + 1) * (template.exp - curExp) / template.exp
    self.progress_text:TweenToNum(template.exp, duration)
    self.seq = DOTween.Sequence():Append(self.slider.unity_uislider:DOValue(1, duration)):AppendCallback(function()
      if curLevel + 1 < self.maxLevel then
        self.progress_text:SetNum(0)
        self.slider:SetValue(0)
        self.level_text:SetText("Lv." .. curLevel + 1)
        self:TweenToProgress()
      else
        self.progress_text:SetLocalText(150072)
        self.slider:SetValue(1)
        self.level_text:SetText("Lv." .. self.maxLevel)
      end
    end)
  elseif curLevel == self.refitData.level then
    local duration = PROGRESS_DURATION * (self.refitData.exp - curExp) / template.exp
    self.progress_text:TweenToNum(self.refitData.exp, duration)
    self.seq = DOTween.Sequence():Append(self.slider.unity_uislider:DOValue(self.refitData.exp / template.exp, duration))
  else
    self.progress_text:SetNum(self.refitData.exp)
    self.slider:SetValue(self.refitData.exp / template.exp)
    self.level_text:SetText("Lv." .. self.refitData.level)
  end
end

local function Close(self)
  self:SendGarageRefitMessage()
  self:CloseTip()
  self.ctrl:CloseSelf()
end

local function OnUpgradeClick(self)
  local succ = false
  if self.restFreeCount > 0 then
    self.restFreeCount = self.restFreeCount - 1
    succ = true
  elseif 0 < self.modifyTemplate.money then
    local playerMoney = LuaEntry.Resource:GetCntByResType(ResourceType.Food)
    if playerMoney >= self.modifyTemplate.money then
      LuaEntry.Resource:UpdateResource({
        money = playerMoney - self.modifyTemplate.money
      })
      succ = true
    else
      UIUtil.ShowTipsId(120450)
      local lackTab = {}
      local param = {}
      param.type = ResLackType.Res
      param.resType = ResourceType.Food
      param.targetNum = self.modifyTemplate.money
      table.insert(lackTab, param)
      GoToResLack.GoToItemResLackList(lackTab)
      succ = false
    end
  else
    local itemId, count = self.modifyTemplate:GetCostItem()
    if itemId ~= nil and 0 < count then
      local itemData = DataCenter.ItemData:GetItemById(itemId)
      local itemCount = itemData and itemData.count or 0
      if count <= itemCount then
        itemData.count = itemData.count - count
        self:ShowExtraRes(true)
        succ = true
      else
        UIUtil.ShowTipsId(120021)
        local lackTab = {}
        local param = {}
        param.type = ResLackType.Item
        param.itemId = itemId
        param.targetNum = count
        table.insert(lackTab, param)
        GoToResLack.GoToItemResLackList(lackTab)
        succ = false
      end
    else
      succ = true
    end
  end
  if succ then
    local factor = DataCenter.GarageRefitManager:GetExpCritFactor()
    self.refitCount = self.refitCount + 1
    self.refitData.exp = self.refitData.exp + self.modifyTemplate.addExp * factor
    self:RefreshExp(false)
    self:RefreshCost()
    if self.refitData.exp >= self.modifyTemplate.exp then
      self.upgrade_btn:SetInteractable(false)
      self:SendGarageRefitMessage()
    end
    if 1 < factor then
      self.crit_text:SetLocalText(140332, factor)
      self.crit_text:SetColor(Color.New(1, 1, 1, 0))
      self.critSeq = DOTween.Sequence():Append(self.crit_text.unity_text:DOFade(1, 0.1)):AppendInterval(1):Append(self.crit_text.unity_text:DOFade(0, 0.3))
    end
  else
    self:SendGarageRefitMessage()
  end
  self:CloseTip()
end

local function OnPartClick(self, type)
  local part = self.refitData.parts[type]
  if part then
    if self.part_tip.active then
      self.part_tip:OnClose()
    end
    self.part_tip:SetActive(true)
    self.part_tip:SetData(part, self.parts[part.type].gameObject)
  end
end

local function OnAddClick(self)
  if not CS.SceneManager:IsInCity() and self.formation.state == ArmyFormationState.Free then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationTableNew, self.formation.uuid, -1, -1, 0, -1, 1, 0, nil, 1)
    self:Close()
  end
end

local function OnInfoClick(self)
  UIUtil.ShowIntro(Localization:GetString("170001"), Localization:GetString("302027"), Localization:GetString("140334"))
  self:CloseTip()
end

local function OnTroopClick(self)
  self:CloseTip()
  local garageIndex = DataCenter.BuildManager:GetGarageIndex(self.garage)
  local effect, val = self.modifyTemplate:GetAdditionalEffect()
  local effectDesc = GetTableData(TableName.EffectNumDesc, effect, "des")
  local param = {}
  param.type = "desc"
  param.title = Localization:GetString("140328", garageIndex)
  param.desc = Localization:GetString(effectDesc) .. " +" .. val .. "\n" .. Localization:GetString("140406")
  param.alignObject = self.troop_btn
  param.showArrow = false
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

local function CloseTip(self)
  self.part_tip:OnClose()
end

local function SendGarageRefitMessage(self)
  if self.refitCount == 0 then
    return
  end
  local param = {
    uuid = self.refitData.uuid,
    count = self.refitCount
  }
  SFSNetwork.SendMessage(MsgDefines.GarageRefit, param)
end

local function ShowUpgradePanel(self, refitData, typeList)
  self.upgrade_tip:SetData(refitData, typeList)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UINoticeEquipTips, {anim = true, playEffect = false})
  local leftTemplate = DataCenter.GarageRefitManager:GetModifyTemplate(self.garage, self.refitData.level - 1)
  local rightTemplate = DataCenter.GarageRefitManager:GetModifyTemplate(self.garage, self.refitData.level)
  local showTroopUpgrade = false
  if leftTemplate == nil and rightTemplate ~= nil then
    showTroopUpgrade = true
  elseif leftTemplate ~= nil and rightTemplate ~= nil then
    local leftEffect, leftVal = leftTemplate:GetAdditionalEffect()
    local rightEffect, rightVal = rightTemplate:GetAdditionalEffect()
    if leftEffect ~= rightEffect or leftVal ~= rightVal then
      showTroopUpgrade = true
    end
  end
  if showTroopUpgrade then
    local garageIndex = DataCenter.BuildManager:GetGarageIndex(self.garage)
    self.troop_upgrade_panel:SetData(leftTemplate, rightTemplate, garageIndex)
    TimerManager:GetInstance():DelayInvoke(function()
      self.troop_upgrade_panel:SetActive(true)
    end, 0.5)
  else
  end
end

UIGarageRefit.OnCreate = OnCreate
UIGarageRefit.OnDestroy = OnDestroy
UIGarageRefit.OnEnable = OnEnable
UIGarageRefit.OnDisable = OnDisable
UIGarageRefit.ComponentDefine = ComponentDefine
UIGarageRefit.ComponentDestroy = ComponentDestroy
UIGarageRefit.DataDefine = DataDefine
UIGarageRefit.DataDestroy = DataDestroy
UIGarageRefit.OnAddListener = OnAddListener
UIGarageRefit.OnRemoveListener = OnRemoveListener
UIGarageRefit.ReInit = ReInit
UIGarageRefit.ShowExtraRes = ShowExtraRes
UIGarageRefit.TimerAction = TimerAction
UIGarageRefit.RefreshTimer = RefreshTimer
UIGarageRefit.Refresh = Refresh
UIGarageRefit.RefreshHeroList = RefreshHeroList
UIGarageRefit.RefreshExp = RefreshExp
UIGarageRefit.RefreshCost = RefreshCost
UIGarageRefit.TweenToProgress = TweenToProgress
UIGarageRefit.Close = Close
UIGarageRefit.OnUpgradeClick = OnUpgradeClick
UIGarageRefit.OnPartClick = OnPartClick
UIGarageRefit.OnAddClick = OnAddClick
UIGarageRefit.OnInfoClick = OnInfoClick
UIGarageRefit.OnTroopClick = OnTroopClick
UIGarageRefit.CloseTip = CloseTip
UIGarageRefit.SendGarageRefitMessage = SendGarageRefitMessage
UIGarageRefit.ShowUpgradePanel = ShowUpgradePanel
return UIGarageRefit
