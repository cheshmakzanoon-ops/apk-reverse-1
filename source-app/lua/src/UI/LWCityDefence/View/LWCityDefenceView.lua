local LWCityDefenceView = BaseClass("LWCityDefenceView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWCityDefenceCell = require("UI.LWCityDefence.Component.LWCityDefenceCell")
local LWCityDefenceEpidemicAlarmCell = require("UI.LWCityDefence.Component.LWCityDefenceEpidemicAlarmCell")
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local LWCityDefenceWallBar = require("UI.LWCityDefence.Component.LWCityDefenceWallBar")
local title_path = "Root/TitleBar/TextTitle"
local title1_val_path = "Root/TopBar/DescObj/DescText1Val"
local title1_tips_path = "Root/TopBar/DescObj/DescTipsBtn"
local title2_path = "Root/TopBar/DefendingObj/DescText2"
local title2_val_path = "Root/TopBar/DefendingObj/DefendingPowerText"
local title2_tips_path = "Root/TopBar/DefendingObj/DefendingTipsBtn"
local bar_path = "Root/TopBar/DurabilityBar"
local bar_txt_path = "Root/TopBar/DurabilityBar/BarText"
local bar_repair_btn_path = "Root/TopBar/DurabilityBar/RepairBtn"
local close_btn_path = "Root/BottomBar/BtnBack"
local btm_desc_txt_path = "Root/BottomBar/BottomDescText"
local scrollView_path = "Root/ScrollView"
local content_path = "Root/ScrollView/Viewport/Content"
local hero_cell_path = "Root/UIHeroCellSmall"
local troop_cell_path = "Root/TroopCell"
local protect_time_text_path = "Root/TopBar/ProtectTimeText"
local tab_path = "Root/Tab"
local toggle1_path = "Root/Tab/toggle1"
local toggle2_path = "Root/Tab/toggle2"
local toggle2_red_point_path = "Root/Tab/toggle2/RedPoint"
local alarm_cell_path = "Root/AlarmCell"
local bg_path = "Root/Bg"
local defObj_path = "Root/TopBar/DefendingObj"
local bar_record_btn_path = "Root/TopBar/DurabilityBar/RecordBtn"
local wall_bar_node_path = "Root/TopBar/WallBarNode"

function LWCityDefenceView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:InitView()
  DataCenter.DefenceWallDataManager:FetchWallBar()
end

function LWCityDefenceView:OnDestroy()
  self:DeleteTimer()
  self.timer_action = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWCityDefenceView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ArmyFormatUpdate, self.RefreshView)
  self:AddUIListener(EventId.GetAssistanceData, self.RefreshView)
  self:AddUIListener(EventId.LuaEntryEffectRefreshStatus, self.RefreshView)
  self:AddUIListener(EventId.CityDefencePriorityUpdate, self.RefreshFormationList)
  self:AddUIListener(EventId.EpidemicBattleBeAttackedBySkill, self.RefreshEpidemicBeAttacked)
  self:AddUIListener(EventId.RefreshMyWallBar, self.OnRefreshMyWallBar)
end

function LWCityDefenceView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ArmyFormatUpdate, self.RefreshView)
  self:RemoveUIListener(EventId.GetAssistanceData, self.RefreshView)
  self:RemoveUIListener(EventId.LuaEntryEffectRefreshStatus, self.RefreshView)
  self:RemoveUIListener(EventId.CityDefencePriorityUpdate, self.RefreshFormationList)
  self:RemoveUIListener(EventId.EpidemicBattleBeAttackedBySkill, self.RefreshEpidemicBeAttacked)
  self:RemoveUIListener(EventId.RefreshMyWallBar, self.OnRefreshMyWallBar)
end

function LWCityDefenceView:ComponentDefine()
  self.title = self:AddComponent(UIText, title_path)
  self.title1_val = self:AddComponent(UIText, title1_val_path)
  self.title1_tips = self:AddComponent(UIButton, title1_tips_path)
  self.title2 = self:AddComponent(UIText, title2_path)
  self.title2_val = self:AddComponent(UIText, title2_val_path)
  self.title2_tips = self:AddComponent(UIButton, title2_tips_path)
  self.bar = self:AddComponent(UISlider, bar_path)
  self.bar_txt = self:AddComponent(UIText, bar_txt_path)
  self.btm_desc_txt = self:AddComponent(UIText, btm_desc_txt_path)
  self.bar_repair_btn = self:AddComponent(UIButton, bar_repair_btn_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.scrollView = self:AddComponent(UIScrollRect, scrollView_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.hero_cell = self.transform:Find(hero_cell_path)
  self.troop_cell = self.transform:Find(troop_cell_path)
  self.title:SetLocalText(457593)
  self.btm_desc_txt:SetLocalText(457569)
  self.protect_time_text = self:AddComponent(UIText, protect_time_text_path)
  self.title2:SetLocalText(GameDialogDefine.SOLDIERS_NUM_ON_WALL)
  self.troopCells = {}
  self.hero_cell.gameObject:GameObjectCreatePool()
  self.troop_cell.gameObject:GameObjectCreatePool()
  self.title1_tips:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:InfoBtnClick(1)
  end)
  self.title2_tips:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:InfoBtnClick(2)
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.bar_repair_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:FixDefencePower()
  end)
  self.tab = self:AddComponent(UIImage, tab_path)
  local bEpidemic = BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone)
  self.tab:SetActive(bEpidemic)
  self.toggle1 = self:AddComponent(UIToggle, toggle1_path)
  self.toggle1:SetOnValueChanged(function(tf)
    if tf then
      self.curTabIdx = 1
      for _, v in pairs(self.troopCells) do
        v:SetActive(true)
      end
      for _, v in pairs(self.alarmCells) do
        v:SetActive(false)
      end
      self:RefreshFormationList()
    end
  end)
  self.toggle2 = self:AddComponent(UIToggle, toggle2_path)
  self.toggle2:SetOnValueChanged(function(tf)
    if tf then
      self.curTabIdx = 2
      for _, v in pairs(self.troopCells) do
        v:SetActive(false)
      end
      for _, v in pairs(self.alarmCells) do
        v:SetActive(true)
      end
      self:RefreshEpidemicBeAttacked()
    end
  end)
  self.toggle2_red_point = self:AddComponent(UIBaseContainer, toggle2_red_point_path)
  self.toggle2_red_point_text = self.toggle2_red_point:AddComponent(UITextMeshProUGUIEx, "Text")
  self.alarmCells = {}
  self.alarm_cell = self.transform:Find(alarm_cell_path).gameObject
  self.alarm_cell:GameObjectCreatePool()
  self.defObj = self:AddComponent(UIBaseComponent, defObj_path)
  self.bg = self:AddComponent(UIBaseComponent, bg_path)
  self.record_btn = self:AddComponent(UIButton, bar_record_btn_path)
  self.record_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIEpidemicBattleSkillRecord)
  end)
  self.wall_bar_node = self:AddComponent(UIBaseContainer, wall_bar_node_path)
end

function LWCityDefenceView:ComponentDestroy()
  self.hero_cell.gameObject:GameObjectRecycleAll()
  self.troop_cell.gameObject:GameObjectRecycleAll()
  self.alarm_cell:GameObjectRecycleAll()
end

function LWCityDefenceView:ClearCells()
  if table.count(self.troopCells) > 0 then
    for _, v in pairs(self.troopCells) do
      v:OnDestroy()
    end
    self.troopCells = {}
    self.content:RemoveComponents(LWCityDefenceCell)
    self.hero_cell.gameObject:GameObjectRecycleAll()
    self.troop_cell.gameObject:GameObjectRecycleAll()
  end
  if 0 < table.count(self.alarmCells) then
    for _, v in pairs(self.alarmCells) do
      v:OnDestroy()
    end
    self.content:RemoveComponents(LWCityDefenceEpidemicAlarmCell)
    self.alarm_cell:GameObjectRecycleAll()
  end
end

function LWCityDefenceView:IsShowWallBar()
  local cur, max = DataCenter.DefenceWallDataManager:GetWallBarCurAndMax()
  return 0 < max
end

function LWCityDefenceView:InitView()
  self:ClearCells()
  self.curTabIdx = 1
  self:RefreshLayout()
  self:RefreshView()
  self:RefreshWallBar()
  self:RefreshEpidemicBeAttacked()
end

function LWCityDefenceView:RefreshLayout()
  local maxSX, maxSY = self.scrollView:GetOffsetMaxXY()
  local maxBgX, maxBgY = self.bg:GetOffsetMaxXY()
  local barX, barY = self.bar:GetSizeDeltaXY()
  if BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) then
    self.tab:SetActive(true)
    self.defObj:SetActive(false)
    self.record_btn:SetActive(true)
    local targetTab = self:GetUserData()
    if targetTab == 2 then
      self.toggle2:SetIsOn(true)
      self.curTabIdx = 2
    else
      self.toggle1:SetIsOn(true)
      self.curTabIdx = 1
    end
    maxSY = -300
    maxBgY = -210
    barX = 660
  elseif self:IsShowWallBar() then
    self.tab:SetActive(false)
    self.defObj:SetActive(true)
    self.record_btn:SetActive(false)
    maxSY = -372
    maxBgY = -358
    barX = 735
  else
    self.tab:SetActive(false)
    self.defObj:SetActive(true)
    self.record_btn:SetActive(false)
    maxSY = -281
    maxBgY = -271
    barX = 735
  end
  self.scrollView:SetOffsetMaxXY(maxSX, maxSY)
  self.bg:SetOffsetMaxXY(maxBgX, maxBgY)
  self.bar:SetSizeDeltaXY(barX, barY)
end

function LWCityDefenceView:RefreshWallBar()
  if self:IsShowWallBar() then
    self.wall_bar_node:SetActive(true)
    if not self.wallBar then
      self.wallBar = self.wall_bar_node:LoadComponentAsync(LWCityDefenceWallBar, "Assets/Main/SeasonRes/S6/Prefabs/UI/Mastery/WallBar.prefab")
    end
    self.wallBar:Refresh()
  else
    self.wall_bar_node:SetActive(false)
    if self.wallBar then
      self.wall_bar_node:RemoveAsyncComponent(self.wallBar)
      self.wallBar = nil
    end
  end
end

function LWCityDefenceView:OnRefreshMyWallBar()
  self:RefreshLayout()
  self:RefreshWallBar()
end

function LWCityDefenceView:RefreshFormationList()
  if self.curTabIdx ~= 1 then
    return
  end
  if table.IsNullOrEmpty(self.troopCells) then
    local formationList = DataCenter.ArmyFormationDataManager:GetArmyFormationIdList()
    for _, v in pairs(formationList) do
      local item = self.troop_cell.gameObject:GameObjectSpawn(self.content.transform)
      item.name = "item" .. v
      local obj = self.content:AddComponent(LWCityDefenceCell, item.name)
      obj:SetActive(true)
      self.troopCells[v] = obj
    end
  end
  local formationList = DataCenter.ArmyFormationDataManager:GetArmyFormationIdListSortByDefencePriority()
  local maxOlder = 0
  local orderMap = {}
  for k, v in pairs(formationList) do
    local info = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(v)
    if 0 < info.defencePriority then
      maxOlder = maxOlder + 1
    end
    local cell = self.troopCells[v]
    cell.transform:SetSiblingIndex(k - 1)
    orderMap[v] = k
  end
  for k, v in pairs(self.troopCells) do
    local order = orderMap[k]
    local param = {
      uuid = k,
      heroCell = self.hero_cell
    }
    v:RefreshData(param)
    v:RefreshPriority(order, maxOlder)
  end
end

function LWCityDefenceView:RefreshView()
  local totalSoldierNum = DataCenter.SoldierDataManager:GetInsideSoldiersTotalNum()
  self.title2_val:SetText(string.GetFormattedSeperatorNum(math.floor(totalSoldierNum)))
  local buildData = self:GetBuildData()
  self.buildData = buildData
  if buildData ~= nil then
    self.bar_txt:SetText(string.GetFormattedSeperatorNum(math.floor(buildData.durability)) .. "/" .. string.GetFormattedSeperatorNum(math.floor(buildData.defDomeMaxNum)))
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if buildData.durability < buildData.defDomeMaxNum or LuaEntry.Effect:CheckCityFarmState() then
      local str
      if LuaEntry.Effect:CheckCityFarmState() then
        local farmChangeValue = LuaEntry.Effect:GetEffectStateValue(90022) * (1 - LuaEntry.Effect:GetGameEffect(50214))
        str = Localization:GetString("building_wall_burn_durability", string.formatDecimal(farmChangeValue, 3))
      else
        local recoverSpeed = buildData.defDomeAddSpeed or 0
        local recoverSpeedUpEffectValue = LuaEntry.Effect:GetGameEffect(50216)
        recoverSpeed = recoverSpeed * (1 + recoverSpeedUpEffectValue)
        str = Localization:GetString("building_wall_normal_durability", string.formatDecimal(recoverSpeed, 3))
      end
      self.title1_val:SetText(str)
      local percent = buildData.durability / buildData.defDomeMaxNum
      self.bar:SetValue(percent)
      if BattleFieldUtil.InBattleField() then
        self.bar_repair_btn:SetActive(false)
      else
        local k3 = LuaEntry.DataConfig:TryGetNum("city_wall", "k3")
        if curTime > buildData.lastGoldRecoverDurabilityTime + k3 * 1000 then
          self.bar_repair_btn:SetActive(true)
        else
          self.bar_repair_btn:SetActive(false)
        end
      end
      self:AddTimer()
      self.isUpdate = true
      self:UpdateTime()
    else
      local protectEndTime = DataCenter.DefenceWallDataManager:GetDefenceWallData().protectEndTime
      local leftTime = protectEndTime - UITimeManager:GetInstance():GetServerTime()
      if 0 < leftTime then
        self:AddTimer()
        self:UpdateTime()
      else
        self:DeleteTimer()
        self.protect_time_text:SetActive(false)
      end
      self.isUpdate = false
      self.bar:SetValue(1)
      self.title1_val:SetLocalText("building_wall_perfect_durability")
      self.bar_repair_btn:SetActive(false)
    end
  end
  self:RefreshFormationList()
end

function LWCityDefenceView:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function LWCityDefenceView:AddTimer()
  if self.timer == nil then
    function self.timer_action(temp)
      self:UpdateTime()
    end
    
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

function LWCityDefenceView:UpdateTime()
  if self.inUpdateTime == true then
    return
  end
  self.inUpdateTime = true
  local inProtect = false
  local inResume = false
  local isFarm = LuaEntry.Effect:CheckCityFarmState()
  if self.isUpdate then
    local curData = self:GetBuildData()
    self.buildData = curData
    if curData ~= nil then
      local curNum = curData.durability
      if curNum >= self.buildData.defDomeMaxNum and not isFarm then
        self:RefreshView()
        self.inUpdateTime = false
        return
      else
        self.bar_txt:SetText(string.GetFormattedSeperatorNum(math.floor(curNum)) .. "/" .. string.GetFormattedSeperatorNum(math.floor(self.buildData.defDomeMaxNum)))
        local percent = curNum / self.buildData.defDomeMaxNum
        self.bar:SetValue(percent)
      end
    end
    if not BattleFieldUtil.InBattleField() then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local k3 = LuaEntry.DataConfig:TryGetNum("city_wall", "k3")
      local deltaTime = self.buildData.lastGoldRecoverDurabilityTime + k3 * 1000 - curTime
      if 0 <= deltaTime then
        self.bar_repair_btn:SetActive(false)
        inResume = true
      else
        self.bar_repair_btn:SetActive(true)
      end
    end
  end
  local protectEndTime = DataCenter.DefenceWallDataManager:GetDefenceWallData().protectEndTime
  local leftTime = protectEndTime - UITimeManager:GetInstance():GetServerTime()
  if 0 < leftTime then
    self.protect_time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
    self.protect_time_text:SetActive(true)
    inProtect = true
  else
    self.protect_time_text:SetActive(false)
  end
  self.inUpdateTime = false
end

function LWCityDefenceView:InfoBtnClick(num, position)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local param = UIHeroTipView.Param.New()
  param.dir = UIHeroTipView.Direction.RIGHT
  if num == 1 then
    param.defWidth = 400
    param.pivot = 0.5
    param.position = self.title1_tips.transform.position + Vector3.New(15 * CommonUtil.ArabicAutoMirrorFactor(), 0, 0) * scaleFactor
    if LuaEntry.Effect:CheckCityFarmState() then
      param.content = Localization:GetString(801148)
    else
      param.content = Localization:GetString(GameDialogDefine.DEFENCE_FORMATION_TIPS1)
    end
  elseif num == 2 then
    param.defWidth = 400
    param.pivot = 0.9
    param.position = self.title2_tips.transform.position + Vector3.New(10 * CommonUtil.ArabicAutoMirrorFactor(), 0, 0) * scaleFactor
    param.content = Localization:GetString(GameDialogDefine.DEFENCE_FORMATION_TIPS2)
  elseif num == 3 then
    param.defWidth = 400
    param.pivot = 0.6
    param.position = position + Vector3.New(25 * CommonUtil.ArabicAutoMirrorFactor(), 10, 0) * scaleFactor
    param.content = Localization:GetString("season_mastery_s6_ui_4_limit")
  end
  param.deltaX = 0
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

function LWCityDefenceView:FixDefencePower()
  local data = self:GetBuildData()
  local maxFixNum = data.defDomeMaxNum * data.fixPercentOnce / 100
  local diamondNum = data.fixDiamond
  local message = Localization:GetString(GameDialogDefine.FIX_DOME_CONFIRM, string.GetFormattedSeperatorNum(math.floor(diamondNum)), string.GetFormattedSeperatorNum(math.floor(maxFixNum)))
  UIUtil.ShowMessage(message, 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    SFSNetwork.SendMessage(MsgDefines.CityDefenceAdd)
  end, function()
  end)
end

function LWCityDefenceView:GetBuildData()
  local data = {}
  if BattleFieldUtil.InBattleField() then
    local mainCity = BattleFieldUtil.GetSelfMainCity()
    data.durability = mainCity ~= nil and mainCity.curHp or 0
    data.defDomeMaxNum = mainCity ~= nil and mainCity.curMaxHp or 0
    if data.defDomeMaxNum == 0 then
      data.defDomeMaxNum = BattleFieldUtil.GetPlayerMaxHp(BattleFieldUtil.GetCurBattleFieldType())
    end
  else
    local wallData = DataCenter.DefenceWallDataManager:GetConfigData()
    data.defDomeMaxNum = wallData.defDomeMaxNum
    data.defDomeAddSpeed = wallData.defDomeAddSpeed
    data.fixPercentOnce = wallData.fixPercentOnce
    data.fixDiamond = wallData.fixDiamond
    data.fixColdDownTime = wallData.fixColdDownTime
    local defenceData = DataCenter.DefenceWallDataManager:GetDefenceWallData()
    if defenceData ~= nil then
      local durability = defenceData.durability
      local recoverSpeedUpEffectValue = LuaEntry.Effect:GetGameEffect(50216)
      local recoverSpeed = data.defDomeAddSpeed * (1 + recoverSpeedUpEffectValue)
      local fireSpeed = LuaEntry.Effect:GetEffectStateValue(90022)
      local fireSpeedUpEffectValue = LuaEntry.Effect:GetGameEffect(50214)
      fireSpeed = fireSpeed * (1 - fireSpeedUpEffectValue)
      local realDurabilityNum = BuildingUtils.GetBuildHp(durability, defenceData.lastDurabilityTime / 1000, defenceData.fireEndTime / 1000, recoverSpeed, fireSpeed)
      realDurabilityNum = math.max(realDurabilityNum, 1)
      data.durability = math.min(realDurabilityNum, wallData.defDomeMaxNum)
      data.lastGoldRecoverDurabilityTime = defenceData.lastGoldRecoverDurabilityTime
      data.lastDurabilityTime = defenceData.lastDurabilityTime
    end
  end
  return data
end

function LWCityDefenceView:RefreshEpidemicBeAttacked()
  local redCnt, list = DataCenter.ActEpidemicZoneManager:GetBeAttackedBySkillList()
  if self.curTabIdx ~= 2 then
    self.toggle2_red_point:SetActive(0 < redCnt)
    if 0 < redCnt then
      self.toggle2_red_point_text:SetText(redCnt)
    end
    return
  end
  self.toggle2_red_point:SetActive(false)
  local cCnt = #self.alarmCells
  local lCnt = #list
  local max = math.max(cCnt, lCnt)
  for i = 1, max do
    local info = list[i]
    local cell = self.alarmCells[i]
    if info then
      if not cell then
        local objItem = self.alarm_cell:GameObjectSpawn(self.content.transform)
        objItem.name = "Record" .. i
        cell = self.content:AddComponent(LWCityDefenceEpidemicAlarmCell, objItem.name)
        self.alarmCells[i] = cell
      end
      cell:SetActive(true)
      cell:SetData(info, self)
    elseif cell then
      cell:SetActive(false)
    end
  end
end

return LWCityDefenceView
