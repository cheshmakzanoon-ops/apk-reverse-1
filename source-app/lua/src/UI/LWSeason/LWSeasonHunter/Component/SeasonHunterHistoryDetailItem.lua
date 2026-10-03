local base = UIBaseContainer
local SeasonHunterHistoryDetailItem = BaseClass("SeasonHunterHistoryDetailItem", base)
local Localization = CS.GameEntry.Localization
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
  self.desc = self:AddComponent(UIText, desc_path)
  self.btnPos = self:AddComponent(UIButton, btnPos_path)
  self.time = self:AddComponent(UIText, time_path)
  self.btnPos:SetOnClick(function()
    if self.data and self.data.pos then
      local v3 = SceneUtils.TileToWorld(self.data.pos, ForceChangeScene.World)
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, LookAtFocusTime, nil, self.data.eventSid, 0)
    end
  end)
end

local function ComponentDestroy(self)
  self.desc = nil
  self.btnPos = nil
  self.time = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SeasonHunterHistoryDetailItem:ReInit(index, data)
  self.data = data
  self.time:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(data.time))
  if data.recordType == 3 then
    local name = string.format("<color=#%s>(#%s %s)</color>", "DA0F28", data.defSrcSid, data.defName)
    local pos = SceneUtils.IndexToTilePos(data.defPoint, ForceChangeScene.World)
    data.pos = pos
    local point = Localization:GetString(GameDialogDefine.SHOW_POS, pos.x, pos.y)
    point = string.format("<color=#%s>#%s%s</color>", "3DB7EA", data.eventSid, point)
    local str = Localization:GetString("season_s4_activity_1200011_desc64", name, point)
    self.desc:SetText(str)
    return
  end
  local name = string.format("<color=#%s>(#%s %s)</color>", "DA0F28", data.defSrcSid, data.killName)
  local pos = SceneUtils.IndexToTilePos(data.killPoint, ForceChangeScene.World)
  data.pos = pos
  local point = Localization:GetString(GameDialogDefine.SHOW_POS, pos.x, pos.y)
  point = string.format("<color=#%s>#%s%s</color>", "3DB7EA", data.eventSid, point)
  local str = Localization:GetString("season_s4_activity_1200011_desc46", name, point, data.gainScore)
  self.desc:SetText(str)
end

SeasonHunterHistoryDetailItem.OnCreate = OnCreate
SeasonHunterHistoryDetailItem.OnDestroy = OnDestroy
SeasonHunterHistoryDetailItem.OnEnable = OnEnable
SeasonHunterHistoryDetailItem.OnDisable = OnDisable
SeasonHunterHistoryDetailItem.ComponentDefine = ComponentDefine
SeasonHunterHistoryDetailItem.ComponentDestroy = ComponentDestroy
SeasonHunterHistoryDetailItem.DataDefine = DataDefine
SeasonHunterHistoryDetailItem.DataDestroy = DataDestroy
return SeasonHunterHistoryDetailItem
