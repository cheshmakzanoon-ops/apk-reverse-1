local LWUIMasterySkillPanelItem = BaseClass("LWUIMasterySkillPanelItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local LIMIT_LEVEL = 30
local LWUIMasterySkillCell = require("UI.LWUIMastery.Component.LWUIMasterySkillCell")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.masterySkillCell = self:AddComponent(LWUIMasterySkillCell, "LWUIMasterySkillCell")
  self.levelNum = self:AddComponent(UIText, "levelNum")
  self.canUp1 = self:AddComponent(UIBaseContainer, "canUp1")
  self.canUp2 = self:AddComponent(UIBaseContainer, "canUp2")
  self.thumb = self:AddComponent(UIBaseComponent, "thumb")
  self.thumb:SetActive(false)
  self.specialSkillBtn = self:AddComponent(UIButton, "specialSkillBtn")
  self.specialSkillBtn:SetOnClick(function()
    self:OnSpecialSkillBtnClick()
  end)
  self.lingxingEffect = self:AddComponent(UIBaseContainer, "Eff_ui_saiji_jinengdian_lingxing_faguang")
  self.lingxingEffect:SetActive(false)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.masterySkillCell = nil
  self.levelNum = nil
  self.canUp1 = nil
  self.canUp2 = nil
  self.thumb = nil
  self.specialSkillBtn = nil
  self.lingxingEffect = nil
end

local function SetData(self, masteryId, skillData)
  self.masteryId = masteryId
  self.skillData = skillData
  self.isEffecting = false
  self.effectEndTime = 0
  self:Refresh()
end

local function SetGrayMasterySkillCell(self, gray, text)
  if gray then
    CS.UIGray.SetGray(self.masterySkillCell.transform, true, true)
    self.levelNum:SetColorRGBA(0.8, 0.8, 0.8, 1)
  else
    CS.UIGray.SetGray(self.masterySkillCell.transform, false, true)
    self.levelNum:SetColorRGBA(0.39, 0.86, 0.39, 1)
  end
  self.levelNum:SetText(text)
end

local function Refresh(self)
  local isSelfSkill = self.skillData.homeId == self.skillData.selfHomeId
  self.canUp1:SetActive(false)
  self.canUp2:SetActive(false)
  self.lingxingEffect:SetActive(false)
  local skillTemp = DataCenter.MasteryManager:GetSkillTemplate(self.skillData.lvOneTemp.skill)
  self.specialSkillBtn:SetActive(skillTemp ~= nil and #skillTemp.guide_img_list > 0)
  local canUp = false
  if not isSelfSkill then
    self:SetGrayMasterySkillCell(true, string.format("%d/%d", 0, self.skillData.maxLv))
  elseif self.skillData.lvOneTemp.season_only == 1 and not SeasonUtil.IsUserInSeason() then
    self:SetGrayMasterySkillCell(true, string.format("%d/%d", 0, self.skillData.maxLv))
  else
    local canUpTip = DataCenter.MasteryManager:IsSkillCanUpByMasteryId(self.masteryId)
    local isUnlock = true
    local isResult = false
    local curHomeLv = self.skillData.masteryData.level
    if canUpTip == MasterySkillCannotUpResaon.DesignerLock then
      isResult = true
      isUnlock = false
    end
    if not isResult and curHomeLv < self.skillData.needLv then
      isResult = true
      isUnlock = false
    end
    if not isResult and self.skillData.needMasteryTemp then
      local perId = self.skillData.needMasteryTemp.mastery_id
      local perLv = self.skillData.needMasteryTemp.lv
      local curLv = self.skillData.masteryData:GetCurLvByMasteryId(perId)
      if not isResult and perLv > curLv then
        isResult = true
        isUnlock = false
      end
    end
    local curLv = self.skillData.masteryData:GetCurLvByMasteryId(self.masteryId)
    self.levelNum:SetText()
    if not isUnlock then
      self:SetGrayMasterySkillCell(true, string.format("%d/%d", curLv, self.skillData.maxLv))
    else
      self:SetGrayMasterySkillCell(false, string.format("%d/%d", curLv, self.skillData.maxLv))
      if canUpTip == MasterySkillCannotUpResaon.None then
        if self.skillData.lvOneTemp.skill == 0 or skillTemp.active_skills == false then
          self.canUp1:SetActive(true)
        else
          self.canUp2:SetActive(true)
        end
        canUp = true
      end
      if self.skillData.lvOneTemp.skill > 0 then
        local skillState, param = DataCenter.MasteryManager:GetMasteryGroupSkillState(self.masteryId)
        if skillState == MasterySkillState.Effect then
          self.isEffecting = true
          self.effectEndTime = param
          self.lingxingEffect:SetActive(true)
        end
      end
    end
  end
  local masterySkillTemp = DataCenter.MasteryManager:GetTempLevelOneByMasteryGroupId(self.masteryId)
  local oldRecommend = canUp and isSelfSkill and masterySkillTemp and 0 < masterySkillTemp.logo
  local newRecommend = self.masteryId == DataCenter.MasteryManager:GetRecommendGroupId()
  self.thumb:SetActive(oldRecommend or newRecommend)
  self.masterySkillCell:SetData(self.masteryId, nil, canUp and isSelfSkill)
end

local function OnBtnClick(self)
  if self.skillData == nil then
    return
  end
  local param = {}
  param.masteryId = self.masteryId
  param.isShowMaxLvl = false
  param.showSkillInfo = false
  param.showShareBtn = true
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMasteryGetSkill, {anim = true}, param)
end

local function OnSpecialSkillBtnClick(self)
  if self.skillData == nil then
    return
  end
  local temp = DataCenter.MasteryManager:GetTempLevelOneByMasteryGroupId(self.masteryId)
  if temp == nil then
    return
  end
  if temp.skill <= 0 then
    return
  end
  local skillTemp = DataCenter.MasteryManager:GetSkillTemplate(temp.skill)
  if skillTemp == nil then
    return
  end
  local series = {}
  for k, v in ipairs(skillTemp.guide_img_list) do
    local descTxt = ""
    if k <= #skillTemp.guide_description_list then
      descTxt = skillTemp.guide_description_list[k]
    end
    local data = {
      banner = string.format(LoadPath.LWMasteryTexturePath, v),
      long_key = descTxt
    }
    table.insert(series, data)
  end
  local fakeConfig = {
    [1] = {series = series}
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWWorldTip, {anim = false}, fakeConfig)
end

local function Update1000MS(self)
  if self.isEffecting == true then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime > self.effectEndTime then
      self.isEffecting = false
      self.lingxingEffect:SetActive(false)
    end
  end
end

LWUIMasterySkillPanelItem.OnCreate = OnCreate
LWUIMasterySkillPanelItem.OnDestroy = OnDestroy
LWUIMasterySkillPanelItem.ComponentDefine = ComponentDefine
LWUIMasterySkillPanelItem.ComponentDestroy = ComponentDestroy
LWUIMasterySkillPanelItem.SetGrayMasterySkillCell = SetGrayMasterySkillCell
LWUIMasterySkillPanelItem.SetData = SetData
LWUIMasterySkillPanelItem.Refresh = Refresh
LWUIMasterySkillPanelItem.OnBtnClick = OnBtnClick
LWUIMasterySkillPanelItem.OnSpecialSkillBtnClick = OnSpecialSkillBtnClick
LWUIMasterySkillPanelItem.Update1000MS = Update1000MS
return LWUIMasterySkillPanelItem
