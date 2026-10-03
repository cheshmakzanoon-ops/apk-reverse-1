local LWUIMigrationView_GuideTime = BaseClass("LWUIMigrationView_GuideTime", UIBaseContainer)
local base = UIBaseContainer
local TimeItem = require("UI.LWUIMigration.Guide.Component.LWUIMigrationView_GuideTimeItem")
local btn_change_path = "TopLine/ChangeBtn"
local text_title_path = "TopLine/TopTimeText"
local item_path = "LineItem"

function LWUIMigrationView_GuideTime:OnCreate()
  base.OnCreate(self)
  self.isLocalTime = true
  self.items = {}
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.btn_info = self:AddComponent(UIButton, btn_change_path)
  self.btn_info:SetOnClick(BindCallback(self, self.OnBtnChangeClick))
  self.theItem = self.transform:Find(item_path).gameObject
  self.theItem:GameObjectCreatePool()
end

function LWUIMigrationView_GuideTime:OnDestroy()
  self:RemoveComponents(TimeItem)
  for _, v in ipairs(self.items) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.theItem:GameObjectRecycleAll()
  self.items = {}
  base.OnDestroy(self)
end

function LWUIMigrationView_GuideTime:OnBtnChangeClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self.isLocalTime = not self.isLocalTime
  self:SetData()
end

function LWUIMigrationView_GuideTime:SetData()
  self.text_title:SetLocalText(self.isLocalTime and "winter_battlefield_interface_tips1012" or "winter_battlefield_interface_tips1013")
  local openConfig = DataCenter.ActMigrationManager:GetOpenConfig() or nil
  local stateTimes = openConfig ~= nil and openConfig.stateTimes or {}
  local maxStage = #stateTimes
  local stage = DataCenter.ActMigrationManager:GetCurStageInfo()
  for i = 1, maxStage do
    local info = stateTimes[i]
    local item = self.items[i]
    if item == nil then
      local obj = self.theItem:GameObjectSpawn(self.transform)
      obj.name = i
      item = self:AddComponent(TimeItem, obj.name)
      self.items[i] = item
    end
    item:SetActive(true)
    item:SetData(info, self.isLocalTime, i, stage)
  end
end

return LWUIMigrationView_GuideTime
