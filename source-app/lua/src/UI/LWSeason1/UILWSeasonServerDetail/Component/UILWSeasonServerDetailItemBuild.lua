local UILWSeasonServerDetailItemBuild = BaseClass("UILWSeasonServerDetailItemBuild", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local name_txt_path = "info/NameTxt"
local alliance_txt_path = "info/AllianceTxt"
local alliance_rank_txt_path = "info/AllianceRankTxt"
local time_txt_path = "timeTxt"
local build_icon_path = "buildIcon"
local protected_path = "buildIcon/protected"
local pos_txt_path = "PosTxt"

function UILWSeasonServerDetailItemBuild:OnCreate()
  base.OnCreate(self)
  self.name_txt = self:AddComponent(UITextMeshProUGUIEx, name_txt_path)
  self.alliance_txt = self:AddComponent(UITextMeshProUGUIEx, alliance_txt_path)
  self.alliance_rank_txt = self:AddComponent(UITextMeshProUGUIEx, alliance_rank_txt_path)
  self.time_txt = self:AddComponent(UITextMeshProUGUIEx, time_txt_path)
  self.build_icon = self:AddComponent(UIImage, build_icon_path)
  self.buildBtn = self:AddComponent(UIButton, build_icon_path)
  self.protected = self:AddComponent(UIImage, protected_path)
  self.pos_txt = self:AddComponent(UITextMeshProUGUIEx, pos_txt_path)
  self.buildBtn:SetOnClick(function()
    if self.data and self.serverId then
      local serverId = self.serverId
      local pos = SceneUtils.TileIndexToWorld(self.data.point, ForceChangeScene.World)
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoWorldPos(pos, nil, nil, function()
      end, serverId, 0)
    end
  end)
end

function UILWSeasonServerDetailItemBuild:OnDestroy()
  self.name_txt = nil
  self.alliance_txt = nil
  self.alliance_rank_txt = nil
  self.time_txt = nil
  self.build_icon = nil
  self.protected = nil
  self.pos_txt = nil
  base.OnDestroy(self)
end

function UILWSeasonServerDetailItemBuild:ReInit(index, data, serverId)
  local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(data.buildId)
  self.data = data
  self.serverId = serverId
  if meta == nil or string.IsNullOrEmpty(meta.name) then
    self.name_txt:SetLocalText("803031")
  else
    self.name_txt:SetLocalText(meta.name)
  end
  local name = UIUtil.FormatServerAllianceName(data.serverId, data.abbr, data.name)
  self.alliance_txt:SetText(Localization:GetString("s1_zone_info_ui07") .. name)
  if data.allianceRank > 0 then
    self.alliance_rank_txt:SetText(Localization:GetString("s1_zone_info_ui08") .. data.allianceRank)
  else
    self.alliance_rank_txt:SetText(Localization:GetString("s1_zone_info_ui08") .. "100+")
  end
  if data.status == AllianceMineStatus.Ruin then
    self.build_icon:LoadSprite("Assets/Main/Sprites/UI/UILWMail/mjc_zhiyejineng_jianzhufeixu.png")
  else
    self.build_icon:LoadSprite("Assets/Main/Sprites/UI/UIAllianceNew/pic_Union_flag.png")
  end
  self.protected:SetActive(data.status == AllianceMineStatus.Build)
  self.pos_txt:SetText(UIUtil.MakeJumpLink(data.point, data.serverId, 0))
  self.time_txt:SetText(UITimeManager:GetInstance():GetServerTimeByUTC(data.createTime or 0, false))
end

return UILWSeasonServerDetailItemBuild
