local UILWTacticalWeaponTipView = BaseClass("UILWTacticalWeaponTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UIHeroSkillItem = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillItem")
local TacticalWeaponAttrLineItem = require("UI.UILWTacticalWeapon.Component.BasicPage.TacticalWeaponAttrLineItem")
local UILWSquadEquipItem = require("UI.UILWSquadEquipPanel.Component.UILWSquadEquipItem")
local UIHeroSkillEffectLine = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillEffectLine")
local SkillChipItem = require("UI.UILWTacticalWeapon.Component.SkillChipPage.SkillChipItem")
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")
local skill_chips_path = "Root/ImgBg/SkillChips"
local skill_chip_path = "Root/ImgBg/SkillChips/SkillChip%d"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
  if self.root then
    local trTransform = self.root.transform
    DOTween.Kill(trTransform)
    trTransform:Set_localScale(0, 0, 0)
    trTransform:DOScale(Vector3.New(1.05, 1.05, 0), 0.1):OnComplete(function()
      trTransform:DOScale(Vector3.one, 0.1)
    end):SetEase(CS.DG.Tweening.Ease.InOutCubic)
  end
end

local function OnDestroy(self)
  if self.root then
    local trTransform = self.root.transform
    DOTween.Kill(trTransform)
  end
  self.nextEffectGroup:RemoveComponents(UIHeroSkillEffectLine)
  self:ClearAttrs()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.bgCloseBtn = self:AddComponent(UIButton, "Panel")
  self.bgCloseBtn:SetOnClick(BindCallback(self, self.OnBtnCloseClickDirect))
  self.skillBasicInfo = self:AddComponent(UIBaseContainer, "Root/ImgBg/SkillBasicInfo")
  self.skillItem = self:AddComponent(UIHeroSkillItem, "Root/ImgBg/SkillBasicInfo/BasicInfo/SkillItem")
  self.skillNameText = self:AddComponent(UIText, "Root/ImgBg/SkillBasicInfo/BasicInfo/NameText")
  self.skillDescText = self:AddComponent(UIText, "Root/ImgBg/SkillBasicInfo/BasicInfo/SkillDescText")
  self.nextEffectGroup = self:AddComponent(UIBaseContainer, "Root/ImgBg/SkillBasicInfo/DescLayout/Viewport/Content/NextEffectGroup")
  self.nextEffectLineTemplate = self.transform:Find("Root/ImgBg/SkillBasicInfo/DescLayout/Viewport/Content/NextEffectGroup/NextEffectValueLine").gameObject
  self.nextEffectLineTemplate:GameObjectCreatePool()
  self.root = self:AddComponent(UIBaseContainer, "Root")
  self.bgRoot = self:AddComponent(UIBaseContainer, "Root/ImgBg")
  self.imgArrow = self:AddComponent(UIImage, "Root/ImgBg/Arrow")
  self.bg = self:AddComponent(UIBaseContainer, "Root/ImgBg/BaseInfo")
  self.weaponIcon = self:AddComponent(UIImage, "Root/ImgBg/BaseInfo/WeaponIcon")
  self.attrsContainer = self:AddComponent(UIBaseContainer, "Root/ImgBg/Attrs")
  self.attrLineTemplate = self:AddComponent(UIBaseContainer, "Root/ImgBg/Attrs/AttrLine")
  self.attrLineTemplate:SetActive(false)
  self.attrLineTemplate.gameObject:GameObjectCreatePool()
  self.equipItemsContainer = self:AddComponent(UIBaseContainer, "Root/ImgBg/BaseInfo/Equips")
  self.equipItems = {}
  for i = 1, 6 do
    local equipItem = self:AddComponent(UILWSquadEquipItem, "Root/ImgBg/BaseInfo/Equips/EquipItem" .. i)
    table.insert(self.equipItems, equipItem)
  end
  self.skillChipsContainer = self:AddComponent(UIBaseContainer, skill_chips_path)
  self.skillChips = {}
  for i = 1, 4 do
    local skillChip = self:AddComponent(SkillChipItem, string.format(skill_chip_path, i))
    table.insert(self.skillChips, skillChip)
  end
end

local function DataDefine(self)
end

local function ComponentDestroy(self)
  self.bgCloseBtn = nil
  self.skillBasicInfo = nil
  self.skillItem = nil
  self.skillNameText = nil
  self.skillDescText = nil
  self.root = nil
  self.bgRoot = nil
  self.imgArrow = nil
  self.bg = nil
  self.attrsContainer = nil
  self.attrLineTemplate = nil
  self.equipItemsContainer = nil
  self.equipItems = nil
end

local function DataDestroy(self)
  self.weaponInfo = nil
  self.skillData = nil
  self.alignObject = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnOpen(self)
  self.weaponInfo, self.equips, self.alignObject, self.skinId, self.chips, self.powerValue = self:GetUserData()
  if self.alignObject == nil or self.alignObject.gameObject == nil or not self.alignObject.gameObject.activeInHierarchy then
    self.ctrl.CloseSelf()
    return
  end
  if not self.powerValue then
    self.powerValue = 0
  end
  self:UpdateView()
end

local function UpdateView(self)
  self.root.transform:Set_localScale(1, 1, 1)
  self.root.transform:Set_localEulerAngles(0, 0, 0)
  if self.weaponInfo == nil then
    self.ctrl:CloseSelf()
    return
  end
  local skills = self.weaponInfo:GetSkillInfos()
  if not table.IsNullOrEmpty(skills) then
    self.skillData = skills[1]
  end
  self:RefreshAttrs()
  self:RefreshSkill()
  self:RefreshEquips()
  self:RefreshBaseInfo()
  self:RefreshChipsInfo()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bgRoot.transform)
  self:CheckAlign()
end

local function OnBtnCloseClick(self)
  self.nodeRoot.transform:Set_localScale(0, 0, 0)
  self.ctrl:CloseSelf()
end

local function OnBtnCloseClickDirect(self)
  self.ctrl.CloseSelf()
end

local Pivot_Max = 1.0
local Pivot_Min = 0.0
local Pivot_Mid = 0.5

local function CheckAlign(self)
  local _arrowX = 0
  local _arrowY = 0
  local _rotation = 0
  local ScreenSize = CS.UnityEngine.Screen
  local ScreenWidth = ScreenSize.width
  local ScreenHeight = ScreenSize.height
  local widthScale = ScreenWidth / DefaultScreenWidth
  local heightScale = ScreenHeight / DefaultScreenHeight
  local _rect = self.bgRoot.rectTransform.rect
  local BgWidth = _rect.width * widthScale
  local BgHeight = _rect.height * heightScale
  local alignObject = self.alignObject
  local _screenPos = PosConverse.UIWorldToScreenPos(alignObject.transform.position)
  local targetScreenPos = _screenPos
  local pivot = Vector2.New(0.5, 0.5)
  if _screenPos.x + BgWidth < ScreenWidth - 10 or _screenPos.x - BgWidth > 10 then
    if _screenPos.x + BgWidth < ScreenWidth - 10 then
      pivot.x = Pivot_Min
      _arrowX = -BgWidth / widthScale * 0.5
    elseif _screenPos.x - BgWidth > 10 then
      pivot.x = Pivot_Max
      _arrowX = BgWidth / widthScale * 0.5
    end
  else
    local offsetX = 0
    if 10 > _screenPos.x - BgWidth / 2 then
      offsetX = BgWidth / 2 - _screenPos.x
    elseif _screenPos.x + BgWidth / 2 > ScreenWidth - 10 then
      offsetX = ScreenWidth - _screenPos.x - BgWidth / 2
    end
    targetScreenPos.x = targetScreenPos.x + offsetX
    pivot.x = Pivot_Mid
    _arrowX = -offsetX / widthScale
  end
  if _screenPos.y + BgHeight < ScreenHeight - 10 or 10 < _screenPos.y - BgHeight then
    if _screenPos.y + BgHeight < ScreenHeight - 10 then
      pivot.y = Pivot_Min
      _arrowY = -BgHeight / heightScale * 0.5
    elseif 10 < _screenPos.y - BgHeight then
      pivot.y = Pivot_Max
      _arrowY = BgHeight / heightScale * 0.5
    end
  else
    pivot.y = Pivot_Mid
  end
  if pivot.x == Pivot_Max and pivot.y == Pivot_Min then
    _rotation = 270
    _arrowX = _arrowX + 8
    _arrowY = _arrowY + 20
  elseif pivot.x == Pivot_Max and pivot.y == Pivot_Max then
    _rotation = 270
    _arrowX = _arrowX + 8
    _arrowY = _arrowY - 16
  elseif pivot.x == Pivot_Max and pivot.y == Pivot_Mid then
    _rotation = 270
    _arrowX = _arrowX + 8
  elseif pivot.x == Pivot_Min and pivot.y == Pivot_Min then
    _rotation = 90
    _arrowX = _arrowX - 8
    _arrowY = _arrowY + 20
  elseif pivot.x == Pivot_Min and pivot.y == Pivot_Max then
    _rotation = 90
    _arrowX = _arrowX - 8
    _arrowY = _arrowY - 16
  elseif pivot.x == Pivot_Min and pivot.y == Pivot_Mid then
    _rotation = 90
    _arrowX = _arrowX - 8
  elseif pivot.x == Pivot_Mid and pivot.y == Pivot_Max then
    _rotation = 0
    _arrowY = _arrowY + 8
  elseif pivot.x == Pivot_Mid and pivot.y == Pivot_Min then
    _rotation = 180
    _arrowY = _arrowY - 4
  else
    _rotation = 0
    _arrowX = 9999
    _arrowY = 9999
  end
  self.imgArrow.transform.localRotation = Quaternion.Euler(0, 0, _rotation)
  self.imgArrow.rectTransform.anchoredPosition = Vector2.New(_arrowX, _arrowY)
  self.imgArrow:SetActive(true)
  self.bgRoot.rectTransform.pivot = pivot
  local uiPos = PosConverse.ScreenToUIPos(self.root.transform, targetScreenPos)
  self.bgRoot.transform.anchoredPosition = uiPos
end

local function ClearAttrs(self)
  if self.attrsContainer then
    self.attrsContainer:RemoveComponents(TacticalWeaponAttrLineItem)
  end
  if self.attrLineTemplate and not IsNull(self.attrLineTemplate.gameObject) then
    self.attrLineTemplate.gameObject:GameObjectRecycleAll()
  end
  self.attrLines = {}
end

local function RefreshAttrs(self)
  self:ClearAttrs()
  if not self.weaponInfo then
    return
  end
  local basicAttrs = {}
  for i = 1, #TacticalWeaponUtils.ShowEffects do
    local id = TacticalWeaponUtils.ShowEffects[i]
    local value = self.weaponInfo:GetProperty(id)
    table.insert(basicAttrs, {id = id, value = value})
  end
  for i = 1, #basicAttrs do
    local attr = basicAttrs[i]
    local rewardName = "attr_" .. attr.id
    local goItem = self.attrLineTemplate.gameObject:GameObjectSpawn(self.attrsContainer.transform)
    goItem.name = rewardName
    goItem:SetActive(true)
    local theItem = self.attrsContainer:AddComponent(TacticalWeaponAttrLineItem, rewardName)
    theItem:SetValue(attr.id, attr.value)
    theItem:SetMaster(self.weaponInfo)
    self.attrLines[attr.id] = theItem
  end
end

local function RefreshSkill(self)
  if self.skillData == nil then
    self.skillBasicInfo:SetActive(false)
    return
  else
    self.skillBasicInfo:SetActive(true)
  end
  self.skillItem:SetData(self.skillData, {
    showSkillName = false,
    showSkillLevel = false,
    showLock = false,
    showStar = true
  }, nil)
  local nameStr = self.skillData:GetName()
  self.skillNameText:SetText(nameStr)
  self.skillDescText:SetText(self.skillData:GetDesc(false, "#5FEF87"))
  self.nextEffectGroup:RemoveComponents(UIHeroSkillEffectLine)
  self.nextEffectLineTemplate.gameObject:GameObjectRecycleAll()
  local normalSkillLvLimit
  local weaponInfo = DataCenter.TacticalWeaponManager:GetFirstWeaponInfo()
  if weaponInfo then
    local maxLv = weaponInfo:GetRealMaxLevel()
    local levelTemp = weaponInfo:GetLevelTemplate(maxLv)
    if levelTemp then
      local skillId = levelTemp.skill
      local skillTemp = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
      if skillTemp then
        normalSkillLvLimit = skillTemp.star
      end
    end
  end
  local realSkillLvLimit
  if normalSkillLvLimit then
    realSkillLvLimit = normalSkillLvLimit + DataCenter.TacticalWeaponManager:GetMainWeaponSkillStarExtra()
  end
  local effectsDesc = self.skillData:GetEffectsDescWeapon()
  if 0 < #effectsDesc then
    for i = 1, #effectsDesc do
      if not realSkillLvLimit or realSkillLvLimit >= effectsDesc[i].unlockStar then
        self.nextEffectGroup:SetActive(true)
        local item = self.nextEffectLineTemplate:GameObjectSpawn(self.nextEffectGroup.transform)
        item.name = "item" .. i
        local cell = self.nextEffectGroup:AddComponent(UIHeroSkillEffectLine, item.name)
        cell:SetData(effectsDesc[i].isUnlock, effectsDesc[i].outDesc, i)
      end
    end
  else
    self.nextEffectGroup:SetActive(false)
  end
end

local function RefreshEquips(self)
  if table.IsNullOrEmpty(self.equips) then
    self.equipItemsContainer:SetActive(false)
    return
  else
    self.equipItemsContainer:SetActive(true)
    for i = 1, #self.equipItems do
      local equipData = self.equips[i]
      if equipData then
        self.equipItems[i]:SetDataForMail(equipData)
      else
        self.equipItems[i]:SetDataForMail(i)
      end
    end
  end
end

local function RefreshBaseInfo(self)
  if not self.weaponInfo then
    return
  end
  local appearance = DataCenter.TacticalWeaponManager:GetWeaponAppearanceData(self.weaponInfo, self.skinId)
  if appearance then
    self.weaponIcon:SetActive(true)
    self.weaponIcon:LoadSpriteAuto(HeroUtils.GetHeroIconPath(appearance, HeroIconType.half_portrait))
  else
    self.weaponIcon:SetActive(false)
  end
end

local function RefreshChipsInfo(self)
  if table.IsNullOrEmpty(self.chips) then
    self.skillChipsContainer:SetActive(false)
    return
  else
    self.skillChipsContainer:SetActive(true)
    local typeMap = {}
    for i = 1, #self.chips do
      local chipInfo = self.chips[i]
      if chipInfo then
        local chipType = DataCenter.TWSkillChipTemplateManager:GetTypeById(chipInfo.cfgId)
        if chipType then
          typeMap[chipType] = chipInfo
        end
      end
    end
    for i = 1, #self.skillChips do
      local chipInfo = typeMap[i]
      if chipInfo then
        self.skillChips[i]:SetTemplate(chipInfo.cfgId, chipInfo.lv, chipInfo.star)
      else
        self.skillChips[i]:SetSlot(i)
      end
    end
  end
end

UILWTacticalWeaponTipView.OnCreate = OnCreate
UILWTacticalWeaponTipView.OnDestroy = OnDestroy
UILWTacticalWeaponTipView.OnEnable = OnEnable
UILWTacticalWeaponTipView.OnDisable = OnDisable
UILWTacticalWeaponTipView.OnAddListener = OnAddListener
UILWTacticalWeaponTipView.OnRemoveListener = OnRemoveListener
UILWTacticalWeaponTipView.ComponentDefine = ComponentDefine
UILWTacticalWeaponTipView.DataDefine = DataDefine
UILWTacticalWeaponTipView.ComponentDestroy = ComponentDestroy
UILWTacticalWeaponTipView.DataDestroy = DataDestroy
UILWTacticalWeaponTipView.OnOpen = OnOpen
UILWTacticalWeaponTipView.OnBtnCloseClick = OnBtnCloseClick
UILWTacticalWeaponTipView.OnBtnCloseClickDirect = OnBtnCloseClickDirect
UILWTacticalWeaponTipView.UpdateView = UpdateView
UILWTacticalWeaponTipView.CheckAlign = CheckAlign
UILWTacticalWeaponTipView.ClearAttrs = ClearAttrs
UILWTacticalWeaponTipView.RefreshAttrs = RefreshAttrs
UILWTacticalWeaponTipView.RefreshSkill = RefreshSkill
UILWTacticalWeaponTipView.RefreshEquips = RefreshEquips
UILWTacticalWeaponTipView.RefreshBaseInfo = RefreshBaseInfo
UILWTacticalWeaponTipView.RefreshChipsInfo = RefreshChipsInfo
return UILWTacticalWeaponTipView
