local WorldLodTemplate = BaseClass("WorldLodTemplate")

local function __init(self)
  self.id = 0
  self.type = 0
  self.path = ""
  self.lodStart = 0
  self.lodEnd = 0
  self.isMain = false
  self.noFading = false
  self.standaloneScaleSpeed = false
  self.minLod = 0
  self.maxLod = 0
  self.maxScale = 0
end

local function __delete(self)
  self.id = nil
  self.type = nil
  self.path = nil
  self.lodStart = nil
  self.lodEnd = nil
  self.isMain = nil
  self.noFading = nil
  self.scaleSpeed = nil
  self.standaloneScaleSpeed = nil
  self.minLod = nil
  self.maxLod = nil
  self.maxScale = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.type = tonumber(row:getValue("type")) or LodType.None
  self.path = row:getValue("path") or ""
  local lodStrs = string.split(row:getValue("lod") or "", "-")
  if #lodStrs == 2 then
    self.lodStart = tonumber(lodStrs[1]) or 0
    self.lodEnd = tonumber(lodStrs[2]) or 0
  end
  self.isMain = tonumber(row:getValue("isMain")) == 1
  self.noFading = tonumber(row:getValue("noFading")) == 1
  local scaleParam = row:getValue("scaleParam") or ""
  if string.IsNullOrEmpty(scaleParam) then
    self.standaloneScaleSpeed = false
  else
    self.standaloneScaleSpeed = true
    local _strs = string.split(scaleParam, ";")
    if #_strs == 3 then
      self.minLod = tonumber(_strs[1])
      self.maxLod = tonumber(_strs[2])
      self.maxScale = tonumber(_strs[3])
      self.standaloneScaleSpeed = true
    else
      self.standaloneScaleSpeed = false
    end
  end
end

WorldLodTemplate.__init = __init
WorldLodTemplate.__delete = __delete
WorldLodTemplate.InitData = InitData
return WorldLodTemplate
