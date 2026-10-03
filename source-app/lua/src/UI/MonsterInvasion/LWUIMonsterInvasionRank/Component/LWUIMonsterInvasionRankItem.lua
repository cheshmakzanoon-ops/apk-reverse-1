local LWUIMonsterInvasionRankItem = BaseClass("LWUIMonsterInvasionRankItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function LWUIMonsterInvasionRankItem:OnCreate()
  base.OnCreate(self)
  self.cell_btn = self:AddComponent(UIButton, "")
  self.cell_btn:SetOnClick(function()
  end)
  self.isOtherBg = self:AddComponent(UIImage, "IsOtherBg")
  self.isSelfBg = self:AddComponent(UIImage, "IsSelfBg")
  self.rankingBg = self:AddComponent(UIImage, "RankingBg")
  self.rankingText = self:AddComponent(UIText, "RankingText")
  self.playerNameText = self:AddComponent(UIText, "GenderNameGroup/PlayerNameText")
  self.gender = self:AddComponent(UIBaseContainer, "GenderNameGroup/Gender")
  self.maleGender = self:AddComponent(UIBaseContainer, "GenderNameGroup/Gender/Man")
  self.femaleGender = self:AddComponent(UIBaseContainer, "GenderNameGroup/Gender/Woman")
  self.pointsText = self:AddComponent(UIText, "PointsText")
  self.self_tag_text = self:AddComponent(UIText, "SelfTagBg/SelfTagText")
  self.playerHead = self:AddComponent(UICommonHead, "UIPlayerHead")
  self.playerHead:SetEnableClickShowInfo(true, true)
  if self.transform:Find("BtnDetail") ~= nil then
    self.BtnDetail = self:AddComponent(UIButton, "BtnDetail")
    self.BtnDetail:SetOnClick(function()
      self:OnOpenArmyInfo()
    end)
  end
end

function LWUIMonsterInvasionRankItem:OnDestroy()
  base.OnDestroy(self)
  self.isOtherBg = nil
  self.isSelfBg = nil
  self.rankingBg = nil
  self.rankingText = nil
  self.playerNameText = nil
  self.gender = nil
  self.maleGender = nil
  self.femaleGender = nil
  self.pointsText = nil
  self.playerHead = nil
end

function LWUIMonsterInvasionRankItem:SetData(playerInfo, showSelfTag)
  if not playerInfo then
    self:SetActive(false)
    return
  end
  local serverId = playerInfo.serverId or playerInfo.server
  self:SetActive(true)
  self.playerData = playerInfo
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
  local isSelf = LuaEntry.Player:GetUid() == self.playerData.uid
  self.isSelfBg:SetActive(isSelf)
  self.isOtherBg:SetActive(not isSelf)
  if isSelf and showSelfTag then
    if 0 < self.playerData.ranking then
      self.self_tag_text:SetLocalText(2000238)
    else
      self.self_tag_text:SetLocalText(110003)
    end
  end
  if 0 >= self.playerData.ranking then
    self.rankingBg:SetActive(false)
    self.rankingText:SetActive(false)
  else
    self.rankingBg:SetActive(3 >= self.playerData.ranking)
    if self.BtnDetail ~= nil then
      self.BtnDetail:SetActive(not showSelfTag and 3 >= self.playerData.ranking)
    end
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
  self.pointsText:SetLocalText(456010, string.GetFormattedSeparatorNum(self.playerData.score))
  self.playerHead:SetData(self.playerData.uid, self.playerData.pic, self.playerData.picVer, nil, self.playerData:GetHeadBgImg())
  self.playerHead:SetFlag(self.playerData.countryFlag)
end

function LWUIMonsterInvasionRankItem:OnOpenArmyInfo()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIOtherArmyInfo, {anim = true}, self.playerData.uid, MsgDefines.InvasionBossUserMarchRecord)
end

return LWUIMonsterInvasionRankItem
