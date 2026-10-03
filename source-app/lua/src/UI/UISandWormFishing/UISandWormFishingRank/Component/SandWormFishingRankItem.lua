local SandWormFishingRankItem = BaseClass("SandWormFishingRankItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local firstNameTxt_path = "firstNameTxt"
local secondNameTxt_path = "secondNameTxt"
local powerTxt_path = "scoreTxt"
local playerFlag_path = "playerFlag"
local playerIcon_path = "playerFlag/UIPlayerHead"
local headBtn_path = "playerFlag/UIPlayerHead"
local rankIcon_path = "RankIcon"
local rankIcoNum_path = "RankIconNum"
local bgImg_path = "bg"

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
  self.firstNameTxt = self:AddComponent(UIText, firstNameTxt_path)
  self.secondNameTxt = self:AddComponent(UIText, secondNameTxt_path)
  self.powerTxt = self:AddComponent(UIText, powerTxt_path)
  self.playerFlag = self:AddComponent(UIImage, playerFlag_path)
  self.playerIcon = self:AddComponent(UICommonHead, playerIcon_path)
  self.headBtn = self:AddComponent(UIButton, headBtn_path)
  self.headBtn:SetOnClick(function()
    self:OnClickHeadIcon()
  end)
  self.rankIcon = self:AddComponent(UIImage, rankIcon_path)
  self.rankIconNum = self:AddComponent(UIText, rankIcoNum_path)
  self.bgImgN = self:AddComponent(UIImage, bgImg_path)
end

local function ComponentDestroy(self)
  self.firstNameTxt = nil
  self.secondNameTxt = nil
  self.powerTxt = nil
  self.playerFlag = nil
  self.playerIcon = nil
  self.rankIcon = nil
  self.rankIconNum = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function RefreshItem(self, rankInfo, rankIndex, scoreType)
  self.rankInfo = rankInfo
  self.rank = rankIndex
  if self.rankInfo == nil then
    return
  end
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(rankInfo.uid, rankInfo.name)
  self.firstNameTxt:SetText(showName)
  local score = rankInfo.score and rankInfo.score or 0
  if scoreType == 1 then
    self.powerTxt:SetLocalText(140002, score)
  elseif scoreType == 2 then
    self.powerTxt:SetText(string.GetFormattedStr2(score))
  else
    self.powerTxt:SetText(string.GetFormattedSeparatorNum(score))
  end
  if rankInfo.abbr ~= nil then
    self.secondNameTxt:SetText("[" .. rankInfo.abbr .. "]" .. " " .. rankInfo.alName)
  else
    self.secondNameTxt:SetText("")
  end
  self.rankIconNum:SetText(self.rank)
  self.playerIcon:SetActive(true)
  self.playerIcon:SetHeadAndFrame(rankInfo.uid, rankInfo.pic, rankInfo.picVer, nil, rankInfo.headSkinId, rankInfo.headSkinET)
  self.playerIcon:SetEnableClickShowInfo(true, true)
  self.SetRankIcon(self.rankIcon, self.rank)
  local color = Color.New(0, 0, 0, 1)
  if self.rank == 1 then
    self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_1.png")
    color = Color.New(0.8156862745098039, 0.4823529411764706, 0.047058823529411764, 1)
  elseif self.rank == 2 then
    self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_2.png")
    color = Color.New(0.4, 0.4549019607843137, 0.7294117647058823, 1)
  elseif self.rank == 3 then
    self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_3.png")
    color = Color.New(0.7176470588235294, 0.4666666666666667, 0.34509803921568627, 1)
  else
    self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_4.png")
  end
  self.firstNameTxt:SetColor(color)
  self.secondNameTxt:SetColor(color)
  self.powerTxt:SetColor(color)
end

local function SetRankIcon(image, rank)
  if IsNull(image.gameObject) then
    return
  end
  image:SetActive(rank <= 3 and 1 <= rank)
  if rank <= 3 then
    if rank == 1 then
      image:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_1.png")
    elseif rank == 2 then
      image:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_2.png")
    elseif rank == 3 then
      image:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_3.png")
    end
  end
end

local function OnClickHeadIcon(self)
  if self.rankInfo.uid == LuaEntry.Player.uid then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true, hideTop = true}, self.rankInfo.uid)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.rankInfo.uid)
  end
end

SandWormFishingRankItem.OnCreate = OnCreate
SandWormFishingRankItem.OnDestroy = OnDestroy
SandWormFishingRankItem.OnEnable = OnEnable
SandWormFishingRankItem.OnDisable = OnDisable
SandWormFishingRankItem.ComponentDefine = ComponentDefine
SandWormFishingRankItem.ComponentDestroy = ComponentDestroy
SandWormFishingRankItem.DataDefine = DataDefine
SandWormFishingRankItem.DataDestroy = DataDestroy
SandWormFishingRankItem.RefreshItem = RefreshItem
SandWormFishingRankItem.OnClickHeadIcon = OnClickHeadIcon
SandWormFishingRankItem.SetRankIcon = SetRankIcon
return SandWormFishingRankItem
