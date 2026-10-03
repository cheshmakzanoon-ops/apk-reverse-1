local p_img_circle_left_path = "military/p_img_circle_left"
local p_img_circle_right_path = "military/p_img_circle_right"
local p_btn_left_path = "military/p_btn_left"
local p_btn_right_path = "military/p_btn_right"
local p_text_military_name_path = "content_name/p_text_military_name"
local p_content_score_path = "p_content_score"
local p_content_rank_path = "p_content_rank"
local p_btn_score_icon_path = "p_content_score/base/p_btn_score_icon"
local p_text_military_score_path = "p_content_score/base/p_text_military_score"
local p_btn_rank_icon_path = "p_content_rank/base/p_btn_rank_icon"
local p_text_military_rank_path = "p_content_rank/base/p_text_military_rank"
local p_img_military_rank_change_path = "p_content_rank/base/p_img_military_rank_change"
local p_comp_military_path = "military/content_military/p_comp_military"
local p_comp_military_other_path = "military/content_military/p_comp_military_other"
local UILWSeasonMilitaryLevelComp = require("UI.LWSeason6.UILWSeasonMilitary.Comp.UILWSeasonMilitaryLevelComp")
local base = UIBaseContainer
local UILWSeasonMilitaryLevelPreviewComp = BaseClass("UILWSeasonMilitaryLevelPreviewComp", UIBaseContainer)

function UILWSeasonMilitaryLevelPreviewComp:ComponentDefine()
  self.p_text_military_name = self:AddComponent(UITextMeshProUGUIEx, p_text_military_name_path)
  self.p_img_circle_left = self:TryAddComponent(UIRawImage, p_img_circle_left_path)
  self.p_img_circle_right = self:TryAddComponent(UIRawImage, p_img_circle_right_path)
  self.p_comp_military = self:AddComponent(UILWSeasonMilitaryLevelComp, p_comp_military_path)
  self.p_comp_military_other = self:TryAddComponent(UILWSeasonMilitaryLevelComp, p_comp_military_other_path)
  self.p_comp_military:ResetAnim()
  if self.p_comp_military_other ~= nil then
    self.p_comp_military_other:ResetAnim()
  end
  self.p_content_score = self:TryAddComponent(UIBaseContainer, p_content_score_path)
  self.p_content_rank = self:TryAddComponent(UIBaseContainer, p_content_rank_path)
  self.p_btn_score_icon = self:TryAddComponent(UIButton, p_btn_score_icon_path)
  if self.p_btn_score_icon ~= nil then
    self.p_btn_score_icon:SetOnClick(BindCallback(self, self.OnScoreIconClicked))
  end
  self.p_text_military_score = self:TryAddComponent(UITextMeshProUGUIEx, p_text_military_score_path)
  self.p_btn_rank_icon = self:TryAddComponent(UIButton, p_btn_rank_icon_path)
  if self.p_btn_rank_icon ~= nil then
    self.p_btn_rank_icon:SetOnClick(BindCallback(self, self.OnRankIconClicked))
  end
  self.p_text_military_rank = self:TryAddComponent(UITextMeshProUGUIEx, p_text_military_rank_path)
  self.p_img_military_rank_change = self:TryAddComponent(UIImage, p_img_military_rank_change_path)
  self.p_btn_left = self:AddComponent(UIButton, p_btn_left_path)
  self.p_btn_left:SetOnClick(BindCallback(self, self.OnLeftClicked))
  self.p_btn_right = self:AddComponent(UIButton, p_btn_right_path)
  self.p_btn_right:SetOnClick(BindCallback(self, self.OnRightClicked))
end

function UILWSeasonMilitaryLevelPreviewComp:ComponentDestroy()
  self.p_img_circle_left = nil
  self.p_img_circle_right = nil
  self.p_comp_military = nil
  self.p_comp_military_other = nil
  self.p_btn_left = nil
  self.p_btn_right = nil
  self.p_text_military_name = nil
  self.p_text_military_score = nil
  self.p_content_score = nil
  self.p_content_rank = nil
  self.p_btn_score_icon = nil
  self.p_btn_rank_icon = nil
  self.p_text_military_rank = nil
  self.p_img_military_rank_change = nil
end

function UILWSeasonMilitaryLevelPreviewComp:DataDefine()
  self.ImgRankUp = "Assets/Main/SeasonRes/S6/Sprites/Military/FX_xiangqing_common_jiantou1_icon.png"
  self.ImgRankDown = "Assets/Main/SeasonRes/S6/Sprites/Military/FX_xiangqing_common_jiantou2_icon.png"
  self.IsPlayingAnim = false
end

function UILWSeasonMilitaryLevelPreviewComp:DataDestroy()
  self.IsPlayingAnim = false
  if self.AnimTimer ~= nil then
    self.AnimTimer:Stop()
    self.AnimTimer = nil
  end
end

function UILWSeasonMilitaryLevelPreviewComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonMilitaryLevelPreviewComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMilitaryLevelPreviewComp:OnAddListener()
  base.OnAddListener(self)
end

function UILWSeasonMilitaryLevelPreviewComp:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWSeasonMilitaryLevelPreviewComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function UILWSeasonMilitaryLevelPreviewComp:InitData(data)
  if data ~= nil then
    self.InfoData = DataCenter.SeasonMilitaryManager.InfoData
    if self.InfoData ~= nil then
      self.OldLevel = DataCenter.SeasonMilitaryManager.AnimLevel
      self.Level = checknumber(data.Level)
      self.MinLevel = checknumber(data.MinLevel)
      self.MaxLevel = checknumber(data.MaxLevel)
      self.ShowSwitch = data.ShowSwitch
      self.EventId = checknumber(data.EventId) > 0 and checknumber(data.EventId) or EventId.SeasonMilitaryLevelPreview
      if self.cur_active_comp == nil then
        self.cur_active_comp = self.p_comp_military
      end
      return true
    end
  end
  return false
end

function UILWSeasonMilitaryLevelPreviewComp:InitUi()
  if self.p_text_military_rank ~= nil then
    local rank = self.InfoData:GetRank()
    if 0 < rank then
      self.p_text_military_rank:SetText(string.GetFormattedSeparatorNum(rank))
    else
      self.p_text_military_rank:SetLocalText("2800058")
    end
  end
  if self.p_text_military_score ~= nil then
    self.p_text_military_score:SetText(string.GetFormattedSeparatorNum(self.InfoData:GetScore()))
  end
end

function UILWSeasonMilitaryLevelPreviewComp:UpdateData()
  self.Cell = DataCenter.SeasonMilitaryManager:GetLevelCellTmp(self.Level)
  self.HasPre = self.MinLevel < self.Level
  self.HasNext = self.Level < self.MaxLevel
  return self.Cell ~= nil
end

function UILWSeasonMilitaryLevelPreviewComp:UpdateUi()
  self.p_btn_left:SetActive(self.ShowSwitch and self.HasPre)
  self.p_btn_right:SetActive(self.ShowSwitch and self.HasNext)
  if self.p_content_score ~= nil then
    self.p_content_score:SetActive(not self.ShowSwitch)
  end
  if self.p_content_rank ~= nil then
    self.p_content_rank:SetActive(not self.ShowSwitch)
  end
  self.p_text_military_name:SetLocalText(self.Cell:GetName())
  if self.OldLevel <= 0 or self.OldLevel == self.Level or self.p_comp_military_other == nil then
    if self.cur_active_comp == nil then
      self.cur_active_comp = self.p_comp_military
    end
    self.p_comp_military:SetActive(self.cur_active_comp == self.p_comp_military)
    if self.p_comp_military_other ~= nil then
      self.p_comp_military_other:SetActive(self.cur_active_comp == self.p_comp_military_other)
    end
    self.cur_active_comp:ReInit(self.Level)
  else
    local isNext = self.Level > self.OldLevel
    local next_comp = self.cur_active_comp == self.p_comp_military and self.p_comp_military_other or self.p_comp_military
    self.IsPlayingAnim = true
    if self.AnimTimer ~= nil then
      self.AnimTimer:Stop()
      self.AnimTimer = nil
    end
    local _, outTime = self.cur_active_comp:PlayAnimationReturnTime(isNext and "leftout" or "rightout")
    outTime = checknumber(outTime)
    self.AnimTimer = TimerManager:GetInstance():DelayInvoke(function()
      if IsNull(self.gameObject) then
        return
      end
      next_comp:SetActive(true)
      next_comp:ReInit(self.Level)
      local _, inTime = next_comp:PlayAnimationReturnTime(isNext and "leftin" or "rightin")
      inTime = checknumber(inTime)
      self.AnimTimer = TimerManager:GetInstance():DelayInvoke(function()
        if IsNull(self.gameObject) then
          return
        end
        self.cur_active_comp:SetActive(false)
        self.cur_active_comp = next_comp
        self.IsPlayingAnim = false
        self.AnimTimer = nil
      end, math.max(inTime, 0.05))
    end, math.max(outTime, 0.05))
  end
  self.OldLevel = self.Level
  DataCenter.SeasonMilitaryManager.AnimLevel = self.Level
  self:UpdateRankImg()
end

function UILWSeasonMilitaryLevelPreviewComp:UpdateRankImg()
  if self.p_img_military_rank_change ~= nil then
    local active = false
    local imgPath = ""
    if self.InfoData ~= nil then
      local lastDayRank = self.InfoData:GetLastDayRank()
      local rank = self.InfoData:GetRank()
      active = 0 < lastDayRank and 0 < rank and lastDayRank ~= rank
      if active then
        if lastDayRank < rank then
          imgPath = self.ImgRankDown
        else
          imgPath = self.ImgRankUp
        end
      end
    end
    self.p_img_military_rank_change:SetActive(active)
    if active and not string.IsNullOrEmpty(imgPath) then
      self.p_img_military_rank_change:LoadSpriteAsync(imgPath)
    end
  end
end

function UILWSeasonMilitaryLevelPreviewComp:OnScoreIconClicked()
  local param = {}
  param.ConfigId = DataCenter.SeasonMilitaryEliteManager.RankType.Person_All
  UIManager:GetInstance():OpenWindow(UIWindowNames.S6MilitaryEliteScoreTipsView, {anim = true}, param)
end

function UILWSeasonMilitaryLevelPreviewComp:OnRankIconClicked()
  local desc = CS.GameEntry.Localization:GetString("season_military_tips_rank_desc")
  local position = self.p_btn_rank_icon.transform.position
  local isTop = true
  UIUtil.ShowBubbleTipsAuto(desc, position, 0, 25, 0, nil, nil, {reversal = isTop})
end

function UILWSeasonMilitaryLevelPreviewComp:OnLeftClicked()
  if self.IsPlayingAnim then
    return
  end
  if self.ShowSwitch and self.HasPre then
    EventManager:GetInstance():Broadcast(self.EventId, self.Level - 1)
  end
end

function UILWSeasonMilitaryLevelPreviewComp:OnRightClicked()
  if self.IsPlayingAnim then
    return
  end
  if self.ShowSwitch and self.HasNext then
    EventManager:GetInstance():Broadcast(self.EventId, self.Level + 1)
  end
end

return UILWSeasonMilitaryLevelPreviewComp
