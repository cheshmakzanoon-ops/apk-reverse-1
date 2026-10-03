local base = UIBaseContainer
local UIWorldSiegePointCompCampDestroyIR = BaseClass("UIWorldSiegePointCompCampDestroyIR", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIWorldSiegePointCompCampDestroyIR:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIWorldSiegePointCompCampDestroyIR:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWorldSiegePointCompCampDestroyIR:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textTmpRank = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compHeadIcon = self.viewSkin:AddComponent(self, UIPlayerHead, 3)
  self.textTmpAlliance = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textTmpScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.btnUIPlayerHead = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnUIPlayerHead:SetOnClick(function()
    self:OnBtnUIPlayerHeadClick()
  end)
end

function UIWorldSiegePointCompCampDestroyIR:ComponentDestroy()
  self.viewSkin = nil
  self.imgBg = nil
  self.textTmpRank = nil
  self.compHeadIcon = nil
  self.textTmpAlliance = nil
  self.textTmpScore = nil
  self.btnUIPlayerHead = nil
end

function UIWorldSiegePointCompCampDestroyIR:DataDefine()
  self.userInfo = nil
  self.rank = 0
end

function UIWorldSiegePointCompCampDestroyIR:RefreshData(data, allianceInfo, rank)
  if not data then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.rank = rank
  self.textTmpRank:SetLocalText("801106", rank)
  self.userInfo = data.userInfo or {}
  local playerName = self.userInfo.name or ""
  if allianceInfo then
    playerName = string.format("#%s[%s]%s", allianceInfo.serverId or 0, allianceInfo.abbr, playerName)
  end
  self.textTmpAlliance:SetText(playerName)
  self.textTmpScore:SetText(string.GetFormattedSeparatorNum(data.score or 0))
  self.compHeadIcon:SetData(self.userInfo.uid, self.userInfo.pic, self.userInfo.picVer)
  local bgName = "mjc_tongyong_paiming_s_bg3"
  local color = "#90624d"
  if rank == 1 then
    bgName = "mjc_tongyong_paiming_s_bg1"
    color = "#ab6100"
  elseif rank == 2 then
    bgName = "mjc_tongyong_paiming_s_bg2"
    color = "#3d4d9b"
  elseif rank == 3 then
    bgName = "mjc_tongyong_paiming_s_bg3"
    color = "#90624d"
  end
  self.textTmpAlliance:SetColorHex(color)
  self.textTmpRank:SetColorHex(color)
  self.textTmpScore:SetColorHex(color)
  self.imgBg:LoadSprite(string.format("Assets/Main/SeasonRes/S6/Sprites/CampDestroy/%s.png", bgName))
end

function UIWorldSiegePointCompCampDestroyIR:DataDestroy()
end

function UIWorldSiegePointCompCampDestroyIR:OnAddListener()
  base.OnAddListener(self)
end

function UIWorldSiegePointCompCampDestroyIR:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIWorldSiegePointCompCampDestroyIR:OnBtnUIPlayerHeadClick()
  if self.userInfo then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, {
      uid = self.userInfo.uid
    })
  end
end

return UIWorldSiegePointCompCampDestroyIR
