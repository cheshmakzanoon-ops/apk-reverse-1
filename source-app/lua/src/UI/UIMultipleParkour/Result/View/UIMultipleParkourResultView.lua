local UIMultipleParkourResultView = BaseClass("UIMultipleParkourResultView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local commonGuiderPath = "Assets/Main/Prefabs/HeroSpinPrefabs/hero_icon_Guider.prefab"
local jpGuiderPath = "Assets/Main/Prefabs/HeroSpinPrefabs/ribenmeizi.prefab"
local tip_path = "Layout/npc/tip"
local alliance_rank_content_path = "Layout/contentLayout/allianceRankContent"
local alliance_rank_title_path = "Layout/contentLayout/allianceRankContent/allianceRankTitle"
local alliance_rank_from_path = "Layout/contentLayout/allianceRankContent/GameObject/allianceRankFrom"
local alliance_rank_to_path = "Layout/contentLayout/allianceRankContent/GameObject/allianceRankTo"
local server_rank_content_path = "Layout/contentLayout/serverRankContent"
local server_rank_title_path = "Layout/contentLayout/serverRankContent/serverRankTitle"
local server_rank_from_path = "Layout/contentLayout/serverRankContent/GameObject/serverRankFrom"
local server_rank_to_path = "Layout/contentLayout/serverRankContent/GameObject/serverRankTo"
local best_result_title_path = "Layout/contentLayout/bestResultContent/bestResultTitle"
local best_result_value_path = "Layout/contentLayout/bestResultContent/bestResultValue"
local result_title_path = "Layout/contentLayout/resultContent/resultTitle"
local result_value_path = "Layout/contentLayout/resultContent/resultValue"
local new_record_bg_path = "Layout/contentLayout/resultContent/resultValue/newRecordBg"
local new_record_path = "Layout/contentLayout/resultContent/resultValue/newRecordBg/newRecord"
local rank_title_path = "Layout/contentLayout/rankContent/rankTitle"
local rank_value_path = "Layout/contentLayout/rankContent/rankValue"
local again_btn_path = "Layout/btnLayout/AgainBtn"
local again_btn_text_path = "Layout/btnLayout/AgainBtn/AgainBtnText"
local back_btn_path = "Layout/btnLayout/BackBtn"
local back_btn_text_path = "Layout/btnLayout/BackBtn/BackBtnText"
local share_btn_path = "Layout/ShareBtn"
local spine_path = "Layout/npc/spine"

function UIMultipleParkourResultView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIMultipleParkourResultView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  self:ClearWaitingForMsg()
  base.OnDestroy(self)
end

function UIMultipleParkourResultView:OnAddListener()
  base.OnAddListener(self)
end

function UIMultipleParkourResultView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIMultipleParkourResultView:ComponentDefine()
  self.tip = self:AddComponent(UITextMeshProUGUIEx, tip_path)
  self.alliance_rank_content = self:AddComponent(UIBaseContainer, alliance_rank_content_path)
  self.alliance_rank_title = self:AddComponent(UITextMeshProUGUIEx, alliance_rank_title_path)
  self.alliance_rank_from = self:AddComponent(UITextMeshProUGUIEx, alliance_rank_from_path)
  self.alliance_rank_to = self:AddComponent(UITextMeshProUGUIEx, alliance_rank_to_path)
  self.server_rank_content = self:AddComponent(UIBaseContainer, server_rank_content_path)
  self.server_rank_title = self:AddComponent(UITextMeshProUGUIEx, server_rank_title_path)
  self.server_rank_from = self:AddComponent(UITextMeshProUGUIEx, server_rank_from_path)
  self.server_rank_to = self:AddComponent(UITextMeshProUGUIEx, server_rank_to_path)
  self.best_result_title = self:AddComponent(UITextMeshProUGUIEx, best_result_title_path)
  self.best_result_value = self:AddComponent(UITextMeshProUGUIEx, best_result_value_path)
  self.result_title = self:AddComponent(UITextMeshProUGUIEx, result_title_path)
  self.result_value = self:AddComponent(UITextMeshProUGUIEx, result_value_path)
  self.new_record_bg = self:AddComponent(UIImage, new_record_bg_path)
  self.new_record = self:AddComponent(UITextMeshProUGUIEx, new_record_path)
  self.rank_title = self:AddComponent(UITextMeshProUGUIEx, rank_title_path)
  self.rank_value = self:AddComponent(UITextMeshProUGUIEx, rank_value_path)
  self.again_btn = self:AddComponent(UIButton, again_btn_path)
  self.again_btn_text = self:AddComponent(UITextMeshProUGUIEx, again_btn_text_path)
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.back_btn_text = self:AddComponent(UITextMeshProUGUIEx, back_btn_text_path)
  self.share_btn = self:AddComponent(UIButton, share_btn_path)
  self.alliance_rank_title:SetText(Localization:GetString("multiply_door_tips_002"))
  self.server_rank_title:SetText(Localization:GetString("multiply_door_tips_003"))
  self.best_result_title:SetText(Localization:GetString("multiply_door_tips_004"))
  self.result_title:SetText(Localization:GetString("multiply_door_tips_005"))
  self.rank_title:SetText(Localization:GetString("multiply_door_tips_006"))
  self.new_record:SetText(Localization:GetString("multiply_door_tips_009"))
  self.again_btn_text:SetText(Localization:GetString("multiply_door_tips_007"))
  self.back_btn_text:SetText(Localization:GetString("multiply_door_tips_008"))
  self.back_btn:SetOnClick(function()
    self:OnBackBtnClick()
  end)
  self.again_btn:SetOnClick(function()
    self:OnAgainBtnClick()
  end)
  self.share_btn:SetOnClick(function()
    self:OnShareBtnClick()
  end)
  self.alliance_rank_content:SetActive(false)
  self.server_rank_content:SetActive(false)
  self.spine = self:AddComponent(UIBaseContainer, spine_path)
  if self.req then
    self.req:Destroy()
    self.req = nil
  end
  local path = commonGuiderPath
  if LuaEntry.Player.JPUser and DataCenter.LWSaveGirlManager:IsJPGirlOpen() then
    path = jpGuiderPath
  end
  self.req = ResourceManager:InstantiateAsync(path)
  self.req:completed("+", function(handle)
    if handle.isError then
      return
    end
    if self.spine == nil or IsNull(self.spine.transform) then
      handle:Destroy()
      return
    end
    local go = handle.gameObject
    local rectTransform = go:GetComponent(typeof(CS.UnityEngine.RectTransform))
    if rectTransform ~= nil then
      rectTransform:SetParent(self.spine.transform)
      rectTransform:Set_localScale(0.5, 0.5, 0.5)
      rectTransform:Set_anchoredPosition(0, 120)
    end
    go:SetActive(true)
  end)
  self.animator = self.gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
  if self.animator then
    self.animator.enabled = true
    self.animator:Play("Eff_UIMultipleParkourResult", 0, 0)
  end
  self.delay = TimerManager:GetInstance():DelayInvoke(function()
    self.delay = nil
    if self.animator then
      self.animator.enabled = false
    end
  end, 1.2)
end

function UIMultipleParkourResultView:DataDefine()
end

function UIMultipleParkourResultView:ComponentDestroy()
  if self.req then
    self.req:Destroy()
    self.req = nil
  end
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
  self.tip = nil
  self.alliance_rank_content = nil
  self.alliance_rank_title = nil
  self.alliance_rank_from = nil
  self.alliance_rank_to = nil
  self.server_rank_content = nil
  self.server_rank_title = nil
  self.server_rank_from = nil
  self.server_rank_to = nil
  self.best_result_title = nil
  self.best_result_value = nil
  self.result_title = nil
  self.result_value = nil
  self.new_record_bg = nil
  self.new_record = nil
  self.rank_title = nil
  self.rank_value = nil
  self.again_btn = nil
  self.again_btn_text = nil
  self.back_btn = nil
  self.back_btn_text = nil
  self.share_btn = nil
  self.spine = nil
end

function UIMultipleParkourResultView:DataDestroy()
end

function UIMultipleParkourResultView:ReInit()
  local resultData = DataCenter.MultipleParkourManager.endlessResultData
  if resultData == nil then
    return
  end
  local best = resultData.bestResult or 1
  local cur = resultData.curResult or 1
  local isNew = resultData.isNewResult
  if isNew then
    best = cur
  end
  local rank = resultData.curRank or 1
  self.passedLevel = DataCenter.MultipleParkourManager:GetPassedLevel()
  self.best_result_value:SetText(Localization:GetString("multiply_door_tips_029", best))
  self.result_value:SetText(Localization:GetString("multiply_door_tips_029", cur))
  self.rank_value:SetText(rank)
  self.new_record_bg:SetActive(isNew)
  local alncChange = false
  if resultData.alOldRank and resultData.alNewRank then
    alncChange = true
    local alncOld = resultData.alOldRank or 0
    if alncOld <= 0 then
      self.alliance_rank_from:SetText(Localization:GetString("361054"))
    else
      self.alliance_rank_from:SetText(alncOld)
    end
    self.alNewRank = resultData.alNewRank
    self.alliance_rank_to:SetText(resultData.alNewRank)
    self.alliance_rank_content:SetActive(true)
  end
  self.alncChange = alncChange
  local serverChange = false
  if resultData.serverOldRank and resultData.serverNewRank then
    serverChange = true
    local serverOld = resultData.serverOldRank or 0
    if serverOld <= 0 then
      self.server_rank_from:SetText(Localization:GetString("361054"))
    else
      self.server_rank_from:SetText(serverOld)
    end
    self.serverNewRank = resultData.serverNewRank
    self.server_rank_to:SetText(resultData.serverNewRank)
    self.server_rank_content:SetActive(true)
  end
  self.serverChange = serverChange
  if alncChange or serverChange then
    local key = DataCenter.MultipleParkourManager:GetNewRecordTip()
    if not string.IsNullOrEmpty(key) then
      self.tip:SetText(Localization:GetString(key))
    end
  else
    local key = DataCenter.MultipleParkourManager:GetNormalResultTip()
    if not string.IsNullOrEmpty(key) then
      self.tip:SetText(Localization:GetString(key))
    end
  end
end

function UIMultipleParkourResultView:OnBackBtnClick()
  self.ctrl:CloseSelf()
  DataCenter.MultipleParkourManager:Exit(function()
    if CS.SceneManager.IsInCity() then
      local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.MultipleParkour.Type)
      if actList and 0 < #actList then
        local actId = tonumber(actList[1].id)
        GoToUtil.GoActWindow({
          tonumber(actId)
        })
      else
        UIUtil.ShowTipsId(801141)
      end
    end
  end)
end

function UIMultipleParkourResultView:OnAgainBtnClick()
  local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.MultipleParkour.Type)
  if actList and 0 < #actList then
    if self.__waitingForMsg then
      UIUtil.ShowTips(Localization:GetString("multiply_door_tips_026"))
      return
    end
    self:SetWaitingForMsg()
    DataCenter.MultipleParkourManager:SimulatorSingleMatchEndless(true)
  else
    UIUtil.ShowTipsId(801141)
  end
end

function UIMultipleParkourResultView:OnShareBtnClick()
  local shareParam = {}
  shareParam.post = PostType.Activity_MultipleParkour
  shareParam.param = {}
  shareParam.param.win = true
  shareParam.param.topScore = top
  if self.serverChange then
    shareParam.param.serverRank = self.serverNewRank
  elseif self.alncChange then
    shareParam.param.alncRank = self.alNewRank
  else
    shareParam.param.passedLevel = self.passedLevel
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, shareParam)
end

function UIMultipleParkourResultView:SetWaitingForMsg()
  if not self.__waitingForMsg then
    self.__waitingForMsg = true
    if self.delayTimer then
      self.delayTimer:Stop()
    end
    self.delayTimer = TimerManager:GetInstance():GetTimer(6, function()
      self.__waitingForMsg = false
    end, self, true, true)
    self.delayTimer:Start()
  end
end

function UIMultipleParkourResultView:ClearWaitingForMsg()
  self.__waitingForMsg = false
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

return UIMultipleParkourResultView
