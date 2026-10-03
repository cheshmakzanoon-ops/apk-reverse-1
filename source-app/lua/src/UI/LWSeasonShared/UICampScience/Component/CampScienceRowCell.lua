local CampScienceRowCell = BaseClass("CampScienceRowCell", UIBaseContainer)
local CampScienceCell = require("UI.LWSeasonShared.UICampScience.Component.CampScienceCell")
local UICampScienceCellPrefab = "Assets/Main/SeasonRes/S6/Prefabs/UI/CampScience/UICampScienceCell.prefab"
local base = UIBaseContainer
local line_content_path = "LineContent"
local rowCellWidthHalf = 135.0
local rowCellHeight = 128
local ResetWidth = 12
local Scale = Vector3.New(1, 1, 1)
local ReScale = Vector3.New(1, -1, 1)
local EulerAngles = Vector3.New(0, 0, 0)
local ReEulerAngles = Vector3.New(0, 0, 90)
local LineSkinMap = {
  [SeasonMapType.NineNationRainforest] = {
    [1] = {
      [1] = "Assets/Main/SeasonRes/S6/Prefabs/UI/CampScience/UICampGrayCenterLine.prefab",
      [2] = "Assets/Main/SeasonRes/S6/Prefabs/UI/CampScience/UICampGrayLeftLine.prefab"
    },
    [2] = {
      [1] = "Assets/Main/SeasonRes/S6/Prefabs/UI/CampScience/UICampLightCenterLine.prefab",
      [2] = "Assets/Main/SeasonRes/S6/Prefabs/UI/CampScience/UICampLightLeftLine.prefab"
    }
  }
}

function CampScienceRowCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.linesReqs = {}
  self.cellReqs = {}
end

function CampScienceRowCell:OnDestroy()
  self:RemoveLines()
  self:RemoveCells()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function CampScienceRowCell:ComponentDefine()
  self.line_content = self:AddComponent(UIBaseContainer, line_content_path)
end

function CampScienceRowCell:ComponentDestroy()
  self.line_content = nil
end

function CampScienceRowCell:SetItemShow(data)
  self:RemoveLines()
  self:RemoveCells()
  local maxCn = math.min(3, #data)
  for i = 1, maxCn do
    local oneData = DataCenter.CampScienceDataManager:GetOneCampScienceById(data[i].id)
    self:AddOneScienceCells(oneData)
    self:AddLines(oneData)
  end
end

function CampScienceRowCell:RemoveLines()
  self.line_content:RemoveComponents(UIImage)
  if self.linesReqs then
    for i = 1, #self.linesReqs do
      self:GameObjectDestroy(self.linesReqs[i])
    end
    self.linesReqs = {}
  end
end

function CampScienceRowCell:RemoveCells()
  self:RemoveComponents(CampScienceCell)
  if self.cellReqs then
    for i = 1, #self.cellReqs do
      self:GameObjectDestroy(self.cellReqs[i])
    end
    self.cellReqs = {}
  end
end

function CampScienceRowCell:AddOneScienceCells(param)
  if param == nil then
    return
  end
  local req = self:GameObjectInstantiateAsync(UICampScienceCellPrefab, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local position = param.position
    local position_vec = string.split_ss_array(position, ";")
    local row = tonumber(position_vec[2])
    local xOffset = rowCellWidthHalf * (row - 1)
    local goRect = go:GetComponent(typeof(CS.UnityEngine.RectTransform))
    goRect:Set_anchoredPosition(xOffset * (CommonUtil.IsArabicAutoMirrorOpen() and -1 or 1), 0)
    go.transform:SetAsLastSibling()
    local nameStr = tostring(NameCount)
    go.name = nameStr
    NameCount = NameCount + 1
    local cell = self:AddComponent(CampScienceCell, nameStr)
    cell:RefreshData(param)
  end)
  self.cellReqs[#self.cellReqs + 1] = req
end

function CampScienceRowCell:GetLineMap(center, gray)
  local index = center and 1 or 2
  local index2 = gray and 1 or 2
  local lineSkin = LineSkinMap[60001]
  if lineSkin == nil then
    return
  end
  return lineSkin[index2][index]
end

function CampScienceRowCell:AddLines(param)
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
        local prefabpath = self:GetLineMap(row == r, true)
        local req = self:GameObjectInstantiateAsync(prefabpath, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          self:addOneLine(row, r, go, true)
        end)
        self.linesReqs[#self.linesReqs + 1] = req
        if param.lineGlays == nil or not param.lineGlays[i] then
          do
            local prefabpath = self:GetLineMap(row == r, false)
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

function CampScienceRowCell:addOneLine(row, r, go)
  local oriX = row * rowCellWidthHalf
  local needX = r * rowCellWidthHalf
  local size = Vector2.New(0, rowCellHeight)
  local eulerAngles = ReEulerAngles
  local scale = Scale
  if oriX == needX then
    size.x = ResetWidth
    eulerAngles = EulerAngles
  elseif oriX > needX then
    scale = ReScale
    size.x = oriX - needX
    local temp = size.x
    size.x = size.y
    size.y = temp + ResetWidth
  elseif oriX < needX then
    scale = Scale
    size.x = needX - oriX
    local temp = size.x
    size.x = size.y
    size.y = temp + ResetWidth
  end
  local nameStr = tostring(NameCount)
  go.name = nameStr
  NameCount = NameCount + 1
  go:SetActive(true)
  go.transform:SetParent(self.line_content.transform)
  local line_img = self.line_content:AddComponent(UIImage, nameStr)
  line_img:SetSizeDelta(size)
  line_img:SetLocalScale(scale)
  line_img:SetEulerAngles(eulerAngles)
  line_img:SetAnchoredPositionXY((needX + oriX) / 2 - rowCellWidthHalf, 0)
end

return CampScienceRowCell
