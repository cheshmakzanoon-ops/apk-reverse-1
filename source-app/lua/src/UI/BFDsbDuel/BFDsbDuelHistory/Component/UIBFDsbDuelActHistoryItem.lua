local UIBFDsbDuelActHistoryItem = BaseClass("UIBFDsbDuelActHistoryItem", UIBaseContainer)
local base = UIBaseContainer
local UIBFDsbDuelActHistoryAllianceItem = require("UI.BFDsbDuel.BFDsbDuelHistory.Component.UIBFDsbDuelActHistoryAllianceItem")
local Localization = CS.GameEntry.Localization
local bg1OffsetX = {
  -260,
  -80,
  80,
  260
}

function UIBFDsbDuelActHistoryItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActHistoryItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActHistoryItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.OnGetNewUserInfoSucc)
end

function UIBFDsbDuelActHistoryItem:OnRemoveListener()
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.OnGetNewUserInfoSucc)
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActHistoryItem:OnGetNewUserInfoSucc(uid)
  if self.data and self.data.mvp and self.data.mvp.uid == uid then
    self:RefreshThumbUp()
  end
end

function UIBFDsbDuelActHistoryItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.imgState = self.viewSkin:AddComponent(self, UIImage, 2)
  self.compUIBFDsbDuelActHistoryAllianceItem1 = self.viewSkin:AddComponent(self, UIBFDsbDuelActHistoryAllianceItem, 3)
  self.compUIBFDsbDuelActHistoryAllianceItem2 = self.viewSkin:AddComponent(self, UIBFDsbDuelActHistoryAllianceItem, 4)
  self.compUIBFDsbDuelActHistoryAllianceItem3 = self.viewSkin:AddComponent(self, UIBFDsbDuelActHistoryAllianceItem, 5)
  self.compUIBFDsbDuelActHistoryAllianceItem4 = self.viewSkin:AddComponent(self, UIBFDsbDuelActHistoryAllianceItem, 6)
  self.imgBG = self.viewSkin:AddComponent(self, UIImage, 7)
  self.imgBG1 = self.viewSkin:AddComponent(self, UIImage, 8)
  self.compUIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 9)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.btnFavor = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnFavor:SetOnClick(function()
    self:OnBtnFavorClick()
  end)
  self.textFavorTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.compMVPContent = self.viewSkin:AddComponent(self, UIBaseContainer, 13)
  self.compUIPlayerHead:SetEnableClickShowInfo(true, true)
  self.allianceItems = {
    self.compUIBFDsbDuelActHistoryAllianceItem1,
    self.compUIBFDsbDuelActHistoryAllianceItem2,
    self.compUIBFDsbDuelActHistoryAllianceItem3,
    self.compUIBFDsbDuelActHistoryAllianceItem4
  }
end

function UIBFDsbDuelActHistoryItem:ComponentDestroy()
  self.viewSkin = nil
  self.textTime = nil
  self.imgState = nil
  self.compUIBFDsbDuelActHistoryAllianceItem1 = nil
  self.compUIBFDsbDuelActHistoryAllianceItem2 = nil
  self.compUIBFDsbDuelActHistoryAllianceItem3 = nil
  self.compUIBFDsbDuelActHistoryAllianceItem4 = nil
  self.imgBG = nil
  self.imgBG1 = nil
  self.compUIPlayerHead = nil
  self.textName = nil
  self.btnFavor = nil
  self.textFavorTxt = nil
  self.compMVPContent = nil
end

function UIBFDsbDuelActHistoryItem:DataDefine()
  self.data = nil
end

function UIBFDsbDuelActHistoryItem:DataDestroy()
  self.data = nil
end

function UIBFDsbDuelActHistoryItem:RefreshThumbUp()
  if not table.IsNullOrEmpty(self.data.mvp) then
    local playerData = UIUtil.GetPlayerInfoShowByUid(self.data.mvp.uid)
    if playerData then
      self.textFavorTxt:SetText(playerData.thumbsUpCount)
    end
  end
end

function UIBFDsbDuelActHistoryItem:GetAlByRank(rank)
  if self.data then
    for _, v in ipairs(self.data.results) do
      if v.rank == rank then
        return v
      end
    end
  end
  return BattlefieldDsbConst.EmptyRole
end

function UIBFDsbDuelActHistoryItem:SetData(data)
  self.data = data
  if not data then
    return
  end
  self.imgState:LoadSpriteAuto(data.teamId == BattlefieldDsbConst.TeamType.A and "Assets/Main/Sprites/UI/BF_Dsb_Duel/UI/lrb_daluandou_zhujiemian_A.png" or "Assets/Main/Sprites/UI/BF_Dsb_Duel/UI/lrb_daluandou_zhujiemian_B.png")
  local timeStr = UITimeManager:GetInstance():TimeStampToTimeForServer(data.battleTime * 1000)
  self.textTime:SetText(Localization:GetString("800811") .. ": " .. timeStr)
  local selfRank
  for i, item in ipairs(self.allianceItems) do
    local info = self:GetAlByRank(i)
    item:SetData(info, i)
    if info.allianceId == LuaEntry.Player.allianceId then
      selfRank = i
    end
  end
  self.compMVPContent:SetActive(not table.IsNullOrEmpty(data.mvp))
  if not table.IsNullOrEmpty(data.mvp) then
    if selfRank then
      self.imgBG1:SetAnchoredPositionXY(bg1OffsetX[selfRank], 0)
    end
    self.compUIPlayerHead:ParseHeadInfo(data.mvp)
    self.textName:SetText(data.mvp.name)
    self.textName:SetColorHex(data.mvp.uid == LuaEntry.Player.uid and "#79FF42" or "#FFFFFF")
    self:RefreshThumbUp()
    local color = BattlefieldDsbDuelUtils.GetMyColor()
    if color then
      self.imgBG:LoadSpriteAuto(color.actMvpBg2)
      self.imgBG1:LoadSpriteAuto(color.actMvpBg1)
    end
  end
end

function UIBFDsbDuelActHistoryItem:OnBtnFavorClick()
  if self.data.mvp then
    InteractiveUtil.TryThumbsUp(self.data.mvp.uid, InteractiveUtil.ThumbsUpType.DsbDuelHistoryMvp, nil, function()
      SFSNetwork.SendMessage(MsgDefines.GetNewUserInfo, self.data.mvp.uid)
    end)
  end
end

return UIBFDsbDuelActHistoryItem
