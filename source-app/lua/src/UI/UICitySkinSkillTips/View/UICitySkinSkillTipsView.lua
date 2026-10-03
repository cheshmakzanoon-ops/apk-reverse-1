local UICitySkinSkillTipsView = BaseClass("UICitySkinSkillTipsView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ParamData = {
  position = Vector2.zero,
  deltaX = 0,
  deltaY = 0,
  contentX = 0,
  skillData = nil
}
local ParamDataClass = DataClass("ParamDataClass", ParamData)

local function OnCreate(self)
  base.OnCreate(self)
  self.param = nil
  self:ComponentDefine()
end

local function OnDestroy(self)
  self.param = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.param = self:GetUserData()
  local contentDeltaX = 166
  local contentDeltaY = 16
  local arrowMidPosX = 80
  self.contentWidth = self.content.transform.sizeDelta
  local arrowX = self.param.position.x
  local arrowY = self.param.position.y
  self.imgArrow:SetPositionXYZ(arrowX, arrowY, 0)
  local anchoredPosition = self.imgArrow:GetAnchoredPosition()
  local contentPosX = 0
  local contentPosY = 0
  arrowX = anchoredPosition.x + self.param.deltaX
  arrowY = anchoredPosition.y + self.param.deltaY
  self.imgArrow:SetAnchoredPositionXY(arrowX, arrowY)
  if anchoredPosition.x > 0 then
    if arrowMidPosX < anchoredPosition.x then
      contentPosX = arrowX - contentDeltaX
    else
      contentPosX = arrowX - contentDeltaX + (arrowMidPosX - anchoredPosition.x)
    end
  elseif anchoredPosition.x < -arrowMidPosX then
    contentPosX = arrowX + contentDeltaX
  else
    contentPosX = arrowX + contentDeltaX - (arrowMidPosX - anchoredPosition.x)
  end
  contentPosY = arrowY + contentDeltaY
  contentPosX = contentPosX + self.param.contentX
  self.content:SetAnchoredPositionXY(contentPosX, contentPosY)
  local useTime = 0
  if self.param.skillData and self.param.skillData.skillTemp.use_times then
    useTime = self.param.skillData.skillTemp.use_times
  end
  if 1 < useTime then
  else
    self.textContent:SetLocalText(self.param.skillData.skillTemp.skill_tips)
    self.text2Content:SetText("")
  end
  self:Update1000MS()
end

local function ComponentDefine(self)
  local btnPanel = self:AddComponent(UIButton, "Panel")
  btnPanel:SetOnClick(function()
    if self.param ~= nil and self.param.closeCallBack ~= nil then
      self.param.closeCallBack()
    end
    self.ctrl.CloseSelf(self.ctrl)
  end)
  self.imgArrow = self:AddComponent(UIBaseContainer, "ImgArrow")
  self.content = self:AddComponent(UIBaseContainer, "content")
  self.textContent = self:AddComponent(UIText, "content/TextContent")
  self.text2Content = self:AddComponent(UIText, "content/Text2Content")
end

local function ComponentDestroy(self)
  self.imgArrow.transform.localRotation = Vector3.New(0, 0, 0)
  self.content.transform.sizeDelta = self.contentWidth
  self.imgArrow = nil
  self.textContent = nil
  self.text2Content = nil
end

function UICitySkinSkillTipsView:Update1000MS()
  if self.param and self.param.skillData and self.param.skillData.skillTemp.use_times > 1 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local intervalUseTime = DataCenter.CitySkinSkillManager:GetSkillIntervalUseTime(self.param.skillData.skillId)
    local maxNumTime = self.param.skillData.skillTemp:GetMaxNumTime(intervalUseTime)
    local deltaTime = 0
    if curTime < maxNumTime then
      deltaTime = maxNumTime - curTime
    end
    local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
    local recoverTime = self.param.skillData.skillTemp.recovery_speed
    local timeNum = math.floor(recoverTime / 60)
    if 120 <= timeNum then
      timeNum = math.floor(timeNum / 60 * 10) / 10
      self.textContent:SetLocalText("decoration_skill_times_tips2_new", timeNum)
    else
      self.textContent:SetLocalText("decoration_skill_times_tips2", timeNum)
    end
    if deltaTime <= 0 then
      self.text2Content:SetLocalText("decoration_skill_times_tips3")
    else
      self.text2Content:SetLocalText("decoration_skill_times_tips4", showTime)
    end
  end
end

UICitySkinSkillTipsView.ParamDataClass = ParamDataClass
UICitySkinSkillTipsView.OnCreate = OnCreate
UICitySkinSkillTipsView.OnDestroy = OnDestroy
UICitySkinSkillTipsView.OnEnable = OnEnable
UICitySkinSkillTipsView.ComponentDefine = ComponentDefine
UICitySkinSkillTipsView.ComponentDestroy = ComponentDestroy
return UICitySkinSkillTipsView
