local base = UIBaseContainer
local SeasonRankCampS6 = BaseClass("SeasonRankCampS6", UIBaseContainer)

function SeasonRankCampS6:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function SeasonRankCampS6:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonRankCampS6:ComponentDefine()
  local name1_path = "camp1/name1"
  local rank1_path = "camp1/value1"
  local name2_path = "camp2/name2"
  local rank2_path = "camp2/value2"
  local openAnimator_path = ""
  local icon1_path = "camp1/name1/icon1"
  local icon2_path = "camp2/name2/icon2"
  self.name1 = self:AddComponent(UITextMeshProUGUIEx, name1_path)
  self.rank1 = self:AddComponent(UITextMeshProUGUIEx, rank1_path)
  self.name2 = self:AddComponent(UITextMeshProUGUIEx, name2_path)
  self.rank2 = self:AddComponent(UITextMeshProUGUIEx, rank2_path)
  self.openAnimator = self:AddComponent(UIAnimator, openAnimator_path)
  self.icon1 = self:AddComponent(UIImage, icon1_path)
  self.icon2 = self:AddComponent(UIImage, icon2_path)
  self.rank1:OnPointerClick(function(eventData)
    self:OnPowerLinkClicked(self.rank1, eventData.position)
  end)
  self.rank2:OnPointerClick(function(eventData)
    self:OnPowerLinkClicked(self.rank2, eventData.position)
  end)
end

function SeasonRankCampS6:ComponentDestroy()
  self.red_diban = nil
  self.blue_diban = nil
  self.name1 = nil
  self.rank1 = nil
  self.name2 = nil
  self.rank2 = nil
  self.openAnimator = nil
  self.icon1 = nil
  self.icon2 = nil
end

function SeasonRankCampS6:GetScoreInfo(scoreTable)
  local info = {}
  info.Score = 0
  info.BuildingScore = 0
  info.DestroyScore = 0
  if not table.IsNullOrEmpty(scoreTable) then
    info.Score = checknumber(scoreTable.campScore)
    info.DestroyScore = checknumber(scoreTable.destroyForce)
    info.BuildingScore = Mathf.Max(0, info.Score - info.DestroyScore)
  end
  return info
end

function SeasonRankCampS6:GetLinkText(linkId, text)
  return string.format("<link=%s>%s</link>", linkId, text)
end

function SeasonRankCampS6:Refresh(data)
  DataCenter.LWSoundManager:PlaySound(6100044, false)
  local mgr = DataCenter.SeasonFactionWarDataManager
  self.CampScoreInfo1 = self:GetScoreInfo(data.campScore1)
  self.CampScoreInfo2 = self:GetScoreInfo(data.campScore2)
  self.rank1:SetText(string.GetFormattedSeparatorNum(self.CampScoreInfo1.Score))
  self.rank1:SetText(self:GetLinkText("s6_camp_score_detail_1", string.GetFormattedSeparatorNum(self.CampScoreInfo1.Score)))
  self.rank2:SetText(string.GetFormattedSeparatorNum(self.CampScoreInfo2.Score))
  self.rank2:SetText(self:GetLinkText("s6_camp_score_detail_2", string.GetFormattedSeparatorNum(self.CampScoreInfo2.Score)))
  self.name1:SetText(mgr:GetCampName(SeasonFactionType.Rebels))
  self.name2:SetText(mgr:GetCampName(SeasonFactionType.Gendarmerie))
  local myCampId = mgr.myCampId
  self.icon1:SetActive(myCampId == SeasonFactionType.Rebels)
  self.icon2:SetActive(myCampId == SeasonFactionType.Gendarmerie)
  self.animation = self.transform:GetComponent(typeof(CS.SimpleAnimation))
  if IsNotNull(self.animation) then
    self.red = self.CampScoreInfo1.Score >= self.CampScoreInfo2.Score
    if self.red then
      self.animation:Play("leftflag")
    else
      self.animation:Play("rightflag")
    end
  end
  self:RefreshAnimation()
end

function SeasonRankCampS6:RefreshAnimation()
  if self.red then
    self.openAnimator:Play("V_CampRank_red_anim")
  else
    self.openAnimator:Play("V_CampRank_blue_anim")
  end
end

function SeasonRankCampS6:OnPowerLinkClicked(rankTxt, clickPos)
  if IsNull(rankTxt) then
    return
  end
  local linkId = rankTxt:TryGetPointerClickLinkID(clickPos)
  if linkId == "s6_camp_score_detail_1" then
    self:ShowTips(self.CampScoreInfo1, rankTxt)
  elseif linkId == "s6_camp_score_detail_2" then
    self:ShowTips(self.CampScoreInfo2, rankTxt)
  end
end

function SeasonRankCampS6:ShowTips(scoreInfo, trans)
  local param = {}
  param.alignObject = trans
  param.yPosFix = 0
  param.showArrow = true
  param.preferTop = false
  param.score = string.GetFormattedSeparatorNum(scoreInfo.Score)
  param.buildingScore = string.GetFormattedSeparatorNum(scoreInfo.BuildingScore)
  param.destroyScore = string.GetFormattedSeparatorNum(scoreInfo.DestroyScore)
  UIManager:GetInstance():OpenWindow(UIWindowNames.S6CampRankScoreTips, {anim = true}, param)
end

return SeasonRankCampS6
