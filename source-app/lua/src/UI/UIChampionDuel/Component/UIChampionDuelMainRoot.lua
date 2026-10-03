local base = require("UI.UIRaceEntrance.Component.ActDownloadNodeBase")
local UIChampionDuelMainRoot = BaseClass("UIChampionDuelMainRoot", base)
local Resource = CS.GameEntry.Resource
local UIChampionDuelSchedule = require("UI.UIChampionDuel.Component.UIChampionDuelSchedule")
local UIChampionDuelGroup = require("UI.UIChampionDuel.Component.UIChampionDuelGroup")
local UIChampionDuelFormation = require("UI.UIChampionDuel.Component.UIChampionDuelFormation")
local UIChampionDuelGuess = require("UI.UIChampionDuel.Component.UIChampionDuelGuess")
local UIChampionDuelDonate = require("UI.UIChampionDuel.Component.UIChampionDuelDonate")
local UIChampionDuelKnockout = require("UI.UIChampionDuel.Component.UIChampionDuelKnockout")
local btn_award_path = "BtnAward"
local red_award_path = "BtnAward/RedAward"
local text_red_award_path = "BtnAward/RedAward/RedAwardNum"
local text_btn_award_path = "BtnAward/TextBtnAward"
local center_path = "ContentContainer"
local content_base_path = "Assets/Main/Prefabs/UI/UIChampionDuel/%s.prefab"
local contents_info = {
  schedule = {
    class = UIChampionDuelSchedule,
    prefab = "UIChampionDuelSchedule",
    langKey = "champion_duel_tips1002"
  },
  group = {
    class = UIChampionDuelGroup,
    prefab = "UIChampionDuelGroup",
    langKey = "champion_duel_tips1003"
  },
  formation = {
    class = UIChampionDuelFormation,
    prefab = "UIChampionDuelFormation",
    langKey = "champion_duel_tips1004"
  },
  guess = {
    class = UIChampionDuelGuess,
    prefab = "UIChampionDuelGuess",
    langKey = "champion_duel_tips1005"
  },
  activity = {
    class = UIChampionDuelDonate,
    prefab = "UIChampionDuelDonate",
    langKey = "champion_duel_tips1058"
  },
  knockout = {
    class = UIChampionDuelKnockout,
    prefab = "UIChampionDuelKnockout",
    langKey = "champion_duel_tips1058"
  }
}
local content_keys = {
  "schedule",
  "",
  "formation",
  "group"
}
local base_toggle_path = "TogView/Content/"
local toggles_path = {
  "ToggleSchedule",
  "ToggleOther",
  "ToggleFormation",
  "ToggleGroup"
}
local toggle_texts_path = {
  "Schedule",
  "Other",
  "Formation",
  "Group"
}

function UIChampionDuelMainRoot:OnCreate()
  base.OnCreate(self)
  self.btn_award = self:AddComponent(UIButton, btn_award_path)
  self.btn_award:SetOnClick(BindCallback(self, self.OnBtnAwardClick))
  self.red_award = self:AddComponent(UIImage, red_award_path)
  self.text_red_award = self:AddComponent(UIText, text_red_award_path)
  self.text_btn_award = self:AddComponent(UIText, text_btn_award_path)
  self.text_btn_award:SetLocalText("130065")
  self.center = self:AddComponent(UIBaseContainer, center_path)
  self.contents = {}
  self.requests = {}
  self.toggles = {}
  self.toggleTexts = {}
  self.togReds = {}
  self.togTextReds = {}
  for i = 1, 4 do
    local keyStr = base_toggle_path .. toggles_path[i]
    local toggle = self:AddComponent(UIToggle, keyStr)
    toggle:SetOnValueChanged(function(tf)
      self:SetOnValueChanged(i, tf)
    end)
    self.toggles[i] = toggle
    local textKey = toggle_texts_path[i]
    local langKey
    local contentKey = content_keys[i]
    if not string.IsNullOrEmpty(contentKey) then
      langKey = contents_info[contentKey].langKey
    end
    local text1 = self:AddComponent(UIText, keyStr .. "/Text" .. textKey .. 1)
    self.toggleTexts[textKey .. 1] = text1
    local text2 = self:AddComponent(UIText, keyStr .. "/Choose/Text" .. textKey .. 2)
    self.toggleTexts[textKey .. 2] = text2
    if not string.IsNullOrEmpty(langKey) then
      text1:SetLocalText(langKey)
      text2:SetLocalText(langKey)
    end
    self.togReds[textKey] = self:AddComponent(UIImage, keyStr .. "/Red" .. textKey)
    self.togTextReds[textKey] = self:AddComponent(UIText, keyStr .. "/Red" .. textKey .. "/TextRed" .. textKey)
  end
  self:SetToggle(1)
  self:SetOnValueChanged(1, true)
end

function UIChampionDuelMainRoot:OnDestroy()
  self:CurContentHide()
  for _, v in pairs(self.requests) do
    v:Destroy()
    v = nil
  end
  self.requests = {}
  self.btn_award = nil
  self.red_award = nil
  self.text_red_award = nil
  self.text_btn_award = nil
  self.center = nil
  self.contents = {}
  self.toggles = {}
  self.toggleTexts = {}
  self.togReds = {}
  self.togTextReds = {}
  base.OnDestroy(self)
end

function UIChampionDuelMainRoot:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChampionDuelUIRefresh, self.RefreshView)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.UpdateRed)
  self:AddUIListener(EventId.ChampionDuelMainTabSel, self.SetToggle)
  self:AddUIListener(EventId.OnPassDay, self.OnPassDay)
end

function UIChampionDuelMainRoot:OnRemoveListener()
  self:RemoveUIListener(EventId.ChampionDuelUIRefresh, self.RefreshView)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.UpdateRed)
  self:RemoveUIListener(EventId.ChampionDuelMainTabSel, self.SetToggle)
  self:RemoveUIListener(EventId.OnPassDay, self.OnPassDay)
  base.OnRemoveListener(self)
end

function UIChampionDuelMainRoot:GetActType()
  return EnumActivity.ChampionDuelMain.Type
end

function UIChampionDuelMainRoot:OnEnterNode()
  DataCenter.ChampionDuelManager:SendActInfo()
end

function UIChampionDuelMainRoot:CurContentHide()
  if self.curContent then
    self.curContent:SetActive(false)
  end
  self.curContent = nil
  self.curIdx = 0
end

function UIChampionDuelMainRoot:ResetCurIdx(msgKey, forceIdx)
  UIUtil.ShowTipsId(msgKey)
  self.onlyChangeTogValue = true
  if forceIdx then
    self:SetToggle(forceIdx)
  else
    self:SetToggle(self.curIdx)
  end
end

function UIChampionDuelMainRoot:SetToggle(idx)
  local toggle = self.toggles[idx]
  if toggle ~= nil then
    if toggle:GetIsOn() then
      self:SetOnValueChanged(idx, true)
    else
      toggle:SetIsOn(true)
    end
  end
end

function UIChampionDuelMainRoot:SetOnValueChanged(idx, tf)
  if not tf then
    return
  end
  if self.onlyChangeTogValue then
    self.onlyChangeTogValue = false
    return
  end
  if self.curIdx == idx then
    return
  end
  if idx == 2 then
    local stageId = DataCenter.ChampionDuelManager:GetCurStageId()
    if stageId <= 0 then
      return
    end
    if stageId == ChampionDuelState.FinalShow then
      self:ResetCurIdx("champion_duel_tips1151", 1)
      return
    end
  elseif idx == 3 then
    local actInfo = DataCenter.ChampionDuelManager:GetActInfo()
    local sign = actInfo ~= nil and actInfo.sign or false
    if not sign then
      self:ResetCurIdx("champion_duel_tips1052")
      return
    end
    local stageId = DataCenter.ChampionDuelManager:GetCurStageId()
    if stageId == ChampionDuelState.FinalShow then
      self:ResetCurIdx("champion_duel_tips1151", 1)
      return
    end
    if stageId >= ChampionDuelState.Rematch then
      local inStage = false
      if stageId == ChampionDuelState.Rematch then
        local group = actInfo ~= nil and actInfo.group or 0
        inStage = 0 < group
      elseif stageId == ChampionDuelState.RematchAnnouncement then
        local group5 = actInfo ~= nil and actInfo.group5 or 0
        inStage = 0 < group5
      elseif stageId == ChampionDuelState.KnockOut then
        local group = actInfo ~= nil and actInfo.group or 0
        inStage = 0 < group
      else
        inStage = true
      end
      if not inStage then
        local tmpIdx = self.curIdx ~= 3 and self.curIdx or nil
        self:ResetCurIdx("champion_duel_tips1136", tmpIdx)
        return
      end
    end
  elseif idx == 4 then
    local stageId = DataCenter.ChampionDuelManager:GetCurStageId()
    if stageId < ChampionDuelState.SignInAnnouncement then
      self:ResetCurIdx("champion_duel_tips1028")
      return
    elseif stageId == ChampionDuelState.FinalShow then
      self:ResetCurIdx("champion_duel_tips1151", 1)
      return
    end
  end
  self:CurContentHide()
  if self.curContent ~= nil then
    self.curContent:SetActive(false)
  end
  local key
  if idx == 2 then
    local stageId = DataCenter.ChampionDuelManager:GetCurStageId()
    key = stageId < ChampionDuelState.Rematch and "activity" or "guess"
  elseif idx == 4 then
    local stageId = DataCenter.ChampionDuelManager:GetCurStageId()
    key = stageId >= ChampionDuelState.KnockOut and "knockout" or "group"
  else
    key = content_keys[idx]
  end
  self.curContent = self.contents[key]
  self.curIdx = idx
  if self.curContent ~= nil then
    self.curContent:SetActive(true)
    self:UpdateData()
    return
  end
  if self.requests[key] ~= nil then
    return
  end
  local info = contents_info[key]
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
    _go:SetActive(self.curIdx == idx)
    if self.curIdx == idx then
      self.curContent = newContent
      newContent:SetActive(true)
      self:UpdateData()
    end
  end)
end

function UIChampionDuelMainRoot:RefreshView()
  base.RefreshView(self)
  self:CheckIsShowStageChangeNotification()
end

function UIChampionDuelMainRoot:CheckIsShowStageChangeNotification()
  local actInfo = DataCenter.ChampionDuelManager:GetActInfo()
  if actInfo == nil then
    return
  end
  local stageId = actInfo.stageId
  local season = actInfo.season
  if stageId == ChampionDuelState.Rematch or stageId == ChampionDuelState.KnockOut then
    local value = CommonUtil.PlayerPrefsGetInt(string.format("%s_%s_%s", SettingKeys.CHAMPION_DUEL_STAGE_CHANGE, season, stageId), 0)
    if value == 0 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionDuelStageChangeNotification, {anim = true}, {stageId = stageId, season = season})
    end
  end
end

function UIChampionDuelMainRoot:UpdateData()
  if self.activityId == nil then
    return
  end
  if self.curContent ~= nil then
    self.curContent:ReInit()
  end
  local actInfo = DataCenter.ChampionDuelManager:GetActInfo()
  local stageId = DataCenter.ChampionDuelManager:GetCurStageId()
  self.btn_award:SetActive(self.curIdx ~= 2 or stageId < ChampionDuelState.Rematch)
  local textKey = toggle_texts_path[4]
  if stageId == ChampionDuelState.RematchAnnouncement then
    self.toggleTexts[textKey .. 1]:SetLocalText("champion_duel_tips1022", "")
    self.toggleTexts[textKey .. 2]:SetLocalText("champion_duel_tips1022", "")
  elseif stageId > ChampionDuelState.RematchAnnouncement then
    local langKey = "champion_duel_tips1092"
    self.toggleTexts[textKey .. 1]:SetLocalText(langKey)
    self.toggleTexts[textKey .. 2]:SetLocalText(langKey)
  else
    local group = actInfo ~= nil and actInfo.group or 0
    if 0 < group then
      local groupChar = DataCenter.ChampionDuelManager:GetGroupLetter(group)
      self.toggleTexts[textKey .. 1]:SetLocalText("champion_duel_tips1022", groupChar)
      self.toggleTexts[textKey .. 2]:SetLocalText("champion_duel_tips1022", groupChar)
    elseif stageId > ChampionDuelState.SignIn then
      self.toggleTexts[textKey .. 1]:SetLocalText("champion_duel_tips1022", "")
      self.toggleTexts[textKey .. 2]:SetLocalText("champion_duel_tips1022", "")
    else
      local info = contents_info.group
      local langKey = info.langKey
      self.toggleTexts[textKey .. 1]:SetLocalText(langKey)
      self.toggleTexts[textKey .. 2]:SetLocalText(langKey)
    end
  end
  local key = stageId < ChampionDuelState.Rematch and "activity" or "guess"
  local langKey = contents_info[key].langKey
  textKey = toggle_texts_path[2]
  self.toggleTexts[textKey .. 1]:SetLocalText(langKey)
  self.toggleTexts[textKey .. 2]:SetLocalText(langKey)
end

function UIChampionDuelMainRoot:UpdateAwardRed()
  if self.red_award == nil then
    return
  end
  local cnt = DataCenter.ChampionDuelManager:GetAwardRed()
  self.red_award:SetActive(0 < cnt)
  if 0 < cnt then
    self.text_red_award:SetText(cnt)
  end
end

function UIChampionDuelMainRoot:UpdateRed()
  self:UpdateAwardRed()
  local key = toggle_texts_path[4]
  local redImg = self.togReds[key]
  if redImg then
    local cnt = DataCenter.ChampionDuelManager:CheckGroupRed()
    redImg:SetActive(0 < cnt)
  end
  key = toggle_texts_path[3]
  redImg = self.togReds[key]
  if redImg then
    local cnt = DataCenter.ChampionDuelManager:CheckFormationRed()
    redImg:SetActive(0 < cnt)
  end
  key = toggle_texts_path[2]
  redImg = self.togReds[key]
  if redImg then
    local stageId = DataCenter.ChampionDuelManager:GetCurStageId()
    local cnt = 0
    if stageId < ChampionDuelState.Rematch then
      cnt = DataCenter.ChampionDuelManager:GetDonateActRedNum()
    else
      cnt = DataCenter.ChampionDuelManager:CheckGuessRed()
      if stageId < ChampionDuelState.FinalShow then
        cnt = cnt + DataCenter.ChampionDuelManager:CheckGuessRewardRed()
      end
    end
    redImg:SetActive(0 < cnt)
    if 0 < cnt then
      local redText = self.togTextReds[key]
      if redText then
        redText:SetText(cnt)
      end
    end
  end
  key = toggle_texts_path[1]
  redImg = self.togReds[key]
  if redImg then
    local cnt = DataCenter.ChampionDuelManager:CheckLogPopRed()
    redImg:SetActive(0 < cnt)
  end
end

function UIChampionDuelMainRoot:OnPassDay()
  local curIdx = self.curIdx == 0 and 1 or self.curIdx
  self:CurContentHide()
  self:SetToggle(curIdx)
  self:UpdateRed()
end

function UIChampionDuelMainRoot:OnBtnAwardClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  DataCenter.ChampionDuelManager:ReqRewardInfo(BindCallback(self, self.UpdateAwardRed))
end

return UIChampionDuelMainRoot
