local UIMainBLBtnBase = require("UI.LWMainUI.Component.UIMainBottom.LeftLayoutBtns.UIMainBLBtnBase")
local UIMainBLBtnSeasonBuild = BaseClass("UIMainBLBtnSeasonBuild", UIMainBLBtnBase)
local base = UIMainBLBtnBase
local LWUIEffectNumAdd = require("UI.LWSeason.LWUIEffectNumAdd")
local Localization = CS.GameEntry.Localization
local time_txt_path = "timeBg/timeTxt"
local tip_path = "tip"
local bubble_path = "tip/bubble"
local icon_path = "tip/bubble/icon"
local countdown_path = "tip/bubble/countdown"
local desc_path = "tip/bubble/desc"
local txt_path = "tip/bubble/icon/txt"
local player_head_path = "UIPlayerHead"

function UIMainBLBtnSeasonBuild:OnCreate()
  base.OnCreate(self)
  self.bubbleExpireTime = nil
  self.lastEffectPath = nil
  self.lastEffectNode = nil
  self.lastBubbleSeconds = nil
  self.player_head = self:AddComponent(UICommonHead, player_head_path)
  self.time_txt = self:AddComponent(UIText, time_txt_path)
  self.bubbleRoot = self:AddComponent(UIBaseContainer, tip_path)
  self.bubbleBtn = self:AddComponent(UIButton, bubble_path)
  self.bubbleIcon = self:AddComponent(UIImage, icon_path)
  self.bubbleCountdown = self:AddComponent(UITextMeshProUGUIEx, countdown_path)
  self.bubbleDesc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.bubbleTxt = self:AddComponent(UITextMeshProUGUIEx, txt_path)
  self.bubbleBtn:SetOnClick(function()
    if self.theSeasonType == SeasonMapType.Darkness then
      self.bubbleRoot:SetActive(false)
      self.bubbleTxt:SetActive(false)
      self.bubbleExpireTime = nil
      if self.lightPlayer then
        local uid = self.lightPlayer.uid
        local member = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(uid)
        if member then
          local pointId = member.pointId
          local serverId = member.serverId
          if pointId and serverId then
            local worldPointPos = SceneUtils.TileIndexToWorld(toInt(pointId), ForceChangeScene.World)
            GoToUtil.CloseAllWindows()
            GoToUtil.GotoWorldPos(worldPointPos, CS.SceneManager.World.InitZoom, 0.2, nil, toInt(serverId), 0)
            TimerManager:GetInstance():DelayInvoke(function()
              local uiPos = CS.CSUtils.WorldPositionToUISpacePosition(worldPointPos)
              local param = {}
              param.position = Vector3.New(uiPos.x, uiPos.y, uiPos.z)
              param.arrowType = ArrowType.Building
              param.positionType = PositionType.Screen
              param.isPanel = false
              param.isAutoClose = 2
              DataCenter.ArrowManager:ShowArrow(param)
            end, 0.55)
          end
        end
      end
    else
      self.lastBubbleSeconds = UITimeManager:GetInstance():GetServerSeconds()
      self.virusExpireTime = nil
      self.bubbleRoot:SetActive(false)
      if 0 < LuaEntry.Player:GetMainWorldPos() then
        GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(LuaEntry.Player:GetMainWorldPos()), CS.SceneManager.World.InitZoom)
      end
    end
  end)
  self.player_head:SetActive(false)
  self.bubbleRoot:SetActive(false)
  self.bubbleTxt:SetActive(false)
  self:RefreshRedDotNum()
end

function UIMainBLBtnSeasonBuild:OnDestroy()
  if self.lastEffectNode then
    self.lastEffectNode:Delete()
    self.lastEffectNode = nil
  end
  self.bubbleTxt = nil
  self.lastEffectPath = nil
  self.player_head = nil
  base.OnDestroy(self)
end

function UIMainBLBtnSeasonBuild:OnAddMainBtnListener()
  base.OnAddMainBtnListener(self)
  self:AddUIListener(EventId.OnEnterCity, self.Refresh)
  self:AddUIListener(EventId.OnEnterWorld, self.Refresh)
  self:AddUIListener(EventId.UserGetDesert, self.UpdateText)
  self:AddUIListener(EventId.UserLostDesert, self.UpdateText)
  self:AddUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuilding)
  self:AddUIListener(EventId.MSG_ITME_STATUS_TIME_CHANGE, self.Refresh)
  self:AddUIListener(EventId.ReceiveQuestReward, self.Refresh)
  self:AddUIListener(EventId.RefreshResourceItem, self.OnSoldierDataChanged)
  self:AddUIListener(EventId.SoldierDataChanged, self.OnSoldierDataChanged)
  self:AddUIListener(EventId.EffectNumChange, self.OnEffectNumChange)
  self:AddUIListener(EventId.BatteryPowerResourceUpdated, self.OnBatteryPowerUpdated)
  self:AddUIListener(EventId.LuaEntryEffectRefreshStatus, self.UpdateText)
end

function UIMainBLBtnSeasonBuild:OnRemoveMainBtnListener()
  base.OnRemoveMainBtnListener(self)
  self:RemoveUIListener(EventId.OnEnterCity, self.Refresh)
  self:RemoveUIListener(EventId.OnEnterWorld, self.Refresh)
  self:RemoveUIListener(EventId.UserGetDesert, self.UpdateText)
  self:RemoveUIListener(EventId.UserLostDesert, self.UpdateText)
  self:RemoveUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuilding)
  self:RemoveUIListener(EventId.MSG_ITME_STATUS_TIME_CHANGE, self.Refresh)
  self:RemoveUIListener(EventId.ReceiveQuestReward, self.Refresh)
  self:RemoveUIListener(EventId.RefreshResourceItem, self.OnSoldierDataChanged)
  self:RemoveUIListener(EventId.SoldierDataChanged, self.OnSoldierDataChanged)
  self:RemoveUIListener(EventId.EffectNumChange, self.OnEffectNumChange)
  self:RemoveUIListener(EventId.BatteryPowerResourceUpdated, self.OnBatteryPowerUpdated)
  self:RemoveUIListener(EventId.LuaEntryEffectRefreshStatus, self.UpdateText)
end

function UIMainBLBtnSeasonBuild:OnBatteryPowerUpdated()
  self:RefreshRedDotNum()
end

function UIMainBLBtnSeasonBuild:OnEffectNumChange()
  local seasonType = SeasonUtil.GetSeasonType()
  if seasonType == SeasonMapType.Mummy then
    local newMummyCount = DataCenter.SoldierDataManager:GetInsideSoldiersTotalNum(SoldierType.Mummy)
    local oldMummyCount = self.mummyCount
    if oldMummyCount and newMummyCount then
      local deltaCount = newMummyCount - oldMummyCount
      if deltaCount == 0 or 0 < deltaCount then
      else
        LWUIEffectNumAdd.CreateNewEffect(self.time_txt.transform, tostring(deltaCount), Color.New(1, 0, 0, 1))
      end
    end
  end
  self:UpdateText()
end

function UIMainBLBtnSeasonBuild:OnSoldierDataChanged()
  local seasonType = SeasonUtil.GetSeasonType()
  if seasonType == SeasonMapType.Mummy then
    local newMummyCount = DataCenter.SoldierDataManager:GetInsideSoldiersTotalNum(SoldierType.Mummy)
    local oldMummyCount = self.mummyCount
    if oldMummyCount and newMummyCount then
      local deltaCount = newMummyCount - oldMummyCount
      if deltaCount ~= 0 then
        if 0 < deltaCount then
          LWUIEffectNumAdd.CreateNewEffect(self.time_txt.transform, "+" .. deltaCount, Color.New(0.4745098039215686, 1, 0.25882352941176473, 1))
        else
          LWUIEffectNumAdd.CreateNewEffect(self.time_txt.transform, tostring(deltaCount), Color.New(1, 0, 0, 1))
        end
      end
    end
  end
  self:UpdateText()
end

function UIMainBLBtnSeasonBuild:UpdateBuilding()
  self:RefreshRedDotNum()
end

function UIMainBLBtnSeasonBuild:Update1000MS()
  if self.theSeasonType == SeasonMapType.CityStronghold and self.time_txt then
    if LuaEntry.Player.VirusLayer == 0 then
      self.time_txt:SetText("")
    else
      self.time_txt:SetText(LuaEntry.Player.VirusLayer)
    end
    if self.virusExpireTime then
      self:CheckExplodeTime()
      local now = UITimeManager:GetInstance():GetServerTime()
      local remainTime = self.virusExpireTime - now
      if 1000 <= remainTime then
        local remainTimeStr = UITimeManager:GetInstance():SecondToFmtStringForCountdownByDialog(remainTime * 0.001)
        self.bubbleCountdown:SetLocalText("season_s1_add_virus_tips04", remainTimeStr)
        self.bubbleCountdown:SetActive(true)
      else
        self.virusExpireTime = nil
        self.bubbleRoot:SetActive(false)
      end
    end
  elseif self.bubbleExpireTime ~= nil and self.theSeasonType == SeasonMapType.Darkness then
    local now = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.bubbleExpireTime - now
    local lightPlayer = self.lightPlayer
    local brightnessLevel = self.brightnessLevel
    if remainTime < 0 or brightnessLevel == nil or lightPlayer == nil then
      self.bubbleRoot:SetActive(false)
      self.bubbleExpireTime = nil
    else
      local iconName
      if brightnessLevel == 1 then
        iconName = "Assets/Main/SeasonRes/S4/Sprites/Common/PowerHouseIcon/ljq_saijis4_rukou_dianliang_04.png"
      elseif brightnessLevel == 2 then
        iconName = "Assets/Main/SeasonRes/S4/Sprites/Common/PowerHouseIcon/ljq_saijis4_rukou_dianliang_05.png"
      elseif brightnessLevel == 3 then
        iconName = "Assets/Main/SeasonRes/S4/Sprites/Common/PowerHouseIcon/ljq_saijis4_rukou_dianliang_06.png"
      elseif brightnessLevel == 4 then
        iconName = "Assets/Main/SeasonRes/S4/Sprites/Common/PowerHouseIcon/ljq_saijis4_rukou_dianliang_07.png"
      end
      if SceneUtils.GetIsInWorld() then
        UIUtil.GetTodayActiveCount("season_s4_tips053", true)
      end
      self.bubbleRoot:SetActive(true)
      if iconName then
        self.bubbleIcon:LoadSprite(iconName)
      end
      self.bubbleTxt:SetActive(true)
      self.bubbleTxt:SetText("L" .. brightnessLevel)
      self.bubbleCountdown:SetActive(false)
      local theName = UIUtil.FormatAllianceAndName(lightPlayer.abbr, lightPlayer.name, lightPlayer.uid)
      if lightPlayer.wolfEndTime then
        local wolfEndTime = toInt(lightPlayer.wolfEndTime)
        if 0 < wolfEndTime and now < tonumber(wolfEndTime) then
          theName = Localization:GetString(GameDialogDefine.WEREWOLF)
        end
      end
      self.bubbleDesc:SetLocalText("season_s4_tips053", theName)
    end
  end
end

function UIMainBLBtnSeasonBuild:RefreshRedDotNum()
  if self.theSeasonType == SeasonMapType.Desert then
    local count = SeasonUtil.CanBuildPlayerBuildingCount()
    if 0 < count then
      self.commonRedPoint:SetDefaultVisible(true)
    else
      self.commonRedPoint:SetDefaultVisible(false)
    end
  elseif self.theSeasonType == SeasonMapType.CityStronghold then
    local count = DataCenter.TaskManager:GetSeasonVirusTaskFinishCount()
    if 0 < count then
      self.commonRedPoint:SetDefaultVisible(true)
    else
      self.commonRedPoint:SetDefaultVisible(false)
    end
  end
  self:UpdateText()
end

function UIMainBLBtnSeasonBuild:OnClick()
  self.commonRedPoint:SetViewed()
  self:UpdateText()
  if self.theSeasonType == SeasonMapType.Desert then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonBuild)
  elseif self.theSeasonType == SeasonMapType.CityStronghold then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonVirus)
  elseif self.theSeasonType == SeasonMapType.Mummy then
    SeasonUtil.ShowSeasonUI(UIWindowNames.UILWMummyMain)
  elseif self.theSeasonType == SeasonMapType.Darkness then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPowerHouse, {anim = true}, 1)
  end
end

function UIMainBLBtnSeasonBuild:UpdateText()
  if self.theSeasonType == SeasonMapType.Desert then
    local myDesertList = DataCenter.DesertDataManager:GetAllMyDesert()
    local ownCount = 0
    if myDesertList then
      local selfServerId = LuaEntry.Player:GetSourceServerId()
      if LuaEntry.Player:IsLoginSourceServer() then
        for _, v in pairs(myDesertList) do
          if v.serverId == selfServerId then
            ownCount = ownCount + 1
          end
        end
      else
        for _, v in pairs(myDesertList) do
          if v.serverId ~= selfServerId then
            ownCount = ownCount + 1
          end
        end
      end
    end
    if self.time_txt then
      self.time_txt:SetText(ownCount .. "/" .. DataCenter.DesertDataManager:GetDesertMaxNum())
    end
  elseif self.theSeasonType == SeasonMapType.CityStronghold then
    local VirusLayer = toInt(LuaEntry.Player.VirusLayer)
    if self.time_txt then
      if VirusLayer == 0 then
        self.time_txt:SetText("")
        self.btn:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason1/virus/Mjc_saiji2_zhujiemianrukou_01.png")
      else
        self.time_txt:SetText(LuaEntry.Player.VirusLayer)
        self.btn:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason1/virus/Mjc_saiji2_zhujiemianrukou_02.png")
      end
    end
    local isMax = false
    local hasVirus, theEffectId, theVirusMaxEffectId = SeasonUtil.HasVirus()
    if theEffectId == 700102 and 100 <= VirusLayer and self.bubbleBtn and self.bubbleRoot then
      local nowSeconds = UITimeManager:GetInstance():GetServerSeconds()
      local addEffect = LuaEntry.Effect:GetGameEffect(EffectDefine.SEASON_VIRUS_MAX_ADD)
      local defaultMaxLayer = 100 + toInt(addEffect)
      local virusLifeTime = toInt(GetTableData(TableName.StatusTab, CityState.VirusCity, "time", 300))
      if VirusLayer >= defaultMaxLayer and (self.lastBubbleSeconds == nil or virusLifeTime < nowSeconds - self.lastBubbleSeconds) then
        isMax = true
        local virusEndTime = LuaEntry.Effect:GetStatusEndTime(CityState.VirusCity) - virusLifeTime * 1000
        local expireTime = LuaEntry.DataConfig:TryGetNum("season_virus", "k2", 30) * 1000
        self.virusExpireTime = virusEndTime - virusLifeTime + expireTime
        self.bubbleDesc:SetLocalText("season_s1_add_virus_tips05")
        self:Update1000MS()
      else
        self.virusExpireTime = nil
      end
    end
    local oldVirusLayer = self.theVirusLayer
    local oldVirusLayerMax = self.theVirusLayerMax
    self.theVirusLayer = VirusLayer
    if oldVirusLayer and VirusLayer and VirusLayer > oldVirusLayer then
      DataCenter.LWSoundManager:PlaySound(1000010, false)
    end
    self.theVirusLayerMax = isMax
    if self.bubbleRoot then
      self.bubbleRoot:SetActive(isMax)
    end
  elseif self.theSeasonType == SeasonMapType.Mummy then
    local isExistBuilding = DataCenter.BuildManager:HasSeasonMummyYardBuilding()
    if isExistBuilding then
      local mummyCount = DataCenter.SoldierDataManager:GetInsideSoldiersTotalNum(SoldierType.Mummy)
      if mummyCount ~= nil and 0 < mummyCount then
        self.time_txt:SetText(mummyCount)
      else
        self.time_txt:SetText("0")
      end
      self.mummyCount = mummyCount
    else
      self.time_txt:SetText("")
      self.mummyCount = 0
    end
    if self.bubbleRoot then
      self.bubbleRoot:SetActive(false)
    end
    self.btn:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/UIMummy/ljq_saijis3_rukou_munaiyi.png")
  elseif self.theSeasonType == SeasonMapType.Darkness then
    self.time_txt:SetText("")
    local brightnessLevel = 0
    local lightHouseStatus = DataCenter.SeasonPowerWorkerManager.lightHouseStatus
    if lightHouseStatus and lightHouseStatus.active then
      brightnessLevel = toInt(lightHouseStatus.brightnessLevel)
    end
    local lightPlayer
    local lightBuffDict = DataCenter.SeasonLightDataManager:GetAllLightBuff()
    if lightBuffDict then
      for stateId, lightStatus in pairs(lightBuffDict) do
        if lightStatus and lightStatus.lightPlayer then
          local lightLevel = toInt(lightStatus.lightPlayer.lightLevel)
          if brightnessLevel < lightLevel then
            lightPlayer = lightStatus.lightPlayer
            brightnessLevel = lightLevel
          end
          break
        end
      end
    end
    self:ShowMyLightStatus(lightHouseStatus, brightnessLevel, lightPlayer)
  end
end

function UIMainBLBtnSeasonBuild:ShowMyLightStatus(lightHouseStatus, brightnessLevel, lightPlayer)
  local sunrise = DataCenter.BloodyNightDataManager:IsSunrise()
  local lastPlayer = self.lightPlayer
  local iconEffectPath
  local iconName = "Assets/Main/SeasonRes/S4/Sprites/Common/PowerHouseIcon/ljq_saijis4_rukou_dianliang_03.png"
  self.lightPlayer = lightPlayer
  self.brightnessLevel = brightnessLevel
  if lightPlayer ~= nil and 0 < brightnessLevel and not sunrise then
    iconName = "Assets/Main/SeasonRes/S4/Sprites/Common/PowerHouseIcon/LXY_saijis4_diandeng_touxiangkuang_01.png"
    self.time_txt:SetText("L" .. brightnessLevel)
    self.player_head:SetActive(true)
    self.player_head:ParseHeadInfo(lightPlayer)
    self.lastEffectPath = nil
    if self.lastEffectNode then
      self.lastEffectNode:Delete()
      self.lastEffectNode = nil
    end
    local activeCount = UIUtil.GetTodayActiveCount("season_s4_tips053", false)
    if activeCount == 0 then
      self.bubbleExpireTime = UITimeManager:GetInstance():GetServerTime() + 5000
    end
  elseif lightHouseStatus == nil or lightHouseStatus.active ~= true then
    iconName = "Assets/Main/SeasonRes/S4/Sprites/Common/PowerHouseIcon/ljq_saijis4_rukou_dianliang_01.png"
    iconEffectPath = "Assets/Main/SeasonRes/S4/Prefabs/Effect/seasonbuild/seasonBuildObjFx06.prefab"
    self.time_txt:SetText("")
  else
    local powerNow, powerMax = DataCenter.SeasonPowerWorkerManager:GetBatteryPowerResourceInfo()
    if brightnessLevel == 0 then
      if powerNow == powerMax then
        iconEffectPath = "Assets/Main/SeasonRes/S4/Prefabs/Effect/seasonbuild/seasonBuildObjFx04.prefab"
        iconName = "Assets/Main/SeasonRes/S4/Sprites/Common/PowerHouseIcon/ljq_saijis4_rukou_dianliang_08.png"
      elseif powerNow == 0 then
        iconEffectPath = "Assets/Main/SeasonRes/S4/Prefabs/Effect/seasonbuild/seasonBuildObjFx07.prefab"
        iconName = "Assets/Main/SeasonRes/S4/Sprites/Common/PowerHouseIcon/ljq_saijis4_rukou_dianliang_02.png"
      else
        iconEffectPath = nil
        iconName = "Assets/Main/SeasonRes/S4/Sprites/Common/PowerHouseIcon/ljq_saijis4_rukou_dianliang_03.png"
      end
      self.time_txt:SetText("")
    elseif brightnessLevel == 1 then
      self.time_txt:SetText("L1")
      iconEffectPath = "Assets/Main/SeasonRes/S4/Prefabs/Effect/seasonbuild/seasonBuildObjFx00.prefab"
      iconName = "Assets/Main/SeasonRes/S4/Sprites/Common/PowerHouseIcon/ljq_saijis4_rukou_dianliang_04.png"
    elseif brightnessLevel == 2 then
      self.time_txt:SetText("L2")
      iconEffectPath = "Assets/Main/SeasonRes/S4/Prefabs/Effect/seasonbuild/seasonBuildObjFx01.prefab"
      iconName = "Assets/Main/SeasonRes/S4/Sprites/Common/PowerHouseIcon/ljq_saijis4_rukou_dianliang_05.png"
    elseif brightnessLevel == 3 then
      self.time_txt:SetText("L3")
      iconEffectPath = "Assets/Main/SeasonRes/S4/Prefabs/Effect/seasonbuild/seasonBuildObjFx02.prefab"
      iconName = "Assets/Main/SeasonRes/S4/Sprites/Common/PowerHouseIcon/ljq_saijis4_rukou_dianliang_06.png"
    elseif brightnessLevel == 4 then
      self.time_txt:SetText("L4")
      iconEffectPath = "Assets/Main/SeasonRes/S4/Prefabs/Effect/seasonbuild/seasonBuildObjFx03.prefab"
      iconName = "Assets/Main/SeasonRes/S4/Sprites/Common/PowerHouseIcon/ljq_saijis4_rukou_dianliang_07.png"
    end
    if powerNow == powerMax and 0 < brightnessLevel then
      iconEffectPath = "Assets/Main/SeasonRes/S4/Prefabs/Effect/seasonbuild/seasonBuildObjFx05.prefab"
      iconName = "Assets/Main/SeasonRes/S4/Sprites/Common/PowerHouseIcon/ljq_saijis4_rukou_dianliang_09.png"
    end
  end
  self.btn:LoadSprite(iconName)
  if lightPlayer == nil then
    self.bubbleExpireTime = nil
    self.player_head:SetActive(false)
    if iconEffectPath == nil or iconEffectPath ~= self.lastEffectPath then
      self.lastEffectPath = iconEffectPath
      if self.lastEffectNode then
        self.lastEffectNode:Delete()
        self.lastEffectNode = nil
      end
    end
    if iconEffectPath ~= nil and self.lastEffectNode == nil and self.transform then
      self.lastEffectNode = UIAsyncNode.New("eff_light", self.transform, iconEffectPath, function(go)
        if IsNotNull(go) then
          go.transform:Set_localPosition(0, 6, 0)
        end
      end)
    end
    self.bubbleRoot:SetActive(false)
  end
end

function UIMainBLBtnSeasonBuild:CheckExplodeTime()
  local my_point_id = LuaEntry.Player:GetMainWorldPos()
  if my_point_id ~= 0 and SceneUtils.GetIsInWorld() and CS.SceneManager.World ~= nil then
    local info = CS.SceneManager.World:GetPointInfo(my_point_id)
    if info and info.itemId == BuildingTypes.FUN_BUILD_MAIN then
      local statusList = info.status
      local hasVirus, theEffectId, theVirusMaxEffectId = SeasonUtil.HasVirus()
      if hasVirus and statusList ~= nil and 0 < statusList.Count then
        local count = statusList.Count
        for i = 0, count - 1 do
          local oneStatus = statusList[i]
          if oneStatus and oneStatus.Id == theVirusMaxEffectId and oneStatus.ExpireTime then
            local expireTime = LuaEntry.DataConfig:TryGetNum("season_virus", "k2", 30) * 1000
            self.virusExpireTime = oneStatus.BeginTime + expireTime + 1000
            break
          end
        end
      end
    end
  end
end

function UIMainBLBtnSeasonBuild:CheckEnable()
  local mainLv = DataCenter.BuildManager.MainLv
  if mainLv == nil or mainLv < SEASON_MIN_LEVEL then
    return false
  end
  local infoPlayer = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  if infoPlayer == nil or not SeasonUtil.IsInSeason(true) then
    return false
  end
  local selfServerId = LuaEntry.Player:GetSelfServerId()
  local theTypeServer = SeasonUtil.GetSeasonType()
  local inWorld = SceneUtils.GetIsInWorld()
  if theTypeServer == SeasonMapType.CityStronghold then
    if not inWorld then
      return false
    end
    if infoPlayer:IsInBattleServerGroupInt(selfServerId) then
      local hasVirus, theEffectId = SeasonUtil.HasVirus()
      if not hasVirus or theEffectId == nil then
        return false
      end
    else
      return false
    end
  elseif theTypeServer == SeasonMapType.Desert then
    if not inWorld then
      return false
    end
    if infoPlayer:IsInBattleServerGroupInt(selfServerId) then
      self.btn:LoadSprite("Assets/Main/Sprites/UI/UISeason/Sprites/zyf_saijikaifa_dikuai_icon.png")
    else
      return false
    end
  elseif theTypeServer == SeasonMapType.Snow then
    return false
  elseif theTypeServer == SeasonMapType.Mummy then
    local isExistBuilding = DataCenter.BuildManager:HasSeasonMummyYardBuilding()
    if not isExistBuilding then
      return false
    end
  elseif theTypeServer == SeasonMapType.Darkness then
    local lightHouseStatus = DataCenter.SeasonPowerWorkerManager.lightHouseStatus
    if lightHouseStatus == nil or lightHouseStatus.active ~= true then
      return false
    end
  elseif theTypeServer == SeasonMapType.NineNation then
    return false
  end
  self.theSeasonType = theTypeServer
  self:UpdateText()
  return true
end

return UIMainBLBtnSeasonBuild
