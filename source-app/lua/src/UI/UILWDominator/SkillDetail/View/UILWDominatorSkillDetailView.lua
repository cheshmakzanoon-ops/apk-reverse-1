local UILWDominatorSkillDetailView = BaseClass("UILWDominatorSkillDetailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UIHeroSkillItem = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillItem")
local UIHeroSkillEffectLine = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillEffectLine")
local UIHeroSkillStar = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillStar")
local UIHeroSkillDesc = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillDesc")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
  if self.root then
    local trTransform = self.root.transform
    DOTween.Kill(trTransform)
    trTransform:Set_localScale(0, 0, 0)
    trTransform:DOScale(Vector3.New(1.1, 1.1, 0), 0.1):OnComplete(function()
      trTransform:DOScale(Vector3.one, 0.1)
    end):SetEase(CS.DG.Tweening.Ease.InOutCubic)
  end
end

local function OnDestroy(self)
  if self.root then
    local trTransform = self.root.transform
    DOTween.Kill(trTransform)
  end
  if self.delayRefresh then
    self.delayRefresh:Stop()
    self.delayRefresh = nil
  end
  self.nextEffectGroup:RemoveComponents(UIHeroSkillEffectLine)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.bgCloseBtn = self:AddComponent(UIButton, "Panel")
  self.bgCloseBtn:SetOnClick(BindCallback(self, self.OnBtnCloseClickDirect))
  self.skillBasicInfo = self:AddComponent(UIBaseContainer, "Root/ImgBg/SkillBasicInfo")
  self.skillItem = self:AddComponent(UIHeroSkillItem, "Root/ImgBg/SkillBasicInfo/SkillItem")
  self.nameText = self:AddComponent(UIText, "Root/ImgBg/SkillBasicInfo/NameText")
  self.skillDescText = self:AddComponent(UIHeroSkillDesc, "Root/ImgBg/DescLayout/Viewport/Content/SkillDescText")
  self.nextEffectGroup = self:AddComponent(UIBaseContainer, "Root/ImgBg/DescLayout/Viewport/Content/NextEffectGroup")
  self.nextEffectLineTemplate = self.transform:Find("Root/ImgBg/DescLayout/Viewport/Content/NextEffectGroup/NextEffectValueLine").gameObject
  self.nextEffectLineTemplate:GameObjectCreatePool()
  self.root = self:AddComponent(UIBaseContainer, "Root")
  self.bgRoot = self:AddComponent(UIBaseContainer, "Root/ImgBg")
  self.imgArrow = self:AddComponent(UIImage, "Root/ImgBg/Arrow")
  self.lockContent = self:AddComponent(UIBaseContainer, "Root/ImgBg/LockContent")
  self.skillStars = self:AddComponent(UIBaseContainer, "Root/ImgBg/SkillBasicInfo/SkillStars")
  self.skillStarTemplate = self.transform:Find("Root/ImgBg/SkillBasicInfo/SkillStars/SkillStar").gameObject
  self.skillStarTemplate:GameObjectCreatePool()
end

local function DataDefine(self)
end

local function ComponentDestroy(self)
  self.bgCloseBtn = nil
  self.skillItem = nil
  self.nameText = nil
  self.skillDescText = nil
  self.nextEffectGroup = nil
  self.nextEffectLineTemplate.gameObject:GameObjectRecycleAll()
  self.nextEffectLineTemplate = nil
  self.root = nil
  self.bgRoot = nil
  self.imgArrow = nil
  self.lockContent = nil
  self.skillStars = nil
  self.skillStarTemplate.gameObject:GameObjectRecycleAll()
  self.skillStarTemplate = nil
end

local function DataDestroy(self)
  self.skillData = nil
  self.skillId = nil
  self.level = nil
  self.isUnlock = nil
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
  self.skillData, self.alignObject, self.isWeapon = self:GetUserData()
  self.skillSlotIndex = self.skillData:GetSlotIndex()
  if self.alignObject.gameObject == nil or not self.alignObject.gameObject.activeInHierarchy then
    self.ctrl.CloseSelf()
    return
  end
  self.skillId = self.skillData:GetId()
  self.level = self.skillData:GetLevel()
  self.isUnlock = self.skillData:IsUnlock()
  self:UpdateView()
end

local function UpdateView(self)
  self.root.transform:Set_localScale(1, 1, 1)
  self.root.transform:Set_localEulerAngles(0, 0, 0)
  if self.skillData == nil then
    return
  end
  if not self.skillData then
    return
  end
  self.skillItem:SetData(self.skillData, {
    showSkillName = false,
    showSkillLevel = false,
    showLock = false
  }, nil)
  local nameStr = self.skillData:GetName()
  if self.isWeapon then
    self.nameText:SetText(nameStr)
  elseif self.skillData:IsUnlock() then
    local levelStr = string.format("Lv.%d/%d", self.skillData:GetLevel(), self.skillData:GetMaxLevel())
    local resultStr = string.format("%s (%s)", nameStr, levelStr)
    self.nameText:SetText(resultStr)
  else
    local resultStr = string.format("%s (%s)", nameStr, Localization:GetString(120050))
    self.nameText:SetText(resultStr)
  end
  self.skillStars:RemoveComponents(UIHeroSkillStar)
  self.skillStarTemplate.gameObject:GameObjectRecycleAll()
  local maxStar = self.skillData:GetMaxStar()
  local curStar = self.skillData:GetStar()
  if 1 <= maxStar then
    for i = 1, maxStar do
      local item = self.skillStarTemplate:GameObjectSpawn(self.skillStars.transform)
      item.name = "star" .. i
      local cell = self.skillStars:AddComponent(UIHeroSkillStar, item.name)
      cell:SetFilled(i <= curStar)
      if i <= curStar then
        cell:SetStarIndex(i)
      end
    end
  end
  self.skillDescText:SetText(self.skillData:GetDesc(false, "#5FEF87"))
  self.nextEffectGroup:RemoveComponents(UIHeroSkillEffectLine)
  self.nextEffectLineTemplate.gameObject:GameObjectRecycleAll()
  local effectsDesc = self.skillData:GetEffectsDesc()
  if 0 < #effectsDesc then
    for i = 1, #effectsDesc do
      self.nextEffectGroup:SetActive(true)
      local item = self.nextEffectLineTemplate:GameObjectSpawn(self.nextEffectGroup.transform)
      item.name = "item" .. i
      local cell = self.nextEffectGroup:AddComponent(UIHeroSkillEffectLine, item.name)
      cell:SetData(effectsDesc[i].isUnlock, effectsDesc[i].outDesc, i)
    end
  else
    self.nextEffectGroup:SetActive(false)
  end
  self.lockContent:SetActive(not self.skillData:IsUnlock() and not self.isWeapon)
  self.delayRefresh = TimerManager:GetInstance():DelayFrameInvoke(function()
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bgRoot.transform)
  end, 1)
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

UILWDominatorSkillDetailView.OnCreate = OnCreate
UILWDominatorSkillDetailView.OnDestroy = OnDestroy
UILWDominatorSkillDetailView.OnEnable = OnEnable
UILWDominatorSkillDetailView.OnDisable = OnDisable
UILWDominatorSkillDetailView.OnAddListener = OnAddListener
UILWDominatorSkillDetailView.OnRemoveListener = OnRemoveListener
UILWDominatorSkillDetailView.ComponentDefine = ComponentDefine
UILWDominatorSkillDetailView.DataDefine = DataDefine
UILWDominatorSkillDetailView.ComponentDestroy = ComponentDestroy
UILWDominatorSkillDetailView.DataDestroy = DataDestroy
UILWDominatorSkillDetailView.OnOpen = OnOpen
UILWDominatorSkillDetailView.OnBtnCloseClick = OnBtnCloseClick
UILWDominatorSkillDetailView.OnBtnCloseClickDirect = OnBtnCloseClickDirect
UILWDominatorSkillDetailView.UpdateView = UpdateView
UILWDominatorSkillDetailView.CheckAlign = CheckAlign
return UILWDominatorSkillDetailView
