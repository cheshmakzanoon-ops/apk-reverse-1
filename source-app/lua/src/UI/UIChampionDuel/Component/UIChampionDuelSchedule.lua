local UIChampionDuelSchedule = BaseClass("UIChampionDuelSchedule", UIBaseContainer)
local base = UIBaseContainer
local Resource = CS.GameEntry.Resource
local UIChampionDuelStateInfo = require("UI.UIChampionDuel.Component.UIChampionDuelStateInfo")
local UICD_ScheduleSign = require("UI.UIChampionDuel.Component.Schedule.UICD_ScheduleSign")
local UICD_ScheduleSigned = require("UI.UIChampionDuel.Component.Schedule.UICD_ScheduleSigned")
local UICD_ScheduleBattle = require("UI.UIChampionDuel.Component.Schedule.UICD_ScheduleBattle")
local UICD_ScheduleBattleResult = require("UI.UIChampionDuel.Component.Schedule.UICD_ScheduleBattleResult")
local UICD_ScheduleGuessStart = require("UI.UIChampionDuel.Component.Schedule.UICD_ScheduleGuessStart")
local UICD_ScheduleFinalShow = require("UI.UIChampionDuel.Component.Schedule.UICD_ScheduleFinalShow")
local state_info_path = "State"
local center_path = "Center"
local btn_sign_path = "BtnSign"
local text_btn_sign_path = "BtnSign/TextBtnSign"
local red_path = "BtnSign/Red"
local content_base_path = "Assets/Main/Prefabs/UI/UIChampionDuel/Schedule/%s.prefab"
local contents_info = {
  sign = {
    class = UICD_ScheduleSign,
    prefab = "UICD_ScheduleSign"
  },
  signed = {
    class = UICD_ScheduleSigned,
    prefab = "UICD_ScheduleSigned"
  },
  battle = {
    class = UICD_ScheduleBattle,
    prefab = "UICD_ScheduleBattle"
  },
  battleResult = {
    class = UICD_ScheduleBattleResult,
    prefab = "UICD_ScheduleBattleResult"
  },
  guessStart = {
    class = UICD_ScheduleGuessStart,
    prefab = "UICD_ScheduleGuessStart"
  },
  finalShow = {
    class = UICD_ScheduleFinalShow,
    prefab = "UICD_ScheduleFinalShow"
  }
}

function UIChampionDuelSchedule:OnCreate()
  base.OnCreate(self)
  self.endTime = 0
  self.stateInfo = self:AddComponent(UIChampionDuelStateInfo, state_info_path)
  self.center = self:AddComponent(UIBaseContainer, center_path)
  self.contents = {}
  self.requests = {}
end

function UIChampionDuelSchedule:OnDestroy()
  for _, v in pairs(self.requests) do
    v:Destroy()
    v = nil
  end
  self.requests = {}
  self.contents = {}
  self.stateInfo = nil
  self.center = nil
  self.endTime = 0
  base.OnDestroy(self)
end

function UIChampionDuelSchedule:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChampionDuelUpdateSigned, self.PlaySignedEff)
end

function UIChampionDuelSchedule:OnRemoveListener()
  self:RemoveUIListener(EventId.ChampionDuelUpdateSigned, self.PlaySignedEff)
  base.OnRemoveListener(self)
end

function UIChampionDuelSchedule:ReInit()
  self.endSendFlag = false
  self.stateInfo:ReInit()
  for _, v in pairs(self.contents) do
    v:SetActive(false)
  end
  local actInfo = DataCenter.ChampionDuelManager:GetActInfo()
  local stageId = DataCenter.ChampionDuelManager:GetCurStageId()
  local sign = actInfo ~= nil and actInfo.sign or false
  local key
  if stageId == ChampionDuelState.SignIn then
    key = sign and "signed" or "sign"
  elseif stageId == ChampionDuelState.SignInAnnouncement then
    key = "signed"
  elseif stageId == ChampionDuelState.PreStage then
    key = sign and "battle" or "signed"
  elseif stageId == ChampionDuelState.PreStageAnnouncement then
    key = sign and "battleResult" or "signed"
  elseif stageId == ChampionDuelState.Rematch then
    local group = actInfo ~= nil and actInfo.group or 0
    key = 0 < group and "battle" or "guessStart"
  elseif stageId == ChampionDuelState.RematchAnnouncement then
    local group5 = actInfo ~= nil and actInfo.group5 or 0
    key = 0 < group5 and "battleResult" or "guessStart"
  elseif stageId == ChampionDuelState.KnockOut then
    local group = actInfo ~= nil and actInfo.group or 0
    key = 0 < group and "battle" or "guessStart"
  elseif stageId == ChampionDuelState.FinalShow then
    key = "finalShow"
  end
  self.stateInfo:SetActive(stageId ~= ChampionDuelState.FinalShow)
  self.curKey = key
  self:CreateContent(key, function(newContent)
    newContent:SetActive(self.curKey == key)
    if newContent:GetActive() then
      self.curContent = newContent
      newContent:ReInit()
    end
  end)
end

function UIChampionDuelSchedule:CreateContent(key, cb)
  local content = self.contents[key]
  if content ~= nil then
    if cb then
      cb(content)
    end
    return
  end
  if self.requests[key] ~= nil then
    return
  end
  local info = contents_info[key]
  if info == nil then
    return
  end
  local request = Resource:InstantiateAsync(string.format(content_base_path, info.prefab))
  self.requests[key] = request
  request:completed("+", function(req)
    local _go = req.gameObject
    if IsNull(_go) then
      return
    end
    CommonUtil.CallAutoArabicMirrorManually(req)
    _go.name = key
    local pTF = _go.transform
    pTF:SetParent(self.center.transform)
    pTF:Set_localScale(1, 1, 1)
    pTF:Set_localPosition(0, 0, 0)
    local newContent = self.center:AddComponent(info.class, key)
    local rect = self.center.rectTransform.rect
    newContent.rectTransform:Set_sizeDelta(rect.width, rect.height)
    newContent.rectTransform:ForceUpdateRectTransforms()
    self.contents[key] = newContent
    if cb then
      cb(newContent)
    else
      newContent:SetActive(false)
    end
  end)
end

function UIChampionDuelSchedule:PlaySignedEff()
  self:CreateContent("signed", function(newContent)
    if not self:GetActive() then
      return
    end
    local oldContent = self.curContent
    oldContent.transform:SetAsLastSibling()
    self.curContent = newContent
    newContent:ReInit(true)
    oldContent:PlaySignAnim(function()
      if not self:GetActive() then
        return
      end
      oldContent:SetActive(false)
      newContent:PlaySignAnim()
    end)
  end)
end

return UIChampionDuelSchedule
