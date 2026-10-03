local base = UIBaseContainer
local RockGamePlayerGuideLineComponent = BaseClass("RockGamePlayerGuideLineComponent", UIBaseContainer)
local GuideLineItemComponent = require("UI.UIActCrazyRock.PlayView.Component.GuideLineItemComponent")
local AudioSettings = CS.UnityEngine.AudioSettings
local Localization = CS.GameEntry.Localization
local line_item_path = "ItemRoot/LineItem"
local line_root_path = "LineRoot"
local item_root_path = "ItemRoot"
local bpm_input_path = "layout/bpmItem/bpmInput"
local bpm_btn_path = "layout/bpmItem/bpmBtn"
local off_set_input_path = "layout/offsetItem/offSetInput"
local music_offset_btn_path = "layout/offsetItem/musicOffsetBtn"
local ani_speed_input_path = "layout/actorAniSpeedItem/aniSpeedInput"
local ani_speed_btn_path = "layout/actorAniSpeedItem/aniSpeedBtn"
local secne_eff_toggle_btn_path = "layout/sceneEffToggle/secneEffToggleBtn"
local scene_eff_toggle_btn_text_path = "layout/sceneEffToggle/secneEffToggleBtn/LW_Btn_Common_New_Base/sceneEffToggleBtnText"
local NOTE_DISAPPEAR_DELAY_TIME = 300

function RockGamePlayerGuideLineComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function RockGamePlayerGuideLineComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function RockGamePlayerGuideLineComponent:ComponentDefine()
  self.lineItemObj = self:AddComponent(UIBaseContainer, line_item_path).gameObject
  self.lineItemObj:GameObjectCreatePool()
  self.lineRoot = self:AddComponent(UIBaseContainer, line_root_path)
  self.itemRoot = self:AddComponent(UIBaseContainer, item_root_path)
  self.itemRoot:SetActive(false)
  self.bpmInput = self:AddComponent(UIInput, bpm_input_path)
  self.bpmInput:SetOnEndEdit(function(value)
    self:OnBpmInputEndEdit(value)
  end)
  self.bpmBtn = self:AddComponent(UIButton, bpm_btn_path)
  self.bpmBtn:SetOnClick(function()
    self:OnBpmBtnClick()
  end)
  self.offSetInput = self:AddComponent(UIInput, off_set_input_path)
  self.offSetInput:SetOnEndEdit(function(value)
    self:OnOffSetInputEndEdit(value)
  end)
  self.musicOffsetBtn = self:AddComponent(UIButton, music_offset_btn_path)
  self.musicOffsetBtn:SetOnClick(function()
    self:OnMusicOffsetBtnClick()
  end)
  self.aniSpeedInput = self:AddComponent(UIInput, ani_speed_input_path)
  self.aniSpeedInput:SetOnEndEdit(function(value)
    self:OnAniSpeedInputEndEdit(value)
  end)
  self.aniSpeedBtn = self:AddComponent(UIButton, ani_speed_btn_path)
  self.aniSpeedBtn:SetOnClick(function()
    self:OnAniSpeedBtnClick()
  end)
  self.effToggleBtn = self:AddComponent(UIButton, secne_eff_toggle_btn_path)
  self.effToggleBtn:SetOnClick(function()
    self:OnSceneEffBtnClick()
  end)
  self.sceneEffBtnText = self:AddComponent(UIText, scene_eff_toggle_btn_text_path)
end

function RockGamePlayerGuideLineComponent:ComponentDestroy()
  if self.lineRoot then
    self.lineRoot:RemoveAllComponentes()
  end
  if self.lineItemObj then
    self.lineItemObj:GameObjectRecycleAll()
  end
end

function RockGamePlayerGuideLineComponent:DataDefine()
  self.allLineItemList = {}
  self.lineItemPoolList = {}
end

function RockGamePlayerGuideLineComponent:DataDestroy()
  self.allLineItemList = nil
  self.lineItemPoolList = nil
end

function RockGamePlayerGuideLineComponent:OnAddListener()
  base.OnAddListener(self)
end

function RockGamePlayerGuideLineComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function RockGamePlayerGuideLineComponent:Init(playCpt, params)
  self.playCpt = playCpt
  self.songData = params.songData
  self.previewNotePosTrans = params.previewNotePosTrans
  self.curNotePosTrans = params.curNotePosTrans
  self.songNotePreviewTime = params.songNotePreviewTime
  self.nextNoteData = params.nextNoteData
  self.bmp = self.songData.bpm
  self.songOffset = self.songData.songOffset
  self.bpm_act = self.songData.bpm_act
  self.bpmInput:SetText(self.bmp)
  self.offSetInput:SetText(self.songOffset)
  self.aniSpeedInput:SetText(self.bpm_act)
  self:GenNoteItemByTime(self.songNotePreviewTime)
  self.sceneEffToggle = true
  self:RefreshSceneEffToggle()
end

function RockGamePlayerGuideLineComponent:Tick(curGamePassTime)
  self.curGamePassTime = curGamePassTime
  local previewTimePos = self.curGamePassTime + self.songNotePreviewTime
  self:GenNoteItemByTime(previewTimePos)
  self:UpdateAllNoteItemPos(self.curGamePassTime)
end

function RockGamePlayerGuideLineComponent:GenNoteItemByTime(targetTime)
  if self.nextNoteData then
    local noteDataList, nextNoteData = self:GetAllNoteDataList(self.nextNoteData, targetTime)
    if self.nextNoteData ~= nextNoteData then
      self.nextNoteData = nextNoteData
      for _, v in ipairs(noteDataList) do
        local noteItem = self:GetLineItemFromPool(v.noteType)
        if CS.UnityEngine.Application.isEditor then
          noteItem.gameObject.name = string.format("note_type_%s_meter_%s_index_%s_timePos_%s", v.noteType, v.meterId, v.noteIndex, v.noteTimePos)
        end
        noteItem:SetNoteData(v)
      end
    end
  end
end

function RockGamePlayerGuideLineComponent:GetAllNoteDataList(noteData, targetTime)
  if not noteData then
    return
  end
  local nextNoteData = noteData
  local ret
  local maxLoopCount = 500
  while nextNoteData and nextNoteData:IsInBeforeTimeLine(targetTime) do
    ret = ret or {}
    table.insert(ret, nextNoteData)
    if nextNoteData.isEndNote then
      local nextMeterId = nextNoteData.meterId + 1
      local meterData = self.songData:GetMeterDataById(nextMeterId)
      if not meterData then
        return ret
      end
      nextNoteData = meterData:GetFirstNoteData()
    else
      nextNoteData = nextNoteData.nextNoteData
    end
    maxLoopCount = maxLoopCount - 1
    if maxLoopCount <= 0 then
      return ret
    end
  end
  return ret, nextNoteData
end

function RockGamePlayerGuideLineComponent:UpdateAllNoteItemPos(passTime)
  local allNeeRecycleList = {}
  for _, v in ipairs(self.allLineItemList) do
    local remainTime = v.noteData.noteTimePos - passTime
    local lerp = 1 - Mathf.Clamp(remainTime / self.songNotePreviewTime, -1, 1)
    local targetPos = Vector3.LerpUnclamped(self.previewNotePosTrans.position, self.curNotePosTrans.position, lerp)
    v.transform.position = targetPos
    v:OnUpdatePos(lerp)
    local noteDisappearTime = v.noteData:DisappearTimeWhenPassHitTime()
    local isNeedRecycle = remainTime <= -1 * (noteDisappearTime + NOTE_DISAPPEAR_DELAY_TIME)
    if isNeedRecycle then
      table.insert(allNeeRecycleList, v)
    end
  end
  for _, v in ipairs(allNeeRecycleList) do
    self:ReturnLineItemToPool(v)
  end
end

function RockGamePlayerGuideLineComponent:GetLineItemFromPool()
  local lineItem
  if #self.lineItemPoolList <= 0 then
    local instObj = self.lineItemObj:GameObjectSpawn(self.lineRoot.transform)
    local name = tostring(NameCount)
    instObj.transform.name = name
    NameCount = NameCount + 1
    lineItem = self.lineRoot:AddComponent(GuideLineItemComponent, name)
  else
    lineItem = self.lineItemPoolList[1]
    table.remove(self.lineItemPoolList, 1)
  end
  lineItem:SetShowHide(true)
  lineItem.transform:SetSiblingIndex(0)
  table.insert(self.allLineItemList, lineItem)
  return lineItem
end

function RockGamePlayerGuideLineComponent:ReturnLineItemToPool(lineItem)
  lineItem:SetShowHide(false)
  table.removebyvalue(self.allLineItemList, lineItem)
  table.insert(self.lineItemPoolList, lineItem)
end

function RockGamePlayerGuideLineComponent:SetShowHide(isShow)
  self.gameObject:SetActive(isShow)
end

function RockGamePlayerGuideLineComponent:OnBpmInputEndEdit(value)
  self.bmp = tonumber(value)
end

function RockGamePlayerGuideLineComponent:OnBpmBtnClick()
  UIUtil.ShowMessage("\232\175\165\230\147\141\228\189\156\233\135\141\229\144\175\229\176\143\230\184\184\230\136\143\229\144\142\231\148\159\230\149\136\239\188\140\230\152\175\229\144\166\231\171\139\229\141\179\233\135\141\229\144\175\229\176\143\230\184\184\230\136\143", 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    self.songData.bpm = self.bmp
    self.songData:ParseSongNoteData()
    self:ReStartGame()
  end, function()
  end)
end

function RockGamePlayerGuideLineComponent:OnOffSetInputEndEdit(value)
  self.songOffset = tonumber(value)
end

function RockGamePlayerGuideLineComponent:OnMusicOffsetBtnClick()
  UIUtil.ShowMessage("\232\175\165\230\147\141\228\189\156\233\135\141\229\144\175\229\176\143\230\184\184\230\136\143\229\144\142\231\148\159\230\149\136\239\188\140\230\152\175\229\144\166\231\171\139\229\141\179\233\135\141\229\144\175\229\176\143\230\184\184\230\136\143", 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    self.songData.songOffset = self.songOffset
    self.songData:ParseSongNoteData()
    self:ReStartGame()
  end, function()
  end)
end

function RockGamePlayerGuideLineComponent:OnAniSpeedInputEndEdit(value)
  self.bpm_act = tonumber(value)
end

function RockGamePlayerGuideLineComponent:OnAniSpeedBtnClick()
  UIUtil.ShowTips(string.format("\229\189\147\229\137\141\229\138\168\231\148\187\233\128\159\229\186\166\228\184\186%s", self.bpm_act))
  local params = {}
  params.aniSpeed = self.bpm_act
  EventManager:GetInstance():Broadcast(EventId.MusicGameActorAniSpeedChange, params)
end

function RockGamePlayerGuideLineComponent:ReStartGame()
  local params = {}
  params.blankTime = 3000
  params.songId = self.songData.songId
  params.isEditorModel = true
  self.playCpt:ChangeGameState(CrazyRockGameState.Load, params)
end

function RockGamePlayerGuideLineComponent:OnSceneEffBtnClick()
  self.sceneEffToggle = not self.sceneEffToggle
  self:RefreshSceneEffToggle()
  EventManager:GetInstance():Broadcast(EventId.MusicGameSetSceneEffState, self.sceneEffToggle)
end

function RockGamePlayerGuideLineComponent:RefreshSceneEffToggle()
  self.sceneEffBtnText:SetText(self.sceneEffToggle and "\230\137\147\229\188\128" or "\229\133\179\233\151\173")
end

return RockGamePlayerGuideLineComponent
