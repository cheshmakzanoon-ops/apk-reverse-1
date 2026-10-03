local UIPersonalArmsRankItem = BaseClass("UIPersonalArmsRankItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIPersonalArmsRewardTipView = require("UI.UIActivityPersonalArms.UIPersonalArmsRewardTip.View.UIPersonalArmsRewardTipView")
local BOX_ICON_NAME_PREFIX = "lrb_zhouliuhuodong_baoxiangkai_0"
local SHOW_REWARD_RANK_NUM = 15

function UIPersonalArmsRankItem:OnCreate()
  base.OnCreate(self)
  self.isOtherBg = self:AddComponent(UIImage, "IsOtherBg")
  self.isSelfBg = self:AddComponent(UIImage, "IsSelfBg")
  self.rankingBg = self:AddComponent(UIImage, "RankingBg")
  self.rankingText = self:AddComponent(UIText, "RankingText")
  self.playerNameText = self:AddComponent(UIText, "GenderNameGroup/PlayerNameText")
  self.gender = self:AddComponent(UIBaseContainer, "GenderNameGroup/Gender")
  self.maleGender = self:AddComponent(UIBaseContainer, "GenderNameGroup/Gender/Man")
  self.femaleGender = self:AddComponent(UIBaseContainer, "GenderNameGroup/Gender/Woman")
  self.playerHead = self:AddComponent(UICommonHead, "UIPlayerHead")
  self.playerHead:SetEnableClickShowInfo(true, true)
  self.playerLv = self:AddComponent(UIText, "playerLv")
  self.rewardBtn = self:AddComponent(UIButton, "rewardBtn")
  self.rewardBtn:SetOnClick(function()
    self:RewardBtnClickFunc()
  end)
  self.imgReward = self:AddComponent(UIImage, "rewardBtn")
  self.pointRect = self:AddComponent(UIBaseContainer, "pointBg/pointRect")
  self.pointTxt = self:AddComponent(UIText, "pointBg/pointTxt")
  self.imgUp = self:AddComponent(UIBaseContainer, "imgUp")
  self.imgDown = self:AddComponent(UIBaseContainer, "imgDown")
  self.txtUp = self:AddComponent(UIText, "txtUp")
  self.txtDown = self:AddComponent(UIText, "txtDown")
end

function UIPersonalArmsRankItem:OnDestroy()
  base.OnDestroy(self)
  self.isOtherBg = nil
  self.isSelfBg = nil
  self.rankingBg = nil
  self.rankingText = nil
  self.playerNameText = nil
  self.gender = nil
  self.maleGender = nil
  self.femaleGender = nil
  self.playerHead = nil
  self.playerLv = nil
  self.rewardBtn = nil
  self.pointRect = nil
  self.pointTxt = nil
  self.imgUp = nil
  self.imgDown = nil
  self.txtUp = nil
  self.txtDown = nil
end

function UIPersonalArmsRankItem:SetData(playerInfo, maxScore, actId, selfType)
  if not playerInfo then
    self:SetActive(false)
    return
  end
  local serverId = playerInfo.serverId or playerInfo.server
  self:SetActive(true)
  self.playerData = playerInfo
  self.maxScore = maxScore
  self.actId = actId
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.playerData.uid, self.playerData.name)
  if serverId then
    if not string.IsNullOrEmpty(self.playerData.alAbbr) then
      self.playerNameText:SetText(string.format("#%s [%s]%s", serverId, self.playerData.alAbbr, showName))
    else
      self.playerNameText:SetText("#" .. serverId .. " " .. showName)
    end
  elseif not string.IsNullOrEmpty(self.playerData.alAbbr) then
    self.playerNameText:SetText(string.format("[%s]%s", self.playerData.alAbbr, showName))
  else
    self.playerNameText:SetText(showName)
  end
  if self.playerData.gender == 0 or self.playerData.gender == 3 then
    self.gender:SetActive(false)
  else
    self.gender:SetActive(true)
    self.maleGender:SetActive(self.playerData.gender == 1)
    self.femaleGender:SetActive(self.playerData.gender == 2)
  end
  local isSelf = selfType == true
  self.isSelfBg:SetActive(isSelf)
  self.isOtherBg:SetActive(not isSelf)
  local color = Color.New(0.16470588235294117, 0.1568627450980392, 0.18823529411764706, 1)
  if isSelf then
    color = Color.New(0.2901960784313726, 0.5764705882352941, 0.15294117647058825, 1)
  end
  self.playerNameText:SetColor(color)
  local rewardData = DataCenter.ActivityPersonalArmsDataManager:GetRewardsDataByActIdAndRank(tostring(self.actId), self.playerData.rank)
  if rewardData ~= nil and 0 < self.playerData.score and self.playerData.rank <= SHOW_REWARD_RANK_NUM then
    self.rewardBtn:SetActive(true)
    local boxGrade = DataCenter.ActivityPersonalArmsDataManager:GetRankGradeByActIdAndRank(tostring(self.actId), self.playerData.rank)
    local iconPath = string.format(LoadPath.UIPersonalArms, BOX_ICON_NAME_PREFIX .. boxGrade)
    self.imgReward:LoadSprite(iconPath)
    self.imgReward:SetLocalScaleXYZ(1, 1, 1)
  else
    self.rewardBtn:SetActive(false)
  end
  if 0 >= self.playerData.rank then
    self.rankingBg:SetActive(false)
    self.rankingText:SetActive(false)
  else
    self.rankingBg:SetActive(3 >= self.playerData.rank)
    if self.BtnDetail ~= nil then
      self.BtnDetail:SetActive(not showSelfTag and 3 >= self.playerData.rank)
    end
    self.rankingText:SetActive(true)
    if 3 >= self.playerData.rank then
      self.rankingBg:LoadSprite(string.format("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_%d.png", self.playerData.rank))
    end
    local showRanking = self.playerData.rank
    if 100 < showRanking then
      showRanking = "100+"
    end
    self.rankingText:SetText(self.playerData.rank)
  end
  local scoreNum = self.playerData.score
  local maxScoreNum = self.maxScore
  if maxScoreNum <= 0 then
    maxScoreNum = 1
  end
  local progress = scoreNum / maxScoreNum
  if 1 < progress then
    progress = 1
  end
  local progressWidth = 320
  local size = self.pointRect:GetSizeDelta()
  self.pointRect:SetSizeDeltaXY(progressWidth * progress, size.y)
  self.pointTxt:SetText(string.GetFormattedSeparatorNum(scoreNum))
  self.playerHead:SetData(self.playerData.uid, self.playerData.pic, self.playerData.picVer, nil, self.playerData:GetHeadBgImg())
  self.playerHead:SetFlag(self.playerData.countryFlag)
  self.playerLv:SetText(self.playerData.level)
end

function UIPersonalArmsRankItem:RewardBtnClickFunc()
  local rewardData = DataCenter.ActivityPersonalArmsDataManager:GetRewardsDataByActIdAndRank(tostring(self.actId), self.playerData.rank)
  if rewardData then
    local param = UIPersonalArmsRewardTipView.ParamDataClass.New()
    param.position = self.rewardBtn:GetPosition()
    param.deltaX = -110
    if CommonUtil.IsArabicAutoMirrorOpen() then
      param.dir = UIPersonalArmsRewardTipView.Direction.LEFT
    else
      param.dir = UIPersonalArmsRewardTipView.Direction.RIGHT
    end
    param.rewardList = rewardData.rewards
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPersonalArmsRewardTip, {anim = false}, param)
  end
end

return UIPersonalArmsRankItem
