local LWUIMigration_AllianceItem = BaseClass("LWUIMigration_AllianceItem", UIBaseContainer)
local base = UIBaseContainer
local img_flag_path = "FlagIcon"
local img_rank_path = "Rank"
local text_rank_path = "RankText"
local text_name_path = "NameText"
local ICON_PATH = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang0%d.png"

function LWUIMigration_AllianceItem:OnCreate()
  base.OnCreate(self)
  self.img_flag = self:AddComponent(UIImage, img_flag_path)
  self.btn_flag = self:AddComponent(UIButton, img_flag_path)
  self.btn_flag:SetOnClick(BindCallback(self, self.TryShowAlliance))
  self.img_rank = self:AddComponent(UIImage, img_rank_path)
  self.text_rank = self:AddComponent(UIText, text_rank_path)
  self.text_name = self:AddComponent(UIText, text_name_path)
end

function LWUIMigration_AllianceItem:OnDestroy()
  base.OnDestroy(self)
end

function LWUIMigration_AllianceItem:TryShowAlliance()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if not self.info then
    return
  end
  local allianceId = self.info.uid
  local allianceName = self.info.name
  if string.IsNullOrEmpty(allianceId) or string.IsNullOrEmpty(self.info.name) then
    UIUtil.ShowTipsId("900507")
    return
  end
  local data = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(allianceId)
  if data == nil then
    SFSNetwork.SendMessage(MsgDefines.GetAllianceInfo, allianceId)
  else
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIAllianceDetail) then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceDetail)
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true, hideTop = false}, allianceName, allianceId, self.serverId)
  end
end

function LWUIMigration_AllianceItem:SetData(info, serverId)
  if info == nil then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.info = info
  self.serverId = serverId
  self.img_flag:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, info.icon))
  self.img_rank:LoadSpriteAuto(string.format(ICON_PATH, info.rank))
  self.text_rank:SetText(info.rank)
  self.text_name:SetText(string.format([[
[%s]
%s]], info.abbr, info.name))
end

return LWUIMigration_AllianceItem
