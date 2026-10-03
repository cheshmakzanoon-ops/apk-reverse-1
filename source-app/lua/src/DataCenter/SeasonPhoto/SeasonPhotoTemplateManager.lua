local SeasonPhotoTemplateManager = BaseClass("SeasonPhotoTemplateManager")
local SeasonPhotoTemplate = require("DataCenter.SeasonPhoto.SeasonPhotoTemplate")
local SeasonPhotoTemplateSize = require("DataCenter.SeasonPhoto.SeasonPhotoTemplateSize")
local SeasonPhotoTemplateBorder = require("DataCenter.SeasonPhoto.SeasonPhotoTemplateBorder")
local SeasonPhotoTemplateTask = require("DataCenter.SeasonPhoto.SeasonPhotoTemplateTask")
local SeasonDefault = {
  [1] = {
    border = 10001,
    decoPath = "Assets/Main/SeasonRes/Shared/Prefabs/Component/SeasonPhotoDecoS1.prefab"
  },
  [2] = {
    border = 20001,
    decoPath = "Assets/Main/SeasonRes/Shared/Prefabs/Component/SeasonPhotoDecoS2.prefab"
  },
  [3] = {
    border = 30001,
    decoPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/Component/SeasonPhotoDecoS3.prefab",
    shareEffectBackPath = "Assets/Main/SeasonRes/Shared/Prefabs/Effect/Eff_ui_S3_loading_enviroment.prefab",
    shareEffectFrontPath = "Assets/Main/SeasonRes/Shared/Prefabs/Effect/Eff_ui_zone_enviroment.prefab"
  },
  [4] = {
    border = 40001,
    decoPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/Component/SeasonPhotoDecoS4.prefab"
  },
  [5] = {
    border = 50001,
    decoPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/Component/SeasonPhotoDecoS5.prefab"
  }
}

function SeasonPhotoTemplateManager:__init()
  self.photoDic = nil
  self.photoSizeDic = nil
  self.photoBorderDic = nil
  self.photoTaskDic = nil
end

function SeasonPhotoTemplateManager:__delete()
end

function SeasonPhotoTemplateManager:Startup()
end

function SeasonPhotoTemplateManager:GetConfigData(configId)
  if not self.photoDic then
    self.photoDic = {}
  end
  if not configId then
    return nil
  end
  if not self.photoDic[configId] then
    local line = LocalController:instance():getLine(TableName.LW_SEASON_PHOTO, configId)
    if line then
      local config = SeasonPhotoTemplate.New()
      config:UpdateData(line)
      self.photoDic[configId] = config
    end
  end
  return self.photoDic[configId]
end

function SeasonPhotoTemplateManager:GetConfigDataSize(configId)
  if not self.photoSizeDic then
    self.photoSizeDic = {}
  end
  if not configId then
    return nil
  end
  if not self.photoSizeDic[configId] then
    local line = LocalController:instance():getLine(TableName.LW_SEASON_PHOTO_SIZE, configId)
    if line then
      local config = SeasonPhotoTemplateSize.New()
      config:UpdateData(line)
      self.photoSizeDic[configId] = config
    end
  end
  return self.photoSizeDic[configId]
end

function SeasonPhotoTemplateManager:GetConfigDataBorder(configId)
  if not self.photoBorderDic then
    self.photoBorderDic = {}
  end
  if not configId then
    return nil
  end
  if not self.photoBorderDic[configId] then
    local line = LocalController:instance():getLine(TableName.LW_SEASON_PHOTO_BORDER, configId)
    if line then
      local config = SeasonPhotoTemplateBorder.New()
      config:UpdateData(line)
      self.photoBorderDic[configId] = config
    end
  end
  return self.photoBorderDic[configId]
end

function SeasonPhotoTemplateManager:GetConfigDataTask(configId)
  if not self.photoTaskDic then
    self.photoTaskDic = {}
  end
  if not configId then
    return nil
  end
  if not self.photoTaskDic[configId] then
    local line = LocalController:instance():getLine(TableName.LW_SEASON_PHOTO_TASK, configId)
    if line then
      local config = SeasonPhotoTemplateTask.New()
      config:UpdateData(line)
      self.photoTaskDic[configId] = config
    end
  end
  return self.photoTaskDic[configId]
end

function SeasonPhotoTemplateManager:GetDefaultBorderConfig(season)
  if not season then
    return
  end
  local info = SeasonDefault[season]
  local borderId = info and info.border
  if not borderId then
    return
  end
  return self:GetConfigDataBorder(borderId)
end

function SeasonPhotoTemplateManager:LoadDeco(view, parent, parentPath, season, pathName, callback)
  if not (view and parent) or not pathName then
    return
  end
  local info = SeasonDefault[season]
  local path = info and info[pathName] or ""
  if string.IsNullOrEmpty(path) then
    return
  end
  return view:GameObjectInstantiateAsync(path, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.gameObject:SetActive(true)
    go.transform:SetParent(parent.transform)
    go.transform:Set_localScale(1, 1, 1)
    local rectTrans = view:AddComponent(UIBaseComponent, string.format("%s/%s", parentPath, go.name))
    rectTrans:SetAnchoredPositionXY(0, 0)
    if callback then
      callback(go, rectTrans)
    end
  end)
end

return SeasonPhotoTemplateManager
