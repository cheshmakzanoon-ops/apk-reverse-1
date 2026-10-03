local GuideNpcUnit = require("DataCenter.LWGuideManager.GuideModel.GuideNpcUnit")
local GuideWorker = BaseClass("GuideWorker", GuideNpcUnit)
local trigger_path = "TipRoot/Trigger"
local questionIcon = "TipRoot/Icon/questionIcon"
local p_entryPath = "ModelGo/point/p_entry"
local Resource = CS.GameEntry.Resource

function GuideWorker:OnCreate()
  self.tipRoot = self.transform:Find("TipRoot")
  self.questionIcon = self.transform:Find(questionIcon)
  self.trigger = self.transform:Find(trigger_path):GetComponent(typeof(CS.TouchObjectEventTrigger))
  
  function self.trigger.onPointerClick()
    self:OnTriggerClick()
  end
  
  self.cancel_icon = self.questionIcon:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
end

function GuideWorker:OnTriggerClick()
  self.data.path = self.data.worker.appearCfg.city_model_path
  self.data.birthPos = Vector3.New(self.transform.position.x, self.transform.position.y, self.transform.position.z)
  self:ClearModel()
  self:CreateModel(function()
    self.effect = self.transform:Find("VFX_animal_grow"):GetComponent(typeof(CS.UnityEngine.ParticleSystem))
    self.isFinish = true
    local cityObj = CS.SceneManager.World:GetBuildingByPoint(self.data.buildData.pointId)
    local p_entry = cityObj.gameObject.transform:Find(p_entryPath)
    local pathList = DataCenter.InnerCityMapManager:FindPath(self.transform.position, p_entry.transform.position)
    self:SetTargetEndPos(pathList)
    self.delay = TimerManager:GetInstance():DelayInvoke(function()
      self.tipRoot.gameObject:SetActive(false)
    end, 1)
    if self.effect then
      self.effect.gameObject:SetActive(true)
      self.effect:Play()
    end
  end)
end

function GuideWorker:OnArrivalTerminal()
  self.tipRoot.gameObject:SetActive(true)
  self.questionIcon.gameObject:SetActive(true)
  self.cancel_icon:LoadSprite("Assets/Main/Sprites/UI/UITask/UI_building_10201000.png")
  self.localPos = self.cancel_icon.gameObject.transform.localPosition
  self.localScale = self.cancel_icon.gameObject.transform.localScale
  self.cancel_icon.gameObject.transform:Set_localPosition(0, 0.12, -0.03)
  self.cancel_icon.gameObject.transform:Set_localScale(0.15, 0.15, 0.15)
end

function GuideWorker:OnFinish()
  self.cancel_icon.gameObject.transform:Set_localPosition(self.localPos.x, self.localPos.y, self.localPos.z)
  self.cancel_icon.gameObject.transform:Set_localScale(self.localScale.x, self.localScale.y, self.localScale.z)
  self.questionIcon.gameObject:SetActive(false)
  self.tipRoot.gameObject:SetActive(false)
  self.localScale = nil
  self.localPos = nil
  self.questionIcon = nil
  self.tipRoot = nil
  self.trigger = nil
  self:Delete()
end

function GuideWorker:OnDelete()
  if self.effect then
    self.effect.gameObject:SetActive(false)
    self.effect = nil
  end
end

function GuideWorker:ClearModel()
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.update = nil
  end
  if self.req then
    self.req:Destroy()
  end
  self.isArrival = nil
  self.simpleAnim = nil
  self.tipRoot = nil
  self.transform = nil
  self.gameObject = nil
end

return GuideWorker
