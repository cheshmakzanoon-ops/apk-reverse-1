local LWUISeasonTowerRankCellComponent = BaseClass("LWUISeasonTowerRankCellComponent", UIBaseContainer)
local LWSeasonTowerUtil = require("DataCenter.LWSeasonTowerManager.LWSeasonTowerUtil")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local bgDict = {
  [1] = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_1.png",
  [2] = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_2.png",
  [3] = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_3.png"
}

function LWUISeasonTowerRankCellComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUISeasonTowerRankCellComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUISeasonTowerRankCellComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgIsSelfBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgIsOtherBg = self.viewSkin:AddComponent(self, UIImage, 2)
  self.imgRankingBg = self.viewSkin:AddComponent(self, UIImage, 3)
  self.textRanking = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compUIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 5)
  self.textPoints = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.compSelfTagBg = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.textSelfTag = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.compGenderNameGroup = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.imgWoman = self.viewSkin:AddComponent(self, UIImage, 10)
  self.imgMan = self.viewSkin:AddComponent(self, UIImage, 11)
  self.textPlayerName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.btnDetail = self.viewSkin:AddComponent(self, UIButton, 13)
  self.btnDetail:SetOnClick(function()
    self:OnBtnDetailClick()
  end)
  self.imgPointIcon = self.viewSkin:AddComponent(self, UIImage, 14)
  self.compUIPlayerHead:SetEnableClickShowInfo(true, true)
end

function LWUISeasonTowerRankCellComponent:ComponentDestroy()
  self.viewSkin = nil
  self.imgIsSelfBg = nil
  self.imgIsOtherBg = nil
  self.imgRankingBg = nil
  self.textRanking = nil
  self.compUIPlayerHead = nil
  self.textPoints = nil
  self.compSelfTagBg = nil
  self.textSelfTag = nil
  self.compGenderNameGroup = nil
  self.imgWoman = nil
  self.imgMan = nil
  self.textPlayerName = nil
  self.btnDetail = nil
  self.imgPointIcon = nil
end

function LWUISeasonTowerRankCellComponent:DataDefine()
  self.playerData = nil
end

function LWUISeasonTowerRankCellComponent:DataDestroy()
  self.playerData = nil
end

function LWUISeasonTowerRankCellComponent:OnAddListener()
  base.OnAddListener(self)
end

function LWUISeasonTowerRankCellComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUISeasonTowerRankCellComponent:OnBtnDetailClick()
  if self.stageId ~= -1 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonTowerRankArmyInfo, {anim = true}, {
      stageId = self.stageId,
      info = self.playerData,
      uid = self.playerData.uid
    })
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonTowerRankAllArmyInfo, {anim = true}, {
      stageId = self.stageId,
      info = self.playerData,
      uid = self.playerData.uid
    })
  end
end

function LWUISeasonTowerRankCellComponent:SetData(playerInfo, showSelfTag, stageId)
  if not playerInfo then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.playerData = playerInfo
  self.stageId = stageId
  self.textPlayerName:SetText(UIUtil.FormatServerAllianceName(self.playerData.serverId, self.playerData.alAbbr, self.playerData.name, self.playerData.uid))
  if self.playerData.gender == 0 or self.playerData.gender == 3 then
    self.imgMan:SetActive(false)
    self.imgWoman:SetActive(false)
  else
    self.imgMan:SetActive(self.playerData.gender == 1)
    self.imgWoman:SetActive(self.playerData.gender == 2)
  end
  local ranking = tonumber(self.playerData.ranking or 0) or 0
  if ranking <= 0 then
    self.imgRankingBg:SetActive(false)
    self.textRanking:SetText("100+")
  else
    self.imgRankingBg:SetActive(ranking <= 3)
    if ranking <= 3 then
      self.imgRankingBg:LoadSprite(NewRankIconPath[ranking])
      self.imgRankingBg:SetNativeSize()
      self.imgIsOtherBg:LoadSprite(bgDict[ranking])
    else
      self.imgIsOtherBg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/FX_common_diban_bai.png")
    end
    local showRanking = 100 < ranking and "100+" or tostring(ranking)
    self.textRanking:SetText(showRanking)
  end
  local isSelf = LuaEntry.Player:GetUid() == self.playerData.uid
  self.imgIsSelfBg:SetActive(isSelf)
  self.imgIsOtherBg:SetActive(not isSelf)
  self.compSelfTagBg:SetActive(false)
  self.btnDetail:SetActive(ranking <= 10 and not showSelfTag)
  if self.stageId ~= -1 then
    self.imgPointIcon:SetActive(false)
    self.textPoints:SetText(Localization:GetString("season_tower_show_progress", self.playerData.score))
  else
    self.imgPointIcon:SetActive(true)
    if tonumber(self.playerData.score) ~= nil then
      self.textPoints:SetText("\195\151" .. string.GetFormattedSeparatorNum(tonumber(self.playerData.score)))
    else
      self.textPoints:SetText("\195\151" .. tostring(self.playerData.score or ""))
    end
  end
  self.compUIPlayerHead:SetData(self.playerData.uid, self.playerData.pic, self.playerData.picVer, nil, self.playerData:GetHeadBgImg())
  self.compUIPlayerHead:SetFlag(self.playerData.countryFlag)
end

return LWUISeasonTowerRankCellComponent
