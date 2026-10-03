local base = UIBaseView
local SeasonHunterResult = BaseClass("SeasonHunterResult", base)
local Localization = CS.GameEntry.Localization
local UIDynamicSkin = require("Framework.UI.Component.UIDynamicSkin")
local btnClose_path = "panel"
local txtTitle_path = "Root/titleText"
local root_path = "Root"
local tips1_path = "Root/Content/tipsRoot/tips1"
local tips_path = "Root/Content/tipsRoot/tips"
local rank_path = "Root/Content/tipsRoot/rank"
local result1_path = "Root/Content/TipsItem1/detail/result1"
local result1Value_path = "Root/Content/TipsItem1/detail/result1Value"
local result1Rank_path = "Root/Content/TipsItem1/detail/result1Rank"
local result2_path = "Root/Content/TipsItem2/detail/result2"
local result2Value_path = "Root/Content/TipsItem2/detail/result2Value"
local result2Rank_path = "Root/Content/TipsItem2/detail/result2Rank"
local head_path = "Root/Title/Player/Head/UIPlayerHead"

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
  DataCenter.SeasonHunterManager:ShowMvp()
end

local function ComponentDefine(self)
  self.btnClose = self:AddComponent(UIButton, btnClose_path)
  self.txtTitle = self:AddComponent(UIText, txtTitle_path)
  self.tips1 = self:AddComponent(UIText, tips1_path)
  self.tips = self:AddComponent(UIText, tips_path)
  self.rank = self:AddComponent(UIText, rank_path)
  self.result1 = self:AddComponent(UIText, result1_path)
  self.result1Value = self:AddComponent(UIText, result1Value_path)
  self.result1Rank = self:AddComponent(UIText, result1Rank_path)
  self.result2 = self:AddComponent(UIText, result2_path)
  self.result2Value = self:AddComponent(UIText, result2Value_path)
  self.result2Rank = self:AddComponent(UIText, result2Rank_path)
  self.head = self:AddComponent(UIBaseContainer, head_path)
  self.btnClose:SetOnClick(BindCallback(self, self.CloseSelf))
  self.skinMgr = self:AddComponent(UIDynamicSkin, "")
  self.playerIcon = self:AddComponent(UICommonHead, head_path)
  self.playerIcon:SetEnableClickShowInfo(true, true)
  self.anim = self:AddComponent(UISimpleAnimation, root_path)
end

local function ComponentDestroy(self)
  self.btnClose = nil
  self.txtTitle = nil
  self.root = nil
  self.tips1 = nil
  self.tips = nil
  self.rank = nil
  self.result1 = nil
  self.result1Value = nil
  self.result1Rank = nil
  self.result2 = nil
  self.result2Value = nil
  self.result2Rank = nil
  self.head = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SeasonHunterResult:RefreshView(result)
  if not result then
    self.ctrl:CloseSelf()
    return
  end
  self.result = result
  self.openTime = UITimeManager:GetInstance():GetServerTime()
  local data = LuaEntry.Player
  self.playerIcon:SetData(data.uid, data.pic, data.picVer, false, string.format(LoadPath.UISeason4Path, "Hunter/ljq_s4_xueselieren_shengli_toukui_02.png"))
  if result.result == 1 then
    self:OnSuccess(result)
    self.anim:Play("Default")
  else
    self:OnFail(result)
    self.anim:Play("fail")
  end
  if not table.IsNullOrEmpty(result.mvpInfo) then
    DataCenter.SeasonHunterManager:ShowMvp(result.mvpInfo)
  end
end

function SeasonHunterResult:OnSuccess(result)
  self.skinMgr:ActiveSkin(SeasonMapType.Darkness)
  self.txtTitle:SetLocalText("season_s4_activity_1200011_desc30")
  self.tips:SetLocalText("season_s4_activity_1200011_desc31")
  if not result.matchRank or result.matchRank <= 0 then
    self.rank:SetActive(false)
    self.tips1:SetActive(false)
  else
    self.rank:SetText(result.matchRank)
    self.rank:SetActive(true)
    self.tips1:SetActive(true)
  end
  self.result1Value:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(result.lifeTime))
  if 0 >= result.timeRank or 0 >= result.total then
    self.result1Rank:SetLocalText("361054")
  else
    local value = (result.total - result.timeRank) / result.total * 100
    value = string.format("%.1f", value)
    self.result1Rank:SetText(Localization:GetString("season_s4_activity_1200011_desc35", value))
  end
  self.result1Rank:SetActive(true)
  self.result2Value:SetText(string.GetFormattedSeperatorNum(math.floor(result.score)))
  if result.matchRank <= 0 or 0 >= result.total then
    self.result2Rank:SetLocalText("361054")
  else
    local value = (result.total - result.matchRank) / result.total * 100
    value = string.format("%.1f", value)
    self.result2Rank:SetText(Localization:GetString("season_s4_activity_1200011_desc35", value))
  end
  self.result2Rank:SetActive(true)
end

function SeasonHunterResult:OnFail(result)
  self.skinMgr:ActiveSkin(SeasonMapType.Nothing)
  self.txtTitle:SetLocalText("season_s4_activity_1200011_desc36")
  self.tips:SetLocalText("season_s4_activity_1200011_desc37")
  if not result.matchRank or result.matchRank <= 0 then
    self.rank:SetActive(false)
    self.tips1:SetActive(false)
  else
    self.rank:SetText(result.matchRank)
    self.rank:SetActive(true)
    self.tips1:SetActive(true)
  end
  self.result1Value:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(result.lifeTime))
  self.result1Rank:SetActive(false)
  self.result2Value:SetText(string.GetFormattedSeperatorNum(math.floor(result.score)))
  self.result2Rank:SetActive(false)
end

function SeasonHunterResult:CloseSelf()
  if self.openTime and self.openTime + 1200 > UITimeManager:GetInstance():GetServerTime() then
    return
  end
  self.ctrl:CloseSelf()
end

SeasonHunterResult.OnCreate = OnCreate
SeasonHunterResult.OnDestroy = OnDestroy
SeasonHunterResult.OnEnable = OnEnable
SeasonHunterResult.OnDisable = OnDisable
SeasonHunterResult.ComponentDefine = ComponentDefine
SeasonHunterResult.ComponentDestroy = ComponentDestroy
SeasonHunterResult.DataDefine = DataDefine
SeasonHunterResult.DataDestroy = DataDestroy
return SeasonHunterResult
