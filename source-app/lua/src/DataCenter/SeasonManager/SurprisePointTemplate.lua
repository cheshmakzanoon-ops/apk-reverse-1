local SurprisePointTemplate = BaseClass("SurprisePointTemplate")

function SurprisePointTemplate:__init(info)
  self.id = info.id
  self.group = info.group
  self.reward_condition = info.reward_condition
  self.effects = info.effects
  self.effects_condition = info.effects_condition
  self.plot = info.plot
  self.reward_tips = info.reward_tips
  self.size = info.size
  self.notopen_plot = info.notopen_plot
  self.positional_offset = info.positional_offset
  self.unlocked_prompt = info.unlocked_prompt
  self.prompt = info.prompt
  self.opening_time = info.opening_time
end

function SurprisePointTemplate:__delete()
  self.id = nil
  self.group = nil
  self.reward_condition = nil
  self.effects = nil
  self.effects_condition = nil
  self.plot = nil
  self.reward_tips = nil
end

return SurprisePointTemplate
