local UIPVESelectBuffView = BaseClass("UIPVESelectBuffView", UIBaseView)
local base = UIBaseView
local UIPVESelectBuffCell = require("UI.UIPVE.UIPVESelectBuff.Component.UIPVESelectBuffCell")
local buff_list_go_path = "BuffListGo"
local this_path = ""

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_show_pve_effect, false)
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.buff_list_go = self:AddComponent(UIBaseContainer, buff_list_go_path)
  self.canvasGroup = self:AddComponent(UICanvasGroup, this_path)
end

local function ComponentDestroy(self)
  self.buff_list_go = nil
  self.canvasGroup = nil
end

local function DataDefine(self)
  self.list = {}
end

local function DataDestroy(self)
  self.list = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  self.canvasGroup:SetBlocksRaycasts(true)
  local buffList = self:GetUserData()
  if buffList ~= nil then
    local list = {}
    for k, v in ipairs(buffList) do
      for k1, v1 in ipairs(v) do
        local trigger = DataCenter.BattleLevel:GetTriggerByTriggerId(v1)
        if not trigger:IsTriggerOK() then
          table.insert(list, v1)
          break
        end
      end
    end
    for k, v in ipairs(list) do
      self:GameObjectInstantiateAsync(UIAssets.UIPVESelectBuffCell, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go:SetActive(true)
        go.transform:SetParent(self.buff_list_go.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local model = self.buff_list_go:AddComponent(UIPVESelectBuffCell, nameStr)
        local param = {}
        param.triggerId = v
        param.index = k
        model:ReInit(param)
        self.list[v] = model
      end)
    end
  end
end

local function OnClick(self)
  self.canvasGroup:SetBlocksRaycasts(false)
end

UIPVESelectBuffView.OnCreate = OnCreate
UIPVESelectBuffView.OnDestroy = OnDestroy
UIPVESelectBuffView.ComponentDefine = ComponentDefine
UIPVESelectBuffView.ComponentDestroy = ComponentDestroy
UIPVESelectBuffView.DataDefine = DataDefine
UIPVESelectBuffView.DataDestroy = DataDestroy
UIPVESelectBuffView.OnEnable = OnEnable
UIPVESelectBuffView.OnDisable = OnDisable
UIPVESelectBuffView.OnAddListener = OnAddListener
UIPVESelectBuffView.OnRemoveListener = OnRemoveListener
UIPVESelectBuffView.ReInit = ReInit
UIPVESelectBuffView.OnClick = OnClick
return UIPVESelectBuffView
