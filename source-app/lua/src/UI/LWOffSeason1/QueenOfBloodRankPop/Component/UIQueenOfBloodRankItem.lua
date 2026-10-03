local base = UIBaseContainer
local UIQueenOfBloodRankItem = BaseClass("UIQueenOfBloodRankItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIQueenOfBloodRankItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIQueenOfBloodRankItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIQueenOfBloodRankItem:ComponentDefine()
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
  self.compPlayer:SetEnableClickShowInfo(true, true)
end

function UIQueenOfBloodRankItem:ComponentDestroy()
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
end

function UIQueenOfBloodRankItem:DataDefine()
end

function UIQueenOfBloodRankItem:DataDestroy()
end

function UIQueenOfBloodRankItem:OnAddListener()
  base.OnAddListener(self)
end

function UIQueenOfBloodRankItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIQueenOfBloodRankItem:OnBtnThumbsUpClick()
  if self.data then
    if self.data.isThumbsUp then
      UIUtil.ShowTipsId("s1_QueenChallenge_like_2")
    else
      InteractiveUtil.TryThumbsUp(self.data.roleInfo.uid, InteractiveUtil.ThumbsUpType.BloodyQueenRank, "BloodyQueenRank", function()
        self.data.isThumbsUp = true
        UIUtil.ShowTips(Localization:GetString("s1_QueenChallenge_like_1", self.data.roleInfo.name))
      end, self.thumbExtend)
    end
  end
end

function UIQueenOfBloodRankItem:SetData(data, isSelf, roundIndex, qualityIndex)
  self.data = data
  local roundStr = tostring(roundIndex) or "1"
  local qualityStr = tostring(qualityIndex) or "1"
  self.thumbExtend = string.format("%s|%s", roundStr, qualityStr)
  local power_color = "#2a2830"
  local first_color = "#2a2830"
  local second_color = "#6d82ad"
  local bgPath = "Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/Mjc_saiji2_paihangbang_list_bg_4.png"
  if isSelf or data.uid == LuaEntry.Player.uid then
    first_color = "#4a9327"
    bgPath = "Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/Mjc_saiji2_paihangbang_list_bg_5.png"
  elseif data.rank == 1 then
    first_color = "#d07b0c"
    bgPath = "Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/Mjc_saiji2_paihangbang_list_bg_1.png"
  elseif data.rank == 2 then
    first_color = "#6674ba"
    bgPath = "Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/Mjc_saiji2_paihangbang_list_bg_2.png"
  elseif data.rank == 3 then
    first_color = "#b77758"
    bgPath = "Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/Mjc_saiji2_paihangbang_list_bg_3.png"
  end
  self.imgBg:LoadSprite(bgPath)
  self.compPlayer:SetActive(true)
  self.compPlayer:ParseHeadInfo(self.data.roleInfo)
  if string.IsNullOrEmpty(data.roleInfo.abbr) then
    self.textFirstNameTxt:SetText("<color=" .. first_color .. ">" .. string.format("%s", data.roleInfo.name) .. "</color>")
  else
    self.textFirstNameTxt:SetText("<color=" .. first_color .. ">" .. string.format("[%s]%s", data.roleInfo.abbr, data.roleInfo.name) .. "</color>")
  end
  self.textRankTxt:SetLocalText("s1_QueenChallenge_result_task2", data.score)
  if self.data.rank and type(data.rank) == "number" and data.rank > 0 then
    self.textNumTxt:SetText(data.rank)
    self.compFirstImg:SetActive(data.rank == 1)
    self.compSecondImg:SetActive(data.rank == 2)
    self.compThirdImg:SetActive(data.rank == 3)
    if data.rank <= 3 then
      self.btnThumbsUp:SetActive(true)
      self:RefreshThumpsUpCount()
    else
      self.btnThumbsUp:SetActive(false)
    end
  else
    self.compFirstImg:SetActive(false)
    self.compSecondImg:SetActive(false)
    self.compThirdImg:SetActive(false)
    self.btnThumbsUp:SetActive(false)
    self.textNumTxt:SetText(CS.GameEntry.Localization:GetString("361054"))
  end
end

function UIQueenOfBloodRankItem:RefreshThumpsUpCount()
  local count = 0
  if self.data and self.data.thumbsUpCount then
    count = self.data.thumbsUpCount
  end
  if self.data.isThumbsUp then
    self.textThumbsUpNumTxt:SetText("<color=#5fef87>" .. count .. "</color>")
  else
    self.textThumbsUpNumTxt:SetText(count)
    self.textThumbsUpNumTxt:SetText("<color=#ffffff>" .. count .. "</color>")
  end
end

return UIQueenOfBloodRankItem
