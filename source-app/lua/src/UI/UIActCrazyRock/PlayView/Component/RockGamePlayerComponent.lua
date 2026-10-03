local base = UIBaseContainer
local RockGamePlayerComponent = BaseClass("RockGamePlayerComponent", UIBaseContainer)
local AudioSettings = CS.UnityEngine.AudioSettings
local Localization = CS.GameEntry.Localization
local CSInput = CS.UnityEngine.Input
local SingleNoteItemComponent = require("UI.UIActCrazyRock.PlayView.Component.SingleNoteItemComponent")
local ContinueNoteItemComponent = require("UI.UIActCrazyRock.PlayView.Component.ContinueNoteItemComponent")
local CrazyRockHitSaveData = require("DataCenter.ActCrazyRockDataManager.Data.GamePlay.CrazyRockHitSaveData")
local RockGamePlayerGuideLineComponent = require("UI.UIActCrazyRock.PlayView.Component.RockGamePlayerGuideLineComponent")
local item_root_path = "ItemRoot"
local note_root_path = "NoteRoot"
local normal_note_item_path = "ItemRoot/NormalNoteItem"
local continue_note_item_path = "ItemRoot/ContinueNoteItem"
local preview_pos_path = "AudioTrack/PreviewPos"
local cur_pos_path = "AudioTrack/CurPos"
local hit_button_path = "HitButton"
local perfect_eff_path = "AudioTrack/Destination/ScoreEffRoot/PerfectEff"
local good_eff_path = "AudioTrack/Destination/ScoreEffRoot/GoodEff"
local empty_eff_path = "AudioTrack/Destination/ScoreEffRoot/EmptyEff"
local continue_note_finish_eff_path = "AudioTrack/Destination/ContinueNoteFinishEff"
local rock_game_player_guide_line_path = "RockGamePlayerGuideLine"
local EMPTY_HIT_SE_CONFIG_ID = 90101
local NOTE_DISAPPEAR_DELAY_TIME = 50
local noteItemClassMap = {
  [CrazyRockNoteType.SingleClick] = SingleNoteItemComponent,
  [CrazyRockNoteType.Continue] = ContinueNoteItemComponent
}
local NOTE_ITEM_PRELOAD_COUNT_CONFIG = {
  [CrazyRockNoteType.SingleClick] = 5,
  [CrazyRockNoteType.Continue] = 1
}

function RockGamePlayerComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  if not self.fpsLockId then
    self.fpsLockId = CS.DynamicFPSConfig.AcquireHighFPSLocker()
  end
end

function RockGamePlayerComponent:OnDestroy()
  if self.fpsLockId then
    self.fpsLockId = CS.DynamicFPSConfig.FreeHighFPSLocker(self.fpsLockId)
    self.fpsLockId = nil
  end
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function RockGamePlayerComponent:OnEnable()
  base.OnEnable(self)
  self.oriBuffSize = CS.GameEntry.Sound:GetDspBufferSize()
  Logger.LogInfo("cur dspBuffSize:" .. self.oriBuffSize)
  CS.GameEntry.Sound:SetDspBufferSize(512)
  Logger.LogInfo("after set dspBuffSize:" .. CS.GameEntry.Sound:GetDspBufferSize())
end

function RockGamePlayerComponent:OnDisable()
  base.OnDisable(self)
  if self.oriBuffSize then
    CS.GameEntry.Sound:SetDspBufferSize(self.oriBuffSize)
  end
end

function RockGamePlayerComponent:ComponentDefine()
  self.itemRoot = self:AddComponent(UIBaseContainer, item_root_path)
  self.itemRoot:SetActive(false)
  self.noteRoot = self:AddComponent(UIBaseContainer, note_root_path)
  self.normalNoteItem = self:AddComponent(UIBaseContainer, normal_note_item_path)
  self.normalNoteItem.gameObject:GameObjectCreatePool()
  self.continueNoteItem = self:AddComponent(UIBaseContainer, continue_note_item_path)
  self.continueNoteItem.gameObject:GameObjectCreatePool()
  self.noteObjDic = {}
  self.noteObjDic[CrazyRockNoteType.SingleClick] = self.normalNoteItem.gameObject
  self.noteObjDic[CrazyRockNoteType.Continue] = self.continueNoteItem.gameObject
  self.previewPoint = self:AddComponent(UIBaseContainer, preview_pos_path)
  self.curPoint = self:AddComponent(UIBaseContainer, cur_pos_path)
  self.hitBtnAni = self:AddComponent(UISimpleAnimation, hit_button_path)
  self.hitButton = self:AddComponent(UIEventTrigger, hit_button_path)
  self.hitButton:OnPointerDown(function()
    self:OnPointerDown()
  end)
  self.hitButton:OnPointerUp(function()
    self:OnPointerUp()
  end)
  local perfectEff = self:AddComponent(UIBaseContainer, perfect_eff_path)
  local goodEff = self:AddComponent(UIBaseContainer, good_eff_path)
  local emptyEff = self:AddComponent(UIBaseContainer, empty_eff_path)
  perfectEff:SetActive(false)
  goodEff:SetActive(false)
  emptyEff:SetActive(false)
  self.continueNoteFinishEff = self:AddComponent(UIBaseContainer, continue_note_finish_eff_path)
  self.continueNoteFinishEff:SetActive(false)
  self.effDic = {}
  self.effDic[CrazyRockScoreType.Perfect] = perfectEff
  self.effDic[CrazyRockScoreType.Good] = goodEff
  self.effDic[CrazyRockScoreType.Empty] = emptyEff
  self.guideLineCpt = self:AddComponent(RockGamePlayerGuideLineComponent, rock_game_player_guide_line_path)
end

function RockGamePlayerComponent:ComponentDestroy()
  self.normalNoteItem.gameObject:GameObjectDestroyAll()
  self.continueNoteItem.gameObject:GameObjectDestroyAll()
  self.normalNoteItem = nil
  self.continueNoteItem = nil
  self.noteRoot:RemoveAllComponentes()
end

function RockGamePlayerComponent:DataDefine()
  self.noteItemPool = {}
  self.noteItemPool[CrazyRockNoteType.SingleClick] = {}
  self.noteItemPool[CrazyRockNoteType.Continue] = {}
  self.noteEffPool = {}
  self.noteEffPool[CrazyRockEffect.OffsetDisappearEff] = {}
  self.allNoteItemList = {}
  self.allClickableItemList = {}
  self.isPointerUp = true
  self.onSuccessHitCallback = nil
  self.onBreakComboCallback = nil
  self.enterContinueCallback = nil
  self.exitContinueCallback = nil
  self.onNoteItemFinishCallback = nil
  self.finishCallback = nil
  self.curScore = 0
  self.comboCount = 0
  self.songStartPlayTime = 0
  self.totalPauseTime = 0
  self.pauseStartTime = 0
  self.continueNoteFinishTimer = nil
  self.curTime = 0
end

function RockGamePlayerComponent:DataDestroy()
  self.noteItemPool = nil
  self.noteEffPool = nil
  self.allNoteItemList = nil
  self.allClickableItemList = nil
  self.isPointerUp = nil
  self.onSuccessHitCallback = nil
  self.onBreakComboCallback = nil
  self.enterContinueCallback = nil
  self.exitContinueCallback = nil
  self.onNoteItemFinishCallback = nil
  self.finishCallback = nil
  self.curScore = nil
  self.comboCount = nil
  self.songStartPlayTime = nil
  self.totalPauseTime = nil
  self.pauseStartTime = nil
  if self.continueNoteFinishTimer then
    self.continueNoteFinishTimer:Stop()
    self.continueNoteFinishTimer = nil
  end
end

function RockGamePlayerComponent:OnAddListener()
  base.OnAddListener(self)
end

function RockGamePlayerComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function RockGamePlayerComponent:BlindSuccessHitCallback(onSuccessHitCallback)
  self.onSuccessHitCallback = onSuccessHitCallback
end

function RockGamePlayerComponent:BlindBreakComboCallback(onBreakComboCallback)
  self.onBreakComboCallback = onBreakComboCallback
end

function RockGamePlayerComponent:BlindEnterClickAreaCallback(enterClickAreaCallback)
  self.enterClickAreaCallback = enterClickAreaCallback
end

function RockGamePlayerComponent:BlindExitClickAreaCallback(exitClickAreaCallback)
  self.exitClickAreaCallback = exitClickAreaCallback
end

function RockGamePlayerComponent:BlindFinishCallback(finishCallback)
  self.finishCallback = finishCallback
end

function RockGamePlayerComponent:BlindOnNoteItemFinishCallback(onNoteItemFinishCallback)
  self.onNoteItemFinishCallback = onNoteItemFinishCallback
end

function RockGamePlayerComponent:PauseGame()
  self.pauseFlag = true
  self:ChangeGameState(CrazyRockGameState.Pause)
end

function RockGamePlayerComponent:ResumeGame()
  self.pauseFlag = false
  self:ChangeGameState(CrazyRockGameState.Resume)
end

function RockGamePlayerComponent:ChangeGameState(newState, params)
  self.curGameState = newState
  if newState == CrazyRockGameState.Load then
    if params and params.isEditorModel and self.guideLineCpt then
      self.isEditorModel = params.isEditorModel
      self.guideLineCpt:SetShowHide(self.isEditorModel)
    end
    DataCenter.LWSoundManager:StopAllSounds()
    self.isLoop = params.isLoop
    self:PreloadNoteItemPrefab()
    self:OnEnterLoadState(params.blankTime, params.songId, params.noteOffset)
    self.nextNoteData = self.songData:GetFirstNoteData()
  elseif newState == CrazyRockGameState.InGame then
  elseif newState == CrazyRockGameState.Pause then
    self:PauseCurBGM()
  elseif newState == CrazyRockGameState.Resume then
    self.pauseStartTime = Mathf.Max(self.pauseStartTime, self.songStartPlayTime)
    local thisPauseDuration = Mathf.Max(CS.GameEntry.Sound:GetDSPTime() * 1000 - self.pauseStartTime, 0)
    local isSongStart = CS.GameEntry.Sound:GetDSPTime() * 1000 - thisPauseDuration >= self.songStartPlayTime
    if isSongStart then
      self.totalPauseTime = self.totalPauseTime + thisPauseDuration
      local curBgmId = CS.GameEntry.Sound:GetBGMusic()
      CS.GameEntry.Sound:ResumeSound(curBgmId)
      self:ChangeGameState(CrazyRockGameState.InGame)
    else
      self.songPlayDelayTime = self.blankTimeBeforeStart - thisPauseDuration
      self:LoadMusicAndPrePlay()
    end
  elseif newState == CrazyRockGameState.MusicEnd then
    if self.finishCallback then
      local hitSaveData = self.hitSaveData and self.hitSaveData:GetFormatDataList() or nil
      self.finishCallback(self.curScore, hitSaveData)
    end
  elseif newState == CrazyRockGameState.Replay then
    self:OnEnterLoadState(0, self.songId)
    self.nextNoteData = self.songData:GetFirstNoteData()
  end
end

function RockGamePlayerComponent:PauseCurBGM()
  local curBgmId = CS.GameEntry.Sound:GetBGMusic()
  CS.GameEntry.Sound:PauseSound(curBgmId)
  self.pauseStartTime = CS.GameEntry.Sound:GetDSPTime() * 1000
end

function RockGamePlayerComponent:PreloadNoteItemPrefab()
  self:PreLoadTargetTypeItem(CrazyRockNoteType.SingleClick)
  self:PreLoadTargetTypeItem(CrazyRockNoteType.Continue)
end

function RockGamePlayerComponent:PreLoadTargetTypeItem(itemType)
  local itemList = self.noteItemPool[itemType]
  if not table.containsKey(NOTE_ITEM_PRELOAD_COUNT_CONFIG, itemType) then
    return
  end
  local preloadCount = NOTE_ITEM_PRELOAD_COUNT_CONFIG[itemType]
  local needPreloadCount = preloadCount - #itemList
  if needPreloadCount <= 0 then
    return
  end
  local tmpList = {}
  for i = 1, needPreloadCount do
    local item = self:GetNoteItemFromPool(itemType)
    table.insert(tmpList, item)
  end
  for _, v in ipairs(tmpList) do
    self:ReturnNoteItemToPool(v, itemType)
  end
end

function RockGamePlayerComponent:OnEnterLoadState(blankTime, songId, noteOffset)
  self:RecycleAllNoteItem()
  self.blankTimeBeforeStart = toInt(blankTime)
  self.songId = toInt(songId)
  self.noteOffset = noteOffset or 0
  self.previewNotePosTrans = self.previewPoint.transform
  self.curNotePosTrans = self.curPoint.transform
  self:InitSongData(songId)
  self:ResetData()
  self.gameDuration = self.songDuration + self.blankTimeBeforeStart
  self.songPlayDelayTime = self.blankTimeBeforeStart
  self:LoadMusicAndPrePlay()
  if self.isEditorModel and self.guideLineCpt then
    local guideLineCptParams = {}
    guideLineCptParams.songData = self.songData
    guideLineCptParams.previewNotePosTrans = self.previewNotePosTrans
    guideLineCptParams.curNotePosTrans = self.curNotePosTrans
    guideLineCptParams.songNotePreviewTime = self.songNotePreviewTime
    guideLineCptParams.nextNoteData = self.songData:GetFirstNoteData()
    self.guideLineCpt:Init(self, guideLineCptParams)
  end
end

function RockGamePlayerComponent:LoadMusicAndPrePlay()
  self.songLoadFinish = false
  local rowData = LocalController:instance():getLine(TableName.LW_Sound, self.songData.bgmMetaId)
  if rowData then
    local function getMusicStartDspTimeFunc()
      self.songLoadFinish = true
      
      self:ConfirmSongStartPlayTime()
      return self.songStartPlayTime / 1000
    end
    
    local function musicLoadFinishFunc()
      if self.curGameState == CrazyRockGameState.Load or self.curGameState == CrazyRockGameState.Resume or self.curGameState == CrazyRockGameState.Replay then
        self:ChangeGameState(CrazyRockGameState.InGame)
      elseif self.pauseFlag then
        self:ChangeGameState(CrazyRockGameState.Pause)
      end
    end
    
    DataCenter.LWSoundManager:PlayBGMWithDspTime(self.songData.bgmMetaId, false, 0, getMusicStartDspTimeFunc, musicLoadFinishFunc)
  end
end

function RockGamePlayerComponent:ConfirmSongStartPlayTime()
  self.songStartPlayTime = CS.GameEntry.Sound:GetDSPTime() * 1000 + self.songPlayDelayTime
end

function RockGamePlayerComponent:InitSongData(songId)
  if self.songData and self.songData.songId == songId then
    return
  end
  self.songData = DataCenter.ActCrazyRockDataManager:GetSongData(songId)
  self.songData:SetCustomOffset(self.noteOffset or 0)
  self.songNotePreviewTime = self.songData.notePreviewTime
  self.clickCheckRightRange = self.songData.clickCheckRightRange
  self.songDuration = self.songData.duration
end

function RockGamePlayerComponent:ResetData()
  self.isPointerUp = true
  self.curScore = 0
  self.comboCount = 0
  self.curSongPlayPassTime = nil
  self.curSongPassDspTime = nil
  if self.hitSaveData then
    self.hitSaveData:Clear()
  end
  self.songStartPlayTime = 0
  self.totalPauseTime = 0
  self.pauseStartTime = 0
  self.songPlayDelayTime = 0
end

function RockGamePlayerComponent:GetCurState()
  return self.curGameState
end

function RockGamePlayerComponent:Pause()
  self:ChangeGameState(CrazyRockGameState.Pause)
end

function RockGamePlayerComponent:Update()
  self.curTime = self.curTime + Time.deltaTime
  self:Tick()
end

function RockGamePlayerComponent:Tick()
  if self.curGameState ~= CrazyRockGameState.InGame then
    return
  end
  local prevSongPassDspTime = self.curSongPassDspTime
  self.curSongPassDspTime = self:GetCurSongPlayPassTime()
  local dspTimeOffset = -1
  if prevSongPassDspTime then
    dspTimeOffset = self.curSongPassDspTime - prevSongPassDspTime
  end
  local prevSongPlayPassTime = self.curSongPlayPassTime
  if dspTimeOffset == 0 then
    self.curSongPlayPassTime = self.curSongPlayPassTime + Time.deltaTime * 1000
  else
    self.curSongPlayPassTime = self.curSongPassDspTime
  end
  local passTimeOffset = 0
  if prevSongPlayPassTime then
    passTimeOffset = self.curSongPlayPassTime - prevSongPlayPassTime
  end
  if passTimeOffset < 0 then
    self.curSongPlayPassTime = prevSongPlayPassTime
  end
  local previewTimePos = self.curSongPlayPassTime + self.songNotePreviewTime
  self:GenNoteItemByTime(previewTimePos)
  self:UpdateAllNoteItemPos(self.curSongPlayPassTime)
  if self.curSongPlayPassTime >= self.songDuration then
    if not self.isLoop then
      self:ChangeGameState(CrazyRockGameState.MusicEnd)
    else
      self:EnterNextLoop()
    end
    return
  end
  self:InputUpdate()
  if self.isEditorModel and self.guideLineCpt then
    self.guideLineCpt:Tick(self.curSongPlayPassTime)
  end
end

function RockGamePlayerComponent:GetCurSongPlayPassTime()
  return CS.GameEntry.Sound:GetDSPTime() * 1000 - self.songStartPlayTime - self.totalPauseTime
end

function RockGamePlayerComponent:GetCurGamePassTime()
  return self:GetCurSongPlayPassTime() + self.blankTimeBeforeStart
end

function RockGamePlayerComponent:GenNoteItemByTime(targetTime)
  if self.nextNoteData then
    local noteDataList, nextNoteData = self:GetAllNoteDataList(self.nextNoteData, targetTime)
    if self.nextNoteData ~= nextNoteData then
      self.nextNoteData = nextNoteData
      if not nextNoteData then
      else
      end
      for _, v in ipairs(noteDataList) do
        local noteItem = self:GetNoteItemFromPool(v.noteType)
        if noteItem then
          if CS.UnityEngine.Application.isEditor then
            noteItem.gameObject.name = string.format("note_type_%s_meter_%s_index_%s_timePos_%s", v.noteType, v.meterId, v.noteIndex, v.noteTimePos)
          end
          noteItem:SetNoteData(v)
          self:UpdateNoteItemPosImmediate(noteItem, self.curSongPlayPassTime)
        end
      end
    end
  end
end

function RockGamePlayerComponent:InputUpdate()
  if not CS.UnityEngine.Application.isEditor and not Config.IsPC() then
    return
  end
  if self.isPointerUp and CSInput.GetKeyDown(CS.UnityEngine.KeyCode.Space) then
    self.isPointerUp = false
    self:TryHitNote()
  end
  if not self.isPointerUp and CSInput.GetKeyUp(CS.UnityEngine.KeyCode.Space) then
    self.isPointerUp = true
  end
end

function RockGamePlayerComponent:UpdateAllNoteItemPos(passTime)
  local allNeeRecycleList = {}
  for _, v in ipairs(self.allNoteItemList) do
    local remainTime = v.noteData.noteTimePos - passTime
    local clampMin = -1
    if v:IsContinueNote() then
      clampMin = 0
    end
    v:Tick(passTime)
    if v.enterClickAreaFlag then
      if v.noteData:CheckIsHit(passTime) then
        self:OnNoteItemEnterClickCheckArea(v)
      end
    elseif not v.noteData:CheckIsHit(passTime) then
      self:OnNoteItemExitClickCheckArea(v)
    end
    local lerp = 1 - Mathf.Clamp(remainTime / self.songNotePreviewTime, clampMin, 1)
    local targetPos = Vector3.LerpUnclamped(self.previewPoint.transform.position, self.curPoint.transform.position, lerp)
    v.transform.position = targetPos
    local noteNotClickTime = v.noteData:DisappearTimeWhenPassHitTime()
    local isNotClickable = remainTime <= -1 * noteNotClickTime
    if isNotClickable then
      table.removebyvalue(self.allClickableItemList, v)
      if not v:IsNoteCompleted() then
        self:BreakCombo(v)
      end
    end
    local noteDisappearTime = v.noteData:DisappearTimeWhenPassHitTime() + (self.songData.disappear_time or NOTE_DISAPPEAR_DELAY_TIME)
    local isNeedRecycle = remainTime <= -1 * noteDisappearTime
    if isNeedRecycle then
      table.insert(allNeeRecycleList, v)
    end
  end
  for _, v in ipairs(allNeeRecycleList) do
    self:DisappearNoteItem(v)
  end
end

function RockGamePlayerComponent:UpdateNoteItemPosImmediate(noteItem, passTime)
  local remainTime = noteItem.noteData.noteTimePos - passTime
  local lerp = 1 - Mathf.Clamp(remainTime / self.songNotePreviewTime, 0, 1)
  local targetPos = Vector3.Lerp(self.previewPoint.transform.position, self.curPoint.transform.position, lerp)
  noteItem.transform.position = targetPos
end

function RockGamePlayerComponent:GetAllNoteDataList(noteData, targetTime)
  if not noteData then
    Logger.LogError("RockGamePlayerComponent:GetAllNoteDataList() noteData is nil! plz check it !")
    return
  end
  local nextNoteData = noteData
  local ret
  local maxLoopCount = 500
  while nextNoteData and nextNoteData:IsInBeforeTimeLine(targetTime) do
    ret = ret or {}
    if nextNoteData:IsNotEmptyNote() then
      table.insert(ret, nextNoteData)
    else
    end
    if nextNoteData.isEndMusicNote then
      return ret
    end
    if nextNoteData.isEndNote then
      local nextMeterId = nextNoteData.meterId + 1
      local metaData = self.songData:GetMeterDataById(nextMeterId)
      if not metaData then
        Logger.LogError("RockGamePlayerComponent:GetAllNoteDataList() metaData is nil! plz check it !")
        return ret
      end
      nextNoteData = metaData:GetFirstNoteData()
    else
      nextNoteData = nextNoteData.nextNoteData
    end
    maxLoopCount = maxLoopCount - 1
    if maxLoopCount <= 0 then
      Logger.LogError("RockGamePlayerComponent:GetAllNoteDataList() maxLoopCount is 0! plz check it !")
      return ret
    end
  end
  return ret, nextNoteData
end

function RockGamePlayerComponent:GetNoteItemFromPool(noteType)
  local noteItem
  local noteItemList = self.noteItemPool[noteType]
  if not noteItemList then
    Logger.LogError("GetNoteItemFromPool.noteItemList is null!. noteType: " .. noteType)
    return
  end
  if #noteItemList <= 0 then
    local targetItemObj = self.noteObjDic[noteType]
    local instObj = targetItemObj:GameObjectSpawn(self.noteRoot.transform)
    local name = tostring(NameCount)
    instObj.transform.name = name
    NameCount = NameCount + 1
    local noteItemClass = noteItemClassMap[noteType]
    noteItem = self.noteRoot:AddComponent(noteItemClass, name)
  else
    noteItem = noteItemList[1]
    table.remove(noteItemList, 1)
  end
  noteItem:SetShowHide(true)
  noteItem.transform:SetSiblingIndex(0)
  table.insert(self.allNoteItemList, noteItem)
  table.insert(self.allClickableItemList, noteItem)
  return noteItem
end

function RockGamePlayerComponent:ReturnNoteItemToPool(noteItem, noteType)
  local noteType = noteItem.noteType or noteType
  local noteItemList = self.noteItemPool[noteType]
  noteItem:SetShowHide(false)
  table.removebyvalue(self.allNoteItemList, noteItem)
  table.insert(noteItemList, noteItem)
end

function RockGamePlayerComponent:GetCurFirstClickableNoteItem()
  if #self.allClickableItemList <= 0 then
    return nil
  end
  return self.allClickableItemList[1]
end

function RockGamePlayerComponent:GetSecondNoteRemainHitTime()
  if #self.allClickableItemList <= 1 then
    return self.songNotePreviewTime
  end
  local secondNoteItem = self.allClickableItemList[2]
  local remainTime = secondNoteItem.noteData.noteTimePos - self.curSongPlayPassTime
  return remainTime
end

function RockGamePlayerComponent:OnPointerDown()
  if not self.isPointerUp then
    return
  end
  self.isPointerUp = false
  self:TryHitNote()
end

function RockGamePlayerComponent:OnPointerUp()
  self.isPointerUp = true
end

function RockGamePlayerComponent:TryHitNote()
  local hitTimePos = toInt(self:GetCurSongPlayPassTime())
  local curFirstNoteItem = self:GetCurFirstClickableNoteItem()
  if not curFirstNoteItem then
    return
  end
  if self.hitBtnAni:IsPlaying("Click") then
    self.hitBtnAni:Rewind("Click")
  else
    self.hitBtnAni:Play("Click")
  end
  if self.curGameState == CrazyRockGameState.Load then
    self:PlayScoreEff(CrazyRockScoreType.Empty)
    return
  end
  local hitRet = curFirstNoteItem:BeHit(hitTimePos)
  if not hitRet then
    self:PlayScoreEff(CrazyRockScoreType.Empty)
    DataCenter.LWSoundManager:PlaySound(EMPTY_HIT_SE_CONFIG_ID, false)
    return
  end
  hitRet.hitTimePos = hitTimePos
  if curFirstNoteItem and curFirstNoteItem.noteData.clickSoundId then
    local clickSoundId = curFirstNoteItem.noteData.clickSoundId
    DataCenter.LWSoundManager:PlaySound(clickSoundId, false)
  end
  self:AfterSuccessHit(curFirstNoteItem, hitRet)
end

function RockGamePlayerComponent:AfterSuccessHit(targetNoteItem, hitRet)
  self:CheckPlayScoreEff(hitRet)
  self.comboCount = self.comboCount + 1
  local comboScoreRatio, comboLv = self.songData:GetComboScoreRatioConfig(self.comboCount)
  local baseScore = hitRet.baseScore
  local addScore = Mathf.Floor(baseScore * comboScoreRatio)
  if targetNoteItem and targetNoteItem:IsEndMusicNote() and self.songData.completeScore and (hitRet.hitType == CrazyRockHitType.SingleNoteHit or hitRet.hitType == CrazyRockHitType.ContinueFirstNoteHit) then
    addScore = addScore + self.songData.completeScore
  end
  hitRet.addScore = addScore
  self.curScore = self.curScore + addScore
  hitRet.totalScore = self.curScore
  hitRet.comboCount = self.comboCount
  hitRet.comboScoreRatio = comboScoreRatio
  hitRet.comboLv = comboLv
  hitRet.secondNoteRemainHitTime = self:GetSecondNoteRemainHitTime()
  if self.onSuccessHitCallback then
    self.onSuccessHitCallback(hitRet)
  end
  self:SaveHitData(targetNoteItem, hitRet)
  if hitRet.isFinish then
    self:OnNoteItemFinish(targetNoteItem, hitRet)
    return
  end
end

function RockGamePlayerComponent:OnNoteItemFinish(noteItem, hitRet)
  if self.onNoteItemFinishCallback then
    self.onNoteItemFinishCallback(noteItem, hitRet)
  end
  table.removebyvalue(self.allClickableItemList, noteItem)
  self:DisappearNoteItem(noteItem)
  if noteItem and noteItem:IsContinueNote() then
    self:PlayContinueNoteFinishEff()
  end
end

function RockGamePlayerComponent:SaveHitData(noteItem, hitRet)
  if not self.hitSaveData then
    self.hitSaveData = CrazyRockHitSaveData.New()
  end
  hitRet.meterId = noteItem.noteData.meterId
  hitRet.noteIndex = noteItem.noteData.noteIndex
  self.hitSaveData:AddHitData(hitRet)
end

function RockGamePlayerComponent:CheckPlayScoreEff(hitRet)
  local hitType = hitRet.hitType
  if hitType ~= CrazyRockHitType.ContinueHit then
    local scoreType = hitRet.scoreType
    self:PlayScoreEff(scoreType)
  end
end

function RockGamePlayerComponent:DisappearNoteItem(noteItem)
  self:ReturnNoteItemToPool(noteItem)
end

function RockGamePlayerComponent:RecycleAllNoteItem()
  if not self.allNoteItemList then
    return
  end
  local tempList = {}
  for _, v in pairs(self.allNoteItemList) do
    table.insert(tempList, v)
  end
  for _, v in ipairs(tempList) do
    self:ReturnNoteItemToPool(v)
  end
  self.allClickableItemList = {}
end

function RockGamePlayerComponent:PlayScoreEff(scoreType)
  for _, v in ipairs(self.effDic) do
    v:SetActive(false)
  end
  self.effDic[scoreType]:SetActive(true)
end

function RockGamePlayerComponent:GetCurSongPassTime()
  return self.curSongPlayPassTime
end

function RockGamePlayerComponent:GetCurSongPlayProgress()
  return self:GetCurGamePassTime() / self.gameDuration
end

function RockGamePlayerComponent:BreakCombo(noteItem)
  self.comboCount = 0
  if self.onBreakComboCallback then
    self.onBreakComboCallback(noteItem)
  end
end

function RockGamePlayerComponent:OnNoteItemEnterClickCheckArea(noteItem)
  if not noteItem then
    Logger.LogError("RockGamePlayerComponent:OnNoteItemEnterClickCheckArea() noteItem is nil! plz check it !")
    return
  end
  noteItem:OnEnterClickArea()
  if self.enterClickAreaCallback then
    self.enterClickAreaCallback(noteItem)
  end
end

function RockGamePlayerComponent:OnNoteItemExitClickCheckArea(noteItem)
  if not noteItem then
    Logger.LogError("RockGamePlayerComponent:OnNoteItemExitClickCheckArea() noteItem is nil! plz check it !")
    return
  end
  if self.exitClickAreaCallback then
    self.exitClickAreaCallback(noteItem)
  end
end

function RockGamePlayerComponent:PlayContinueNoteFinishEff()
  if self.continueNoteFinishTimer then
    self.continueNoteFinishTimer:Stop()
    self.continueNoteFinishTimer = nil
  end
  self.continueNoteFinishEff:SetActive(false)
  self.continueNoteFinishEff:SetActive(true)
  self.continueNoteFinishTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.continueNoteFinishTimer = nil
    self.continueNoteFinishEff:SetActive(false)
  end, 1)
end

function RockGamePlayerComponent:ShowMusicLog(info, color)
  Logger.LogCustom(string.format("[music]%s", info), color)
end

function RockGamePlayerComponent:EnterNextLoop()
  self:ChangeGameState(CrazyRockGameState.Replay)
end

return RockGamePlayerComponent
