local base = UIBaseContainer
local UIGhostreconTaskSpecialPanel = BaseClass("UIGhostreconTaskSpecialPanel", base)
local UIGhostreconRewardBoxBtn = require("UI.UIDispatchTask.Ghostrecon.Component.UIGhostreconRewardBoxBtn")
local UIGhostreconTeamCell = require("UI.UIDispatchTask.Ghostrecon.Component.UIGhostreconTeamCell")
local emojiImg_path = "TitleImg/EmojiImg"
local titleText_path = "TitleImg/TitleText"
local unComplyBg_path = "BoxPanel/UnComplyBg"
local complyBg_path = "BoxPanel/ComplyBg"
local boxPanel_path = "BoxPanel/BoxBtn"
local teamCell1_path = "TeamPanel/TeamCell1"
local teamCell2_path = "TeamPanel/TeamCell2"
local titleImg_path = "TitleImg"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.emojiImg = self:AddComponent(UIImage, emojiImg_path)
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.unComplyBg = self:AddComponent(UIImage, unComplyBg_path)
  self.complyBg = self:AddComponent(UIImage, complyBg_path)
  self.boxPanel = self:AddComponent(UIGhostreconRewardBoxBtn, boxPanel_path)
  self.teamCell1 = self:AddComponent(UIGhostreconTeamCell, teamCell1_path)
  self.teamCell2 = self:AddComponent(UIGhostreconTeamCell, teamCell2_path)
  self.titleImg = self:AddComponent(UIImage, titleImg_path)
end

local function ComponentDestroy(self)
  self.emojiImg = nil
  self.titleText = nil
  self.unComplyBg = nil
  self.complyBg = nil
  self.boxPanel = nil
  self.teamCell1 = nil
  self.teamCell2 = nil
  self.titleImg = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, cfg, meetNums)
  local superConditions = cfg.superCondions
  local isMeet = true
  for i = 1, 2 do
    local cell = self["teamCell" .. i]
    if superConditions[i] then
      cell:SetActive(true)
      if meetNums and meetNums[i] then
        cell:SetData(superConditions[i], meetNums[i])
      else
        cell:SetData(superConditions[i])
        cell:SetPreviewText("x" .. superConditions[i].num)
      end
      if not cell:IsMeet() then
        isMeet = false
      end
    else
      cell:SetActive(false)
    end
  end
  if meetNums then
    self.emojiImg:SetActive(true)
    if isMeet then
      self.emojiImg:LoadSprite("Assets/Main/Sprites/UI/LWChatEmoji/Default/14.png")
      CS.UIGray.SetGray(self.boxPanel.transform, false, true)
      self.complyBg:SetActive(true)
      self.titleText:SetLocalText("ghostrecon_031")
      self.titleImg:LoadSprite("Assets/Main/Sprites/UI/UIGhostrecon/ljq_youling_diban_02.png")
    else
      self.emojiImg:LoadSprite("Assets/Main/Sprites/UI/LWChatEmoji/Default/10.png")
      CS.UIGray.SetGray(self.boxPanel.transform, true, true)
      self.complyBg:SetActive(false)
      self.titleText:SetLocalText("ghostrecon_032")
      self.titleImg:LoadSprite("Assets/Main/Sprites/UI/UIGhostrecon/ljq_youling_diban_01.png")
    end
  else
    self.emojiImg:SetActive(false)
    CS.UIGray.SetGray(self.boxPanel.transform, false, true)
    self.unComplyBg:SetActive(false)
    self.complyBg:SetActive(true)
    self.titleText:SetLocalText("ghostrecon_017")
  end
  self.boxPanel:SetData(cfg)
end

UIGhostreconTaskSpecialPanel.OnCreate = OnCreate
UIGhostreconTaskSpecialPanel.OnDestroy = OnDestroy
UIGhostreconTaskSpecialPanel.OnEnable = OnEnable
UIGhostreconTaskSpecialPanel.OnDisable = OnDisable
UIGhostreconTaskSpecialPanel.ComponentDefine = ComponentDefine
UIGhostreconTaskSpecialPanel.ComponentDestroy = ComponentDestroy
UIGhostreconTaskSpecialPanel.DataDefine = DataDefine
UIGhostreconTaskSpecialPanel.DataDestroy = DataDestroy
UIGhostreconTaskSpecialPanel.SetData = SetData
return UIGhostreconTaskSpecialPanel
