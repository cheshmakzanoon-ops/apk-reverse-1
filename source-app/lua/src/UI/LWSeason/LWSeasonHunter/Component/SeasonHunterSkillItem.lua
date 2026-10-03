local base = UIBaseContainer
local SeasonHunterSkillItem = BaseClass("SeasonHunterSkillItem", base)
local btnTips_path = "btnTips"
local btnGoto_path = "TxtGoto"
local finish_path = "finish"
local icon_path = "icon"
local txtName_path = "TxtName"

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
  self.btnTips = self:AddComponent(UIButton, btnTips_path)
  self.btnGoto = self:AddComponent(UIButton, btnGoto_path)
  self.finish = self:AddComponent(UIBaseContainer, finish_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.txtName = self:AddComponent(UIText, txtName_path)
  self.btnTips:SetOnClick(function()
    local content = CS.GameEntry.Localization:GetString(self.tips)
    local title = CS.GameEntry.Localization:GetString(self.tipsTitle)
    UIUtil.ShowBubbleTips(content, self.btnTips.transform.position, 37, -65, 20, nil, title)
  end)
  self.btnGoto:SetOnClick(function()
    if self.masteryTemp then
      local params = {}
      params.tabType = MasteryTabType.MasterSkillTab
      params.data = {
        homeId = self.homeId,
        jumpMasteryId = self.masteryTemp.mastery_id
      }
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMasteryCenterTab, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, params)
    end
  end)
end

local function ComponentDestroy(self)
  self.btnTips = nil
  self.btnGoto = nil
  self.finish = nil
  self.icon = nil
  self.txtName = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SeasonHunterSkillItem:ReInit(index, tips, tipsTitle)
  self.tips = tips
  self.tipsTitle = tipsTitle
  local homeId, skillState, _, masteryTemp, skillTemplate = DataCenter.SeasonHunterManager:GetMasterySkillState(index)
  self.homeId = homeId
  self.masteryTemp = masteryTemp
  if not masteryTemp then
    self:SetActive(false)
    return
  end
  self.icon:LoadSprite(masteryTemp:GetIconFullPath())
  self.txtName:SetLocalText(masteryTemp.name)
  local hasLearn = skillState ~= MasterySkillState.None and skillState ~= MasterySkillState.Locked
  self.finish:SetActive(hasLearn)
  self.btnGoto:SetActive(not hasLearn)
  self.btnTips:SetActive(not hasLearn)
  self:SetActive(true)
end

SeasonHunterSkillItem.OnCreate = OnCreate
SeasonHunterSkillItem.OnDestroy = OnDestroy
SeasonHunterSkillItem.OnEnable = OnEnable
SeasonHunterSkillItem.OnDisable = OnDisable
SeasonHunterSkillItem.ComponentDefine = ComponentDefine
SeasonHunterSkillItem.ComponentDestroy = ComponentDestroy
SeasonHunterSkillItem.DataDefine = DataDefine
SeasonHunterSkillItem.DataDestroy = DataDestroy
return SeasonHunterSkillItem
