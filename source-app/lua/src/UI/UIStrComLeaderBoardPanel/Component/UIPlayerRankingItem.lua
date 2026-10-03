local UIPlayerRankingItem = BaseClass("UIPlayerRankingItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function DataDefine(self)
end

local function ComponentDefine(self)
  self.isOtherBg = self:AddComponent(UIImage, "IsOtherBg")
  self.isSelfBg = self:AddComponent(UIImage, "IsSelfBg")
  self.rankingBg = self:AddComponent(UIImage, "RankingBg")
  self.rankingText = self:AddComponent(UIText, "RankingText")
  self.playerNameText = self:AddComponent(UIText, "GenderNameGroup/PlayerNameText")
  self.gender = self:AddComponent(UIBaseContainer, "GenderNameGroup/Gender")
  self.maleGender = self:AddComponent(UIBaseContainer, "GenderNameGroup/Gender/Man")
  self.femaleGender = self:AddComponent(UIBaseContainer, "GenderNameGroup/Gender/Woman")
  self.pointsText = self:AddComponent(UIText, "PointsText")
  self.selfTag = self:AddComponent(UIImage, "SelfTagBg")
  self.playerHead = self:AddComponent(UICommonHead, "UIPlayerHead")
  self.countryFlag = self:AddComponent(UIImage, "UIPlayerHead/countryFlag")
end

local function DataDestroy(self)
end

local function ComponentDestroy(self)
  self.isOtherBg = nil
  self.isSelfBg = nil
  self.rankingBg = nil
  self.rankingText = nil
  self.playerNameText = nil
  self.gender = nil
  self.maleGender = nil
  self.femaleGender = nil
  self.pointsText = nil
  self.selfTag = nil
  self.playerHead = nil
  self.countryFlag = nil
end

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  base.OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
end

local function SetData(self, playerInfo, showSelfTag)
  if not playerInfo then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.playerData = playerInfo
  if not string.IsNullOrEmpty(self.playerData.alAbbr) then
    self.playerNameText:SetText(string.format("[%s]%s", self.playerData.alAbbr, self.playerData.name))
  else
    self.playerNameText:SetText(self.playerData.name)
  end
  if self.playerData.gender == 0 or self.playerData.gender == 3 then
    self.gender:SetActive(false)
  else
    self.gender:SetActive(true)
    self.maleGender:SetActive(self.playerData.gender == 1)
    self.femaleGender:SetActive(self.playerData.gender == 2)
  end
  local isSelf = LuaEntry.Player:GetUid() == self.playerData.uid
  self.isSelfBg:SetActive(isSelf)
  self.isOtherBg:SetActive(not isSelf)
  self.selfTag:SetActive(isSelf and showSelfTag)
  if 0 >= self.playerData.ranking then
    self.rankingBg:SetActive(false)
    self.rankingText:SetActive(false)
  else
    self.rankingBg:SetActive(3 >= self.playerData.ranking)
    self.rankingText:SetActive(true)
    if 3 >= self.playerData.ranking then
      self.rankingBg:LoadSprite(string.format("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_%d.png", self.playerData.ranking))
    end
    local showRanking = self.playerData.ranking
    if 100 < showRanking then
      showRanking = "100+"
    end
    self.rankingText:SetText(self.playerData.ranking)
  end
  self.pointsText:SetLocalText(2000239, self.playerData.score)
  local nationTemplate = self.playerData:GetCountryFlagTemplate()
  if nationTemplate then
    self.countryFlag:SetActive(true)
    self.countryFlag:LoadSprite(nationTemplate:GetNationFlagPath())
  else
    self.countryFlag:SetActive(false)
  end
  self.playerHead:SetData(self.playerData.uid, self.playerData.pic, self.playerData.picVer, nil, self.playerData:GetHeadBgImg())
end

UIPlayerRankingItem.OnCreate = OnCreate
UIPlayerRankingItem.OnDestroy = OnDestroy
UIPlayerRankingItem.DataDefine = DataDefine
UIPlayerRankingItem.ComponentDefine = ComponentDefine
UIPlayerRankingItem.DataDestroy = DataDestroy
UIPlayerRankingItem.ComponentDestroy = ComponentDestroy
UIPlayerRankingItem.SetData = SetData
return UIPlayerRankingItem
