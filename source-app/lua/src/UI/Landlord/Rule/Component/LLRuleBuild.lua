local base = UIAsyncContainer
local LLRuleBuild = BaseClass("LLRuleBuild", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local LLRuleBuildGroupItem = require("UI.Landlord.Rule.Component.LLRuleBuildGroupItem")
local ActMgr = DataCenter.LandlordMgr
local CLS = "UI.Landlord.Rule.Component.LLRuleCommonItem"
local PREFAB = "Assets/Main/Prefabs/UI/Landlord/Rule/LLRuleCommonItem.prefab"

function LLRuleBuild:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLRuleBuild:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLRuleBuild:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.imgGroupArr = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textGroup = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnGroup = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnGroup:SetOnClick(function()
    self:OnBtnGroupClick()
  end)
  self.btnGroupContent = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnGroupContent:SetOnClick(function()
    self:OnBtnGroupContentClick()
  end)
  self.compGroupContent = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self.compGroupCell = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.img = self.viewSkin:AddComponent(self, UIImage, 8)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textProgress = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.btnProgress = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnProgress:SetOnClick(function()
    self:OnBtnProgressClick()
  end)
  self.compRateBg = self.viewSkin:AddComponent(self, UIBaseComponent, 12)
  self.textRate = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.btnRate = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnRate:SetOnClick(function()
    self:OnBtnRateClick()
  end)
  self.compRewardBg = self.viewSkin:AddComponent(self, UIBaseComponent, 15)
  self.btnSwitch = self.viewSkin:AddComponent(self, UIButton, 16)
  self.btnSwitch:SetOnClick(function()
    self:OnBtnSwitchClick()
  end)
  self.textReward = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 17)
  self.btnReward = self.viewSkin:AddComponent(self, UIButton, 18)
  self.btnReward:SetOnClick(function()
    self:OnBtnRewardClick()
  end)
  self.compRewardContent = self.viewSkin:AddComponent(self, UIBaseContainer, 19)
  self.compDescGroup = self.viewSkin:AddComponent(self, UIBaseComponent, 20)
  self.textPDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 21)
  self.compLine = self.viewSkin:AddComponent(self, UIBaseComponent, 22)
  self.compProgressBg = self.viewSkin:AddComponent(self, UIBaseComponent, 23)
  self.compBuildBg = self.viewSkin:AddComponent(self, UIBaseComponent, 24)
  self.textBuild = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 25)
  self.btnBuild = self.viewSkin:AddComponent(self, UIButton, 26)
  self.btnBuild:SetOnClick(function()
    self:OnBtnBuildClick()
  end)
  self.imgBuildArrow = self.viewSkin:AddComponent(self, UIImage, 27)
  self.compBuildContent = self.viewSkin:AddComponent(self, UIBaseContainer, 28)
  self.textPos = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 29)
  self.btnPosText = self.viewSkin:AddComponent(self, UIButton, 30)
  self.btnPosText:SetOnClick(function()
    self:OnBtnPosTextClick()
  end)
end

function LLRuleBuild:ComponentDestroy()
  self.viewSkin = nil
  self.compContent = nil
  self.imgGroupArr = nil
  self.textGroup = nil
  self.btnGroup = nil
  self.btnGroupContent = nil
  self.compGroupContent = nil
  self.compGroupCell = nil
  self.img = nil
  self.textDesc = nil
  self.textProgress = nil
  self.btnProgress = nil
  self.compRateBg = nil
  self.textRate = nil
  self.btnRate = nil
  self.compRewardBg = nil
  self.btnSwitch = nil
  self.textReward = nil
  self.btnReward = nil
  self.compRewardContent = nil
  self.compDescGroup = nil
  self.textPDesc = nil
  self.compLine = nil
  self.compProgressBg = nil
  self.compBuildBg = nil
  self.textBuild = nil
  self.btnBuild = nil
  self.imgBuildArrow = nil
  self.compBuildContent = nil
  self.textPos = nil
  self.btnPosText = nil
end

function LLRuleBuild:DataDefine()
  self.curType = 1
  self.groupCells = {}
  self.cbType = BindCallback(self, self.SetTypeSel)
  self.group_cell = self.compGroupCell.gameObject
  self.group_cell:GameObjectCreatePool()
end

function LLRuleBuild:DataDestroy()
  if self.compContent ~= nil then
    self.compContent:RemoveAllComponentes()
  end
  self.asyncs = nil
  self.items = nil
  self.rewards = nil
  self.compGroupContent:RemoveComponents(LLRuleBuildGroupItem)
  self.group_cell:GameObjectRecycleAll()
  self.cbType = nil
  self.guideList = nil
  self.subList = nil
  self.countMap = nil
  self.cities = nil
  self.mainCityId = nil
  self.extraId = nil
end

function LLRuleBuild:OnAddListener()
  base.OnAddListener(self)
end

function LLRuleBuild:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLRuleBuild:OnBtnGroupClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self:SetTypeSel(0)
end

function LLRuleBuild:OnBtnGroupContentClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self:SetTypeSel(self.curType)
end

function LLRuleBuild:OnBtnProgressClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  EventManager:GetInstance():Broadcast(EventId.LandlordRuleTabIndex, {
    tab = LLConst.RuleType.Battle,
    subTab = 1
  })
end

function LLRuleBuild:OnBtnRateClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  EventManager:GetInstance():Broadcast(EventId.LandlordRuleTabIndex, {
    tab = LLConst.RuleType.Battle,
    subTab = 2
  })
end

function LLRuleBuild:OnBtnSwitchClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self.curCamp = self.curCamp == LLConst.LandLordGroup.LORD and LLConst.LandLordGroup.FARMER or LLConst.LandLordGroup.LORD
  self:RefreshRewardContent()
end

function LLRuleBuild:OnBtnRewardClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILLReward, {anim = true}, {
    camp = self.curCamp,
    tab = LLConst.RewardTabType.BD
  })
end

function LLRuleBuild:OnBtnBuildClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self.showSubBuild = not self.showSubBuild
  self:RefreshBuildContent()
end

function LLRuleBuild:OnBtnPosTextClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.mainCityId == nil then
    return
  end
  ActMgr:JumpToCity(self.mainCityId)
end

function LLRuleBuild:SetInfo(idx, subIdx, extraId)
  self.idx = idx
  self.subIdx = subIdx
  self.extraId = extraId
  self.guideList = ActMgr:GetGuide(self.idx)
  self:RefreshView()
end

function LLRuleBuild:UpdateData()
  if self.guideList == nil then
    return
  end
  if self.subIdx ~= nil then
    self.curType = self.subIdx
    self.subIdx = nil
  end
  self:RefreshGroupShow()
end

function LLRuleBuild:SetTypeSel(index)
  local bShowContent = index == 0
  self.compGroupContent:SetActive(bShowContent)
  self.btnGroupContent:SetActive(bShowContent)
  local imgName = bShowContent and "cfm_tongyong_anniu_xiao_1.png" or "cfm_tongyong_anniu_xiao_2.png"
  local imgPath = string.format(LoadPath.CommonPath, imgName)
  self.imgGroupArr:LoadSpriteAuto(imgPath)
  if not bShowContent then
    self.curType = index
    self:RefreshContent()
    return
  end
  for i, v in ipairs(self.guideList) do
    local obj = self.groupCells[i]
    if obj == nil then
      local item = self.group_cell:GameObjectSpawn(self.compGroupContent.transform)
      item.name = "Item_" .. i
      obj = self.compGroupContent:AddComponent(LLRuleBuildGroupItem, item.name)
      obj:SetActive(true)
      table.insert(self.groupCells, obj)
    end
    obj:SetData(v, i, self.curType, self.cbType)
  end
end

function LLRuleBuild:RefreshGroupShow()
  self.compGroupContent:SetActive(false)
  self.compGroupCell:SetActive(false)
  self:SetTypeSel(self.curType)
end

function LLRuleBuild:RefreshContent()
  self.curCamp = math.max(ActMgr:GetMyGroup(), 1)
  self.showSubBuild = false
  local guideConfig = self.guideList[self.curType]
  local typeConfig = ActMgr:GetCityTypeConfig(guideConfig.subtype)
  local city_id = self.extraId or typeConfig.city_id
  self.extraId = nil
  self.mainCityId = city_id
  local cityConfig = ActMgr:GetCityTemplate(city_id)
  local cityPos = cityConfig.pos
  self.textPos:SetLocalText(300015, cityPos.x, cityPos.y)
  self.textGroup:SetLocalText(guideConfig.tittle)
  self.img:LoadSpriteAsyncWithCallback(cityConfig.city_rally_icon, function()
    self.img:SetAspectSize(260)
  end)
  self.textDesc:SetLocalText(guideConfig.desc)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.textDesc.transform)
  self.textProgress:SetText(string.format("%s: %s", Localization:GetString("zonewar_landlord_limit_1002"), cityConfig.boom_progress))
  local isCenter = guideConfig.subtype == LLConst.CitySubType.Throne
  self.compLine:SetActive(isCenter)
  self.compDescGroup:SetActive(isCenter)
  if isCenter then
    self.textPDesc:SetLocalText("zonewar_landlord_desc_1035")
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.textPDesc.transform)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.textPDesc.transform.parent)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compProgressBg.transform)
  self.textRate:SetText(string.format("%s: %s", Localization:GetString("zonewar_landlord_tittle_10002"), cityConfig.ruins_points))
  self:RefreshRewardContent()
  local subIds = typeConfig.belong_building
  local countMap = {}
  local orderedIds = {}
  for _, id in ipairs(subIds) do
    if not table.hasvalue(orderedIds, id) then
      table.insert(orderedIds, id)
    end
    countMap[id] = countMap[id] or 0
    countMap[id] = countMap[id] + 1
  end
  self.subList = orderedIds
  self.countMap = countMap
  local haveSub = 0 < #self.subList
  self.compBuildBg:SetActive(haveSub)
  if haveSub then
    self.textBuild:SetLocalText("zonewar_landlord_limit_1005")
    self:RefreshBuildContent()
  else
    self.compBuildBg:SetActive(false)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compContent.transform)
  end
end

function LLRuleBuild:RefreshRewardContent()
  local guideConfig = self.guideList[self.curType]
  local key = self.curCamp == LLConst.LandLordGroup.LORD and "zonewar_landlord_limit_1004" or "zonewar_landlord_limit_1003"
  self.textReward:SetLocalText(key)
  self.rewards = ActMgr:GetCityTypeRewards(guideConfig.subtype, self.curCamp)
  self.asyncs = self.asyncs or {}
  self.items = self.items or {}
  local iCnt = #self.items
  local rCnt = #self.rewards
  local max = math.max(iCnt, rCnt)
  for i = 1, max do
    local info = self.rewards[i]
    local item = self.items[i]
    if info ~= nil then
      if item ~= nil then
        self:RefreshIcon(i)
      else
        local async = self.asyncs[i]
        if async == nil then
          local idx = i
          async = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
            if request.isError then
              return
            end
            local go = request.gameObject
            go.name = "Item_" .. idx
            go.gameObject:SetActive(true)
            local tf = go.transform
            tf:SetParent(self.compRewardContent.transform)
            tf:Reset()
            local cell = self.compRewardContent:AddComponent(UICommonResItem, go.name)
            cell:SetSizeDeltaXY(COMMON_RES_ITEM_DEF_SIZE, COMMON_RES_ITEM_DEF_SIZE)
            cell:SetLocalScaleXYZ(0.7, 0.7, 1)
            self.items[idx] = cell
            self:RefreshIcon(idx)
          end)
          self.asyncs[i] = async
        end
      end
    elseif item ~= nil then
      item:SetActive(false)
    end
  end
end

function LLRuleBuild:RefreshIcon(i)
  local item = self.items[i]
  if item == nil then
    return
  end
  local info = self.rewards[i]
  item:SetActive(info ~= nil)
  if info ~= nil then
    item:ReInit(info)
  end
end

function LLRuleBuild:RefreshBuildContent()
  if self.compBuildBg:GetActive() then
    local imgName = self.showSubBuild and "cfm_tongyong_anniu_xiao_1.png" or "cfm_tongyong_anniu_xiao_2.png"
    self.imgBuildArrow:LoadSpriteAuto(string.format(LoadPath.CommonPath, imgName))
    self.compBuildContent:SetActive(self.showSubBuild)
    if self.showSubBuild then
      self:RefreshList()
    end
  else
    self.compBuildContent:SetActive(false)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compBuildBg.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compContent.transform)
end

function LLRuleBuild:RefreshList()
  self.cities = self.cities or {}
  local cnt = 0
  local max = math.max(#self.cities, #self.subList)
  for i = 1, max do
    local id = self.subList[i]
    local item = self.cities[i]
    if id ~= nil then
      if item == nil then
        item = self:LoadComponentAsync(CLS, PREFAB, self.compBuildContent, function()
          cnt = cnt + 1
          self:CheckLoadAsyncFinish(cnt)
        end)
        self.cities[i] = item
      else
        cnt = cnt + 1
      end
      item:SetActive(true)
      local typeCfg = ActMgr:GetCityTypeConfig(id)
      local cityCfg = ActMgr:GetCityTemplate(typeCfg.city_id)
      item:SetData({
        id = id,
        pic = cityCfg ~= nil and cityCfg:GetIconPath() or nil,
        tittle = typeCfg.name,
        desc = typeCfg.desc,
        num = self.countMap[id]
      })
      self:CheckLoadAsyncFinish(cnt)
    elseif item ~= nil then
      item:SetActive(false)
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compBuildContent.transform)
end

function LLRuleBuild:CheckLoadAsyncFinish(cnt)
  local max = self.showSubBuild and #self.subList or 0
  if cnt ~= max then
    return
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compBuildContent.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compBuildBg.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compContent.transform)
end

return LLRuleBuild
