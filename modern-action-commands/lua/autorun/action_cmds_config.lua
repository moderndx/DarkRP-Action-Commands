modern_action_commands_config = {}
modern_action_commands_config.color_command = true -- Colors the command in the output (example: command raid || modern has started a raid - raid would be colored
modern_action_commands_config.hide_message = true -- Hides the chat message they sent
-- supported tags
--[[
{player_name} = players name
{time_cur} = current time
]]--
modern_action_commands_config.commands_output = {
  {command = "raid", output = "{player_name} has started a raid", timeout_amount = 120, color = Color(200, 25, 25)},
  {command = "mug", output = "{player_name} has started a mug", timeout_amount = 120, color = Color(25, 25, 200)},
  {command = "over", output = "{player_name}'s action is over", timeout_amount = 0, color = Color(25, 25, 200)},
}
