local base = UIBaseContainer
local TradeStationHistoryItem = BaseClass("TradeStationHistoryItem", base)
local TabIconPath = "Assets/Main/SeasonRes/Shared/Sprites/UI/UITradeStation/%s.png"
local TabIcons = {
  "mjc_S3_maoyizhan_icon_zhanzheng",
  "mjc_S3_maoyizhan_icon_maoyi",
  "mjc_S3_maoyizhan_icon_shuishou"
}
local icon_path = "bgIcon"
local desc_path = "Txt_Des"
local btnPos_path = "Txt_Des"
local time_path = "Txt_Time"

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
  self.icon = self:AddComponent(UIImage, icon_path)
  self.desc = self:AddComponent(UIText, desc_path)
  self.btnPos = self:AddComponent(UIButton, btnPos_path)
  self.time = self:AddComponent(UIText, time_path)
  self.btnPos:SetOnClick(function()
    local param = CommonUtil.AnalyseParam(self.data)
    if param and param.link then
      local v3 = SceneUtils.TileToWorld(param.link, ForceChangeScene.World)
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, LookAtFocusTime, nil, param.link.server, 0)
    end
  end)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.desc = nil
  self.btnPos = nil
  self.time = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function TradeStationHistoryItem:ReInit(data)
  if data == nil then
    return
  end
  self.data = data
  self.icon:LoadSprite(string.format(TabIconPath, TabIcons[data.type]))
  self.desc:SetText(CommonUtil.GetStrLog(data.code, data, false))
  self.time:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(data.time))
end

TradeStationHistoryItem.OnCreate = OnCreate
TradeStationHistoryItem.OnDestroy = OnDestroy
TradeStationHistoryItem.OnEnable = OnEnable
TradeStationHistoryItem.OnDisable = OnDisable
TradeStationHistoryItem.ComponentDefine = ComponentDefine
TradeStationHistoryItem.ComponentDestroy = ComponentDestroy
TradeStationHistoryItem.DataDefine = DataDefine
TradeStationHistoryItem.DataDestroy = DataDestroy
return TradeStationHistoryItem
