local MailHeroPage = BaseClass("MailHeroPage", UIBaseContainer)
local base = UIBaseContainer
local MailEquipItem = require("UI.UILWMail.UILWMailMain.Component.MailEquipItem")
local MailSkillItem = require("UI.UILWMail.UILWMailMain.Component.MailSkillItem")
local MailHeroWeaponCellNew = require("UI.UILWMail.UILWMailMain.Component.MailHeroWeaponCell_New")
local UILWMailHeroPageRelationContainer = require("UI.UILWMail.UILWMailMain.Component.UILWMailHeroPageRelationContainer")
local HeroOverview = require("UI.UILWMail.UILWMailMain.Component.BattleAIHelperComs.HeroOverview")
local Localization = CS.GameEntry.Localization

function MailHeroPage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MailHeroPage:OnDestroy()
  BattleReportUtil.Cancel()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailHeroPage:DataDefine()
end

function MailHeroPage:DataDestroy()
end

function MailHeroPage:OnEnable()
  base.OnEnable(self)
end

function MailHeroPage:OnDisable()
  base.OnDisable(self)
end

function MailHeroPage:OnAddListener()
  base.OnAddListener(self)
end

function MailHeroPage:OnRemoveListener()
  base.OnRemoveListener(self)
end

function MailHeroPage:ComponentDefine()
  self.heroOverview = self:AddComponent(HeroOverview, "HeroOverview")
  self.hero_page_relation_container = self:AddComponent(UILWMailHeroPageRelationContainer, "HeroOverview/HeroPageRelationContainer")
  self.EquipView = self:AddComponent(UIBaseComponent, "EquipView")
  local EquipTitleText = self:AddComponent(UIText, "EquipView/EquipTitle/EquipTitleText")
  EquipTitleText:SetLocalText(GameDialogDefine.EQUIPMENT)
  self.EquipPower1 = self:AddComponent(UIText, "EquipView/EquipTitle/EquipPower1")
  self.EquipPower2 = self:AddComponent(UIText, "EquipView/EquipTitle/EquipPower2")
  self.equipReqs = {}
  self.EquipContent = self:AddComponent(UIBaseContainer, "EquipView/EquipContent")
  self.SkillView = self:AddComponent(UIBaseComponent, "SkillView")
  local SkillTitleText = self:AddComponent(UIText, "SkillView/SkillTitle/SkillTitleText")
  SkillTitleText:SetLocalText(GameDialogDefine.SKILL)
  self.SkillPower1 = self:AddComponent(UIText, "SkillView/SkillTitle/SkillPower1")
  self.SkillPower2 = self:AddComponent(UIText, "SkillView/SkillTitle/SkillPower2")
  self.skillReqs = {}
  self.SkillContent = self:AddComponent(UIBaseContainer, "SkillView/SkillContent")
  self.uniqueWeaponView = self:AddComponent(UIBaseComponent, "UniqueWeaponView")
  local UniqueWeaponTitleText = self:AddComponent(UIText, "UniqueWeaponView/UniqueWeaponTitle/UniqueWeaponTitleText")
  UniqueWeaponTitleText:SetLocalText("hero_unique_weapon_battle1")
  self.uniqueWeaponReqs = {}
  self.uniqueWeaponContent = self:AddComponent(UIBaseContainer, "UniqueWeaponView/UniqueWeaponContent")
  self.uniqueWeaponLeft = self:AddComponent(UIButton, "UniqueWeaponView/UniqueWeaponContent/Left")
  self.uniqueWeaponRight = self:AddComponent(UIButton, "UniqueWeaponView/UniqueWeaponContent/Right")
  self.uniqueWeaponPower1 = self:AddComponent(UIText, "UniqueWeaponView/UniqueWeaponTitle/uniqueWeaponPower1/power1_txt")
  self.uniqueWeaponPower2 = self:AddComponent(UIText, "UniqueWeaponView/UniqueWeaponTitle/uniqueWeaponPower2/power2_txt")
  self.uw1InfoContainer = self:AddComponent(UIBaseContainer, "UniqueWeaponView/UniqueWeaponTitle/uniqueWeaponPower1/info1_container")
  self.uw1InfoContainer:SetActive(false)
  self.uw2InfoContainer = self:AddComponent(UIBaseContainer, "UniqueWeaponView/UniqueWeaponTitle/uniqueWeaponPower2/info2_container")
  self.uw2InfoContainer:SetActive(false)
  self.uw1InfoBtn = self:AddComponent(UIButton, "UniqueWeaponView/UniqueWeaponTitle/uniqueWeaponPower1/info1_container/info1_btn")
  self.uw2InfoBtn = self:AddComponent(UIButton, "UniqueWeaponView/UniqueWeaponTitle/uniqueWeaponPower2/info2_container/info2_btn")
  
  local function onUWInfoBtnClick(btn, playerInfo)
    local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
    param.title = Localization:GetString("hero_unique_unit_battle_tips_1")
    param.content = Localization:GetString("hero_unique_unit_battle_tips_2", playerInfo.weaponStrengTotalLv)
    param.alignObject = btn
    param.yPosFix = -10
    param.width = 400
    param.showArrow = false
    param.preferTop = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
  end
  
  self.uw1InfoBtn:SetOnClick(function()
    onUWInfoBtnClick(self.uw1InfoBtn, self.extData.player[1])
  end)
  self.uw2InfoBtn:SetOnClick(function()
    onUWInfoBtnClick(self.uw2InfoBtn, self.extData.player[2])
  end)
end

function MailHeroPage:ComponentDestroy()
  self:RemoveSkillItems()
  self:RemoveEquipItems()
end

function MailHeroPage:Refresh(extData)
  self.extData = extData
  self:RefreshView()
end

function MailHeroPage:RefreshView()
  self:RefreshHeroOverView()
  local showEquip = self.extData.pb_BattleReport.version >= 3 and DataCenter.BattleReportControlManager:NeedShow(UIMailRegion.Equip, self.extData.battleType)
  local showSkill = self.extData.pb_BattleReport.version >= 3 and DataCenter.BattleReportControlManager:NeedShow(UIMailRegion.Skill, self.extData.battleType)
  local showUniqueWeapon = DataCenter.BattleReportControlManager:NeedShow(UIMailRegion.UniqueWeapon, self.extData.battleType)
  self.EquipView:SetActive(showEquip)
  self.SkillView:SetActive(showSkill)
  if showEquip then
    self:RefreshHeroEquipView()
  end
  if showSkill then
    self:RefreshHeroSkillView()
  end
  if showUniqueWeapon then
    self:RefreshUniqueWeaponView()
  else
    self.uniqueWeaponView:SetActive(false)
  end
end

function MailHeroPage:RefreshHeroOverView()
  self.heroOverview:SetData(self.extData)
  local isBothPlayer = self.extData.player[1].armyType == MailTargetType.Player and self.extData.player[2].armyType == MailTargetType.Player
  local containSelf = self.extData.player[1].uid == LuaEntry.Player.uid or self.extData.player[2].uid == LuaEntry.Player.uid
  if isBothPlayer and not containSelf then
    self.hero_page_relation_container:SetActive(false)
  else
    self.hero_page_relation_container:SetActive(true)
    self.hero_page_relation_container:ReInit(self.extData)
  end
end

function MailHeroPage:RefreshHeroEquipView()
  self:RemoveEquipItems()
  local equipPower1, equipPower2 = 0, 0
  for i = 1, 5 do
    if self.extData.hero[i] or self.extData.hero[i + 5] then
      self.equipReqs[i] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWMail/EquipItem.prefab", function(req)
        if IsNull(req.gameObject) then
          return
        end
        local item = req.gameObject
        item.name = "EquipItem" .. i
        item.transform:SetParent(self.EquipContent.transform)
        item.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local obj = self.EquipContent:AddComponent(MailEquipItem, item.name)
        obj:SetData(self.extData.hero[i], self.extData.hero[i + 5])
      end)
      if self.extData.hero[i] and self.extData.hero[i].effect[HeroEffectDefine.HeroPowerEquip] then
        equipPower1 = equipPower1 + self.extData.hero[i].effect[HeroEffectDefine.HeroPowerEquip]
      end
      if self.extData.hero[i + 5] and self.extData.hero[i + 5].effect[HeroEffectDefine.HeroPowerEquip] then
        equipPower2 = equipPower2 + self.extData.hero[i + 5].effect[HeroEffectDefine.HeroPowerEquip]
      end
    end
  end
  self.EquipPower1:SetLocalText(GameDialogDefine.BATTLE_POWER, string.GetFormattedStr(math.floor(equipPower1)))
  self.EquipPower2:SetLocalText(GameDialogDefine.BATTLE_POWER, string.GetFormattedStr(math.floor(equipPower2)))
end

function MailHeroPage:RefreshHeroSkillView()
  self:RemoveSkillItems()
  local skillPower1, skillPower2 = 0, 0
  for index = 1, 5 do
    local i = index
    if self.extData.hero[i] or self.extData.hero[i + 5] then
      self.skillReqs[i] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWMail/SkillItem.prefab", function(req)
        if IsNull(req.gameObject) then
          return
        end
        local item = req.gameObject
        item.name = "SkillItem" .. i
        item.transform:SetParent(self.SkillContent.transform)
        item.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local obj = self.SkillContent:AddComponent(MailSkillItem, item.name)
        obj:SetData(self.extData.hero[i], self.extData.hero[i + 5])
      end)
      if self.extData.hero[i] and self.extData.hero[i].effect[HeroEffectDefine.HeroPowerSkill] then
        skillPower1 = skillPower1 + self.extData.hero[i].effect[HeroEffectDefine.HeroPowerSkill]
      end
      if self.extData.hero[i + 5] and self.extData.hero[i + 5].effect[HeroEffectDefine.HeroPowerSkill] then
        skillPower2 = skillPower2 + self.extData.hero[i + 5].effect[HeroEffectDefine.HeroPowerSkill]
      end
    end
  end
  self.SkillPower1:SetLocalText(GameDialogDefine.BATTLE_POWER, string.GetFormattedStr(math.floor(skillPower1)))
  self.SkillPower2:SetLocalText(GameDialogDefine.BATTLE_POWER, string.GetFormattedStr(math.floor(skillPower2)))
end

function MailHeroPage:RemoveSkillItems()
  self.SkillContent:RemoveComponents(MailSkillItem)
  if self.skillReqs then
    for _, v in pairs(self.skillReqs) do
      v:Destroy()
    end
    self.skillReqs = {}
  end
end

function MailHeroPage:RemoveEquipItems()
  self.EquipContent:RemoveComponents(MailEquipItem)
  if self.equipReqs then
    for _, v in pairs(self.equipReqs) do
      v:Destroy()
    end
    self.equipReqs = {}
  end
end

function MailHeroPage:OnReplayClick()
  local uuid = self.extData.uuid
  local isAddressMode = BattleReportUtil.IsAddressMode(self.extData.address)
  local address = self.extData.address
  if self.extData.pb_BattleReport and self.extData.pb_BattleReport.round and self.extData.pb_BattleReport.round[1] and self.extData.pb_BattleReport.round[1].battle and self.extData.pb_BattleReport.round[1].battle[1] and self.extData.pb_BattleReport.round[1].battle[1].uuid then
    uuid = self.extData.pb_BattleReport.round[1].battle[1].uuid
    isAddressMode = BattleReportUtil.IsAddressMode(self.extData.pb_BattleReport.round[1].battle[1].address)
    address = self.extData.pb_BattleReport.round[1].battle[1].address
  end
  if BattleReportUtil.UseCDNBattleReport() then
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIChampionDuelBattleLogDetail) then
      BattleReportUtil.Create(uuid, PVEEnterType.CD_BattleLog, nil, isAddressMode, address)
    else
      BattleReportUtil.Create(uuid, PVEEnterType.Mail, nil, isAddressMode, address)
    end
  else
    SFSNetwork.SendMessage(MsgDefines.MailGetFightReportDetail, uuid)
  end
  PostEventLog.Track(PostEventLog.Defines.click_enter_replay, {
    uuid = tostring(uuid)
  })
end

function MailHeroPage:OnLackSoldierTipsBtnClick(targetTipsBtn, soldierCount, soldierCapacity)
  local param = soldierCount / soldierCapacity * 100
  local integerPart, decimalPart = math.modf(param)
  local firstDecimalPart = math.floor(decimalPart * 10) % 10
  if 0 < firstDecimalPart then
    param = integerPart .. "." .. firstDecimalPart
  else
    param = integerPart
  end
  local content = Localization:GetString("458604", param)
  local position = targetTipsBtn.transform.position
  UIUtil:ShowSoldierNumBubbleTips(content, position, 0, -30, 0, nil, {
    soldierCount = math.floor(soldierCount),
    soldierCapacity = math.floor(soldierCapacity)
  })
end

function MailHeroPage:RefreshUniqueWeaponView()
  self:RemoveUniqueWeaponItems()
  local uniqueWeaponPower1, uniqueWeaponPower2 = 0, 0
  for i = PVPBattleSlot.SelfHero1, PVPBattleSlot.SelfHero5 do
    if self.extData.hero[i] then
      uniqueWeaponPower1 = uniqueWeaponPower1 + self.extData.hero[i].weaponPower
    end
    if self.extData.hero[i + 5] then
      uniqueWeaponPower2 = uniqueWeaponPower2 + self.extData.hero[i + 5].weaponPower
    end
  end
  local bothSidesHasUniqueWeapon = 0 < uniqueWeaponPower1 or 0 < uniqueWeaponPower2
  if bothSidesHasUniqueWeapon then
    self.uniqueWeaponView:SetActive(true)
  else
    self.uniqueWeaponView:SetActive(false)
    return
  end
  self.uw1InfoContainer:SetActive(0 < (self.extData.player[1].weaponStrengTotalLv or 0))
  self.uw2InfoContainer:SetActive(0 < (self.extData.player[2].weaponStrengTotalLv or 0))
  for i = 1, 5 do
    if self.extData.hero[i] and 0 < self.extData.hero[i].weaponLevel then
      self.uniqueWeaponReqs[i] = self:GameObjectInstantiateAsync(UIAssets.MailHeroWeaponCell_New, function(req)
        if IsNull(req.gameObject) then
          return
        end
        local item = req.gameObject
        item.name = "MailHeroWeaponCell_New" .. i
        item.transform:SetParent(self.uniqueWeaponLeft.transform)
        item.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local obj = self.uniqueWeaponLeft:AddComponent(MailHeroWeaponCellNew, item.name)
        obj:SetData(self.extData.hero[i].heroId, self.extData.hero[i].weaponLevel, self.extData.hero[i].heroInfo.uwUnitLvMap, self.extData.hero[i].heroSkinId)
      end)
    end
    if self.extData.hero[i + 5] and 0 < self.extData.hero[i + 5].weaponLevel then
      self.uniqueWeaponReqs[i + 5] = self:GameObjectInstantiateAsync(UIAssets.MailHeroWeaponCell_New, function(req)
        if IsNull(req.gameObject) then
          return
        end
        local item = req.gameObject
        item.name = "MailHeroWeaponCell_New" .. i + 5
        item.transform:SetParent(self.uniqueWeaponRight.transform)
        item.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local obj = self.uniqueWeaponRight:AddComponent(MailHeroWeaponCellNew, item.name)
        obj:SetData(self.extData.hero[i + 5].heroId, self.extData.hero[i + 5].weaponLevel, self.extData.hero[i + 5].heroInfo.uwUnitLvMap, self.extData.hero[i + 5].heroSkinId)
      end)
    end
  end
  self.uniqueWeaponPower1:SetLocalText(GameDialogDefine.BATTLE_POWER, string.GetFormattedStr(math.floor(uniqueWeaponPower1)))
  self.uniqueWeaponPower2:SetLocalText(GameDialogDefine.BATTLE_POWER, string.GetFormattedStr(math.floor(uniqueWeaponPower2)))
end

function MailHeroPage:RemoveUniqueWeaponItems()
  self.uniqueWeaponLeft:RemoveComponents(MailHeroWeaponCellNew)
  self.uniqueWeaponRight:RemoveComponents(MailHeroWeaponCellNew)
  if self.uniqueWeaponReqs then
    for _, v in pairs(self.uniqueWeaponReqs) do
      self:GameObjectDestroy(v)
    end
    self.uniqueWeaponReqs = {}
  end
end

return MailHeroPage
