local FormationCreateTipNew = BaseClass("FormationCreateTipNew", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local des_txt_path = "bg/desBg/desTxt"
local create_btn_path = "enterBtn"
local create_txt_path = "enterBtn/enterText"
local common_img_tipsarrow = "common_img_tipsarrow"

local function OnCreate(self)
  base.OnCreate(self)
  self.common_img_tipsarrow = self:AddComponent(UIBaseContainer, common_img_tipsarrow)
  self.des_txt = self:AddComponent(UIText, des_txt_path)
  self.des_txt:SetLocalText(GameDialogDefine.EMPTY_FORMATION)
  self.create_txt = self:AddComponent(UIText, create_txt_path)
  self.create_btn = self:AddComponent(UIButton, create_btn_path)
  self.create_btn:SetOnClick(function()
    self:OnEditClick()
  end)
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
  self:RefreshStaminaState()
  self:RefreshEditBtnText()
end

local function OnEditClick(self)
  self.view:HideAllShowTip()
  if self.showLackStamina then
    UIUtil.ShowTipsId(GameDialogDefine.LACK_PVE_STAMINA)
  else
    self.view:OnEditClick(self.uuid, true)
  end
end

local function RefreshTimeByUuid(self, uuid, time)
  if uuid == nil or self.uuid == nil or uuid == self.uuid then
  end
end

local function SetPosition(self, posX, posY)
  local v = self.transform.position
  v.x = posX
  self.transform.position = v
  local v3 = self.common_img_tipsarrow.transform.position
  v3.x = posX
  self.common_img_tipsarrow.transform.position = v3
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
    self.create_txt:SetLocalText(GameDialogDefine.ADD_STAMINA)
  else
    self.create_txt:SetLocalText(100645)
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
FormationCreateTipNew.RefreshEditBtnText = RefreshEditBtnText
FormationCreateTipNew.RefreshStaminaState = RefreshStaminaState
return FormationCreateTipNew
