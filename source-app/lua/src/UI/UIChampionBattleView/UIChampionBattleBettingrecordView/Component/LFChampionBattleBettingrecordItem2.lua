local LFChampionBattleBettingrecordItem2 = BaseClass("LFChampionBattleBettingrecordItem2", UIBaseContainer)
local base = UIBaseContainer
local resultTxt_path = "resultTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.resultTxt = self:AddComponent(UIText, resultTxt_path)
end

local function DataDefine(self)
end

local function ComponentDestroy(self)
end

local function DataDestroy(self)
end

local function SetData(self, data)
  if data.state == 0 then
    self.resultTxt:SetLocalText(312150)
  elseif data.state == 1 then
    local resultValue = tostring(math.abs(data.totalWinCount))
    local param = string.GetFormattedThousandthStr(resultValue)
    if 0 <= data.totalWinCount then
      param = "+" .. param
    else
      param = "-" .. param
    end
    self.resultTxt:SetLocalText(180504, param)
  end
end

LFChampionBattleBettingrecordItem2.OnCreate = OnCreate
LFChampionBattleBettingrecordItem2.OnDestroy = OnDestroy
LFChampionBattleBettingrecordItem2.ComponentDefine = ComponentDefine
LFChampionBattleBettingrecordItem2.DataDefine = DataDefine
LFChampionBattleBettingrecordItem2.ComponentDestroy = ComponentDestroy
LFChampionBattleBettingrecordItem2.DataDestroy = DataDestroy
LFChampionBattleBettingrecordItem2.SetData = SetData
return LFChampionBattleBettingrecordItem2
