local AllianceScienceRowCell = BaseClass("AllianceScienceRowCell", UIBaseContainer)
local AllianceScienceCell = require("UI.UIAlliance.UIAllianceScience.Component.AllianceScienceCell")
local base = UIBaseContainer
local line_content_path = "LineContent"
local science_content_path = "scienceContent"
local SizeDelta = Vector2.New(0, 104)
local lightSizeDelta = Vector2.New(0, 100)
local Position = Vector3.New(0, 0, 0)
local Scale = Vector3.New(1, 1, 1)
local rowCellHeight = 233
local rowCellHeightHalf = 116.5
local grayLineW = 16
local lightLineW = 12

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self.linesReqs = {}
  self.cellReqs = {}
end

local function RemoveLines(self)
  self.science_content:RemoveComponents(AllianceScienceCell)
  if self.cellReqs then
    for i = 1, #self.cellReqs do
      self:GameObjectDestroy(self.cellReqs[i])
    end
    self.cellReqs = {}
  end
end

local function RemoveCells(self)
  self.line_content:RemoveComponents(UIImage)
  if self.linesReqs then
    for i = 1, #self.linesReqs do
      self:GameObjectDestroy(self.linesReqs[i])
    end
    self.linesReqs = {}
  end
end

local function OnDestroy(self)
  RemoveLines(self)
  RemoveCells(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.line_content = self:AddComponent(UIBaseContainer, line_content_path)
  self.science_content = self:AddComponent(UIBaseContainer, science_content_path)
end

local function ComponentDestroy(self)
  self.line_content = nil
  self.science_content = nil
end

local function SetItemShow(self, data)
  RemoveLines(self)
  RemoveCells(self)
  local maxCn = math.min(3, #data)
  for i = 1, maxCn do
    local oneSciencedata = DataCenter.AllianceScienceDataManager:GetOneAllianceScienceById(data[i].id)
    self:AddOneScienceCells(oneSciencedata)
    self:AddLines(oneSciencedata)
  end
end

local function AddOneScienceCells(self, param)
  if param == nil then
    return
  end
  local req = self:GameObjectInstantiateAsync(UIAssets.UIAllianceScienceCell, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.science_content.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local position = param.position
    local position_vec = string.split_ss_array(position, ";")
    local row = tonumber(position_vec[2])
    go.transform:Set_localPosition(rowCellHeightHalf * (row - 1) * (CommonUtil.IsArabicAutoMirrorOpen() and -1 or 1), 0)
    go.transform:SetAsLastSibling()
    local nameStr = tostring(NameCount)
    go.name = nameStr
    NameCount = NameCount + 1
    local cell = self.science_content:AddComponent(AllianceScienceCell, nameStr)
    cell:RefreshData(param)
  end)
  self.cellReqs[#self.cellReqs + 1] = req
end

local function AddLines(self, param)
  local position = param.position
  local position_vec = string.split_ss_array(position, ";")
  local row = tonumber(position_vec[2])
  local rolation = param.rolation
  local rolation_vec = string.split_ss_array(rolation, "|")
  if 0 < #rolation_vec then
    for i = 1, #rolation_vec do
      local p = rolation_vec[i]
      local p_vec = string.split_ss_array(p, ";")
      if #p_vec == 2 then
        local r = tonumber(p_vec[2])
        local prefabpath
        if row == r then
          prefabpath = "Assets/Main/Prefabs/UI/Alliance/LWAlGrayCenterLine.prefab"
        else
          prefabpath = "Assets/Main/Prefabs/UI/Alliance/LWAlGrayLeftLine.prefab"
        end
        local req = self:GameObjectInstantiateAsync(prefabpath, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          self:addOneLine(row, r, go, true)
        end)
        self.linesReqs[#self.linesReqs + 1] = req
        if param.lineGlays ~= nil and param.lineGlays[i] then
        else
          if row == r then
            prefabpath = "Assets/Main/Prefabs/UI/Alliance/LWAlLightCenterLine.prefab"
          else
            prefabpath = "Assets/Main/Prefabs/UI/Alliance/LWAlLightLeftLine.prefab"
          end
          do
            local req = self:GameObjectInstantiateAsync(prefabpath, function(request)
              if request.isError then
                return
              end
              local go = request.gameObject
              self:addOneLine(row, r, go, false)
            end)
            self.linesReqs[#self.linesReqs + 1] = req
          end
        end
      end
    end
  end
end

local function addOneLine(self, row, r, go, isgray)
  if row == r then
    SizeDelta.x = grayLineW
    lightSizeDelta.x = lightLineW
    Position.x = rowCellHeightHalf * (row - 1)
    Scale.x = 1
  else
    local fromx = rowCellHeightHalf * (row - 1)
    local tox = rowCellHeightHalf * (r - 1)
    SizeDelta.x = math.abs(fromx - tox) + grayLineW
    lightSizeDelta.x = math.abs(fromx - tox) + lightLineW
    Position.x = (fromx + tox) * 0.5
    if r < row then
      Scale.x = 1
    else
      Scale.x = -1
    end
  end
  local nameStr = tostring(NameCount)
  go.name = nameStr
  NameCount = NameCount + 1
  go:SetActive(true)
  go.transform:SetParent(self.line_content.transform)
  local lineimg = self.line_content:AddComponent(UIImage, nameStr)
  if isgray then
    go.transform:SetAsFirstSibling()
    lineimg.rectTransform.sizeDelta = SizeDelta
  else
    lineimg.rectTransform.sizeDelta = lightSizeDelta
  end
  lineimg.transform:Set_localPosition(Position.x * (CommonUtil.IsArabicAutoMirrorOpen() and -1 or 1), Position.y)
  lineimg.transform.localScale = Scale
end

AllianceScienceRowCell.OnCreate = OnCreate
AllianceScienceRowCell.OnDestroy = OnDestroy
AllianceScienceRowCell.ComponentDefine = ComponentDefine
AllianceScienceRowCell.ComponentDestroy = ComponentDestroy
AllianceScienceRowCell.SetItemShow = SetItemShow
AllianceScienceRowCell.AddOneScienceCells = AddOneScienceCells
AllianceScienceRowCell.AddLines = AddLines
AllianceScienceRowCell.addOneLine = addOneLine
return AllianceScienceRowCell
