local FormationSimulatedBattleV2 = BaseClass("FormationSimulatedBattleV2", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local root_path = "root"
local icon_path = "root/icon"
local loading_path = "root/icon/loading"
local text_path = "root/text"
local icon_refresh_path = "root/iconRefresh"
local _ConfigData = {}
local _RecordData = {}
local local_debug_log

local function InitConfig()
  local cfg = _ConfigData
  if cfg == nil or cfg.MaxWaitTime == nil then
    cfg = {}
    cfg.MaxWaitTime = LuaEntry.DataConfig:TryGetNum("sim_battle", "k1", 1.5)
    local MaxTimeCountStr = LuaEntry.DataConfig:TryGetStr("sim_battle", "k2", "60,20")
    local MaxTime, MaxCount = string.match(MaxTimeCountStr, "([^;,|]+)[;,|]([^;,|]+)")
    if MaxTime ~= nil and MaxCount ~= nil then
      cfg.MaxTime = toInt(MaxTime) * 1000
      cfg.MaxCount = toInt(MaxCount)
    else
      cfg.MaxTime = 60000
      cfg.MaxCount = 20
    end
    local LimitSettingStr = LuaEntry.DataConfig:TryGetStr("sim_battle", "k3", "5,600")
    local NewWaitTime, LimitWaitCD = string.match(LimitSettingStr, "([^;,|]+)[;,|]([^;,|]+)")
    if NewWaitTime ~= nil and LimitWaitCD ~= nil then
      cfg.NewWaitTime = toInt(NewWaitTime)
      cfg.LimitWaitCD = toInt(LimitWaitCD) * 1000
    else
      cfg.NewWaitTime = cfg.MaxWaitTime * 2
      cfg.LimitWaitCD = 600000
    end
    _ConfigData = cfg
  end
end

local function SendRequestMessage(sequence, formationUuid, targetType, targetUuid, targetServerId, theSoldierType, UseLightWorkerMan)
  local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(formationUuid)
  if formation == nil then
    return
  end
  local curSoldiers = formation.soldiers or {}
  local sfsObj = SFSObject.New()
  sfsObj:PutLong("uuid", formationUuid)
  local armyArray = SFSArray.New()
  for posIndex, tab in pairs(curSoldiers) do
    if not table.IsNullOrEmpty(tab) then
      local soldierIdNumArr = SFSArray.New()
      for soldierId, soldierNum in pairs(tab) do
        if type(soldierId) == "number" then
          local obj = SFSObject.New()
          obj:PutInt("soldierId", soldierId)
          obj:PutInt("soldierNum", soldierNum)
          soldierIdNumArr:AddSFSObject(obj)
        end
      end
      local army = SFSObject.New()
      army:PutInt("posIndex", posIndex)
      army:PutSFSArray("soldierIdNumArr", soldierIdNumArr)
      armyArray:AddSFSObject(army)
    end
  end
  sfsObj:PutSFSArray("formations", armyArray)
  local heroInfo = formation:GenerateServerHeroArray()
  sfsObj:PutSFSArray("heroInfos", heroInfo)
  local extraParam = SFSObject.New()
  if UseLightWorkerMan then
    extraParam:PutBool("userPowerWorker", true)
  end
  local cardSkillUseInfoList = DataCenter.TacticalCardDataManager:PopFormationViewCardSkillUseCache()
  if cardSkillUseInfoList and 0 < #cardSkillUseInfoList then
    local cardSkills = SFSArray.New()
    for i, v in ipairs(cardSkillUseInfoList) do
      local obj = SFSObject.New()
      obj:PutLong("cardUuid", v.cardUuid)
      obj:PutInt("cardSkillId", v.cardSkillId)
      cardSkills:AddSFSObject(obj)
    end
    extraParam:PutSFSArray("cardSkills", cardSkills)
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local soldierType = theSoldierType or SoldierType.Player
  local msg = MsgDefines.FetchFormationSimulatedBattleResult
  SFSNetwork.SendMessage(msg, sequence, formationUuid, soldierType, targetType, targetUuid, targetServerId, sfsObj, extraParam)
  if local_debug_log ~= nil then
    local_debug_log("world.march.simulate.SimulatedBattle.SendMessage sequence = ", sequence)
  end
  if _RecordData.lastSendTime then
    local cfg = _ConfigData
    if cfg and cfg.MaxTime and now > cfg.MaxTime + _RecordData.lastSendTime then
      _RecordData.data = {}
    end
  end
  _RecordData.lastSendTime = now
  _RecordData.lastSequence = sequence
end

function FormationSimulatedBattleV2:OnCreate()
  base.OnCreate(self)
  self.root = self:AddComponent(UICanvasGroup, root_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.loading = self:AddComponent(UIImage, loading_path)
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.icon_refresh = self:AddComponent(UIButton, icon_refresh_path)
  self:SetAsLastSibling()
  self.icon:SetAlpha(0)
  self.loading:SetActive(true)
  self.icon_refresh:SetActive(false)
  self.icon_refresh:SetOnClick(function()
    self:TrySimulated()
  end)
end

function FormationSimulatedBattleV2:OnDestroy()
  _RecordData.pThis = nil
  self.timerEnable = false
  self.delayTime = nil
  self.root = nil
  self.icon = nil
  self.loading = nil
  self.text = nil
  self.icon_refresh = nil
  base.OnDestroy(self)
end

function FormationSimulatedBattleV2:UpdateData()
  InitConfig()
  self.cursor = _RecordData.lastSequence or 0
  self.MaxWaitTime = _ConfigData.MaxWaitTime
  if _RecordData.lockEndTime ~= nil and UITimeManager:GetInstance():GetServerTime() < _RecordData.lockEndTime then
    self.MaxWaitTime = _ConfigData.NewWaitTime
    self.lockEndTime = _RecordData.lockEndTime
  end
end

function FormationSimulatedBattleV2:UpdateTimer(timerEnable)
  if self.timerEnable ~= timerEnable then
    if self.timerEnable == nil and timerEnable == true then
      self:UpdateData()
    end
    self.timerEnable = timerEnable
  end
  _RecordData.pThis = self
end

function FormationSimulatedBattleV2:OnLightWorkerManValueChanged(UseLightWorkerMan)
  if self.UseLightWorkerMan ~= UseLightWorkerMan then
    self.UseLightWorkerMan = UseLightWorkerMan
    self.cursor = self.cursor + 1
    self.delayTime = 0
  end
end

function FormationSimulatedBattleV2:RefreshData(soldierType, formationUuid, targetType, targetUuid, targetServerId)
  local dirty = false
  if self.soldierType ~= soldierType then
    self.soldierType = soldierType or SoldierType.Player
    dirty = true
  end
  if self.formationUuid ~= formationUuid then
    self.formationUuid = formationUuid
    dirty = true
  end
  if self.targetType ~= targetType then
    self.targetType = targetType
    dirty = true
  end
  if self.targetUuid ~= targetUuid then
    self.targetUuid = targetUuid
    dirty = true
  end
  if self.targetServerId ~= targetServerId then
    self.targetServerId = targetServerId
    dirty = true
  end
  if dirty then
    self:TrySimulated()
  end
  local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, formationUuid, LuaEntry.Player.allianceId)
  if march ~= nil and march.fixedSoldierType == SoldierType.Mummy then
    self.timerEnable = false
    self:SetActive(false)
    return
  end
  self:SetActive(true)
end

function FormationSimulatedBattleV2:TrySimulated()
  if self.loading == nil then
    return
  end
  local msg = Localization:GetString("sim_battle_ui_6_limit_15")
  self.delayTime = 0
  self.cursor = self.cursor + 1
  self.icon:SetAlpha(0)
  self.loading:SetActive(true)
  self.icon_refresh:SetActive(false)
  self.text:SetText("<color=#8d8b8b>" .. msg .. "</color>")
  self.waitResult = true
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.text.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.root.transform)
  if local_debug_log ~= nil then
    local_debug_log("world.march.simulate.SimulatedBattle.TrySimulated sequence = ", self.cursor, "delayTime = ", self.delayTime)
  end
end

function FormationSimulatedBattleV2.OnResponseMessage(msg)
  local pThis = _RecordData.pThis
  local sequence = msg.sequence
  if sequence ~= nil then
    if _RecordData == nil then
      _RecordData = {}
    end
    if _RecordData.data == nil then
      _RecordData.data = {}
    end
    local now = UITimeManager:GetInstance():GetServerTime()
    local cfg = _ConfigData
    if cfg then
      if _RecordData.lockEndTime == nil or now < _RecordData.lockEndTime then
        table.insert(_RecordData.data, {sequence = sequence, now = now})
        local MaxTime = cfg.MaxTime
        local MaxCount = cfg.MaxCount
        local lastTime = now - MaxTime
        local totalCount = #_RecordData.data
        for index, data in ipairs(_RecordData.data) do
          if lastTime <= data.now then
            if MaxCount <= totalCount - index + 1 then
              _RecordData.data = {}
              _RecordData.lockEndTime = now + cfg.LimitWaitCD
              if pThis then
                pThis.MaxWaitTime = cfg.NewWaitTime
                pThis.lockEndTime = _RecordData.lockEndTime
              end
              Logger.LogInfo(string.format("SimulatedBattle \232\191\155\229\133\165\233\153\144\233\162\145\230\168\161\229\188\143 : %s, %s, %s", totalCount, MaxCount, lastTime))
              break
            end
            _RecordData.data = {
              table.unpack(_RecordData.data, index, totalCount)
            }
            break
          end
        end
      elseif local_debug_log ~= nil then
        local_debug_log("SimulatedBattle \232\191\152\229\156\168\233\153\144\233\162\145\230\168\161\229\188\143\228\184\173")
      end
    end
  else
    if pThis ~= nil then
      pThis:OnResponse(msg)
    end
    return
  end
  if local_debug_log ~= nil and pThis ~= nil then
    local_debug_log("world.march.simulate.SimulatedBattle.OnResponse pThis.sequence = ", pThis.cursor, " sequence = ", sequence)
  end
  if pThis == nil or sequence ~= pThis.cursor then
    if local_debug_log ~= nil then
      local_debug_log("world.march.simulate.SimulatedBattle.OnResponse sequence.err")
    end
    return
  end
  pThis:OnResponse(msg)
end

function FormationSimulatedBattleV2:OnResponse(msg)
  if self.icon and self.loading and msg then
    local lossRate = tonumber(msg.lossRate) or 1
    local tips
    local tipsColor = "#8d8b8b"
    if msg.win ~= true then
      tipsColor = "#f53c3d"
      tips = Localization:GetString("sim_battle_ui_5_limit_10")
      self.icon:LoadSpriteAsync("Assets/Main/SeasonRes/Shared/Sprites/LWCommon/BattleSimulated/v40.png")
    elseif lossRate < 0.3 then
      tipsColor = "#099b4a"
      tips = Localization:GetString("sim_battle_ui_2_limit_10")
      self.icon:LoadSpriteAsync("Assets/Main/SeasonRes/Shared/Sprites/LWCommon/BattleSimulated/v10.png")
    elseif 0.3 <= lossRate and lossRate < 0.6 then
      tipsColor = "#fc9a00"
      tips = Localization:GetString("sim_battle_ui_3_limit_10")
      self.icon:LoadSpriteAsync("Assets/Main/SeasonRes/Shared/Sprites/LWCommon/BattleSimulated/v20.png")
    elseif 0.6 <= lossRate and lossRate < 0.9 then
      tipsColor = "#fc9a00"
      tips = Localization:GetString("sim_battle_ui_4_limit_10")
      self.icon:LoadSpriteAsync("Assets/Main/SeasonRes/Shared/Sprites/LWCommon/BattleSimulated/v30.png")
    else
      tipsColor = "#f53c3d"
      tips = Localization:GetString("sim_battle_ui_5_limit_10")
      self.icon:LoadSpriteAsync("Assets/Main/SeasonRes/Shared/Sprites/LWCommon/BattleSimulated/v40.png")
    end
    if local_debug_log ~= nil then
      local_debug_log("world.march.simulate.SimulatedBattle.OnResponse", tips)
    end
    self.icon:SetAlpha(1)
    self.loading:SetActive(false)
    self.icon_refresh:SetActive(false)
    if tips and tipsColor then
      self.text:SetText("<color=" .. tipsColor .. ">" .. tips .. "</color>")
    end
    self.waitResult = false
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.text.transform)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.root.transform)
  end
end

function FormationSimulatedBattleV2:Update100MS()
  if _RecordData.pThis == self and self.timerEnable == true and self.delayTime ~= nil and self.MaxWaitTime ~= nil then
    self.delayTime = self.delayTime + 0.1
    if self.cursor == _RecordData.lastSequence and self.waitResult then
      if self.delayTime >= self.MaxWaitTime * 2 then
        if local_debug_log ~= nil then
          local_debug_log("world.march.simulate.SimulatedBattle.\232\175\183\230\177\130\232\182\133\230\151\182 delayTime = ", self.delayTime)
        end
        local tips = Localization:GetString("sim_battle_ui_7_limit_10")
        self.delayTime = nil
        self.icon:LoadSpriteAsync("Assets/Main/SeasonRes/Shared/Sprites/LWCommon/BattleSimulated/v40.png")
        self.icon:SetAlpha(1)
        self.loading:SetActive(false)
        self.icon_refresh:SetActive(true)
        self.text:SetText("<color=#8d8b8b>" .. tips .. "</color>")
        self.waitResult = false
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.text.transform)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.root.transform)
      end
    elseif self.waitResult then
      if self.lockEndTime ~= nil and UITimeManager:GetInstance():GetServerTime() >= self.lockEndTime then
        self.lockEndTime = nil
        self.MaxWaitTime = _ConfigData.MaxWaitTime
        if local_debug_log ~= nil then
          local_debug_log("world.march.simulate.SimulatedBattle.\230\151\182\233\151\180\229\136\176\239\188\140\229\142\187\230\142\137\233\153\144\233\162\145\233\153\144\229\136\182")
        end
      end
      if self.delayTime >= self.MaxWaitTime then
        if local_debug_log ~= nil then
          local_debug_log("world.march.simulate.SimulatedBattle.SendRequestMessage delayTime = ", self.delayTime)
        end
        SendRequestMessage(self.cursor, self.formationUuid, self.targetType, self.targetUuid, self.targetServerId, self.soldierType, self.UseLightWorkerMan)
      end
    end
  end
end

return FormationSimulatedBattleV2
