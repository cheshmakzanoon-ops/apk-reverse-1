local UIDesertBattleStatusItem = BaseClass("UIDesertBattleStatusItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local bg_path = "bg"
local first_name_txt_path = "Name/firstNameTxt"
local power_txt_path = "powerTxt"
local first_img_path = "firstImg"
local second_img_path = "secondImg"
local third_img_path = "thirdImg"
local num_txt_path = "numTxt"
local player_path = "player"
local button_path = "Button"

function UIDesertBattleStatusItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.first_txt = self:AddComponent(UIText, first_name_txt_path)
  self.power_txt = self:AddComponent(UIText, power_txt_path)
  self.num_txt = self:AddComponent(UIText, num_txt_path)
  self.first_flag = self:AddComponent(UIBaseContainer, first_img_path)
  self.second_flag = self:AddComponent(UIBaseContainer, second_img_path)
  self.third_flag = self:AddComponent(UIBaseContainer, third_img_path)
  self.player_flag = self:AddComponent(UICommonHead, player_path)
end

function UIDesertBattleStatusItem:OnDestroy()
  base.OnDestroy(self)
end

function UIDesertBattleStatusItem:OnEnable()
  base.OnEnable(self)
end

function UIDesertBattleStatusItem:OnDisable()
  base.OnDisable(self)
end

function UIDesertBattleStatusItem:ReInit(data, isSelf)
  local power_color = "#2a2830"
  local first_color = "#2a2830"
  local second_color = "#6d82ad"
  local bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_huisetiao"
  if isSelf or data.uid == LuaEntry.Player.uid then
    power_color = "#4a9327"
    first_color = "#4a9327"
    second_color = "#14a91b"
    bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_lvsetiao"
  elseif data.rank == 1 then
    power_color = "#d07b0c"
    first_color = "#d07b0c"
    second_color = "#b78026"
    bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_jinsetiao"
  elseif data.rank == 2 then
    power_color = "#6674ba"
    first_color = "#6674ba"
    second_color = "#5065cb"
    bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_yinsetiao"
  elseif data.rank == 3 then
    power_color = "#b77758"
    first_color = "#b77758"
    second_color = "#ba6744"
    bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_tongsetiao"
  end
  self.data = data
  if isSelf then
    local player = LuaEntry.Player
    self.player_flag:SetHead(player.uid, player.pic, player.picVer)
  else
    self.player_flag:SetHead(data.uid, data.pic, data.picVer)
  end
  if data ~= nil then
    if type(data.rank) == "number" and data.rank > 0 then
      self.num_txt:SetText(data.rank)
    else
      self.num_txt:SetText("?")
    end
    self.bg:LoadSpriteAuto(bgPath)
    self.first_flag:SetActive(self.data.rank == 1)
    self.second_flag:SetActive(self.data.rank == 2)
    self.third_flag:SetActive(self.data.rank == 3)
    self.power_txt:SetText("<color=" .. power_color .. ">" .. self.data.score .. "</color>")
    self.first_txt:SetText("<color=" .. first_color .. ">" .. self.data.name .. "</color>")
  else
    self.first_txt:SetText(LuaEntry.Player:GetFullName())
    self.power_txt:SetText("0")
    self.num_txt:SetText("?")
    self.first_flag:SetActive(false)
    self.second_flag:SetActive(false)
    self.third_flag:SetActive(false)
  end
end

return UIDesertBattleStatusItem
