local LWUITitleSkillUseInWorldCell = BaseClass("LWUITitleSkillUseInWorldCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UILWScienceDetailDesc = require("UI/UILWScience/UILWScienceDetail/Component/UILWScienceDetailDesc")
local LWUIMasterySkillCell = require("UI.LWUIMastery.Component.LWUIMasterySkillCell")
local name_path = "Name"
local desc_path = "desc"
local tipTxt_path = "tipTxt"
local useContent_path = "useContent"
local useBtn_path = "useContent/useBtn"
local btnTxt_path = "useContent/useBtn/btnTxt"
local skill_icon2_path = "SkillCell/showType/mask/skillIcon2"
local slider_path = "Slider"
local progress_path = "Slider/SliderText"

function LWUITitleSkillUseInWorldCell:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function LWUITitleSkillUseInWorldCell:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWUITitleSkillUseInWorldCell:ComponentDefine()
  self.skill_icon2 = self:AddComponent(UIImage, skill_icon2_path)
  self.name = self:AddComponent(UIText, name_path)
  self.desc = self:AddComponent(UILWScienceDetailDesc, desc_path)
  self.tipTxt = self:AddComponent(UIText, tipTxt_path)
  self.useContent = self:AddComponent(UIBaseContainer, useContent_path)
  self.use_btn = self:AddComponent(UIButton, useBtn_path)
  self.btnTxt = self:AddComponent(UIText, btnTxt_path)
  self.btnTxt:SetLocalText("110046")
  self.timeTxt = self:AddComponent(UIText, "timeTxt")
  self.slider = self:AddComponent(UISlider, slider_path)
  self.progress_txt = self:AddComponent(UIText, progress_path)
  self.use_btn:SetOnClick(function()
    self:OnBtnClickFunc()
  end)
  self.numCount = self:AddComponent(UIText, "numCount")
  self.numCount:SetActive(false)
end

function LWUITitleSkillUseInWorldCell:ComponentDestroy()
end

function LWUITitleSkillUseInWorldCell:DataDefine()
  self.showData = nil
  self.curState = nil
  self.cdEndTime = 0
  self.effectEndTime = 0
end

function LWUITitleSkillUseInWorldCell:DataDestroy()
  self.showData = nil
  self.curState = nil
  self.cdEndTime = nil
  self.effectEndTime = nil
end

function LWUITitleSkillUseInWorldCell:SetData(showData, usePos, serverId)
  self.showData = showData
  self.usePos = usePos
  self.serverId = serverId
  self:Refresh()
end

function LWUITitleSkillUseInWorldCell:Refresh()
  if self.showData == nil then
    return
  end
  self.curState = self.showData.tempState
  local titleTemp = self.showData.titleTemp
  local skillTemp = self.showData.skillTemp
  self.skill_icon2:LoadSpriteAsyncEx(titleTemp.title_show_icon)
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

function LWUITitleSkillUseInWorldCell:RefreshLearnStateView()
  self.numCount:SetActive(false)
  UIGray.SetGray(self.skill_icon2.transform, false, true)
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
    UIGray.SetGray(self.skill_icon2.transform, true, true)
  end
  if self.showData and self.showData.skillTemp then
    local cur, max = DataCenter.MasteryManager:GetStorageSkillCount(self.showData.skillTemp.id)
    if 1 < max then
      self.numCount:SetActive(true)
      self.numCount:SetText(string.format("%s/%s", cur, max))
    end
  end
end

function LWUITitleSkillUseInWorldCell:Update1000MS()
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

function LWUITitleSkillUseInWorldCell:OnBtnClickFunc()
  if self.showData == nil or self.curState ~= MasterySkillState.Normal then
    return
  end
  DataCenter.MasteryManager:UseSkill(self.showData.skillTemp.id, self.showData.pointId, MsgDefines.UseLwSkill, self.serverId)
  self.view.ctrl:CloseSelf()
end

return LWUITitleSkillUseInWorldCell
