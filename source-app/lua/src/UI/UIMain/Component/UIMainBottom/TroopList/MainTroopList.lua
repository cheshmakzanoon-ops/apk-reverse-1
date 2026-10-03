local RewardUtil = require("Util.RewardUtil")
local UIMarchQueueFormationListCell = require("UI.UIMain.Component.UIMainBottom.TroopList.UIMarchQueueFormationListCell")
local FormationScoutSelectList = require("UI.UIMain.Component.UIMainBottom.TroopList.UIMainFormationScoutSelectList")
local MainUIVoiceRoomComponent = require("UI.UIChatVoice.Component.MainUIVoiceRoomComponent")
local LIST_HEAD_HEIGHT = 60
local MainTroopList = BaseClass("MainTroopList", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local RectTransform = typeof(CS.UnityEngine.RectTransform)
local content_path = "MarchQueueContent/troopList/Mask/Content1"
local content_path2 = "DetectQueueContent/troopList/Mask/Content2"
local formation_army_tip_path = "FormationArmyTip"
local create_army_tip_path = "CreateArmyTip"
local formationScoutSelectList_path = "DetectQueueContent/troopList"
local march_queue_content_path = "MarchQueueContent"
local detect_queue_content_path = "DetectQueueContent"
local voice_room_prefab_path = "Assets/Main/Prefabs/UI/ChatVoice/MainUI_BFVoiceRoom.prefab"
local voice_chat_content_name = "VoiceChatContent"

local function TryShowBFVoiceRoomByChatRooms(self)
  local chatMgr = ChatManager2:GetInstance()
  local roomMgr = chatMgr and chatMgr.Room or nil
  if not roomMgr or not roomMgr.GetRoomDatas then
    return
  end
  local roomDatas = roomMgr:GetRoomDatas()
  if type(roomDatas) ~= "table" then
    return
  end
  for _, roomData in pairs(roomDatas) do
    local hasVoiceRoomFeature = roomData and roomData.HasVoiceRoomFeature and roomData:HasVoiceRoomFeature() or false
    if hasVoiceRoomFeature then
      self:ShowBFVoiceRoom()
      return
    end
  end
end

local function OnCreate(self)
  base.OnCreate(self)
  self.view.ctrl:InitData()
  self.curFormationType = self.view.ctrl.formationType
  self.isVoiceRoomVisible = false
  self.voiceRoomReq = nil
  self.voice_room_content = nil
  self.march_list_content = self:AddComponent(UIBaseContainer, content_path)
  self.detect_list_content = self:AddComponent(UIBaseContainer, content_path2)
  self.uIMainFormationScoutSelectList = self:AddComponent(FormationScoutSelectList, formationScoutSelectList_path)
  
  function self.timer_action(temp)
    self:RefreshFormationStamina()
  end
  
  self.FormationTimeList = {}
  self.marchFormationList = {}
  self.FormationPowerList = {}
  self.dragInstance = nil
  self.march_queue_content = self:AddComponent(UIBaseContainer, march_queue_content_path)
  self.detect_queue_content = self:AddComponent(UIBaseContainer, detect_queue_content_path)
  self.voice_chat_content = self:AddComponent(UIBaseContainer, voice_chat_content_name)
  self:DataDefine()
  TryShowBFVoiceRoomByChatRooms(self)
end

local function GetVoiceChatTargetY(self)
  local targetY = 0
  if self.isMarchListActive then
    targetY = targetY - LIST_HEAD_HEIGHT
  end
  if self.isMarchListOpen and self.march_list_content and self.march_list_content.rectTransform then
    local marchHeight = self.march_list_content.rectTransform.rect.height
    targetY = targetY - marchHeight
  end
  if self.isDetectListActive then
    targetY = targetY - LIST_HEAD_HEIGHT
  end
  if self.isDetectListOpen and self.detect_list_content and self.detect_list_content.rectTransform then
    local detectHeight = self.detect_list_content.rectTransform.rect.height
    targetY = targetY - detectHeight
  end
  return targetY
end

local function RefreshVoiceChatContentPosition(self, useTween)
  if not self.voice_chat_content or not self.voice_chat_content.transform then
    return
  end
  local targetY = GetVoiceChatTargetY(self)
  local voiceTransform = self.voice_chat_content.transform
  local curPos = voiceTransform.localPosition
  if useTween then
    voiceTransform:DOKill()
    voiceTransform:DOLocalMoveY(targetY, 0.5)
  else
    voiceTransform.localPosition = Vector3.New(curPos.x, targetY, 0)
  end
end

local function UnloadVoiceChatContent(self)
  if self.voice_room_content then
    self:RemoveComponents(MainUIVoiceRoomComponent)
    self.voice_room_content = nil
  end
  if self.voiceRoomReq ~= nil then
    self.voiceRoomReq:Destroy()
    self.voiceRoomReq = nil
  end
end

local function ShowBFVoiceRoom(self)
  self.isVoiceRoomVisible = true
  if self.voice_room_content then
    self.voice_room_content:SetActive(true)
    RefreshVoiceChatContentPosition(self, false)
    return
  end
  if self.voiceRoomReq ~= nil then
    return
  end
  local request = ResourceManager:InstantiateAsync(voice_room_prefab_path)
  self.voiceRoomReq = request
  request:completed("+", function(req)
    if self.voiceRoomReq ~= req then
      return
    end
    local go = req.gameObject
    if IsNull(go) then
      UnloadVoiceChatContent(self)
      return
    end
    local tf = go.transform
    local roomRectTf = tf:GetComponent(RectTransform)
    local voiceChatNode = self.transform:Find(voice_chat_content_name)
    if IsNull(voiceChatNode) then
      UnloadVoiceChatContent(self)
      return
    end
    local anchorNode = voiceChatNode:Find("Anchor")
    if IsNull(anchorNode) then
      UnloadVoiceChatContent(self)
      return
    end
    tf:SetParent(anchorNode, false)
    roomRectTf.anchoredPosition3D = Vector3.New(0, 64, 0)
    roomRectTf.localScale = Vector3.one
    local voiceRoomPath = string.format("%s/Anchor/%s", voice_chat_content_name, go.name)
    self.voice_room_content = self:AddComponent(MainUIVoiceRoomComponent, voiceRoomPath)
    if not self.isVoiceRoomVisible then
      UnloadVoiceChatContent(self)
      return
    end
    self.voice_room_content:RefreshTargetVoiceRoomInfo()
    RefreshVoiceChatContentPosition(self, false)
  end)
end

local function HideBFVoiceRoom(self)
  self.isVoiceRoomVisible = false
  UnloadVoiceChatContent(self)
end

local function OnDestroy(self)
  self:HideBFVoiceRoom()
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  self.title = nil
  self.march_list_content = nil
  self.detect_list_content = nil
  self.march_queue_content = nil
  self.detect_queue_content = nil
  self.isVoiceRoomVisible = nil
  self.voice_chat_content = nil
  self.voice_room_content = nil
  if self.voiceRoomReq ~= nil then
    self.voiceRoomReq:Destroy()
    self.voiceRoomReq = nil
  end
  self.return_btn = nil
  self.marchFormationList = nil
  self.uIMainFormationScoutSelectList = nil
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:OnRefresh(nil, true)
  self:AddTimer()
  local voiceMgr = ChatManager2:GetInstance().Voice
  local hasCanJoinRoom = voiceMgr:HasVoiceRoom()
  if self.isVoiceRoomVisible then
    if not hasCanJoinRoom then
      self:HideBFVoiceRoom()
    end
  elseif hasCanJoinRoom then
    self:ShowBFVoiceRoom()
  end
end

local function OnDisable(self)
  self:DeleteTimer()
  if self.troopActionTimer ~= nil then
    self.troopActionTimer:Stop()
    self.troopActionTimer = nil
  end
  base.OnDisable(self)
end

local function DataDefine(self)
  self.isMarchListActive = DataCenter.WorldMarchDataManager:IsHaveMarchInWorld() or RewardUtil.IsHaveWorldReward()
  self.isDetectListActive = self.view.ctrl:IsExistMarchInvesFormation()
  self.isDetectListOpen = false
  self.isMarchListOpen = self.isMarchListActive
end

local function DataDestroy(self)
  self.isMarchListOpen = nil
  self.isDetectListOpen = nil
  self.isDetectListActive = nil
  self.isMarchListActive = nil
end

local function SetFormationType(self, formationType)
  self.curFormationType = formationType
end

local function ClearContent(self)
  self.march_list_content:RemoveComponents(UIMarchQueueFormationListCell)
  if self.marchModel ~= nil then
    for k, v in pairs(self.marchModel) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.marchModel = {}
  self.marchFormationList = {}
end

local function GetMarchingCountByMarchData(self)
  local data = self.view.ctrl:GetFormationListData()
  local curMarchNum = 0
  for k, v in pairs(data.list) do
    local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, v, LuaEntry.Player.allianceId)
    if march then
      curMarchNum = curMarchNum + 1
    end
  end
  for _, _ in pairs(DataCenter.WorldMarchDataManager:GetMyDisguiseMarches()) do
    curMarchNum = curMarchNum + 1
  end
  return curMarchNum
end

local function OnRefresh(self, show, isInit)
  local inCity = SceneUtils.GetIsInCity()
  if inCity then
    return
  end
  self:ClearContent()
  local data = self.view.ctrl:GetFormationListData()
  if data ~= nil then
    local list = data.list
    if list ~= nil then
      self.curMarchNum = self:GetMarchingCountByMarchData()
      for i = 1, data.maxNum do
        if list[i] then
          local marchInfo = self.view.ctrl:GetFormationItemData(list[i])
          if marchInfo.isMarch > 0 then
            self.marchModel[#self.marchModel + 1] = self:GameObjectInstantiateAsync(UIAssets.UIMainFormationSelectListCellNew, function(request)
              if request.isError then
                return
              end
              local go = request.gameObject
              go.gameObject:SetActive(true)
              go.transform:SetParent(self.march_list_content.transform)
              go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
              local nameStr = tostring(NameCount)
              go.name = nameStr
              NameCount = NameCount + 1
              local cell = self.march_list_content:AddComponent(UIMarchQueueFormationListCell, nameStr)
              cell:SetUuidAndIndex(i, list[i])
              cell:RefreshData(show)
              self.marchFormationList[#self.marchFormationList + 1] = cell
              if #self.marchFormationList >= #self.marchModel then
                self:OnListComplete(isInit)
              end
            end)
          end
        end
      end
      do
        local myDisguiseMarches = DataCenter.WorldMarchDataManager:GetMyDisguiseMarches()
        for _, v in pairs(myDisguiseMarches) do
          self.marchModel[#self.marchModel + 1] = self:GameObjectInstantiateAsync(UIAssets.UIMainFormationSelectListCellNew, function(request)
            if request.isError then
              return
            end
            local go = request.gameObject
            go.gameObject:SetActive(true)
            go.transform:SetParent(self.march_list_content.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            local nameStr = tostring(NameCount)
            go.name = nameStr
            NameCount = NameCount + 1
            local cell = self.march_list_content:AddComponent(UIMarchQueueFormationListCell, nameStr)
            cell:SetDisguiseMarchUuidAndIndex(v.uuid, #self.marchFormationList + 1)
            cell:RefreshData(show)
            self.marchFormationList[#self.marchFormationList + 1] = cell
            if #self.marchFormationList >= #self.marchModel then
              self:OnListComplete(isInit)
            end
          end)
        end
        local isOpen = DataCenter.MonthCardNewManager:CheckIfMonthCardActive()
        if #list < data.maxNum and not isOpen then
          self.marchModel[#self.marchModel + 1] = self:GameObjectInstantiateAsync(UIAssets.UIMainFormationSelectListCellNew, function(request)
            if request.isError then
              return
            end
            local go = request.gameObject
            go.gameObject:SetActive(true)
            go.transform:SetParent(self.march_list_content.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            local nameStr = tostring(NameCount)
            go.name = nameStr
            NameCount = NameCount + 1
            local cell = self.march_list_content:AddComponent(UIMarchQueueFormationListCell, nameStr)
            cell:SetUuidAndIndex(#self.marchFormationList + 1)
            cell:RefreshData(show)
            self.marchFormationList[#self.marchFormationList + 1] = cell
            if #self.marchFormationList >= #self.marchModel then
              self:OnListComplete(isInit)
            end
          end)
        end
        if table.IsNullOrEmpty(self.marchModel) then
          self:OnListComplete(isInit)
        end
      end
    end
  end
  self.uIMainFormationScoutSelectList:InitUI()
end

local function OnListComplete(self, isInit)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.march_list_content.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.detect_list_content.transform)
  local height = self.march_list_content.rectTransform.rect.height
  self.isMarchListActive = DataCenter.WorldMarchDataManager:IsHaveMarchInWorld() or RewardUtil.IsHaveWorldReward()
  local headOffset = self.isMarchListActive and -height - LIST_HEAD_HEIGHT or -height
  self.detect_queue_content.transform.localPosition = Vector3.New(self.detect_queue_content.transform.localPosition.x, headOffset, 0)
  RefreshVoiceChatContentPosition(self, false, headOffset)
  self:RefreshListState()
end

local function OnMarchItemUpdateSelf(self)
  local curMarchNum = self:GetMarchingCountByMarchData()
  if self.curMarchNum == curMarchNum then
    if self.marchFormationList ~= nil then
      table.walk(self.marchFormationList, function(k, v)
        v:RefreshMarchData()
      end)
    end
    self:RefreshListState()
  else
    self:OnRefresh()
  end
end

local function OnMarchRefresh(self)
  local curMarchNum = self:GetMarchingCountByMarchData()
  if self.curMarchNum == curMarchNum then
    if self.marchFormationList ~= nil then
      table.walk(self.marchFormationList, function(k, v)
        v:RefreshMarchData()
      end)
    end
    self:RefreshListState()
  else
    self:OnRefresh()
  end
end

local function OnFormationRefresh(self)
  if CS.SceneManager.IsInPVE() then
    return
  end
  local list = {}
  local data = self.view.ctrl:GetFormationListData()
  if data ~= nil then
    list = data.list
  end
  if self.marchFormationList ~= nil then
    table.walk(self.marchFormationList, function(k, v)
      v:RefreshData()
    end)
  end
end

local function OnSelectClick(self, uuid)
  table.walk(self.marchFormationList, function(k, v)
    v:OnSelectClick(uuid)
  end)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.MarchItemUpdateSelf, self.OnMarchItemUpdateSelf)
  self:AddUIListener(EventId.FormationSoldierUpdate, self.OnMarchRefresh)
  self:AddUIListener(EventId.ArmyFormatUpdate, self.OnFormationRefresh)
  self:AddUIListener(EventId.ShowTroopBattleValue, self.ShowTroopBattleSignal)
  self:AddUIListener(EventId.ArmyFormationSave, self.OnFormationRefresh)
  self:AddUIListener(EventId.HideMarchTip, self.OnResetMarchTip)
  self:AddUIListener(EventId.TrainArmyData, self.OnFormationRefresh)
  self:AddUIListener(EventId.HeroLvUpSuccess, self.OnFormationRefresh)
  self:AddUIListener(EventId.ShowFormationSelect, self.ShowFormationSelect)
  self:AddUIListener(EventId.HideFormationSelect, self.HideFormationSelect)
  self:AddUIListener(EventId.ShowTroopAction, self.ShowTroopAction)
  self:AddUIListener(EventId.FormationStaminaUpdate, self.RefreshFormationStamina)
  self:AddUIListener(EventId.RefreshMonsterRewardBag, self.OnRefreshMonsterRewardBag)
  self:AddUIListener(EventId.MarchItemTargetMeUpdate, self.OnMarchItemTargetMeUpdate)
  self:AddUIListener(EventId.DetectResultDataUpdate, self.OnRefreshDetectData)
  self:AddUIListener(EventId.BankReportDataUpdate, self.OnRefreshDetectData)
  self:AddUIListener(EventId.ShowBFVoiceRoom, self.ShowBFVoiceRoom)
  self:AddUIListener(EventId.HideBFVoiceRoom, self.HideBFVoiceRoom)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ShowTroopAction, self.ShowTroopAction)
  self:RemoveUIListener(EventId.MarchItemUpdateSelf, self.OnMarchItemUpdateSelf)
  self:RemoveUIListener(EventId.FormationSoldierUpdate, self.OnMarchRefresh)
  self:RemoveUIListener(EventId.ArmyFormatUpdate, self.OnFormationRefresh)
  self:RemoveUIListener(EventId.ShowTroopBattleValue, self.ShowTroopBattleSignal)
  self:RemoveUIListener(EventId.ArmyFormationSave, self.OnFormationRefresh)
  self:RemoveUIListener(EventId.HideMarchTip, self.OnResetMarchTip)
  self:RemoveUIListener(EventId.TrainArmyData, self.OnFormationRefresh)
  self:RemoveUIListener(EventId.HeroLvUpSuccess, self.OnFormationRefresh)
  self:RemoveUIListener(EventId.ShowFormationSelect, self.ShowFormationSelect)
  self:RemoveUIListener(EventId.HideFormationSelect, self.HideFormationSelect)
  self:RemoveUIListener(EventId.FormationStaminaUpdate, self.RefreshFormationStamina)
  self:RemoveUIListener(EventId.RefreshMonsterRewardBag, self.OnRefreshMonsterRewardBag)
  self:RemoveUIListener(EventId.DetectResultDataUpdate, self.OnRefreshDetectData)
  self:RemoveUIListener(EventId.BankReportDataUpdate, self.OnRefreshDetectData)
  self:RemoveUIListener(EventId.MarchItemTargetMeUpdate, self.OnMarchItemTargetMeUpdate)
  self:RemoveUIListener(EventId.ShowBFVoiceRoom, self.ShowBFVoiceRoom)
  self:RemoveUIListener(EventId.HideBFVoiceRoom, self.HideBFVoiceRoom)
end

local function ShowFormationArmyTip(self, posX, posY, formationData)
end

local function HideAllShowTip(self)
end

local function OnResetMarchTip(self)
  self.view.ctrl:SetSelectFormationUuid(0)
  self:HideAllShowTip()
end

local function ShowTroopBattleSignal(self, data)
  local str = data
  if str ~= nil then
    local strArr = string.split(str, ";")
    if 3 < #strArr then
      local marchUuid = tonumber(strArr[1])
      local hp = tonumber(strArr[3])
      local hpMax = tonumber(strArr[4])
      if self.marchFormationList ~= nil then
        table.walk(self.marchFormationList, function(k, v)
          v:RefreshSlider(marchUuid, hp, hpMax)
        end)
      end
    end
  end
end

local function ShowFormationSelect(self, data)
  local marchUuid = tonumber(data)
  local info = DataCenter.WorldMarchDataManager:GetMarch(marchUuid)
  if info ~= nil then
    local formationUuid = info.ownerFormationUuid
    self.view.ctrl:SetSelectFormationUuid(formationUuid)
    table.walk(self.marchFormationList, function(k, v)
      v:OnSelectClick(formationUuid)
    end)
  end
end

local function HideFormationSelect(self, data)
  local marchUuid = tonumber(data)
  local info = DataCenter.WorldMarchDataManager:GetMarch(marchUuid)
  if info ~= nil then
    local formationUuid = info.ownerFormationUuid
    if self.view.ctrl.selectFormationUuid == 0 or self.view.ctrl.selectFormationUuid == formationUuid then
      self.view.ctrl:SetSelectFormationUuid(0)
      self:HideAllShowTip()
      table.walk(self.marchFormationList, function(k, v)
        v:OnSelectClick(0)
      end)
    end
  end
end

local function ShowFormationCreateTip(self, posX, posY, formationData)
end

local function ShowFormationRallyTip(self, posX, posY, formationData)
end

local function GetTimeInFormation(self, formationUuid)
  return self.view.ctrl:GetTimeFormCurPosToTarPos(formationUuid)
end

local function OnAtkClick(self, uuid)
  if CS.SceneManager:IsInCity() then
  else
  end
end

local function OnEditClick(self, uuid, needAutoFix)
  if CS.SceneManager:IsInCity() then
    self.view.ctrl:OnCreateMarchInGuide(uuid, needAutoFix)
  else
    self.view.ctrl:OnEditClick(uuid, needAutoFix)
  end
end

local function OnCreateClick(self, uuid)
  if CS.SceneManager:IsInCity() then
  else
  end
end

local function OnClickScoutTroopItem(self, tempIndex)
  if self.uIMainFormationScoutSelectList then
    return self.uIMainFormationScoutSelectList:OnSelectTroopBtnClick(tempIndex)
  end
end

local function GetScoutTroopUnlockLv(self, formationIndex)
  if self.uIMainFormationScoutSelectList then
    return self.uIMainFormationScoutSelectList:GetUnlockLv(formationIndex)
  end
end

local function ResetScoutSelectTipPosition(self, posX, posY)
  if self.uIMainFormationScoutSelectList then
    return self.uIMainFormationScoutSelectList:ResetTipPosition(posX, posY)
  end
end

local function GetInvesFormationStateDes(self)
  if self.uIMainFormationScoutSelectList then
    return self.uIMainFormationScoutSelectList:GetInvesFormationStateDes()
  end
end

local function GetInvesCostTime(self, targetPointID)
  if self.uIMainFormationScoutSelectList then
    return self.uIMainFormationScoutSelectList:GetInvesCostTime(targetPointID)
  end
end

local function OnClickStartInvestigate(self)
  if self.uIMainFormationScoutSelectList then
    return self.uIMainFormationScoutSelectList:OnClickStartInvestigate()
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
  if self.marchFormationList ~= nil then
    table.walk(self.marchFormationList, function(k, v)
      v:UpdateTime()
    end)
  end
  if self.uIMainFormationScoutSelectList then
    self.uIMainFormationScoutSelectList:RefreshTime()
  end
end

local function ShowTroopAction(self)
end

local function OnRefreshMonsterRewardBag(self)
  self:RefreshListState()
end

local function OnRefreshDetectData(self)
  self:RefreshListState()
end

local function RefreshListState(self)
  if BattleFieldUtil.InBattleField() then
    self.isMarchListActive = true
    self.isMarchListOpen = true
    self.isDetectListActive = true
    self.isDetectListOpen = true
  else
    self.isMarchListActive = DataCenter.WorldMarchDataManager:IsHaveMarchInWorld() or RewardUtil.IsHaveWorldReward()
    self.isMarchListOpen = self.isMarchListActive
    self.isDetectListActive = self.view.ctrl:IsExistMarchInvesFormation() or not DataCenter.DetectResultDataManager:IsDataEmpty() or not DataCenter.SeasonBankReportManager:IsDataEmpty()
  end
  EventManager:GetInstance():Broadcast(EventId.MarchBtnStateChange, self.isMarchListOpen)
  EventManager:GetInstance():Broadcast(EventId.DetectBtnStateChange, self.isDetectListActive)
  if self.isDetectListActive == false then
    self.isDetectListOpen = false
  end
  self.delayTimer = TimerManager:GetInstance():DelayFrameInvoke(function()
    if self.march_list_content then
      if self.isMarchListOpen then
        self:ShowMarchItemList()
      else
        self:HideMarchItemList()
      end
      if self.isDetectListOpen then
        self:ShowDetectItemList()
      else
        self:HideDetectItemList()
      end
    end
  end, 5)
end

local function ShowMarchItemList(self)
  local height = self.march_list_content.rectTransform.rect.height
  self.march_list_content.transform:DOKill()
  self.march_list_content.transform:DOLocalMoveY(0, 0.5)
  local detectTargetY = -height - LIST_HEAD_HEIGHT
  self.detect_queue_content.transform:DOKill()
  self.detect_queue_content.transform:DOLocalMoveY(detectTargetY, 0.5)
  self.isMarchListOpen = true
  RefreshVoiceChatContentPosition(self, true, detectTargetY)
end

local function ShowDetectItemList(self)
  self.detect_list_content.transform:DOKill()
  self.detect_list_content.transform:DOLocalMoveY(0, 0.5)
  self.isDetectListOpen = true
  RefreshVoiceChatContentPosition(self, true)
end

local function HideMarchItemList(self)
  if not self.march_list_content then
    return
  end
  local height = self.march_list_content.rectTransform.rect.height
  self.march_list_content.transform:DOKill()
  self.march_list_content.transform:DOLocalMoveY(height, 0.5)
  self.detect_queue_content.transform:DOKill()
  local headOffset = self.isMarchListActive and -LIST_HEAD_HEIGHT or 0
  self.detect_queue_content.transform:DOLocalMoveY(headOffset, 0.5)
  self.isMarchListOpen = false
  RefreshVoiceChatContentPosition(self, true, headOffset)
end

function MainTroopList:OnMarchItemTargetMeUpdate()
  if not DataCenter.ActMeteoriteBattleManager:IsInMeteoriteBattle() then
    return
  end
  if self.marchFormationList ~= nil then
    table.walk(self.marchFormationList, function(k, v)
      v:RefreshMeteoriteUnderAttackAlarm()
    end)
  end
end

local function HideDetectItemList(self)
  local height = self.detect_list_content.rectTransform.rect.height
  self.detect_list_content.transform:DOKill()
  self.detect_list_content.transform:DOLocalMoveY(height, 0.5)
  self.isDetectListOpen = false
  RefreshVoiceChatContentPosition(self, true)
end

MainTroopList.OnCreate = OnCreate
MainTroopList.OnDestroy = OnDestroy
MainTroopList.OnRefresh = OnRefresh
MainTroopList.OnEnable = OnEnable
MainTroopList.OnDisable = OnDisable
MainTroopList.OnAddListener = OnAddListener
MainTroopList.OnRemoveListener = OnRemoveListener
MainTroopList.OnMarchRefresh = OnMarchRefresh
MainTroopList.OnMarchItemUpdateSelf = OnMarchItemUpdateSelf
MainTroopList.ShowFormationArmyTip = ShowFormationArmyTip
MainTroopList.ShowFormationRallyTip = ShowFormationRallyTip
MainTroopList.ShowFormationCreateTip = ShowFormationCreateTip
MainTroopList.ClearContent = ClearContent
MainTroopList.GetTimeInFormation = GetTimeInFormation
MainTroopList.OnAtkClick = OnAtkClick
MainTroopList.OnEditClick = OnEditClick
MainTroopList.OnCreateClick = OnCreateClick
MainTroopList.OnSelectClick = OnSelectClick
MainTroopList.ShowTroopBattleSignal = ShowTroopBattleSignal
MainTroopList.HideAllShowTip = HideAllShowTip
MainTroopList.OnClickScoutTroopItem = OnClickScoutTroopItem
MainTroopList.GetScoutTroopUnlockLv = GetScoutTroopUnlockLv
MainTroopList.ResetScoutSelectTipPosition = ResetScoutSelectTipPosition
MainTroopList.GetInvesFormationStateDes = GetInvesFormationStateDes
MainTroopList.GetInvesCostTime = GetInvesCostTime
MainTroopList.OnClickStartInvestigate = OnClickStartInvestigate
MainTroopList.SetFormationType = SetFormationType
MainTroopList.OnResetMarchTip = OnResetMarchTip
MainTroopList.ShowFormationSelect = ShowFormationSelect
MainTroopList.HideFormationSelect = HideFormationSelect
MainTroopList.OnFormationRefresh = OnFormationRefresh
MainTroopList.AddTimer = AddTimer
MainTroopList.DeleteTimer = DeleteTimer
MainTroopList.RefreshFormationStamina = RefreshFormationStamina
MainTroopList.ShowTroopAction = ShowTroopAction
MainTroopList.OnRefreshMonsterRewardBag = OnRefreshMonsterRewardBag
MainTroopList.OnRefreshDetectData = OnRefreshDetectData
MainTroopList.ShowMarchItemList = ShowMarchItemList
MainTroopList.ShowDetectItemList = ShowDetectItemList
MainTroopList.HideMarchItemList = HideMarchItemList
MainTroopList.HideDetectItemList = HideDetectItemList
MainTroopList.ShowBFVoiceRoom = ShowBFVoiceRoom
MainTroopList.HideBFVoiceRoom = HideBFVoiceRoom
MainTroopList.DataDefine = DataDefine
MainTroopList.DataDestroy = DataDestroy
MainTroopList.OnListComplete = OnListComplete
MainTroopList.RefreshListState = RefreshListState
MainTroopList.GetMarchingCountByMarchData = GetMarchingCountByMarchData
return MainTroopList
