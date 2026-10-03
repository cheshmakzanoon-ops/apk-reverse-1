local UIDesertBuildStatusView = BaseClass("UIDesertBuildStatusView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UIDesertBuildStatusItem = require("UI.UIActivityCenterTable.Component.DesertBattle.BuildStatus.Component.UIDesertBuildStatusItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local btn_attack_path = "PopUpTitle/Topbar/BtnList/BtnAttack"
local btn_rally_path = "PopUpTitle/Topbar/BtnList/BtnRally"
local btn_scout_path = "PopUpTitle/Topbar/BtnList/BtnScout"
local btn_assistance_path = "PopUpTitle/Topbar/BtnList/BtnAssistance"
local btn_go_path = "PopUpTitle/Topbar/BtnList/BtnGo"
local icon_path = "PopUpTitle/Topbar/Build/icon"
local name_path = "PopUpTitle/Topbar/Build/name"
local point_text_path = "PopUpTitle/Topbar/Build/GameObject/pointText"
local speed_path = "PopUpTitle/Topbar/Build/speed"
local slider_path = "PopUpTitle/Topbar/Build/Slider"
local slider_value_path = "PopUpTitle/Topbar/Build/Slider/SliderValue"
local fill_path = "PopUpTitle/Topbar/Build/Slider/Fill Area/Fill"
local content_path = "PopUpTitle/Topbar/ScrollView/Viewport/Content"
local member_path = "PopUpTitle/Topbar/member"
local toggle1_path = "PopUpTitle/Topbar/TabHolder/Tab/toggle1"
local toggle2_path = "PopUpTitle/Topbar/TabHolder/Tab/toggle2"
local attack1_path = "PopUpTitle/Topbar/Build/icon/attack1"
local txt_attack1_path = "PopUpTitle/Topbar/Build/icon/attack1/txt_attack1"
local defence_path = "PopUpTitle/Topbar/Build/icon/defence"
local txt_defence_path = "PopUpTitle/Topbar/Build/icon/defence/txt_defence"
local attack2_path = "PopUpTitle/Topbar/Build/icon/attack2"
local txt_attack2_path = "PopUpTitle/Topbar/Build/icon/attack2/txt_attack2"

function UIDesertBuildStatusView:OnCreate()
  base.OnCreate(self)
  local param, ctrlInfo = self:GetUserData()
  self.param = param
  self.ctrlInfo = ctrlInfo
  self:ComponentDefine()
end

function UIDesertBuildStatusView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDesertBuildStatusView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UPDATE_POINTS_DATA, self.OnDragonInfoRefresh)
  self:AddUIListener(EventId.AllianceWarUpdate, self.OnRefreshAlliance)
  self:AddUIListener(EventId.ALLIANCE_WAR_DELETE, self.OnRefreshAlliance)
  self:AddUIListener(EventId.MarchItemTargetMeUpdate, self.OnRefreshAlliance)
  self:AddUIListener(EventId.NoticeMainViewUpdateMarch, self.OnRefreshAlliance)
  self:AddUIListener(EventId.UpdateAlertData, self.OnRefreshAlliance)
  self:AddUIListener(EventId.SingleMarchStateUpdate, self.OnRefreshAlliance)
  self:AddUIListener(EventId.MarchItemUpdateSelf, self.OnRefreshAlliance)
  self:AddUIListener(EventId.DragonInfoRefresh, self.OnDragonInfoRefresh)
end

function UIDesertBuildStatusView:OnRemoveListener()
  self:RemoveUIListener(EventId.UPDATE_POINTS_DATA, self.OnDragonInfoRefresh)
  self:RemoveUIListener(EventId.AllianceWarUpdate, self.OnRefreshAlliance)
  self:RemoveUIListener(EventId.ALLIANCE_WAR_DELETE, self.OnRefreshAlliance)
  self:RemoveUIListener(EventId.MarchItemTargetMeUpdate, self.OnRefreshAlliance)
  self:RemoveUIListener(EventId.NoticeMainViewUpdateMarch, self.OnRefreshAlliance)
  self:RemoveUIListener(EventId.UpdateAlertData, self.OnRefreshAlliance)
  self:RemoveUIListener(EventId.SingleMarchStateUpdate, self.OnRefreshAlliance)
  self:RemoveUIListener(EventId.MarchItemUpdateSelf, self.OnRefreshAlliance)
  self:RemoveUIListener(EventId.DragonInfoRefresh, self.OnDragonInfoRefresh)
  base.OnRemoveListener(self)
end

function UIDesertBuildStatusView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("458062")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.icon = self:AddComponent(UIImage, icon_path)
  self.name = self:AddComponent(UIText, name_path)
  self.point_text = self:AddComponent(UIText, point_text_path)
  self.speed = self:AddComponent(UIText, speed_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.slider_value = self:AddComponent(UIText, slider_value_path)
  self.point_text:SetText("0")
  self.fill = self:AddComponent(UIImage, fill_path)
  self.defence = self:AddComponent(UIImage, defence_path)
  self.txt_defence = self:AddComponent(UIText, txt_defence_path)
  self.attack1 = self:AddComponent(UIImage, attack1_path)
  self.txt_attack1 = self:AddComponent(UIText, txt_attack1_path)
  self.attack2 = self:AddComponent(UIImage, attack2_path)
  self.txt_attack2 = self:AddComponent(UIText, txt_attack2_path)
  self.showMineArmy = true
  self.toggle1 = self:AddComponent(UIToggle, toggle1_path)
  self.toggle2 = self:AddComponent(UIToggle, toggle2_path)
  self.toggle1:SetIsOn(true)
  self.toggle1:SetOnValueChanged(function(tf)
    if tf then
      self.showMineArmy = true
      self:OnRefreshAlliance()
    end
  end)
  self.toggle2:SetOnValueChanged(function(tf)
    if tf then
      self.showMineArmy = false
      self:OnRefreshAlliance()
    end
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.theItem = self.transform:Find(member_path).gameObject
  self.theItem:GameObjectCreatePool()
  local template = DataCenter.DragonBuildTemplateManager:GetTemplate(self.param.buildId)
  if template then
    self.config = template
    self.icon:LoadSpriteAsyncWithCallback(template:GetDetailPath(), function()
      if self.icon then
        self.icon:SetNativeSize()
      end
    end)
    self.name:SetLocalText(self.param.name)
    local speed = template.point_produce_per_second
    local bUp, effNum = DataCenter.ActDragonManager:GetBuildUpEffInfo(self.param.allianceId)
    if bUp then
      speed = math.floor(speed * (1 + effNum / 10000))
    end
    self.speed:SetText("+" .. speed .. "/s")
  end
  self.btn_attack = self:AddComponent(UIButton, btn_attack_path)
  self.btn_rally = self:AddComponent(UIButton, btn_rally_path)
  self.btn_scout = self:AddComponent(UIButton, btn_scout_path)
  self.btn_assistance = self:AddComponent(UIButton, btn_assistance_path)
  self.btn_go = self:AddComponent(UIButton, btn_go_path)
  self.btn_attack:SetActive(false)
  self.btn_rally:SetActive(false)
  self.btn_scout:SetActive(false)
  self.btn_assistance:SetActive(false)
  self.btn_go:SetActive(true)
  self.btn_go:SetOnClick(function()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertBuildStatus)
  end)
  self.btn_attack:SetOnClick(function()
    if self.curState == DragonBuildState.Protect then
      UIUtil.ShowTipsId(458279)
      return
    end
    MarchUtil.OnClickStartMarch(MarchTargetType.ATTACK_DRAGON_BUILDING, self.ctrlInfo.pointId, self.ctrlInfo.uuid, -1, 1)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertBuildStatus)
  end)
  self.btn_rally:SetOnClick(function()
    if self.curState == DragonBuildState.Protect then
      UIUtil.ShowTipsId(458279)
      return
    end
    MarchUtil.OnClickStartMarch(MarchTargetType.RALLY_DRAGON_BUILDING, self.ctrlInfo.pointId, self.ctrlInfo.uuid, -1, 0)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertBuildStatus)
  end)
  self.btn_scout:SetOnClick(function()
    if self.curState == DragonBuildState.Protect then
      UIUtil.ShowTipsId(458279)
      return
    end
    MarchUtil.LaunchScout(MarchTargetType.SCOUT_DRAGON_BUILDING, self.ctrlInfo.pointId, self.ctrlInfo.uuid)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertBuildStatus)
  end)
  self.btn_assistance:SetOnClick(function()
    if self.curState == DragonBuildState.Protect then
      UIUtil.ShowTipsId(458279)
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAssistance, self.ctrlInfo.uuid, self.ctrlInfo.ownerUid, self.ctrlInfo.pointId, AssistanceType.DragonBuild)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertBuildStatus)
  end)
  self:OnDragonInfoRefresh()
end

function UIDesertBuildStatusView:ComponentDestroy()
  self.content:RemoveComponents(UIDesertBuildStatusItem)
  self.theItem:GameObjectRecycleAll()
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.btn_back = nil
end

function UIDesertBuildStatusView:OnRefreshAlliance()
  self.content:RemoveComponents(UIDesertBuildStatusItem)
  self.theItem:GameObjectRecycleAll()
  local warIdList = DataCenter.AllianceWarDataManager:GetAllianceWarIdList()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for i, warId in ipairs(warIdList) do
    local data = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(warId)
    local skipIt = false
    if data.leaderMarch and data.leaderMarch.endTime and curTime >= data.leaderMarch.endTime then
      skipIt = true
    end
    if data.leaderMarch and (data.leaderMarch.status == 1 or data.leaderMarch.status == 4) then
      skipIt = true
    end
    if not skipIt and self.param.pointId == data.targetPointId and not data:AlreadyGo() then
      if CommonUtil.IsDebug() and data.leaderMarch then
        print("data.leaderMarch.status = " .. data.leaderMarch.status)
      end
      if self.showMineArmy and data.attackAllianceId == LuaEntry.Player.allianceId or not self.showMineArmy and data.attackAllianceId ~= LuaEntry.Player.allianceId then
        local theName = tostring(warId)
        local goItem = self.theItem:GameObjectSpawn(self.content.transform)
        goItem.name = theName
        goItem:SetActive(true)
        local itemNode = self.content:AddComponent(UIDesertBuildStatusItem, theName)
        itemNode:ReInit(warId, data, self.param, false)
      end
    end
  end
  local allMarches = DataCenter.WorldMarchDataManager:GetAllMarches()
  if allMarches then
    local skipMarch = false
    local allianceAbbr = ""
    local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if data ~= nil and data.abbr ~= nil and data.abbr ~= "" then
      allianceAbbr = data.abbr
    end
    for k, marchData in pairs(allMarches) do
      local status = marchData:GetMarchStatus()
      local targetType = marchData:GetMarchTargetType()
      if status == MarchStatus.IN_TEAM or status == MarchStatus.WAIT_RALLY or targetType == MarchTargetType.BACK_HOME then
      else
        skipMarch = marchData.worldId == 0 or marchData.targetPos ~= self.param.pointId
        if (status == MarchStatus.ASSISTANCE or status == MarchStatus.STATION) and marchData.allianceUid ~= self.param.allianceId then
          skipMarch = true
        end
        if not skipMarch and marchData.worldId > 0 and marchData.targetPos == self.param.pointId and (self.showMineArmy and marchData.allianceUid == LuaEntry.Player.allianceId or not self.showMineArmy and marchData.allianceUid ~= LuaEntry.Player.allianceId) then
          local theName = tostring(marchData.uuid)
          local goItem = self.theItem:GameObjectSpawn(self.content.transform)
          goItem.name = theName
          goItem:SetActive(true)
          local itemNode = self.content:AddComponent(UIDesertBuildStatusItem, theName)
          itemNode:ReInit(marchData.uuid, marchData, self.param, true)
        end
      end
    end
  end
  self:UpdateMarch()
end

function UIDesertBuildStatusView:Update1000MS()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.occupyAllianceId ~= nil and self.config ~= nil then
    self.point_text:SetText(tostring(self.param.overflowScore or self.param.score or 0))
  elseif self.param.state == 0 and self.protectTime ~= nil and curTime < self.protectTime then
    local remainTime = self.protectTime - curTime
    if 0 < remainTime then
      local total_time = 600000
      self.curState = DragonBuildState.Protect
      self.slider:SetValue(math.max(0, math.min(100, 100 - remainTime * 100 / total_time)))
      self.slider_value:SetText(Localization:GetString("458192") .. " " .. UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.btn_attack:SetActive(true)
      self.btn_rally:SetActive(true)
      self.btn_scout:SetActive(true)
      self.protectTime = nil
      self.slider:SetValue(0)
      self.slider_value:SetLocalText("458224")
      self.curState = DragonBuildState.Normal
    end
  elseif self.param.state == 3 and self.occupyTime ~= nil and curTime < self.occupyTime then
    local remainTime = self.occupyTime - curTime
    if 0 < remainTime then
      local total_time = 120000
      self.slider:SetValue(math.max(math.min(100, 100 - remainTime * 100 / total_time)))
      self.slider_value:SetText(Localization:GetString("458195") .. " " .. UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      local dragonInfo = DataCenter.ActDragonManager:GetActInfo()
      local myAllianceId = LuaEntry.Player.allianceId
      self.occupyTime = nil
      self.slider_value:SetText(Localization:GetString("458193") .. dragonInfo:GetAllianceName(self.param.allianceId))
      if self.param.allianceId == myAllianceId then
        self.btn_assistance:SetActive(true)
      else
        self.btn_attack:SetActive(true)
        self.btn_rally:SetActive(true)
        self.btn_scout:SetActive(true)
      end
      self.slider:SetValue(100)
      self.occupyAllianceId = self.param.allianceId
    end
  end
end

function UIDesertBuildStatusView:UpdateMarch()
  local mgr = BattleFieldUtil.GetMgrActive()
  local attackCountRed, attackCountBlue, defenceCountRed, defenceCountBlue = mgr:GetAttackInfo(self.config.mainIndex, self.param.allianceId)
  if 0 < attackCountBlue and 0 < attackCountRed then
    self.attack1:SetActive(true)
    self.attack2:SetActive(true)
    self.txt_attack1:SetText(attackCountBlue)
    self.txt_attack2:SetText(attackCountRed)
    self.attack1:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldPath, "lrb_shamofengbao_tubiao_wofangxingjun"))
    self.attack2:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldPath, "lrb_shamofengbao_tubiao_difangxingjun"))
  elseif 0 < attackCountBlue then
    self.attack1:SetActive(true)
    self.attack2:SetActive(false)
    self.txt_attack1:SetText(attackCountBlue)
    self.attack1:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldPath, "lrb_shamofengbao_tubiao_wofangxingjun"))
  elseif 0 < attackCountRed then
    self.attack1:SetActive(true)
    self.attack2:SetActive(false)
    self.txt_attack1:SetText(attackCountRed)
    self.attack1:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldPath, "lrb_shamofengbao_tubiao_difangxingjun"))
  else
    self.attack1:SetActive(false)
    self.attack2:SetActive(false)
  end
  self.defence:SetActive(0 < defenceCountRed or 0 < defenceCountBlue)
  self.txt_defence:SetText(defenceCountRed + defenceCountBlue)
  if 0 < defenceCountRed then
    self.defence:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldPath, "lrb_shamofengbao_tubiao_difangzhushou"))
  elseif 0 < defenceCountBlue then
    self.defence:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldPath, "lrb_shamofengbao_tubiao_wofangzhushou"))
  end
end

function UIDesertBuildStatusView:UpdateData()
end

function UIDesertBuildStatusView:OnDragonInfoRefresh()
  ProfilerUtil.BeginSample("UIDesertBuildStatusView:OnDragonInfoRefresh")
  local pointData = DataCenter.ActDragonManager:GetBuildData(self.param.pointId)
  local dragonInfo = DataCenter.ActDragonManager:GetActInfo()
  local myAllianceId = LuaEntry.Player.allianceId
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.param = pointData
  self.curState = nil
  local isObserve = BattleFieldUtil.isObserve
  self.btn_attack:SetActive(false)
  self.btn_rally:SetActive(false)
  self.btn_scout:SetActive(false)
  self.btn_assistance:SetActive(false)
  self.btn_go:SetActive(not isObserve)
  if self.param.state == 0 then
    if curTime < self.param.openTime then
      self.curState = DragonBuildState.Protect
      self.btn_go:SetActive(not isObserve)
    else
      self.btn_attack:SetActive(not isObserve)
      self.btn_rally:SetActive(not isObserve)
      self.btn_scout:SetActive(not isObserve)
      self.btn_assistance:SetActive(false)
      self.slider_value:SetLocalText("458194")
      self.curState = DragonBuildState.Normal
    end
    self.fill:LoadSpriteAuto("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_jindutiao_huang.png")
    self.slider:SetValue(0)
  elseif self.param.state == 3 then
    if self.param.allianceId == myAllianceId then
      self.btn_assistance:SetActive(not isObserve)
      self.fill:LoadSpriteAuto("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_jindutiao_lan.png")
    else
      self.btn_attack:SetActive(not isObserve)
      self.btn_rally:SetActive(not isObserve)
      self.btn_scout:SetActive(not isObserve)
      self.fill:LoadSpriteAuto("Assets/Main/Sprites/UI/LWAllianceZone/Textures/zyf_chengchixinxi_hongse_jindutiao.png")
    end
    self.curState = DragonBuildState.Occupying
  elseif self.param.state == 1 then
    self.slider_value:SetText(Localization:GetString("458193") .. " " .. dragonInfo:GetAllianceName(self.param.allianceId))
    if self.param.allianceId == myAllianceId then
      self.btn_assistance:SetActive(not isObserve)
      self.fill:LoadSpriteAuto("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_jindutiao_lan.png")
    else
      self.btn_attack:SetActive(not isObserve)
      self.btn_rally:SetActive(not isObserve)
      self.btn_scout:SetActive(not isObserve)
      self.btn_assistance:SetActive(false)
      self.fill:LoadSpriteAuto("Assets/Main/Sprites/UI/LWAllianceZone/Textures/zyf_chengchixinxi_hongse_jindutiao.png")
    end
    self.slider:SetValue(100)
    self.occupyAllianceId = self.param.allianceId
    self.curState = DragonBuildState.Occupied
  end
  self.occupyTime = self.param.occupyTime
  self.protectTime = self.param.openTime
  self:Update1000MS()
  self:OnRefreshAlliance()
  ProfilerUtil.EndSample()
end

return UIDesertBuildStatusView
