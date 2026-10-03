local UIBuildDetailsView = BaseClass("UIBuildDetailsView", UIBaseView)
local base = UIBaseView
local UIDetailsCell = require("UI.UIBuildUpgrade.Component.UIDetailsCell")
local UIDesCell = require("UI.UIBuildUpgrade.Component.UIDesCell")
local Localization = CS.GameEntry.Localization
local panel_path = "UICommonPopUpTitle/panel"
local title_text_path = "UICommonPopUpTitle/Common_img_title/titleText"
local animator_path = "MiddleBg"
local details_btn_path = "MiddleBg/BuildInfo/InfoBtn"
local des_content_path = "MiddleBg/BuildInfo/Des/Common_bg1"
local back_btn_path = "MiddleBg/BuildDetails/BackBtn"
local detail_title_cell_path = "MiddleBg/BuildDetails/DetailTitleCell"
local scroll_view_path = "MiddleBg/BuildDetails/Scroll View"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local middle_go_path = "MiddleBg/BuildDetails"
local select_details_cell_path = "MiddleBg/BuildDetails/Common_img_select"
local build_icon_path = "MiddleBg/BuildInfo/UIBuild_icon"
local build_des_path = "MiddleBg/BuildInfo/Des/DesText"
local MoreText_path = "MiddleBg/BuildDetails/MoreText"
local build_help_btn_path = "MiddleBg/BuildInfo/Btn_List/Btn_Help"
local build_help_txt_path = "MiddleBg/BuildInfo/Btn_List/Btn_Help/helpTxt"
local build_jump_btn_path = "MiddleBg/BuildInfo/Btn_List/Btn_Jump"
local build_jump_txt_path = "MiddleBg/BuildInfo/Btn_List/Btn_Jump/jumpTxt"
local extra_effect_path = "MiddleBg/BuildInfo/UIExtraEffect"
local police_obj_path = "MiddleBg/BuildInfo/policeObj"
local police_des_path = "MiddleBg/BuildInfo/policeObj/policeDes"
local police_btn_path = "MiddleBg/BuildInfo/policeObj/PoliceBtn"
local dismantle_btn_path = "MiddleBg/BuildInfo/Btn_Dismantle"
local order_time_path = "MiddleBg/BuildInfo/OrderTime"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:SetAllCellsDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, panel_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.animator = self:AddComponent(UIAnimator, animator_path)
  self.details_btn = self:AddComponent(UIButton, details_btn_path)
  self.des_content = self:AddComponent(UIBaseContainer, des_content_path)
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.detail_title_cell = self:AddComponent(UIDetailsCell, detail_title_cell_path)
  self.middle_go = self:AddComponent(UIBaseContainer, middle_go_path)
  self.build_des = self:AddComponent(UIText, build_des_path)
  self.build_help_btn = self:AddComponent(UIButton, build_help_btn_path)
  self.build_help_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBuildAssistance()
  end)
  self.build_help_txt = self:AddComponent(UIText, build_help_txt_path)
  self.MoreText = self:AddComponent(UIText, MoreText_path)
  self.MoreText:SetActive(false)
  self.build_jump_btn = self:AddComponent(UIButton, build_jump_btn_path)
  self.build_jump_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBuildJump()
  end)
  self.build_jump_txt = self:AddComponent(UIText, build_jump_txt_path)
  self.select_details_cell = self:AddComponent(UIBaseContainer, select_details_cell_path)
  self.build_icon = self:AddComponent(UIImage, build_icon_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.details_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:DetailsBtnClick()
  end)
  self.back_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Close, false)
    self:BackBtnClick()
  end)
  self.police_obj = self:AddComponent(UIBaseContainer, police_obj_path)
  self.police_des = self:AddComponent(UIText, police_des_path)
  self.police_des:SetLocalText(140313)
  self.police_btn = self:AddComponent(UIButton, police_btn_path)
  self.police_btn:SetOnClick(function()
    self:OnPoliceClick()
  end)
  self.extra_effect = self:AddComponent(UIExtraEffect, extra_effect_path)
  self.dismantle_btn = self:AddComponent(UIButton, dismantle_btn_path)
  self.dismantle_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBuildDismantle()
  end)
  self.order_time_text = self:AddComponent(UIText, order_time_path)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.close_btn = nil
  self.title_text = nil
  self.animator = nil
  self.details_btn = nil
  self.des_content = nil
  self.back_btn = nil
  self.detail_title_cell = nil
  self.select_details_cell.transform:SetParent(self.middle_go.transform)
  self.middle_go = nil
  self.des_cell = nil
  self.select_details_cell = nil
  self.scroll_view = nil
  self.build_icon = nil
  self.build_des = nil
  self.extra_effect = nil
  self.MoreText = nil
  self.build_jump_btn = nil
  self.build_jump_txt = nil
  self.dismantle_btn = nil
  self.order_time_text = nil
end

local function DataDefine(self)
  self.initCell = nil
  self.buildUuid = nil
  self.buildData = nil
  self.buildTemplate = nil
  self.buildCurLevelTemplate = nil
  self.desCells = {}
  self.freeDesCells = {}
  self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
  self.timer:Start()
end

local function DataDestroy(self)
  self.initCell = nil
  self.buildUuid = nil
  self.buildData = nil
  self.buildTemplate = nil
  self.buildCurLevelTemplate = nil
  self.desCells = nil
  self.freeDesCells = nil
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildDataSignal)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildDataSignal)
end

local function TimerAction(self)
  if self.timerAction then
    self:timerAction()
  end
end

local function OnPoliceClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPoliceStation)
  self.ctrl:CloseSelf()
end

local function ReInit(self)
  local showPolice = false
  self.dismantle_btn:SetActive(false)
  local uuid, tabType = self:GetUserData()
  self.buildUuid = tonumber(uuid)
  self.buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.buildUuid)
  if self.buildData ~= nil then
    self.buildId = self.buildData.itemId
    self.buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.buildId)
    if self.buildTemplate ~= nil and self.buildTemplate.guard ~= nil and self.buildTemplate.guard == "1" then
      showPolice = true
    end
    self:ShowPanel()
    self:SetDetailsTitle()
    if self.buildData.itemId == BuildingTypes.APS_BUILD_WORMHOLE_MAIN or self.buildData.itemId == BuildingTypes.APS_BUILD_WORMHOLE_SUB then
      self.build_jump_btn:SetActive(true)
      local str = self.buildData.itemId == BuildingTypes.APS_BUILD_WORMHOLE_MAIN and 143586 or 143585
      self.build_jump_txt:SetLocalText(str)
    else
      self.build_jump_btn:SetActive(false)
    end
    self.dismantle_btn:SetActive(self.buildData.itemId == BuildingTypes.APS_BUILD_WORMHOLE_SUB or self.buildData.itemId == BuildingTypes.WORM_HOLE_CROSS)
    self.order_time_text:SetActive(false)
    if self.buildData.itemId == BuildingTypes.APS_BUILD_FARM then
      function self.timerAction()
        local index = DataCenter.EnergyOrderManager:GetIndexByBuildUuid(self.buildUuid)
        
        if index then
          local restTime = DataCenter.EnergyOrderManager:GetOrderRestTime(index)
          if 0 < restTime then
            if not self.order_time_text:GetActive() then
              self.order_time_text:SetActive(true)
            end
            local restTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(restTime)
            self.order_time_text:SetText(Localization:GetString("134015") .. "\n" .. restTimeStr)
          else
            self.order_time_text:SetActive(false)
            self.timerAction = nil
          end
        end
      end
      
      self.timerAction()
    else
      self.timerAction = nil
    end
  end
  local hasPolice = DataCenter.BuildManager:HasBuilding(BuildingTypes.FUN_BUILD_POLICE_STATION)
  self.police_obj:SetActive(hasPolice and showPolice)
  if tabType == UIBuildDetailTabType.Detail then
    self.animator:Play("ShowDetail", 0, 0)
    self:ShowCells()
    self.back_btn:SetActive(false)
  else
    self.animator:Play("ShowBuild", 0, 0)
    self.back_btn:SetActive(true)
  end
end

local function SetDetailsTitle(self)
  if self.buildCurLevelTemplate == nil then
    return
  end
  local count = table.count(self.buildTemplate.effect_Local_dialog)
  local showPower = LuaEntry.DataConfig:TryGetNum("show_power", "k1")
  local min, max = self.buildCurLevelTemplate:GetLevelRange()
  if showPower <= DataCenter.BuildManager.MainLv and min < max then
    count = 1 + count
  end
  if 0 < count then
    local param = UIDetailsCell.Param.New()
    param.names = {}
    param.names[1] = Localization:GetString(GameDialogDefine.LEVEL)
    for k, v in ipairs(self.buildTemplate.effect_Local_dialog) do
      param.names[k + 1] = Localization:GetString(v)
    end
    if showPower <= DataCenter.BuildManager.MainLv then
      param.names[#param.names + 1] = Localization:GetString(GameDialogDefine.POWER)
    end
    self.detail_title_cell:ReInit(param)
    self.details_btn:SetActive(true)
  else
    self.details_btn:SetActive(false)
  end
end

local function ShowPanel(self)
  if self.buildData ~= nil then
    self.level = self.buildData.level
    self.buildCurLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.buildId, self.level)
    local effectType
    if self.buildId == BuildingTypes.FUN_BUILD_CONDOMINIUM then
      effectType = HeroStationEffectType.GlobalMoney
    elseif self.buildId == BuildingTypes.FUN_BUILD_COLD_STORAGE then
      effectType = HeroStationEffectType.StorageLimit
    end
    self.extra_effect:SetData(effectType, self)
  end
  if self.buildCurLevelTemplate ~= nil then
    self.build_icon:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(self.buildId, self.level))
    self.build_des:SetLocalText(self.buildCurLevelTemplate.long_description)
    local buildName = Localization:GetString(self.buildCurLevelTemplate.name)
    local showLv = self.buildCurLevelTemplate:GetShowLevel()
    self.title_text:SetLocalText(140205, showLv, buildName)
  end
  self.build_help_txt:SetLocalText(GameDialogDefine.ASSISTANCE)
  self:ShowDesCells()
end

local function ClearScroll(self)
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UIDetailsCell)
end

local function OnCreateCell(self, itemObj, index)
  local min, max = self.buildCurLevelTemplate:GetLevelRange()
  local level = min + index - 1
  local template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.buildId, level)
  itemObj.name = self.buildId + level
  local cellItem = self.scroll_view:AddComponent(UIDetailsCell, itemObj)
  local param = UIDetailsCell.Param.New()
  param.names = {}
  param.names[1] = index
  for k, v in ipairs(template.local_num) do
    local effect = DataCenter.BuildManager:GetEffectNumWithType(v, self.buildTemplate.effect_Local_type[k])
    param.names[k + 1] = effect
  end
  local showPower = LuaEntry.DataConfig:TryGetNum("show_power", "k1")
  if showPower <= DataCenter.BuildManager.MainLv then
    param.names[#param.names + 1] = template.power
  end
  cellItem:ReInit(param)
  if level == self.level then
    self.select_details_cell.transform:SetParent(cellItem.transform)
    self.select_details_cell.transform:SetAsFirstSibling()
    self.select_details_cell.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.select_details_cell.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.select_details_cell:SetActive(true)
  end
end

local function OnDeleteCell(self, itemObj, index)
  local min, max = self.buildCurLevelTemplate:GetLevelRange()
  local level = min + index - 1
  if level == self.level then
    self.select_details_cell.transform:SetParent(self.middle_go.transform)
    self.select_details_cell:SetActive(false)
  end
  self.scroll_view:RemoveComponent(itemObj.name, UIDetailsCell)
end

local function ShowCells(self)
  self:ClearScroll()
  local count = table.count(self.buildTemplate.effect_Local_dialog)
  local showPower = LuaEntry.DataConfig:TryGetNum("show_power", "k1")
  local min, max = self.buildTemplate:GetLevelRange(self.buildData.level)
  if showPower <= DataCenter.BuildManager.MainLv and min < max then
    count = 1 + count
  end
  if 0 < count then
    local num = max - min + 1
    self.scroll_view:SetTotalCount(num)
    local showRange = self.buildData.level - min
    if showRange <= 0 then
      showRange = 1
    end
    self.scroll_view:RefillCells(showRange)
    local showMore = max < self.buildTemplate.max_level
    self.MoreText:SetActive(showMore)
    if showMore then
      local currentStageTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.buildId, min)
      local nextStageTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.buildId, max + 1)
      if currentStageTemplate ~= nil and nextStageTemplate ~= nil then
        local currentStageName = Localization:GetString(currentStageTemplate.name)
        local nextStageName = Localization:GetString(nextStageTemplate.name)
        self.MoreText:SetLocalText(140402, currentStageName, tostring(max - min + 1), nextStageName)
      end
    end
  end
end

local function SetAllCellsDestroy(self)
  self:ClearScroll()
end

local function DetailsBtnClick(self)
  if not self.initCell then
    self.initCell = true
    local ret, time = self.animator:PlayAnimationReturnTime("switchEnter")
    if ret then
      self.showTimer = TimerManager:GetInstance():GetTimer(time, function()
        if self.showTimer ~= nil then
          self.showTimer:Stop()
          self.showTimer = nil
        end
        self:ShowCells()
      end, self, true, false, false)
      self.showTimer:Start()
    end
  else
    self.animator:Play("switchEnter", 0, 0)
  end
end

local function BackBtnClick(self)
  self.animator:Play("switchOut", 0, 0)
end

local function ShowDesCells(self)
  for k, v in pairs(self.desCells) do
    v:SetActive(false)
    table.insert(self.freeDesCells, v)
  end
  self.desCells = {}
  local curNums = self.buildCurLevelTemplate.local_num
  local maxCount = table.count(curNums)
  local diaCount = table.count(self.buildTemplate.effect_Local_dialog)
  if maxCount > diaCount then
    maxCount = diaCount
  end
  if 0 < maxCount then
    self.des_content:SetActive(true)
    for i = 1, maxCount do
      local param = {}
      local needAdd = true
      local dialog = self.buildTemplate.effect_Local_dialog[i]
      param.name = Localization:GetString(dialog)
      local type = self.buildTemplate.effect_Local_type[i]
      if type == EffectLocalType.Dialog then
        param.curValue = ""
        param.addDur = ""
        local val = DataCenter.BuildManager:GetEffectNumWithType(curNums[i], type)
        if self.buildId == BuildingTypes.FUN_BUILD_CONDOMINIUM then
          val = DataCenter.HeroStationManager:CalcEffectedValue(val, HeroStationEffectType.GlobalMoney)
          val = Mathf.Round(val)
        end
        if val == nil or val == "" then
          needAdd = false
        end
        param.addValue = val
      else
        local curNumber = tonumber(curNums[i])
        local val = DataCenter.BuildManager:GetEffectNumWithType(curNumber, type)
        if self.buildId == BuildingTypes.FUN_BUILD_CONDOMINIUM then
          val = DataCenter.HeroStationManager:CalcEffectedValue(val, HeroStationEffectType.GlobalMoney)
          val = Mathf.Round(val)
        end
        param.curValue = val
      end
      if needAdd then
        self:AddOneDesCells(param)
      end
    end
    self:AddPowerDesCell()
  else
    self.des_content:SetActive(false)
    self:AddPowerDesCell()
  end
  local showBtn = false
  local buildInfo = CS.SceneManager.World:GetPointInfo(self.buildData.pointId)
  if buildInfo ~= nil and buildInfo.pointType == CS.WorldPointType.PlayerBuilding then
    cast(buildInfo, typeof(CS.BuildPointInfo))
    if buildInfo ~= nil and buildInfo.inside == 0 and DataCenter.BuildManager:HasBuilding(BuildingTypes.FUND_BUILD_ALLIANCE_CENTER) then
      showBtn = true
    end
  end
  self.build_help_btn:SetActive(showBtn)
end

local function AddPowerDesCell(self)
  local showPower = LuaEntry.DataConfig:TryGetNum("show_power", "k1")
  if showPower <= DataCenter.BuildManager.MainLv then
    self.des_content:SetActive(true)
    local param = {}
    param.name = Localization:GetString(GameDialogDefine.POWER)
    param.curValue = self.buildCurLevelTemplate.power
    self:AddOneDesCells(param)
  end
end

local function AddOneDesCells(self, param)
  if #self.freeDesCells > 0 then
    local temp = table.remove(self.freeDesCells)
    if temp ~= nil then
      temp:SetActive(true)
      temp:ReInit(param)
      temp.transform:SetParent(self.des_content.transform)
      temp.transform:SetAsLastSibling()
      self.desCells[param.name] = temp
    end
  else
    self:GameObjectInstantiateAsync(UIAssets.DesCell, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.des_content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:SetAsLastSibling()
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      self.desCells[param.name] = self.des_content:AddComponent(UIDesCell, nameStr)
      self.desCells[param.name]:ReInit(param)
    end)
  end
end

local function UpdateBuildDataSignal(self, uuid)
  if uuid == self.buildUuid then
    self.buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
    self:ShowPanel()
  end
end

local function OnBuildAssistance(self)
  local selfUid = LuaEntry.Player.uid
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAssistance, {anim = true, hideTop = true}, self.buildData.uuid, selfUid, self.buildData.pointId, 0)
end

local function OnBuildJump(self)
  if self.buildData.itemId == BuildingTypes.APS_BUILD_WORMHOLE_MAIN then
    GoToUtil.GotoCityByBuildId(BuildingTypes.APS_BUILD_WORMHOLE_SUB, WorldTileBtnType.WormHole_Enter)
  elseif self.buildData.itemId == BuildingTypes.APS_BUILD_WORMHOLE_SUB then
    GoToUtil.GotoCityByBuildId(BuildingTypes.APS_BUILD_WORMHOLE_MAIN, WorldTileBtnType.WormHole_Enter)
  end
end

local function OnBuildDismantle(self)
  if self.buildData.itemId == BuildingTypes.APS_BUILD_WORMHOLE_SUB or self.buildData.itemId == BuildingTypes.WORM_HOLE_CROSS then
    UIUtil.ShowMessage(Localization:GetString("121046"), 2, nil, nil, function()
      self.ctrl:CloseSelf()
      SFSNetwork.SendMessage(MsgDefines.FreeBuildingFoldUpNew, {
        buildUuid = self.buildData.uuid
      })
    end, nil)
  end
end

UIBuildDetailsView.OnCreate = OnCreate
UIBuildDetailsView.OnDestroy = OnDestroy
UIBuildDetailsView.OnEnable = OnEnable
UIBuildDetailsView.OnDisable = OnDisable
UIBuildDetailsView.ComponentDefine = ComponentDefine
UIBuildDetailsView.ComponentDestroy = ComponentDestroy
UIBuildDetailsView.DataDefine = DataDefine
UIBuildDetailsView.DataDestroy = DataDestroy
UIBuildDetailsView.OnAddListener = OnAddListener
UIBuildDetailsView.OnRemoveListener = OnRemoveListener
UIBuildDetailsView.TimerAction = TimerAction
UIBuildDetailsView.ReInit = ReInit
UIBuildDetailsView.OnDeleteCell = OnDeleteCell
UIBuildDetailsView.ShowCells = ShowCells
UIBuildDetailsView.OnCreateCell = OnCreateCell
UIBuildDetailsView.ClearScroll = ClearScroll
UIBuildDetailsView.SetAllCellsDestroy = SetAllCellsDestroy
UIBuildDetailsView.DetailsBtnClick = DetailsBtnClick
UIBuildDetailsView.BackBtnClick = BackBtnClick
UIBuildDetailsView.ShowPanel = ShowPanel
UIBuildDetailsView.SetDetailsTitle = SetDetailsTitle
UIBuildDetailsView.ShowDesCells = ShowDesCells
UIBuildDetailsView.AddPowerDesCell = AddPowerDesCell
UIBuildDetailsView.AddOneDesCells = AddOneDesCells
UIBuildDetailsView.UpdateBuildDataSignal = UpdateBuildDataSignal
UIBuildDetailsView.OnBuildAssistance = OnBuildAssistance
UIBuildDetailsView.OnPoliceClick = OnPoliceClick
UIBuildDetailsView.OnBuildJump = OnBuildJump
UIBuildDetailsView.OnBuildDismantle = OnBuildDismantle
return UIBuildDetailsView
