local LWUICitySkinSkillUseInWorldCell = BaseClass("LWUICitySkinSkillUseInWorldCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UICitySkinSkillTipsView = require("UI.UICitySkinSkillTips.View.UICitySkinSkillTipsView")
local SeasonCallbackInfo = require("UI.LWSeason.LWSeasonMain.Component.SeasonCallback.SeasonCallbackInfo")
local name_path = "Name"
local desc_path = "descScrollView/Viewport/desc"
local tipTxt_path = "tipTxt"
local useContent_path = "useContent"
local useBtn_path = "useContent/useBtn"
local btnTxt_path = "useContent/useBtn/btnTxt"
local slider_path = "Slider"
local progress_path = "Slider/SliderText"
local skill_icon2_path = "SkillCell/showType/mask/skillIcon2"
local tip_icon_btn_path = "tipIconBtn"
local skill_num_desc_path = "tipIconBtn/skillNumDesc"
local UISeasonCallbackInfoPath = "UISeasonCallbackInfo"
local passive_skill_txt_path = "useContent/PassiveSkillTxt"
local skillState = {
  Lock = 0,
  UnLock = 1,
  CD = 2,
  WaitRecovery = 3
}

function LWUICitySkinSkillUseInWorldCell:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function LWUICitySkinSkillUseInWorldCell:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWUICitySkinSkillUseInWorldCell:ComponentDefine()
  self.skill_icon2 = self:AddComponent(UIImage, skill_icon2_path)
  self.name = self:AddComponent(UIText, name_path)
  self.desc = self:AddComponent(UIText, desc_path)
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
  self.tip_icon_btn = self:AddComponent(UIButton, tip_icon_btn_path)
  self.skill_num_desc = self:AddComponent(UITextMeshProUGUIEx, skill_num_desc_path)
  self.tip_icon_btn:SetOnClick(function()
    self:OnTipBtnClickFunc()
  end)
  self.seasonCallbackInfo = self:AddComponent(SeasonCallbackInfo, UISeasonCallbackInfoPath)
  self.passive_skill_txt = self:AddComponent(UITextMeshProUGUIEx, passive_skill_txt_path)
  self.passive_skill_txt:SetLocalText("decoration_skilltype_use_tips1")
end

function LWUICitySkinSkillUseInWorldCell:ComponentDestroy()
  self.passive_skill_txt = nil
end

function LWUICitySkinSkillUseInWorldCell:DataDefine()
  self.showData = nil
  self.curState = nil
  self.cdEndTime = 0
end

function LWUICitySkinSkillUseInWorldCell:DataDestroy()
  self.showData = nil
  self.curState = nil
  self.cdEndTime = nil
end

function LWUICitySkinSkillUseInWorldCell:SetData(showData, usePos, serverId)
  self.showData = showData
  self.usePos = usePos
  self.serverId = serverId
  self.desc:SetAnchoredPositionXY(0, 0)
  self:Refresh()
end

function LWUICitySkinSkillUseInWorldCell:Refresh()
  if self.showData == nil then
    return
  end
  self:RefreshState()
  local skillTemp = self.showData.skillTemp
  self.name:SetLocalText(skillTemp.name)
  self.desc:SetText(skillTemp:GetDescStr())
  self.skill_icon2:LoadSprite(string.format("Assets/Main/Sprites/UI/UICitySkinSkill/%s.png", skillTemp.icon))
  self:Update1000MS()
  self:RefreshLearnStateView()
end

function LWUICitySkinSkillUseInWorldCell:RefreshLearnStateView()
  UIGray.SetGray(self.skill_icon2.transform, false, true)
  if self.curState == skillState.UnLock then
    local skillTemp = self.showData.skillTemp
    self.use_btn:SetActive(skillTemp.use_type == DecorationSkillUseType.Active)
    self.passive_skill_txt:SetActive(skillTemp.use_type == DecorationSkillUseType.Passive)
    self.timeTxt:SetActive(false)
    self.slider:SetActive(false)
    self.tipTxt:SetActive(true)
    self.tipTxt:SetLocalText("458527")
    self.tipTxt:SetColor(GreenColor)
    UIGray.SetGray(self.use_btn.transform, false, true)
  elseif self.curState == skillState.CD then
    self.use_btn:SetActive(false)
    self.passive_skill_txt:SetActive(false)
    self.timeTxt:SetActive(true)
    self.slider:SetActive(false)
    self.tipTxt:SetActive(true)
    self.tipTxt:SetColor(RedColor)
    self.tipTxt:SetLocalText("100381")
  elseif self.curState == skillState.WaitRecovery then
    self.use_btn:SetActive(false)
    self.passive_skill_txt:SetActive(false)
    self.timeTxt:SetActive(true)
    self.slider:SetActive(false)
    self.tipTxt:SetActive(true)
    self.tipTxt:SetColor(RedColor)
    self.tipTxt:SetText("")
  elseif self.curState == skillState.Lock then
    self.use_btn:SetActive(false)
    self.passive_skill_txt:SetActive(false)
    self.timeTxt:SetActive(false)
    self.slider:SetActive(false)
    local name = Localization:GetString(self.showData.decorationTemp.name)
    local showTxt = Localization:GetString("decoration_skill_desc3", name)
    self.tipTxt:SetText(showTxt)
    self.tipTxt:SetActive(true)
    self.tipTxt:SetColor(GrayColor)
    UIGray.SetGray(self.skill_icon2.transform, true, true)
  end
end

function LWUICitySkinSkillUseInWorldCell:Update1000MS()
  if self.showData == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.curState == skillState.CD or self.curState == skillState.WaitRecovery then
    local leftTime = self.cdEndTime - curTime
    if leftTime < 0 then
      leftTime = 0
    end
    local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
    self.timeTxt:SetText(countDownTimeStr)
    if leftTime <= 0 then
      self:RefreshState()
      self:RefreshLearnStateView()
    end
  end
  local intervalUseTime = DataCenter.CitySkinSkillManager:GetSkillIntervalUseTime(self.showData.skillId)
  local curNum = self.showData.skillTemp:GetCurNum(intervalUseTime)
  local maxNum = self.showData.skillTemp.use_times
  local curStr = curNum
  if 0 < maxNum then
    if curNum <= 0 then
      curStr = string.format("<color=#E64141>%s</color>", curNum)
    end
    self.skill_num_desc:SetLocalText("decoration_skill_times_tips1", curStr, maxNum)
    self.tip_icon_btn:SetActive(true)
  else
    self.skill_num_desc:SetText("")
    self.tip_icon_btn:SetActive(false)
  end
end

function LWUICitySkinSkillUseInWorldCell:OnBtnClickFunc()
  if self.showData == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.curState == skillState.UnLock then
    local skillTemp = DataCenter.DecorationSkillTemplateManager:GetTemplate(self.showData.skillId)
    if skillTemp and skillTemp.type and DataCenter.DecorationDataManager:IsSeasonSkinSkill(skillTemp) and (BattleFieldUtil.InBattleField(BattleFieldType.WinterStorm) or BattleFieldUtil.InBattleField(BattleFieldType.Desert) and not BattleFieldUtil.isObserve) then
      UIUtil.ShowTips(Localization:GetString("season_s1_callback_tips_1"))
      return
    end
    local serverId = LuaEntry.Player:GetCrossServerId()
    local worldId = LuaEntry.Player:GetCurWorldId()
    SFSNetwork.SendMessage(MsgDefines.UseSkinSkill, self.showData.decorationTemp.id, self.showData.skillId, serverId, worldId)
    self.view.ctrl:CloseSelf()
  elseif self.curState == skillState.CD then
    local leftTime = self.cdEndTime - curTime
    if leftTime < 0 then
      leftTime = 0
    end
    local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
    UIUtil.ShowTips(Localization:GetString("decoration_skill_use_alert2", countDownTimeStr))
  elseif self.curState == skillState.WaitRecovery then
    local leftTime = self.cdEndTime - curTime
    if leftTime < 0 then
      leftTime = 0
    end
    local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
    UIUtil.ShowTips(Localization:GetString("decoration_skill_use_alert1", countDownTimeStr))
  end
end

function LWUICitySkinSkillUseInWorldCell:OnTipBtnClickFunc()
  if self.showData == nil then
    return
  end
  local param = UICitySkinSkillTipsView.ParamDataClass.New()
  param.position = self.tip_icon_btn:GetPosition()
  param.deltaY = 20
  param.contentX = -20
  param.skillData = self.showData
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICitySkinSkillTips, {anim = false}, param)
end

function LWUICitySkinSkillUseInWorldCell:RefreshState()
  if self.showData == nil then
    return
  end
  if self.showData.state == CitySkinSkillState.NoGetPath or self.showData.state == CitySkinSkillState.Lock then
    self.curState = skillState.Lock
  else
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local cdEndTime = DataCenter.CitySkinSkillManager:GetSkillCdTime(self.showData.skillId) * 1000
    local intervalUseTime = DataCenter.CitySkinSkillManager:GetSkillIntervalUseTime(self.showData.skillId)
    local curNum = self.showData.skillTemp:GetCurNum(intervalUseTime)
    local maxNum = self.showData.skillTemp.use_times
    if curTime < cdEndTime then
      self.curState = skillState.CD
      self.cdEndTime = cdEndTime
    elseif 0 < maxNum and curNum <= 0 then
      self.curState = skillState.WaitRecovery
      self.cdEndTime = intervalUseTime * 1000 + self.showData.skillTemp.recovery_speed * 1000
    else
      self.curState = skillState.UnLock
    end
  end
  if self.seasonCallbackInfo then
    if DataCenter.DecorationDataManager:IsSeasonSkinSkill(self.showData.skillTemp) then
      self.seasonCallbackInfo:TrySetItemById(SeasonCallbackType.Base, self.showData.decorationTemp.id, true)
    else
      self.seasonCallbackInfo:SetActive(false)
    end
  end
end

return LWUICitySkinSkillUseInWorldCell
