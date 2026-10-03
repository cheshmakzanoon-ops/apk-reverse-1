local UIEpidemicBattleStatusItem = BaseClass("UIEpidemicBattleStatusItem", UIBaseContainer)
local base = UIBaseContainer
local bg_path = "bg"
local name_txt_path = "nameTxt"
local power_txt_path = "powerTxt"
local rank_img_path = "rankImg"
local num_txt_ex_path = "rankImg/numTxtEx"
local num_txt_path = "numTxt"
local player_path = "player"

function UIEpidemicBattleStatusItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.name_txt = self:AddComponent(UITextMeshProUGUIEx, name_txt_path)
  self.power_txt = self:AddComponent(UITextMeshProUGUIEx, power_txt_path)
  self.num_txt = self:AddComponent(UITextMeshProUGUIEx, num_txt_path)
  self.rank_img = self:AddComponent(UIImage, rank_img_path)
  self.num_txt_ex = self:AddComponent(UITextMeshProUGUIEx, num_txt_ex_path)
  self.player_flag = self:AddComponent(UICommonHead, player_path)
  self.player_flag:SetEnableClickShowInfo(true, true)
end

function UIEpidemicBattleStatusItem:ReInit(data, index, isSelf, tabIdx)
  self.data = data
  local rank = index
  if data ~= nil then
    rank = toInt(data.rank)
  end
  local power = 0
  if data ~= nil then
    if tabIdx == 1 then
      power = data.score or 0
    elseif tabIdx == 2 then
      power = data.battleScore or 0
    elseif tabIdx == 3 then
      power = data.cooperationScore or 0
    elseif tabIdx == 4 then
      power = data.tacticsScore or 0
    end
  end
  local name = data ~= nil and UIUtil.FormatAllianceAndName(data.abbr, data.name, data.uid) or "?"
  local bgPath
  local spRank = true
  if rank == 1 then
    self.rank_img:LoadSpriteAuto(string.format(LoadPath.CommonApsNewPath, "lyp_huodong_zqzhg_paihangbang_1"))
    bgPath = "ljq_tongyong_paihangbang_1"
  elseif rank == 2 then
    self.rank_img:LoadSpriteAuto(string.format(LoadPath.CommonApsNewPath, "lyp_huodong_zqzhg_paihangbang_2"))
    bgPath = "ljq_tongyong_paihangbang_2"
  elseif rank == 3 then
    self.rank_img:LoadSpriteAuto(string.format(LoadPath.CommonApsNewPath, "lyp_huodong_zqzhg_paihangbang_3"))
    bgPath = "ljq_tongyong_paihangbang_3"
  else
    spRank = false
    bgPath = "ljq_tongyong_paihangbang_4"
  end
  if isSelf or data.uid == LuaEntry.Player.uid then
    bgPath = "ljq_tongyong_paihangbang_5"
    name = LuaEntry.Player:GetFullName()
  end
  self.bg:LoadSpriteAuto(string.format(LoadPath.CommonApsNewPath, bgPath))
  self.rank_img:SetActive(spRank)
  self.num_txt:SetActive(not spRank)
  if spRank then
    self.num_txt_ex:SetText(rank)
  else
    self.num_txt:SetText(0 < rank and rank or "?")
  end
  self.power_txt:SetText(string.GetFormattedSeparatorNum(power))
  self.name_txt:SetText(name)
  if isSelf then
    local player = LuaEntry.Player
    self.player_flag:SetHead(player.uid, player.pic, player.picVer)
  else
    self.player_flag:SetHead(data.uid, data.pic, data.picVer)
  end
end

return UIEpidemicBattleStatusItem
