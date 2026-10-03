local UIBloodyNightStageListView = BaseClass("UIBloodyNightStageListView", UIBaseView)
local BloodyNightStageCell = require("UI.UIBloodyNight.BloodyNightStageCell")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local close_btn_path = "closeBtn"
local StageContent_path = "SafeArea/eventList/Viewport/StageContent"
local event_list = "SafeArea/eventList"
local stage_desc_path = "SafeArea/stageDesc"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshStageList()
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
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.stage_content = self:AddComponent(UIBaseContainer, StageContent_path)
  self.stage_desc = self:AddComponent(UITextMeshProUGUIEx, stage_desc_path)
  self.stage_desc:SetLocalText("radar_tips_10")
end

local function ComponentDestroy(self)
  self:RemoveStageList()
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function UIBloodyNightStageListView:RemoveStageList()
  self.stage_content:RemoveComponents(BloodyNightStageCell)
  if self.stage_reqs then
    for _, v in pairs(self.stage_reqs) do
      self:GameObjectDestroy(v)
    end
  end
  self.stage_reqs = {}
end

function UIBloodyNightStageListView:RefreshStageList()
  self:RemoveStageList()
  local curStageTemp, stageTempList = DataCenter.BloodyNightDataManager:GetStageTemplate(LuaEntry.Player:GetSelfServerId())
  if table.IsNullOrEmpty(stageTempList) then
    return
  end
  local endTime = DataCenter.BloodyNightDataManager:GetStageEndTime()
  for i = 1, #stageTempList do
    self.stage_reqs[i] = self:GameObjectInstantiateAsync(UIAssets.BloodyNightStageCell, function(req)
      if IsNull(req.gameObject) then
        return
      end
      local item = req.gameObject
      item.name = "StageCell" .. i
      item.transform:SetParent(self.stage_content.transform)
      item.transform:Set_localScale(1, 1, 1)
      local obj = self.stage_content:AddComponent(BloodyNightStageCell, item.name)
      obj:SetData(stageTempList[i], curStageTemp.stage, endTime)
    end)
  end
end

UIBloodyNightStageListView.OnCreate = OnCreate
UIBloodyNightStageListView.OnDestroy = OnDestroy
UIBloodyNightStageListView.OnEnable = OnEnable
UIBloodyNightStageListView.OnDisable = OnDisable
UIBloodyNightStageListView.ComponentDefine = ComponentDefine
UIBloodyNightStageListView.ComponentDestroy = ComponentDestroy
UIBloodyNightStageListView.DataDefine = DataDefine
UIBloodyNightStageListView.DataDestroy = DataDestroy
UIBloodyNightStageListView.OnAddListener = OnAddListener
UIBloodyNightStageListView.OnRemoveListener = OnRemoveListener
return UIBloodyNightStageListView
