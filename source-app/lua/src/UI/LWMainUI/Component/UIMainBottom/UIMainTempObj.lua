local UIMainTempObj = BaseClass("UIMainTempObj", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local btn_path = "btn"
local btn1_path = "btn1"
local btn2_path = "btn2"
local degree_path = "degree"
local tip_path = "tip"
local bubble_path = "tip/bubble"
local icon_path = "tip/bubble/icon"
local countdown_path = "tip/bubble/countdown"
local desc_path = "tip/bubble/desc"
local eff_ui_temp_cold_path = "Eff_ui_temp_cold"
local eff_ui_temp_hot_path = "Eff_ui_temp_hot"

function UIMainTempObj:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIMainTempObj:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMainTempObj:ComponentDefine()
  self.face1 = self:AddComponent(UIImage, btn1_path)
  self.face2 = self:AddComponent(UIImage, btn2_path)
  self.anim = self:AddComponent(UISimpleAnimation, "")
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OpenTemperatureMainUI()
  end)
  self.degree = self:AddComponent(UITextMeshProUGUIEx, degree_path)
  self.tip = self:AddComponent(UIBaseContainer, tip_path)
  self.bubble = self:AddComponent(UIButton, bubble_path)
  self.bubble:SetOnClick(function()
    self:OpenPhaseChangeMainUI()
  end)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.countdown = self:AddComponent(UITextMeshProUGUIEx, countdown_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.eff_ui_temp_cold = self:AddComponent(UIBaseContainer, eff_ui_temp_cold_path)
  self.eff_ui_temp_hot = self:AddComponent(UIBaseContainer, eff_ui_temp_hot_path)
  self.floatInsts = {}
  self.float = self:AddComponent(UIBaseComponent, "float")
  self.float:SetActive(false)
  self:MyBasePhaseChangeTip()
end

function UIMainTempObj:ComponentDestroy()
  if self.floatInsts then
    for _, floatInst in ipairs(self.floatInsts) do
      if not IsNull(floatInst) then
        CS.UnityEngine.GameObject.Destroy(floatInst)
      end
    end
    self.floatInsts = nil
  end
end

function UIMainTempObj:OnEnable()
  base.OnEnable(self)
end

function UIMainTempObj:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MyBasePhaseChangeChange, self.MyBasePhaseChangeTip)
  self:AddUIListener(EventId.MyBaseTemperatureChangeSuddenChange, self.ShowFloatChange)
end

function UIMainTempObj:OnRemoveListener()
  self:RemoveUIListener(EventId.MyBasePhaseChangeChange, self.MyBasePhaseChangeTip)
  self:RemoveUIListener(EventId.MyBaseTemperatureChangeSuddenChange, self.ShowFloatChange)
  base.OnRemoveListener(self)
end

function UIMainTempObj:MyBasePhaseChangeTip()
  local conductor = DataCenter.TemperatureManager:GetMyBaseConductor()
  local phaseChangeType = conductor:GetPhaseChangeType()
  self.showTip = false
  self.tip:SetActive(false)
  if phaseChangeType ~= PhaseChangeType.None then
    if phaseChangeType == PhaseChangeType.ToFrozen then
      if not Setting:GetBool("HIDE_FREEZE_BUBBLE", false) then
        self.showTip = true
        self.tip:SetActive(true)
        self.icon:LoadSprite("Assets/Main/Sprites/UI/UITemperature/FX_S2saiji_icon_bing.png")
        self.desc:SetLocalText("season_s2_status_desc_002")
        self.countdownLang = "season_s2_status_name_001"
      end
    elseif phaseChangeType == PhaseChangeType.ToFire then
      if not Setting:GetBool("HIDE_OVERHEAT_BUBBLE", false) then
        self.showTip = true
        self.tip:SetActive(true)
        self.icon:LoadSprite("Assets/Main/Sprites/UI/UITemperature/FX_S2saiji_icon_re.png")
        self.desc:SetLocalText("season_s2_status_desc_001")
        self.countdownLang = "season_s2_status_name_002"
      end
    elseif phaseChangeType == PhaseChangeType.FrozenToNormal then
      if not Setting:GetBool("HIDE_FREEZE_BUBBLE", false) then
        self.showTip = true
        self.tip:SetActive(true)
        self.icon:LoadSprite("Assets/Main/Sprites/UI/UITemperature/FX_S2saiji_wendu_ronghua.png")
        self.desc:SetLocalText("season_s2_tips002")
        self.countdownLang = "season_s2_status_name_003"
      end
    elseif phaseChangeType == PhaseChangeType.FireToNormal and not Setting:GetBool("HIDE_OVERHEAT_BUBBLE", false) then
      self.showTip = true
      self.tip:SetActive(true)
      self.icon:LoadSprite("Assets/Main/Sprites/UI/UITemperature/FX_S2saiji_wendu_mie.png")
      self.desc:SetLocalText("season_s2_tips003")
      self.countdownLang = "season_s2_status_name_004"
    end
    self:Update1000MS()
  end
end

function UIMainTempObj:Refresh()
  self.showTip = false
  self.tip:SetActive(false)
  self:Update1000MS()
end

function UIMainTempObj:Update1000MS()
  local temp = DataCenter.TemperatureManager:GetMyBaseTemperature()
  local arrow = ""
  if self.lastTemp then
    if temp > self.lastTemp then
      arrow = "\226\134\145"
    elseif temp < self.lastTemp then
      arrow = "\226\134\147"
    end
  end
  self.lastTemp = temp
  local tempString = DataCenter.TemperatureManager:FormatTemperature(temp)
  tempString = Localization:GetString("season_s2_common_temperature", tempString) .. arrow
  if self.curTempString ~= tempString then
    self.degree:SetText(tempString)
    self.curTempString = tempString
  end
  self.eff_ui_temp_hot:SetActive(40 <= temp)
  self.eff_ui_temp_cold:SetActive(temp <= -20)
  local metaTemp = math.floor(temp)
  if -20 < temp and temp < -19 then
    metaTemp = -19
  end
  local meta = DataCenter.TemperatureTemplateManager:GetTemplate(metaTemp)
  local nextEmoji = string.format("Assets/Main/Sprites/UI/UITemperature/%s.png", meta.emoji_btn)
  if self.curEmoji == nil then
    self.face1:LoadSprite(nextEmoji)
    self.face2:LoadSprite(nextEmoji)
  elseif self.curEmoji ~= meta.emoji_btn then
    self.face2:LoadSprite(nextEmoji)
    self.anim:Rewind("Switch")
    self.anim:Play("Switch")
  end
  self.curEmoji = meta.emoji_btn
  if self.showTip then
    local conductor = DataCenter.TemperatureManager:GetMyBaseConductor()
    if conductor:IsPhaseChanging() then
      local now = UITimeManager:GetInstance():GetServerTime()
      local remain = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutHour(conductor.nextPhaseEndTime - now)
      self.countdown:SetLocalText(self.countdownLang, remain)
    else
      self.showTip = false
      self.tip:SetActive(false)
    end
  end
end

function UIMainTempObj:OpenTemperatureMainUI()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITemperatureMain, {anim = true, hideTop = true})
end

function UIMainTempObj:OpenPhaseChangeMainUI()
  self.showTip = false
  self.tip:SetActive(false)
  local conductor = DataCenter.TemperatureManager:GetMyBaseConductor()
  local phaseChangeType = conductor:GetPhaseChangeType()
  if phaseChangeType == PhaseChangeType.ToFrozen then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITemperatureMain, {anim = true, hideTop = true}, 3)
    UIUtil.CheckEventTrigger(OpMode.ClickBtnFrozen)
  elseif phaseChangeType == PhaseChangeType.ToFire then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITemperatureMain, {anim = true, hideTop = true}, 3)
    UIUtil.CheckEventTrigger(OpMode.ClickBtnFireWillOn)
  elseif phaseChangeType == PhaseChangeType.FrozenToNormal then
    UIUtil.CheckEventTrigger(OpMode.ClickBtnThawing)
  elseif phaseChangeType == PhaseChangeType.FireToNormal then
    UIUtil.CheckEventTrigger(OpMode.ClickBtnFireWillOff)
  elseif phaseChangeType == PhaseChangeType.None and CS.CommonUtils.IsDebug() then
    Logger.LogInfo("\233\157\158\231\155\184\229\143\152\231\138\182\230\128\129")
  end
end

function UIMainTempObj:ShowFloatChange(change)
  local floatInst = CS.UnityEngine.GameObject.Instantiate(self.float.gameObject, self.float.transform.parent)
  floatInst:SetActive(true)
  table.insert(self.floatInsts, floatInst)
  floatInst.transform.anchoredPosition = Vector2.New(0, 0)
  floatInst.transform:DOAnchorPosY(100, 2)
  local text = floatInst:GetComponent(typeof(CS.TextMeshProUGUIEx))
  text:Native_SetText(Localization:GetString("season_s2_common_temperature", 0 < change and "+" .. change or change))
  text.color = 0 < change and UIUtil.HexToColor("fd7442") or UIUtil.HexToColor("5CB4FF")
  floatInst:GetComponent(typeof(CS.UnityEngine.CanvasGroup)):DOFade(0.8, 3):OnComplete(function()
    CS.UnityEngine.GameObject.Destroy(floatInst)
  end)
end

return UIMainTempObj
