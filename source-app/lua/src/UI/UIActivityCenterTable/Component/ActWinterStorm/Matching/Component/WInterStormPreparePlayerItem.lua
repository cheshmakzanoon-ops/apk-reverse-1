local WInterStormPreparePlayerItem = BaseClass("WInterStormPreparePlayerItem", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local MyRand = math.random
local typeofPS = typeof(CS.UnityEngine.ParticleSystem)
local prepare_path = "prepare"
local eff_orange_1_path = "Eff_ui_PlayerItem1_2"
local eff_purple_1_path = "Eff_ui_PlayerItem1_1"
local icon_path = "Head/UIPlayerHead/HeadIcon"
local btn_path = "Head/Btn"
local eff_orange_2_path = "Head/Eff_ui_PlayerItem2_2"
local eff_purple_2_path = "Head/Eff_ui_PlayerItem2_1"
local text_name_path = "NameText"
local point_group_path = "PointGroup"
local arrow_path = "Arrow"
local color_self = Color.New(0.28627450980392155, 9.709803921568627, 0.5882352941176471, 1)
local color_other = Color.New(1, 1, 1, 1)
local TIP_KEYS = {
  "winter_battlefield_tips1061",
  "winter_battlefield_tips1062",
  "winter_battlefield_tips1063"
}

function WInterStormPreparePlayerItem:OnCreate()
  base.OnCreate(self)
  self.playerUid = 0
  self.prepare = self:AddComponent(UIBaseContainer, prepare_path)
  self.eff_orange_1 = self.transform:Find(eff_orange_1_path):GetComponent(typeofPS)
  self.eff_purple_1 = self.transform:Find(eff_purple_1_path):GetComponent(typeofPS)
  self.icon = self:AddComponent(UIPlayerHead, icon_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnClickInfoBtn()
  end)
  self.eff_orange_2 = self.transform:Find(eff_orange_2_path):GetComponent(typeofPS)
  self.eff_purple_2 = self.transform:Find(eff_purple_2_path):GetComponent(typeofPS)
  self.textName = self:AddComponent(UIText, text_name_path)
  self.pointGroup = self:AddComponent(UIBaseContainer, point_group_path)
  self.arrow = self:AddComponent(UIImage, arrow_path)
end

function WInterStormPreparePlayerItem:OnDestroy()
  self.playerUid = 0
  self.tempTeamData = nil
  self.prepare = nil
  self.icon = nil
  self.btn = nil
  self.textName = nil
  self.pointGroup = nil
  self.arrow = nil
  base.OnDestroy(self)
end

function WInterStormPreparePlayerItem:OnClickInfoBtn()
  local idx = MyRand(1, #TIP_KEYS)
  local strTip = Localization:GetString(TIP_KEYS[idx])
  UIUtil.ShowBubbleTips(strTip, self.icon.transform.position, 0, -30, 0)
end

function WInterStormPreparePlayerItem:SetPlayer(teamArr)
  self.tempTeamData = teamArr
  self:RefreshView()
end

function WInterStormPreparePlayerItem:UpdateData()
  if table.IsNullOrEmpty(self.tempTeamData) then
    return
  end
  self.playerUid = self.tempTeamData.uid
  local name = UIUtil.FormatAllianceAndName(self.tempTeamData.allianceName, self.tempTeamData.name)
  self.textName:SetText(name)
  local color = self.playerUid == LuaEntry.Player:GetUid() and color_self or color_other
  self.textName:SetColor(color)
  self.icon:SetData(self.tempTeamData.uid, self.tempTeamData.head, self.tempTeamData.frame)
  local bReady = self.tempTeamData.b_ready
  self.prepare:SetActive(bReady)
  self.arrow:SetActive(bReady)
  self.pointGroup:SetActive(not bReady)
end

return WInterStormPreparePlayerItem
