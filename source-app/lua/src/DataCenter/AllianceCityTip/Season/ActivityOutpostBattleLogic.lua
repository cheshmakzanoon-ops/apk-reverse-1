local OutpostOwnerChanged = require("Net.Msgs.Season5.Outpost.PushOutpostOwnerChangedMessage")
local OutpostScoreChanged = require("Net.Msgs.Season5.Outpost.PushOutpostScoreChangeMessage")
local Localization = CS.GameEntry.Localization
local OutpostBattleScoreData = {}
local BattleServerItem = BaseClass("ActivityOutpostBattleServerItem", UIBaseContainer)
local base = UIAsyncContainer
local ActivityOutpostBattleLogic = BaseClass("ActivityOutpostBattleLogic", UIAsyncContainer)
local image_path = "Image"
local time_tip_path = "Image/bg/time_tip"
local main_root_path = "Image/main_root"
local pro_root_path = "Image/pro_root"
local expand_btn_path = "Image/ExpandBtn"
local btn_path = "Image/ExpandBtn/Btn"
local arrow1_path = "Image/ExpandBtn/arrow1"
local arrow2_path = "Image/ExpandBtn/arrow2"
local end_time_tip_path = "Image/end_time_tip"

function ActivityOutpostBattleLogic:OnCreate()
  base.OnCreate(self)
  self.expandMode = false
  self:SetLocalScaleXYZ(0.0045, 0.0045, 0.0045)
  self.end_time_tip = self:AddComponent(UITextMeshProUGUIEx, end_time_tip_path)
  self.content = self:AddComponent(UIBaseContainer, image_path)
  self.time_tip = self:AddComponent(UITextMeshProUGUIEx, time_tip_path)
  self.main_root = self:AddComponent(BattleServerItem, main_root_path)
  self.theItemPool = self.transform:Find(pro_root_path).gameObject
  self.theItemPool:GameObjectCreatePool()
  self.theItemPool:SetActive(false)
  self.expand_btn = self:AddComponent(UIBaseContainer, expand_btn_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self.expandMode = not self.expandMode
    self.arrow1:SetActive(not self.expandMode)
    self.arrow2:SetActive(self.expandMode)
    if self.thePopupRoot then
      self.thePopupRoot:SetActive(false)
    end
    self:RefreshUI()
  end)
  self.end_time_tip:SetActive(true)
  self.arrow1 = self:AddComponent(UIImage, arrow1_path)
  self.arrow2 = self:AddComponent(UIImage, arrow2_path)
  self.arrow1:SetActive(true)
  self.arrow2:SetActive(false)
  self.expand_btn:SetActive(false)
end

function ActivityOutpostBattleLogic:OnDestroy()
  self.content:RemoveComponents(BattleServerItem)
  self.theItemPool:GameObjectRecycleAll()
  self.content = nil
  self.time_tip = nil
  self.main_root = nil
  self.expand_btn = nil
  self.end_time_tip = nil
  self.btn = nil
  self.arrow1 = nil
  self.arrow2 = nil
  base.OnDestroy(self)
end

function ActivityOutpostBattleLogic:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OutpostBattleOccupyListUpdate, self.UpdateData)
  self:AddUIListener(EventId.OutpostBattleOccupyServerChanged, self.OnOccupyServerChanged)
  self:AddUIListener(EventId.OutpostBattleFinish, self.OnBattleFinish)
  self:AddUIListener(EventId.OutpostOwnerChanged, self.OnOwnerChanged)
end

function ActivityOutpostBattleLogic:OnRemoveListener()
  self:RemoveUIListener(EventId.OutpostBattleOccupyListUpdate, self.UpdateData)
  self:RemoveUIListener(EventId.OutpostBattleOccupyServerChanged, self.OnOccupyServerChanged)
  self:RemoveUIListener(EventId.OutpostBattleFinish, self.OnBattleFinish)
  self:RemoveUIListener(EventId.OutpostOwnerChanged, self.OnOwnerChanged)
  base.OnRemoveListener(self)
end

function ActivityOutpostBattleLogic:SetLod(lod)
  if lod and self.lodCache ~= lod then
    self.lodCache = lod
    self:RefreshUI()
  end
end

function ActivityOutpostBattleLogic:CheckLod(lod)
  if lod and self.lodCache ~= lod then
    self.lodCache = lod
    self:RefreshUI()
  end
end

function ActivityOutpostBattleLogic:OnWorldAllianceCityDetail()
  self:RefreshUI()
end

function ActivityOutpostBattleLogic:OnOccupyServerChanged()
  if self.thePopupRoot ~= nil and self.thePopupRoot:AsyncLoadDone() then
    self.end_time_tip:SetAsLastSibling()
    self.expand_btn:SetAsLastSibling()
    self.thePopupRoot:SetAsLastSibling()
  end
  self:UpdateData()
end

function ActivityOutpostBattleLogic:OnBattleFinish(cityId)
  if cityId ~= nil and self.cityId == cityId then
    self.battle_end_time = nil
    self.content:SetActive(false)
  end
end

function ActivityOutpostBattleLogic:OnOwnerChanged(t)
  if t ~= nil then
    local cityId = toInt(t.cityId)
    if 0 < cityId and self.cityId == cityId then
      SFSNetwork.SendMessage(MsgDefines.FetchOutpostBattleOccupyList, self.serverId, cityId)
    end
  end
end

function ActivityOutpostBattleLogic:UpdateData()
  if self.lodCache then
    self:RefreshUI()
  end
end

function ActivityOutpostBattleLogic:ReInit(cityId, serverId, pointInfo, meta, battle_end_time)
  self.meta = meta
  self.cityId = cityId
  self.serverId = serverId
  self.thePointInfo = pointInfo
  self.battle_end_time = battle_end_time
  self:UpdateData()
end

function ActivityOutpostBattleLogic:RefreshUI()
  if self.content == nil or self.lodCache == nil or self.thePointInfo == nil or self.battle_end_time == nil then
    return
  end
  local battleInfo = DataCenter.SeasonOutpostManager:GetOutpostBattleInfo(self.cityId, self.serverId)
  local now = UITimeManager:GetInstance():GetServerTime()
  local showIt = self.lodCache <= 3 and now < self.battle_end_time and battleInfo ~= nil
  local contributeSpeed = 0
  local ownerServerId = 0
  local tmpOwnerServerId = 0
  if battleInfo then
    contributeSpeed = tonumber(battleInfo.contributeSpeed) or 0
    ownerServerId = toInt(battleInfo.ownerServerId)
    tmpOwnerServerId = toInt(battleInfo.tmpOwnerServerId)
  end
  if tmpOwnerServerId <= 0 then
    showIt = false
  end
  self.content:SetActive(showIt)
  if not showIt then
    return
  end
  if OutpostBattleScoreData == nil or OutpostBattleScoreData.time == nil or now - OutpostBattleScoreData.time > OneDayTime * 1000 then
    OutpostBattleScoreData = {time = now}
  end
  local scoreList = battleInfo.outpostOccupyScoreList
  local occupy_start_time = battleInfo.now
  local max_score = DataCenter.SeasonOutpostManager:TryGetNum("k3", 720000)
  local show_count = 1
  self:SetLocalScaleXYZ(0.0045, 0.0045, 0.0045)
  self.content:RemoveComponents(BattleServerItem)
  self.theItemPool:GameObjectRecycleAll()
  local tmpScoreInfo = OutpostScoreChanged.GetTempScoreInfo(self.cityId, self.serverId)
  if tmpScoreInfo ~= nil and tmpScoreInfo.now ~= nil and occupy_start_time < tmpScoreInfo.now then
    local theScoreOwnerServerId = toInt(tmpScoreInfo.ownerServerId)
    if 0 < theScoreOwnerServerId then
      occupy_start_time = tmpScoreInfo.now
      contributeSpeed = tonumber(tmpScoreInfo.contributeSpeed) or 0
      tmpOwnerServerId = theScoreOwnerServerId
      if tmpScoreInfo.curBuildPoint ~= nil then
        for k, v in pairs(scoreList) do
          if v.serverId == tmpOwnerServerId then
            v.serverScore = tmpScoreInfo.curBuildPoint
            break
          end
        end
      end
    end
  end
  self.main_root:ReInit(self, self.serverId, tmpOwnerServerId, self.cityId, contributeSpeed, scoreList, max_score, self.battle_end_time, occupy_start_time)
  local occupy_score = toInt(self.main_root.score)
  local occupy_end_time = self.main_root.occupy_end_time
  self.occupy_end_time = nil
  if 0 <= occupy_score and occupy_end_time ~= nil and max_score > occupy_score and contributeSpeed ~= 0 then
    self.occupy_end_time = now + 1000 * (max_score - occupy_score) / contributeSpeed
  end
  if self.expandMode then
    for k, v in pairs(scoreList) do
      if v.serverId ~= tmpOwnerServerId then
        show_count = show_count + 1
        self:AddOneServer(v.serverId, self.cityId, 0, scoreList, max_score, self.battle_end_time)
      end
    end
    self.arrow1:SetActive(false)
    self.arrow2:SetActive(true)
  else
    for k, v in pairs(scoreList) do
      if v.serverId ~= tmpOwnerServerId then
        self:AddOneServer(v.serverId, self.cityId, 0, scoreList, max_score, self.battle_end_time)
        show_count = show_count + 1
        if show_count == 3 then
          break
        end
      end
    end
    self.arrow1:SetActive(true)
    self.arrow2:SetActive(false)
  end
  self.end_time_tip:SetAsLastSibling()
  self.expand_btn:SetAsLastSibling()
  self.expand_btn:SetActive(3 < #scoreList)
  if self.thePopupRoot ~= nil and self.thePopupRoot:AsyncLoadDone() then
    self.thePopupRoot:SetAsLastSibling()
  end
end

function ActivityOutpostBattleLogic:AddOneServer(serverId, cityId, contributeSpeed, scoreList, max_score, battle_end_time)
  local goItem, theItem
  goItem = self.theItemPool:GameObjectSpawn(self.content.transform)
  goItem.name = "item_" .. UIUtil.GetLoopListItemIndex()
  goItem:SetActive(true)
  theItem = self.content:AddComponent(BattleServerItem, goItem.name)
  theItem:ReInit(self, self.serverId, serverId, cityId, contributeSpeed, scoreList, max_score, battle_end_time)
end

function ActivityOutpostBattleLogic:Update1000MS()
  if self.battle_end_time then
    local now = UITimeManager:GetInstance():GetServerTime()
    if self.occupy_end_time and now < self.occupy_end_time then
      if now < self.battle_end_time then
        local occupyStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(self.occupy_end_time - now)
        self.time_tip:SetText(Localization:GetString("season_s1_add_stronghold_desc01") .. occupyStr)
        local battleStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(self.battle_end_time - now)
        self.end_time_tip:SetText(Localization:GetString("season_s1_add_stronghold_desc02") .. battleStr)
        self.end_time_tip:SetActive(true)
      else
        self.time_tip:SetLocalText("310162")
        self.end_time_tip:SetActive(false)
        self.battle_end_time = nil
      end
    else
      if now < self.battle_end_time then
        local timeStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(self.battle_end_time - now)
        self.time_tip:SetText(Localization:GetString("season_s1_add_stronghold_desc02") .. timeStr)
      else
        self.time_tip:SetLocalText("310162")
        self.battle_end_time = nil
      end
      self.end_time_tip:SetActive(false)
    end
  end
end

function ActivityOutpostBattleLogic:DoShowDetail(x, y, z, detail, max_score)
  if detail == nil then
    return
  end
  local serverId = toInt(detail.clientServerId)
  local cityId = toInt(detail.cityId)
  local targetServerId = toInt(detail.targetServerId)
  if serverId <= 0 or cityId <= 0 or targetServerId <= 0 then
    return
  end
  if self.thePopupRoot == nil then
    local luaPath = "DataCenter.AllianceCityTip.Season.ActivityOutpostBattlePopup"
    local prefabPath = "Assets/Main/Prefabs/UI/LWSeasonShared/OutpostOccupyPopUp.prefab"
    self.thePopupRoot = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.content, function(view, go, lua, callback_param)
      if self.end_time_tip then
        self.end_time_tip:SetAsLastSibling()
      end
      if self.expand_btn then
        self.expand_btn:SetAsLastSibling()
      end
      if self.thePopupRoot ~= nil then
        self.thePopupRoot:SetAsLastSibling()
      end
    end)
  end
  self.thePopupRoot:SetData(x, y, z, detail, max_score)
  self.thePopupRoot:SetActive(true)
  self.end_time_tip:SetAsLastSibling()
  self.expand_btn:SetAsLastSibling()
  if self.thePopupRoot ~= nil and self.thePopupRoot:AsyncLoadDone() then
    self.thePopupRoot:SetAsLastSibling()
  end
end

function BattleServerItem:OnCreate()
  base.OnCreate(self)
  self.tryShowDetail = nil
  self.pro = self:AddComponent(UISlider, "pro")
  self.pro_fill = self:AddComponent(UIImage, "pro/FillArea/pro_fill")
  self.pro_abbr = self:AddComponent(UITextMeshProUGUIEx, "pro_abbr")
  self.pro_num = self:AddComponent(UITextMeshProUGUIEx, "pro_num")
  self.king_badges = self:AddComponent(UIImage, "icon")
  self.info_btn = self:AddComponent(UIButton, "infoBtn")
  self.info_btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  
  function self.timer_action()
    self:TimerAction()
  end
  
  self:AddUIListener(EventId.OutpostBattleOccupyServerInfoUpdate, self.DoShowDetail)
end

function BattleServerItem:OnDestroy()
  self:RemoveUIListener(EventId.OutpostBattleOccupyServerInfoUpdate, self.DoShowDetail)
  self:DeleteTimer()
  self.tryShowDetail = nil
  self.timer_action = nil
  self.pro = nil
  self.pro_fill = nil
  self.pro_abbr = nil
  self.pro_num = nil
  self.king_badges = nil
  self.info_btn = nil
  base.OnDestroy(self)
end

local _CacheBattleOccupyInfo = {}

function BattleServerItem:OnBtnClick()
  local key = string.format("%s_%s_%s", self.serverId, self.cityId, self.targetServerId)
  local detail = _CacheBattleOccupyInfo[key]
  if detail ~= nil then
    self:DoShowDetail(detail, true)
  end
  SFSNetwork.SendMessage(MsgDefines.FetchOutpostBattleOccupyInfo, self.serverId, self.cityId, self.targetServerId)
  self.tryShowDetail = true
end

function BattleServerItem:DoShowDetail(detail, fromCache)
  if detail == nil or self.tryShowDetail ~= true then
    return
  end
  local serverId = toInt(detail.clientServerId)
  local cityId = toInt(detail.cityId)
  local targetServerId = toInt(detail.targetServerId)
  if serverId ~= self.serverId or cityId ~= self.cityId or targetServerId ~= self.targetServerId then
    return
  end
  if fromCache ~= true then
    local key = string.format("%s_%s_%s", serverId, cityId, targetServerId)
    _CacheBattleOccupyInfo[key] = detail
  end
  local x, y, z = self:GetLocalPositionXYZ()
  self.logic:DoShowDetail(x, y, z, detail, self.score)
  self.tryShowDetail = nil
end

function BattleServerItem:AddTimer()
  self:DeleteTimer()
  self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  self.timer:Start()
end

function BattleServerItem:TimerAction()
  if self.occupy_end_time then
    local add_score = 0
    local now = UITimeManager:GetInstance():GetServerTime()
    if now < self.occupy_end_time then
      if self.score ~= nil and self.max_score ~= nil and self.occupy_start_time ~= nil and self.contributeSpeed ~= nil and self.contributeSpeed ~= 0 then
        add_score = (now - self.occupy_start_time) * 0.001 * self.contributeSpeed
        if 0 < add_score then
          local scoreNow = self.score + add_score
          self.pro:SetValue(math.max(math.min(scoreNow / self.max_score, 1), 0.01))
          self.pro_num:SetText(string.percentage(scoreNow, self.max_score, 2))
          if OutpostBattleScoreData and self.logicKey then
            OutpostBattleScoreData[self.logicKey] = scoreNow
          end
        else
          add_score = 0
          self.pro_num:SetText(string.percentage(self.score, self.max_score, 2))
        end
        return
      end
      local timeStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(self.occupy_end_time - now)
      self.pro_num:SetText(Localization:GetString("season_s1_add_stronghold_desc01") .. timeStr)
    else
      self.occupy_end_time = nil
      self:DeleteTimer()
    end
  end
end

function BattleServerItem:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function BattleServerItem:ReInit(logic, serverId, targetServerId, cityId, contributeSpeed, scoreList, max_score, battle_end_time, occupy_start_time)
  local score = 0
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  for k, v in pairs(scoreList) do
    if v.serverId == targetServerId then
      score = v.serverScore
      break
    end
  end
  self.logic = logic
  self.cityId = cityId
  self.serverId = serverId
  self.targetServerId = targetServerId
  self.score = score
  self.contributeSpeed = contributeSpeed
  self.max_score = max_score
  self.occupy_start_time = occupy_start_time
  self.occupy_end_time = nil
  self.battle_end_time = battle_end_time
  self.logicKey = string.format("%s_%s_%s", serverId, targetServerId, cityId)
  if contributeSpeed ~= nil and contributeSpeed ~= 0 then
    local now = UITimeManager:GetInstance():GetServerTime()
    self.occupy_end_time = math.min(now + 1000 * (max_score - score) / contributeSpeed, battle_end_time)
    self:AddTimer()
  else
    if OutpostBattleScoreData and self.logicKey then
      local score_cache = toInt(OutpostBattleScoreData[self.logicKey])
      if score_cache == 0 then
        OutpostBattleScoreData[self.logicKey] = score
      else
        score = math.max(score, score_cache)
        self.score = score
      end
    end
    self:DeleteTimer()
  end
  self.pro_num:SetText(string.percentage(score, max_score, 2))
  self.info_btn:SetActive(mySourceServerId == targetServerId and score ~= 0)
  self.pro:SetValue(math.max(math.min(score / max_score, 1), 0.01))
  if score == 0 then
    self.info_btn:SetActive(false)
    self.pro:SetValue(0)
    self.pro_num:SetText("0%")
  end
  self.pro_abbr:SetText("#" .. targetServerId)
  if mySourceServerId == targetServerId then
    self.pro_fill:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/LWCommon/cfm_jindutiao_2.png")
  else
    self.pro_fill:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/LWCommon/cfm_jindutiao_4.png")
  end
  local iconPath = DataCenter.ZoneWarManager:GetKingdomBadgesIconPath(targetServerId)
  self.king_badges:LoadSprite(iconPath)
  self:TimerAction()
end

return ActivityOutpostBattleLogic
