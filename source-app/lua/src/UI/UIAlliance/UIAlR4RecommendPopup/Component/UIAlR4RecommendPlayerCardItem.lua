local base = UIBaseContainer
local UIAlR4RecommendPlayerCardItem = BaseClass("UIAlR4RecommendPlayerCardItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local AllianceRateStarItem = require("UI.UIAlliance.UIAllianceInfo.Component.AllianceRateStarItem")
local UIAlR4RecommendTag = require("UI.UIAlliance.UIAlR4RecommendPopup.Component.UIAlR4RecommendTag")

function UIAlR4RecommendPlayerCardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIAlR4RecommendPlayerCardItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAlR4RecommendPlayerCardItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compUIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 1)
  self.compAllianceRateStarItem = self.viewSkin:AddComponent(self, AllianceRateStarItem, 2)
  self.imgAllianceIcon = self.viewSkin:AddComponent(self, UIImage, 3)
  self.textPlayerName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compTag4 = self.viewSkin:AddComponent(self, UIAlR4RecommendTag, 5)
  self.compTag3 = self.viewSkin:AddComponent(self, UIAlR4RecommendTag, 6)
  self.compTag2 = self.viewSkin:AddComponent(self, UIAlR4RecommendTag, 7)
  self.compTag1 = self.viewSkin:AddComponent(self, UIAlR4RecommendTag, 8)
  self.btnUpgrade = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnUpgrade:SetOnClick(function()
    self:OnBtnUpgradeClick()
  end)
  self.textButton = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.compFinishTag = self.viewSkin:AddComponent(self, UIBaseComponent, 11)
  self.compTagList = {
    self.compTag1,
    self.compTag2,
    self.compTag3,
    self.compTag4
  }
end

function UIAlR4RecommendPlayerCardItem:ComponentDestroy()
  self.viewSkin = nil
  self.compUIPlayerHead = nil
  self.compAllianceRateStarItem = nil
  self.imgAllianceIcon = nil
  self.textPlayerName = nil
  self.compTag4 = nil
  self.compTag3 = nil
  self.compTag2 = nil
  self.compTag1 = nil
  self.btnUpgrade = nil
  self.textButton = nil
  self.compFinishTag = nil
  self.compTagList = nil
end

function UIAlR4RecommendPlayerCardItem:DataDefine()
  self.playerTagList = {}
  self.playerUid = 0
  self.playerRank = 0
end

function UIAlR4RecommendPlayerCardItem:DataDestroy()
  self.playerTagList = nil
  self.playerUid = nil
  self.playerRank = nil
end

function UIAlR4RecommendPlayerCardItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceMember, self.RefreshPlayerRank)
end

function UIAlR4RecommendPlayerCardItem:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceMember, self.RefreshPlayerRank)
  base.OnRemoveListener(self)
end

function UIAlR4RecommendPlayerCardItem:OnBtnUpgradeClick()
  if self.playerRank >= 4 then
    return
  end
  DataCenter.AllianceMemberDataManager:SendAllianceSetRank(self.playerUid, 4, 0)
end

function UIAlR4RecommendPlayerCardItem:UpdatePlayerCard(recommendData)
  local player_score = recommendData.recommendInfo.score or 0
  local player_tag_list = recommendData.recommendInfo.tage or {}
  local player_info = recommendData.roleInfo or {}
  self.playerUid = recommendData.roleInfo.uid or 0
  self.playerRank = recommendData.roleInfo.rank or LWAlMemberRankType.R1
  self:RefreshPlayerRank()
  self.compUIPlayerHead:SetHeadAndFrame(self.playerUid, player_info.headPic, player_info.headPicVer, false, player_info.headSkinId, player_info.headSkinEt)
  self.compUIPlayerHead:SetEnableClickShowInfo(true, true)
  self.textPlayerName:SetText(player_info.name or "")
  self.compAllianceRateStarItem:RefreshByBaseInfo({comprehensiveScore = player_score})
  local tag_config_list = {}
  table.sort(player_tag_list, function(a, b)
    if not tag_config_list[a] then
      tag_config_list[a] = DataCenter.AllianceMemberDataManager:GetR4RecommendTagConfig(a)
    end
    if not tag_config_list[b] then
      tag_config_list[b] = DataCenter.AllianceMemberDataManager:GetR4RecommendTagConfig(b)
    end
    if tag_config_list[a].is_show == tag_config_list[b].is_show then
      return tag_config_list[a].order > tag_config_list[b].order
    else
      return tag_config_list[a].is_show > tag_config_list[b].is_show
    end
  end)
  local tag_max_num = LuaEntry.DataConfig:TryGetNum("r4recommend_config", "k2", 4)
  for i = 1, tag_max_num do
    local tag_id = player_tag_list[i]
    if tag_id then
      local is_visible = DataCenter.AllianceMemberDataManager:CheckTagVisible(tag_id)
      if not is_visible then
        self.compTagList[i]:SetActive(false)
      else
        self.compTagList[i]:SetActive(true)
        self.compTagList[i]:SetTagInfo(tag_id)
      end
    else
      self.compTagList[i]:SetActive(false)
    end
  end
end

function UIAlR4RecommendPlayerCardItem:RefreshPlayerRank()
  if DataCenter.AllianceMemberDataManager:IsOurR4MemberByUid(self.playerUid) then
    self.playerRank = 4
  end
  self.imgAllianceIcon:LoadSprite(LWAlMemberRankParam[self.playerRank].Icon)
  self:RefreshUpgradeBtn(self.playerRank >= LWAlMemberRankType.R4)
end

function UIAlR4RecommendPlayerCardItem:RefreshUpgradeBtn(isR4)
  if isR4 then
    self.textButton:SetLocalText("r4Recommend_btn_setR4")
    self.compFinishTag:SetActive(true)
    self.btnUpgrade:SetActive(false)
  else
    self.compFinishTag:SetActive(false)
    self.btnUpgrade:SetActive(true)
  end
end

return UIAlR4RecommendPlayerCardItem
