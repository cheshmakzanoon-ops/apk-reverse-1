local base = UIBaseContainer
local UIGhostParkourMatchPlayerItem = BaseClass("UIGhostParkourMatchPlayerItem", base)
local bg_path = "Bg"
local u_i_player_head_path = "UIPlayerHead"
local rank_icon_path = "RankIcon"
local alli_name_txt_path = "AlliNameTxt"
local player_name_txt_path = "PlayerNameTxt"
local best_time_path = "BestTime"
local best_time_txt_path = "BestTimeTxt"
local BG_PATH_OTHER = "Assets/Main/TextureEx/UIGhostParkour/lrb_YZPK_pipei_bieren.png"
local BG_PATH_SELF = "Assets/Main/TextureEx/UIGhostParkour/lrb_YZPK_pipei_ziji.png"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.bg = self:AddComponent(UIRawImage, bg_path)
  self.u_i_player_head = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.u_i_player_head:SetEnableClickShowInfo(false)
  self.rank_icon = self:AddComponent(UIRawImage, rank_icon_path)
  self.alli_name_txt = self:AddComponent(UITextMeshProUGUIEx, alli_name_txt_path)
  self.player_name_txt = self:AddComponent(UITextMeshProUGUIEx, player_name_txt_path)
  self.best_time = self:AddComponent(UITextMeshProUGUIEx, best_time_path)
  self.best_time:SetLocalText("ghost_parkour_match_best_record")
  self.best_time_txt = self:AddComponent(UITextMeshProUGUIEx, best_time_txt_path)
end

local function ComponentDestroy(self)
  self.bg = nil
  self.u_i_player_head = nil
  self.rank_icon = nil
  self.alli_name_txt = nil
  self.player_name_txt = nil
  self.best_time = nil
  self.best_time_txt = nil
end

function UIGhostParkourMatchPlayerItem:ReInit(index, data, isSelf)
  if data then
    local tier, score
    if isSelf then
      self.bg:LoadSpriteAuto(BG_PATH_SELF)
      self:InitData(data, true)
      tier = data.tier
      score = data.score
    else
      self.bg:LoadSpriteAuto(BG_PATH_OTHER)
      if data.isNpc then
        local meta = DataCenter.ParkourGhostNpcTemplateManager:GetTemplate(data.uid)
        if meta then
          local pic = meta.icon
          self.u_i_player_head:SetHead(nil, pic, nil, nil, nil)
          self.player_name_txt:SetLocalText(meta.name)
          tier = meta.tier
          score = meta.time
        else
          self.u_i_player_head:SetHead()
          self.player_name_txt:SetText("")
        end
        self.alli_name_txt:SetText("")
      else
        self:InitData(data)
        tier = data.tier
        score = data.score
      end
    end
    if tier then
      local tierMeta = DataCenter.ParkourScoreTierTemplateManager:GetTemplate(tier)
      if tierMeta then
        self.rank_icon:LoadSpriteAuto(tierMeta.icon)
      end
    end
    local str = DataCenter.LWGhostParkourDataManager:GetTimeFormat(score)
    self.best_time_txt:SetText(str)
  else
    self.u_i_player_head:SetHead()
    self.alli_name_txt:SetText("")
    self.player_name_txt:SetText("")
    self.best_time_txt:SetText("")
  end
end

function UIGhostParkourMatchPlayerItem:InitData(data, isSelf)
  if data == nil then
    return
  end
  local uid = data.uid
  local pic = data.pic
  local picVer = data.picver
  self.u_i_player_head:SetHead(uid, pic, picVer, nil, nil)
  local abbr = data.abbr
  if string.IsNullOrEmpty(abbr) then
    self.alli_name_txt:SetText("")
  elseif isSelf then
    self.alli_name_txt:SetText(data.abbr)
  else
    self.alli_name_txt:SetText("[" .. data.abbr .. "]")
  end
  self.player_name_txt:SetText(data.name)
end

UIGhostParkourMatchPlayerItem.OnCreate = OnCreate
UIGhostParkourMatchPlayerItem.OnDestroy = OnDestroy
UIGhostParkourMatchPlayerItem.ComponentDefine = ComponentDefine
UIGhostParkourMatchPlayerItem.ComponentDestroy = ComponentDestroy
return UIGhostParkourMatchPlayerItem
