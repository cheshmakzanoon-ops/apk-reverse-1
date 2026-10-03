local base = UIAsyncContainer
local UIWorldS0AllianceBuildDesc = BaseClass("UIWorldS0AllianceBuildDesc", base)
local Localization = CS.GameEntry.Localization
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")

function UIWorldS0AllianceBuildDesc:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function UIWorldS0AllianceBuildDesc:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWorldS0AllianceBuildDesc:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnDetail = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnDetail:SetOnClick(function()
    self:OnBtnDetailClick()
  end)
  self.textBossName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textReward = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.scrollView = self.viewSkin:AddComponent(self, UIScrollView, 4)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.btnShare = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnShare:SetOnClick(function()
    self:OnBtnShareClick()
  end)
  self.btnMark = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnMark:SetOnClick(function()
    self:OnBtnMarkClick()
  end)
  self.rawImgBanner = self.viewSkin:AddComponent(self, UIRawImage, 8)
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
end

function UIWorldS0AllianceBuildDesc:ComponentDestroy()
  self:ClearScroll()
  self.viewSkin = nil
  self.btnDetail = nil
  self.textBossName = nil
  self.textReward = nil
  self.scrollView = nil
  self.textTime = nil
  self.btnShare = nil
  self.btnMark = nil
  self.rawImgBanner = nil
end

function UIWorldS0AllianceBuildDesc:OnEnable()
  base.OnEnable(self)
  self:AddTimer()
end

function UIWorldS0AllianceBuildDesc:OnDisable()
  base.OnDisable(self)
  self:RemoveTimer()
end

function UIWorldS0AllianceBuildDesc:DataDefine()
  self.tipParam = nil
end

function UIWorldS0AllianceBuildDesc:DataDestroy()
  self.tipParam = nil
end

function UIWorldS0AllianceBuildDesc:OnAddListener()
  base.OnAddListener(self)
end

function UIWorldS0AllianceBuildDesc:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIWorldS0AllianceBuildDesc:InitView()
  self.textBossName:SetLocalText("s0_alliance_boss_build_name")
  self.textReward:SetLocalText("s0_alliance_boss_current_reward_info")
end

function UIWorldS0AllianceBuildDesc:RemoveTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIWorldS0AllianceBuildDesc:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, BindCallback(self, self.RefreshTime), self, false, false, false)
  end
  self.timer:Start()
end

function UIWorldS0AllianceBuildDesc:RefreshTime()
  if self.startTime and self.startTime > 0 then
    local curTs = UITimeManager:GetInstance():GetServerTime()
    local remain = self.startTime - curTs
    if 0 < remain then
      self.textTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remain))
    else
      self.textTime:SetText("")
    end
  end
end

function UIWorldS0AllianceBuildDesc:RefreshData(data)
  if data then
    local info = CS.SceneManager.World:GetPointInfoByUuid(data.uuid)
    if info and info.buildPointInfo then
      local buildPointInfo = info.buildPointInfo
      if buildPointInfo then
        self.startTime = buildPointInfo.startTime or 0
        if self.startTime <= 0 then
          self.textTime:SetText("")
        end
        if buildPointInfo.cfgId and 0 < buildPointInfo.cfgId then
          local bossTemp = DataCenter.AllianceBossS0TemplateManager:GetTemplate(buildPointInfo.cfgId)
          if bossTemp then
            self.rawImgBanner:LoadSpriteAuto(bossTemp.monster_banner)
            local allianceReward = bossTemp.allianceReward
            if allianceReward then
              local result = {}
              local reward = allianceReward[1]
              local rewardList = DataCenter.RewardTemplateManager:GetList(reward)
              if rewardList then
                for _, v in ipairs(rewardList) do
                  result[#result + 1] = v
                end
              end
              self:RefreshReward(result)
            end
          end
        end
      end
    end
    local name = Localization:GetString(data.name)
    self.textBossName:SetText("Lv." .. data.level .. " " .. name)
  end
end

function UIWorldS0AllianceBuildDesc:OnRewardItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(UICommonResItem, itemObj)
  if cellItem ~= nil then
    local reward = self.rewardList[index]
    if reward then
      cellItem:ParseInfo(reward)
    end
  end
end

function UIWorldS0AllianceBuildDesc:OnRewardItemMoveOut(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, UICommonResItem)
end

function UIWorldS0AllianceBuildDesc:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UICommonResItem)
end

function UIWorldS0AllianceBuildDesc:RefreshReward(rewardList)
  if not table.IsNullOrEmpty(rewardList) then
    self.rewardList = rewardList
    self:ClearScroll()
    self.scrollView:SetTotalCount(#rewardList)
    self.scrollView:RefillCells()
  end
end

function UIWorldS0AllianceBuildDesc:OnBtnDetailClick()
  local context = Localization:GetString("s0_alliance_boss_alliance_reward_tip")
  if self.scaleFactor == nil then
    self.scaleFactor = UIManager:GetInstance():GetScaleFactor()
  end
  local position = self.btnDetail.transform.position + Vector3.New(0, 25, 0) * self.scaleFactor
  if self.tipParam == nil then
    self.tipParam = UIHeroTipView.Param.New()
  end
  self.tipParam.content = context
  self.tipParam.dir = UIHeroTipView.Direction.ABOVE
  self.tipParam.defWidth = 200
  self.tipParam.pivot = 0.5
  self.tipParam.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, self.tipParam)
end

function UIWorldS0AllianceBuildDesc:OnBtnShareClick()
  self.view:OnShareClick()
end

function UIWorldS0AllianceBuildDesc:OnBtnMarkClick()
  self.view:OnMarkClick()
end

return UIWorldS0AllianceBuildDesc
