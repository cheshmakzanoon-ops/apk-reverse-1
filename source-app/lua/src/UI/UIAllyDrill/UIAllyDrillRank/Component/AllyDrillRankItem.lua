local AllyDrillRankItem = BaseClass("AllyDrillRankItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.bg = self:AddComponent(UIImage, "bg")
  self.nameTxt = self:AddComponent(UIText, "nameTxt")
  self.damageTxt = self:AddComponent(UITextMeshProUGUIEx, "damageTxt")
  self.head = self:AddComponent(UICommonHead, "headNode/head")
  self.rankIcon = self:AddComponent(UIImage, "rankIcon")
  self.rankTxt = self:AddComponent(UITextMeshProUGUIEx, "rankTxt")
  self.txt = self:AddComponent(UITextMeshProUGUIEx, "txt")
  self.txt:SetLocalText("2010314")
end

local function ComponentDestroy(self)
  self.bg = nil
  self.nameTxt = nil
  self.damageTxt = nil
  self.head = nil
  self.rankIcon = nil
  self.rankTxt = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function Refresh(self, data)
  self.uid = data.uid
  local rank = data.rank
  local damage = data.damage
  local name = data.name
  local color = Color.New(0, 0, 0, 1)
  if self.uid == LuaEntry.Player.uid then
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_lvsetiao.png")
    color = Color.New(0.2901960784313726, 0.5764705882352941, 0.15294117647058825, 1)
  elseif rank == 1 then
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_jinsetiao.png")
    color = Color.New(0.8156862745098039, 0.4823529411764706, 0.047058823529411764, 1)
  elseif rank == 2 then
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_yinsetiao.png")
    color = Color.New(0.4, 0.4549019607843137, 0.7294117647058823, 1)
  elseif rank == 3 then
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_tongsetiao.png")
    color = Color.New(0.7176470588235294, 0.4666666666666667, 0.34509803921568627, 1)
  else
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_huisetiao.png")
  end
  self.nameTxt:SetColor(color)
  self.nameTxt:SetText(UIUtil.FormatAllianceAndName(data.abbr, data.name))
  self.damageTxt:SetLocalText(2010337, string.GetFormattedStr2(damage))
  self.rankTxt:SetText(rank)
  self.head:SetEnableClickShowInfo(true, true)
  self.head:SetHeadAndFrame(data.uid, data.pic, data.picVer, false, data.headSkinId, data.headSkinET)
  self:SetRankIcon(rank)
end

local function SetRankIcon(self, rank)
  self.rankIcon:SetActive(rank <= 3 and 1 <= rank)
  if rank <= 3 then
    if rank == 1 then
      self.rankIcon:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_1.png")
    elseif rank == 2 then
      self.rankIcon:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_2.png")
    elseif rank == 3 then
      self.rankIcon:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_3.png")
    end
  end
end

AllyDrillRankItem.OnCreate = OnCreate
AllyDrillRankItem.OnDestroy = OnDestroy
AllyDrillRankItem.OnEnable = OnEnable
AllyDrillRankItem.OnDisable = OnDisable
AllyDrillRankItem.ComponentDefine = ComponentDefine
AllyDrillRankItem.ComponentDestroy = ComponentDestroy
AllyDrillRankItem.DataDefine = DataDefine
AllyDrillRankItem.DataDestroy = DataDestroy
AllyDrillRankItem.Refresh = Refresh
AllyDrillRankItem.SetRankIcon = SetRankIcon
return AllyDrillRankItem
