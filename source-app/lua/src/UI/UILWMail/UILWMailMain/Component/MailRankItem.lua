local MailRankItem = BaseClass("MailRankItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function MailRankItem:OnCreate()
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
  self.countryFlag = self:AddComponent(UIImage, "UIPlayerHead/countryFlag")
  self.playerHead:SetEnableClickShowInfo(true, true)
  self.playerLv = self:AddComponent(UIText, "playerLv")
  self.itemFlagIcon = self:AddComponent(UIImage, "ItemFlagIcon")
  self.pointRect = self:AddComponent(UIBaseContainer, "pointBg/pointRect")
  self.pointTxt = self:AddComponent(UIText, "pointBg/pointTxt")
  self.scoreTxt = self:AddComponent(UIText, "PointsText")
  self.itemIcon = self:AddComponent(UIImage, "ItemIcon")
end

function MailRankItem:OnDestroy()
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
  self.countryFlag = nil
  self.playerLv = nil
  self.pointRect = nil
  self.pointTxt = nil
  self.scoreTxt = nil
  self.itemIcon = nil
end

function MailRankItem:SetData(dataInfo, maxScore, selfType)
  if not dataInfo then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.dataInfo = dataInfo
  self.maxScore = maxScore
  local isSelf = selfType == true
  self.isSelfBg:SetActive(isSelf)
  self.isOtherBg:SetActive(not isSelf)
  if self.dataInfo.rank <= 0 then
    self.rankingBg:SetActive(false)
    self.rankingText:SetActive(false)
  else
    self.rankingBg:SetActive(self.dataInfo.rank <= 3)
    self.rankingText:SetActive(true)
    if self.dataInfo.rank <= 3 then
      self.rankingBg:LoadSprite(string.format("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_%d.png", self.dataInfo.rank))
    end
    self.rankingText:SetText(self.dataInfo.rank)
  end
  local color = Color.New(0, 0, 0, 1)
  if isSelf then
    color = Color.New(0.2901960784313726, 0.5764705882352941, 0.15294117647058825, 1)
  elseif self.dataInfo.rank == 1 then
    self.isOtherBg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_jinsetiao.png")
    color = Color.New(0.8156862745098039, 0.4823529411764706, 0.047058823529411764, 1)
  elseif self.dataInfo.rank == 2 then
    self.isOtherBg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_yinsetiao.png")
    color = Color.New(0.4, 0.4549019607843137, 0.7294117647058823, 1)
  elseif self.dataInfo.rank == 3 then
    self.isOtherBg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_tongsetiao.png")
    color = Color.New(0.7176470588235294, 0.4666666666666667, 0.34509803921568627, 1)
  else
    self.isOtherBg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_huisetiao.png")
  end
  self.playerNameText:SetColor(color)
  local scoreNum = self.dataInfo.score
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
  self.pointTxt:SetText(scoreNum)
  if dataInfo and dataInfo.activityId then
    local actData = DataCenter.ActivityListDataManager:GetActivityDataById(dataInfo.activityId)
    if actData and actData.type == EnumActivity.ActValentineSendGift.Type then
      local temp = DataCenter.ValentineDataManager:GetActSendTempByActId(dataInfo.activityId)
      if temp and tonumber(scoreNum) > temp.rank_max_score then
        scoreNum = temp.rank_max_score .. "+"
      end
    end
  end
  self.scoreTxt:SetText(scoreNum)
  local iconName = "zyf_yanhuujifen_icon_daoju.png"
  if dataInfo.iconName then
    iconName = dataInfo.iconName
  else
    local activityId = dataInfo.activityId
    local activityTemp, activitySubTemp
    if activityId and 0 < activityId then
      activityTemp = LocalController:instance():getLine(TableName.Activity, toInt(activityId))
    end
    if activityTemp then
      activitySubTemp = LocalController:instance():getLine(activityTemp.tableInfo, toInt(activityTemp.tableInfoType))
    end
    if activitySubTemp and activitySubTemp.score_pic then
      iconName = activitySubTemp.score_pic
    end
  end
  self.itemIcon:LoadSprite(string.format(LoadPath.ItemPath, iconName))
  if self.dataInfo.rankType == MailRankType.Player then
    local playerData = self.dataInfo.playerData
    self.gender:SetActive(false)
    self.playerHead:SetActive(true)
    self.itemFlagIcon:SetActive(false)
    local serverId = playerData.serverId
    if serverId then
      if not string.IsNullOrEmpty(playerData.alAbbr) then
        self.playerNameText:SetText(string.format("#%s [%s]%s", serverId, playerData.alAbbr, playerData.name))
      else
        self.playerNameText:SetText("#" .. serverId .. " " .. playerData.name)
      end
    elseif not string.IsNullOrEmpty(playerData.alAbbr) then
      self.playerNameText:SetText(string.format("[%s]%s", playerData.alAbbr, playerData.name))
    else
      self.playerNameText:SetText(playerData.name)
    end
    local nationTemplate = playerData:GetCountryFlagTemplate()
    if nationTemplate then
      self.countryFlag:SetActive(true)
      self.countryFlag:LoadSprite(nationTemplate:GetNationFlagPath())
    else
      self.countryFlag:SetActive(false)
    end
    self.playerHead:SetData(playerData.uid, playerData.pic, playerData.picVer, nil, playerData:GetHeadBgImg())
    self.playerLv:SetText(playerData.level)
  elseif self.dataInfo.rankType == MailRankType.Alliance then
    local rankData = self.dataInfo.rankData
    self.gender:SetActive(false)
    self.playerHead:SetActive(false)
    self.itemFlagIcon:SetActive(true)
    self.itemFlagIcon:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, rankData.icon))
    self.playerNameText:SetText(string.format("[%s]%s", rankData.abbr, rankData.alliancename))
    self.playerLv:SetText("")
  end
end

return MailRankItem
