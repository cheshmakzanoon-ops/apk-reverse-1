local LWUITCCardSkillUseInWorldCell = BaseClass("LWUITCCardSkillUseInWorldCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UILWScienceDetailDesc = require("UI/UILWScience/UILWScienceDetail/Component/UILWScienceDetailDesc")
local name_path = "Name"
local desc_path = "desc"
local tipTxt_path = "tipTxt"
local useContent_path = "useContent"
local useBtn_path = "useContent/useBtn"
local btnTxt_path = "useContent/useBtn/btnTxt"
local slider_path = "Slider"
local progress_path = "Slider/SliderText"
local skill_icon2_path = "LWUITCCardSkillCell/showType/mask/skillIcon2"

function LWUITCCardSkillUseInWorldCell:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function LWUITCCardSkillUseInWorldCell:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWUITCCardSkillUseInWorldCell:ComponentDefine()
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
  self.skillIcon = self:AddComponent(UIImage, skill_icon2_path)
end

function LWUITCCardSkillUseInWorldCell:ComponentDestroy()
end

function LWUITCCardSkillUseInWorldCell:DataDefine()
  self.showData = nil
  self.curState = nil
  self.cdEndTime = 0
  self.effectEndTime = 0
end

function LWUITCCardSkillUseInWorldCell:DataDestroy()
  self.showData = nil
  self.curState = nil
  self.cdEndTime = nil
  self.effectEndTime = nil
end

function LWUITCCardSkillUseInWorldCell:SetData(showData, usePos, serverId)
  self.showData = showData
  self.usePos = usePos
  self.serverId = serverId
  self:Refresh()
end

function LWUITCCardSkillUseInWorldCell:Refresh()
  if self.showData == nil then
    return
  end
  self.skillData = self.showData.skillData
  self.curState = self.showData.tempState
  local skillTemp = self.showData.skillTemp
  self.name:SetLocalText(skillTemp.name)
  self.desc:SetText(skillTemp:GetDesc())
  if self.showData.tempState == TCCardSkillState.CD then
    self.cdEndTime = self.skillData:GetSkillCdOverTime()
  elseif self.showData.tempState == TCCardSkillState.Effect then
    self.effectEndTime = self.skillData:GetSkillCdOverTime()
  end
  self.skillIcon:LoadSprite("Assets/Main/Sprites/TacticalCardSkill/" .. skillTemp.icon)
  self:Update1000MS()
  self:RefreshLearnStateView()
end

function LWUITCCardSkillUseInWorldCell:RefreshLearnStateView()
  self.numCount:SetActive(false)
  if self.curState == TCCardSkillState.Normal then
    self.use_btn:SetActive(true)
    self.timeTxt:SetActive(false)
    self.slider:SetActive(false)
    self.tipTxt:SetActive(true)
    self.tipTxt:SetLocalText("458527")
    self.tipTxt:SetColor(GreenColor)
    UIGray.SetGray(self.use_btn.transform, false, true)
  elseif self.curState == TCCardSkillState.NoUse then
    self.use_btn:SetActive(true)
    self.timeTxt:SetActive(false)
    self.slider:SetActive(false)
    self.tipTxt:SetActive(true)
    self.tipTxt:SetColor(RedColor)
    self.tipTxt:SetLocalText("season_mastery_167")
    UIGray.SetGray(self.use_btn.transform, true, false)
  elseif self.curState == TCCardSkillState.CD then
    self.use_btn:SetActive(false)
    self.timeTxt:SetActive(true)
    self.slider:SetActive(false)
    self.tipTxt:SetActive(true)
    self.tipTxt:SetColor(RedColor)
    self.tipTxt:SetLocalText("100381")
  elseif self.curState == TCCardSkillState.Effect then
    self.use_btn:SetActive(false)
    self.timeTxt:SetActive(true)
    self.timeTxt:SetLocalText("320534")
    self.slider:SetActive(true)
    self.tipTxt:SetActive(false)
  elseif self.curState == TCCardSkillState.Locked then
    self.use_btn:SetActive(false)
    self.timeTxt:SetActive(false)
    self.slider:SetActive(false)
    self.tipTxt:SetLocalText("season_mastery_166")
    self.tipTxt:SetActive(true)
    self.tipTxt:SetColor(GrayColor)
  elseif self.curState == TCCardSkillState.NotUseInBattleField then
    self.use_btn:SetActive(true)
    self.timeTxt:SetActive(false)
    self.slider:SetActive(false)
    self.tipTxt:SetActive(true)
    self.tipTxt:SetColor(RedColor)
    self.tipTxt:SetLocalText("battle_card_cant_field")
    UIGray.SetGray(self.use_btn.transform, true, false)
  elseif self.curState == TCCardSkillState.NotUseInCurPos then
    self.use_btn:SetActive(true)
    self.timeTxt:SetActive(false)
    self.slider:SetActive(false)
    self.tipTxt:SetActive(true)
    self.tipTxt:SetColor(RedColor)
    self.tipTxt:SetLocalText("season_mastery_167")
    UIGray.SetGray(self.use_btn.transform, true, false)
  else
    self.use_btn:SetActive(true)
    self.timeTxt:SetActive(false)
    self.slider:SetActive(false)
    self.tipTxt:SetActive(true)
    self.tipTxt:SetColor(RedColor)
    self.tipTxt:SetLocalText("season_mastery_167")
    UIGray.SetGray(self.use_btn.transform, true, false)
  end
  if self.skillData and self.skillData:GetChargeData() then
    local cur, max = self.skillData:GetChargeData():GetCurAndMaxCount()
    if 1 < max then
      self.numCount:SetActive(true)
      self.numCount:SetText(string.format("%s/%s", cur, max))
    end
  end
end

function LWUITCCardSkillUseInWorldCell:Update1000MS()
  if self.showData == nil then
    return
  end
  if self.curState == TCCardSkillState.CD or self.curState == TCCardSkillState.Effect then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local newState = self.curState
    if curTime < self.effectEndTime then
      newState = TCCardSkillState.Effect
      local leftTime = self.effectEndTime - curTime
      if leftTime < 0 then
        leftTime = 0
      end
      local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
      self.progress_txt:SetText(countDownTimeStr)
      local effectDuration = math.max(self.showData.skillTemp.duration * 60000, 1)
      self.slider:SetValue(leftTime / effectDuration)
    elseif curTime < self.cdEndTime and curTime > self.effectEndTime then
      newState = TCCardSkillState.CD
      local leftTime = self.cdEndTime - curTime
      if leftTime < 0 then
        leftTime = 0
      end
      local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
      self.timeTxt:SetText(countDownTimeStr)
    else
      newState = TCCardSkillState.Normal
    end
    if newState ~= self.curState then
      self.curState = newState
      self:RefreshLearnStateView()
    end
  end
end

function LWUITCCardSkillUseInWorldCell:OnBtnClickFunc()
  if not self.showData or not self.skillData then
    return
  end
  if self.curState ~= TCCardSkillState.Normal then
    return
  end
  local cardUuid = self.skillData.cardUuid
  local skillGroupId = self.skillData:GetSkillGroupId()
  if not skillGroupId then
    Logger.LogError("not find skill groupId. skillId" .. self.skillData.skillId)
    return
  end
  local skillTmp = self.skillData.template
  if not skillTmp then
    Logger.LogError("not find skill template. skillId" .. self.skillData.skillId)
    return
  end
  local params
  if skillTmp.effect == TCCardSkillEffectType.GetRemainResourceImmediate then
    local marchTargetType, allianceBuildUuid = TacticalCardUtil.GetCardCollectSkillParams(self.showData.pointId)
    params = {
      resourcePointId = self.showData.pointId,
      marchTargetType = marchTargetType,
      uuid = allianceBuildUuid
    }
  end
  SFSNetwork.SendMessage(MsgDefines.BattleCardUseSkill, cardUuid, skillGroupId, params)
  self.view.ctrl:CloseSelf()
end

return LWUITCCardSkillUseInWorldCell
