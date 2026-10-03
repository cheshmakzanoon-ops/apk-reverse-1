local UIGhostreconFormationConditionPanel = BaseClass("UIGhostreconFormationConditionPanel", UIBaseContainer)
local base = UIBaseContainer
local titleText_path = "TitleText"
local type_icon1_path = "conditions/require1/typeIcon1"
local num_text1_path = "conditions/require1/NumText1"
local type_icon2_path = "conditions/require2/typeIcon2"
local num_text2_path = "conditions/require2/NumText2"
local num_text3_path = "conditions/require3/NumText3"
local req4lv_text_path = "conditions/require4/req4lvText"
local num_text4_path = "conditions/require4/NumText4"
local require_path = "conditions/require"
local star_path = "conditions/require3/star"
local level_tip_text_path = "conditions/require4/levelTipText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.type_icon1 = self:AddComponent(UIImage, type_icon1_path)
  self.num_text1 = self:AddComponent(UIText, num_text1_path)
  self.type_icon2 = self:AddComponent(UIImage, type_icon2_path)
  self.num_text2 = self:AddComponent(UIText, num_text2_path)
  self.num_text3 = self:AddComponent(UIText, num_text3_path)
  self.req4lv_text = self:AddComponent(UIText, req4lv_text_path)
  self.num_text4 = self:AddComponent(UIText, num_text4_path)
  self.level_tip_text = self:AddComponent(UIText, level_tip_text_path)
  self.titleText:SetLocalText("ghostrecon_026")
  self.level_tip_text:SetText("Level")
  self.stars = {}
  for i = 1, 5 do
    table.insert(self.stars, self:AddComponent(UIBaseContainer, star_path .. i))
  end
  self.conditionNodes = {}
  for i = 1, 4 do
    self.conditionNodes[i] = self:AddComponent(UIImage, require_path .. i)
  end
end

local function ComponentDestroy(self)
  self.titleText = nil
  self.type_icon1 = nil
  self.num_text1 = nil
  self.type_icon2 = nil
  self.num_text2 = nil
  self.num_text3 = nil
  self.req4lv_text = nil
  self.num_text4 = nil
  self.stars = nil
  self.conditionNodes = nil
  self.level_tip_text = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.conditions = nil
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function SetData(self, conditions)
  self.conditions = conditions
  for _, v in pairs(self.conditionNodes) do
    v:SetActive(false)
  end
  for _, v in pairs(conditions) do
    local k = v.type
    self.conditionNodes[k]:SetActive(true)
    if k == 1 then
      self.type_icon1:LoadSprite(HeroUtils.GetHeroTypeIcon(v.value))
    elseif k == 2 then
      self.type_icon2:LoadSprite(HeroUtils.GetHeroQualityTagImg(v.value))
      self.type_icon2:SetNativeSize()
    elseif k == 3 then
      local starCon = toInt((v.value - 1) / 5)
      for i = 1, 5 do
        self.stars[i]:SetActive(i <= starCon)
      end
    elseif k == 4 then
      self.req4lv_text:SetText(tostring(v.value))
    end
  end
end

local function RefreshSelectHero(self, condNumTable)
  local meetAllCondition = true
  for _, v in pairs(self.conditions) do
    local k = v.type
    if condNumTable[k] >= v.num then
      self["num_text" .. k]:SetLocalText(135225, condNumTable[k], v.num)
      self.conditionNodes[k]:SetColor(Color.New(0.8509803921568627, 0.9411764705882353, 0.7843137254901961, 1))
    else
      meetAllCondition = false
      self["num_text" .. k]:SetLocalText(456222, condNumTable[k], v.num)
      self.conditionNodes[k]:SetColor(Color.New(0.9215686274509803, 0.8941176470588236, 0.8862745098039215, 1))
    end
  end
  return meetAllCondition
end

UIGhostreconFormationConditionPanel.OnCreate = OnCreate
UIGhostreconFormationConditionPanel.OnDestroy = OnDestroy
UIGhostreconFormationConditionPanel.OnEnable = OnEnable
UIGhostreconFormationConditionPanel.OnDisable = OnDisable
UIGhostreconFormationConditionPanel.ComponentDefine = ComponentDefine
UIGhostreconFormationConditionPanel.ComponentDestroy = ComponentDestroy
UIGhostreconFormationConditionPanel.DataDefine = DataDefine
UIGhostreconFormationConditionPanel.DataDestroy = DataDestroy
UIGhostreconFormationConditionPanel.OnAddListener = OnAddListener
UIGhostreconFormationConditionPanel.OnRemoveListener = OnRemoveListener
UIGhostreconFormationConditionPanel.SetData = SetData
UIGhostreconFormationConditionPanel.RefreshSelectHero = RefreshSelectHero
return UIGhostreconFormationConditionPanel
