local UIActChristmasTreeTimeLine = BaseClass("UIActChristmasTreeTimeLine", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local timelinePath = "Assets/Main/Prefabs/UI/ActMusicFestival2025/Effect/shengdanjie_timeline_Variant.prefab"
local LightPath = "City/Scene_City2(Clone)/Light_City"
local defaultQuality, shadowDistance
local RenderSettings = CS.UnityEngine.RenderSettings
local Camera = CS.UnityEngine.Camera
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local Resource = CS.GameEntry.Resource
local RenderTexture = CS.UnityEngine.RenderTexture

function UIActChristmasTreeTimeLine:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActChristmasTreeTimeLine:OnDestroy()
  self:EndTimeLine()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIActChristmasTreeTimeLine:ComponentDefine()
  self.rawImage = self:AddComponent(UIRawImage, "")
  self.rawImage:SetActive(false)
  local rtWidth = DefaultScreenWidth
  local rtHeight = DefaultScreenHeight
  local rtFormat = RenderTextureFormat.ARGB32
  self.renderTexture = RenderTexture.GetTemporary(rtWidth, rtHeight, 24, rtFormat)
  self.rawImage:SetTexture(self.renderTexture)
end

function UIActChristmasTreeTimeLine:ComponentDestroy()
  self.rawImage = nil
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
end

function UIActChristmasTreeTimeLine:DataDefine()
  self.timer = nil
  self.sceneLoadRequest = nil
  self.scene = nil
  self.director = nil
  self.cameraRoot = nil
  self.camera = nil
  self.roleRoot = nil
  self.tankRoot = nil
  self.feijiRoot = nil
  self.daodanRoot = nil
  self.name1 = nil
  self.name2 = nil
  self.name3 = nil
end

function UIActChristmasTreeTimeLine:DataDestroy()
  self.timer = nil
  self.sceneLoadRequest = nil
  self.scene = nil
  self.director = nil
  self.cameraRoot = nil
  self.camera = nil
  self.roleRoot = nil
  self.tankRoot = nil
  self.feijiRoot = nil
  self.daodanRoot = nil
  self.name1 = nil
  self.name2 = nil
  self.name3 = nil
end

function UIActChristmasTreeTimeLine:StartTimeLine()
  if self.sceneLoadRequest ~= nil then
    return
  end
  self.rawImage:SetActive(false)
  shadowDistance = RenderSetting.GetShadowDistance()
  self:SetCityLightActive(false)
  self:CloseMainCamera()
  self:CreateLevel()
end

function UIActChristmasTreeTimeLine:EndTimeLine()
  if shadowDistance ~= nil then
    RenderSetting.SetShadowDistance(shadowDistance)
  end
  self:SetCityLightActive(true)
  self:RecoverMainCamera()
  self:UnInitCamera()
  self:CloseTimer()
  if self.sceneLoadRequest then
    self.sceneLoadRequest:RealDestroy()
    self.sceneLoadRequest = nil
  end
end

function UIActChristmasTreeTimeLine:CreateLevel()
  self.sceneLoadRequest = nil
  local req = Resource:InstantiateAsync(timelinePath)
  req:completed("+", function()
    local sceneRoot = req.gameObject.transform
    sceneRoot:Set_localPosition(0, 0, 0)
    self.scene = req.gameObject
    self.director = self.scene.transform:GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
    self.cameraRoot = self.scene.transform:Find("Camera")
    self.roleRoot = self.scene.transform:Find("weizhi/bubing")
    self.tankRoot = self.scene.transform:Find("weizhi/Tanke")
    self.feijiRoot = self.scene.transform:Find("weizhi/Feiji")
    self.daodanRoot = self.scene.transform:Find("weizhi/Daodan")
    local childCount = self.roleRoot.transform.childCount
    for index = 1, childCount do
      local v = self.roleRoot.transform:GetChild(index - 1)
      if v ~= nil then
        if index == 1 then
          local mingzi = v.transform:Find("Hero@bubing02_skin_01/To_unity/DeformationSystem/Root/mingzi")
          if mingzi ~= nil then
            self.name1 = mingzi:GetComponent(typeof(CS.SuperTextMesh))
          end
        elseif index == 2 then
          local mingzi = v.transform:Find("Hero@bubing02_skin_01/To_unity/DeformationSystem/Root/mingzi")
          if mingzi ~= nil then
            self.name2 = mingzi:GetComponent(typeof(CS.SuperTextMesh))
          end
        elseif index == 3 then
          local mingzi = v.transform:Find("Hero@bubing02_skin_01/To_unity/DeformationSystem/Root/mingzi")
          if mingzi ~= nil then
            self.name3 = mingzi:GetComponent(typeof(CS.SuperTextMesh))
          end
        end
      end
    end
    self:ResetParam()
    self:OnLoadedScene()
  end)
  self.sceneLoadRequest = req
end

function UIActChristmasTreeTimeLine:ResetParam()
  if self.director then
    self.director:Pause()
  end
end

function UIActChristmasTreeTimeLine:OnLoadedScene()
  self:InitCamera()
  self:InitTimerCallBack()
  self.rawImage:SetActive(true)
end

function UIActChristmasTreeTimeLine:InitCamera()
  self.camera = self.cameraRoot:GetComponentInChildren(typeof(CS.UnityEngine.Camera))
  self.camera.targetTexture = self.renderTexture
end

function UIActChristmasTreeTimeLine:UnInitCamera()
  if self.camera then
    self.camera.targetTexture = nil
    self.camera = nil
  end
end

function UIActChristmasTreeTimeLine:TimeFunc()
  if self.director then
    self.director.time = 0
    self.director:Play()
  end
  local selfName = LuaEntry.Player.name
  local name2 = ""
  local name3 = ""
  local all
  if LuaEntry.Player:IsInAlliance() then
    all = DataCenter.AllianceMemberDataManager:GetAllMember()
  end
  if all then
    local nameList = {}
    for k, v in pairs(all) do
      if v.uid ~= LuaEntry.Player.uid then
        table.insert(nameList, v.name)
      end
    end
    if #nameList == 0 then
      name2 = ""
      name3 = ""
    elseif #nameList == 1 then
      name2 = nameList[1]
      name3 = ""
    else
      for i = 1, 2 do
        local randomNum = math.random(i, #nameList)
        if i < randomNum then
          nameList[i], nameList[randomNum] = nameList[randomNum], nameList[i]
        end
      end
      name2 = nameList[1]
      name3 = nameList[2]
    end
  end
  if self.name1 then
    self.name1.text = selfName
  end
  if self.name2 then
    self.name2.text = name2
  end
  if self.name3 then
    self.name3.text = name3
  end
  local tankRootCount = self.tankRoot.transform.childCount
  local tankRootNum = math.random(1, tankRootCount)
  for index = 1, tankRootCount do
    local v = self.tankRoot.transform:GetChild(index - 1)
    v.gameObject:SetActive(index == tankRootNum)
  end
  local feijiRootCount = self.feijiRoot.transform.childCount
  local feijiRootNum = math.random(1, feijiRootCount)
  for index = 1, feijiRootCount do
    local v = self.feijiRoot.transform:GetChild(index - 1)
    v.gameObject:SetActive(index == feijiRootNum)
  end
  local daodanRootCount = self.daodanRoot.transform.childCount
  local daodanRootNum = math.random(1, daodanRootCount)
  for index = 1, daodanRootCount do
    local v = self.daodanRoot.transform:GetChild(index - 1)
    v.gameObject:SetActive(index == daodanRootNum)
  end
end

function UIActChristmasTreeTimeLine:InitTimerCallBack()
  self:CloseTimer()
  self:TimeFunc()
  local time = self.director.duration
  self._timer = TimerManager:GetInstance():GetTimer(time, self.TimeFunc, self, false, false, false)
  self._timer:Start()
end

function UIActChristmasTreeTimeLine:CloseTimer()
  if self._timer ~= nil then
    self._timer:Stop()
  end
  self._timer = nil
end

function UIActChristmasTreeTimeLine:SetCityLightActive(val)
  local light = CS.UnityEngine.GameObject.Find(LightPath)
  if light ~= nil then
    light:SetActive(val)
  end
end

function UIActChristmasTreeTimeLine:CloseMainCamera()
  self.mainCamera = Camera.main
  self.mainCullingMask = self.mainCamera.cullingMask
  self.mainCamera.cullingMask = 0
end

function UIActChristmasTreeTimeLine:RecoverMainCamera()
  if self.mainCamera ~= nil and self.mainCullingMask ~= nil then
    self.mainCamera.cullingMask = self.mainCullingMask
  end
end

return UIActChristmasTreeTimeLine
