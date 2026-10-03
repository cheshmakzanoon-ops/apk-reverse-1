local BookMarkManager = BaseClass("BookMarkManager")
local Localization = CS.GameEntry.Localization

local function __init(self)
end

local function __delete(self)
end

local function GetBookMarkName(self, index)
  return Localization:GetString(self:GetBookMarkNameId(index))
end

local function GetBookMarkNameId(self, index)
  local info = CS.SceneManager.World:GetPointInfo(index)
  if info ~= nil then
    if info.PointType == WorldPointType.WorldResource then
      return GameDialogDefine.RESOURCE_POINT
    elseif info.PointType == WorldPointType.PlayerBuilding then
      return GameDialogDefine.BUILDING
    elseif info.PointType == WorldPointType.WorldCollectResource then
      return GameDialogDefine.RESOURCE_COLLECT
    end
  end
  return GameDialogDefine.TILE
end

BookMarkManager.__init = __init
BookMarkManager.__delete = __delete
BookMarkManager.GetBookMarkName = GetBookMarkName
BookMarkManager.GetBookMarkNameId = GetBookMarkNameId
return BookMarkManager
