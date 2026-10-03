local UIPVESelectDiffView = BaseClass("UIPVESelectDiffView", UIBaseView)
local base = UIBaseView
local UIPVESelectDiffCell = require("UI.UIPVE.UIPVESelectDiff.Component.UIPVESelectDiffCell")
local diff_list_go_path = "DiffListGo"
local tip_desc_path = "Tip/TipDesc"
local SHOW_COUNT = 3

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.diff_list_go = self:AddComponent(UIBaseContainer, diff_list_go_path)
  self.tip_desc_text = self:AddComponent(UIText, tip_desc_path)
  self.tip_desc_text:SetLocalText(400061)
end

local function ComponentDestroy(self)
  self.diff_list_go = nil
  self.tip_desc_text = nil
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
  local triggerId, monsterGroupList = self:GetUserData()
  if monsterGroupList == nil then
    return
  end
  local curDiff = DataCenter.BattleLevel.diffParam.curDiff
  for i = curDiff, curDiff + SHOW_COUNT - 1 do
    local info = monsterGroupList[i]
    self:GameObjectInstantiateAsync(UIAssets.UIPVESelectDiffCell, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.diff_list_go.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(i)
      go.name = nameStr
      local model = self.diff_list_go:AddComponent(UIPVESelectDiffCell, nameStr)
      local param = {}
      param.monsterGroupInfo = info
      param.diff = i
      param.triggerId = triggerId
      model:ReInit(param)
      self.list[i] = model
    end)
  end
end

UIPVESelectDiffView.OnCreate = OnCreate
UIPVESelectDiffView.OnDestroy = OnDestroy
UIPVESelectDiffView.ComponentDefine = ComponentDefine
UIPVESelectDiffView.ComponentDestroy = ComponentDestroy
UIPVESelectDiffView.DataDefine = DataDefine
UIPVESelectDiffView.DataDestroy = DataDestroy
UIPVESelectDiffView.OnEnable = OnEnable
UIPVESelectDiffView.OnDisable = OnDisable
UIPVESelectDiffView.OnAddListener = OnAddListener
UIPVESelectDiffView.OnRemoveListener = OnRemoveListener
UIPVESelectDiffView.ReInit = ReInit
return UIPVESelectDiffView
