local base = UIBaseContainer
local UIRevivalPlanRankItemComponent = BaseClass("UIRevivalPlanRankItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UICommonHead = require("Framework.UI.Component.UICommonHead")

function UIRevivalPlanRankItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIRevivalPlanRankItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIRevivalPlanRankItemComponent:ComponentDefine()
  self.imgIsOtherBg = self:AddComponent(UIImage, "IsOtherBg")
  self.imgIsSelfBg = self:AddComponent(UIImage, "IsSelfBg")
  self.imgRankingBg = self:AddComponent(UIImage, "RankingBg")
  self.textRanking = self:AddComponent(UIText, "RankingText")
  self.textPlayerName = self:AddComponent(UIText, "GenderNameGroup/PlayerNameText")
  self.compGender = self:AddComponent(UIBaseContainer, "GenderNameGroup/Gender")
  self.compMan = self:AddComponent(UIBaseContainer, "GenderNameGroup/Gender/Man")
  self.compWoman = self:AddComponent(UIBaseContainer, "GenderNameGroup/Gender/Woman")
  self.textPoints = self:AddComponent(UIText, "PointsText")
  self.imgSelfTagBg = self:AddComponent(UIImage, "SelfTagBg")
  self.compUIPlayerHead = self:AddComponent(UICommonHead, "UIPlayerHead")
  self.imgCountryFlag = self:AddComponent(UIImage, "UIPlayerHead/countryFlag")
  self.compUIPlayerHead:SetEnableClickShowInfo(true)
end

function UIRevivalPlanRankItemComponent:ComponentDestroy()
  self.imgIsOtherBg = nil
  self.imgIsSelfBg = nil
  self.imgRankingBg = nil
  self.textRanking = nil
  self.textPlayerName = nil
  self.compGender = nil
  self.compMan = nil
  self.compWoman = nil
  self.textPoints = nil
  self.imgSelfTagBg = nil
  self.compUIPlayerHead = nil
  self.imgCountryFlag = nil
end

function UIRevivalPlanRankItemComponent:DataDefine()
end

function UIRevivalPlanRankItemComponent:DataDestroy()
end

function UIRevivalPlanRankItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIRevivalPlanRankItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIRevivalPlanRankItemComponent:SetData(playerInfo, showSelfTag)
  if not playerInfo then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.playerData = playerInfo
  if not string.IsNullOrEmpty(self.playerData.alAbbr) then
    local txt = UIUtil.FormatAllianceAndName(self.playerData.alAbbr, self.playerData.name)
    self.textPlayerName:SetText(txt)
  else
    self.textPlayerName:SetText(self.playerData.name)
  end
  if self.playerData.gender == 0 or self.playerData.gender == 3 then
    self.compGender:SetActive(false)
  else
    self.compGender:SetActive(true)
    self.compMan:SetActive(self.playerData.gender == 1)
    self.compWoman:SetActive(self.playerData.gender == 2)
  end
  local isSelf = LuaEntry.Player:GetUid() == self.playerData.uid
  self.imgIsSelfBg:SetActive(isSelf)
  self.imgIsOtherBg:SetActive(not isSelf)
  self.imgSelfTagBg:SetActive(isSelf and showSelfTag)
  if 0 >= self.playerData.ranking then
    self.imgRankingBg:SetActive(false)
    self.textRanking:SetActive(false)
  else
    self.imgRankingBg:SetActive(3 >= self.playerData.ranking)
    self.textRanking:SetActive(true)
    if 3 >= self.playerData.ranking then
      self.imgRankingBg:LoadSprite(string.format("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_%d.png", self.playerData.ranking))
    end
    local showRanking = self.playerData.ranking
    if 100 < showRanking then
      showRanking = "100+"
    end
    self.textRanking:SetText(self.playerData.ranking)
  end
  self.textPoints:SetLocalText(2000239, self.playerData.score)
  local nationTemplate = self.playerData:GetCountryFlagTemplate()
  if nationTemplate then
    self.imgCountryFlag:SetActive(true)
    self.imgCountryFlag:LoadSprite(nationTemplate:GetNationFlagPath())
  else
    self.imgCountryFlag:SetActive(false)
  end
  self.compUIPlayerHead:SetData(self.playerData.uid, self.playerData.pic, self.playerData.picVer, nil, self.playerData:GetHeadBgImg())
end

return UIRevivalPlanRankItemComponent
