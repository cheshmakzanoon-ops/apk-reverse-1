local ShowTypeContentSkinSkillBtn = BaseClass("ShowTypeContentSkinSkillBtn", UIBaseContainer)
local base = UIBaseContainer
local use_skill_content_path = ""
local skill_icon_path = "SkillCell/showType/mask/skillIcon"

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

local function ComponentDefine(self)
  self.use_skill_content = self:AddComponent(UIButton, use_skill_content_path)
  self.skill_icon = self:AddComponent(UIImage, skill_icon_path)
  self.use_skill_content:SetOnClick(function()
    self:OnUseSkillContentClick()
  end)
end

local function ComponentDestroy(self)
  self.use_skill_content = nil
  self.skill_icon = nil
end

local function DataDefine(self)
  self.playSkillFunc = nil
  self.skillId = nil
  self.skillTemp = nil
end

local function DataDestroy(self)
  self.playSkillFunc = nil
  self.skillId = nil
  self.skillTemp = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self, playSkillFunc)
  self.playSkillFunc = playSkillFunc
end

local function SetData(self, skillId)
  self.skillId = skillId
  self.skillTemp = DataCenter.DecorationSkillTemplateManager:GetTemplate(self.skillId)
  if self.skillTemp == nil then
    return
  end
  self:RefreshView()
end

local function RefreshView(self)
  self.skill_icon:LoadSprite(string.format(LoadPath.UICitySkinSkill, self.skillTemp.icon))
end

local function OnUseSkillContentClick(self)
  if self.playSkillFunc then
    self.playSkillFunc(self.skillId)
  end
end

ShowTypeContentSkinSkillBtn.OnCreate = OnCreate
ShowTypeContentSkinSkillBtn.OnDestroy = OnDestroy
ShowTypeContentSkinSkillBtn.OnEnable = OnEnable
ShowTypeContentSkinSkillBtn.OnDisable = OnDisable
ShowTypeContentSkinSkillBtn.ComponentDefine = ComponentDefine
ShowTypeContentSkinSkillBtn.ComponentDestroy = ComponentDestroy
ShowTypeContentSkinSkillBtn.DataDefine = DataDefine
ShowTypeContentSkinSkillBtn.DataDestroy = DataDestroy
ShowTypeContentSkinSkillBtn.ReInit = ReInit
ShowTypeContentSkinSkillBtn.SetData = SetData
ShowTypeContentSkinSkillBtn.RefreshView = RefreshView
ShowTypeContentSkinSkillBtn.OnWorldTypeBtnClick = OnWorldTypeBtnClick
ShowTypeContentSkinSkillBtn.OnCityTypeBtnClick = OnCityTypeBtnClick
ShowTypeContentSkinSkillBtn.OnUseSkillContentClick = OnUseSkillContentClick
return ShowTypeContentSkinSkillBtn
