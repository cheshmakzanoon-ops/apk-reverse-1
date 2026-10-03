local base = UIAsyncContainer
local UIWorldPointNewOtherPlayerInfoAssistanceComp = BaseClass("UIWorldPointNewOtherPlayerInfoAssistanceComp", base)
local Localization = CS.GameEntry.Localization
local UIWorldPointAssistanceHeadItem = require("UI.UIWorldPoint.Component.UIWorldPointAssistanceHeadItem")
local HeadScale = Vector3.New(1, 1, 1)
local HeadLimit = 10

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
  self:RemoveTimer()
end

local function ComponentDefine(self)
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textLbAssCount = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.compDogHeadRect = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.btnDetail = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnDetail:SetOnClick(function()
    self:OnBtnDetailClick()
  end)
  self.textLbPower = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 5)
  self.btnUpDown = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnUpDown:SetOnClick(function()
    self:OnBtnUpDownClick()
  end)
  self.imgBtn = self.viewSkin:AddComponent(self, UIImage, 7)
  self.headRoot = self.compDogHeadRect.transform
  self.dogHeads = {}
  self.widthOfRect = self.compDogHeadRect:GetSizeDeltaXY()
end

local function ComponentDestroy(self)
  self.dogHeads = nil
  self.members = nil
  self.memberCount = nil
  self.viewSkin = nil
  self.textLbAssCount = nil
  self.compDogHeadRect = nil
  self.btnDetail = nil
  self.textLbPower = nil
  self.imgIcon = nil
  self.btnUpDown = nil
  self.imgBtn = nil
end

local function DataDefine(self)
  self.isShowPlayers = CommonUtil.PlayerPrefsGetBool(SettingKeys.IS_SHOW_PLAYER_HEADS_IN_CITY_DETAIL, true)
  self:RefreshPlayerShowOrHide()
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function UIWorldPointNewOtherPlayerInfoAssistanceComp:ShowBuildAssistanceInfo()
  local data = CS.SceneManager.World:GetPointInfo(self.pointId)
  if not data then
    return
  end
  local asType = AssistanceType.MainCity
  if data.PointType == WorldPointType.WORLD_ALLIANCE_BUILD then
    asType = AssistanceType.AllianceBuild
  elseif data.PointType == WorldPointType.DRAGON_BUILDING then
    asType = AssistanceType.DragonBuild
  elseif data.PointType == WorldPointType.WINTER_ENTITY then
    asType = AssistanceType.WinterEntity
  elseif data.PointType == WorldPointType.BATTLEFIELD_BUILD then
    asType = AssistanceType.EpidemicBuild
  elseif data.PointType == WorldPointType.WORLD_CITY_OUTPOST then
    asType = AssistanceType.ASSISTANCE_OUTPOST
  elseif data.PointType == WorldPointType.WORLD_CITY_OUTPOST_TOWER then
    asType = AssistanceType.ASSISTANCE_OUTPOST
  elseif data.PointType == WorldPointType.ZWL_BUILDING or data.PointType == WorldPointType.ZWL_BUILDING_THRONE or data.PointType == WorldPointType.ZWL_BUILDING_BUFF or data.PointType == WorldPointType.ZWL_BUILDING_TOWER then
    asType = AssistanceType.ASSISTANCE_ZWL_BUILDING
  end
  local mainLv = DataCenter.BuildManager.MainLv
  local needMainLv = LuaEntry.DataConfig:TryGetNum("assistance_open", "k1")
  if mainLv >= needMainLv then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAssistance, data.uuid, data.ownerUid, self.pointId, asType)
  else
    UIUtil.ShowTips(Localization:GetString("121005", needMainLv))
  end
end

function UIWorldPointNewOtherPlayerInfoAssistanceComp:ShowAllianceCityAssistanceInfo()
  local allianceuid = LuaEntry.Player.allianceId
  if allianceuid == "" then
    UIUtil.ShowTipsId(371059)
    return
  end
  local cityInfo = WorldBattleUtil.TryGetAllianceCityInfo(self.cityId, self.pointId)
  if not cityInfo then
    return
  end
  local isThroneCity = cityInfo.type == WorldAllianceCityType.King or cityInfo.type == WorldAllianceCityType.LLThroneCity
  local isCrossServerThrone = cityInfo.isCrossServerThrone
  if cityInfo.type == WorldAllianceCityType.Stronghold then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAssistance, cityInfo.uuid, "", cityInfo.pointId, AssistanceType.CityStronghold, isThroneCity, isCrossServerThrone)
  elseif cityInfo.type == WorldAllianceCityType.TradingStation then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAssistance, cityInfo.uuid, "", cityInfo.pointId, AssistanceType.TradeState, isThroneCity, isCrossServerThrone)
  elseif cityInfo.type == WorldAllianceCityType.CrossZoneOutpost or cityInfo.type == WorldAllianceCityType.CrossZoneOutpostCanon then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAssistance, cityInfo.uuid, "", cityInfo.pointId, AssistanceType.ASSISTANCE_OUTPOST, isThroneCity, isCrossServerThrone)
  elseif cityInfo.type == WorldAllianceCityType.LLNormalCity or cityInfo.type == WorldAllianceCityType.LLThroneCity or cityInfo.type == WorldAllianceCityType.LLBuffCity or cityInfo.type == WorldAllianceCityType.LLCanon then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAssistance, cityInfo.uuid, "", cityInfo.pointId, AssistanceType.ASSISTANCE_ZWL_BUILDING, isThroneCity, isCrossServerThrone)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAssistance, cityInfo.uuid, "", cityInfo.pointId, AssistanceType.AllianceCity, isThroneCity, isCrossServerThrone)
  end
end

function UIWorldPointNewOtherPlayerInfoAssistanceComp:OnBtnDetailClick()
  if self.isCity and self.cityId then
    self:ShowAllianceCityAssistanceInfo()
  elseif self.pointId then
    self:ShowBuildAssistanceInfo()
  end
end

function UIWorldPointNewOtherPlayerInfoAssistanceComp:OnBtnUpDownClick()
  self.isShowPlayers = not self.isShowPlayers
  CommonUtil.PlayerPrefsSetBool(SettingKeys.IS_SHOW_PLAYER_HEADS_IN_CITY_DETAIL, self.isShowPlayers)
  self:RefreshPlayerShowOrHide()
end

function UIWorldPointNewOtherPlayerInfoAssistanceComp:GetMemberInfo(index)
  return self.members and self.members[index]
end

function UIWorldPointNewOtherPlayerInfoAssistanceComp:GetPlayerHead(index)
  return self.dogHeads and self.dogHeads[index] and self.dogHeads[index].head
end

function UIWorldPointNewOtherPlayerInfoAssistanceComp:GetDogHeadAnchorPos(index)
  if not self.memberShowCount or self.memberShowCount <= 1 then
    return 0, 0
  end
  local gap = self.widthOfRect / (self.memberShowCount - 1)
  return index * gap, 0
end

function UIWorldPointNewOtherPlayerInfoAssistanceComp:RefreshAllHeadState()
  for i = 1, self.memberShowCount do
    local head = self:GetPlayerHead(i)
    if head then
      head.transform:SetSiblingIndex(0)
    end
  end
  for i = 1, #self.dogHeads do
    local head = self:GetPlayerHead(i)
    if head then
      local show = i <= self.memberShowCount
      head:SetActive(show)
    end
  end
  if self.view.ReAutoFitUI then
    self.view:ReAutoFitUI()
  end
end

function UIWorldPointNewOtherPlayerInfoAssistanceComp:AsyncCreate()
  local _ = {}
  table.insert(self.dogHeads, _)
  local index = #self.dogHeads
  _.index = index
  self:GameObjectInstantiateAsync(UIAssets.UIWorldPointAssistanceHeadItem, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.headRoot)
    go.transform:Set_localScale(HeadScale.x, HeadScale.y, HeadScale.z)
    go.name = "[dynamic]AssistanceHead_" .. index
    _.head = self:AddComponent(UIWorldPointAssistanceHeadItem, go)
    local member = self:GetMemberInfo(index)
    go.gameObject:SetActive(true)
    _.head:Setup(member)
    if CommonUtil.IsArabicAutoMirrorOpen() then
      _.head:SetAnchorMinXY(1, 0.5)
      _.head:SetAnchorMaxXY(1, 0.5)
    else
      _.head:SetAnchorMinXY(0, 0.5)
      _.head:SetAnchorMaxXY(0, 0.5)
    end
    _.head:SetAnchoredPositionXY(self:GetDogHeadAnchorPos(index - 1))
    self:RefreshAllHeadState()
  end)
end

function UIWorldPointNewOtherPlayerInfoAssistanceComp:Setup(data)
  self.isCity = data.isCity
  self.pointId = data.pointId
  self.cityId = data.cityId
  self.members = data.assistanceList
  local delaySec
  local cur = UITimeManager:GetInstance():GetServerTime()
  for k, v in ipairs(data.assistanceList) do
    local marchTime = v.marchEndTime
    if cur < marchTime then
      if not delaySec then
        delaySec = marchTime - cur
      else
        delaySec = Mathf.Min(delaySec, marchTime - cur)
      end
    end
  end
  if delaySec and 0 < delaySec then
    self:StartTimer(delaySec)
  else
    self:RemoveTimer()
  end
  self.memberShowCount = Mathf.Min(data.limit, data.maxMember)
  self.memberCount = data.memberCount or 0
  self.textLbAssCount:SetText(string.format("%s/%s", self.memberCount, data.maxMember or 0))
  self.textLbPower:SetText(string.GetFormattedStr(data.totalPower or 0))
  for i = 1, self.memberShowCount do
    local head = self:GetPlayerHead(i)
    if not head then
      self:AsyncCreate()
    else
      head:Setup(self:GetMemberInfo(i))
    end
  end
  self:RefreshAllHeadState()
  local assistanceCount = CS.SceneManager.World:GetMyAssistanceCount(self.pointId)
  if 0 < assistanceCount then
    self.imgIcon:LoadSprite("Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/wxy_dashijie_zhufang_zhushouwo.png")
  else
    self.imgIcon:LoadSprite("Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/wxy_dashijie_zhufang_zhushou.png")
  end
end

function UIWorldPointNewOtherPlayerInfoAssistanceComp:StartTimer(sec)
  if sec <= 0 then
    return
  end
  self:RemoveTimer()
  self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
    EventManager:GetInstance():Broadcast(EventId.UIRefreshAssistanceDetailInfo, self.pointId)
  end, sec / 1000 + 0.1)
end

function UIWorldPointNewOtherPlayerInfoAssistanceComp:RemoveTimer()
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

function UIWorldPointNewOtherPlayerInfoAssistanceComp:RefreshPlayerShowOrHide()
  self.compDogHeadRect:SetActive(self.isShowPlayers)
  self.imgBtn:LoadSprite(self.isShowPlayers and string.format(LoadPath.UIWorkerSpritePath, "Mjc_tongyong_bt_xiao_shang") or string.format(LoadPath.UIWorkerSpritePath, "Mjc_tongyong_bt_xiao_xia"))
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

UIWorldPointNewOtherPlayerInfoAssistanceComp.OnCreate = OnCreate
UIWorldPointNewOtherPlayerInfoAssistanceComp.OnDestroy = OnDestroy
UIWorldPointNewOtherPlayerInfoAssistanceComp.OnEnable = OnEnable
UIWorldPointNewOtherPlayerInfoAssistanceComp.OnDisable = OnDisable
UIWorldPointNewOtherPlayerInfoAssistanceComp.ComponentDefine = ComponentDefine
UIWorldPointNewOtherPlayerInfoAssistanceComp.ComponentDestroy = ComponentDestroy
UIWorldPointNewOtherPlayerInfoAssistanceComp.DataDefine = DataDefine
UIWorldPointNewOtherPlayerInfoAssistanceComp.DataDestroy = DataDestroy
UIWorldPointNewOtherPlayerInfoAssistanceComp.OnAddListener = OnAddListener
UIWorldPointNewOtherPlayerInfoAssistanceComp.OnRemoveListener = OnRemoveListener
return UIWorldPointNewOtherPlayerInfoAssistanceComp
