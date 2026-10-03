local base = UIBaseContainer
local UIQueenOfBloodRankListItem = BaseClass("UIQueenOfBloodRankListItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIQueenOfBloodRankListItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIQueenOfBloodRankListItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIQueenOfBloodRankListItem:ComponentDefine()
  self.imgBg = self:AddComponent(UIImage, "bg")
  self.textFirstNameTxt = self:AddComponent(UITextMeshProUGUIEx, "firstNameTxt")
  self.textRankTxt = self:AddComponent(UITextMeshProUGUIEx, "rankTxt")
  self.compFirstImg = self:AddComponent(UIBaseComponent, "firstImg")
  self.compSecondImg = self:AddComponent(UIBaseComponent, "secondImg")
  self.compThirdImg = self:AddComponent(UIBaseComponent, "thirdImg")
  self.textNumTxt = self:AddComponent(UITextMeshProUGUIEx, "numTxt")
  self.compPlayer = self:AddComponent(UICommonHead, "player")
  self.btnThumbsUp = self:AddComponent(UIButton, "btnThumbsUp")
  self.btnThumbsUp:SetOnClick(function()
    self:OnBtnThumbsUpClick()
  end)
  self.textThumbsUpNumTxt = self:AddComponent(UITextMeshProUGUIEx, "btnThumbsUp/thumbsUpNumTxt")
  self.btnServerIcon = self:AddComponent(UIButton, "ServerIcon")
  self.btnServerIcon:SetOnClick(function()
    self:OnBtnServerIconClick()
  end)
  self.textValue = self:AddComponent(UITextMeshProUGUIEx, "ValueText")
  self.btnAllianceIcon = self:AddComponent(UIButton, "AllianceIcon")
  self.btnAllianceIcon:SetOnClick(function()
    self:OnBtnAllianceIconClick()
  end)
  self.compPlayer:SetEnableClickShowInfo(true, true)
  self.noAlRoot = self:AddComponent(UIBaseComponent, "NoAL")
  self.textNoAl = self:AddComponent(UIText, "NoAL/TextNoAL")
  self.textServerName = self:AddComponent(UIText, "serverNameTxt")
end

function UIQueenOfBloodRankListItem:ComponentDestroy()
  self.imgBg = nil
  self.textFirstNameTxt = nil
  self.textRankTxt = nil
  self.compFirstImg = nil
  self.compSecondImg = nil
  self.compThirdImg = nil
  self.textNumTxt = nil
  self.compPlayer = nil
  self.btnThumbsUp = nil
  self.textThumbsUpNumTxt = nil
  self.btnServerIcon = nil
  self.textValue = nil
  self.btnAllianceIcon = nil
  self.noAlRoot = nil
  self.textNoAl = nil
  self.textServerName = nil
end

function UIQueenOfBloodRankListItem:DataDefine()
end

function UIQueenOfBloodRankListItem:DataDestroy()
end

function UIQueenOfBloodRankListItem:OnAddListener()
  base.OnAddListener(self)
end

function UIQueenOfBloodRankListItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIQueenOfBloodRankListItem:OnBtnThumbsUpClick()
  if self.typeIndex == 1 and self.data and self.data.roleInfo then
    if self.data.isThumbsUp then
      UIUtil.ShowTipsId("s1_QueenChallenge_like_2")
    else
      InteractiveUtil.TryThumbsUp(self.data.roleInfo.uid, InteractiveUtil.ThumbsUpType.BloodyQueenRank, "BloodyQueenRank", function()
        if self.data.thumbsUpCount == nil then
          self.data.thumbsUpCount = 0
        end
        self.data.thumbsUpCount = self.data.thumbsUpCount + 1
        self.data.isThumbsUp = true
        self:RefreshThumpsUpCount()
        UIUtil.ShowTips(Localization:GetString("s1_QueenChallenge_like_1", self.data.roleInfo.name))
      end, self.thumbExtend)
    end
  end
end

function UIQueenOfBloodRankListItem:OnBtnAllianceIconClick()
  if self.typeIndex == 2 and self.data and self.data.allianceInfo then
    UIUtil.TryShowAllianceInfo(self.data.allianceInfo.allianceServerId, self.data.allianceInfo.allianceId, self.data.allianceInfo.allianceName)
  end
end

function UIQueenOfBloodRankListItem:OnBtnServerIconClick()
  if self.typeIndex == 3 and self.data and self.data.areaInfo then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentOfficial, {anim = true}, self.data.areaInfo.serverId)
  end
end

function UIQueenOfBloodRankListItem:SetData(data, typeIndex, isSelf, roundIndex, qualityIndex)
  self.typeIndex = typeIndex
  self.roundIndex = roundIndex
  self.qualityIndex = qualityIndex
  local roundStr = tostring(self.roundIndex) or "1"
  local qualityStr = tostring(self.qualityIndex) or "1"
  self.thumbExtend = string.format("%s|%s", roundStr, qualityStr)
  self.data = data
  local isPersonal = typeIndex == 1
  local isAlliance = typeIndex == 2
  local isServer = typeIndex == 3
  local power_color = "#2a2830"
  local first_color = "#2a2830"
  local second_color = "#6d82ad"
  local bgPath = "Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/Mjc_saiji2_paihangbang_list_bg_4.png"
  if isSelf or isAlliance and LuaEntry.Player.allianceId == data.allianceId or isPersonal and data.uid == LuaEntry.Player.uid then
    first_color = "#4a9327"
    bgPath = "Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/Mjc_saiji2_paihangbang_list_bg_5.png"
  elseif data.rank == 1 then
    first_color = "#d07b0c"
    bgPath = "Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/Mjc_saiji2_paihangbang_list_bg_1.png"
  elseif data.rank == 2 then
    power_color = "#6674ba"
    first_color = "#6674ba"
    bgPath = "Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/Mjc_saiji2_paihangbang_list_bg_2.png"
  elseif data.rank == 3 then
    first_color = "#b77758"
    bgPath = "Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/Mjc_saiji2_paihangbang_list_bg_3.png"
  end
  self.imgBg:LoadSprite(bgPath)
  if isAlliance then
    self.btnServerIcon:SetActive(false)
    self.textServerName:SetActive(false)
    self.textValue:SetActive(false)
    if isSelf and not LuaEntry.Player:IsInAlliance() then
      self.noAlRoot:SetActive(true)
      self.textNoAl:SetLocalText(451033)
      return
    else
      self.noAlRoot:SetActive(false)
      self.compPlayer:SetActive(false)
      if self.data.allianceInfo.allianceIcon ~= nil and self.data.allianceInfo.allianceIcon ~= "" then
        self.btnAllianceIcon:SetActive(true)
        self.btnAllianceIcon:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(self.data.allianceInfo.allianceIcon)))
      else
        self.btnAllianceIcon:SetActive(false)
      end
    end
    self.textFirstNameTxt:SetActive(true)
    self.textFirstNameTxt:SetText("<color=" .. first_color .. ">" .. string.format("[%s]%s", data.allianceInfo.abbr, data.allianceInfo.allianceName) .. "</color>")
    self.textRankTxt:SetActive(true)
    self.textRankTxt:SetLocalText("s1_QueenChallenge_result_task2", data.score)
  elseif isPersonal then
    self.btnServerIcon:SetActive(false)
    self.textServerName:SetActive(false)
    self.textValue:SetActive(false)
    self.noAlRoot:SetActive(false)
    self.btnAllianceIcon:SetActive(false)
    self.compPlayer:SetActive(true)
    self.compPlayer:ParseHeadInfo(self.data.roleInfo)
    self.textFirstNameTxt:SetActive(true)
    if string.IsNullOrEmpty(data.roleInfo.abbr) then
      self.textFirstNameTxt:SetText("<color=" .. first_color .. ">" .. string.format("%s", data.roleInfo.name) .. "</color>")
    else
      self.textFirstNameTxt:SetText("<color=" .. first_color .. ">" .. string.format("[%s]%s", data.roleInfo.abbr, data.roleInfo.name) .. "</color>")
    end
    self.textRankTxt:SetActive(true)
    self.textRankTxt:SetLocalText("s1_QueenChallenge_result_task2", data.score)
  elseif isServer then
    local iconPath = DataCenter.ZoneWarManager:GetKingdomBadgesIconPath(data.areaInfo.serverId)
    self.btnServerIcon:SetActive(true)
    self.btnServerIcon:LoadSprite(iconPath)
    self.noAlRoot:SetActive(false)
    self.btnAllianceIcon:SetActive(false)
    self.compPlayer:SetActive(false)
    self.textFirstNameTxt:SetActive(false)
    self.textRankTxt:SetActive(false)
    self.textServerName:SetActive(true)
    self.textServerName:SetText(Localization:GetString("800941") .. " #" .. data.areaInfo.serverId)
    self.textValue:SetActive(true)
    local cityCount = data.areaInfo.cityCount or 0
    local durability = data.areaInfo.durability or 0
    self.textValue:SetText(cityCount .. "(" .. string.percentage(durability, 100, 2) .. ")")
  end
  if self.data.rank and type(data.rank) == "number" and data.rank > 0 then
    self.textNumTxt:SetText(data.rank)
    self.compFirstImg:SetActive(data.rank == 1)
    self.compSecondImg:SetActive(data.rank == 2)
    self.compThirdImg:SetActive(data.rank == 3)
    if isPersonal and 3 >= data.rank then
      self.btnThumbsUp:SetActive(true)
      self:RefreshThumpsUpCount()
    else
      self.btnThumbsUp:SetActive(false)
    end
  else
    self.compFirstImg:SetActive(false)
    self.compFirstImg:SetActive(false)
    self.compThirdImg:SetActive(false)
    self.btnThumbsUp:SetActive(false)
    self.textNumTxt:SetText(CS.GameEntry.Localization:GetString("361054"))
  end
end

function UIQueenOfBloodRankListItem:RefreshThumpsUpCount()
  local count = 0
  if self.typeIndex == 1 and self.data and self.data.thumbsUpCount then
    count = self.data.thumbsUpCount
  end
  if self.data.isThumbsUp then
    self.textThumbsUpNumTxt:SetText("<color=#5fef87>" .. count .. "</color>")
  else
    self.textThumbsUpNumTxt:SetText(count)
    self.textThumbsUpNumTxt:SetText("<color=#ffffff>" .. count .. "</color>")
  end
end

return UIQueenOfBloodRankListItem
