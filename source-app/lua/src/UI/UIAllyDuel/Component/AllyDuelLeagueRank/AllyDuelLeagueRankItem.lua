local AllyDuelLeagueRankItem = BaseClass("AllyDuelLeagueRankItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local SpritePath = {
  [0] = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_zhanqupaiming_lose.png",
  [1] = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_zhanqupaiming_win.png",
  [2] = "Assets/Main/Sprites/UI/UIMain/UIMainNew/jiantou_battle.png",
  [3] = "Assets/Main/Sprites/UI/UIAllyDuel/sj_liamengduijue_zzz.png"
}

function AllyDuelLeagueRankItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllyDuelLeagueRankItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllyDuelLeagueRankItem:ComponentDefine()
  self.bg = self:AddComponent(UIImage, "bg")
  self.rankIcon = self:AddComponent(UIImage, "rankIcon")
  self.rankTxt = self:AddComponent(UIText, "rankTxt")
  self.flag = self:AddComponent(UIImage, "flag")
  self.abbr = self:AddComponent(UIText, "abbr")
  self.name = self:AddComponent(UIText, "name")
  self.up = self:AddComponent(UIBaseComponent, "up")
  self.down = self:AddComponent(UIBaseComponent, "down")
  self.week = {}
  self.weekBtn = {}
  for i = 1, 4 do
    self.week[i] = self:AddComponent(UIImage, "week" .. i)
    self.weekBtn[i] = self:AddComponent(UIButton, "week" .. i)
    self.weekBtn[i]:SetOnClick(function()
      self:OnClickWeekBtn(i)
    end)
  end
  self.allyBtn = self:AddComponent(UIButton, "allyBtn")
  self.allyBtn:SetOnClick(function()
    self:OnClickAllyBtn()
  end)
end

function AllyDuelLeagueRankItem:ComponentDestroy()
end

function AllyDuelLeagueRankItem:DataDefine()
end

function AllyDuelLeagueRankItem:DataDestroy()
end

function AllyDuelLeagueRankItem:OnEnable()
  base.OnEnable(self)
end

function AllyDuelLeagueRankItem:OnDisable()
  base.OnDisable(self)
end

function AllyDuelLeagueRankItem:OnAddListener()
  base.OnAddListener(self)
end

function AllyDuelLeagueRankItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function AllyDuelLeagueRankItem:Refresh(data, showUp, showDown)
  self.roundResult = data.roundResult
  self.allianceId = data.allianceId
  self.allianceName = data.name
  local rank = data.rank
  local color = Color.New(0, 0, 0, 1)
  if data.allianceId == LuaEntry.Player.allianceId then
    self.bg:LoadSpriteAuto("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_lvsetiao.png")
    color = Color.New(0.29, 0.58, 0.15, 1)
  elseif rank == 1 then
    self.bg:LoadSpriteAuto("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_jinsetiao.png")
    color = Color.New(0.8156862745098039, 0.4823529411764706, 0.047058823529411764, 1)
  elseif rank == 2 then
    self.bg:LoadSpriteAuto("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_yinsetiao.png")
    color = Color.New(0.4, 0.4549019607843137, 0.7294117647058823, 1)
  elseif rank == 3 then
    self.bg:LoadSpriteAuto("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_tongsetiao.png")
    color = Color.New(0.7176470588235294, 0.4666666666666667, 0.34509803921568627, 1)
  else
    self.bg:LoadSpriteAuto("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_huisetiao.png")
  end
  if data.fake == 1 then
    self.name:SetLocalText(312059)
  else
    self.abbr:SetText("[" .. data.abbr .. "]")
    self.name:SetText(data.name)
  end
  self.abbr:SetColor(color)
  self.name:SetColor(color)
  self.rankTxt:SetText(rank)
  self:SetRankIcon(rank)
  self.up:SetActive(showUp)
  self.down:SetActive(showDown)
  self.flag:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, data.icon))
  local arr = string.split(self.roundResult, ";")
  local isFighting = true
  for i = 1, 4 do
    if string.IsNullOrEmpty(arr[i]) then
      if isFighting then
        isFighting = false
        self.week[i]:LoadSpriteAuto(SpritePath[2])
      else
        self.week[i]:LoadSpriteAuto(SpritePath[3])
      end
    else
      self.week[i]:LoadSpriteAuto(SpritePath[tonumber(arr[i])])
    end
  end
end

function AllyDuelLeagueRankItem:SetRankIcon(rank)
  self.rankIcon:SetActive(rank <= 3 and 1 <= rank)
  if rank <= 3 then
    if rank == 1 then
      self.rankIcon:LoadSpriteAuto("Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang01.png")
    elseif rank == 2 then
      self.rankIcon:LoadSpriteAuto("Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang02.png")
    elseif rank == 3 then
      self.rankIcon:LoadSpriteAuto("Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang03.png")
    end
  end
end

function AllyDuelLeagueRankItem:OnClickHistoryBtn()
  if not string.IsNullOrEmpty(self.roundResult) then
    EventManager:GetInstance():Broadcast(EventId.AllyDuelLeagueRankItemTip, {
      data = self.roundResult,
      pos = self.historyBtn.transform.position
    })
  else
    UIUtil.ShowTipsId(459019)
  end
end

function AllyDuelLeagueRankItem:OnClickWeekBtn(i)
  local curWeek = DataCenter.LeagueMatchManager:GetWeekCount()
  if i > curWeek then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllyDuelLeagueHistory, {anim = true}, i, self.allianceId)
end

function AllyDuelLeagueRankItem:OnClickAllyBtn()
  if not string.IsNullOrEmpty(self.allianceId) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true}, self.allianceName, self.allianceId)
  end
end

return AllyDuelLeagueRankItem
