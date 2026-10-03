local base = UIBaseContainer
local UITitleSkillItem = BaseClass("UITitleSkillItem", base)
local UIGray = CS.UIGray
local name_path = "top/title"
local tipTxt_path = "top/tipTxt"
local icon_path = "icon"
local desc_path = "desc"
local use_btn_path = "useContent/useBtn"
local btnTxt_path = "useContent/useBtn/btnTxt"
local timeTxt_path = "timeTxt"
local numCount_path = "numCount"
local slider_path = "top/Slider"

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
  self.name = self:AddComponent(UIText, name_path)
  self.tipTxt = self:AddComponent(UIText, tipTxt_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.desc = self:AddComponent(UIText, desc_path)
  self.use_btn = self:AddComponent(UIButton, use_btn_path)
  self.btnTxt = self:AddComponent(UIText, btnTxt_path)
  self.timeTxt = self:AddComponent(UIText, timeTxt_path)
  self.numCount = self:AddComponent(UIText, numCount_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.btnTxt:SetLocalText("110046")
  self.use_btn:SetOnClick(function()
    self:OnBtnClickFunc()
  end)
  self.numCount:SetActive(false)
end

local function ComponentDestroy(self)
  self.name = nil
  self.tipTxt = nil
  self.icon = nil
  self.desc = nil
  self.use_btn = nil
  self.btnTxt = nil
  self.timeTxt = nil
  self.numCount = nil
  self.slider = nil
end

local function DataDefine(self)
  self.showData = nil
  self.curState = nil
  self.cdEndTime = 0
  self.effectEndTime = 0
end

local function DataDestroy(self)
  self.showData = nil
  self.curState = nil
  self.cdEndTime = nil
  self.effectEndTime = nil
end

function UITitleSkillItem:ReInit(showData)
  self.showData = showData
  self.usePos = MasterySkillUsePosType.SkillView
  self.curState = self.showData.tempState
  local titleTemp = self.showData.titleTemp
  local skillTemp = self.showData.skillTemp
  self.icon:LoadSpriteAsyncEx(titleTemp.title_show_icon)
  self.name:SetLocalText(skillTemp.name)
  self.desc:SetText(skillTemp:GetDescStr())
  if self.showData.tempState == MasterySkillState.CD then
    self.cdEndTime = self.showData.endTime
  elseif self.showData.tempState == MasterySkillState.Effect then
    self.effectEndTime = self.showData.endTime
  end
  self:Update1000MS()
  self:RefreshLearnStateView()
end

function UITitleSkillItem:RefreshLearnStateView()
  self.numCount:SetActive(false)
  UIGray.SetGray(self.icon.transform, false, true)
  if self.curState == MasterySkillState.Normal then
    self.use_btn:SetActive(true)
    self.timeTxt:SetActive(false)
    self.slider:SetActive(false)
    self.tipTxt:SetActive(true)
    self.tipTxt:SetLocalText("458527")
    self.tipTxt:SetColor(GreenColor)
    UIGray.SetGray(self.use_btn.transform, false, true)
  elseif self.curState == MasterySkillState.NoUse then
    self.use_btn:SetActive(true)
    self.timeTxt:SetActive(false)
    self.slider:SetActive(false)
    self.tipTxt:SetActive(true)
    self.tipTxt:SetColor(RedColor)
    self.tipTxt:SetLocalText("season_mastery_167")
    UIGray.SetGray(self.use_btn.transform, true, false)
  elseif self.curState == MasterySkillState.CD then
    self.use_btn:SetActive(false)
    self.timeTxt:SetActive(true)
    self.slider:SetActive(false)
    self.tipTxt:SetActive(true)
    self.tipTxt:SetColor(RedColor)
    self.tipTxt:SetLocalText("100381")
  elseif self.curState == MasterySkillState.Effect then
    self.use_btn:SetActive(false)
    self.timeTxt:SetActive(true)
    self.timeTxt:SetLocalText("320534")
    self.slider:SetActive(true)
    self.tipTxt:SetActive(false)
  elseif self.curState == MasterySkillState.Locked then
    self.use_btn:SetActive(false)
    self.timeTxt:SetActive(false)
    self.slider:SetActive(false)
    self.tipTxt:SetLocalText("season_mastery_166")
    self.tipTxt:SetActive(true)
    self.tipTxt:SetColor(GrayColor)
    UIGray.SetGray(self.icon.transform, true, true)
  end
  if self.showData and self.showData.skillTemp then
    local cur, max = DataCenter.MasteryManager:GetStorageSkillCount(self.showData.skillTemp.id)
    if 1 < max then
      self.numCount:SetActive(true)
      self.numCount:SetText(string.format("%s/%s", cur, max))
    end
  end
end

function UITitleSkillItem:Update1000MS()
  if self.showData == nil then
    return
  end
  if self.curState == MasterySkillState.CD or self.curState == MasterySkillState.Effect then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local newState = self.curState
    if curTime < self.effectEndTime then
      newState = MasterySkillState.Effect
      local leftTime = self.effectEndTime - curTime
      if leftTime < 0 then
        leftTime = 0
      end
      local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
      self.progress_txt:SetText(countDownTimeStr)
      local effectDuration = math.max(self.showData.skillTemp.duration * 60000, 1)
      self.slider:SetValue(leftTime / effectDuration)
    elseif curTime < self.cdEndTime and curTime > self.effectEndTime then
      newState = MasterySkillState.CD
      local leftTime = self.cdEndTime - curTime
      if leftTime < 0 then
        leftTime = 0
      end
      local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
      self.timeTxt:SetText(countDownTimeStr)
    else
      newState = MasterySkillState.Normal
    end
    if newState ~= self.curState then
      self.curState = newState
      self:RefreshLearnStateView()
    end
  end
end

function UITitleSkillItem:OnBtnClickFunc()
  if self.showData == nil or self.curState ~= MasterySkillState.Normal then
    return
  end
  DataCenter.MasteryManager:UseSkill(self.showData.skillTemp.id, self.showData.pointId, MsgDefines.UseLwSkill)
end

UITitleSkillItem.OnCreate = OnCreate
UITitleSkillItem.OnDestroy = OnDestroy
UITitleSkillItem.OnEnable = OnEnable
UITitleSkillItem.OnDisable = OnDisable
UITitleSkillItem.ComponentDefine = ComponentDefine
UITitleSkillItem.ComponentDestroy = ComponentDestroy
UITitleSkillItem.DataDefine = DataDefine
UITitleSkillItem.DataDestroy = DataDestroy
return UITitleSkillItem
