local UILWTWSkillChipChangeSuccessView = BaseClass("UILWTWSkillChipChangeSuccessView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIChipChangeSuccessLine = require("UI.UILWTWSkillChip.UILWTWSkillChipChangeSuccess.Component.UIChipChangeSuccessLine")
local SkillChipItem = require("UI.UILWTacticalWeapon.Component.SkillChipPage.SkillChipItem")
local UIHeroSkillEffectLine = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillEffectLine")
local title_path = "UIGarageRefitUpgrade/UICommonRewardPopUp/Panel/ImgTitleBg/TextTitle"
local next_path = "UIGarageRefitUpgrade/UICommonRewardPopUp/Panel"
local root_path = "UIGarageRefitUpgrade/Root"
local content_path = "UIGarageRefitUpgrade/Root/Content"
local equipItem_path = "UIGarageRefitUpgrade/Root/UILWTWSkillChipItem"
local eff_ui_icon_hammer1_path = "UIGarageRefitUpgrade/Root/Eff_ui_icon_hammer 1"
local skill_effect_line_change_path = "UIGarageRefitUpgrade/Root/Content/SkillEffectLineChange"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function CloseSelfWindow(self)
  self.ctrl:CloseSelf()
  if self.closeCallback then
    self.closeCallback()
  end
end

local function ComponentDefine(self)
  self.title_text = self:AddComponent(UIText, title_path)
  self.next_btn = self:AddComponent(UIButton, next_path)
  self.next_btn:SetOnClick(function()
    CloseSelfWindow(self)
  end)
  self.root_anim = self:AddComponent(UIAnimator, root_path)
  self.content_go = self:AddComponent(UIBaseContainer, content_path)
  self.equipItem = self:AddComponent(SkillChipItem, equipItem_path)
  self.upgrade_effect = self:AddComponent(UIBaseContainer, eff_ui_icon_hammer1_path)
  self.upgrade_effect:SetActive(false)
  self.skill_effect_line_change = self:AddComponent(UIHeroSkillEffectLine, skill_effect_line_change_path)
end

local function ComponentDestroy(self)
  self:ClearItems()
  self.title_text = nil
  self.next_btn = nil
  self.root_anim = nil
  self.item_anim = nil
  self.content_go = nil
  self.equipItem = nil
end

local function DataDefine(self)
  self.reqs = {}
  self.active = false
  self.onClose = nil
  self.rewardReqs = {}
end

local function DataDestroy(self)
  self.reqs = nil
  self.active = nil
  self.onClose = nil
  self.rewardReqs = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  if self.delayHide then
    self.delayHide:Stop()
    self.delayHide = nil
  end
  self.active = false
  base.OnDisable(self)
end

local function ReInit(self)
  self.equipUuid, self.srcLevel, self.srcStar, self.closeCallback = self:GetUserData()
  self.equipData = DataCenter.TWSkillChipManager:GetChipInfo(self.equipUuid)
  self:Show()
end

local level_effectId = 50156

local function Show(self)
  if self.root_anim ~= nil then
    self.root_anim:SampleAnimationAtTime("V_ui_bujianshengji_01_anim", 0, 0)
    self.root_anim:Play("V_ui_bujianshengji_01_anim", 0, 0)
  end
  DataCenter.LWSoundManager:PlaySound(61010, false)
  if not self.equipData then
    CloseSelfWindow(self)
    return
  end
  local isUpgrade = false
  local isStarUp = false
  local curLevel = self.equipData:GetLevel()
  local curStar = self.equipData:GetStar()
  if self.srcLevel and curLevel > self.srcLevel then
    isUpgrade = true
  elseif self.srcStar and curStar > self.srcStar then
    isStarUp = true
  end
  if self.equipData then
    self.equipItem:SetActive(true)
    self.equipItem:SetData(self.equipData, nil, false, false, true)
    if isUpgrade then
      self.equipItem:SetLevelText(self.srcLevel)
      self.upgrade_effect:SetActive(true)
      self.equipItem:AnimRefreshLevelText(0.3, 1.2)
      self.delayHide = TimerManager:GetInstance():DelayInvoke(function()
        self.upgrade_effect:SetActive(false)
        self.delayHide = nil
      end, 2)
    elseif isStarUp then
      self.equipItem:SetStars(self.srcStar)
      self.equipItem:SetStars(self.equipData:GetStar(), self.equipData:GetStar())
    end
  end
  self.skill_effect_line_change:SetActive(isStarUp)
  if isUpgrade then
    local changedEffects = {}
    local oldChipTemplate = TWSkillChipInfo.New()
    oldChipTemplate:CreateFromTemplate(self.equipData:GetId(), self.srcLevel, self.equipData:GetStar())
    local lvLineData = {}
    lvLineData.id = level_effectId
    lvLineData.prevValue = self.srcLevel
    lvLineData.value = curLevel
    table.insert(changedEffects, lvLineData)
    local curProperties = self.equipData:GetSortedProperties()
    local oldProperties = oldChipTemplate:GetProperties()
    for _, data in pairs(curProperties) do
      local id = data.id
      local value = data.value
      local oldValue = oldProperties[id]
      if oldValue == nil or oldValue ~= nil and oldValue ~= value then
        local lineData = {}
        lineData.id = id
        lineData.prevValue = oldValue
        lineData.value = value
        table.insert(changedEffects, lineData)
      end
    end
    for i, data in pairs(changedEffects) do
      local req = Resource:InstantiateAsync(UIAssets.UIEquipPromoteSuccessCell)
      req:completed("+", function()
        if req.isError then
          return
        end
        if not self.gameObject or not self.active then
          req:Destroy()
          return
        end
        CommonUtil.CallAutoArabicMirrorManually(req)
        local go = req.gameObject
        go:SetActive(true)
        go.name = "Line_" .. tostring(i)
        local tf = go.transform
        tf:SetParent(self.content_go.transform)
        tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local item = self.content_go:AddComponent(UIChipChangeSuccessLine, go)
        item:SetData(data.id, data.prevValue, data.value)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content_go.transform)
        self.reqs[i] = req
      end)
    end
  else
    local skillInfo = self.equipData:GetSkillInfo()
    local star = self.equipData:GetStar()
    local effectLines = skillInfo:GetEffectsDesc()
    self.skill_effect_line_change:SetData(true, effectLines[star] ~= nil and effectLines[star].outDesc or "", star)
  end
end

local function ClearItems(self)
  if self.content_go then
    self.content_go:RemoveComponents(UIChipChangeSuccessLine)
  end
  if self.reqs then
    for _, req in pairs(self.reqs) do
      req:Destroy()
    end
  end
end

UILWTWSkillChipChangeSuccessView.OnCreate = OnCreate
UILWTWSkillChipChangeSuccessView.OnDestroy = OnDestroy
UILWTWSkillChipChangeSuccessView.ComponentDefine = ComponentDefine
UILWTWSkillChipChangeSuccessView.ComponentDestroy = ComponentDestroy
UILWTWSkillChipChangeSuccessView.DataDefine = DataDefine
UILWTWSkillChipChangeSuccessView.DataDestroy = DataDestroy
UILWTWSkillChipChangeSuccessView.OnEnable = OnEnable
UILWTWSkillChipChangeSuccessView.OnDisable = OnDisable
UILWTWSkillChipChangeSuccessView.ReInit = ReInit
UILWTWSkillChipChangeSuccessView.ClearItems = ClearItems
UILWTWSkillChipChangeSuccessView.Show = Show
return UILWTWSkillChipChangeSuccessView
