local UIBuildListCell = BaseClass("UIBuildListCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UICommonDesTipView = require("UI.UICommonDesTip.View.UICommonDesTipView")
local UIBuildDecorateCell = require("UI.UIBuildList.Component.UIBuildDecorateCell")
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local SliderLength = 455
local this_path = ""
local build_bg_path = "buildBg"
local build_icon_path = "buildBg/buildIcon"
local build_detailBtn_path = "buildBg/detailBtn"
local build_dummy_icon_path = "buildBg/AnimDummy/buildDummyIcon"
local build_name_path = "buildBg/titleContent/buildName"
local cost_path = "buildBg/buildCondition/cost"
local need_resource1_path = "buildBg/buildCondition/cost/ResourceGo/NeedResource1"
local need_icon1_path = "buildBg/buildCondition/cost/ResourceGo/NeedResource1/needItem1Num/needItem1"
local need_num1_path = "buildBg/buildCondition/cost/ResourceGo/NeedResource1/needItem1Num"
local need_resource2_path = "buildBg/buildCondition/cost/ResourceGo/NeedResource2"
local need_icon2_path = "buildBg/buildCondition/cost/ResourceGo/NeedResource2/needItem2Num/needItem2"
local need_num2_path = "buildBg/buildCondition/cost/ResourceGo/NeedResource2/needItem2Num"
local time_text_path = "buildBg/buildDetail/timeText"
local time_value_path = "buildBg/buildCondition/status/statusBg/timeValue"
local own_text_path = "buildBg/buildDetail/OwnText"
local own_num_path = "buildBg/buildCondition/status/statusBg/buildValue"
local reason_value_bg_path = "buildBg/requestBg"
local reason_value_path = "buildBg/requestBg/requireTxt"
local reason_value_dummy_path = "buildBg/AnimDummy/requestBg/requireDummyTxt"
local build_detail_path = "buildBg/buildDetail"
local red_dot_path = "buildBg/redDot"
local build_des_path = "buildBg/titleContent/buildDes"
local robot_obj_path = "buildBg/robotObj"
local robot_name_path = "buildBg/robotObj/robotNameBg/robotName"
local robot_des_path = "buildBg/robotObj/robotDes"
local queue_slider_path = "buildBg/robotObj/Background"
local workBuildName_path = "buildBg/robotObj/Background/workBuildName"
local queue_slider_img_path = "buildBg/robotObj/Background/Fill"
local queue_task_img_path = "buildBg/robotObj/Background/Image"
local queue_goto_btn_path = "buildBg/robotObj/Btn_Goto"
local rect_freeEffect_path = "buildBg/robotObj/Btn_Goto/Rect_FreeEffect"
local queue_goto_txt_path = "buildBg/robotObj/Btn_Goto/queueGoto/gotoTxt"
local queue_goto_path = "buildBg/robotObj/Btn_Goto/queueGoto"
local queue_goto_icon_path = "buildBg/robotObj/Btn_Goto/queueGoto/gotoIcon"
local queue_free_des_path = "buildBg/robotObj/robotState"
local queue_unlock_icon_path = "buildBg/robotObj/Btn_Goto/queueGoto/unlockIcon"
local build_detail_icon_path = "buildBg/detail"
local lock_go_path = "buildBg/Lock"
local buildCondition_group_path = "buildBg/buildCondition"
local new_txt_path = "buildBg/redDot/Bg/Text"
local YesColor = Color.New(1, 1, 1, 1.0)
local NoColor = Color.New(0.918, 0.26, 0.26, 1.0)
local GrayReasonColor = Color.New(0.4235294, 0.2039216, 0.08627451, 1.0)
local LackBuildColor = Color.New(0.9333333, 0, 0, 1.0)
local OwnTextBuildColor = Color.New(0.7843137, 0.5764706, 0.372549, 1.0)
local OwnTextPickColor = Color.New(0.15294, 0.77647, 0.549, 1.0)
local IconPosition = Vector3.New(0, 182, 0)

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

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.anim = self:AddComponent(UIAnimator, this_path)
end

local function DelayComponentDefine(self)
  if not self.define then
    self.define = true
    self.btn = self:AddComponent(UIButton, build_bg_path)
    self.build_icon = self:AddComponent(UIImage, build_icon_path)
    self.build_dummy_icon = self:AddComponent(UIImage, build_dummy_icon_path)
    self.build_bg = self:AddComponent(UIImage, build_bg_path)
    self.build_name = self:AddComponent(UIText, build_name_path)
    self.robot_name = self:AddComponent(UIText, robot_name_path)
    self.need_icon1 = self:AddComponent(UIImage, need_icon1_path)
    self.need_num1 = self:AddComponent(UIText, need_num1_path)
    self.need_icon2 = self:AddComponent(UIImage, need_icon2_path)
    self.need_num2 = self:AddComponent(UIText, need_num2_path)
    self.own_num = self:AddComponent(UIText, own_num_path)
    self.costItem = self:AddComponent(UIBaseContainer, cost_path)
    self.need_resource1 = self:AddComponent(UIBaseContainer, need_resource1_path)
    self.need_resource2 = self:AddComponent(UIBaseContainer, need_resource2_path)
    self.time_text = self:AddComponent(UIText, time_text_path)
    self.time_value = self:AddComponent(UIText, time_value_path)
    self.own_text = self:AddComponent(UIText, own_text_path)
    self.reason_bg_value = self:AddComponent(UIImage, reason_value_bg_path)
    self.reason_value = self:AddComponent(UIText, reason_value_path)
    self.reason_dummy_value = self:AddComponent(UIText, reason_value_dummy_path)
    self.build_detail = self:AddComponent(UIBaseContainer, build_detail_path)
    self.red_dot = self:AddComponent(UIBaseContainer, red_dot_path)
    self.build_detail_icon = self:AddComponent(UIImage, build_detail_icon_path)
    self.build_des = self:AddComponent(UIText, build_des_path)
    self.robot_obj = self:AddComponent(UIBaseContainer, robot_obj_path)
    self.queue_slider = self:AddComponent(UIButton, queue_slider_path)
    self.workBuildName = self:AddComponent(UIText, workBuildName_path)
    self.queue_slider:SetOnClick(function()
      self:OnCellBgClick()
    end)
    self.decorateBg = self:AddComponent(UIBuildDecorateCell, "decorateBg")
    self.queue_slider_img = self:AddComponent(UIImage, queue_slider_img_path)
    self.queue_goto_btn = self:AddComponent(UIButton, queue_goto_btn_path)
    self.rect_freeEffect = self:AddComponent(UIBaseContainer, rect_freeEffect_path)
    self.queue_task_img = self:AddComponent(UIImage, queue_task_img_path)
    self.queue_goto_img = self:AddComponent(UIImage, queue_goto_btn_path)
    self.queue_goto_btn:SetOnClick(function()
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      self:OnBtnClick()
    end)
    self.queue_goto_txt = self:AddComponent(UIText, queue_goto_txt_path)
    self.queue_goto = self:AddComponent(UIText, queue_goto_path)
    self.queue_goto_icon = self:AddComponent(UIImage, queue_goto_icon_path)
    self.queue_goto_txt_shadow = self:AddComponent(UIShadow, queue_goto_txt_path)
    self.queue_free_des = self:AddComponent(UIText, queue_free_des_path)
    self.robot_des = self:AddComponent(UIText, robot_des_path)
    self.queue_unlock_icon = self:AddComponent(UIImage, queue_unlock_icon_path)
    self.btn:SetOnClick(function()
      self:OnSelectBtnClick()
    end)
    self.lock_go = self:AddComponent(UIBaseContainer, lock_go_path)
    self.buildCondition_group = self:AddComponent(UIBaseContainer, buildCondition_group_path)
    self.new_txt = self:AddComponent(UIText, new_txt_path)
    self.new_txt:SetLocalText(458557)
  end
end

local function ComponentDestroy(self)
  self.anim = nil
  self.btn = nil
  self.build_icon = nil
  self.build_dummy_icon = nil
  self.build_bg = nil
  self.build_name = nil
  self.need_icon1 = nil
  self.need_num1 = nil
  self.need_icon2 = nil
  self.need_num2 = nil
  self.own_num = nil
  self.event_trigger = nil
  self.costItem = nil
  self.need_resource1 = nil
  self.need_resource2 = nil
  self.time_text = nil
  self.time_value = nil
  self.own_text = nil
  self.reason_bg_value = nil
  self.reason_value = nil
  self.reason_dummy_value = nil
  self.build_detail = nil
  self.red_dot = nil
  self.build_des = nil
  self.queue_goto_img = nil
  self.queue_goto_btn = nil
  self.queue_goto_txt = nil
  self.queue_unlock_icon = nil
  self.queue_slider_txt = nil
  self.queue_goto_txt_shadow = nil
  self.lock_go = nil
  self.robot_des = nil
  self.workBuildName = nil
  self.detailBtn = nil
end

local function DataDefine(self)
  self.param = {}
  self.isDrag = nil
  self.isInBuild = false
  self.buildTemplate = nil
  self.uuid = 0
  self.isStartDray = false
  self.lackResource = nil
  self.define = nil
  self.isUpdate = false
  self.startTime = 0
  self.endTime = 0
  self.laseTime = 0
  self.lastCurTime = 0
  self.unlockData = nil
  self.gotoUpgradeId = nil
  self.gotoLevel = nil
  self.freeTime = 0
  self.canBuild = false
end

local function DataDestroy(self)
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self.param = nil
  self.touchPositionY = nil
  self.isDrag = nil
  self.isInBuild = nil
  self.buildTemplate = nil
  self.uuid = nil
  self.isStartDray = nil
  self.lackResource = nil
  self.define = nil
  self.isUpdate = nil
  self.startTime = nil
  self.endTime = nil
  self.laseTime = nil
  self.lastCurTime = nil
  self.gotoUpgradeId = nil
  self.gotoLevel = nil
  self.canBuild = nil
  self.isBuiltMax = nil
  self.isTabClick = nil
  self.index = nil
  self.allAnimNum = nil
end

local function ReInit(self, param, isTabClick, index, max)
  self.param = param
  self.isTabClick = isTabClick
  self.index = index
  self.allAnimNum = max
  if param ~= nil then
    self.isInBuild = false
    if not param.isDelay then
      self:DelayComponentDefine()
      self:InitData()
    end
  end
end

local function InitData(self)
  self.canBuild = false
  if self.param.buildType == UIBuildListBuildType.Decorate then
    self.decorateBg:SetActive(true)
    self.decorateBg:ReInit(self.param)
    self.isBuiltMax = self.decorateBg:GetState()
    self.build_bg:SetActive(false)
  else
    self.decorateBg:SetActive(false)
    self.build_bg:SetActive(true)
  end
  self.error_tips = nil
  self.lackResource = nil
  self.isUpdate = false
  self.showList = {}
  self.rect_freeEffect:SetActive(false)
  self.isUseFreeTime = false
  self.reason_value:SetColor(Color.white)
  if self.param.buildType == UIBuildListBuildType.BuildRoad then
    self:RefreshRedDot(false)
    self.build_des:SetActive(false)
    self.robot_obj:SetActive(false)
    self.build_icon:SetActive(true)
    self.build_icon:SetColor(WhiteColor)
    self.build_bg:SetColor(WhiteColor)
    self.build_icon:SetLocalPosition(IconPosition)
    self.build_detail:SetActive(false)
    self.reason_bg_value:SetActive(false)
    self.buildCondition_group:SetActive(true)
    self.build_detail_icon:SetActive(false)
    self.build_bg:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_tanchuang_lan_bg"))
    self.canBuild = true
    self.build_name:SetLocalText(GameDialogDefine.BUILD_ROAD)
    self.buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.FUN_BUILD_ROAD)
    if self.buildTemplate ~= nil then
      local needCount = 0
      local needResource = self.buildTemplate:GetNeedResource()
      local resourceCount = table.count(needResource)
      if 0 < resourceCount then
        needCount = needCount + resourceCount
        for k, v in ipairs(needResource) do
          local need = v.count
          local resourceType = v.resourceType
          local ownNum = LuaEntry.Resource:GetCntByResType(resourceType)
          local param = {}
          table.insert(self.showList, param)
          param.icon = DataCenter.ResourceManager:GetResourceIconByType(resourceType)
          param.num = string.GetFormattedStr(need)
          param.needType = CommonCostNeedType.Resource
          param.itemId = resourceType
          param.need = need
          if need <= ownNum then
            param.numColor = YesColor
            if self.lackResource == nil then
              self.lackResource = resourceType
            end
          else
            param.numColor = NoColor
          end
        end
      end
      local maxNum = self.buildTemplate:GetCurMaxCanBuildNum()
      local hasBuild = DataCenter.BoardManager:GetBoardCount()
      self.own_num:SetText("")
      self.isDrag = maxNum > hasBuild
    end
    self.own_text:SetLocalText(GameDialogDefine.HAS_BUILD)
    self.own_text:SetColor(OwnTextBuildColor)
    self.own_text:SetText("")
    self.time_text:SetLocalText(GameDialogDefine.TIME)
    self.lock_go:SetActive(false)
    local buildTime = DataCenter.BoardManager:GetBuildTime()
    if 60000 < buildTime then
      self.time_value:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(buildTime))
    else
      self.time_value:SetLocalText(GameDialogDefine.SEC, math.ceil(buildTime / 1000))
    end
    self:ShowResourceCell()
  elseif self.param.buildType == UIBuildListBuildType.RemoveRoad then
    self.build_des:SetActive(false)
    self.robot_obj:SetActive(false)
    self:RefreshRedDot(false)
    self.build_icon:SetActive(true)
    self.build_detail_icon:SetActive(false)
    self.build_icon:SetColor(WhiteColor)
    self.build_bg:SetColor(WhiteColor)
    self.build_icon:SetLocalPosition(IconPosition)
    self.build_detail:SetActive(false)
    self.reason_bg_value:SetActive(false)
    self.buildCondition_group:SetActive(true)
    self.build_bg:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_tanchuang_lan_bg"))
    self.canBuild = true
    self.build_name:SetLocalText(GameDialogDefine.DELETE_ROAD)
    self.costItem:SetActive(false)
    self.need_resource1:SetActive(false)
    self.need_resource2:SetActive(false)
    self.time_text:SetLocalText(GameDialogDefine.TIME)
    self.time_value:SetLocalText(GameDialogDefine.SEC, 0)
    self.own_text:SetLocalText(GameDialogDefine.HAS_BUILD)
    self.own_text:SetColor(OwnTextBuildColor)
    self.own_text:SetText("")
    self.own_num:SetText("")
    self.isDrag = true
    self.lock_go:SetActive(false)
    self:ShowResourceCell()
  elseif self.param.buildType == UIBuildListBuildType.Build then
    self.build_icon:SetActive(true)
    self.build_detail_icon:SetActive(false)
    self.buildTemplate = self.param.buildTemplate
    self.robot_obj:SetActive(false)
    if self.buildTemplate ~= nil then
      local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.param.buildId, 1)
      if buildLevelTemplate ~= nil then
        self.build_icon:SetLocalPosition(IconPosition + buildLevelTemplate:GetIconDeltaPosition())
      else
        self.build_icon:SetLocalPosition(IconPosition)
      end
      self.resourceType = DataCenter.BuildManager:GetResourceTypeByBuildId(self.param.buildId)
      self.build_des:SetActive(true)
      self.build_des:SetLocalText(self.buildTemplate.des)
      self.time_text:SetLocalText(GameDialogDefine.TIME)
      self.uuid = 0
      local state = self.param.state
      if state == nil then
        state = DataCenter.BuildManager:GetBuildState(self.param.buildId)
      end
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local showRedDot = false
      if state == BuildState.BUILD_LIST_RECEIVED then
        local list = DataCenter.BuildManager:GetFoldUpBuildByBuildId(self.param.buildId)
        if list ~= nil and 0 < table.count(list) then
          local buildData
          for k, v in ipairs(list) do
            buildData = v
            break
          end
          if buildData ~= nil then
            self.uuid = buildData.uuid
          end
          showRedDot = DataCenter.BuildManager:IsShowRedDotByTemplateAndState(self.buildTemplate, BuildState.BUILD_LIST_RECEIVED)
          self:RefreshRedDot(showRedDot)
          self.build_detail:SetActive(false)
          self.reason_bg_value:SetActive(false)
          self.buildCondition_group:SetActive(true)
          self.build_bg:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_tanchuang_lan_bg"))
          self.canBuild = true
          self.costItem:SetActive(false)
          self.need_resource1:SetActive(false)
          self.need_resource2:SetActive(false)
          self.isDrag = true
          self.time_value:SetLocalText(GameDialogDefine.SEC, 0)
          self.own_text:SetLocalText(GameDialogDefine.CAN_PUT)
          self.own_text:SetColor(OwnTextPickColor)
          self.own_num:SetText(table.count(list))
          self.build_icon:SetColor(WhiteColor)
          self.build_bg:SetColor(WhiteColor)
          self.lock_go:SetActive(false)
          if self.buildTemplate.tab_type == UIBuildListTabType.SeasonBuild then
            local str = ""
            local allianceCenterId = tonumber(self.buildTemplate.para1)
            local allianceCenterData = DataCenter.AllianceMineManager:GetAllianceCenterDataByBuildId(allianceCenterId)
            if allianceCenterData ~= nil then
              local canPlace = DataCenter.AllianceMineManager:IsPointInAllianceCenterRange(self.view.pointId, allianceCenterId)
              if canPlace == false then
                local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(allianceCenterId)
                if template ~= nil then
                  local name = template.name
                  str = Localization:GetString("season_tips007", Localization:GetString(name))
                  self.build_des:SetText(str)
                  self.own_text:SetText("")
                  self.own_num:SetText("")
                end
              end
            else
              local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(allianceCenterId)
              if template ~= nil then
                str = Localization:GetString("season_tips008", Localization:GetString(template.name))
                self.error_tips = str
                self.build_des:SetText(str)
                self.own_text:SetText("")
                self.own_num:SetText("")
                self.build_bg:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_tanchuang_hui_bg"))
              end
            end
          end
        end
      else
        showRedDot = DataCenter.BuildManager:IsShowRedDotByTemplateAndState(self.buildTemplate, state)
        self:RefreshRedDot(showRedDot)
        if state == BuildState.BUILD_LIST_REACH_MAX then
          self.build_icon:SetColor(BuildGrayColor)
          self.build_bg:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_tanchuang_hui_bg"))
          self.build_detail:SetActive(false)
          self.reason_bg_value:SetActive(true)
          self.buildCondition_group:SetActive(false)
          self.reason_bg_value:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_xiaohao_img_bg"))
          self.reason_value:SetLocalText(GameDialogDefine.THIS_BUILD_HAS_REACH_BUILD_MAX)
          self.isDrag = false
          self.lock_go:SetActive(false)
        else
          self.build_icon:SetMaterial(nil)
          local needCount = 0
          local needPeopleNum = self.buildTemplate:GetNeedPeopleNum()
          if 0 < needPeopleNum then
            needCount = needCount + 1
            local param = {}
            table.insert(self.showList, param)
            local need = needPeopleNum
            local resourceType = ResourceType.People
            param.icon = DataCenter.ResourceManager:GetResourceIconByType(resourceType)
            param.num = string.GetFormattedStr(need)
            param.needType = CommonCostNeedType.Resource
            param.itemId = resourceType
            param.need = need
            if need > LuaEntry.Resource:GetCntByResType(resourceType) then
              param.numColor = NoColor
              self.lackResource = resourceType
            else
              param.numColor = YesColor
            end
          end
          if self.buildTemplate.put ~= BuildPutType.Lv0 then
            local needResource = self.buildTemplate:GetNeedResource()
            local resourceCount = table.count(needResource)
            if 0 < resourceCount then
              needCount = needCount + resourceCount
              for k, v in ipairs(needResource) do
                local need = v.count
                local resourceType = v.resourceType
                local ownNum = LuaEntry.Resource:GetCntByResType(resourceType)
                local param = {}
                table.insert(self.showList, param)
                param.icon = DataCenter.ResourceManager:GetResourceIconByType(resourceType)
                param.num = string.GetFormattedStr(need)
                param.needType = CommonCostNeedType.Resource
                param.itemId = resourceType
                param.need = need
                if need <= ownNum then
                  param.numColor = YesColor
                  if self.lackResource == nil then
                    self.lackResource = resourceType
                  end
                else
                  param.numColor = NoColor
                end
              end
            end
            local needResourceItem = self.buildTemplate:GetNeedResourceItem()
            resourceCount = table.count(needResourceItem)
            if 0 < resourceCount then
              needCount = needCount + resourceCount
              for i, v in ipairs(needResourceItem) do
                local itemId = v.itemId
                local itemTemplate = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(itemId)
                local ownNum = DataCenter.ResourceItemDataManager:GetCountByItemId(itemId)
                local need = v.count
                local param = {}
                table.insert(self.showList, param)
                param.icon = string.format(LoadPath.ItemPath, itemTemplate.pic)
                param.num = string.GetFormattedStr(need)
                param.needType = CommonCostNeedType.ResourceItem
                param.itemId = itemId
                param.need = need
                if ownNum >= need then
                  param.numColor = YesColor
                else
                  param.numColor = NoColor
                end
              end
            end
            local needItem = self.buildTemplate:GetNeedItem()
            resourceCount = table.count(needItem)
            if 0 < resourceCount then
              needCount = needCount + resourceCount
              for i, v in ipairs(needItem) do
                local itemId = v.itemId
                local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
                local ownNum = DataCenter.ItemData:GetItemCount(itemId)
                local need = v.num
                local param = {}
                table.insert(self.showList, param)
                param.icon = string.format(LoadPath.ItemPath, itemTemplate.icon)
                param.num = string.GetFormattedStr(need)
                param.needType = CommonCostNeedType.Goods
                param.itemId = itemId
                param.need = need
                if ownNum >= need then
                  param.numColor = YesColor
                else
                  param.numColor = NoColor
                end
              end
            end
          end
          self:ShowResourceCell()
          self.isSeasonBuildLock = false
          if state == BuildState.BUILD_LIST_STATE_OK then
            self.isDrag = true
            if self.buildTemplate.tab_type == UIBuildListTabType.SeasonBuild then
              local str = ""
              local allianceCenterId = tonumber(self.buildTemplate.para1)
              local allianceCenterData = DataCenter.AllianceMineManager:GetAllianceCenterDataByBuildId(allianceCenterId)
              if allianceCenterData ~= nil then
                local canPlace = DataCenter.AllianceMineManager:IsPointInAllianceCenterRange(self.view.pointId, allianceCenterId)
                if canPlace == false then
                  local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(allianceCenterId)
                  if template ~= nil then
                    local name = template.name
                    str = Localization:GetString("season_tips007", Localization:GetString(name))
                    self.build_des:SetText(str)
                    self.own_text:SetText("")
                    self.own_num:SetText("")
                  end
                  self.isDrag = false
                end
              else
                local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(allianceCenterId)
                if template ~= nil then
                  str = Localization:GetString("season_tips008", Localization:GetString(template.name))
                  self.build_des:SetText(str)
                  self.error_tips = str
                end
                self.isSeasonBuildLock = true
                self.isDrag = false
              end
            end
          else
            self.isDrag = false
          end
          if state == BuildState.BUILD_LIST_STATE_OK or state == BuildState.BUILD_LIST_LACK_RESOURCE or state == BuildState.BUILD_LIST_STATE_NEED_BUY_ITEM or state == BuildState.BUILD_LIST_STATE_NEED_RESOURCE_ITEM or state == BuildState.BUILD_LIST_LACK_PEOPLE then
            self.build_icon:SetColor(WhiteColor)
            self.build_bg:SetColor(WhiteColor)
            self.build_detail:SetActive(false)
            self.reason_bg_value:SetActive(false)
            self.buildCondition_group:SetActive(true)
            local buildTime = self.buildTemplate:GetBuildTime()
            if 60000 < buildTime then
              self.time_value:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(buildTime))
            else
              self.time_value:SetLocalText(GameDialogDefine.SEC, math.ceil(buildTime / 1000))
            end
            self.own_text:SetLocalText(GameDialogDefine.HAS_BUILD)
            self.own_text:SetColor(OwnTextBuildColor)
            if self.isSeasonBuildLock then
              self.own_text:SetText("")
              self.own_num:SetText("")
              self.build_bg:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_tanchuang_hui_bg"))
            else
              local own = DataCenter.BuildManager:GetHaveBuildNumWithOutFoldUpByBuildId(self.param.buildId)
              local curMax = DataCenter.BuildManager:GetCurMaxBuildNum(self.param.buildId)
              self.own_num:SetLocalText(GameDialogDefine.SPLIT, own, curMax)
              self.own_text:SetText("")
              self.build_bg:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_tanchuang_lan_bg"))
              self.canBuild = true
            end
            self.lock_go:SetActive(false)
            if DataCenter.BuildManager:CanShowUnlock(self.param.buildId) then
              self.anim:Play("Unlock", 0, 0)
              DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Build_Unclock, false)
              DataCenter.BuildManager:SetBuildShowUnlock(self.param.buildId)
              self.reason_dummy_value:SetText("")
            end
          elseif state == BuildState.BUILD_LIST_PREBUILD then
            self.build_detail:SetActive(false)
            self.reason_bg_value:SetActive(true)
            self.reason_bg_value:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_xiaohao_img_bg"))
            self.buildCondition_group:SetActive(false)
            self.build_bg:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_tanchuang_lan_bg"))
            self.canBuild = true
            self.lock_go:SetActive(false)
            local building_prerequisites = self.buildTemplate.building_prerequisites
            if string.IsNullOrEmpty(building_prerequisites) then
              local preBuild = self.buildTemplate:GetPreBuild()
              if preBuild ~= nil then
                local strKey = GameDialogDefine.NEED_SOMETHING_REACH_SOMETHING
                for k, v in ipairs(preBuild) do
                  local buildId = v.buildId
                  local level = v.level
                  if not DataCenter.BuildManager:IsExistBuildByTypeLv(buildId, level) then
                    local baseXml = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
                    if baseXml ~= nil then
                      self.gotoUpgradeId = buildId
                      self.reason_value:SetText(Localization:GetString(strKey, Localization:GetString(baseXml.name), level))
                    end
                  end
                end
              end
            else
              local data_list = string.split(building_prerequisites, "|")
              local lack_info = {}
              self.gotoUpgradeId = nil
              for k, v in ipairs(data_list) do
                local tmp = string.split_ii_array(v, ";")
                if 2 <= #tmp and not DataCenter.BuildManager:IsExistBuildByTypeLv(tmp[1], tmp[2]) then
                  local baseXml = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(tmp[1])
                  if baseXml ~= nil then
                    if self.gotoUpgradeId == nil or DataCenter.BuildManager:HasBuilding(tmp[1]) then
                      self.gotoUpgradeId = tmp[1]
                    end
                    table.insert(lack_info, {
                      name = Localization:GetString(baseXml.name),
                      level = tmp[2]
                    })
                  end
                end
              end
              local lack_info_count = #lack_info
              if lack_info_count == 1 then
                local strKey = GameDialogDefine.NEED_SOMETHING_REACH_SOMETHING
                self.reason_value:SetText(Localization:GetString(strKey, lack_info[1].name, lack_info[1].level))
              elseif lack_info_count == 2 then
                self.reason_value:SetText(Localization:GetString("building_772000_condition_desc", lack_info[1].name, lack_info[1].level, lack_info[2].name, lack_info[2].level))
              end
            end
          elseif state == BuildState.BUILD_LIST_STATE_NEED_MONOPOLY then
            self.build_detail:SetActive(false)
            self.reason_bg_value:SetActive(true)
            self.reason_bg_value:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_xiaohao_img_bg"))
            self.buildCondition_group:SetActive(false)
            self.build_bg:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_tanchuang_hui_bg"))
            self.lock_go:SetActive(false)
            local mono_condition = DataCenter.MonopolyManager:GetPlacealityQuestOrder(tonumber(self.buildTemplate.mono_condition))
            self.reason_value:SetText(Localization:GetString(801155, mono_condition))
          elseif state == BuildState.BUILD_LIST_SCIENCE or state == BuildState.BUILD_LIST_SCIENCE_BUILD then
            self.build_icon:SetColor(BuildGrayColor)
            self.build_bg:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_tanchuang_hui_bg"))
            self.build_detail:SetActive(false)
            self.reason_bg_value:SetActive(true)
            self.reason_bg_value:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_xiaohao_img_bg"))
            self.buildCondition_group:SetActive(false)
            self.lock_go:SetActive(false)
            local needScience = self.buildTemplate:GetNeedScience()
            if needScience ~= nil then
              for k, v in ipairs(needScience) do
                local scienceId = v.scienceId
                local level = v.level
                if not DataCenter.ScienceManager:HasScienceByIdAndLevel(scienceId, level) then
                  local baseXml = DataCenter.ScienceTemplateManager:GetScienceTemplate(scienceId, level)
                  if baseXml ~= nil then
                    self.gotoUpgradeId = scienceId
                    self.reason_value:SetText(Localization:GetString(GameDialogDefine.NEED_RESEARCHING_SCIENCE, Localization:GetString(baseXml.name)))
                  end
                end
              end
            end
          elseif state == BuildState.BUILD_LIST_NEED_PARA3_SCIENCE then
            self.build_icon:SetColor(BuildGrayColor)
            self.build_bg:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_tanchuang_hui_bg"))
            self.build_detail:SetActive(false)
            self.reason_bg_value:SetActive(true)
            self.reason_bg_value:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_xiaohao_img_bg"))
            self.buildCondition_group:SetActive(false)
            self.lock_go:SetActive(false)
            local science = tonumber(self.buildTemplate.para3)
            local scienceId = CommonUtil.GetScienceBaseType(science)
            local level = CommonUtil.GetScienceLv(science)
            if not DataCenter.ScienceManager:HasScienceByIdAndLevel(scienceId, level) then
              local baseXml = DataCenter.ScienceTemplateManager:GetScienceTemplate(scienceId, level)
              if baseXml ~= nil then
                self.gotoUpgradeId = scienceId
                self.reason_value:SetText(Localization:GetString(GameDialogDefine.NEED_RESEARCHING_SCIENCE, Localization:GetString(baseXml.name)))
              end
            end
          elseif state == BuildState.BUILD_LIST_STATE_VIP_LEVEL then
            self.build_icon:SetColor(BuildGrayColor)
            self.build_bg:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_tanchuang_hui_bg"))
            self.build_detail:SetActive(false)
            self.reason_bg_value:SetActive(true)
            self.reason_bg_value:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_xiaohao_img_bg"))
            self.buildCondition_group:SetActive(false)
            self.lock_go:SetActive(false)
            self.reason_value:SetLocalText(320297, 6)
            self.gotoLevel = tonumber(self.param.buildTemplate.unlock_player_level)
          elseif state == BuildState.BUILD_LIST_STATE_NEED_ITEM_FORM_GIFT then
            self.build_icon:SetColor(BuildGrayColor)
            self.build_bg:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_tanchuang_hui_bg"))
            self.build_detail:SetActive(false)
            self.reason_bg_value:SetActive(true)
            self.reason_bg_value:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_xiaohao_img_bg"))
            self.buildCondition_group:SetActive(false)
            self.lock_go:SetActive(false)
            self.reason_value:SetLocalText(320007)
          elseif state == BuildState.BUILD_LIST_REACH_CUR_MAX then
            self.build_icon:SetColor(BuildGrayColor)
            self.build_bg:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_tanchuang_hui_bg"))
            self.build_detail:SetActive(false)
            self.reason_bg_value:SetActive(true)
            self.reason_bg_value:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_xiaohao_img_bg"))
            self.buildCondition_group:SetActive(false)
            self.lock_go:SetActive(false)
            local unlockInfo = self.buildTemplate:GetCurNoBuildUnlockBuildInfo()
            if unlockInfo ~= nil and 0 < unlockInfo.canBuildNun then
              local expNum = DataCenter.BuildManager:GetExtraCanBuildNum(self.buildId)
              local baseXml = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(unlockInfo.buildId)
              if baseXml ~= nil then
                self.gotoUpgradeId = unlockInfo.buildId
                if 1 < unlockInfo.canBuildNun then
                  self.reason_value:SetText(Localization:GetString(GameDialogDefine.THEN_SOMETHING_REACH_SOMETHING_CAN_BUILD_SOMETHING, Localization:GetString(baseXml.name), unlockInfo.level, unlockInfo.canBuildNun + expNum))
                else
                  self.reason_value:SetText(Localization:GetString(GameDialogDefine.NEED_SOMETHING_REACH_SOMETHING, Localization:GetString(baseXml.name), unlockInfo.level))
                end
              end
            end
          elseif state == BuildState.BUILD_LIST_NEED_GUIDE then
            self.build_icon:SetColor(BuildGrayColor)
            self.build_bg:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_tanchuang_hui_bg"))
            self.build_detail:SetActive(false)
            self.reason_bg_value:SetActive(true)
            self.reason_bg_value:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_xiaohao_img_bg"))
            self.buildCondition_group:SetActive(false)
            self.lock_go:SetActive(false)
            self.reason_value:SetLocalText(GameDialogDefine.NEED_FINISH_MORE_QUEST_TO_UNLOCK_BUILD)
          elseif state == BuildState.BUILD_LIST_NEED_QUEST then
            self.build_icon:SetColor(BuildGrayColor)
            self.build_bg:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_tanchuang_hui_bg"))
            self.build_detail:SetActive(false)
            self.reason_bg_value:SetActive(true)
            self.reason_bg_value:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_xiaohao_img_bg"))
            self.buildCondition_group:SetActive(false)
            self.lock_go:SetActive(false)
            self.reason_value:SetLocalText(GameDialogDefine.NEED_FINISH_MORE_QUEST_TO_UNLOCK_BUILD)
          elseif state == BuildState.BUILD_LIST_NEED_CHAPTER then
            self.build_icon:SetColor(BuildGrayColor)
            self.build_bg:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_tanchuang_hui_bg"))
            self.build_detail:SetActive(false)
            self.reason_bg_value:SetActive(true)
            self.reason_bg_value:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_xiaohao_img_bg"))
            self.buildCondition_group:SetActive(false)
            self.lock_go:SetActive(false)
            self.reason_value:SetLocalText(GameDialogDefine.NEED_FINISH_CHAPTER_TO_UNLOCK_BUILD)
          elseif state == BuildState.BUILD_LIST_STATE_NEED_BUY_MONTH then
            self.gotoUpgradeId = self.buildTemplate.month_card
            self.build_icon:SetColor(BuildGrayColor)
            self.build_bg:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_tanchuang_hui_bg"))
            self.build_detail:SetActive(false)
            self.reason_bg_value:SetActive(true)
            self.reason_bg_value:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_xiaohao_img_bg"))
            self.buildCondition_group:SetActive(false)
            self.lock_go:SetActive(false)
            self.reason_value:SetLocalText(GameDialogDefine.NEED_BUY_MONTH_CARD)
          elseif state == BuildState.BUILD_LIST_NEED_BUY_WEEKCARD_SEASON then
            self.build_icon:SetColor(BuildGrayColor)
            self.build_bg:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_tanchuang_hui_bg"))
            self.build_detail:SetActive(false)
            self.reason_bg_value:SetActive(true)
            self.reason_bg_value:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_xiaohao_img_bg"))
            self.buildCondition_group:SetActive(false)
            self.lock_go:SetActive(false)
            self.reason_value:SetLocalText("season_week_card_001")
          elseif state == BuildState.BUILD_LIST_STATE_NEED_LEVEL then
            self.build_icon:SetColor(BuildGrayColor)
            self.build_bg:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_tanchuang_hui_bg"))
            self.build_detail:SetActive(false)
            self.reason_bg_value:SetActive(true)
            self.reason_bg_value:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_xiaohao_img_bg"))
            self.buildCondition_group:SetActive(false)
            self.lock_go:SetActive(false)
            self.reason_value:SetLocalText(120986, self.param.buildTemplate.unlock_player_level)
            self.gotoLevel = tonumber(self.param.buildTemplate.unlock_player_level)
          elseif state == BuildState.BUILD_LIST_NEED_UNLOCK_TILE then
            self.build_icon:SetColor(BuildGrayColor)
            self.build_bg:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_tanchuang_hui_bg"))
            self.build_detail:SetActive(false)
            self.reason_bg_value:SetActive(true)
            self.reason_bg_value:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_xiaohao_img_bg"))
            self.buildCondition_group:SetActive(false)
            self.lock_go:SetActive(false)
            self.reason_value:SetLocalText(GameDialogDefine.NEED_CLEAR_TILE)
            if self.param.buildTemplate.need_pve ~= 0 then
              self.gotoUpgradeId = self.param.buildTemplate.need_pve
            end
          elseif state == BuildState.BUILD_LIST_NEED_UNLOCK_TALENT then
            self.build_icon:SetColor(BuildGrayColor)
            self.build_bg:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_tanchuang_hui_bg"))
            self.build_detail:SetActive(false)
            self.reason_bg_value:SetActive(true)
            self.reason_bg_value:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_xiaohao_img_bg"))
            self.buildCondition_group:SetActive(false)
            self.lock_go:SetActive(false)
            local template = DataCenter.TalentTemplateManager:GetTemplate(toInt(self.buildTemplate.need_talent))
            if template ~= nil then
              local nameStr = Localization:GetString("300665", template.lv) .. " " .. template.name
              self.reason_value:SetLocalText(131006, nameStr)
            end
          elseif state == BuildState.BUILD_LIST_NEED_ALLIANCE_CITY_BUILD then
            self.build_icon:SetColor(BuildGrayColor)
            self.build_bg:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_tanchuang_hui_bg"))
            self.build_detail:SetActive(false)
            self.buildCondition_group:SetActive(false)
            self.reason_bg_value:SetActive(true)
            self.reason_bg_value:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_xiaohao_img_bg"))
            self.reason_value:SetColor(LackBuildColor)
            self.lock_go:SetActive(true)
            self.reason_value:SetLocalText(GameDialogDefine.NEED_OWN_ONE_LEVEL_ALLIANCE_CITY, self.buildTemplate.need_ruin)
          elseif state == BuildState.BUILD_LIST_SCIENCE_SEASON then
            self.build_icon:SetColor(BuildGrayColor)
            self.build_detail:SetActive(false)
            self.buildCondition_group:SetActive(false)
            self.reason_bg_value:SetActive(true)
            self.reason_bg_value:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_xiaohao_img_bg"))
            self.reason_value:SetColor(LackBuildColor)
            self.build_bg:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_tanchuang_hui_bg"))
            self.lock_go:SetActive(true)
            local str = ""
            local effectCondition = self.buildTemplate.effectCondition
            if effectCondition and effectCondition.effectId then
              local effectName = GetTableData(TableName.LW_Effect_Number, effectCondition.effectId, "name")
              str = Localization:GetString("season_alliance_building_condition_tips001") .. Localization:GetString(effectName)
            end
            self.reason_value:SetText(str)
          elseif state == BuildState.BUILD_LIST_INSUFFICIENT_EFFECT_CONDITION then
            self.build_icon:SetColor(BuildGrayColor)
            self.build_detail:SetActive(false)
            self.buildCondition_group:SetActive(false)
            self.reason_bg_value:SetActive(true)
            self.reason_bg_value:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_xiaohao_img_bg"))
            self.reason_value:SetColor(LackBuildColor)
            self.build_bg:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_tanchuang_hui_bg"))
            self.lock_go:SetActive(true)
            local str = ""
            local effectCondition = self.buildTemplate.effectCondition
            if effectCondition and effectCondition.effectId then
              str = Localization:GetString("season_tips223")
            end
            self.reason_value:SetText(str)
          elseif state == BuildState.BUILD_LIST_NEED_ALLIANCE_CENTER_FOR_BUILD then
            self.build_icon:SetColor(BuildGrayColor)
            self.build_detail:SetActive(false)
            self.buildCondition_group:SetActive(false)
            self.reason_bg_value:SetActive(true)
            self.reason_bg_value:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_xiaohao_img_bg"))
            self.reason_value:SetColor(LackBuildColor)
            self.build_bg:LoadSprite(string.format(LoadPath.UILWBuild, "chengjian_lzh_tanchuang_hui_bg"))
            self.lock_go:SetActive(true)
            local str = ""
            local allianceCenterId = tonumber(self.buildTemplate.para1)
            local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(allianceCenterId)
            if template ~= nil then
              local name = template.name
              str = Localization:GetString("season_tips008", Localization:GetString(name))
            end
            self.reason_value:SetText(str)
          elseif state == BuildState.BUILD_LIST_NEED_ALLIANCE_CENTER_FOR_REPLACE then
            self.build_icon:SetColor(BuildGrayColor)
            self.build_detail:SetActive(false)
            self.reason_bg_value:SetActive(true)
            self.reason_bg_value:LoadSprite(string.format(LoadPath.UILWBuild, "UIBuild_bg_tips"))
            self.reason_value:SetColor(LackBuildColor)
            self.build_bg:LoadSprite(string.format(LoadPath.UILWBuild, "UIBuild_btn_yellow_disable"))
            self.lock_go:SetActive(true)
            local str = ""
            local allianceCenterId = tonumber(self.buildTemplate.para1)
            local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(allianceCenterId)
            if template ~= nil then
              local name = template.name
              str = Localization:GetString("season_tips007", Localization:GetString(name))
            end
            self.reason_value:SetText(str)
          elseif state == BuildState.BUILD_LIST_NEED_MASTERY then
            self.build_icon:SetColor(BuildGrayColor)
            self.build_detail:SetActive(false)
            self.reason_bg_value:SetActive(true)
            self.reason_bg_value:LoadSprite(string.format(LoadPath.UILWBuild, "UIBuild_bg_tips"))
            self.reason_value:SetColor(LackBuildColor)
            self.build_bg:LoadSprite(string.format(LoadPath.UILWBuild, "UIBuild_btn_yellow_disable"))
            self.lock_go:SetActive(true)
            local desc = DataCenter.MasteryManager:GetBuildNeedDesc(self.param.buildId)
            self.reason_value:SetText(Localization:GetString("110730", desc))
          elseif state == BuildState.BUILD_LIST_NEED_DIRECTION then
            self.build_icon:SetColor(BuildGrayColor)
            self.build_detail:SetActive(false)
            self.reason_bg_value:SetActive(true)
            self.reason_bg_value:LoadSprite(string.format(LoadPath.UILWBuild, "UIBuild_bg_tips"))
            self.reason_value:SetColor(LackBuildColor)
            self.build_bg:LoadSprite(string.format(LoadPath.UILWBuild, "UIBuild_btn_yellow_disable"))
            self.lock_go:SetActive(true)
            local template = DataCenter.BuildingDirectionTemplateManager:GetTemplate(self.buildTemplate.need_direction)
            if template ~= nil then
              self.reason_value:SetLocalText(GameDialogDefine.BUILD_NEED_SELECT_DIRECTION_WITH, Localization:GetString(template.name))
            end
          end
        end
      end
      self.build_name:SetLocalText(self.buildTemplate.name)
      self.build_icon:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(self.param.buildId, 1), DefaultImage)
      self.build_dummy_icon:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(self.param.buildId, 1), DefaultImage)
      if showRedDot == true then
        DataCenter.BuildManager:SetBuildRedDotOnce(self.param.buildId)
      end
    end
  elseif self.param.buildType == UIBuildListBuildType.Decorate then
    self.build_icon:SetActive(true)
    self.build_detail_icon:SetActive(false)
    self.buildTemplate = self.param.buildTemplate
    self.robot_obj:SetActive(false)
    self.build_name:SetLocalText(self.buildTemplate.name)
    local itemId = self.param.buildId // BuildLevelCap * BuildLevelCap
    self.build_icon:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(itemId, 1), DefaultImage)
    self.build_dummy_icon:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(itemId, 1), DefaultImage)
    self:RefreshRedDot(false)
    self.costItem:SetActive(false)
    self.need_resource1:SetActive(false)
    self.need_resource2:SetActive(false)
  end
  self:PlayTabAnim()
end

function UIBuildListCell:PlayTabAnim()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if self.index == nil then
    return
  end
  if self.isTabClick and self.allAnimNum and self.index <= self.allAnimNum and (not (self.param.buildType ~= UIBuildListBuildType.Decorate or self.isBuiltMax) or self.canBuild) then
    self:DoEnterAnimDefault()
  end
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    if self and self.isTabClick and self.allAnimNum and self.index <= self.allAnimNum then
      self:DoTabAnim()
    end
    self.isTabClick = false
  end, 0.1 * (self.index - 1))
end

function UIBuildListCell:DoTabAnim()
  if self and self.anim and self.param then
    if self.param.buildType == UIBuildListBuildType.Decorate and not self.isBuiltMax then
      self.anim:Play("CellChangeNew_Decorate", 0, 0)
    elseif self.canBuild then
      self.anim:Play("CellChangeNew_Build", 0, 0)
    else
      self.anim:Play("CellChangeNormal", 0, 0)
    end
  end
end

local function OnSelectBtnClick(self)
  if self.error_tips then
    UIUtil.ShowTips(self.error_tips)
    return
  end
  if self.unlockData and self.unlockData.type == BuildQueueUnlockType.Mastery and not self:IsMasteryRobotUnlocked() then
    self:OnUnlockBtnClick()
    return
  end
  if not self.isStartDray then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Build_SelectCard, false)
    if self.param.buildType == UIBuildListBuildType.Build or self.param.buildType == UIBuildListBuildType.Decorate then
      self:ShowGreen()
      self:OnDragOff()
    else
      self:OnDragOff()
    end
  end
end

local function GetTouchPositionY(self)
  return 435.0 * UIManager:GetInstance():GetScaleFactor()
end

local function OnBeginDrag(self, eventData)
  self.isStartDray = true
  if self.param.buildType == UIBuildListBuildType.Build then
    self:ShowGreen()
  end
  if self.param.scrollView ~= nil then
    self.param.scrollView:OnBeginDrag(eventData)
  end
end

local function OnEndDrag(self, eventData)
  self.isStartDray = false
  if self.param.buildType == UIBuildListBuildType.Build then
    self:ShowGreen()
  end
  if self.param.scrollView ~= nil then
    self.param.scrollView:OnEndDrag(eventData)
  end
end

local function OnDrag(self, eventData)
  if self.param.scrollView ~= nil then
    self.param.scrollView:OnDrag(eventData)
  end
  if eventData.position.y > self.touchPositionY then
    self:OnDragOff(SceneUtils.WorldToTileIndex(CS.SceneManager.World:GetTouchPoint()))
  end
end

local function GetLackByType(self, needType)
  local result = {}
  for k, v in pairs(self.showList) do
    if v.needType == needType and v.numColor == NoColor then
      local param = {}
      if v.needType == CommonCostNeedType.Resource then
        param.type = ResLackType.Res
        param.resType = v.itemId
      elseif v.needType == CommonCostNeedType.ResourceItem then
        param.type = ResLackType.ResItem
        param.itemId = v.itemId
      end
      param.targetNum = v.need
      param.need = v.need
      table.insert(result, param)
    end
  end
  return result
end

local function OnDragOff(self, point)
  self.view:HideRobotFreeView()
  if self.param.buildType == UIBuildListBuildType.BuildRoad or self.param.buildType == UIBuildListBuildType.Decorate then
    if DataCenter.GuideManager:InGuide() or DataCenter.GuideManager:IsCanBuildRoad() then
      if self.lackResource then
        GoToResLack.GoToItemResLackList(self:GetLackByType(CommonCostNeedType.Resource))
      elseif self.isDrag then
        if not self.isInBuild then
          self.isInBuild = true
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlaceRoad, {anim = false}, PlaceRoadState.Build)
          self.view.ctrl:CloseSelf(false)
        end
      else
        UIUtil.ShowTipsId(GameDialogDefine.ROAD_REACH_BUILD_MAX)
      end
    else
      UIUtil.ShowTipsId(GameDialogDefine.LOCK_BUILD_ROAD_TIP)
    end
  elseif self.param.buildType == UIBuildListBuildType.RemoveRoad then
    if DataCenter.GuideManager:InGuide() or DataCenter.GuideManager:IsCanBuildRoad() then
      if self.lackResource then
        GoToResLack.GoToItemResLackList(self:GetLackByType(CommonCostNeedType.Resource))
      elseif not self.isInBuild then
        self.isInBuild = true
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlaceRoad, {anim = false}, PlaceRoadState.Remove)
        self.view.ctrl:CloseSelf(false)
      end
    else
      UIUtil.ShowTipsId(GameDialogDefine.LOCK_BUILD_ROAD_TIP)
    end
  elseif self.param.buildType == UIBuildListBuildType.Build then
    local state = DataCenter.BuildManager:GetBuildState(self.param.buildId)
    if state == BuildState.BUILD_LIST_STATE_OK or state == BuildState.BUILD_LIST_RECEIVED then
      self.isDrag = true
    else
      self.isDrag = false
    end
    if not self.isDrag then
      if state == BuildState.BUILD_LIST_LACK_RESOURCE then
        local lack = self:GetLackByType(CommonCostNeedType.Resource)
        LWResourceLackUtil:GotoResLack(lack)
      elseif state == BuildState.BUILD_LIST_LACK_PEOPLE then
        local resNeed = self:GetLackByType(CommonCostNeedType.Resource)
        local resNeeds = self:GetLackByType(CommonCostNeedType.ResourceItem)
        local arr = table.mergeArray(resNeed, resNeeds)
        GoToResLack.GoToItemResLackList(arr)
      elseif state == BuildState.BUILD_LIST_STATE_NEED_RESOURCE_ITEM then
        GoToResLack.GoToItemResLackList(self:GetLackByType(CommonCostNeedType.ResourceItem))
      elseif state == BuildState.BUILD_LIST_PREBUILD or state == BuildState.BUILD_LIST_REACH_CUR_MAX then
        if DataCenter.BuildManager:HasBuilding(self.gotoUpgradeId) then
          GoToUtil.GotoCityByBuildId(self.gotoUpgradeId, WorldTileBtnType.City_Upgrade)
        else
          EventManager:GetInstance():Broadcast(EventId.GOTO_BUILD, {
            buildId = self.gotoUpgradeId
          })
        end
      elseif state == BuildState.BUILD_LIST_STATE_NEED_MONOPOLY then
        GoToUtil.CloseAllWindows()
        GoToUtil.GotoCurrMonopolyCell()
      elseif state == BuildState.BUILD_LIST_SCIENCE or state == BuildState.BUILD_LIST_SCIENCE_BUILD or state == BuildState.BUILD_LIST_NEED_PARA3_SCIENCE then
        local scienceId = self.gotoUpgradeId
        GoToUtil.CloseAllWindows()
        GoToUtil.GotoScience(scienceId)
      elseif state == BuildState.BUILD_LIST_STATE_NEED_BUY_MONTH then
        if not WelfareController.HasShowTag() then
          UIUtil.ShowTipsId(GameDialogDefine.FUNCTION_NO_USE)
        else
          GoToUtil.CloseAllWindows()
          GoToUtil.GoToMonthCard(self.gotoUpgradeId)
        end
      elseif state == BuildState.BUILD_LIST_NEED_BUY_WEEKCARD_SEASON then
        GoToUtil.GotoSeasonWeekCardView()
      elseif state == BuildState.BUILD_LIST_STATE_NEED_LEVEL then
        GoToUtil.GoToPlayerLevel(self.gotoLevel)
      elseif state == BuildState.BUILD_LIST_STATE_VIP_LEVEL then
        local mgr = DataCenter.LWFunctionUnlockManager
        local unlock = mgr:CheckCanShow(LWFunctionUnlockType.MainUI_VIP)
        if unlock then
          GoToUtil.CloseAllWindows()
          GoToUtil.GotoOpenView(UIWindowNames.UIVip, 6)
        else
          UIUtil.ShowTips(Localization:GetString("320269", k3))
        end
      elseif state == BuildState.BUILD_LIST_NEED_UNLOCK_TILE then
        GoToUtil.CloseAllWindows()
        GoToUtil.GoLandLockById(self.gotoUpgradeId)
      elseif state == BuildState.BUILD_LIST_NEED_GUIDE then
        UIUtil.ShowTipsId(GameDialogDefine.NEED_FINISH_MORE_QUEST_TO_UNLOCK_BUILD)
      elseif state == BuildState.BUILD_LIST_NEED_QUEST then
        UIUtil.ShowTipsId(GameDialogDefine.NEED_FINISH_MORE_QUEST_TO_UNLOCK_BUILD)
      elseif state == BuildState.BUILD_LIST_NEED_CHAPTER then
        UIUtil.ShowTipsId(GameDialogDefine.NEED_FINISH_CHAPTER_TO_UNLOCK_BUILD_TIP)
      elseif state == BuildState.BUILD_LIST_NEED_ALLIANCE_CITY_BUILD then
        local allianceCenterId = toInt(self.buildTemplate.para1)
        local allianceCenterData = DataCenter.AllianceMineManager:GetAllianceCenterDataByBuildId(allianceCenterId)
        if allianceCenterData ~= nil then
          if allianceCenterData.status == AllianceMineStatus.Build then
            UIUtil.ShowTipsId("season_tips109")
          end
        else
          local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(allianceCenterId)
          if template ~= nil then
            self.error_tips = Localization:GetString("season_tips008", Localization:GetString(template.name))
            UIUtil.ShowTips(self.error_tips)
          end
        end
      elseif state == BuildState.BUILD_LIST_SCIENCE_SEASON then
        local effectCondition = self.buildTemplate.effectCondition
        if effectCondition and effectCondition.effectId then
          local effectId = effectCondition.effectId
          local effectName = GetTableData(TableName.LW_Effect_Number, effectId, "name")
          UIUtil.ShowTips(Localization:GetString("454101", Localization:GetString(effectName)))
          local tmp = DataCenter.AllianceScienceTemplateManager:GetAlScienceTemplateByBuffId(effectId)
          if tmp and tmp.science_id then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceScience, {anim = true, hideTop = true}, {
              autoOpenRecScience = false,
              openScienceId = toInt(tmp.science_id)
            })
          end
        end
        self.view.ctrl:CloseSelf()
      elseif state == BuildState.BUILD_LIST_NEED_ALLIANCE_CENTER_FOR_BUILD then
        local allianceCenterId = toInt(self.buildTemplate.para1)
        local allianceCenterData = DataCenter.AllianceMineManager:GetAllianceCenterDataByBuildId(allianceCenterId)
        if allianceCenterData ~= nil then
          if allianceCenterData.status == AllianceMineStatus.Build then
            UIUtil.ShowTipsId("season_tips109")
          end
        else
          local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(allianceCenterId)
          if template ~= nil then
            local error_tips = Localization:GetString("season_tips008", Localization:GetString(template.name))
            UIUtil.ShowTips(error_tips)
          end
          UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonCity)
        end
        self.view.ctrl:CloseSelf()
      elseif state == BuildState.BUILD_LIST_NEED_ALLIANCE_CENTER_FOR_REPLACE then
        local str = ""
        local allianceCenterId = tonumber(self.buildTemplate.para1)
        local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(allianceCenterId)
        if template ~= nil then
          local name = template.name
          str = Localization:GetString("season_tips007", Localization:GetString(name))
        end
        UIUtil.ShowTips(str)
      elseif state == BuildState.BUILD_LIST_NEED_MASTERY then
        for _, masteryId in ipairs(self.buildTemplate.needMasteryList) do
          if not DataCenter.MasteryManager:HasLearntMastery(masteryId) then
            local template = DataCenter.MasteryManager:GetTemplateById(masteryId)
            if template then
              self.view.ctrl:CloseSelf()
              GoToUtil.CloseAllWindows()
              DataCenter.MasteryManager:ShowHome(template.home, template.group)
              break
            end
          end
        end
      elseif state == BuildState.BUILD_LIST_INSUFFICIENT_EFFECT_CONDITION then
        local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.param.buildId)
        if buildTemplate then
          GoToUtil.GotoEffectLack(buildTemplate.effect_condition)
        end
      else
        local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(self.param.buildId)
        if list ~= nil then
          for k, v in pairs(list) do
            if self.view.tabType == UIBuildListTabType.SeasonBuild or self.view.tabType == UIBuildListTabType.EdenSubway then
              GoToUtil.MoveToWorldPoint(v.pointId, SceneManagerSceneID.World)
              break
            end
            GoToUtil.MoveToWorldPoint(v.pointId, SceneManagerSceneID.City)
            break
          end
        end
      end
      return
    end
    if not self.isInBuild then
      if self.view.tabType == UIBuildListTabType.SeasonBuild or self.param.buildId == BuildingTypes.SEASON_CAREER_BUILD then
        local effectCondition = self.buildTemplate.effectCondition
        if effectCondition and effectCondition.effectId then
          local effectId = effectCondition.effectId
          local effectValue = LuaEntry.Effect:GetGameEffect(effectId)
          local effectName = GetTableData(TableName.LW_Effect_Number, effectId, "name")
          if effectValue == nil or effectValue == 0 then
            local str1 = Localization:GetString("season_alliance_building_condition_tips001")
            UIUtil.ShowTips(str1 .. Localization:GetString(effectName))
            return
          end
        end
        point = self.view.pointId
        if self.buildTemplate ~= nil and self.buildTemplate.tab_type == UIBuildListTabType.SeasonBuild then
          local allianceCenterId = tonumber(self.buildTemplate.para1)
          local allianceCenterData = DataCenter.AllianceMineManager:GetAllianceCenterDataByBuildId(allianceCenterId)
          if allianceCenterData ~= nil then
            if allianceCenterData.status == AllianceMineStatus.Build then
              UIUtil.ShowTipsId("season_tips109")
              return
            end
            local canPlace = DataCenter.AllianceMineManager:IsPointInAllianceCenterRange(point, allianceCenterId)
            if canPlace == false then
              point = allianceCenterData.pointId
              local tmpPointId = Setting:GetPrivateInt("UIBuildListSeasonBuild", 0)
              if tmpPointId and tmpPointId ~= 0 then
                point = tmpPointId
              else
                point = SceneUtils.WorldToTileIndex(CS.SceneManager.World.CurTarget)
              end
            end
          else
            local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(allianceCenterId)
            if template ~= nil then
              self.error_tips = Localization:GetString("season_tips008", Localization:GetString(template.name))
              UIUtil.ShowTips(self.error_tips)
            end
            return
          end
        end
      end
      if point == nil or point == 0 then
        point = BuildingUtils.GetPointByBuildCanPut(self.param.buildId, SceneUtils.WorldToTileIndex(CS.SceneManager.World.CurTarget))
      end
      local uuid = self.uuid
      local buildId = self.param.buildId
      local curPoint = point
      self.view:SetCancelRedGreen(false)
      self.isInBuild = true
      if uuid ~= 0 then
        GoToUtil.CloseAllWindows()
        BuildingUtils.ShowPutBuild(buildId, PlaceBuildType.Replace, uuid, curPoint, nil, UIWindowNames.UIBuildList)
      else
        GoToUtil.CloseAllWindows()
        BuildingUtils.ShowPutBuild(buildId, PlaceBuildType.Build, 0, curPoint, nil, UIWindowNames.UIBuildList)
      end
    end
  end
end

local function ShowGreen(self)
end

local function RefreshResource(self)
  self.lackResource = nil
  self:RefreshResourceCell()
end

local function DoEnterAnim(self)
  if self.param.isDelay then
    self:DelayComponentDefine()
    self:InitData()
  end
  if self.isTabClick then
    return
  end
  if self.param.buildType == UIBuildListBuildType.Decorate and not self.isBuiltMax then
    self.anim:Play("CellChangeNew_Decorate", 0, 0)
  elseif self.canBuild then
    self.anim:Play("CellChangeNew_Build", 0, 0)
  else
    self.anim:Play("CellChange", 0, 0)
  end
end

local function DoEnterAnimDefault(self)
  self.anim:Play("CellChangeDefault", 0, 0)
end

local function RefreshRedDot(self, isShow)
  self.red_dot:SetActive(isShow)
end

local function UpdateSlider(self)
  if self.isUpdate ~= nil and self.isUpdate then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local changeTime = self.endTime - curTime
    local maxTime = self.endTime - self.startTime
    if 0 < changeTime then
      local tempTimeSec = math.ceil(changeTime / 1000)
      if tempTimeSec ~= self.laseTime then
        self.laseTime = tempTimeSec
        local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(changeTime)
        if self.param.buildType == UIBuildListBuildType.Build then
          self.reason_value:SetText(tempTimeValue .. Localization:GetString(GameDialogDefine.DESTROY_CITY_COLD_TIP))
        end
      end
      if 0 < maxTime then
        local tempValue = 1 - changeTime / maxTime
        if TimeBarUtil.CheckIsNeedChangeBar(changeTime, self.endTime - self.lastCurTime, maxTime, SliderLength) then
          self.lastCurTime = curTime
          self.queue_slider_img:SetFillAmount(tempValue)
        end
      end
    else
      self.isUpdate = false
    end
  end
end

local function OnGotoBtnClick(self)
  local queueIndex = self.param.buildId
  local data = DataCenter.BuildQueueManager:GetQueueDataByIndex(queueIndex)
  if data ~= nil then
    if self.isUpdate then
      if data.state == RobotState.BUILD then
        local bUuid = data.occupyUuid
        if bUuid ~= nil and bUuid ~= 0 then
          if self.isUseFreeTime then
            SFSNetwork.SendMessage(MsgDefines.BuildCcdMNew, {
              bUUID = bUuid,
              itemIDs = "",
              isFixRuins = false
            })
            UIUtil.ShowTipsId(110249)
          else
            UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed, {anim = true}, ItemSpdMenu.ItemSpdMenu_City, bUuid)
          end
        end
      elseif data.state == RobotState.SCIENCE then
        local bUuid = data.occupyUuid
        if bUuid ~= nil and bUuid ~= 0 then
          local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(bUuid)
          if queue ~= nil and queue:GetQueueState() == NewQueueState.Work then
            if self.isUseFreeTime then
              SFSNetwork.SendMessage(MsgDefines.QueueCcdMNew, {
                qUUID = queue.uuid,
                itemIDs = "",
                isGold = IsGold.NoUseGold
              })
              UIUtil.ShowTipsId(110249)
            else
              UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed, {anim = true}, ItemSpdMenu.ItemSpdMenu_Science, queue.uuid)
            end
          end
        end
      end
    elseif data.state == RobotState.BUILD then
      local bUuid = data.occupyUuid
      if bUuid ~= nil and bUuid ~= 0 then
        DataCenter.BuildManager:CheckSendBuildFinish(bUuid)
      end
    end
  end
end

local function OnUnlockBtnClick(self)
  if self.unlockData ~= nil then
    if self.unlockData.type == BuildQueueUnlockType.Gift then
      local packId = self.unlockData.giftId
      local pack = GiftPackageData.get(tostring(packId))
      if pack ~= nil then
        local rechargeId = pack:getRechargeLineData(packId).id
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackage, {anim = true}, {
          welfareTagType = WelfareTagType.RobotPack,
          curRechargeId = rechargeId
        })
      else
        local needBuildId = self.unlockData.preBuildId
        local needBuildData = DataCenter.BuildManager:GetFunbuildByItemID(needBuildId)
        if needBuildData ~= nil or self.unlockData.needUnLockItemId ~= nil and self.unlockData.needUnLockItemId ~= "" and DataCenter.ItemData:GetItemCount(self.unlockData.needUnLockItemId) > 0 then
          local buildId = self.unlockData.preBuildId
          if 0 < buildId then
            if DataCenter.BuildManager:HasBuilding(buildId) then
              GoToUtil.GotoCityByBuildId(buildId, WorldTileBtnType.City_Upgrade)
            else
              EventManager:GetInstance():Broadcast(EventId.GOTO_BUILD, {buildId = buildId, showArrow = true})
            end
          end
        end
      end
    elseif self.unlockData.type == BuildQueueUnlockType.Talent then
      DataCenter.TalentDataManager:SetSpecialShowTalent(self.unlockData.talentId)
      GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_MAIN, WorldTileBtnType.Talent)
    elseif self.unlockData.type == BuildQueueUnlockType.Mastery then
      if not DataCenter.MasteryManager:HasLearntMastery(self.unlockData.masteryId) then
        local template = DataCenter.MasteryManager:GetTemplateById(self.unlockData.masteryId)
        if template then
          DataCenter.MasteryManager:ShowHome(template.home, template.group)
        end
      else
        local buildId = self.unlockData.preBuildId
        if 0 < buildId then
          if DataCenter.BuildManager:HasBuilding(buildId) then
            GoToUtil.GotoCityByBuildId(buildId, WorldTileBtnType.City_Upgrade)
          else
            EventManager:GetInstance():Broadcast(EventId.GOTO_BUILD, {buildId = buildId, showArrow = true})
          end
        end
      end
    elseif self.unlockData.type == BuildQueueUnlockType.Build then
      local buildId = self.unlockData.preBuildId
      if 0 < buildId then
        if DataCenter.BuildManager:HasBuilding(buildId) then
          GoToUtil.GotoCityByBuildId(buildId, WorldTileBtnType.City_Upgrade)
        else
          EventManager:GetInstance():Broadcast(EventId.GOTO_BUILD, {buildId = buildId})
        end
      end
    end
  end
end

local function OnBuildBtnClick(self)
  local willParam = DataCenter.BuildQueueManager:GetWillUpgradeParam()
  if willParam ~= nil then
    if willParam.enterType == UIBuildQueueEnterType.Build then
      local state = DataCenter.BuildManager:GetBuildState(willParam.buildId)
      if state == BuildState.BUILD_LIST_RECEIVED or state == BuildState.BUILD_LIST_STATE_OK then
        if willParam.point == nil then
          willParam.point = BuildingUtils.GetPointByBuildCanPut(willParam.buildId, SceneUtils.WorldToTileIndex(CS.SceneManager.World.CurTarget))
        end
        local uuid = willParam.uuid
        local buildId = willParam.buildId
        local point = willParam.point
        GoToUtil.CloseAllWindows()
        if uuid ~= 0 then
          BuildingUtils.ShowPutBuild(buildId, PlaceBuildType.Replace, uuid, point, nil, UIWindowNames.UIBuildList)
        else
          BuildingUtils.ShowPutBuild(buildId, PlaceBuildType.Build, 0, point, nil, UIWindowNames.UIBuildList)
        end
        return
      end
    elseif willParam.enterType == UIBuildQueueEnterType.Upgrade and DataCenter.BuildManager:GetBuildCanUpgrade(willParam.uuid) then
      SFSNetwork.SendMessage(MsgDefines.FreeBuildingUpNew, willParam.messageParam)
      GoToUtil.CloseAllWindows()
      return
    end
  end
  local list = DataCenter.BuildManager:GetCanUpgradeBuildUuidListFilterd()
  if 0 < table.count(list) then
    table.sort(list, function(a, b)
      local buildDataA = DataCenter.BuildManager:GetBuildingDataByUuid(a)
      local buildDataB = DataCenter.BuildManager:GetBuildingDataByUuid(b)
      if buildDataA ~= nil and buildDataB ~= nil then
        local templateA = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildDataA.itemId)
        local templateB = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildDataB.itemId)
        if templateA ~= nil and templateB ~= nil then
          return templateA.order < templateB.order
        end
      end
      return a < b
    end)
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(list[1])
    if buildData ~= nil then
      GoToUtil.GotoCityByBuildId(buildData.itemId, WorldTileBtnType.City_Upgrade)
    else
      GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_MAIN, WorldTileBtnType.City_Upgrade)
    end
  else
    GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_MAIN, WorldTileBtnType.City_Upgrade)
  end
end

local function OnBtnClick(self)
end

local function GetPos(self)
  return self.build_icon.transform.position
end

local function GetBtnPos(self)
  return self.queue_goto_btn.transform.position
end

local function OnQueueSliderClick(self)
  self.view:HideRobotFreeView()
end

local function OnCellBgClick(self)
  self.view:HideRobotFreeView()
end

local function ShowResourceCell(self)
  local resource1 = true
  local resource2 = true
  if self.showList[1] ~= nil then
    local param = self.showList[1]
    self.need_resource1:SetActive(true)
    self.need_icon1:LoadSprite(param.icon)
    self.need_num1:SetText(param.num)
    self.need_num1:SetColor(param.numColor)
  else
    self.need_resource1:SetActive(false)
    resource1 = false
  end
  if self.showList[2] ~= nil then
    self.need_resource2:SetActive(true)
    local param = self.showList[2]
    self.need_resource2:SetActive(true)
    self.need_icon2:LoadSprite(param.icon)
    self.need_num2:SetText(param.num)
    self.need_num2:SetColor(param.numColor)
  else
    self.need_resource2:SetActive(false)
    resource2 = false
  end
  self.costItem:SetActive(resource1 or resource2)
end

local function RefreshResourceCell(self)
  if self.showList[1] ~= nil then
    local param = self.showList[1]
    local own = CommonUtil.GetOwnCountByCommonCostType(param.needType, param.itemId)
    if own >= param.need then
      param.numColor = YesColor
    else
      param.numColor = NoColor
      if param.needType == CommonCostNeedType.Resource then
        self.lackResource = param.itemId
      end
    end
    self.need_num1:SetColor(param.numColor)
  end
  if self.showList[2] ~= nil then
    local param = self.showList[2]
    local own = CommonUtil.GetOwnCountByCommonCostType(param.needType, param.itemId)
    if own >= param.need then
      param.numColor = YesColor
    else
      param.numColor = NoColor
      if self.lackResource == nil and param.needType == CommonCostNeedType.Resource then
        self.lackResource = param.itemId
      end
    end
    self.need_num2:SetColor(param.numColor)
  end
end

local function IsMasteryRobotUnlocked(self)
  if not DataCenter.MasteryManager:HasLearntMastery(self.unlockData.masteryId) then
    return false
  end
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.unlockData.preBuildId)
  if DataCenter.BuildManager:GetHaveBuildNumWithOutFoldUpByBuildId(buildTemplate.id) <= 0 then
    return false
  end
  return true
end

UIBuildListCell.OnCreate = OnCreate
UIBuildListCell.OnDestroy = OnDestroy
UIBuildListCell.OnEnable = OnEnable
UIBuildListCell.OnDisable = OnDisable
UIBuildListCell.ComponentDefine = ComponentDefine
UIBuildListCell.ComponentDestroy = ComponentDestroy
UIBuildListCell.DataDefine = DataDefine
UIBuildListCell.DataDestroy = DataDestroy
UIBuildListCell.ReInit = ReInit
UIBuildListCell.InitData = InitData
UIBuildListCell.OnSelectBtnClick = OnSelectBtnClick
UIBuildListCell.GetTouchPositionY = GetTouchPositionY
UIBuildListCell.OnBeginDrag = OnBeginDrag
UIBuildListCell.OnEndDrag = OnEndDrag
UIBuildListCell.OnDrag = OnDrag
UIBuildListCell.ShowGreen = ShowGreen
UIBuildListCell.OnDragOff = OnDragOff
UIBuildListCell.RefreshResource = RefreshResource
UIBuildListCell.DoEnterAnim = DoEnterAnim
UIBuildListCell.DoEnterAnimDefault = DoEnterAnimDefault
UIBuildListCell.DelayComponentDefine = DelayComponentDefine
UIBuildListCell.RefreshRedDot = RefreshRedDot
UIBuildListCell.UpdateSlider = UpdateSlider
UIBuildListCell.OnGotoBtnClick = OnGotoBtnClick
UIBuildListCell.OnBuildBtnClick = OnBuildBtnClick
UIBuildListCell.OnUnlockBtnClick = OnUnlockBtnClick
UIBuildListCell.OnBtnClick = OnBtnClick
UIBuildListCell.GetPos = GetPos
UIBuildListCell.GetBtnPos = GetBtnPos
UIBuildListCell.OnQueueSliderClick = OnQueueSliderClick
UIBuildListCell.OnCellBgClick = OnCellBgClick
UIBuildListCell.RefreshResourceCell = RefreshResourceCell
UIBuildListCell.ShowResourceCell = ShowResourceCell
UIBuildListCell.GetLackByType = GetLackByType
UIBuildListCell.IsMasteryRobotUnlocked = IsMasteryRobotUnlocked
return UIBuildListCell
