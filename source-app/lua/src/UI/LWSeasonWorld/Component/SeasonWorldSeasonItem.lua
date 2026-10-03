local SeasonWorldSeasonItem = BaseClass("SeasonWorldSeasonItem", UIBaseContainer)
local base = UIBaseContainer
local bg_path = "btn/bg"
local btn_path = "btn"
local img_banner_path = "btn/img_banner"
local img_season_path = "btn/img_season"
local select_path = "select"
local state_complete_path = "state_complete"
local state_progress_path = "state_progress"
local state_comming_path = "state_comming"
local state_expect_path = "state_expect"
local state_not_path = "state_not"
local SeasonBannerPath = "Assets/Main/Sprites/UI/LWSeasonWorld/ljq_s4_huanraodiqiu_yeqian_kong.png"
local SeasonBgPath = {
  [1] = "Assets/Main/Sprites/UI/LWSeasonWorld/ljq_s4_huanraodiqiu_yeqian_bg.png",
  [2] = "Assets/Main/Sprites/UI/LWSeasonWorld/ljq_s4_huanraodiqiu_yeqian_hui_bg.png"
}
local SeasonItemState = {
  None = 0,
  Complete = 1,
  Progress = 2,
  Comming = 3,
  Expect = 4,
  Not = 5
}

function SeasonWorldSeasonItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.state = SeasonItemState.None
end

function SeasonWorldSeasonItem:OnDestroy()
  self.template = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonWorldSeasonItem:ComponentDefine()
  self.btn = self:AddComponent(UIButton, btn_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.img_banner = self:AddComponent(UIImage, img_banner_path)
  self.img_season = self:AddComponent(UIImage, img_season_path)
  self.select = self:AddComponent(UIImage, select_path)
  self.state_complete = self:AddComponent(UIBaseContainer, state_complete_path)
  self.state_progress = self:AddComponent(UIBaseContainer, state_progress_path)
  self.state_comming = self:AddComponent(UIBaseContainer, state_comming_path)
  self.state_expect = self:AddComponent(UIBaseContainer, state_expect_path)
  self.state_not = self:AddComponent(UIBaseContainer, state_not_path)
  self.btn:SetOnClick(BindCallback(self, self.ClickBtn))
end

function SeasonWorldSeasonItem:ComponentDestroy()
  self.bg = nil
  self.btn = nil
  self.img_banner = nil
  self.img_season = nil
  self.select = nil
  self.state_complete = nil
  self.state_progress = nil
  self.state_comming = nil
  self.state_expect = nil
  self.state_not = nil
end

function SeasonWorldSeasonItem:ReInit(template)
  self.template = template
  self:RefreshState()
  self:SetSelect(false)
  self.state_complete:SetActive(self.state == SeasonItemState.Complete)
  self.state_progress:SetActive(self.state == SeasonItemState.Progress)
  self.state_comming:SetActive(self.state == SeasonItemState.Comming)
  self.state_expect:SetActive(self.state == SeasonItemState.Expect)
  self.state_not:SetActive(self.state == SeasonItemState.Not)
  local gray = self.state == SeasonItemState.Expect or self.state == SeasonItemState.Not
  if not string.IsNullOrEmpty(template.small_banner) then
    if self.state ~= SeasonItemState.Not then
      self.img_banner:LoadSprite(template.small_banner)
    else
      self.img_banner:LoadSprite(SeasonBannerPath)
    end
    CS.UIGray.SetGray(self.img_banner.transform, gray, true)
  end
  self.bg:LoadSprite(gray and SeasonBgPath[2] or SeasonBgPath[1])
  local showImgSeason = not string.IsNullOrEmpty(template.small_banner_season) and self.state ~= SeasonItemState.Not
  self.img_season:SetActive(showImgSeason)
  if showImgSeason then
    self.img_season:LoadSprite(template.small_banner_season)
  end
end

function SeasonWorldSeasonItem:RefreshState()
  local condition = self.template:Condition()
  if not condition then
    self.state = SeasonItemState.Not
    return
  end
  local curSeason = SeasonUtil.GetSeason()
  local preMode = SeasonUtil.IsInSeasonPrepareMode(true)
  local isInSeason = SeasonUtil.IsInSeason()
  local data = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  local isTruce = data:InTruceMode()
  if self.template.season == 0 then
    if curSeason == self.template.season then
      self.state = SeasonItemState.Progress
    else
      self.state = SeasonItemState.Complete
    end
  elseif preMode and curSeason + 1 == self.template.season then
    self.state = SeasonItemState.Comming
  elseif (preMode or isTruce) and curSeason == self.template.season or curSeason > self.template.season then
    self.state = SeasonItemState.Complete
  elseif isInSeason and curSeason == self.template.season then
    self.state = SeasonItemState.Progress
  else
    self.state = SeasonItemState.Expect
  end
end

function SeasonWorldSeasonItem:SetSelect(isSelect)
  self.select.gameObject:SetActive(isSelect)
end

function SeasonWorldSeasonItem:ClickBtn()
  if not self.template:Condition() or not self.template.activeModel then
    UIUtil.ShowTipsId("season_travel_world_ui_07")
    return
  end
  self.view:OnClickItem(self.template)
end

return SeasonWorldSeasonItem
