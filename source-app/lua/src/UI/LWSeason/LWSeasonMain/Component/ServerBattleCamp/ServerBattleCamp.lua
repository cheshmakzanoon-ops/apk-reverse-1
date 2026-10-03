local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local ServerBattleCamp = BaseClass("ServerBattleCamp", base)
local Localization = CS.GameEntry.Localization
local TitleText_path = "RightView/Rect_Top/Top/TitleText"
local TimeText_path = "RightView/Rect_Top/Top/time/TimeText"
local IntroBtn_path = "RightView/Rect_Top/DescBtn"
local Desc_path = "RightView/Rect_Bottom/Desc"
local Bg_path = "ImageBg2"
local RankL1_path = "RightView/Rect_Bottom/left/rank1/Text1"
local RankL2_path = "RightView/Rect_Bottom/left/rank2/Text2"
local RankL3_path = "RightView/Rect_Bottom/left/rank3/Text3"
local RankL4_path = "RightView/Rect_Bottom/left/rank4/Text4"
local RankR1_path = "RightView/Rect_Bottom/right/rank1/Text1r"
local RankR2_path = "RightView/Rect_Bottom/right/rank2/Text2r"
local RankR3_path = "RightView/Rect_Bottom/right/rank3/Text3r"
local RankR4_path = "RightView/Rect_Bottom/right/rank4/Text4r"
local GotoBtn_path = "BtnGoto"
local RankBtn_path = "BtnRank"
local Item_path = "RightView/Rect_Bottom/Item"
local ItemIcon_path = "RightView/Rect_Bottom/Item/itemIcon"
local ItemName_path = "RightView/Rect_Bottom/Item/itemName"
local __SeasonInfo = {
  [SeasonMapType.Nothing] = {
    resourceType = ResourceType.AllianceStone
  },
  [SeasonMapType.Snow] = {
    resourceType = ResourceType.AllianceStone
  },
  [SeasonMapType.Mummy] = {
    resourceType = ResourceType.AllianceStone
  },
  [SeasonMapType.Darkness] = {
    resourceType = ResourceType.AllianceStone,
    effectPath = "Assets/Main/SeasonRes/S4/Prefabs/Effect/ServerBattleCampS4/Eff_ServerBattleCampS4_BG.prefab"
  }
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
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
  self.TitleText = self:AddComponent(UIText, TitleText_path)
  self.TimeText = self:AddComponent(UIText, TimeText_path)
  self.IntroBtn = self:AddComponent(UIButton, IntroBtn_path)
  self.Desc = self:AddComponent(UIText, Desc_path)
  self.Bg = self:AddComponent(UIRawImage, Bg_path)
  self.RankL1 = self:AddComponent(UIText, RankL1_path)
  self.RankL2 = self:AddComponent(UIText, RankL2_path)
  self.RankL3 = self:AddComponent(UIText, RankL3_path)
  self.RankL4 = self:AddComponent(UIText, RankL4_path)
  self.RankR1 = self:AddComponent(UIText, RankR1_path)
  self.RankR2 = self:AddComponent(UIText, RankR2_path)
  self.RankR3 = self:AddComponent(UIText, RankR3_path)
  self.RankR4 = self:AddComponent(UIText, RankR4_path)
  self.GotoBtn = self:AddComponent(UIButton, GotoBtn_path)
  self.RankBtn = self:AddComponent(UIButton, RankBtn_path)
  self.Item = self:AddComponent(UIButton, Item_path)
  self.ItemIcon = self:AddComponent(UIImage, ItemIcon_path)
  self.ItemName = self:AddComponent(UIText, ItemName_path)
  self.IntroBtn:SetOnClick(function()
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.activityData.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end)
  self.GotoBtn:SetOnClick(function()
    self:Goto()
  end)
  self.RankBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonRank, {anim = true}, 3)
  end)
  self.Item:SetOnClick(function()
    if self.activityData and not table.IsNullOrEmpty(self.activityData.howtoplay) then
      local param = {}
      param.howToPlayList = self.activityData.howtoplay
      param.story = self.activityData.story
      param.defaultTitle = self.activityData.name
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
    end
  end)
end

local function ComponentDestroy(self)
  if self.effectObj then
    self:GameObjectDestroy(self.effectObj)
    self.effectObj = nil
  end
  self.TitleText = nil
  self.TimeText = nil
  self.IntroBtn = nil
  self.Desc = nil
  self.Bg = nil
  self.RankL1 = nil
  self.RankL2 = nil
  self.RankL3 = nil
  self.RankL4 = nil
  self.RankR1 = nil
  self.RankR2 = nil
  self.RankR3 = nil
  self.RankR4 = nil
  self.GotoBtn = nil
  self.RankBtn = nil
  self.Item = nil
  self.ItemIcon = nil
  self.ItemName = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function ServerBattleCamp:SetData(activityId)
  base.SetData(self, activityId)
  local data = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if data == nil then
    return
  end
  self.activityData = data
  self.TitleText:SetLocalText(data.name)
  self.Desc:SetLocalText(data.desc_info)
  self.StartTime = data.startTime
  self.EndTime = data.endTime
  self:RefreshView()
  self:Update1000MS()
end

function ServerBattleCamp:RefreshView()
  local configSchedule = DataCenter.ZoneWarManager:GetCrossKingSchedule()
  local group = configSchedule and configSchedule.initServerGroup and configSchedule.initServerGroup.group
  if table.IsNullOrEmpty(group) then
    local key = "801140"
    self.RankL1:SetText(Localization:GetString(key, 1))
    self.RankL2:SetText(Localization:GetString(key, 2))
    self.RankL3:SetText(Localization:GetString(key, 3))
    self.RankL4:SetText(Localization:GetString(key, 4))
    self.RankR1:SetText(Localization:GetString(key, 1))
    self.RankR2:SetText(Localization:GetString(key, 2))
    self.RankR3:SetText(Localization:GetString(key, 3))
    self.RankR4:SetText(Localization:GetString(key, 4))
  else
    self.RankL1:SetText(string.format("#%s", group.b[1] or ""))
    self.RankL2:SetText(string.format("#%s", group.b[2] or ""))
    self.RankL3:SetText(string.format("#%s", group.b[3] or ""))
    self.RankL4:SetText(string.format("#%s", group.b[4] or ""))
    self.RankR1:SetText(string.format("#%s", group.a[1] or ""))
    self.RankR2:SetText(string.format("#%s", group.a[2] or ""))
    self.RankR3:SetText(string.format("#%s", group.a[3] or ""))
    self.RankR4:SetText(string.format("#%s", group.a[4] or ""))
  end
  local seasonInfo = __SeasonInfo[SeasonUtil.GetSeasonType()]
  seasonInfo = seasonInfo or __SeasonInfo[SeasonMapType.Nothing]
  if self.effectObj then
    self:GameObjectDestroy(self.effectObj)
    self.effectObj = nil
  end
  if not seasonInfo then
    return
  end
  if seasonInfo.effectPath then
    self.effectObj = self:GameObjectInstantiateAsync(seasonInfo.effectPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      local trans = go.transform
      trans:SetParent(self.Bg.transform)
      trans:Set_localScale(1, 1, 1)
      local effect = self:AddComponent(UIBaseComponent, string.format("%s/%s", Bg_path, go.name))
      effect:SetAnchoredPositionXY(0, 0)
    end)
  end
  if seasonInfo.resourceType then
    self.ItemName:SetText(DataCenter.ResourceManager:GetResourceNameByType(seasonInfo.resourceType))
    self.ItemIcon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(seasonInfo.resourceType, true))
    self.ItemIcon:SetNativeSize()
  end
end

function ServerBattleCamp:Update1000MS()
  if self.activityData then
    UIUtil.SetLeftTimeText(self.TimeText, self.StartTime, self.EndTime)
  end
end

function ServerBattleCamp:Goto()
  local mgr = DataCenter.ZoneWarManager
  if mgr.configSchedulePreview ~= nil then
    UIUtil.ShowTipsId("season_tips231")
  elseif mgr:CheckShowMainUIBtn() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentServerBattleMain, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  elseif mgr:IsOver() then
    UIUtil.ShowTipsId("458272")
  else
    UIUtil.ShowTipsId("801141")
  end
end

ServerBattleCamp.OnCreate = OnCreate
ServerBattleCamp.OnDestroy = OnDestroy
ServerBattleCamp.OnEnable = OnEnable
ServerBattleCamp.OnDisable = OnDisable
ServerBattleCamp.ComponentDefine = ComponentDefine
ServerBattleCamp.ComponentDestroy = ComponentDestroy
ServerBattleCamp.DataDefine = DataDefine
ServerBattleCamp.DataDestroy = DataDestroy
return ServerBattleCamp
