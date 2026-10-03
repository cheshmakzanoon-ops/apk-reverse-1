local base = UIBaseView
local SeasonHunterMVP = BaseClass("SeasonHunterMVP", base)
local Localization = CS.GameEntry.Localization
local btnBack_path = "Root/BtnGet"
local Item1_path = "Root/Content/Item1"
local player1_path = "Root/Content/Item1/Head/player1"
local Value1_path = "Root/Content/Item1/Value1"
local Name1_path = "Root/Content/Item1/Name1"
local Item2_path = "Root/Content/Item2"
local player2_path = "Root/Content/Item2/Head/player2"
local Value2_path = "Root/Content/Item2/Value2"
local Name2_path = "Root/Content/Item2/Name2"
local Item3_path = "Root/Content/Item3"
local player3_path = "Root/Content/Item3/Head/player3"
local Value3_path = "Root/Content/Item3/Value3"
local Name3_path = "Root/Content/Item3/Name3"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView(self:GetUserData())
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btnBack = self:AddComponent(UIButton, btnBack_path)
  self.Item1 = self:AddComponent(UIBaseContainer, Item1_path)
  self.player1 = self:AddComponent(UIBaseContainer, player1_path)
  self.Value1 = self:AddComponent(UIText, Value1_path)
  self.Name1 = self:AddComponent(UIText, Name1_path)
  self.Item2 = self:AddComponent(UIBaseContainer, Item2_path)
  self.player2 = self:AddComponent(UIBaseContainer, player2_path)
  self.Value2 = self:AddComponent(UIText, Value2_path)
  self.Name2 = self:AddComponent(UIText, Name2_path)
  self.Item3 = self:AddComponent(UIBaseContainer, Item3_path)
  self.player3 = self:AddComponent(UIBaseContainer, player3_path)
  self.Value3 = self:AddComponent(UIText, Value3_path)
  self.Name3 = self:AddComponent(UIText, Name3_path)
  self.btnBack:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.playerIcon1 = self:AddComponent(UICommonHead, player1_path)
  self.playerIcon1:SetEnableClickShowInfo(true, true)
  self.playerIcon2 = self:AddComponent(UICommonHead, player2_path)
  self.playerIcon2:SetEnableClickShowInfo(true, true)
  self.playerIcon3 = self:AddComponent(UICommonHead, player3_path)
  self.playerIcon3:SetEnableClickShowInfo(true, true)
end

local function ComponentDestroy(self)
  self.btnBack = nil
  self.Item1 = nil
  self.player1 = nil
  self.Value1 = nil
  self.Name1 = nil
  self.Item2 = nil
  self.player2 = nil
  self.Value2 = nil
  self.Name2 = nil
  self.Item3 = nil
  self.player3 = nil
  self.Value3 = nil
  self.Name3 = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SeasonHunterMVP:RefreshView(mvpInfo)
  if mvpInfo == nil then
    return
  end
  local data = mvpInfo.killMvpInfo
  local score = data and data.score and tonumber(data.score) or 0
  if 0 < score then
    self.Item1:SetActive(true)
    self.Value1:SetText(string.GetFormattedSeperatorNum(math.floor(score)))
    if string.IsNullOrEmpty(data.abbr) then
      self.Name1:SetText(string.format([[
#%s
%s]], data.serverId, data.name))
    else
      self.Name1:SetText(string.format([[
#%s[%s]
%s]], data.serverId, data.abbr, data.name))
    end
    self.playerIcon1:SetHeadAndFrame(data.uid, data.pic, data.picVer, nil, data.headSkinId, data.headSkinET)
  else
    self.Item1:SetActive(false)
  end
  data = mvpInfo.lifeTimeMvpInfo
  score = data and data.score and tonumber(data.score) or 0
  if 0 < score then
    self.Item2:SetActive(true)
    self.Value2:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(score))
    if string.IsNullOrEmpty(data.abbr) then
      self.Name2:SetText(string.format([[
#%s
%s]], data.serverId, data.name))
    else
      self.Name2:SetText(string.format([[
#%s[%s]
%s]], data.serverId, data.abbr, data.name))
    end
    self.playerIcon2:SetHeadAndFrame(data.uid, data.pic, data.picVer, nil, data.headSkinId, data.headSkinET)
  else
    self.Item2:SetActive(false)
  end
  data = mvpInfo.scoreMvpInfo
  score = data and data.score and tonumber(data.score) or 0
  if 0 < score then
    self.Item3:SetActive(true)
    self.Value3:SetText(string.GetFormattedSeperatorNum(math.floor(score)))
    if string.IsNullOrEmpty(data.abbr) then
      self.Name3:SetText(string.format([[
#%s
%s]], data.serverId, data.name))
    else
      self.Name3:SetText(string.format([[
#%s[%s]
%s]], data.serverId, data.abbr, data.name))
    end
    self.playerIcon3:SetHeadAndFrame(data.uid, data.pic, data.picVer, nil, data.headSkinId, data.headSkinET)
  else
    self.Item3:SetActive(false)
  end
end

SeasonHunterMVP.OnCreate = OnCreate
SeasonHunterMVP.OnDestroy = OnDestroy
SeasonHunterMVP.OnEnable = OnEnable
SeasonHunterMVP.OnDisable = OnDisable
SeasonHunterMVP.ComponentDefine = ComponentDefine
SeasonHunterMVP.ComponentDestroy = ComponentDestroy
SeasonHunterMVP.DataDefine = DataDefine
SeasonHunterMVP.DataDestroy = DataDestroy
return SeasonHunterMVP
