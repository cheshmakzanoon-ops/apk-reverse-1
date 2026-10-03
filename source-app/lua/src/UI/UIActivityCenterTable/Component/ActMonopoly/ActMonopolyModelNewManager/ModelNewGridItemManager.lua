local ModelNewGridItemManager = BaseClass("ModelNewGridItemManager")
local Resource = CS.GameEntry.Resource
local SpriteRenderer = CS.UnityEngine.SpriteRenderer
local SuperTextMesh = CS.SuperTextMesh
local SkinnedMeshRenderer = CS.UnityEngine.SkinnedMeshRenderer
local Localization = CS.GameEntry.Localization
local gridItemPath = "Assets/Main/Prefabs/PrefabsIncrement/Prop/O_env_dafuweng_dikuai_01/O_env_dafuweng_dikuai_01.prefab"
local boxPath = "Assets/Main/Prefabs/UIChristmasPerfab/actMonopolyBaoxiang.prefab"
local GridOriginPosX = 4.17
local GridOriginPosY = -3.72
local X_AxisVectorX = 0
local X_AxisVectorY = 0.93
local Y_AxisVectorX = -0.93
local Y_AxisVectorY = 0
local objH = 0.44
local effectConfig = {
  [ActMonopolyGridEffectType.Eff_ui_dfw_dikuai_shuaguang] = {
    path = "Assets/_Art_LastWar/Effect/Prefab/UI/Dafuweng/Eff_ui_dfw_dikuai_shuaguang.prefab",
    time = 0.8
  },
  [ActMonopolyGridEffectType.Eff_ui_dfw_dikuai_jiangli] = {
    path = "Assets/_Art_LastWar/Effect/Prefab/UI/Dafuweng/Eff_ui_dfw_dikuai_jiangli.prefab",
    time = 0.8
  }
}

function ModelNewGridItemManager:__init()
  self:DataDefine()
end

function ModelNewGridItemManager:__delete()
  self:OnDestroy()
end

function ModelNewGridItemManager:DataDefine()
  self.activityId = nil
  self.activityInfo = nil
  self.activityDetailData = nil
  self.gridTempDict = nil
  self.modelShowManager = nil
  self.isAllModelLoad = false
  self.gridItemPath = gridItemPath
  self.gridItemMPB = nil
  self.gridItemList = {}
  self.gridEffectList = {}
  self.gridEffectCacheList = {}
  self.specialBoxList = {}
  self.specialBoxCacheList = {}
end

function ModelNewGridItemManager:OnDestroy()
  self.activityId = nil
  self.activityInfo = nil
  self.activityDetailData = nil
  self.gridTempDict = nil
  self.modelShowManager = nil
  self.isAllModelLoad = nil
  self.gridItemPath = nil
  self.gridItemMPB = nil
  self.gridItemList = nil
  self.gridItemCacheList = nil
  self.gridEffectList = nil
  self.gridEffectCacheList = nil
  self.effectTypeConfig = nil
  self.specialBoxList = nil
  self.specialBoxCacheList = nil
end

function ModelNewGridItemManager:SetData(activityId, activityInfo, activityDetailData, actGridTempList)
  self.activityId = activityId
  self.activityInfo = activityInfo
  self.activityDetailData = activityDetailData
  self.actGridTempList = actGridTempList
end

function ModelNewGridItemManager:StartShow(modelShowManager)
  self.modelShowManager = modelShowManager
  self.isAllModelLoad = false
  self:LoadAllModelGridItems()
end

function ModelNewGridItemManager:EndShow()
  self.isAllModelLoad = false
  self:GridItemEndShow()
  self:GridEffectEndShow()
  self:SpecialBoxEndShow()
end

function ModelNewGridItemManager:LoadAllModelGridItems()
  self.needWaitLoadNum = 0
  for i, gridTemp in ipairs(self.actGridTempList) do
    self.gridItemList[i] = {
      req = nil,
      obj = nil,
      index = i,
      comps = {
        bgRender = nil,
        icon = nil,
        oneIcon = nil,
        progressNum = nil,
        progressNumTMP = nil,
        ani = nil
      }
    }
    self.needWaitLoadNum = self.needWaitLoadNum + 1
    local data = self.gridItemList[i]
    local loadGridItemPath = string.IsNullOrEmpty(gridTemp.grid_prefab) and self.gridItemPath or gridTemp.grid_prefab
    local req = Resource:InstantiateAsync(loadGridItemPath)
    data.req = req
    req:completed("+", function()
      CommonUtil.CallAutoArabicMirrorManually(req)
      local root = req.gameObject
      root:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("timeline"))
      data.obj = root
      root.transform:SetParent(self.modelShowManager.modelRoot.transform, false)
      data.comps.bgRender = data.obj.transform:Find("O_env_dafuweng_dikuai_01_skin/To_unity/Geometry/O_env_dafuweng_dikuai_03"):GetComponent(typeof(SkinnedMeshRenderer))
      data.comps.ani = data.obj.transform:Find("O_env_dafuweng_dikuai_01_skin"):GetComponent(typeof(CS.SimpleAnimation))
      data.comps.icon = data.obj.transform:Find("O_env_dafuweng_dikuai_01_skin/To_unity/DeformationSystem/root/hip/joint3/icon"):GetComponent(typeof(SpriteRenderer))
      data.comps.oneIcon = data.obj.transform:Find("O_env_dafuweng_dikuai_01_skin/To_unity/DeformationSystem/root/hip/joint3/oneIcon"):GetComponent(typeof(SpriteRenderer))
      data.comps.progressNum = data.obj.transform:Find("O_env_dafuweng_dikuai_01_skin/To_unity/DeformationSystem/root/hip/joint3/progressNum"):GetComponent(typeof(SuperTextMesh))
      data.comps.progressNumTMP = data.obj.transform:Find("O_env_dafuweng_dikuai_01_skin/To_unity/DeformationSystem/root/hip/joint3/progressNum_tmp"):GetComponent(typeof(CS.TextMeshProEx))
      self:InitGridItemByIndex(data.index)
      self.needWaitLoadNum = self.needWaitLoadNum - 1
      if self.needWaitLoadNum == 0 then
        self.isAllModelLoad = true
        self.modelShowManager.modelNewGridItemManagerInitFin = true
        self.modelShowManager:CheckAllLoadFinish()
        self:RefreshSpecialBox()
      end
    end)
  end
end

function ModelNewGridItemManager:GetGridLocalPosByIndex(index)
  local temp = self.actGridTempList[index]
  local posX = temp.posData.x
  local posY = temp.posData.y
  return self:GetGridLocalPos(posX, posY)
end

function ModelNewGridItemManager:GetGridLocalPos(posX, posY)
  local aPosX = 0
  local aPosY = 0
  aPosX = GridOriginPosX + posX * X_AxisVectorX + posY * Y_AxisVectorX
  aPosY = GridOriginPosY + posX * X_AxisVectorY + posY * Y_AxisVectorY
  return aPosX, aPosY
end

function ModelNewGridItemManager:InitGridItemByIndex(index)
  local temp = self.actGridTempList[index]
  local data = self.gridItemList[index]
  local lPosX, lPosY = self:GetGridLocalPosByIndex(index)
  data.obj.transform.localPosition = Vector3.New(lPosX, 0, lPosY)
  local iconName = "lrb_dafuweng_gezi_icon_wenhao"
  if not string.IsNullOrEmpty(temp.exhibition) then
    iconName = temp.exhibition
  end
  local iconPath = string.format(UIAssets.UIActMonopolySpritePath, iconName)
  if temp.type == ActMonopolyGridType.Exp then
    data.comps.icon.gameObject:SetActive(true)
    data.comps.progressNum.gameObject:SetActive(false)
    data.comps.progressNumTMP.gameObject:SetActive(true)
    data.comps.oneIcon.gameObject:SetActive(false)
    data.comps.icon:LoadSprite(iconPath)
  else
    data.comps.icon.gameObject:SetActive(false)
    data.comps.progressNum.gameObject:SetActive(false)
    data.comps.progressNumTMP.gameObject:SetActive(false)
    data.comps.oneIcon.gameObject:SetActive(true)
    data.comps.oneIcon:LoadSprite(iconPath)
    local bgVal = self:GetExpGridBgByLv(-1)
    self:GetGridItemMPB(bgVal)
    data.comps.bgRender:SetPropertyBlock(self.gridItemMPB)
  end
  self:RefreshGridItemByIndex(index)
end

function ModelNewGridItemManager:RefreshGridItemByIndex(index, inputLv, inputExp)
  local temp = self.actGridTempList[index]
  local data = self.gridItemList[index]
  local curData = self.activityDetailData:GetGridItemDatabyIndex(index)
  if temp.type == ActMonopolyGridType.Exp then
    local curLv = curData.lv or 1
    local curExp = curData.exp or 0
    if inputLv ~= nil then
      curLv = inputLv
    end
    if inputExp ~= nil then
      curExp = inputExp
    end
    local bgVal = self:GetExpGridBgByLv(curLv)
    self:GetGridItemMPB(bgVal)
    data.comps.bgRender:SetPropertyBlock(self.gridItemMPB)
    local curLvMax = temp.expList[curLv]
    if curLvMax == nil then
      data.comps.progressNumTMP.text = Localization:GetString(454114)
    else
      data.comps.progressNumTMP.text = string.format("%d/%d", curExp, curLvMax)
    end
  end
end

function ModelNewGridItemManager:GetGridItemMPB(value)
  if IsNull(self.gridItemMPB) then
    local mpb = CS.UnityEngine.MaterialPropertyBlock()
    self.gridItemMPB = mpb
  end
  self.gridItemMPB:SetInt("_SetF", value)
  return self.gridItemMPB
end

function ModelNewGridItemManager:GetExpGridBgByLv(level)
  local val = 4
  if 1 <= level and level <= 4 then
    val = level - 1
  end
  return val
end

function ModelNewGridItemManager:PlayJumpAniByIndex(index, speed)
  local data = self.gridItemList[index]
  local aniName = "jump"
  data.comps.ani:Stop()
  data.comps.ani:SetStateSpeed(aniName, speed)
  data.comps.ani:Play(aniName)
end

function ModelNewGridItemManager:GetGridItemRoleLocalPosByIndex(index)
  local localPos = Vector3.zero
  local data = self.gridItemList[index]
  if data then
    localPos = data.obj.transform.localPosition
    local localPosY = objH
    localPos.y = localPosY
  end
  return localPos
end

function ModelNewGridItemManager:GridItemEndShow()
  for k, v in pairs(self.gridItemList) do
    if v.req then
      v.req:Destroy()
    end
  end
  self.gridItemList = {}
end

function ModelNewGridItemManager:OnUpdate1000MS()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for type, dataDict in pairs(self.gridEffectList) do
    for index, effectData in pairs(dataDict) do
      if curTime >= effectData.finTime then
        self:RecycleGridEffect(type, index)
      end
    end
  end
end

function ModelNewGridItemManager:RecycleGridEffect(effectType, index)
  local effectData = self.gridEffectList[effectType][index]
  if effectData.obj then
    effectData.obj:SetActive(false)
  end
  if self.gridEffectCacheList[effectType] == nil then
    self.gridEffectCacheList[effectType] = {}
  end
  table.insert(self.gridEffectCacheList[effectType], effectData)
  self.gridEffectList[effectType][index] = nil
end

function ModelNewGridItemManager:PlayGridEffect(effectType, index)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local effectConfigData = effectConfig[effectType]
  local finTime = curTime + effectConfigData.time * 1000
  local localPos = self:GetGridItemRoleLocalPosByIndex(index)
  if self.gridEffectList[effectType] == nil then
    self.gridEffectList[effectType] = {}
  end
  if self.gridEffectList[effectType][index] then
    local effectData = self.gridEffectList[effectType][index]
    effectData.finTime = finTime
    if effectData.obj then
      effectData.obj:SetActive(false)
      effectData.obj:SetActive(true)
    else
    end
  elseif self.gridEffectCacheList[effectType] and #self.gridEffectCacheList[effectType] > 0 then
    local cacheListLen = #self.gridEffectCacheList[effectType]
    local effectData = self.gridEffectCacheList[effectType][cacheListLen]
    self.gridEffectCacheList[effectType][cacheListLen] = nil
    effectData.finTime = finTime
    self.gridEffectList[effectType][index] = effectData
    if effectData.obj then
      effectData.obj.transform.localPosition = localPos
      effectData.obj:SetActive(false)
      effectData.obj:SetActive(true)
    else
    end
  else
    local effectData = {
      req = nil,
      obj = nil,
      finTime = finTime
    }
    local req = Resource:InstantiateAsync(effectConfigData.path)
    effectData.req = req
    req:completed("+", function()
      local obj = req.gameObject
      obj:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("timeline"))
      obj:SetActive(false)
      obj.transform:SetParent(self.modelShowManager.modelRoot.transform, false)
      effectData.obj = obj
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if curTime < effectData.finTime then
        obj.transform.localPosition = localPos
        obj:SetActive(true)
      end
    end)
    self.gridEffectList[effectType][index] = effectData
  end
end

function ModelNewGridItemManager:GridEffectEndShow()
  for type, dataDict in pairs(self.gridEffectList) do
    for k, v in pairs(dataDict) do
      if v.req then
        v.req:Destroy()
      end
    end
  end
  self.gridEffectList = {}
  for type, cacheList in pairs(self.gridEffectCacheList) do
    for k, v in pairs(cacheList) do
      if v.req then
        v.req:Destroy()
      end
    end
  end
  self.gridEffectCacheList = {}
end

function ModelNewGridItemManager:GetSpecialBoxShowData()
  local specialBoxData = {}
  local boxData = self.activityDetailData.boxGrid
  if boxData and boxData.order > 0 then
    local imgIcon = "lrb_dafuweng_gezi_baoxiangguan"
    local activityInfo = self.activityInfo
    if activityInfo then
      local showTemp = activityInfo:GetShowConfigTemp()
      if showTemp then
        local configImg = showTemp.monopoly_gridbox
        if not string.IsNullOrEmpty(configImg) then
          local boxImgList = string.split(configImg, "|")
          imgIcon = boxImgList[1]
        end
      end
    end
    local imgIconPath = string.format(UIAssets.UIActMonopolySpritePath, imgIcon)
    specialBoxData[boxData.order] = {iconPath = imgIconPath}
  end
  return specialBoxData
end

function ModelNewGridItemManager:RefreshSpecialBox()
  if self.isAllModelLoad == false then
    return
  end
  local specialBoxData = self:GetSpecialBoxShowData()
  local needRemoveIndexList = {}
  for index, boxData in pairs(self.specialBoxList) do
    if specialBoxData[index] == nil then
      boxData.index = -1
      if boxData.obj then
        boxData.obj:SetActive(false)
      end
      table.insert(self.specialBoxCacheList, boxData)
      self.specialBoxList[index] = nil
    else
      if boxData.iconPath ~= specialBoxData[index].iconPath then
        boxData.iconPath = specialBoxData[index].iconPath
        if boxData.obj then
          boxData.iconRender:LoadSprite(specialBoxData[index].iconPath)
        end
      end
      table.insert(needRemoveIndexList, index)
    end
  end
  for i, index in ipairs(needRemoveIndexList) do
    specialBoxData[index] = nil
  end
  for index, data in pairs(specialBoxData) do
    if self.specialBoxCacheList and #self.specialBoxCacheList > 0 then
      local cacheListLen = #self.specialBoxCacheList
      local boxData = self.specialBoxCacheList[cacheListLen]
      self.specialBoxCacheList[cacheListLen] = nil
      boxData.index = index
      boxData.iconPath = data.iconPath
      if boxData.obj then
        boxData.iconRender:LoadSprite(data.iconPath)
        boxData.obj.transform.localPosition = self:GetGridItemRoleLocalPosByIndex(boxData.index)
        boxData.obj:SetActive(true)
      else
      end
      self.specialBoxList[index] = boxData
    else
      local boxData = {
        req = nil,
        obj = nil,
        index = index,
        iconPath = data.iconPath,
        iconRender = nil
      }
      local req = Resource:InstantiateAsync(boxPath)
      boxData.req = req
      req:completed("+", function()
        local root = req.gameObject
        root:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("timeline"))
        boxData.obj = root
        root.transform:SetParent(self.modelShowManager.modelRoot.transform, false)
        boxData.iconRender = root.transform:Find("icon"):GetComponent(typeof(SpriteRenderer))
        if boxData.index > 0 then
          root.transform.localPosition = self:GetGridItemRoleLocalPosByIndex(boxData.index)
          root:SetActive(true)
          boxData.iconRender:LoadSprite(boxData.iconPath)
        else
          root:SetActive(false)
        end
      end)
      self.specialBoxList[index] = boxData
    end
  end
end

function ModelNewGridItemManager:SpecialBoxEndShow()
  for index, boxData in pairs(self.specialBoxList) do
    if boxData.req then
      boxData.req:Destroy()
    end
  end
  self.specialBoxList = {}
  for k, v in pairs(self.specialBoxCacheList) do
    if v.req then
      v.req:Destroy()
    end
  end
  self.specialBoxCacheList = {}
end

return ModelNewGridItemManager
