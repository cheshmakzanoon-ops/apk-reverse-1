local FormationStaminaSlider = BaseClass("FormationStaminaSlider", UIBaseContainer)
local base = UIBaseContainer
local slider_path = "Slider"
local total_num_path = "totalNum"
local cost_num_path = "costNum"
local stamina_des_btn_path = "stateBtn"
local click_btn_path = "clickBtn"
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self.des_btn = self:AddComponent(UIButton, stamina_des_btn_path)
  self.click_btn = self:AddComponent(UIButton, click_btn_path)
  self.click_btn:SetOnClick(function()
    self:OnClick()
  end)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.total_num = self:AddComponent(UIText, total_num_path)
  self.cost_num = self:AddComponent(UIText, cost_num_path)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:InitData()
end

local function OnDisable(self)
  self.isTop = nil
  self.tipPivot = nil
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  base.OnDisable(self)
end

local function InitData(self)
  self.curNum = LuaEntry.Player:GetCurStamina()
  local costPoint = 0
  if self.view.ctrl.targetType ~= nil and 0 <= self.view.ctrl.targetType then
    costPoint = self.view.ctrl:GetCostStaminaByTargetType(self.view.ctrl.targetType)
  end
  if 0 < costPoint then
    self.cost_num:SetText("-" .. costPoint)
  else
    self.cost_num:SetText("")
  end
  self.isTop = false
  self.lastNum = -1
  self:UpdateStamina()
end

local function UpdateCost(self)
  local costPoint = 0
  if self.view.ctrl.targetType ~= nil and 0 <= self.view.ctrl.targetType then
    costPoint = self.view.ctrl:GetCostStaminaByTargetType(self.view.ctrl.targetType)
  end
  if 0 < costPoint then
    self.cost_num:SetText("-" .. costPoint)
  elseif costPoint == -1 then
    self.cost_num:SetLocalText(130262)
  else
    self.cost_num:SetText("")
  end
end

local function UpdateStamina(self)
  self.maxNum = 100
  local config = DataCenter.ArmyFormationDataManager:GetConfigData()
  if config ~= nil then
    self.maxNum = config.FormationStaminaMax
  end
  self.curNum = LuaEntry.Player:GetCurStamina()
  local tempValue = math.min(1, self.curNum / self.maxNum)
  self.slider:SetValue(tempValue)
  self.total_num:SetText(string.GetFormattedSeperatorNum(math.floor(self.curNum)))
end

local function OnDesClick(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.des_btn.gameObject.transform.position + Vector3.New(-19, 30, 0) * scaleFactor
  if self.isTop == true then
    position = self.des_btn.gameObject.transform.position + Vector3.New(-19, -20, 0)
  end
  local endTime = 0
  local config = DataCenter.ArmyFormationDataManager:GetConfigData()
  if config ~= nil then
    local maxNum = config.FormationStaminaMax
    local resumeSpeed = config.FormationStaminaUpdateTime
    local title = Localization:GetString(tostring(GameDialogDefine.STAMINA_RESUME_ONR_POINT_NEED_TIME), math.ceil(resumeSpeed))
    local speedAddEffect = LuaEntry.Effect:GetGameEffect(EffectDefine.STAMINA_RECOVER_SPEED_ADD)
    local content0 = 0 < speedAddEffect and Localization:GetString("320292") .. "+" .. math.floor(speedAddEffect) .. "%" or ""
    local content1 = Localization:GetString("104199")
    local content2 = Localization:GetString("104200")
    endTime = LuaEntry.Player.lastStaminaTime + (maxNum - LuaEntry.Player.stamina) * resumeSpeed * 1000
    local param = {}
    param.title = title
    param.content0 = content0
    param.content1 = content1
    param.content2 = content2
    param.endTime = endTime
    param.position = position
    param.isTop = self.isTop
    if self.isTop then
      param.pivot = Vector2.New(0.5, 1)
    end
    if self.tipPivot then
      param.pivot = self.tipPivot
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationTip, {anim = false}, param)
  end
end

local function OnAddClick(self)
  LWResourceLackUtil:GotoSpecialResLack(ResLackContextType.Energy)
end

local function OnClick(self)
  LWResourceLackUtil:GotoSpecialResLack(ResLackContextType.Energy)
end

local function SetTipTop(self)
  self.isTop = true
end

local function SetTipPivot(self, pivot)
  self.tipPivot = pivot
end

local function PlaySlideAni(self)
  local costPoint = 0
  if self.view.ctrl.targetType ~= nil and 0 <= self.view.ctrl.targetType then
    costPoint = self.view.ctrl:GetCostStaminaByTargetType(self.view.ctrl.targetType)
  end
  if 0 < costPoint then
    local targetSliderValue = math.min(1, (self.curNum - costPoint) / self.maxNum)
    local startSliderValue = self.slider:GetValue()
    local duration = 0.5
    local elapsedTime = 0
    local startNum = self.curNum
    local targetNum = self.curNum - costPoint
    self.timer = TimerManager:GetInstance():GetTimer(0.016, function(_)
      elapsedTime = elapsedTime + Time.deltaTime
      local t = math.min(elapsedTime / duration, 1)
      local newSliderValue = startSliderValue + (targetSliderValue - startSliderValue) * t
      self.slider:SetValue(newSliderValue)
      local newNum = math.floor(startNum + (targetNum - startNum) * t)
      self.total_num:SetText(string.GetFormattedSeperatorNum(math.floor(newNum)))
      if 0.5 <= t then
        self.change = true
        self.timer:Stop()
      end
    end, self, false, true, false)
    self.timer:Start()
  end
end

FormationStaminaSlider.OnEnable = OnEnable
FormationStaminaSlider.OnCreate = OnCreate
FormationStaminaSlider.OnDisable = OnDisable
FormationStaminaSlider.InitData = InitData
FormationStaminaSlider.UpdateStamina = UpdateStamina
FormationStaminaSlider.OnDesClick = OnDesClick
FormationStaminaSlider.OnAddClick = OnAddClick
FormationStaminaSlider.OnClick = OnClick
FormationStaminaSlider.SetTipTop = SetTipTop
FormationStaminaSlider.UpdateCost = UpdateCost
FormationStaminaSlider.SetTipPivot = SetTipPivot
FormationStaminaSlider.PlaySlideAni = PlaySlideAni
return FormationStaminaSlider
