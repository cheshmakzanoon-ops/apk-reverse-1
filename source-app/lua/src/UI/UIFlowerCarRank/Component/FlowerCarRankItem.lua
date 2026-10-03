local FlowerCarRankItem = BaseClass("FlowerCarRankItem", UIBaseContainer)
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
  self.damageTxt = self:AddComponent(UIText, "damageTxt")
  self.head = self:AddComponent(UICommonHead, "headNode/head")
  self.head:SetEnableClickShowInfo(true, true)
  self.rankIcon = self:AddComponent(UIImage, "rankIcon")
  self.rankTxt = self:AddComponent(UIText, "rankTxt")
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
  local rank = data.rank
  local damage = data.damage
  local color = Color.New(0, 0, 0, 1)
  if rank == 1 then
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_1.png")
    color = Color.New(0.8156862745098039, 0.4823529411764706, 0.047058823529411764, 1)
  elseif rank == 2 then
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_2.png")
    color = Color.New(0.4, 0.4549019607843137, 0.7294117647058823, 1)
  elseif rank == 3 then
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_3.png")
    color = Color.New(0.7176470588235294, 0.4666666666666667, 0.34509803921568627, 1)
  else
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_4.png")
  end
  self.nameTxt:SetColor(color)
  self.damageTxt:SetText(string.GetFormattedStr2(damage))
  self.rankTxt:SetText(rank == 0 and "" or rank)
  if data.uid then
    self.head:SetHeadAndFrame(data.uid, data.headPic, data.headPicVer, false, data.headSkinId, data.headSkinET)
    self.nameTxt:SetText(UIUtil.FormatAllianceAndName(data.abbr, data.name))
  else
    self.head:SetAsMyself()
    self.nameTxt:SetText(LuaEntry.Player:GetFullName())
  end
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

FlowerCarRankItem.OnCreate = OnCreate
FlowerCarRankItem.OnDestroy = OnDestroy
FlowerCarRankItem.OnEnable = OnEnable
FlowerCarRankItem.OnDisable = OnDisable
FlowerCarRankItem.ComponentDefine = ComponentDefine
FlowerCarRankItem.ComponentDestroy = ComponentDestroy
FlowerCarRankItem.DataDefine = DataDefine
FlowerCarRankItem.DataDestroy = DataDestroy
FlowerCarRankItem.Refresh = Refresh
FlowerCarRankItem.SetRankIcon = SetRankIcon
return FlowerCarRankItem
