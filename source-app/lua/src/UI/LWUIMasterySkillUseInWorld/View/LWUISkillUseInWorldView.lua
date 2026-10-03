local LWUISkillUseInWorldView = BaseClass("LWUISkillUseInWorldView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWUICitySkinSkillUseInWorldContent = require("UI.LWUIMasterySkillUseInWorld.Component.LWUICitySkinSkillUseInWorldContent")
local LWUIMasterySkillUseInWorldContent = require("UI.LWUIMasterySkillUseInWorld.Component.LWUIMasterySkillUseInWorldContent")
local LWUITCCardSkillUseInWorldContent = require("UI.LWUIMasterySkillUseInWorld.Component.LWUITCCardSkillUseInWorldContent")
local LWUITitleSkillUseInWorldContent = require("UI.LWUIMasterySkillUseInWorld.Component.LWUITitleSkillUseInWorldContent")
local return_btn_path = "UICommonMiniPopUpTitle/panel"
local toggle1_path = "Root/selectContent/selectBg/Toggle1"
local selectToggle1_path = "Root/selectContent/selectBg/Toggle1/selectToggle1"
local toggle2_path = "Root/selectContent/selectBg/Toggle2"
local selectToggle2_path = "Root/selectContent/selectBg/Toggle2/selectToggle2"
local toggle3_path = "Root/selectContent/selectBg/Toggle3"
local select_toggle3_path = "Root/selectContent/selectBg/Toggle3/selectToggle3"
local toggle4_path = "Root/selectContent/selectBg/Toggle4"
local select_toggle4_path = "Root/selectContent/selectBg/Toggle4/selectToggle4"
local mastery_skill_content_path = "Root/MasterySkillContent"
local city_skin_skill_content_path = "Root/CitySkinSkillContent"
local title_skill_content_path = "Root/TitleSkillContent"
local t_c_card_skill_content_path = "Root/TCCardSkillContent"
local title_text_path = "UICommonMiniPopUpTitle/titleText"
local select_content_path = "Root/selectContent"
local toggleType = {
  SkillUseInWorldType.MasterySkill,
  SkillUseInWorldType.CitySkinSkill,
  SkillUseInWorldType.TitleSkill,
  SkillUseInWorldType.TCCardSkill
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn = self:AddComponent(UIButton, "UICommonMiniPopUpTitle/CloseBtn")
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.toggle1 = self:AddComponent(UIButton, toggle1_path)
  self.toggle1:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnToggleSelect(1)
  end)
  self.selectToggle1 = self:AddComponent(UIBaseContainer, selectToggle1_path)
  self.toggle2 = self:AddComponent(UIButton, toggle2_path)
  self.toggle2:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnToggleSelect(2)
  end)
  self.selectToggle2 = self:AddComponent(UIBaseContainer, selectToggle2_path)
  self.toggle3 = self:AddComponent(UIButton, toggle3_path)
  self.toggle3:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnToggleSelect(3)
  end)
  self.selectToggle3 = self:AddComponent(UIBaseContainer, select_toggle3_path)
  self.toggle4 = self:AddComponent(UIButton, toggle4_path)
  self.toggle4:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnToggleSelect(4)
  end)
  self.selectToggle4 = self:AddComponent(UIBaseContainer, select_toggle4_path)
  self.toggleList = {
    [1] = {
      toggle = self.toggle1,
      selectToggle = self.selectToggle1
    },
    [2] = {
      toggle = self.toggle2,
      selectToggle = self.selectToggle2
    },
    [3] = {
      toggle = self.toggle3,
      selectToggle = self.selectToggle3
    },
    [4] = {
      toggle = self.toggle4,
      selectToggle = self.selectToggle4
    }
  }
  self.mastery_skill_content = self:AddComponent(LWUIMasterySkillUseInWorldContent, mastery_skill_content_path)
  self.city_skin_skill_content = self:AddComponent(LWUICitySkinSkillUseInWorldContent, city_skin_skill_content_path)
  self.tc_card_skill_content = self:AddComponent(LWUITCCardSkillUseInWorldContent, t_c_card_skill_content_path)
  self.title_skill_content = self:AddComponent(LWUITitleSkillUseInWorldContent, title_skill_content_path)
  self.contentList = {
    [1] = self.mastery_skill_content,
    [2] = self.city_skin_skill_content,
    [3] = self.title_skill_content,
    [4] = self.tc_card_skill_content
  }
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.select_content = self:AddComponent(UIBaseContainer, select_content_path)
end

local function ComponentDestroy(self)
  self.return_btn = nil
  self.close_btn = nil
  self.toggle1 = nil
  self.selectToggle1 = nil
  self.toggle2 = nil
  self.selectToggle2 = nil
  self.toggle3 = nil
  self.selectToggle3 = nil
  self.toggleList = nil
  self.mastery_skill_content = nil
  self.city_skin_skill_content = nil
  self.title_skill_content = nil
  self.contentList = nil
  self.title_text = nil
  self.select_content = nil
end

local function DataDefine(self)
  self.usePos = nil
  self.pointId = nil
  self.selectIndex = nil
  self.jumpSelectType = nil
  self.toggleShowIndexList = {}
  self.toggleOpenDict = {}
  self.usePos, self.pointId, self.jumpSelectType, self.serverId = self:GetUserData()
end

local function DataDestroy(self)
  self.usePos = nil
  self.pointId = nil
  self.selectIndex = nil
  self.jumpSelectType = nil
  self.toggleShowIndexList = nil
  self.toggleOpenDict = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  self:InitData()
  self:InitView()
  self:Refresh()
end

local function InitData(self)
  local pointId = self.pointId
  local info = CS.SceneManager.World:GetPointInfo(pointId)
  self.toggleShowIndexList = {}
  self.toggleOpenDict = {}
  for i, v in ipairs(toggleType) do
    local isOpen = self:IsToggleOpen(v, info)
    self.toggleOpenDict[i] = isOpen
    if isOpen then
      table.insert(self.toggleShowIndexList, i)
    end
  end
  self.selectIndex = -1
  if self.jumpSelectType then
    for i, index in ipairs(self.toggleShowIndexList) do
      if toggleType[index] == self.jumpSelectType then
        self.selectIndex = index
        break
      end
    end
    if self.selectIndex <= 0 then
      self.selectIndex = self.toggleShowIndexList[1]
    end
  else
    self.selectIndex = self.toggleShowIndexList[1]
  end
end

local function InitView(self)
  for k, v in pairs(self.toggleList) do
    local isOpen = self.toggleOpenDict[k]
    v.toggle:SetActive(isOpen)
  end
  local selectContentH = self.select_content:GetSizeDelta().y
  if #self.toggleShowIndexList > 1 then
    self.select_content:SetActive(true)
    for k, v in pairs(self.contentList) do
      v:SetOffsetMaxXY(0, -1 * selectContentH)
    end
  else
    self.select_content:SetActive(false)
    for k, v in pairs(self.contentList) do
      v:SetOffsetMaxXY(0, 0)
    end
  end
  if #self.toggleShowIndexList > 1 then
    self.title_text:SetLocalText("151039")
  elseif #self.toggleShowIndexList == 1 then
    local type = toggleType[self.toggleShowIndexList[1]]
    if type == SkillUseInWorldType.MasterySkill then
      self.title_text:SetLocalText("season_mastery_093")
    elseif type == SkillUseInWorldType.CitySkinSkill then
      self.title_text:SetLocalText("decoration_skill_title1")
    elseif type == SkillUseInWorldType.TitleSkill then
      self.title_text:SetLocalText("lw_title_ui_14")
    end
  end
end

local function OnToggleSelect(self, index)
  if self.selectIndex == index then
    return
  end
  self.selectIndex = index
  self:Refresh()
end

local function Refresh(self)
  for k, v in pairs(self.toggleList) do
    if k == self.selectIndex then
      v.selectToggle:SetActive(true)
    else
      v.selectToggle:SetActive(false)
    end
  end
  for k, v in pairs(self.contentList) do
    if k == self.selectIndex then
      v:SetActive(true)
      v:SetData(self.usePos, self.pointId, self.serverId)
    else
      v:SetActive(false)
    end
  end
end

local function IsToggleOpen(self, OnToggleSelectype, pointInfo)
  local isOpen = false
  local isDragonWorld = BattleFieldUtil.InBattleField()
  if OnToggleSelectype == SkillUseInWorldType.MasterySkill then
    isOpen = DataCenter.MasteryManager:IsShowWorldMasteryBtn() and not isDragonWorld
  elseif OnToggleSelectype == SkillUseInWorldType.CitySkinSkill then
    if self.usePos == MasterySkillUsePosType.Building and pointInfo and pointInfo.ownerUid == LuaEntry.Player.uid and pointInfo:IsNormalType() then
      isOpen = DataCenter.CitySkinSkillManager:IsHaveSkillShow()
    end
  elseif OnToggleSelectype == SkillUseInWorldType.TCCardSkill then
    isOpen = TacticalCardUtil.IsShowWorldMasteryBtn()
    if isOpen and self.usePos == MasterySkillUsePosType.Building and self.pointId and self.pointId ~= LuaEntry.Player:GetMainWorldPos() then
      isOpen = false
    end
  elseif OnToggleSelectype == SkillUseInWorldType.TitleSkill then
    isOpen = DataCenter.PlayerInfoDataManager:HasTitleSkill(true) and not isDragonWorld
  end
  return isOpen
end

LWUISkillUseInWorldView.OnCreate = OnCreate
LWUISkillUseInWorldView.OnDestroy = OnDestroy
LWUISkillUseInWorldView.ComponentDefine = ComponentDefine
LWUISkillUseInWorldView.ComponentDestroy = ComponentDestroy
LWUISkillUseInWorldView.DataDefine = DataDefine
LWUISkillUseInWorldView.DataDestroy = DataDestroy
LWUISkillUseInWorldView.OnAddListener = OnAddListener
LWUISkillUseInWorldView.OnRemoveListener = OnRemoveListener
LWUISkillUseInWorldView.ReInit = ReInit
LWUISkillUseInWorldView.InitView = InitView
LWUISkillUseInWorldView.InitData = InitData
LWUISkillUseInWorldView.Refresh = Refresh
LWUISkillUseInWorldView.OnToggleSelect = OnToggleSelect
LWUISkillUseInWorldView.IsToggleOpen = IsToggleOpen
return LWUISkillUseInWorldView
