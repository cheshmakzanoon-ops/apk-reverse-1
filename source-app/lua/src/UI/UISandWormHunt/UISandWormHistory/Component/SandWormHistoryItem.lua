local SandWormHistoryItem = BaseClass("SandWormHistoryItem", UIBaseContainer)
local base = UIBaseContainer
local ui_player_head_path = "UIPlayerHead"
local txt_des_path = "Txt_Des"
local txt_time_path = "Txt_Time"
local txt_name_path = "Txt_Title"

function SandWormHistoryItem:OnCreate()
  base.OnCreate(self)
  self.player_head = self:AddComponent(UICommonHead, ui_player_head_path)
  self.txt_des = self:AddComponent(UITextMeshProUGUIEx, txt_des_path)
  self.txt_time = self:AddComponent(UITextMeshProUGUIEx, txt_time_path)
  self.txt_name = self:AddComponent(UITextMeshProUGUIEx, txt_name_path)
  self.bgIcon = self:TryAddComponent(UIBaseComponent, "bgIcon")
  if self.bgIcon then
    self.bgIcon:SetActive(false)
  end
end

function SandWormHistoryItem:OnDestroy()
  if self.bgIcon then
    self.bgIcon:SetActive(true)
  end
  base.OnDestroy(self)
  self.player_head = nil
  self.txt_des = nil
  self.txt_time = nil
  self.txt_name = nil
  self.bgIcon = nil
end

function SandWormHistoryItem:ReInit(index, data)
  if data.type == 1 then
    local meta = DataCenter.MonsterTemplateManager:GetMonsterTemplate(data.cfgId)
    if not meta then
      return
    end
    if meta.special == WorldMonsterSpecialType.SmallSandWorm then
      self.txt_des:SetLocalText("season_activity_1000069_desc09")
    elseif meta.special == WorldMonsterSpecialType.BigSandWorm then
      self.txt_des:SetLocalText("season_activity_1000069_desc10")
    end
    if data.avatar then
      self.player_head:SetHeadAndFrame(data.avatar.uid, data.avatar.headPic, data.avatar.headPicVer, nil, data.avatar.headSkinId, data.avatar.headSkinET)
      self.player_head:SetEnableClickShowInfo(true, true)
      self.txt_name:SetColorRGBA(0.14, 0.61, 0.77, 1)
      self.txt_name:SetText(UIUtil.FormatAllianceAndName(data.avatar.abbr, data.avatar.name))
    end
  elseif data.type == 2 then
    self.txt_des:SetLocalText("season_activity_1000069_desc11")
    if data.avatar then
      self.player_head:SetHeadAndFrame(data.avatar.uid, data.avatar.headPic, data.avatar.headPicVer, nil, data.avatar.headSkinId, data.avatar.headSkinET)
      self.player_head:SetEnableClickShowInfo(true, true)
      self.txt_name:SetColorRGBA(0.14, 0.61, 0.77, 1)
      self.txt_name:SetText(UIUtil.FormatAllianceAndName(data.avatar.abbr, data.avatar.name))
    end
  end
  if data.time then
    self.txt_time:SetText(UITimeManager:GetInstance():ConvertServerTimeToLocalTime(data.time, false))
  else
    self.txt_time:SetText("")
  end
end

return SandWormHistoryItem
