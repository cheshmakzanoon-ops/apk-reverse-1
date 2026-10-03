local GuideNeedLoadManager = BaseClass("GuideNeedLoadManager")
local ResourceManager = CS.GameEntry.Resource
local TankScene = require("Scene.TankScene.TankScene")

function GuideNeedLoadManager:__init()
  self.allScene = {}
  self.useGuideTimelineMarker = false
  self.saveParam = {}
  self:AddListener()
end

function GuideNeedLoadManager:__delete()
  self.allScene = {}
  self.useGuideTimelineMarker = false
  self.saveParam = {}
  self:RemoveListener()
  self:DestroyAllObject()
end

function GuideNeedLoadManager:Startup()
end

function GuideNeedLoadManager:AddListener()
  function self.OnTimelineMarker(id)
    self:OnTimelineMarkerSignal(id)
  end
  
  EventManager:GetInstance():AddListener(EventId.GuideTimelineMarker, self.OnTimelineMarker)
  
  function self.GotoTimeSignal(time)
    self:GotoTime(time)
  end
  
  EventManager:GetInstance():AddListener(EventId.GotoTime, self.GotoTimeSignal)
end

function GuideNeedLoadManager:RemoveListener()
  if self.OnTimelineMarker ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.GuideTimelineMarker, self.OnTimelineMarker)
    self.OnTimelineMarker = nil
  end
  if self.GotoTimeSignal ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.GotoTime, self.GotoTimeSignal)
    self.GotoTimeSignal = nil
  end
end

function GuideNeedLoadManager:LoadTankScene(param)
  if param.sceneType == nil then
    param.sceneType = GuideAnimObjectType.ShowTankScene
  end
  if self.allScene[param.sceneType] == nil then
    local request = ResourceManager:InstantiateAsync(UIAssets.TankScene)
    local para = {}
    para.request = request
    para.param = param
    self.allScene[param.sceneType] = para
    request:completed("+", function()
      if request.isError then
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local effect = TankScene.New()
      effect:OnCreate(request)
      para.model = effect
      effect:ReInit(self.allScene[param.sceneType].param)
    end)
  else
    self.allScene[param.sceneType].param = param
    if self.allScene[param.sceneType].model ~= nil then
      self.allScene[param.sceneType].model:ReInit(param)
    end
  end
  if param.nextType == GuideNpcDoNextType.WaitWalkDelete then
    self:RemoveSaveParam(param.sceneType)
  else
    self:AddSaveParam(param.sceneType, param.saveParam)
  end
end

function GuideNeedLoadManager:DestroyAllObject()
  if self.allScene ~= nil then
    for k, v in pairs(self.allScene) do
      if v.model ~= nil then
        v.model:OnDestroy()
      end
      if v.request ~= nil then
        v.request:Destroy()
      end
    end
    self.allScene = {}
  end
end

function GuideNeedLoadManager:DestroyTankScene()
  local scene = self.allScene[GuideAnimObjectType.ShowTankScene]
  if scene ~= nil then
    if scene.model ~= nil then
      scene.model:OnDestroy()
    end
    if scene.request ~= nil then
      scene.request:Destroy()
    end
    self.allScene[GuideAnimObjectType.ShowTankScene] = nil
    self:RemoveSaveParam(GuideAnimObjectType.ShowTankScene)
  end
end

function GuideNeedLoadManager:OnTimelineMarkerSignal(id)
  if self:IsUseGuideTimelineMarker() then
    if id == GuideTimeLineShowMarkerType.End then
      self.useGuideTimelineMarker = false
      self:CheckDoNext()
    else
      local template = DataCenter.GuideManager:GetCurTemplate()
      if template ~= nil then
        if template.type == GuideType.PlayMovie or template.type == GuideType.WaitMovieComplete then
          local para2 = template.para2
          if para2 ~= nil then
            DataCenter.GuideManager:SetCurGuideId(tonumber(template.para2))
            DataCenter.GuideManager:DoGuide()
          end
        else
          for k, v in ipairs(template.jumptype) do
            if v == GuideJumpType.TimelineJump and template.jumpid ~= 0 then
              DataCenter.GuideManager:SetNoGotoTime(true)
              DataCenter.GuideManager:SetCurGuideId(template.jumpid)
              DataCenter.GuideManager:DoGuide()
            end
          end
        end
      end
    end
  end
end

function GuideNeedLoadManager:CheckDoNext()
  local template = DataCenter.GuideManager:GetCurTemplate()
  if template ~= nil and (template.type == GuideType.PlayMovie or template.type == GuideType.WaitMovieComplete) then
    DataCenter.GuideManager:DoNext()
  end
end

function GuideNeedLoadManager:GotoTime(time)
  for k, v in pairs(self.allScene) do
    if v.model ~= nil and v.model.GotoTime ~= nil then
      v.model:GotoTime(time)
    end
  end
end

function GuideNeedLoadManager:IsUseGuideTimelineMarker()
  return self.useGuideTimelineMarker
end

function GuideNeedLoadManager:AddSaveParam(sceneType, param)
  if param ~= nil then
    self.saveParam[sceneType] = param
    self:SendSaveParam()
  end
end

function GuideNeedLoadManager:RemoveSaveParam(sceneType)
  if self.saveParam[sceneType] ~= nil then
    self.saveParam[sceneType] = nil
    self:SendSaveParam()
  end
end

function GuideNeedLoadManager:SendSaveParam()
  local str = ""
  for k, v in pairs(self.saveParam) do
    if str ~= "" then
      str = str .. "|"
    end
    str = str .. k .. ";" .. v
  end
  DataCenter.GuideManager:SendSaveGuideMessage(GuideNeedLoadScene, str)
end

function GuideNeedLoadManager:InitLoadScene()
  local str = DataCenter.GuideManager:GetSaveGuideValue(GuideNeedLoadScene)
  if str ~= nil and str ~= "" then
    local spl = string.split_ss_array(str, "|")
    for k, v in ipairs(spl) do
      local spl2 = string.split_ss_array(v, ";")
      if table.count(spl2) > 1 then
        local sceneType = tonumber(spl2[1])
        self:AddSaveParam(sceneType, spl2[2])
        self:LoadSceneBySceneType(sceneType)
      end
    end
  end
end

function GuideNeedLoadManager:LoadSceneBySceneType(sceneType)
  if self.saveParam[sceneType] ~= nil then
    local spl = string.split_ss_array(self.saveParam[sceneType], ",")
    local count = table.count(spl)
    if sceneType == GuideAnimObjectType.ShowTankScene then
      local param = {}
      param.sceneType = sceneType
      if 1 < count then
        param.posArr = {
          Vector2.New(tonumber(spl[1]), tonumber(spl[2]))
        }
      end
      if 2 < count then
        param.angle = tonumber(spl[3])
      end
      self:LoadTankScene(param)
    end
  end
end

function GuideNeedLoadManager:GetModel(sceneType)
  if self.allScene[sceneType] ~= nil then
    return self.allScene[sceneType].model
  end
end

return GuideNeedLoadManager
