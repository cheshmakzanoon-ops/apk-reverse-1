local LWUIMasterySkillCell = BaseClass("LWUIMasterySkillCell", UIBaseContainer)
local base = UIBaseContainer
local tishi_path = "tishi"

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

local function ComponentDefine(self)
  self.showType1 = self:AddComponent(UIImage, "showType1")
  self.showType2 = self:AddComponent(UIImage, "showType2")
  self.skillIcon1 = self:AddComponent(UIImage, "showType1/mask/skillIcon1")
  self.skillIcon2 = self:AddComponent(UIImage, "showType2/mask/skillIcon2")
  self.tishi = self:AddComponent(UIImage, tishi_path)
  self.lock = self:AddComponent(UIImage, "lock")
end

local function ComponentDestroy(self)
  self.showType1 = nil
  self.showType2 = nil
  self.skillIcon1 = nil
  self.skillIcon2 = nil
  self.tishi = nil
  self.lock = nil
end

local function DataDefine(self)
  self.masteryTemp = nil
  self.isShowRecTip = false
end

local function DataDestroy(self)
  self.masteryTemp = nil
  self.isShowRecTip = nil
end

local function SetData(self, masteryId, skillId, isShowRecTip)
  if masteryId then
    self.masteryTemp = DataCenter.MasteryManager:GetTempLevelOneByMasteryGroupId(masteryId)
  elseif skillId then
    local skillTemp = DataCenter.MasteryManager:GetSkillTemplate(skillId)
    if skillTemp then
      self.masteryTemp = DataCenter.MasteryManager:GetTempById(skillTemp.need_id)
    end
  end
  self.isShowRecTip = isShowRecTip
  self:Refresh()
end

local function Refresh(self)
  local masteryTemp = self.masteryTemp
  if masteryTemp == nil then
    return
  end
  self.tishi:SetActive(self.isShowRecTip and masteryTemp.logo > 0)
  local iconPath = masteryTemp:GetIconFullPath()
  local skillTemp = DataCenter.MasteryManager:GetSkillTemplate(masteryTemp.skill)
  if masteryTemp.skill == 0 or skillTemp.active_skills == false then
    self.showType1:SetActive(true)
    self.showType2:SetActive(false)
    self.skillIcon1:LoadSprite(iconPath)
    local bgName = "Mjc_zhiyezhuanjing_icon_bg01"
    if masteryTemp.color == 2 then
      bgName = "zyf_zhiyezhuanjing_icon_bg_green"
    end
    local bgPath = string.format(LoadPath.LWMasterySpritePath, bgName)
    self.showType1:LoadSprite(bgPath)
  else
    self.showType1:SetActive(false)
    self.showType2:SetActive(true)
    self.skillIcon2:LoadSprite(iconPath)
    local bgName = "Mjc_zhiyezhuanjing_icon_bg02"
    if masteryTemp.color == 2 then
      bgName = "zyf_zhiyezhuanjing_icon_bg_green2"
    end
    local bgPath = string.format(LoadPath.LWMasterySpritePath, bgName)
    self.showType2:LoadSprite(bgPath)
  end
  local canUpTip = DataCenter.MasteryManager:IsSkillCanUpByMasteryId(self.masteryTemp.mastery_id)
  self.lock:SetActive(canUpTip == MasterySkillCannotUpResaon.ExtraLock)
end

LWUIMasterySkillCell.OnCreate = OnCreate
LWUIMasterySkillCell.OnDestroy = OnDestroy
LWUIMasterySkillCell.ComponentDefine = ComponentDefine
LWUIMasterySkillCell.ComponentDestroy = ComponentDestroy
LWUIMasterySkillCell.DataDefine = DataDefine
LWUIMasterySkillCell.DataDestroy = DataDestroy
LWUIMasterySkillCell.SetData = SetData
LWUIMasterySkillCell.Refresh = Refresh
return LWUIMasterySkillCell
