local UIPVESelectBattleBuffView = BaseClass("UIPVESelectBattleBuffView", UIBaseView)
local base = UIBaseView
local UIPVESelectBattleBuffCell = require("UI.UIPVE.UIPVESelectBattleBuff.Component.UIPVESelectBattleBuffCell")
local buff_list_go_path = "BuffListGo"
local SHOW_BUFF_COUNT = 3

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
  self.buff_list_go = self:AddComponent(UIBaseContainer, buff_list_go_path)
end

local function ComponentDestroy(self)
  self.buff_list_go = nil
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
  local buffList, triggerId = self:GetUserData()
  if buffList ~= nil then
    local selectIndex
    local lines = {}
    local totalRate = 0
    for index, id in ipairs(buffList) do
      local line = LocalController:instance():getLine("aps_pve_choosebuff", tostring(id))
      lines[index] = line
      local rate = tonumber(line:getValue("rate"))
      totalRate = totalRate + rate
    end
    local pveRandom = DataCenter.BattleLevel.pveRandom or 0
    local levelId = DataCenter.BattleLevel.levelId
    local seed = pveRandom % 481312 + levelId + triggerId
    local apsRandom = ApsRandom.New(seed)
    local rand = apsRandom:NextInt(totalRate)
    for index, line in ipairs(lines) do
      local rate = tonumber(line:getValue("rate"))
      rand = rand - rate
      if rand <= 0 then
        selectIndex = index
        break
      end
    end
    local indexList = {selectIndex}
    for i = 1, SHOW_BUFF_COUNT - 1 do
      local randIndex = math.random(1, selectIndex)
      table.insert(indexList, randIndex)
    end
    local record = {}
    for _, index in ipairs(indexList) do
      local line = lines[index]
      local strs = string.split(line:getValue("buffId"), "|")
      if #strs < SHOW_BUFF_COUNT then
        Logger.LogError("aps_pve_choosebuff not enough buff id")
        break
      end
      local buffId
      while buffId == nil do
        local id = tonumber(table.randomArrayValue(strs))
        if not table.hasvalue(record, id) then
          table.insert(record, id)
          buffId = id
        end
      end
      self:GameObjectInstantiateAsync(UIAssets.UIPVESelectBattleBuffCell, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go:SetActive(true)
        go.transform:SetParent(self.buff_list_go.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(buffId)
        go.name = nameStr
        local model = self.buff_list_go:AddComponent(UIPVESelectBattleBuffCell, nameStr)
        local param = {}
        param.triggerId = triggerId
        param.buffGroupId = tonumber(line:getValue("id"))
        param.buffId = buffId
        param.quality = tonumber(line:getValue("quality"))
        model:ReInit(param)
        self.list[buffId] = model
      end)
    end
  end
end

UIPVESelectBattleBuffView.OnCreate = OnCreate
UIPVESelectBattleBuffView.OnDestroy = OnDestroy
UIPVESelectBattleBuffView.ComponentDefine = ComponentDefine
UIPVESelectBattleBuffView.ComponentDestroy = ComponentDestroy
UIPVESelectBattleBuffView.DataDefine = DataDefine
UIPVESelectBattleBuffView.DataDestroy = DataDestroy
UIPVESelectBattleBuffView.OnEnable = OnEnable
UIPVESelectBattleBuffView.OnDisable = OnDisable
UIPVESelectBattleBuffView.OnAddListener = OnAddListener
UIPVESelectBattleBuffView.OnRemoveListener = OnRemoveListener
UIPVESelectBattleBuffView.ReInit = ReInit
return UIPVESelectBattleBuffView
