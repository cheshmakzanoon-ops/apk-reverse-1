local FormationCreateTipNew = BaseClass("FormationCreateTipNew", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local des_path = "bg/headBg/desTxt"
local toggle_path = "checkObj/item"
local toggle1_path = "checkObj/item1"
local toggle2_path = "checkObj/item2"
local toggle3_path = "checkObj/item3"
local toggle4_path = "checkObj/item4"
local rally_txt_path = "enterBtn/enterText"
local rally_btn_path = "enterBtn"

local function OnCreate(self)
  base.OnCreate(self)
  local list = self.view.ctrl:GetRallyTimeList()
  self.des = self:AddComponent(UIText, des_path)
  self.des:SetLocalText(390138)
  self.toggle = {}
  for i = 1, 4 do
    self.toggle[i] = self:AddComponent(UIToggle, toggle_path .. i)
    if list[i] then
      self.toggle[i]:SetActive(true)
      self.toggle[i]:SetIsOn(i == 1)
      self.toggle[i]:SetOnValueChanged(function(tf)
        if tf then
          self:ToggleControlBorS()
        end
      end)
      self.toggle[i].text = self.toggle[i]:AddComponent(UIText, "Text_num")
      self.toggle[i].text:SetText(list[i] .. Localization:GetString("100165"))
    else
      self.toggle[i]:SetActive(false)
    end
  end
  self.rally_btn = self:AddComponent(UIButton, rally_btn_path)
  self.rally_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnEditClick()
  end)
  self.rally_txt = self:AddComponent(UIText, rally_txt_path)
  self.showLackStamina = nil
end

local function OnDestroy(self)
  self.des_txt = nil
  self.btn_txt = nil
  self.enter_btn = nil
  self.showLackStamina = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshData(self, posX, posY, formationData)
  self.uuid = formationData.uuid
  self.index = formationData.index
  self:SetPosition(posX, posY)
  if self.uuid ~= nil then
    local time = self.view:GetTimeInFormation(self.uuid)
    self:RefreshTimeByUuid(self.uuid, time)
  end
  self:ToggleControlBorS()
  self:RefreshStaminaState()
  self:RefreshEditBtnText()
end

local function ToggleControlBorS(self)
  self.timeIndex = 0
  for i = 1, #self.toggle do
    if self.toggle[i]:GetIsOn() then
      self.timeIndex = i
      break
    end
  end
  self.view.ctrl:SetTimeIndex(self.timeIndex)
end

local function OnEditClick(self)
  if self.showLackStamina then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAddStamina)
  else
    self.view:OnEditClick(self.uuid, true)
  end
end

local function SetPosition(self, posX, posY)
  local v3 = self.transform.position
  v3.x = posX
  v3.y = posY
  self.transform.position = v3
end

local function RefreshTimeByUuid(self, uuid, time)
  if uuid == nil or self.uuid == nil or uuid == self.uuid then
  end
end

local function RefreshStaminaState(self)
  if self.view.ctrl.targetType > 0 and not BattleFieldUtil.InBattleField() and self.uuid ~= nil then
    local costPoint = self.view.ctrl:GetCostStaminaByTargetType(self.view.ctrl.targetType)
    if 1 < costPoint then
      local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(self.uuid)
      if formation ~= nil then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local deltaTime = curTime - LuaEntry.Player.lastStaminaTime
        local curStamina = LuaEntry.Player.stamina
        if costPoint > curStamina then
          local speedAddEffect = LuaEntry.Effect:GetGameEffect(EffectDefine.STAMINA_RECOVER_SPEED_ADD)
          local timeBase = LuaEntry.DataConfig:TryGetNum("car_stamina", "k2")
          local k2 = timeBase / (1 + speedAddEffect / 100)
          if 0 < k2 then
            local delta = costPoint - curStamina
            if delta < 1 then
              delta = 1
            end
            local needTime = delta * k2 * 1000
            if deltaTime < needTime then
              self.showLackStamina = true
              return
            end
          end
        end
      end
    end
  end
  if self.showLackStamina == true then
    self.showLackStamina = false
    self:RefreshEditBtnText()
  end
end

local function RefreshEditBtnText(self)
  if self.showLackStamina then
    self.rally_txt:SetLocalText(GameDialogDefine.ADD_STAMINA)
  else
    self.rally_txt:SetLocalText(300038)
  end
end

FormationCreateTipNew.OnDestroy = OnDestroy
FormationCreateTipNew.OnCreate = OnCreate
FormationCreateTipNew.OnEnable = OnEnable
FormationCreateTipNew.OnDisable = OnDisable
FormationCreateTipNew.RefreshData = RefreshData
FormationCreateTipNew.SetPosition = SetPosition
FormationCreateTipNew.RefreshTimeByUuid = RefreshTimeByUuid
FormationCreateTipNew.OnEditClick = OnEditClick
FormationCreateTipNew.ToggleControlBorS = ToggleControlBorS
FormationCreateTipNew.RefreshEditBtnText = RefreshEditBtnText
FormationCreateTipNew.RefreshStaminaState = RefreshStaminaState
return FormationCreateTipNew
