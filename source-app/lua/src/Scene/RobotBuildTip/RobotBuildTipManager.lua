local RobotBuildTipManager = BaseClass("RobotBuildTipManager", Singleton)
local RobotBuildTip = require("Scene.RobotBuildTip.RobotBuildTip")
local ResourceManager = CS.GameEntry.Resource

local function __init(self)
  self.allBuildRobot = {}
  self.tempInstance = {}
  self:AddListener()
end

local function __delete(self)
  self.allBuildRobot = nil
  self.tempInstance = nil
  self:RemoveListener()
end

local function AddListener(self)
end

local function RemoveListener(self)
end

local function ShowBuildRobotTip(self, uuid)
  local robotData = DataCenter.BuildQueueManager:GetQueueByUuid(uuid)
  if robotData ~= nil and robotData.occupyUuid ~= nil and robotData.occupyUuid ~= 0 and robotData.skills ~= nil and robotData.state ~= RobotState.FREE then
    local skillLine
    local level = 0
    for i = 1, #robotData.skills do
      if skillLine == nil then
        local skillId = robotData.skills[i].skillId
        level = robotData.skills[i].level
        local tempLine = LocalController:instance():getLine(TableName.SkillTab, skillId)
        if tempLine ~= nil then
          local type2 = tempLine:getValue("type2")
          if type2 ~= nil then
            if robotData.state == RobotState.BUILD then
              if tonumber(type2) == RobotSkillType.BUILD then
                skillLine = tempLine
              end
            elseif robotData.state == RobotState.SCIENCE then
              if tonumber(type2) == RobotSkillType.SCIENCE then
                skillLine = tempLine
              end
            elseif robotData.state == RobotState.FACTORY then
              if tonumber(type2) == RobotSkillType.FACTORY then
                skillLine = tempLine
              end
            elseif (robotData.state == RobotState.PASTURE or robotData.state == RobotState.FARM) and tonumber(type2) == RobotSkillType.FARM then
              skillLine = tempLine
            end
          end
        end
      end
    end
    if skillLine ~= nil then
      local skillDes = skillLine:getValue("des")
      local effect_des = skillLine:getValue("effect_des")
      local array1 = string.split(effect_des, "|")
      local effectNumList = {}
      for k, v in ipairs(array1) do
        local array2 = string.split(v, ";")
        table.insert(effectNumList, array2)
      end
      local curLvEffect = effectNumList[math.max(level, 1)]
      if curLvEffect ~= nil and 0 < #curLvEffect then
        local num = curLvEffect[1]
        if num ~= nil and num ~= "" and num ~= "0" then
          local templateIcon = GetTableData(TableName.Robot, robotData.robotId, "sculpture1")
          local icon = string.format(LoadPath.UIBuildBtns, templateIcon)
          local bUuid = tonumber(robotData.occupyUuid)
          local info = CS.SceneManager.World:GetPointInfoByUuid(bUuid)
          if info ~= nil then
            cast(info, typeof(CS.BuildPointInfo))
            if info ~= nil then
              local pointId = info.mainIndex
              local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(info.itemId)
              if buildTemplate ~= nil then
                local des = CS.GameEntry.Localization:GetString(skillDes)
                if buildTemplate.id == BuildingTypes.APS_BUILD_FARM then
                  local desStr = GetTableData(TableName.EffectNumDesc, EffectDefine.ADD_FARM_SPEED, "des")
                  if desStr ~= nil then
                    des = CS.GameEntry.Localization:GetString(desStr)
                  end
                elseif buildTemplate.id == BuildingTypes.APS_BUILD_PASTURE_OSTRICH or buildTemplate.id == BuildingTypes.APS_BUILD_PASTURE_CATTLE or buildTemplate.id == BuildingTypes.APS_BUILD_PASTURE_SANDWORM then
                  local desStr = GetTableData(TableName.EffectNumDesc, EffectDefine.ADD_PASTURE_SPEED, "des")
                  if desStr ~= nil then
                    des = CS.GameEntry.Localization:GetString(desStr)
                  end
                end
                self:ShowOneEffect(bUuid, pointId, icon, des, num, buildTemplate.tileX, buildTemplate.tileY)
              end
            end
          end
        end
      end
    end
  end
end

local function ShowOneEffect(self, bUuid, pointId, icon, nameStr, numStr, tileX, tileY)
  if self.allBuildRobot[bUuid] == nil and self.tempInstance[bUuid] == nil then
    local request = ResourceManager:InstantiateAsync(UIAssets.SceneRobotBuildTip)
    self.tempInstance[bUuid] = request
    request:completed("+", function()
      self.tempInstance[bUuid] = nil
      if request.isError then
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:SetParent(CS.SceneManager.World.BuildBubbleNode)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      DataCenter.BuildBubbleManager:SetShowBuildBubble(bUuid, false)
      local RobotBuildTip = RobotBuildTip.New()
      RobotBuildTip:OnCreate(request)
      local param = {}
      param.pointId = pointId
      param.nameStr = nameStr
      param.numStr = numStr
      param.icon = icon
      param.bUuid = bUuid
      param.tileX = tileX
      param.tileY = tileY
      param.request = request
      RobotBuildTip:StartShowTip(param)
      self.allBuildRobot[bUuid] = RobotBuildTip
    end)
  elseif self.allBuildRobot[bUuid] ~= nil then
    self.allBuildRobot[bUuid]:RefreshShow(icon, nameStr, numStr)
  end
end

local function RemoveOneEffect(self, bUuid)
  DataCenter.BuildBubbleManager:SetShowBuildBubble(bUuid, true)
  if self.allBuildRobot[bUuid] ~= nil then
    local request = self.allBuildRobot[bUuid].request
    self.allBuildRobot[bUuid]:OnDestroy()
    if request ~= nil then
      request:Destroy()
    end
  end
  self.allBuildRobot[bUuid] = nil
end

RobotBuildTipManager.__init = __init
RobotBuildTipManager.__delete = __delete
RobotBuildTipManager.RemoveOneEffect = RemoveOneEffect
RobotBuildTipManager.ShowBuildRobotTip = ShowBuildRobotTip
RobotBuildTipManager.ShowOneEffect = ShowOneEffect
RobotBuildTipManager.AddListener = AddListener
RobotBuildTipManager.RemoveListener = RemoveListener
return RobotBuildTipManager
