local FormationSoldierSelect = BaseClass("FormationSoldierSelect", UIBaseContainer)
local base = UIBaseContainer
local FormationSoldierChooseCell = require("UI.UIFormation.UIFormationTableNew.Component.FormationSoldierChooseCell")
local FormationSoldierItem = require("UI.UIFormation.UIFormationTableNew.Component.FormationSoldierItem")
local Localization = CS.GameEntry.Localization
local empty_obj_path = "emptyObj"
local txt_empty_path = "emptyObj/TxtEmpty"
local empty_btn_path = "emptyObj/addBtn"
local empty_btn_txt_path = "emptyObj/addBtn/addTxt"
local start_btn_path = "btn_green"
local start_des_path = "btn_green/createTxt"
local start_time_path = "btn_green/timeTxt"
local state_layout_path = "layout"
local state_txt_path = "layout/stateTxt"
local state_img_path = "layout/Img_Icon"
local state_btn_path = "layout/btn_detail"
local content_path = "ScrollView/Viewport/Content"
local soldier_num_path = "soldierNum"
local one_key_btn_path = "onekeyBtn"
local one_key_txt_path = "onekeyBtn/onekeyTxt"
local save_edit_btn_path = "SaveEditBtn"
local save_edit_txt_path = "SaveEditBtn/SaveEditTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self.state_txt = self:AddComponent(UIText, state_txt_path)
  self.state_icon = self:AddComponent(UIImage, state_img_path)
  self.state_btn = self:AddComponent(UIButton, state_btn_path)
  self.state_btn:SetOnClick(function()
    self:OnStateBtnClick()
  end)
  self.state_layout = self:AddComponent(UIBaseContainer, state_layout_path)
  self.empty_obj = self:AddComponent(UIBaseContainer, empty_obj_path)
  self.txt_empty = self:AddComponent(UIText, txt_empty_path)
  self.txt_empty:SetLocalText(GameDialogDefine.ADD_SOLDIER)
  self.empty_btn = self:AddComponent(UIButton, empty_btn_path)
  self.empty_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:JumpToBuild()
  end)
  self.empty_btn_txt = self:AddComponent(UIText, empty_btn_txt_path)
  self.empty_btn_txt:SetLocalText(130061)
  self.save_edit_btn = self:AddComponent(UIButton, save_edit_btn_path)
  self.save_edit_txt = self:AddComponent(UIText, save_edit_txt_path)
  self.start_btn = self:AddComponent(UIButton, start_btn_path)
  self.start_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Start_March, false)
    if CS.SceneManager:IsInCity() then
    else
      self.view.ctrl:OnStartClick()
    end
  end)
  self.start_des = self:AddComponent(UIText, start_des_path)
  self.start_des:SetLocalText(150122)
  self.start_time = self:AddComponent(UIText, start_time_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.army_num = self:AddComponent(UIText, soldier_num_path)
  self.one_key_btn = self:AddComponent(UIButton, one_key_btn_path)
  self.one_key_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    if self.oneKeyFill then
      self.view.ctrl:OnOneKeyFillClick()
    else
      self.view.ctrl:OnOneKeyClearClick()
    end
    self:UpdateArmyContent()
  end)
  self.one_key_txt = self:AddComponent(UIText, one_key_txt_path)
  
  function self.timer_action(temp)
    self:RefreshFormationStamina()
  end
  
  self:InitStaminaPos()
end

local function OnDestroy(self)
  self.state_txt = nil
  self.txt_empty = nil
  self.start_btn = nil
  self.start_des = nil
  self.start_time = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:AddTimer()
end

local function OnDisable(self)
  self:DeleteTimer()
  base.OnDisable(self)
end

local function RefreshData(self)
  self.save_edit_btn:SetActive(false)
  self:UpdateArmyContent()
end

local function OnSelectHeroRefresh(self)
  local data = self.view.ctrl:GetSoliderState()
  if data ~= nil then
    self.army_num:SetText(string.GetFormattedSeperatorNum(math.floor(data.curNum)) .. " / " .. string.GetFormattedSeperatorNum(math.floor(data.maxNum)))
  end
  self.view:UpdateNum()
end

local function CollectRefresh(self)
  if self.view.ctrl.targetType == MarchTargetType.COLLECT then
    local data = CS.SceneManager.World:GetResourcePointInfoByIndex(self.view.ctrl.targetPoint)
    if data then
      self.state_txt:SetText(GetTableData(TableName.GatherResource, data.id, "collect_power"))
    end
    self.state_icon:LoadSprite(string.format(LoadPath.LWCommonPath, "Common_icon_electricity"))
    self.state_btn:SetActive(false)
  elseif self.view.ctrl.targetType == MarchTargetType.PICK_GARBAGE then
    local k2 = LuaEntry.DataConfig:TryGetNum("Reconnaissance_power_consumption", "k3")
    self.state_txt:SetText(string.GetFormattedSeperatorNum(math.floor(k2)))
    self.state_icon:LoadSprite(string.format(LoadPath.LWCommonPath, "Common_icon_electricity"))
    self.state_btn:SetActive(false)
  elseif self.view.ctrl.targetType == MarchTargetType.SAMPLE then
    local k3 = LuaEntry.DataConfig:TryGetNum("Reconnaissance_power_consumption", "k3")
    self.state_txt:SetText(string.GetFormattedSeperatorNum(math.floor(k3)))
    self.state_icon:LoadSprite(string.format(LoadPath.LWCommonPath, "Common_icon_electricity"))
    self.state_btn:SetActive(false)
  else
    local curStamina = DataCenter.ArmyFormationDataManager:GetCurStaminaByUuid(self.view.ctrl.uuid)
    local costPoint = self.view.ctrl:GetCostStaminaByTargetType(self.view.ctrl.targetType)
    if 1 < costPoint and self.view.ctrl.targetType > 0 then
      local numStr = string.format("<color=#dd2828> %s</color>", "-" .. math.floor(costPoint))
      self.state_txt:SetText(math.floor(curStamina) .. numStr)
    else
      self.state_txt:SetText(math.floor(curStamina))
    end
    self.state_icon:LoadSprite(string.format("Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_stamina.png"))
    self.state_btn:SetActive(true)
  end
end

local function ClearContent(self)
  self.content:RemoveComponents(FormationSoldierChooseCell)
  self.content:RemoveComponents(FormationSoldierItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

local function UpdateArmyContent(self)
  self:ClearContent()
  if self.view.ctrl.targetType >= 0 then
    local list = self.view.ctrl:GetArmyIdList()
    if list ~= nil and 0 < #list then
      self.empty_obj:SetActive(false)
      table.sort(list, function(a, b)
        local aData = self.view.ctrl:GetArmyData(a)
        local bData = self.view.ctrl:GetArmyData(b)
        if aData.level ~= bData.level then
          return aData.level > bData.level
        end
        return aData.armyId > bData.armyId
      end)
      table.walk(list, function(k, v)
        if self.model[v] == nil then
          self.model[v] = self:GameObjectInstantiateAsync(UIAssets.FormationSoldierChooseCellNew, function(request)
            if request.isError then
              return
            end
            local go = request.gameObject
            go.gameObject:SetActive(true)
            go.transform:SetParent(self.content.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            local nameStr = tostring(NameCount)
            go.name = nameStr
            NameCount = NameCount + 1
            local cell = self.content:AddComponent(FormationSoldierChooseCell, nameStr)
            cell:InitData(v)
          end)
        end
      end)
    else
      self.empty_obj:SetActive(true)
    end
    self.one_key_btn:SetActive(true)
    self.start_btn:SetActive(true)
    local realTime = self.view.ctrl:GetCostTime() * 1000
    if self.view.ctrl.targetType == MarchTargetType.DIRECT_ATTACK_ACT_BOSS then
      local maxTime = DataCenter.ActBossDataManager.maxTime * 1000
      if realTime > maxTime then
        realTime = maxTime
      end
    end
    self.start_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(realTime))
  else
    local list = self.view.ctrl:GetCurrentSoliderDataList()
    if list ~= nil and 0 < #list then
      self.empty_obj:SetActive(false)
      table.walk(list, function(k, v)
        if self.model[v] == nil then
          self.model[v] = self:GameObjectInstantiateAsync(UIAssets.FormationSoldierItem, function(request)
            if request.isError then
              return
            end
            local go = request.gameObject
            go.gameObject:SetActive(true)
            go.transform:SetParent(self.content.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            local nameStr = tostring(NameCount)
            go.name = nameStr
            NameCount = NameCount + 1
            local cell = self.content:AddComponent(FormationSoldierItem, nameStr)
            cell:SetItemShow(v)
          end)
        end
      end)
    else
      self.empty_obj:SetActive(true)
    end
    self.one_key_btn:SetActive(false)
    self.start_btn:SetActive(false)
  end
  self:UpdateViewState()
end

local function UpdateViewState(self)
  local maxSoldier = self.view.ctrl:GetMaxNum()
  local currentTotal = self.view.ctrl:GetTotalSoldierNum()
  local curMaxSoldierNum = self.view.ctrl:GetMaxSoldierNum()
  self.oneKeyFill = maxSoldier > currentTotal and currentTotal < curMaxSoldierNum
  if self.oneKeyFill then
    self.one_key_txt:SetLocalText(110000)
  else
    self.one_key_txt:SetLocalText(150141)
  end
  self.army_num:SetText(string.GetFormattedSeperatorNum(math.floor(currentTotal)) .. " / " .. string.GetFormattedSeperatorNum(math.floor(maxSoldier)))
  self.view:UpdateNum()
end

local function JumpToBuild(self)
  local buildData = DataCenter.BuildManager:GetArmyBuildMaxLevelData()
  if buildData ~= nil then
    if buildData.itemId == BuildingTypes.FUN_BUILD_CAR_BARRACK then
      GoToUtil.GotoCityByBuildId(buildData.itemId, WorldTileBtnType.City_TrainingTank)
    elseif buildData.itemId == BuildingTypes.FUN_BUILD_INFANTRY_BARRACK then
      GoToUtil.GotoCityByBuildId(buildData.itemId, WorldTileBtnType.City_TrainingInfantry)
    elseif buildData.itemId == BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK then
      GoToUtil.GotoCityByBuildId(buildData.itemId, WorldTileBtnType.City_TrainingAircraft)
    end
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function RefreshFormationStamina(self)
  if self.view.ctrl.targetType ~= MarchTargetType.COLLECT and self.view.ctrl.targetType ~= MarchTargetType.PICK_GARBAGE and self.view.ctrl.targetType ~= MarchTargetType.SAMPLE then
    local curStamina = DataCenter.ArmyFormationDataManager:GetCurStaminaByUuid(self.view.ctrl.uuid)
    local costPoint = self.view.ctrl:GetCostStaminaByTargetType(self.view.ctrl.targetType)
    if 1 < costPoint and self.view.ctrl.targetType > 0 then
      local numStr = string.format("<color=#dd2828> %s</color>", "-" .. math.floor(costPoint))
      self.state_txt:SetText(math.floor(curStamina) .. numStr)
    else
      self.state_txt:SetText(math.floor(curStamina))
    end
  end
end

local function OnStateBtnClick(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.state_btn.gameObject.transform.position + Vector3.New(-19, 30, 0) * scaleFactor
  local endTime = 0
  local timeBase = LuaEntry.DataConfig:TryGetNum("car_stamina", "k2")
  local title = Localization:GetString("104198", math.floor(timeBase))
  local speedAddEffect = LuaEntry.Effect:GetGameEffect(EffectDefine.STAMINA_RECOVER_SPEED_ADD)
  local content0 = 0 < speedAddEffect and Localization:GetString("320292") .. "+" .. math.floor(speedAddEffect) .. "%" or ""
  local content1 = Localization:GetString("104199")
  local content2 = Localization:GetString("104200")
  local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(self.view.ctrl.uuid)
  if formation ~= nil then
    local maxAddEffect = LuaEntry.Effect:GetGameEffect(EffectDefine.STAMINA_MAX_LIMIT)
    local maxBase = LuaEntry.DataConfig:TryGetNum("car_stamina", "k1")
    local maxStamina = maxBase + maxAddEffect
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = curTime - LuaEntry.Player.lastStaminaTime
    local curStamina = LuaEntry.Player.stamina
    if maxStamina > curStamina then
      local k2 = timeBase / (1 + speedAddEffect / 100)
      if 0 < k2 then
        local delta = maxStamina - curStamina
        if delta < 1 then
          delta = 1
        end
        local needTime = delta * k2 * 1000
        if deltaTime < needTime then
          endTime = LuaEntry.Player.lastStaminaTime + needTime
        end
      end
    end
  end
  local param = {}
  param.title = title
  param.content0 = content0
  param.content1 = content1
  param.content2 = content2
  param.endTime = endTime
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationTip, {anim = false}, param)
end

local function InitStaminaPos(self)
  if self.state_layout ~= nil then
    if self.view.ctrl.targetType >= 0 then
      self.state_layout.transform:Set_localPosition(-3.5, -227, 0)
    else
      self.state_layout.transform:Set_localPosition(-3.5, -357, 0)
    end
  end
end

FormationSoldierSelect.OnCreate = OnCreate
FormationSoldierSelect.OnDestroy = OnDestroy
FormationSoldierSelect.RefreshData = RefreshData
FormationSoldierSelect.OnEnable = OnEnable
FormationSoldierSelect.OnDisable = OnDisable
FormationSoldierSelect.OnSelectHeroRefresh = OnSelectHeroRefresh
FormationSoldierSelect.OnItemMoveIn = OnItemMoveIn
FormationSoldierSelect.OnItemMoveOut = OnItemMoveOut
FormationSoldierSelect.ClearScroll = ClearScroll
FormationSoldierSelect.UpdateArmyContent = UpdateArmyContent
FormationSoldierSelect.UpdateViewState = UpdateViewState
FormationSoldierSelect.ClearContent = ClearContent
FormationSoldierSelect.OnSaveClick = OnSaveClick
FormationSoldierSelect.OnAddClick = OnAddClick
FormationSoldierSelect.CollectRefresh = CollectRefresh
FormationSoldierSelect.JumpToBuild = JumpToBuild
FormationSoldierSelect.AddTimer = AddTimer
FormationSoldierSelect.DeleteTimer = DeleteTimer
FormationSoldierSelect.RefreshFormationStamina = RefreshFormationStamina
FormationSoldierSelect.OnStateBtnClick = OnStateBtnClick
FormationSoldierSelect.InitStaminaPos = InitStaminaPos
return FormationSoldierSelect
