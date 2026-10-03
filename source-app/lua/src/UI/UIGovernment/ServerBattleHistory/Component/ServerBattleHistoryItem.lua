local ServerBattleHistoryItem = BaseClass("ServerBattleHistoryItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local bg_path = "bg"
local home_icon_path = "serverFlag"
local icon_path = "serverFlag/icon"
local server_id_path = "serverFlag/icon/serverId"
local button_path = "Button"
local wk1_path = "wk1"
local wk2_path = "wk2"
local status1_win_path = "wk1/status1Win"
local status1_lost_path = "wk1/status1Lost"
local status2_win_path = "wk2/status2Win"
local status2_lost_path = "wk2/status2Lost"
local rank_txt_path = "rankTxt"
local first_img_path = "firstImg"
local second_img_path = "secondImg"
local third_img_path = "thirdImg"

function ServerBattleHistoryItem:OnCreate()
  base.OnCreate(self)
  self.first_img = self:AddComponent(UIImage, first_img_path)
  self.second_img = self:AddComponent(UIImage, second_img_path)
  self.third_img = self:AddComponent(UIImage, third_img_path)
  self.rank_txt = self:AddComponent(UIText, rank_txt_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.home_icon = self:AddComponent(UIImage, home_icon_path)
  self.server_id = self:AddComponent(UIText, server_id_path)
  self.button = self:AddComponent(UIButton, button_path)
  self.wk1 = self:AddComponent(UIText, wk1_path)
  self.wk2 = self:AddComponent(UIText, wk2_path)
  self.status1_win = self:AddComponent(UIText, status1_win_path)
  self.status1_lost = self:AddComponent(UIText, status1_lost_path)
  self.status2_win = self:AddComponent(UIText, status2_win_path)
  self.status2_lost = self:AddComponent(UIText, status2_lost_path)
end

function ServerBattleHistoryItem:OnDestroy()
  base.OnDestroy(self)
end

function ServerBattleHistoryItem:ReInit(curRound, index, data, serverInfo)
  local player = LuaEntry.Player
  local mySeverId = player:GetSourceServerId()
  self.index = index
  self.wk1:SetActive(false)
  self.wk2:SetActive(false)
  self.server_id:SetText("#" .. data.serverId)
  if mySeverId == data.serverId then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_fuwuqibg02.png")
  else
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_fuwuqibg01.png")
  end
  if serverInfo then
    self.cfgId = serverInfo.cfgId or 511001
  else
    self.cfgId = 511001
  end
  if self.cfgId then
    local itemCfg = DataCenter.ItemTemplateManager:GetItemTemplate(self.cfgId)
    if itemCfg ~= nil then
      self.home_icon:LoadSprite(string.format(LoadPath.ItemPath, itemCfg.icon))
    end
  end
  for _, v in ipairs(data.battleList) do
    if v.round == 1 then
      self.wk1:SetActive(true)
      self.wk1:SetText("vs #" .. v.vsServerId)
      self.status1_win:SetActive(v.win == 1)
      self.status1_lost:SetActive(v.win ~= 1)
      if v.vsServerId == mySeverId then
        self.icon:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_difang_fuwuqibg.png")
      end
    elseif v.round == 2 then
      self.wk2:SetActive(true)
      self.wk2:SetText("vs #" .. v.vsServerId)
      self.status2_win:SetActive(v.win == 1)
      self.status2_lost:SetActive(v.win ~= 1)
      if v.vsServerId == mySeverId then
        self.icon:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_difang_fuwuqibg.png")
      end
    end
  end
  local rank = index
  local bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_huisetiao"
  if rank == 1 then
    bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_jinsetiao"
  elseif rank == 2 then
    bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_yinsetiao"
  elseif rank == 3 then
    bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_tongsetiao"
  else
    self.rank_txt:SetText(tostring(rank))
  end
  self.bg:LoadSprite(bgPath)
  self.first_img:SetActive(rank == 1)
  self.second_img:SetActive(rank == 2)
  self.third_img:SetActive(rank == 3)
  self.rank_txt:SetActive(3 < rank)
end

return ServerBattleHistoryItem
